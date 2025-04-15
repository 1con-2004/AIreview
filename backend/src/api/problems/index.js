const express = require('express');
const router = express.Router();
const db = require('../../db'); // 确保路径正确
const { authenticateToken } = require('../../middleware/auth');

// 更新题目通过率的工具函数
const updateProblemAcceptanceRate = async (problemId) => {
  try {
    console.log(`开始更新题目 ${problemId} 的通过率`);
    
    // 获取题目当前的提交数据
    const [problem] = await db.query(
      'SELECT id, total_submissions, accepted_submissions FROM problems WHERE id = ?',
      [problemId]
    );

    if (!problem || problem.length === 0) {
      console.log(`未找到题目 ${problemId}`);
      return;
    }

    const totalSubmissions = problem[0].total_submissions || 0;
    const acceptedSubmissions = problem[0].accepted_submissions || 0;
    
    // 计算通过率
    let acceptanceRate = 0;
    if (totalSubmissions > 0) {
      acceptanceRate = (acceptedSubmissions / totalSubmissions) * 100;
      // 保留两位小数
      acceptanceRate = parseFloat(acceptanceRate.toFixed(2));
    }

    // 更新数据库
    await db.query(
      'UPDATE problems SET acceptance_rate = ? WHERE id = ?',
      [acceptanceRate, problemId]
    );

    console.log(`题目 ${problemId} 的通过率已更新为 ${acceptanceRate}%`);
    return acceptanceRate;
  } catch (error) {
    console.error('更新题目通过率时发生错误:', error);
    throw error;
  }
};

// 批量更新所有题目通过率的函数
const updateAllProblemsAcceptanceRate = async () => {
  try {
    console.log('开始更新所有题目的通过率');
    
    // 获取所有题目
    const [problems] = await db.query('SELECT id FROM problems');
    
    // 逐个更新每道题的通过率
    for (const problem of problems) {
      await updateProblemAcceptanceRate(problem.id);
    }
    
    console.log('所有题目的通过率更新完成');
  } catch (error) {
    console.error('批量更新题目通过率时发生错误:', error);
    throw error;
  }
};

// 获取题目通过 ID
const getProblemById = async (id, userId) => {
  // 先尝试用 problem_number 精确匹配
  let [problemRows] = await db.query(
    'SELECT * FROM problems WHERE problem_number = ?', 
    [id.toString().padStart(4, '0')]
  );
  
  // 如果找不到,再尝试用 id 查询
  if (!problemRows || problemRows.length === 0) {
    [problemRows] = await db.query(
      'SELECT * FROM problems WHERE id = ?', 
      [parseInt(id)]
    );
  }
  
  if (!problemRows || problemRows.length === 0) {
    return null;
  }

  const problem = problemRows[0];
  
  if (userId) {
    const [statusRows] = await db.query(
      'SELECT status FROM user_problem_status WHERE user_id = ? AND problem_id = ?',
      [userId, problem.id]
    );
    problem.userStatus = statusRows[0]?.status || null;
  }
  
  return problem;
};

// 获取题目列表
router.get('/list', async (req, res) => {
  try {
    console.log('Getting problems list with params:', req.query);
    const difficulty = req.query.difficulties || '';
    
    let query = `
      SELECT 
        id,
        title,
        difficulty,
        tags,
        problem_number,
        total_submissions,
        COALESCE(acceptance_rate, 0) as acceptance_rate
      FROM problems
    `;
    
    const conditions = [];
    const params = [];
    
    if (difficulty) {
      conditions.push('difficulty = ?');
      params.push(difficulty);
    }
    
    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }
    
    // 按ID降序排序
    query += ' ORDER BY id DESC';
    
    console.log('Executing SQL query:', query);
    console.log('Query parameters:', params);

    const [problems] = await db.query(query, params);
    
    // 处理数值类型
    const processedProblems = problems.map(problem => ({
      ...problem,
      total_submissions: parseInt(problem.total_submissions) || 0,
      acceptance_rate: parseFloat(problem.acceptance_rate) || 0
    }));
    
    res.json({
      code: 200,
      data: {
        problems: processedProblems,
        total: processedProblems.length
      }
    });
  } catch (error) {
    console.error('Error getting problems list:', error);
    res.status(500).json({
      code: 500,
      message: '获取题目列表失败'
    });
  }
});

