const axios = require('axios');
const config = require('../../config');
const https = require('https');

// DeepSeek API基础配置
const DEEPSEEK_API_URL = config.DEEPSEEK_API_URL || 'https://api.deepseek.com/chat/completions';
const DEEPSEEK_BALANCE_URL = config.DEEPSEEK_BALANCE_URL || 'https://api.deepseek.com/user/balance';
const DEEPSEEK_MODELS_URL = config.DEEPSEEK_MODELS_URL || 'https://api.deepseek.com/models';
const API_KEY = config.DEEPSEEK_API_KEY;

// 创建自定义HTTPS代理
const httpsAgent = new https.Agent({
  rejectUnauthorized: false, // 忽略SSL错误，仅在开发环境使用
  keepAlive: true,
  timeout: 120000
});

// 创建axios实例 - 修改配置
const deepseekClient = axios.create({
  headers: {
    'Authorization': `Bearer ${API_KEY}`,
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  },
  timeout: 120000, // 增加到60秒
  // 强制禁用代理
  proxy: false,
  httpsAgent: httpsAgent,
  // 增加重试配置
  maxRetries: 3,
  retryDelay: 1000
});

// 代码分析服务
async function analyzeCode(codeContent, modelType = 'deepseek-chat', temperature = 0.7) {
  try {
    // 验证模型类型
    const validModels = ['deepseek-chat', 'deepseek-reasoner'];
    if (!validModels.includes(modelType)) {
      throw new Error('不支持的模型类型');
    }
    
    // 直接使用API支持的模型ID
    const model = modelType;
    console.log('使用模型:', model);
    
    // 精简代码内容，避免过长
    const trimmedCode = codeContent.length > 2000 
      ? codeContent.substring(0, 2000) + '...(代码已截断)' 
      : codeContent;
    
    const requestBody = {
      model,
      messages: [
        { role: 'system', content: '你是一个专业的代码审查专家，擅长分析代码质量、发现潜在问题并提供改进建议。' },
        { role: 'user', content: `请分析以下代码并提供详细评审意见：\n\`\`\`\n${trimmedCode}\n\`\`\`` }
      ],
      max_tokens: 2000, // 减少token数量
      stream: false // 明确指定非流式响应
    };
    
    // 对于非reasoner模型，设置temperature
    if (modelType !== 'deepseek-reasoner') {
      requestBody.temperature = parseFloat(temperature);
    }
    
    // DeepSeek-reasoner模型特有参数，根据最新API文档
    if (modelType === 'deepseek-reasoner') {
      requestBody.temperature = 0.0; // reasoner模型通常使用较低temperature
    }
    
    console.log('发送请求到:', DEEPSEEK_API_URL);
    console.log('请求体大小约:', JSON.stringify(requestBody).length, '字节');
    
    // 分批次尝试发送请求，首先尝试直接API调用
    try {
      console.log('尝试直接API调用...');
      const response = await deepseekClient.post(DEEPSEEK_API_URL, requestBody);
      
      console.log('API响应状态码:', response.status);
      console.log('API响应大小约:', JSON.stringify(response.data).length, '字节');
      
      // 处理不同模型的返回结果
      if (modelType === 'deepseek-reasoner') {
        // 根据实际响应格式调整
        console.log('DeepSeek Reasoner API响应结构:', JSON.stringify(response.data.choices[0], null, 2));
        
        // 检查并提取reasoning字段（如果存在）
        let reasoningContent = '无推理过程';
        // 根据API文档，正确的字段是message.reasoning_content
        if (response.data.choices[0].message.reasoning_content) {
          reasoningContent = response.data.choices[0].message.reasoning_content;
          console.log('从message.reasoning_content获取思考过程');
        } else if (response.data.choices[0].message.reasoning) {
          reasoningContent = response.data.choices[0].message.reasoning;
          console.log('从message.reasoning获取思考过程');
        } else if (response.data.choices[0].reasoning) {
          reasoningContent = response.data.choices[0].reasoning;
          console.log('从reasoning获取思考过程');
        } else if (response.data.choices[0].reasoning_steps) {
          reasoningContent = response.data.choices[0].reasoning_steps;
          console.log('从reasoning_steps获取思考过程');
        }
        
        return {
          model: modelType,
          content: response.data.choices[0].message.content,
          reasoning_content: reasoningContent,
          usage: response.data.usage
        };
      } else {
        return {
          model: modelType,
          content: response.data.choices[0].message.content,
          usage: response.data.usage
        };
      }
    } catch (error) {
      console.error('直接API调用失败，尝试使用普通模型作为备选...');
      // 如果是reasoner模型失败，尝试使用普通模型作为备选
      if (modelType === 'deepseek-reasoner') {
        console.log('使用deepseek-chat模型作为备选...');
        requestBody.model = 'deepseek-chat';
        requestBody.temperature = parseFloat(temperature);
        
        const fallbackResponse = await deepseekClient.post(DEEPSEEK_API_URL, requestBody);
        
        return {
          model: 'deepseek-chat (fallback)',
          content: fallbackResponse.data.choices[0].message.content,
          reasoning_content: '由于原模型调用失败，此结果由deepseek-chat模型生成',
          usage: fallbackResponse.data.usage
        };
      } else {
        throw error; // 如果不是reasoner模型，则继续抛出错误
      }
    }
  } catch (error) {
    console.error('DeepSeek API调用失败:');
    if (error.response) {
      console.error('状态码:', error.response.status);
      console.error('响应数据:', JSON.stringify(error.response.data, null, 2));
    } else if (error.request) {
      console.error('请求未收到响应，可能是网络或代理问题');
      console.error('请尝试禁用代理或VPN后重试');
    } else {
      console.error('错误信息:', error.message);
    }
    throw new Error(error.response?.data?.error?.message || 'AI代码分析失败，请检查网络连接和API配置');
  }
}

// 查询余额服务
async function queryBalance() {
  try {
    console.log('正在查询DeepSeek余额，URL:', DEEPSEEK_BALANCE_URL);
    
    const response = await deepseekClient.get(DEEPSEEK_BALANCE_URL);
    console.log('余额查询响应:', response.data);
    
    // 处理新的响应格式
    if (response.data.is_available && response.data.balance_infos && response.data.balance_infos.length > 0) {
      const balanceInfo = response.data.balance_infos[0];
      return {
        is_available: response.data.is_available,
        currency: balanceInfo.currency,
        total_balance: balanceInfo.total_balance,
        granted_balance: balanceInfo.granted_balance,
        topped_up_balance: balanceInfo.topped_up_balance
      };
    } else {
      throw new Error('余额信息格式异常');
    }
  } catch (error) {
    console.error('余额查询失败:', error.response?.data || error.message);
    throw new Error(error.response?.data?.message || '余额查询失败');
  }
}

// 查询支持的模型
async function getAvailableModels() {
  try {
    console.log('正在查询DeepSeek可用模型，URL:', DEEPSEEK_MODELS_URL);
    
    const response = await deepseekClient.get(DEEPSEEK_MODELS_URL);
    console.log('模型查询响应:', response.data);
    
    if (response.data.data && Array.isArray(response.data.data)) {
      return response.data.data.map(model => ({
        id: model.id,
        object: model.object,
        owned_by: model.owned_by
      }));
    } else {
      throw new Error('模型信息格式异常');
    }
  } catch (error) {
    console.error('模型查询失败:', error.response?.data || error.message);
    throw new Error(error.response?.data?.message || '模型查询失败');
  }
}

module.exports = {
  analyzeCode,
  queryBalance,
  getAvailableModels
}; 