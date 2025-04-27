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
    const { model = 'deepseek-coder', code_content, temperature = 0.7 } = req.body;
    
    // 参数验证
    if (!['deepseek-coder', 'deepseek-chat', 'deepseek-reasoner'].includes(model)) {
      return res.status(400).json({ code: 400, message: '无效的model参数' });
    }
    
    if (!code_content) {
      return res.status(400).json({ code: 400, message: 'code_content参数不能为空' });
    }
    
    // 调用服务
    const result = await deepseekService.analyzeCode(code_content, model, temperature);
    return res.status(200).json({ code: 200, data: result });
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
async function balanceQuery(req, res) {
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
    return res.status(200).json(successResponse(models));
  } catch (error) {
    console.error('模型查询失败:', error);
    return res.status(200).json(errorResponse(500, error.message));
  }
}

module.exports = {
  codeAnalysis,
  balanceQuery,
  getModels
}; 