// 获取题目统计信息
router.get('/stats', async (req, res) => {
  try {
    console.log('Getting problems statistics');
    
    // 获取总题目数
    const [totalProblems] = await db.query('SELECT COUNT(*) as total FROM problems');
    
    // 获取所有不同的标签
    const [tags] = await db.query('SELECT DISTINCT tags FROM problems');
    const tagSet = new Set();
    tags.forEach(tag => {
      if (tag.tags) {
        tag.tags.split(',').forEach(t => tagSet.add(t.trim()));
      }
    });
    
    // 获取难度分布
    const [difficultyStats] = await db.query(`
      SELECT difficulty, COUNT(*) as count 
      FROM problems 
      GROUP BY difficulty
    `);
    
    console.log('统计信息:', {
      totalProblems: totalProblems[0].total,
      totalCategories: tagSet.size,
      difficultyStats
    });
    
    res.json({
      code: 200,
      data: {
        totalProblems: totalProblems[0].total,
        totalCategories: tagSet.size,
        difficultyStats: difficultyStats
      }
    });
  } catch (error) {
    console.error('Error getting problems statistics:', error);
    res.status(500).json({
      code: 500,
      message: '获取题目统计信息失败'
    });
  }
});

// 获取所有题目分类
router.get('/categories', async (req, res) => {
  try {
    console.log('Getting problem categories');
    const [categories] = await db.query('SELECT * FROM problem_pool_categories');
    
    res.json({
      code: 200,
      data: categories
    });
  } catch (error) {
    console.error('Error getting problem categories:', error);
    res.status(500).json({
      code: 500,
      message: '获取题目分类失败'
    });
  }
});

// 获取所有标签
router.get('/tags', async (req, res) => {
  try {
    const [tags] = await db.query('SELECT DISTINCT tags FROM problems');
    const tagArray = tags.flatMap(tag => tag.tags ? tag.tags.split(',').map(t => t.trim()) : []);
    console.log('获取到的标签数据:', tagArray);
    res.json({
      code: 200,
      data: [...new Set(tagArray)] // 去重后返回
    });
  } catch (error) {
    console.error('获取标签失败:', error);
    res.status(500).json({
      code: 500,
      message: '获取标签失败'
    });
  }
});

// 测试数据库连接
router.get('/test', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT 1');
    res.json({
      code: 200,
      data: rows
    });
  } catch (error) {
    res.status(500).json({
      code: 500,
      message: '数据库连接失败'
    });
  }
});

// 获取所有题目
router.get('/', async (req, res) => {
  try {
    console.log('开始获取题目列表...');
    
    // 添加调试日志
    console.log('执行SQL查询: SELECT * FROM problems');
    const [rows] = await db.query('SELECT * FROM problems');
    console.log('查询结果数量:', rows.length);
    console.log('查询结果示例:', rows[0]);
    
    res.json({
      code: 200,
      data: rows
    });
  } catch (error) {
    console.error('获取题目列表失败，错误详情:', error);
    console.error('错误堆栈:', error.stack);
    res.status(500).json({
      code: 500,
      message: '获取题目列表失败',
      error: error.message
    });
  }
});

// 添加新题目
router.post('/', async (req, res) => {
  const { problem_number, title, difficulty, total_submissions, acceptance_rate, tags, description, input_example, output_example } = req.body;
  try {
    await db.query(
      'INSERT INTO problems (problem_number, title, difficulty, total_submissions, acceptance_rate, tags, description, input_example, output_example) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [problem_number, title, difficulty, total_submissions, acceptance_rate, tags, description, input_example, output_example]
    );
    res.status(201).json({
      code: 200,
      message: '题目添加成功'
    });
  } catch (error) {
    console.error('添加题目失败:', error);
    res.status(500).json({
      code: 500,
      message: '添加题目失败'
    });
  }
});

// 获取题目成功率统计
router.get('/success-rates', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取用户题目成功率, userId:', userId);

    const [stats] = await db.query(
      `SELECT 
         COUNT(*) as total_submissions,
         SUM(CASE WHEN status = 'Accepted' THEN 1 ELSE 0 END) as accepted_submissions,
         COUNT(DISTINCT problem_id) as total_problems,
         SUM(CASE WHEN status = 'Accepted' THEN 1 ELSE 0 END) / COUNT(*) * 100 as success_rate
       FROM user_problem_status
       WHERE user_id = ?`,
      [userId]
    );

    const [difficultyStats] = await db.query(
      `SELECT 
         p.difficulty,
         COUNT(DISTINCT ups.problem_id) as solved_count
       FROM problems p
       JOIN user_problem_status ups ON p.id = ups.problem_id
       WHERE ups.user_id = ? AND ups.status = 'Accepted'
       GROUP BY p.difficulty`,
      [userId]
    );

    const [dailyStats] = await db.query(
      `SELECT 
         DATE(created_at) as date,
         COUNT(*) as submissions,
         SUM(CASE WHEN status = 'Accepted' THEN 1 ELSE 0 END) as accepted
       FROM user_problem_status
       WHERE user_id = ? 
       AND created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
       GROUP BY DATE(created_at)
       ORDER BY date`,
      [userId]
    );

    res.json({
      code: 200,
      data: {
        overall: stats[0],
        byDifficulty: difficultyStats,
        dailyStats
      }
    });
  } catch (error) {
    console.error('获取成功率统计失败:', error);
    res.status(500).json({
      code: 500,
      message: '获取成功率统计失败'
    });
  }
});

