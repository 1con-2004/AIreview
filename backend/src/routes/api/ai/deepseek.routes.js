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
 * @route GET /api/ai/deepseek/balance/query
 * @desc 查询余额接口
 * @access Public
 */
router.get('/balance/query', aiController.balanceQuery);

/**
 * @route GET /api/ai/deepseek/models
 * @desc 查询可用模型接口
 * @access Public
 */
router.get('/models', aiController.getModels);

module.exports = router; 