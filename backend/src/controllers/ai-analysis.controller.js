const analyzeCodeService = require('../services/ai/analyzeCode.service');
const db = require('../db');

/**
 * AI代码分析控制器
 * 处理不同AI模型的代码分析请求
 */
class AIAnalysisController {
  /**
   * 代码分析
   * @param {Object} req 请求对象
   * @param {Object} res 响应对象
   * @returns {Promise<void>}
   */
  async analyzeCode(req, res) {
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
      
      // 检查模型是否支持
      const supportedModels = ['glm-4-flash', 'deepseek-chat', 'deepseek-reasoner'];
      if (!supportedModels.includes(model)) {
        console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 不支持的模型: ${model}`);
        return res.status(400).json({
          success: false,
          message: `不支持的模型: ${model}，支持的模型有: ${supportedModels.join(', ')}`
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
      
      // 调用服务进行代码分析
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 正在使用模型 ${model} 进行代码分析...`);
      const result = await analyzeCodeService.analyzeCode(params, model);
      
      // 根据不同模型处理响应
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 获取分析结果成功`);
      
      return res.json({
        success: true,
        data: result
      });
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
  }
  
  /**
   * 获取模型余额
   * @param {Object} req 请求对象 
   * @param {Object} res 响应对象
   * @returns {Promise<void>}
   */
  async getBalance(req, res) {
    try {
      // 这里可以实现查询不同模型的余额逻辑
      res.json({
        success: true,
        data: {
          glm4: { amount: 1000, unit: '积分' },
          deepseek: { amount: 5000, unit: '积分' }
        }
      });
    } catch (error) {
      console.error('获取余额失败:', error);
      res.status(500).json({
        success: false,
        message: '获取余额失败'
      });
    }
  }
  
  /**
   * 获取可用模型列表
   * @param {Object} req 请求对象
   * @param {Object} res 响应对象
   * @returns {Promise<void>}
   */
  async getModels(req, res) {
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
  }
  
  /**
   * 通用代码分析
   * @param {Object} req 请求对象
   * @param {Object} res 响应对象
   * @returns {Promise<void>}
   */
  async codeAnalysis(req, res) {
    return this.analyzeCode(req, res);
  }
}

module.exports = new AIAnalysisController(); 