// 获取题目解答 - 放在其他具体路由之前
router.get('/:id/solution', async (req, res) => {
  const problemId = req.params.id;
  
  try {
    // 使用统一的函数获取题目
    const problem = await getProblemById(problemId);
    
    if (!problem) {
      return res.status(404).json({
        code: 404,
        message: '未找到该题目'
      });
    }

    // 使用题目 ID 获取解答
    const [mainSolutions] = await db.query(
      'SELECT * FROM solution_main WHERE problem_id = ?',
      [problem.id]  // 使用找到的题目 ID
    );
    
    if (!mainSolutions || mainSolutions.length === 0) {
      console.log('No solution found for problem:', problem.id);
      return res.status(404).json({
        code: 404,
        message: '未找到该题目的解答'
      });
    }

    // 获取所有支持的编程语言
    const [languages] = await db.query('SELECT * FROM solution_languages');

    // 获取各语言的具体实现代码
    const [codes] = await db.query(
      'SELECT sc.*, sl.language_name FROM solution_code sc JOIN solution_languages sl ON sc.language_id = sl.id WHERE sc.solution_id = ?',
      [mainSolutions[0].id]
    );

    // 整合所有信息
    const solution = {
      ...mainSolutions[0],
      languages: languages.map(lang => ({
        id: lang.id,
        name: lang.language_name,
        template: lang.code_template
      })),
      implementations: codes.map(code => ({
        language: code.language_name,
        code: code.standard_solution,
        version: code.version
      }))
    };

    console.log('Found complete solution:', solution);

    res.json({
      code: 200,
      data: solution
    });
  } catch (err) {
    console.error('获取题目解答失败:', err);
    res.status(500).json({
      code: 500,
      message: '获取题目解答失败'
    });
  }
});

// 用户获取题目列表（用于problems/index.vue）
router.get('/user/list', authenticateToken, async (req, res) => {
  try {
    console.log('获取用户题目列表，用户ID:', req.user.id);
    
    // 从 problems 表获取所有题目信息
    const problemsQuery = `
      SELECT 
        p.*,
        COALESCE(ups.status, 'Not Started') as status
      FROM problems p
      LEFT JOIN (
        SELECT problem_id, status
        FROM submissions
        WHERE user_id = ?
        AND status = 'Accepted'
        GROUP BY problem_id
      ) ups ON p.id = ups.problem_id
      ORDER BY p.problem_number
    `;

    console.log('执行题目查询:', problemsQuery);
    const [problems] = await db.query(problemsQuery, [req.user.id]);

    // 处理每个题目的数据
    const processedProblems = problems.map(problem => ({
      ...problem,
      tags: problem.tags ? problem.tags.split(',').map(tag => tag.trim()) : [],
      acceptance_rate: parseFloat(problem.acceptance_rate) || 0,
      total_submissions: parseInt(problem.total_submissions) || 0,
      status: problem.status || 'Not Started'
    }));

    console.log('处理后的题目数据示例:', {
      totalProblems: processedProblems.length,
      sampleProblem: processedProblems[0]
    });

    res.json({
      code: 200,
      data: {
        problems: processedProblems
      }
    });
  } catch (error) {
    console.error('获取题目列表失败:', error);
    console.error('错误详情:', {
      message: error.message,
      sql: error.sql,
      sqlMessage: error.sqlMessage
    });
    res.status(500).json({
      code: 500,
      message: '获取题目列表失败'
    });
  }
});

// 获取题目通过 ID - 放在最后以避免路径冲突
router.get('/:id', authenticateToken, async (req, res) => {
  const problemId = req.params.id;
  const userId = req.user?.id;
  console.log('Received request for problem ID/number:', problemId, 'User ID:', userId);
  
  try {
    const problem = await getProblemById(problemId, userId);
    if (!problem) {
      return res.status(404).json({
        code: 404,
        message: '未找到该题目'
      });
    }
    res.json({
      code: 200,
      data: problem
    });
  } catch (err) {
    console.error('获取题目失败:', err);
    res.status(500).json({
      code: 500,
      message: '获取题目失败'
    });
  }
});

