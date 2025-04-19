const express = require('express');
const router = express.Router();
const db = require('../../db');
const { authenticateToken } = require('../../middleware/auth');
const ZhipuAI = require('../../utils/zhipuAI');

// 代码分析路由
router.post('/analyze-code', authenticateToken, async (req, res) => {
  const requestId = req.requestId || `ai-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] =========AI代码分析开始=========`);
  console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户ID: ${req.user?.id}, 用户名: ${req.user?.username}`);
  
  try {
    const { code, language, problemId } = req.body;
    
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 接收到分析请求 - 语言: ${language}, 题目ID: ${problemId}`);
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

    // 修改提示信息,使用更宽松的格式要求
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
        content: `题目：${problem.title}
题目描述：${problem.description}

用户代码：
\`\`\`${language}
${code}
\`\`\`

请分析这段代码的问题并给出改进建议。`
      }
    ];

    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 正在调用智谱AI进行代码分析...`);
    const zhipuAI = new ZhipuAI();
    const aiResponse = await zhipuAI.chat(messages);
    
    // 解析AI响应
    let analysis;
    try {
      // 直接返回完整分析内容
      analysis = {
        codeAnalysis: aiResponse || '未获取到分析内容'
      };
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] AI响应解析成功, 内容长度: ${aiResponse?.length || 0}`);
    } catch (error) {
      console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 解析AI响应失败:`, error);
      analysis = {
        codeAnalysis: '解析AI响应失败'
      };
    }

    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] AI分析完成，准备返回结果`);
    
    res.json({
      success: true,
      data: analysis
    });
    
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] =========AI代码分析结束=========`);
  } catch (error) {
    console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 代码分析失败:`, error);
    
    // 记录详细错误信息
    if (error.response) {
      console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] API响应错误:`, {
        status: error.response.status,
        data: error.response.data
      });
    }
    
    res.status(500).json({
      success: false,
      message: '代码分析失败：' + error.message
    });
    
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] =========AI代码分析异常结束=========`);
  }
});



module.exports = router; 