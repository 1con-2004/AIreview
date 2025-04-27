const deepseekService = require('../services/ai/deepseek.service');
const { successResponse, errorResponse } = require('../utils/response');

/**
 * AI代码分析接口
 * @param {Object} req 请求对象
 * @param {Object} res 响应对象
 * @returns {Promise<void>}
 */
async function codeAnalysis(req, res) {
  try {
    const { model = 'deepseek-chat', code_content, temperature = 0.7 } = req.body;
    
    // 参数验证
    if (!['deepseek-chat', 'deepseek-reasoner'].includes(model)) {
      return res.status(400).json({ code: 400, message: '无效的model参数' });
    }
    
    if (!code_content) {
      return res.status(400).json({ code: 400, message: 'code_content参数不能为空' });
    }
    
    // 提供额外信息
    console.log(`处理代码分析请求，使用模型: ${model}, 代码长度: ${code_content.length}字符`);
    
    // 调用服务
    const result = await deepseekService.analyzeCode(code_content, model, temperature);
    
    // 处理响应，保持向后兼容性
    const response = {
      code: 200,
      data: {
        model: result.model,
        content: result.content,
        usage: result.usage
      }
    };
    
    // 如果是推理模型且有推理内容，则添加推理内容
    if (result.model.includes('reasoner') && result.reasoning_content) {
      response.data.reasoning_content = result.reasoning_content;
    }
    
    // 添加延迟推理信息
    if (result.usage && result.usage.completion_tokens_details && result.usage.completion_tokens_details.reasoning_tokens) {
      if (!response.data.reasoning_content) {
        response.data.reasoning_content = '该模型未提供单独的推理内容，但使用了推理过程。';
      }
      response.data.reasoning_tokens = result.usage.completion_tokens_details.reasoning_tokens;
    }
    
    return res.status(200).json(response);
  } catch (error) {
    console.error('代码分析失败:', error);
    return res.status(500).json({ code: 500, message: error.message });
  }
}

/**
 * 余额查询接口
 * @param {Object} req 请求对象
 * @param {Object} res 响应对象
 * @returns {Promise<void>}
 */
async function getBalance(req, res) {
  try {
    const balanceInfo = await deepseekService.queryBalance();
    return res.status(200).json(successResponse(balanceInfo));
  } catch (error) {
    console.error('余额查询失败:', error);
    return res.status(200).json(errorResponse(500, error.message));
  }
}

/**
 * 查询可用模型接口
 * @param {Object} req 请求对象
 * @param {Object} res 响应对象
 * @returns {Promise<void>}
 */
async function getModels(req, res) {
  try {
    const models = await deepseekService.getAvailableModels();
    
    // 添加模型描述信息
    const modelsWithDetails = models.map(model => {
      // 添加基础信息
      const modelWithDetails = { ...model };
      
      // 为不同模型添加说明
      if (model.id === 'deepseek-chat') {
        modelWithDetails.description = 'DeepSeek-V3 通用对话模型';
        modelWithDetails.capabilities = ['代码分析', '文本生成', '多轮对话'];
      } else if (model.id === 'deepseek-reasoner') {
        modelWithDetails.description = 'DeepSeek-R1 强化推理模型';
        modelWithDetails.capabilities = ['复杂推理', '代码分析', '详细思考过程'];
      }
      
      return modelWithDetails;
    });
    
    return res.status(200).json(successResponse(modelsWithDetails));
  } catch (error) {
    console.error('模型查询失败:', error);
    return res.status(200).json(errorResponse(500, error.message));
  }
}

module.exports = {
  codeAnalysis,
  getBalance,
  getModels
}; 