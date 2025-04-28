const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../../../middleware/auth');
const aiController = require('../../../controllers/ai-analysis.controller');

/**
 * @route POST /api/ai/analyze-code
 * @desc 多模型代码分析接口
 * @access Private
 */
router.post('/analyze-code', authenticateToken, aiController.analyzeCode);

/**
 * @route GET /api/ai/models
 * @desc 获取可用AI模型列表
 * @access Private
 */
router.get('/models', authenticateToken, aiController.getModels);

/**
 * @route GET /api/ai/balance
 * @desc 获取AI模型余额
 * @access Private
 */
router.get('/balance', authenticateToken, aiController.getBalance);

/**
 * 旧路由兼容处理 - 深度思考API
 */
// 添加DeepSeek API路由
const deepseekRoutes = require('./deepseek.routes');
router.use('/deepseek', deepseekRoutes);

console.log('AI API路由已注册，包含多模型代码分析功能');

module.exports = router; 