// 管理员获取题目列表（用于admin/problems.vue）
router.get('/admin/list', async (req, res) => {
  try {
    console.log('Getting admin problems list with params:', req.query);
    const page = parseInt(req.query.page) || 1;
    const pageSize = parseInt(req.query.pageSize) || 10;
    const search = req.query.search || '';
    const difficulties = req.query.difficulties ? req.query.difficulties.split(',') : [];
    
    let query = `
      SELECT 
        id,
        title,
        difficulty,
        tags,
        COALESCE(total_submissions, 0) as total_submissions,
        COALESCE(acceptance_rate, 0) as acceptance_rate
      FROM problems
    `;
    
    const conditions = [];
    const params = [];
    
    if (search) {
      conditions.push('(title LIKE ? OR description LIKE ?)');
      params.push(`%${search}%`, `%${search}%`);
    }
    
    if (difficulties.length > 0) {
      conditions.push('difficulty IN (?)');
      params.push(difficulties);
    }
    
    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }
    
    // 添加排序和分页
    query += ' ORDER BY id DESC LIMIT ? OFFSET ?';
    params.push(pageSize, (page - 1) * pageSize);
    
    console.log('Executing admin SQL query:', query);
    console.log('Query parameters:', params);

    const [problems] = await db.query(query, params);
    
    // 处理数值类型
    const processedProblems = problems.map(problem => ({
      ...problem,
      total_submissions: parseInt(problem.total_submissions) || 0,
      acceptance_rate: parseFloat(problem.acceptance_rate) || 0
    }));
    
    // 获取总数
    const [totalResult] = await db.query(
      'SELECT COUNT(*) as total FROM problems' +
      (conditions.length > 0 ? ' WHERE ' + conditions.join(' AND ') : ''),
      conditions.length > 0 ? params.slice(0, -2) : []
    );
    
    res.json({
      code: 200,
      data: {
        problems: processedProblems,
        total: totalResult[0].total,
        page,
        pageSize
      }
    });
  } catch (error) {
    console.error('Error getting admin problems list:', error);
    res.status(500).json({
      code: 500,
      message: '获取管理员题目列表失败'
    });
  }
});

// 添加更新通过率的路由
router.post('/update-acceptance-rates', async (req, res) => {
  try {
    await updateAllProblemsAcceptanceRate();
    res.json({
      code: 200,
      message: '所有题目的通过率已更新'
    });
  } catch (error) {
    console.error('更新通过率失败:', error);
    res.status(500).json({
      code: 500,
      message: '更新通过率失败'
    });
  }
});

// 更新单个题目的通过率
router.post('/update-acceptance-rate/:id', async (req, res) => {
  try {
    const problemId = req.params.id;
    await updateProblemAcceptanceRate(problemId);
    res.json({
      code: 200,
      message: `题目 ${problemId} 的通过率已更新`
    });
  } catch (error) {
    console.error('更新题目通过率失败:', error);
    res.status(500).json({
      code: 500,
      message: '更新题目通过率失败'
    });
  }
});

// 提交题目解答
router.post('/:id/solution', async (req, res) => {
  try {
    const problemId = req.params.id;
    const { code, language } = req.body;
    const userId = req.user.id;

    console.log('接收到代码提交请求:', {
      problemId,
      language,
      userId
    });

    // 首先尝试通过 problem_number 查询题目
    let [problems] = await db.query(
      'SELECT id FROM problems WHERE problem_number = ?',
      [problemId]
    );

    // 如果没找到，再尝试通过 id 查询
    if (!problems || problems.length === 0) {
      [problems] = await db.query(
        'SELECT id FROM problems WHERE id = ?',
        [parseInt(problemId)]
      );
    }

    if (!problems || problems.length === 0) {
      console.log('未找到题目:', problemId);
      return res.status(404).json({
        code: 404,
        message: '未找到该题目'
      });
    }

    const actualProblemId = problems[0].id;
    console.log('找到题目ID:', actualProblemId);

    // 插入提交记录
    const [result] = await db.query(
      'INSERT INTO submissions (user_id, problem_id, problem_number, code, language, status) VALUES (?, ?, ?, ?, ?, ?)',
      [userId, actualProblemId, problemId, code, language, 'Pending']
    );

    // 更新用户题目状态
    await db.query(
      'INSERT INTO user_problem_status (user_id, problem_id, status) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE status = ?',
      [userId, actualProblemId, 'Submitted', 'Submitted']
    );

    console.log('代码提交成功，submission_id:', result.insertId);

    res.json({
      code: 200,
      message: '代码提交成功',
      data: {
        submission_id: result.insertId
      }
    });
  } catch (error) {
    console.error('提交代码失败:', error);
    res.status(500).json({
      code: 500,
      message: '提交代码失败'
    });
  }
});

