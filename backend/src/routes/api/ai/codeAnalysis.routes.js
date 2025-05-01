const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../../../middleware/auth');
const codeAnalysisService = require('../../../services/ai/codeAnalysisService');
const db = require('../../../db');

/**
 * @route POST /api/ai/code-analysis/analyze
 * @desc 分析代码
 * @access 私有
 */
router.post('/analyze', authenticateToken, async (req, res) => {
  const { code, language, analysisType, submissionId, problemNumber: rawProblemNumber, userId } = req.body;
  const requestId = `codeanalysis-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  
  console.log(`[${requestId}] 接收到代码分析请求 - 分析类型: ${analysisType}, 语言: ${language}`);
  
  try {
    // 基本参数验证
    if (!code) {
      return res.status(400).json({
        success: false,
        message: '代码不能为空'
      });
    }
    
    if (!analysisType) {
      return res.status(400).json({
        success: false,
        message: '分析类型不能为空'
      });
    }
    
    if (!language) {
      return res.status(400).json({
        success: false,
        message: '编程语言不能为空'
      });
    }
    
    // 格式化题目编号为4位数字字符串
    let problemNumber = rawProblemNumber;
    if (problemNumber && !problemNumber.match(/^\d{4}$/)) {
      problemNumber = String(problemNumber).padStart(4, '0');
      console.log(`[${requestId}] 已格式化题目编号 ${rawProblemNumber} -> ${problemNumber}`);
    }
    
    // 分析代码
    console.log(`[${requestId}] 开始分析代码，分析类型: ${analysisType}, 代码长度: ${code.length}`);
    const result = await codeAnalysisService.analyzeCode(code, language, analysisType);
    
    // 如果提供了submissionId，将分析结果保存到数据库
    if (submissionId && userId && problemNumber) {
      try {
        // 根据分析类型选择对应的表
        let tableName;
        switch (analysisType) {
          case 'naming':
            tableName = 'code_style_naming';
            break;
          case 'logic':
            tableName = 'code_style_logic';
            break;
          case 'complexity':
            tableName = 'code_style_complexity';
            break;
          case 'readability':
            tableName = 'code_style_readability';
            break;
          default:
            throw new Error(`未知的分析类型: ${analysisType}`);
        }
        
        // 处理analysis字段 - 如果是对象，转为JSON字符串
        let analysisText = result.analysis;
        if (typeof analysisText === 'object') {
          console.log(`[${requestId}] 分析结果为对象类型，转换为JSON字符串`);
          analysisText = JSON.stringify(analysisText);
        }
        
        // 确保suggestion字段是字符串
        let suggestionText = result.suggestion;
        if (typeof suggestionText === 'object') {
          suggestionText = JSON.stringify(suggestionText);
        }
        
        // 将分析结果存储到对应的表中
        await db.query(
          `INSERT INTO ${tableName} (user_id, submission_id, problem_number, analysis_text, score, suggestion_text) 
           VALUES (?, ?, ?, ?, ?, ?)`,
          [userId, submissionId, problemNumber, analysisText, result.score, suggestionText]
        );
        
        console.log(`[${requestId}] 分析结果已保存到数据库表 ${tableName}，提交ID: ${submissionId}`);
      } catch (dbError) {
        console.log(`[${requestId}] 保存分析结果到数据库失败: ${dbError.message}`);
        // 这里仅记录错误，不影响API返回结果
      }
    } else if (submissionId) {
      console.log(`[${requestId}] 缺少保存分析结果所需的参数（userId 或 problemNumber），结果未保存到数据库`);
    }
    
    console.log(`[${requestId}] 代码分析完成，得分: ${result.score}`);
    
    return res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.log(`[${requestId}] 代码分析失败: ${error.message}`);
    
    return res.status(500).json({
      success: false,
      message: `代码分析失败: ${error.message}`
    });
  }
});

/**
 * @route GET /api/ai/code-analysis/types
 * @desc 获取支持的代码分析类型
 * @access 私有
 */
router.get('/types', authenticateToken, (req, res) => {
  const analysisTypes = [
    {
      id: 'naming',
      name: '命名规范分析',
      description: '分析代码中的变量和函数命名是否规范',
      dimensions: ['变量命名规则遵循度', '变量命名表意性', '函数命名规范性', '命名一致性']
    },
    {
      id: 'logic',
      name: '逻辑连通性分析',
      description: '分析代码的逻辑结构和连贯性',
      dimensions: ['条件判断逻辑', '循环逻辑', '函数调用逻辑', '代码整体逻辑连贯性']
    },
    {
      id: 'complexity',
      name: '复杂度分析',
      description: '分析代码的时间复杂度、空间复杂度和嵌套深度',
      dimensions: ['时间复杂度', '空间复杂度', '嵌套深度']
    },
    {
      id: 'readability',
      name: '可读性分析',
      description: '分析代码的可读性和注释完整性',
      dimensions: ['注释完整性', '代码布局', '函数和类设计']
    }
  ];
  
  return res.json({
    success: true,
    data: analysisTypes
  });
});

/**
 * @route GET /api/ai/code-analysis/history/:submissionId
 * @desc 获取某次提交的历史分析结果
 * @access 私有
 */
router.get('/history/:submissionId', authenticateToken, async (req, res) => {
  const { submissionId } = req.params;
  
  try {
    // 从各个代码风格表中获取历史分析结果
    const [namingResults] = await db.query(
      'SELECT "naming" as type, analysis_text as analysis, score, suggestion_text as suggestion, created_at FROM code_style_naming WHERE submission_id = ?',
      [submissionId]
    );
    
    const [logicResults] = await db.query(
      'SELECT "logic" as type, analysis_text as analysis, score, suggestion_text as suggestion, created_at FROM code_style_logic WHERE submission_id = ?',
      [submissionId]
    );
    
    const [complexityResults] = await db.query(
      'SELECT "complexity" as type, analysis_text as analysis, score, suggestion_text as suggestion, created_at FROM code_style_complexity WHERE submission_id = ?',
      [submissionId]
    );
    
    const [readabilityResults] = await db.query(
      'SELECT "readability" as type, analysis_text as analysis, score, suggestion_text as suggestion, created_at FROM code_style_readability WHERE submission_id = ?',
      [submissionId]
    );
    
    // 合并所有结果
    const allResults = [
      ...namingResults,
      ...logicResults,
      ...complexityResults,
      ...readabilityResults
    ].sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
    
    return res.json({
      success: true,
      data: allResults
    });
  } catch (error) {
    console.log(`获取历史分析结果失败: ${error.message}`);
    
    return res.status(500).json({
      success: false,
      message: `获取历史分析结果失败: ${error.message}`
    });
  }
});

module.exports = router; 