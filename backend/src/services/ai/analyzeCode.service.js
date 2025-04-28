const ZhipuAI = require('../../utils/zhipuAI');
const axios = require('axios');
const config = require('../../config');

/**
 * 代码分析服务
 * 支持多种AI模型的代码分析
 */
class AnalyzeCodeService {
  /**
   * 使用智谱AI进行代码分析
   * @param {Object} params 分析参数
   * @returns {Promise<string>} 分析结果
   */
  async analyzeWithGLM4(params) {
    const { code, language, problemTitle, problemDescription } = params;
    
    const messages = [
      {
        role: "system",
        content: `你是一个亲切的编程导师，请用以下格式分析代码：

代码分析：
1. 错误代码片段
- 有问题的代码：\`代码片段\`
- 错误原因：用简单易懂的话解释问题

2. 逻辑问题
- 用朋友般的语气指出问题所在
- 举例说明正确的思路

请用以下风格：
• 使用中文口语化表达，如"咱们"、"这里"等
• 适当使用emoji增加亲切感 👍✨
• 代码块使用 \`\`\`语言 的格式包裹
• 每点分析后空一行方便阅读
注意，你不需要写出改进后的代码`
      },
      {
        role: "user",
        content: `题目：${problemTitle}
题目描述：${problemDescription}

用户代码：
\`\`\`${language}
${code}
\`\`\`

请分析这段代码的问题并给出改进建议。`
      }
    ];

    const zhipuAI = new ZhipuAI();
    const aiResponse = await zhipuAI.chat(messages);
    
    return aiResponse;
  }

  /**
   * 使用DeepSeek Chat进行代码分析
   * @param {Object} params 分析参数
   * @returns {Promise<string>} 分析结果
   */
  async analyzeWithDeepSeekChat(params) {
    const { code, language, problemTitle, problemDescription } = params;
    
    try {
      const API_KEY = config.DEEPSEEK_API_KEY;
      const API_URL = config.DEEPSEEK_API_URL;
      
      const messages = [
        {
          role: "system",
          content: `你是一个编程代码分析专家，请用以下格式分析代码：

# 代码分析报告

## 主要问题
- 详细列出代码中的主要问题
- 使用markdown格式让分析更加清晰

## 改进建议
- 提供具体的改进方法
- 解释每个改进建议的原因

使用要求：
• 使用中文分析
• 适当使用emoji增加可读性 ✅❌⚠️
• 代码片段使用markdown代码块格式
• 使用适当的标题层级和列表让内容有条理`
        },
        {
          role: "user",
          content: `题目：${problemTitle}
题目描述：${problemDescription}

用户代码：
\`\`\`${language}
${code}
\`\`\`

请详细分析这段代码的优缺点，并提供改进建议。`
        }
      ];
      
      // 调用DeepSeek API
      const response = await axios({
        method: 'post',
        url: API_URL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': `Bearer ${API_KEY}`
        },
        data: {
          model: 'deepseek-chat',
          messages: messages,
          temperature: 0.7,
          max_tokens: 2000,
          stream: false
        }
      });
      
      return response.data.choices[0].message.content;
    } catch (error) {
      console.error('DeepSeek Chat分析失败:', error);
      throw error;
    }
  }

  /**
   * 使用DeepSeek Reasoner进行代码分析
   * @param {Object} params 分析参数
   * @returns {Promise<Object>} 包含思考过程和分析结果的对象
   */
  async analyzeWithDeepSeekReasoner(params) {
    const { code, language, problemTitle, problemDescription } = params;
    
    try {
      const API_KEY = config.DEEPSEEK_API_KEY;
      const API_URL = config.DEEPSEEK_API_URL;
      
      const messages = [
        {
          role: "system",
          content: `你是一个编程专家，请先详细思考代码的问题，然后提供分析报告。

思考过程中:
1. 确认代码的整体逻辑和功能
2. 分析代码可能存在的错误和效率问题
3. 考虑改进方案的可行性

最终分析报告中:
- 使用markdown格式
- 使用适当的标题和列表
- 代码示例使用代码块格式
- 具体明确地指出问题和解决方案`
        },
        {
          role: "user",
          content: `题目：${problemTitle}
题目描述：${problemDescription}

用户代码：
\`\`\`${language}
${code}
\`\`\`

请分析这段代码。首先进行详细的思考过程，然后给出最终的分析报告。`
        }
      ];
      
      // 调用DeepSeek API
      const response = await axios({
        method: 'post',
        url: API_URL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': `Bearer ${API_KEY}`
        },
        data: {
          model: 'deepseek-reasoner',
          messages: messages,
          temperature: 0.2,
          max_tokens: 2500,
          stream: false,
          reasoning: true  // 启用推理功能
        }
      });
      
      console.log('DeepSeek Reasoner API 响应:', JSON.stringify(response.data.choices[0], null, 2));
      
      const reasoningResponse = response.data.choices[0]; 
      
      // 分离思考过程和最终分析
      // 根据DeepSeek API文档，正确的字段是message.reasoning_content
      let reasoning = '';
      const analysis = reasoningResponse.message?.content || '';
      
      // 根据API文档，思维链内容应该在message.reasoning_content字段
      if (reasoningResponse.message?.reasoning_content) {
        reasoning = reasoningResponse.message.reasoning_content;
        console.log('从message.reasoning_content获取思考过程');
      } else if (reasoningResponse.reasoning) {
        reasoning = reasoningResponse.reasoning;
        console.log('从reasoning字段获取思考过程(旧版兼容)');
      } else if (reasoningResponse.reasoning_steps) {
        reasoning = reasoningResponse.reasoning_steps;
        console.log('从reasoning_steps字段获取思考过程(旧版兼容)');
      } else {
        console.log('DeepSeek Reasoner API响应中没有找到思考过程，使用空字符串');
      }
      
      return {
        reasoning,
        analysis
      };
    } catch (error) {
      console.error('DeepSeek Reasoner分析失败:', error);
      throw error;
    }
  }

  /**
   * 根据选择的模型进行代码分析
   * @param {Object} params 分析参数
   * @param {string} model 模型名称
   * @returns {Promise<Object|string>} 分析结果
   */
  async analyzeCode(params, model = 'glm-4-flash') {
    const requestId = `ai-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 开始代码分析 - 模型: ${model}`);
    
    try {
      // 根据模型选择调用不同的API
      let result;
      
      switch (model) {
        case 'glm-4-flash':
          console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 使用智谱AI进行分析`);
          result = await this.analyzeWithGLM4(params);
          break;
        
        case 'deepseek-chat':
          console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 使用DeepSeek Chat进行分析`);
          result = await this.analyzeWithDeepSeekChat(params);
          break;
        
        case 'deepseek-reasoner':
          console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 使用DeepSeek Reasoner进行分析`);
          result = await this.analyzeWithDeepSeekReasoner(params);
          break;
        
        default:
          console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 未知模型, 默认使用智谱AI`);
          result = await this.analyzeWithGLM4(params);
      }
      
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 代码分析完成`);
      return result;
    } catch (error) {
      console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 代码分析失败:`, error);
      throw error;
    }
  }
}

module.exports = new AnalyzeCodeService(); 