// 获取题目的提交记录
router.get('/:id/submissions', authenticateToken, async (req, res) => {
  const problemId = req.params.id;
  const userId = req.user.id; // 从token中获取用户ID
  console.log('Getting submissions for problem:', problemId, 'user:', userId);

  try {
    // 首先尝试通过 problem_number 查询题目
    let actualProblemId;

    // 检查是否是数字形式的problem_number (例如"0030")
    if (problemId.match(/^\d+$/)) {
      const paddedProblemNumber = problemId.padStart(4, '0');
      console.log('查询problem_number:', paddedProblemNumber);
      
      // 尝试通过problem_number查询
      let [problemsByNumber] = await db.query(
        'SELECT id FROM problems WHERE problem_number = ?',
        [paddedProblemNumber]
      );
      
      if (problemsByNumber && problemsByNumber.length > 0) {
        actualProblemId = problemsByNumber[0].id;
        console.log('通过problem_number找到题目ID:', actualProblemId);
      } else {
        // 如果通过problem_number找不到，尝试直接使用id
        actualProblemId = parseInt(problemId);
        console.log('尝试直接使用ID:', actualProblemId);
      }
    } else {
      // 非数字形式的ID，直接使用
      actualProblemId = problemId;
    }
    
    console.log('最终使用的题目ID:', actualProblemId);
    
    // 获取该用户对该题目的所有提交记录
    const [submissions] = await db.query(
      `SELECT id, code, language, runtime, memory, status, error_message, created_at, completed_at 
       FROM submissions 
       WHERE user_id = ? AND (problem_id = ? OR problem_number = ?)
       ORDER BY created_at DESC`,
      [userId, actualProblemId, problemId]
    );

    // 检查是否有提交记录
    if (submissions.length === 0) {
      console.log('未找到提交记录，尝试通过数值ID查询:', parseInt(problemId));
      
      // 尝试通过直接的数值ID查询
      const [submissionsByNumericId] = await db.query(
        `SELECT id, code, language, runtime, memory, status, error_message, created_at, completed_at 
         FROM submissions 
         WHERE user_id = ? AND problem_id = ?
         ORDER BY created_at DESC`,
        [userId, parseInt(problemId)]
      );
      
      console.log('Found submissions by numeric ID:', submissionsByNumericId.length);
      
      if (submissionsByNumericId.length > 0) {
        // 如果找到了提交记录，使用这些记录
        return res.json({
          code: 200,
          data: submissionsByNumericId
        });
      }
    }

    console.log('Found submissions:', submissions.length);

    res.json({
      code: 200,
      data: submissions
    });
  } catch (err) {
    console.error('获取提交记录失败:', err);
    res.status(500).json({
      code: 500,
      message: '获取提交记录失败'
    });
  }
});

// 更新题目内容
router.put('/:id', authenticateToken, async (req, res) => {
  const problemId = req.params.id;
  const { title, difficulty, tags, description, time_limit, memory_limit, test_cases } = req.body;
  
  try {
    console.log('更新题目内容:', { problemId, ...req.body });
    
    // 开始事务
    await db.query('START TRANSACTION');
    
    try {
      // 更新题目基本信息
      const [result] = await db.query(
        `UPDATE problems 
         SET title = ?, difficulty = ?, tags = ?, description = ?, 
             time_limit = ?, memory_limit = ?
         WHERE id = ?`,
        [title, difficulty, tags, description, time_limit, memory_limit, problemId]
      );
      
      if (result.affectedRows === 0) {
        await db.query('ROLLBACK');
        return res.status(404).json({
          code: 404,
          message: '未找到该题目'
        });
      }

      // 如果提供了测试用例,更新测试用例
      if (Array.isArray(test_cases)) {
        // 删除原有的测试用例
        await db.query(
          'DELETE FROM problem_test_cases WHERE problem_id = ?',
          [problemId]
        );

        // 插入新的测试用例
        if (test_cases.length > 0) {
          const values = test_cases.map(tc => [
            problemId,
            tc.input,
            tc.output,
            tc.is_example ? 1 : 0,
            tc.order_num
          ]);

          await db.query(
            `INSERT INTO problem_test_cases 
             (problem_id, input, output, is_example, order_num)
             VALUES ?`,
            [values]
          );
        }
      }
      
      // 提交事务
      await db.query('COMMIT');
      
      console.log('题目更新成功');
      res.json({
        code: 200,
        message: '题目更新成功'
      });
    } catch (error) {
      // 如果过程中出现错误,回滚事务
      await db.query('ROLLBACK');
      throw error;
    }
  } catch (error) {
    console.error('更新题目失败:', error);
    res.status(500).json({
      code: 500,
      message: '更新题目失败'
    });
  }
});

