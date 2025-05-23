const express = require('express');
const router = express.Router();
const mysql = require('mysql2/promise');
const { submitCode, executeCode } = require('../../services/judge');
const { dbConfig } = require('../../config/db');
const { Executor } = require('../../services/judge/executor');
const executor = new Executor();

// 提交代码进行判题
router.post('/problems/:id/submit', async (req, res) => {
  const problemIdParam = req.params.id;
  const { code, language } = req.body;
  const userId = req.user?.id || 1;

  console.log('收到判题请求:', { problemIdParam, language });
  
  // 预处理代码，针对Java处理不同类名格式
  let processedCode = code;
  if (language.toLowerCase() === 'java') {
    // 检查Java代码是否包含public类
    const publicClassMatch = /public\s+class\s+(\w+)\s*\{/.test(code);
    if (publicClassMatch) {
      const className = RegExp.$1;
      console.log(`检测到public类 ${className}`);
    }
  }
  
  let connection;
  let sandbox;
  try {
    connection = await mysql.createConnection(dbConfig);
    await connection.beginTransaction();
    console.log('开启数据库事务');

    // 1. 获取题目信息 - 既支持problem_number也支持id
    let actualProblemId;
    let problems = [];

    // 检查是否是数字形式的problem_number (例如"0030")
    if (problemIdParam.match(/^\d+$/)) {
      const paddedProblemNumber = problemIdParam.padStart(4, '0');
      console.log('尝试通过problem_number查询:', paddedProblemNumber);
      
      // 首先尝试通过problem_number查询
      [problems] = await connection.execute(
        'SELECT * FROM problems WHERE problem_number = ?',
        [paddedProblemNumber]
      );
      
      if (problems && problems.length > 0) {
        console.log('通过problem_number找到题目:', problems[0].title);
      } else {
        // 如果没找到，尝试通过ID查询
        console.log('通过problem_number未找到题目，尝试通过ID查询');
        [problems] = await connection.execute(
          'SELECT * FROM problems WHERE id = ?',
          [parseInt(problemIdParam)]
        );
      }
    } else {
      // 非数字ID，直接查询
      [problems] = await connection.execute(
        'SELECT * FROM problems WHERE id = ?',
        [problemIdParam]
      );
    }
    
    if (problems.length === 0) {
      await connection.rollback();
      return res.status(404).json({
        success: false,
        message: '题目不存在'
      });
    }
    
    actualProblemId = problems[0].id;
    console.log('获取题目信息成功: ID =', actualProblemId, ', 标题 =', problems[0].title);
    
    // 2. 获取题目的测试用例
    const [testCases] = await connection.execute(
      'SELECT id, problem_id, problem_number, input, output, order_num, is_example FROM problem_test_cases WHERE (problem_id = ? OR problem_number = ?) ORDER BY order_num ASC',
      [actualProblemId, problems[0].problem_number]
    );
    
    if (testCases.length === 0) {
      await connection.rollback();
      return res.status(404).json({
        success: false,
        message: '题目没有测试用例'
      });
    }
    console.log('获取测试用例成功, 数量:', testCases.length);

    // 3. 创建提交记录
    const [submission] = await connection.execute(
      'INSERT INTO submissions (user_id, problem_id, problem_number, code, language, status) VALUES (?, ?, ?, ?, ?, ?)',
      [userId, actualProblemId, problems[0].problem_number, processedCode, language, 'Pending']
    );
    console.log('创建提交记录成功, ID:', submission.insertId);

    // 4. 调用判题服务
    console.log('开始判题...');
    const judgeResult = await submitCode({
      submissionId: submission.insertId,
      code: processedCode,
      language,
      problem: problems[0],
      testCases
    });
    console.log('判题结果:', judgeResult);

    // 将判题服务的状态映射到数据库状态
    const statusMap = {
      'accepted': 'Accepted',
      'wrong_answer': 'Wrong Answer',
      'runtime_error': 'Runtime Error',
      'compile_error': 'Compilation Error',
      'time_limit_exceeded': 'Time Limit Exceeded',
      'memory_limit_exceeded': 'Memory Limit Exceeded',
      'system_error': 'System Error'
    };

    const dbStatus = statusMap[judgeResult.status] || 'System Error';

    // 5. 更新提交状态
    await connection.execute(
      `UPDATE submissions 
       SET status = ?, runtime = ?, memory = ?, error_message = ?, completed_at = NOW()
       WHERE id = ?`,
      [dbStatus, judgeResult.runtime || 0, judgeResult.memory || 0, judgeResult.error_message, submission.insertId]
    );
    console.log('更新提交状态成功');

    // 6. 如果通过，更新题目统计
    if (dbStatus === 'Accepted') {
      // 更新题目的通过率
      await connection.execute(
        `UPDATE problems 
         SET accepted_submissions = accepted_submissions + 1,
             total_submissions = total_submissions + 1,
             acceptance_rate = ROUND((accepted_submissions / total_submissions) * 100, 2)
         WHERE id = ?`,
        [actualProblemId]
      );
    } else {
      // 只更新总提交数
      await connection.execute(
        `UPDATE problems 
         SET total_submissions = total_submissions + 1,
             acceptance_rate = ROUND((accepted_submissions / total_submissions) * 100, 2)
         WHERE id = ?`,
        [actualProblemId]
      );
    }

    // 提交事务
    await connection.commit();
    console.log('提交事务成功');

    res.json({
      success: true,
      data: {
        ...judgeResult,
        status: dbStatus,
        submissionId: submission.insertId
      }
    });

  } catch (error) {
    console.error('判题失败:', error);
    if (connection) {
      try {
        await connection.rollback();
        console.log('回滚事务成功');
      } catch (rollbackError) {
        console.error('回滚事务失败:', rollbackError);
      }
    }

    // 尝试更新提交状态为系统错误
    if (connection && submission?.insertId) {
      try {
        await connection.execute(
          `UPDATE submissions 
           SET status = 'System Error', 
               error_message = ?, 
               completed_at = NOW()
           WHERE id = ?`,
          [error.message || '系统错误，请稍后重试', submission.insertId]
        );
      } catch (updateError) {
        console.error('更新提交状态失败:', updateError);
      }
    }

    res.status(500).json({
      success: false,
      message: '判题失败，请稍后重试',
      error: error.message
    });
  } finally {
    if (connection) {
      try {
        await connection.end();
        console.log('关闭数据库连接');
      } catch (error) {
        console.error('关闭数据库连接失败:', error);
      }
    }
  }
});

// 获取提交历史的路由
router.get('/submissions', async (req, res) => {
  const { user_id, problem_id, problem_number, page = 1, limit = 20 } = req.query;
  const offset = (page - 1) * limit;

  let connection;
  try {
    connection = await mysql.createConnection(dbConfig);

    // 构建查询条件
    const conditions = [];
    const params = [];
    if (user_id) {
      conditions.push('user_id = ?');
      params.push(user_id);
    }
    if (problem_id) {
      conditions.push('problem_id = ?');
      params.push(problem_id);
    }
    if (problem_number) {
      conditions.push('problem_number = ?');
      params.push(problem_number);
    }

    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

    // 获取总数
    const [countResult] = await connection.execute(
      `SELECT COUNT(*) as total FROM submissions ${whereClause}`,
      params
    );
    const total = countResult[0].total;

    // 如果没有记录，直接返回空数组，而不是抛出错误
    if (total === 0) {
      return res.json([]);
    }

    // 获取分页数据
    const [submissions] = await connection.execute(
      `SELECT id, user_id, problem_id, problem_number, language, status, runtime, memory, created_at, completed_at
       FROM submissions
       ${whereClause}
       ORDER BY created_at DESC
       LIMIT ?, ?`,
      [...params, parseInt(offset), parseInt(limit)]
    );

    res.json(submissions);
  } catch (error) {
    console.error('获取提交历史失败:', error);
    res.status(500).json({
      message: '获取提交历史失败'
    });
  } finally {
    if (connection) {
      connection.end();
    }
  }
});

// 获取用户提交记录的路由 - 放在参数路由之前
router.get('/submissions/user', async (req, res) => {
  let connection;
  try {
    connection = await mysql.createConnection(dbConfig);

    // 获取用户ID（暂时使用固定用户ID）
    const userId = 1; // 这里应该从会话中获取用户ID，暂时使用固定值

    // 获取用户的提交记录
    const [submissions] = await connection.execute(
      `SELECT s.*, p.title as problem_title 
       FROM submissions s
       LEFT JOIN problems p ON s.problem_id = p.id OR s.problem_number = p.problem_number
       WHERE s.user_id = ?
       ORDER BY s.created_at DESC`,
      [userId]
    );

    res.json(submissions);

  } catch (error) {
    console.error('获取用户提交记录失败:', error);
    res.status(500).json({
      error: '获取用户提交记录失败',
      message: error.message
    });
  } finally {
    if (connection) {
      connection.end();
    }
  }
});

// 获取单个提交详情的路由 - 放在最后
router.get('/submissions/:id', async (req, res) => {
  const submissionId = req.params.id;
  const userId = 1; // 暂时使用固定用户ID

  let connection;
  try {
    connection = await mysql.createConnection(dbConfig);

    // 获取提交记录详情
    const [[submission]] = await connection.execute(
      `SELECT s.*, p.title as problem_title, u.username 
       FROM submissions s
       LEFT JOIN problems p ON s.problem_id = p.id OR s.problem_number = p.problem_number
       LEFT JOIN users u ON s.user_id = u.id
       WHERE s.id = ?`,
      [submissionId]
    );

    if (!submission) {
      return res.status(404).json({ error: '提交记录不存在' });
    }

    // 检查访问权限（只有提交者和管理员可以查看完整代码）
    if (submission.user_id !== userId) {
      delete submission.code;
    }

    res.json(submission);

  } catch (error) {
    console.error('获取提交详情失败:', error);
    res.status(500).json({
      error: '获取提交详情失败',
      message: error.message
    });
  } finally {
    if (connection) {
      connection.end();
    }
  }
});

// 更新题目统计信息
async function updateProblemStats(connection, problemId, status) {
  try {
    // 更新总提交数
    await connection.execute(
      'UPDATE problems SET total_submissions = total_submissions + 1 WHERE id = ?',
      [problemId]
    );

    // 如果是通过的提交，更新通过数
    if (status === 'accepted') {
      await connection.execute(
        'UPDATE problems SET accepted_submissions = accepted_submissions + 1 WHERE id = ?',
        [problemId]
      );
    }

    // 更新通过率
    await connection.execute(
      `UPDATE problems 
       SET acceptance_rate = ROUND((accepted_submissions / total_submissions) * 100, 2)
       WHERE id = ?`,
      [problemId]
    );

  } catch (error) {
    console.error('更新题目统计信息失败:', error);
  }
}

// 修改运行代码的路由
router.post('/problems/:id/run', async (req, res) => {
  const { code, language, input } = req.body;
  
  if (!code || !language) {
    return res.status(400).json({
      success: false,
      message: '缺少必要参数'
    });
  }

  try {
    console.log('开始调试运行...');
    console.log('代码:', code);
    console.log('语言:', language);
    console.log('输入:', input);

    // 预处理Java代码
    let processedCode = code;
    if (language.toLowerCase() === 'java') {
      // 检查是否包含public类
      const publicClassMatch = code.match(/public\s+class\s+(\w+)\s*\{/);
      if (publicClassMatch && publicClassMatch[1]) {
        console.log(`检测到public类 ${publicClassMatch[1]}`);
      }
    }

    // 使用执行器执行代码
    const result = await executor.executeDebug(processedCode, language, input);
    console.log('调试执行结果:', result);

    if (result.status === 'error') {
      return res.json({
        success: false,
        message: result.error,
        data: {
          output: '',
          compilerOutput: result.error // 编译错误信息
        }
      });
    }

    return res.json({
      success: true,
      data: {
        output: result.output, // 代码执行输出
        compilerOutput: result.compilerOutput || '编译成功，无编译器输出' // 编译器输出信息
      }
    });

  } catch (error) {
    console.error('调试运行出错:', error);
    return res.status(500).json({
      success: false,
      message: error.message || '运行代码时发生错误',
      data: {
        output: '',
        compilerOutput: error.message || '系统错误'
      }
    });
  }
});

module.exports = router; 