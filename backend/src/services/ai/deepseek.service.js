const axios = require('axios');
const config = require('../../config');

// DeepSeek API基础配置
const DEEPSEEK_API_URL = config.DEEPSEEK_API_URL || 'https://api.deepseek.com/v1/chat/completions';
const DEEPSEEK_BALANCE_URL = config.DEEPSEEK_BALANCE_URL || 'https://api.deepseek.com/user/balance';
const DEEPSEEK_MODELS_URL = config.DEEPSEEK_MODELS_URL || 'https://api.deepseek.com/models';
const API_KEY = config.DEEPSEEK_API_KEY;

// 创建axios实例
const deepseekClient = axios.create({
  headers: {
    'Authorization': `Bearer ${API_KEY}`,
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  },
  timeout: 30000 // 设置30秒超时
});

// 代码分析服务
async function analyzeCode(codeContent, modelType = 'deepseek-coder', temperature = 0.7) {
  try {
    // 当前支持的模型映射
    const modelMap = {
      'deepseek-coder': 'deepseek-chat',
      'deepseek-chat': 'deepseek-chat',
      'deepseek-reasoner': 'deepseek-reasoner'
    };
    
    const actualModel = modelMap[modelType] || modelMap['deepseek-coder'];
    
    const requestBody = {
      model: actualModel,
      messages: [
        { role: 'system', content: '你是一个专业的代码审查专家，擅长分析代码质量、发现潜在问题并提供改进建议。' },
        { role: 'user', content: `请分析以下代码并提供详细评审意见：\n\`\`\`\n${codeContent}\n\`\`\`` }
      ],
      max_tokens: 4000
    };
    
    // 对于非reasoner模型，可以继续使用temperature参数
    if (modelType !== 'deepseek-reasoner') {
      requestBody.temperature = parseFloat(temperature);
    }
    
    const response = await deepseekClient.post(DEEPSEEK_API_URL, requestBody);
    
    // 处理不同模型的返回结果
    if (modelType === 'deepseek-reasoner') {
      return {
        model: modelType,
        content: response.data.choices[0].message.content,
        reasoning_content: response.data.choices[0].message.reasoning_content, // 直接使用API返回的思考过程
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
    console.error('DeepSeek API调用失败:', error.response?.data || error.message);
    throw new Error(error.response?.data?.error?.message || 'AI代码分析失败');
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