// 更新题目解答
router.put('/:id/solution', authenticateToken, async (req, res) => {
  const problemId = req.params.id;
  const { solution_approach, solutions } = req.body;
  
  try {
    console.log('更新题目解答:', { problemId, solution_approach, solutions });
    
    // 开始事务
    await db.query('START TRANSACTION');
    
    try {
      // 更新通用解题思路
      const [mainSolution] = await db.query(
        'SELECT id FROM solution_main WHERE problem_id = ?',
        [problemId]
      );
      
      if (!mainSolution || mainSolution.length === 0) {
        await db.query('ROLLBACK');
        return res.status(404).json({
          code: 404,
          message: '未找到题目的解答信息'
        });
      }
      
      // 更新解题思路
      await db.query(
        'UPDATE solution_main SET solution_approach = ? WHERE id = ?',
        [solution_approach, mainSolution[0].id]
      );
      
      // 获取语言ID映射
      const [languageRows] = await db.query('SELECT id, language_name FROM solution_languages');
      const languageMap = {};
      languageRows.forEach(row => {
        languageMap[row.language_name] = row.id;
      });
      
      // 更新各语言的解答代码
      const languageSolutions = [
        { language: 'c', code: solutions.c },
        { language: 'cpp', code: solutions.cpp },
        { language: 'java', code: solutions.java },
        { language: 'python', code: solutions.python }
      ];
      
      for (const solution of languageSolutions) {
        const languageId = languageMap[solution.language];
        if (!languageId) {
          throw new Error(`未找到语言 ${solution.language} 的ID`);
        }
        
        await db.query(
          `UPDATE solution_code 
           SET standard_solution = ?, version = ?
           WHERE solution_id = ? AND language_id = ?`,
          [solution.code, '1.0', mainSolution[0].id, languageId]
        );
      }
      
      // 提交事务
      await db.query('COMMIT');
      
      console.log('题目解答更新成功');
      res.json({
        code: 200,
        message: '题目解答更新成功'
      });
    } catch (error) {
      // 如果过程中出现错误，回滚事务
      await db.query('ROLLBACK');
      throw error;
    }
  } catch (error) {
    console.error('更新题目解答失败:', error);
    res.status(500).json({
      code: 500,
      message: '更新题目解答失败'
    });
  }
});

// 获取特定语言的解答代码
router.get('/:id/solution/:langId', authenticateToken, async (req, res) => {
  const problemId = req.params.id;
  const languageId = req.params.langId;
  
  try {
    console.log('获取特定语言的解答代码:', { problemId, languageId });
    
    // 获取解答代码
    const [codes] = await db.query(
      `SELECT sc.standard_solution, sc.version
       FROM solution_code sc
       JOIN solution_main sm ON sc.solution_id = sm.id
       WHERE sm.problem_id = ? AND sc.language_id = ?`,
      [problemId, languageId]
    );
    
    if (!codes || codes.length === 0) {
      return res.status(404).json({
        code: 404,
        message: '未找到该语言的解答代码'
      });
    }
    
    res.json({
      code: 200,
      data: codes[0]
    });
  } catch (error) {
    console.error('获取解答代码失败:', error);
    res.status(500).json({
      code: 500,
      message: '获取解答代码失败'
    });
  }
});

// 删除题目
router.delete('/:id', authenticateToken, async (req, res) => {
  const problemId = req.params.id;
  
  try {
    console.log('开始删除题目:', problemId);
    
    // 开始事务
    await db.query('START TRANSACTION');
    
    try {
      // 获取要删除的题目信息
      const [problemInfo] = await db.query(
        'SELECT problem_number FROM problems WHERE id = ?',
        [problemId]
      );

      if (!problemInfo || problemInfo.length === 0) {
        await db.query('ROLLBACK');
        return res.status(404).json({
          code: 404,
          message: '未找到该题目'
        });
      }

      const deletedProblemNumber = problemInfo[0].problem_number;
      console.log('要删除的题目编号:', deletedProblemNumber);

      // 1. 删除题目集中的题目关系
      console.log('删除 problem_set_items 表数据...');
      await db.query(
        'DELETE FROM problem_set_items WHERE problem_id = ?',
        [problemId]
      );
      
      // 2. 删除题目分类关系（注意：使用 problem_set_id 而不是 problem_id）
      console.log('删除 problem_set_category_relations 表数据...');
      await db.query(
        'DELETE FROM problem_set_category_relations WHERE problem_set_id = ?',
        [problemId]
      );
      
      // 3. 删除学习路径中的题目关系
      console.log('删除 learning_path_problems 表数据...');
      await db.query(
        'DELETE FROM learning_path_problems WHERE problem_id = ?',
        [problemId]
      );
      
      // 4. 删除学习计划中的题目关系
      console.log('删除 learning_plan_problems 表数据...');
      await db.query(
        'DELETE FROM learning_plan_problems WHERE problem_id = ?',
        [problemId]
      );

      // 5. 删除题目解答（problem_solutions表）
      console.log('删除 problem_solutions 表数据...');
      await db.query(
        'DELETE FROM problem_solutions WHERE problem_id = ?',
        [problemId]
      );
      
      // 6. 删除题目解答代码
      console.log('删除 solution_code 表数据...');
      await db.query(
        `DELETE sc FROM solution_code sc
         JOIN solution_main sm ON sc.solution_id = sm.id
         WHERE sm.problem_id = ?`,
        [problemId]
      );
      
      // 7. 删除题目主要解答
      console.log('删除 solution_main 表数据...');
      await db.query(
        'DELETE FROM solution_main WHERE problem_id = ?',
        [problemId]
      );
      
      // 8. 删除用户题目状态
      console.log('删除 user_problem_status 表数据...');
      await db.query(
        'DELETE FROM user_problem_status WHERE problem_id = ?',
        [problemId]
      );
      
      // 9. 删除提交记录
      console.log('删除 submissions 表数据...');
      await db.query(
        'DELETE FROM submissions WHERE problem_id = ?',
        [problemId]
      );

      // 10. 删除测试用例
      console.log('删除 test_cases 表数据...');
      await db.query(
        'DELETE FROM test_cases WHERE problem_id = ?',
        [problemId]
      );
      
      // 11. 删除题目本身
      console.log('删除 problems 表数据...');
      const [result] = await db.query(
        'DELETE FROM problems WHERE id = ?',
        [problemId]
      );
      
      if (result.affectedRows === 0) {
        await db.query('ROLLBACK');
        return res.status(404).json({
          code: 404,
          message: '未找到该题目'
        });
      }

      // 12. 更新其他题目的编号
      console.log('更新其他题目的编号...');
      await db.query(
        `UPDATE problems 
         SET problem_number = LPAD(
           CAST(
             CAST(SUBSTRING(problem_number, 1) AS UNSIGNED) - 1 
             AS CHAR(4)
           ), 
           4, 
           '0'
         )
         WHERE CAST(SUBSTRING(problem_number, 1) AS UNSIGNED) > ?`,
        [parseInt(deletedProblemNumber)]
      );
      
      // 提交事务
      await db.query('COMMIT');
      
      console.log('题目删除成功');
      res.json({
        code: 200,
        message: '题目删除成功'
      });
    } catch (error) {
      // 如果过程中出现错误，回滚事务
      await db.query('ROLLBACK');
      throw error;
    }
  } catch (error) {
    console.error('删除题目失败:', error);
    res.status(500).json({
      code: 500,
      message: '删除题目失败',
      error: error.message
    });
  }
});

