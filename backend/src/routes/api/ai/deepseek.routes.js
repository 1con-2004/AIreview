const express = require('express');
const router = express.Router();
const aiController = require('../../../controllers/ai-analysis.controller');

/**
 * @route POST /api/ai/deepseek/code-analysis
 * @desc AI代码分析接口
 * @access Public
 */
router.post('/code-analysis', aiController.codeAnalysis);

/**
 * @route GET /api/ai/deepseek/balance
 * @desc 查询余额接口
 * @access Public
 */
router.get('/balance', aiController.getBalance);

/**
 * @route GET /api/ai/deepseek/models
 * @desc 查询可用模型接口
 * @access Public
 */
router.get('/models', aiController.getModels);

/**
 * @route POST /api/ai/deepseek/chat
 * @desc DeepSeek聊天接口（非流式）
 * @access Public
 */
router.post('/chat', async (req, res) => {
  try {
    const axios = require('axios');
    const config = require('../../../config');
    const API_KEY = config.DEEPSEEK_API_KEY;
    const API_URL = config.DEEPSEEK_API_URL;
    
    console.log('收到聊天请求 - 非流式');
    
    // 准备请求数据
    const requestData = {
      ...req.body,
      model: req.body.model || 'deepseek-chat',
      stream: false // 确保非流式
    };
    
    console.log('请求DeepSeek API:', API_URL);
    console.log('请求数据:', JSON.stringify(requestData, null, 2));
    
    // 调用DeepSeek API
    const response = await axios({
      method: 'post',
      url: API_URL,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': `Bearer ${API_KEY}`
      },
      data: requestData
    });
    
    console.log('DeepSeek API响应状态:', response.status);
    
    // 返回原始API响应
    return res.status(200).json(response.data);
  } catch (error) {
    console.error('调用DeepSeek API失败:', error.message);
    
    if (error.response) {
      console.error('错误状态码:', error.response.status);
      console.error('错误响应:', error.response.data);
      return res.status(error.response.status).json({
        error: '调用DeepSeek API失败',
        details: error.response.data
      });
    }
    
    return res.status(500).json({
      error: '调用DeepSeek API失败',
      message: error.message
    });
  }
});

/**
 * @route POST /api/ai/deepseek/chat-stream
 * @desc DeepSeek聊天接口（流式）
 * @access Public
 */
router.post('/chat-stream', async (req, res) => {
  try {
    const axios = require('axios');
    const config = require('../../../config');
    const API_KEY = config.DEEPSEEK_API_KEY;
    const API_URL = config.DEEPSEEK_API_URL;
    
    console.log('收到聊天请求 - 流式');
    
    // 准备请求数据
    const requestData = {
      ...req.body,
      model: req.body.model || 'deepseek-chat',
      stream: true // 确保流式
    };
    
    console.log('请求DeepSeek API (流式):', API_URL);
    console.log('请求数据:', JSON.stringify(requestData, null, 2));
    
    // 设置响应头，表示这是一个流式响应
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    
    // 调用DeepSeek API 并直接透传响应
    const response = await axios({
      method: 'post',
      url: API_URL,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'text/event-stream',
        'Authorization': `Bearer ${API_KEY}`
      },
      data: requestData,
      responseType: 'stream'
    });
    
    // 直接将流传递给客户端
    response.data.pipe(res);
    
    // 处理潜在错误
    response.data.on('error', (err) => {
      console.error('流处理错误:', err);
      res.end(`data: {"error":"流处理错误: ${err.message}"}\n\n`);
    });
    
  } catch (error) {
    console.error('流式请求失败:', error.message);
    
    // 尝试以SSE格式发送错误
    res.write(`data: {"error":"调用DeepSeek API失败: ${error.message}"}\n\n`);
    res.end('data: [DONE]\n\n');
  }
});

module.exports = router; 