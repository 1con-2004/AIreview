const express = require('express');
const router = express.Router();
const db = require('../../db');
const { authenticateToken } = require('../../middleware/auth');
const ZhipuAI = require('../../utils/zhipuAI');
const analyzeCodeService = require('../../services/ai/analyzeCode.service');

// 代码分析路由
router.post('/analyze-code', authenticateToken, async (req, res) => {
  const requestId = req.requestId || `ai-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] =========AI代码分析开始=========`);
  console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户ID: ${req.user?.id}, 用户名: ${req.user?.username}`);
  
  try {
    const { code, language, problemId, model = 'glm-4-flash' } = req.body;
    
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 接收到分析请求 - 语言: ${language}, 题目ID: ${problemId}, 模型: ${model}`);
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 代码长度: ${code?.length || 0} 字符`);
    
    if (!code || !language || !problemId) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 缺少必要参数`);
      return res.status(400).json({
        success: false,
        message: '缺少必要参数'
      });
    }

    // 获取题目信息
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 正在获取题目信息: ${problemId}`);
    const [problems] = await db.query(
      'SELECT title, description FROM problems WHERE problem_number = ?',
      [problemId]
    );

    if (!problems || problems.length === 0) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 题目不存在: ${problemId}`);
      return res.status(404).json({
        success: false,
        message: '题目不存在'
      });
    }

    const problem = problems[0];
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 成功获取题目: ${problem.title}`);

    // 构建分析参数
    const params = {
      code,
      language,
      problemTitle: problem.title,
      problemDescription: problem.description
    };
    
    // 使用analyzeCodeService进行代码分析，根据model参数选择不同的AI模型
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 使用模型 ${model} 进行代码分析`);
    let result;
    
    // 调用服务进行代码分析
    result = await analyzeCodeService.analyzeCode(params, model);
    
    // 构建响应
    const responseObj = {
      success: true,
      data: result
    };
    
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 分析完成，响应数据类型:`, typeof result === 'object' ? 'object' : typeof result);
    if (typeof result === 'string') {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 分析结果前50个字符:`, result.substring(0, 50));
    } else if (result && result.analysis) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 分析结果前50个字符:`, result.analysis.substring(0, 50));
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 包含思考过程:`, !!result.reasoning);
    }
    
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] AI分析完成，准备返回结果`);
    
    return res.json(responseObj);
  } catch (error) {
    console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 代码分析失败:`, error);
    
    // 记录详细错误信息
    let errorMessage = '代码分析失败';
    
    if (error.response) {
      console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] API响应错误:`, {
        status: error.response.status,
        data: error.response.data
      });
      errorMessage += `：API错误(${error.response.status}) - ${error.response.data?.error || '未知API错误'}`;
    } else if (error.request) {
      console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 未收到响应:`, error.request);
      errorMessage += '：请求已发送但未收到响应，请检查网络连接或服务提供商状态';
    } else {
      console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 请求设置错误:`, error.message);
      errorMessage += `：${error.message || '未知错误'}`;
    }
    
    res.status(500).json({
      success: false,
      message: errorMessage,
      error: {
        type: error.name || 'Error',
        detail: error.message || '未知错误'
      }
    });
    
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] =========AI代码分析异常结束=========`);
  }
});

// 获取可用模型列表
router.get('/models', authenticateToken, async (req, res) => {
  try {
    const models = [
      { 
        id: 'glm-4-flash', 
        name: '智谱AI', 
        description: '智谱GLM-4-flash模型，快速响应，支持中文交互',
        status: 'available'
      },
      { 
        id: 'deepseek-chat', 
        name: 'DeepSeek-V3', 
        description: 'DeepSeek最新对话模型，提供准确、详细的代码分析',
        status: 'available'
      },
      { 
        id: 'deepseek-reasoner', 
        name: 'DeepSeek-R1', 
        description: 'DeepSeek推理模型，提供详细思考过程和分析',
        status: 'available'
      }
    ];
    
    res.json({
      success: true,
      data: models
    });
  } catch (error) {
    console.error('获取模型列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取模型列表失败'
    });
  }
});

// 添加DeepSeek API路由
const deepseekRoutes = require('../../routes/api/ai/deepseek.routes');
router.use('/deepseek', deepseekRoutes);

console.log('DeepSeek API路由已注册');

module.exports = router; 