// 重新排序题目编号
router.post('/reorder', authenticateToken, async (req, res) => {
  try {

    
    console.log('开始重新排序题目编号...');
    
    // 开始事务
    await db.query('START TRANSACTION');
    
    try {
      // 获取所有题目，按照id排序
      const [problems] = await db.query(
        'SELECT id FROM problems ORDER BY CAST(problem_number AS UNSIGNED)'
      );
      
      console.log('获取到的题目数量:', problems.length);
      
      // 更新每个题目的编号
      for (let i = 0; i < problems.length; i++) {
        const newProblemNumber = String(i + 1).padStart(4, '0');
        console.log(`更新题目 ${problems[i].id} 的编号为 ${newProblemNumber}`);
        
        await db.query(
          'UPDATE problems SET problem_number = ? WHERE id = ?',
          [newProblemNumber, problems[i].id]
        );
      }
      
      // 提交事务
      await db.query('COMMIT');
      
      console.log('题目编号重新排序完成');
      res.json({
        code: 200,
        message: '题目编号重新排序成功'
      });
    } catch (error) {
      // 如果过程中出现错误，回滚事务
      await db.query('ROLLBACK');
      throw error;
    }
  } catch (error) {
    console.error('重新排序题目编号失败:', error);
    res.status(500).json({
      code: 500,
      message: '重新排序题目编号失败',
      error: error.message
    });
  }
});

// 创建新题目
router.post('/create', authenticateToken, async (req, res) => {
  const { 
    title, 
    difficulty, 
    tags, 
    description, 
    time_limit, 
    memory_limit,
    solution_approach,
    time_complexity,
    space_complexity,
    solutions,
    test_cases
  } = req.body;

  try {
    // 获取最新的题目编号
    const [latestProblems] = await db.query(
      'SELECT problem_number FROM problems ORDER BY problem_number DESC LIMIT 1'
    );
    
    let nextNumber = '0001';
    if (latestProblems.length > 0) {
      const latestNumber = parseInt(latestProblems[0].problem_number);
      nextNumber = (latestNumber + 1).toString().padStart(4, '0');
    }

    console.log('创建新题目，编号:', nextNumber);

    // 开始事务
    await db.query('START TRANSACTION');

    try {
      // 插入题目基本信息
      const [result] = await db.query(
        `INSERT INTO problems (
          problem_number, title, difficulty, tags, 
          description, time_limit, memory_limit,
          total_submissions, acceptance_rate, accepted_submissions
        ) VALUES (?, ?, ?, ?, ?, ?, ?, 0, 0.00, 0)`,
        [nextNumber, title, difficulty, tags, description, time_limit, memory_limit]
      );

      const problemId = result.insertId;

      // 插入题目解答到solution_main表
      const [solutionMainResult] = await db.query(
        `INSERT INTO solution_main (
          problem_id, solution_approach, time_complexity, space_complexity
        ) VALUES (?, ?, ?, ?)`,
        [problemId, solution_approach, time_complexity, space_complexity]
      );

      // 获取语言ID映射
      const [languageRows] = await db.query('SELECT id, language_name FROM solution_languages');
      const languageMap = {};
      languageRows.forEach(row => {
        languageMap[row.language_name] = row.id;
      });

      // 插入各语言的答案到solution_code表
      const solutionMainId = solutionMainResult.insertId;
      for (const lang of Object.keys(solutions)) {
        const languageId = languageMap[lang];
        if (!languageId) {
          throw new Error(`未找到语言 ${lang} 的ID`);
        }

        await db.query(
          `INSERT INTO solution_code (
            solution_id, language_id, standard_solution
          ) VALUES (?, ?, ?)`,
          [solutionMainId, languageId, solutions[lang]]
        );
      }

      // 插入测试用例
      if (Array.isArray(test_cases) && test_cases.length > 0) {
        const testCaseValues = test_cases.map(tc => [
          problemId,
          nextNumber,
          tc.input,
          tc.output,
          tc.is_example ? 1 : 0,
          tc.order_num
        ]);

        await db.query(
          `INSERT INTO problem_test_cases 
           (problem_id, problem_number, input, output, is_example, order_num)
           VALUES ?`,
          [testCaseValues]
        );
      }

      // 提交事务
      await db.query('COMMIT');

      res.status(201).json({
        code: 201,
        message: '题目创建成功',
        data: {
          id: problemId,
          problem_number: nextNumber
        }
      });
    } catch (error) {
      // 如果出现错误，回滚事务
      await db.query('ROLLBACK');
      throw error;
    }
  } catch (error) {
    console.error('创建题目失败:', error);
    res.status(500).json({
      code: 500,
      message: '创建题目失败'
    });
  }
});

// 获取题目的测试用例
router.get('/:id/test-cases', async (req, res) => {
  const problemId = req.params.id;
  console.log('获取题目测试用例, problemId:', problemId);
  
  try {
    // 首先尝试通过 problem_number 查询题目
    let [problems] = await db.query(
      'SELECT id FROM problems WHERE problem_number = ?', 
      [problemId]
    );
    
    // 如果没找到，再尝试通过 id 查询
    if (!problems || problems.length === 0) {
      [problems] = await db.query(
        'SELECT id FROM problems WHERE id = ?', 
        [parseInt(problemId)]
      );
    }
    
    if (!problems || problems.length === 0) {
      return res.status(404).json({
        code: 404,
        message: '未找到该题目'
      });
    }

    const actualProblemId = problems[0].id;
    
    // 获取题目的所有测试用例
    const [testCases] = await db.query(
      `SELECT id, input, output, is_example, order_num 
       FROM problem_test_cases 
       WHERE problem_id = ? OR problem_number = ?
       ORDER BY order_num`,
      [actualProblemId, problemId]
    );

    console.log(`找到 ${testCases.length} 个测试用例`);
    
    res.json({
      code: 200,
      data: testCases
    });
  } catch (error) {
    console.error('获取题目测试用例失败:', error);
    res.status(500).json({
      code: 500,
      message: '获取题目测试用例失败'
    });
  }
});

// 更新题目的测试用例
router.put('/:id/test-cases', async (req, res) => {
  const problemId = req.params.id;
  const { test_cases } = req.body;
  
  console.log('更新题目测试用例:', {
    problemId,
    testCasesCount: test_cases?.length
  });
  
  if (!Array.isArray(test_cases)) {
    return res.status(400).json({
      code: 400,
      message: '测试用例数据格式错误'
    });
  }

  try {
    // 首先尝试通过 problem_number 查询题目
    let [problems] = await db.query(
      'SELECT id FROM problems WHERE problem_number = ?', 
      [problemId]
    );
    
    // 如果没找到，再尝试通过 id 查询
    if (!problems || problems.length === 0) {
      [problems] = await db.query(
        'SELECT id FROM problems WHERE id = ?', 
        [parseInt(problemId)]
      );
    }
    
    if (!problems || problems.length === 0) {
      return res.status(404).json({
        code: 404,
        message: '未找到该题目'
      });
    }

    const actualProblemId = problems[0].id;

    // 开始事务
    await db.query('START TRANSACTION');

    try {
      // 1. 删除原有的测试用例
      await db.query(
        'DELETE FROM problem_test_cases WHERE problem_id = ? OR problem_number = ?',
        [actualProblemId, problemId]
      );

      // 2. 插入新的测试用例
      if (test_cases.length > 0) {
        const values = test_cases.map(tc => [
          actualProblemId,
          problemId,
          tc.input,
          tc.output,
          tc.is_example ? 1 : 0,
          tc.order_num
        ]);

        await db.query(
          `INSERT INTO problem_test_cases 
           (problem_id, problem_number, input, output, is_example, order_num)
           VALUES ?`,
          [values]
        );
      }

      // 提交事务
      await db.query('COMMIT');
      
      console.log('测试用例更新成功');
      res.json({
        code: 200,
        message: '测试用例更新成功'
      });
    } catch (error) {
      // 如果出错，回滚事务
      await db.query('ROLLBACK');
      throw error;
    }
  } catch (error) {
    console.error('更新题目测试用例失败:', error);
    res.status(500).json({
      code: 500,
      message: '更新题目测试用例失败'
    });
  }
});

module.exports = router;