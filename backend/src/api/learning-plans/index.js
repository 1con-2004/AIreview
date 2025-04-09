const express = require('express');
const router = express.Router();
const db = require('../../db');
const { authenticateToken } = require('../../middleware/auth');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = path.join(__dirname, '../../../../frontend/public/icons');
    console.log('上传目录:', uploadDir);
    // 确保上传目录存在
    if (!fs.existsSync(uploadDir)) {
      console.log('创建上传目录');
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    console.log('上传的文件:', file);
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const filename = uniqueSuffix + path.extname(file.originalname);
    console.log('生成的文件名:', filename);
    cb(null, filename);
  }
});

const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 限制5MB
  },
  fileFilter: (req, file, cb) => {
    console.log('文件类型验证:', file.mimetype);
    const allowedTypes = /jpeg|jpg|png|gif/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    
    if (extname && mimetype) {
      return cb(null, true);
    }
    
    console.error('文件类型不支持:', file.mimetype);
    cb(new Error('只支持图片文件!'));
  }
});

// 获取所有学习计划
router.get('/', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const { all } = req.query; // 获取查询参数
    console.log('获取用户学习计划, userId:', userId, '获取所有计划:', all);

    // 获取用户角色信息
    const [userRows] = await db.query(
      `SELECT role FROM users WHERE id = ?`,
      [userId]
    );
    
    const userRole = userRows.length > 0 ? userRows[0].role : 'normal';
    console.log('用户角色:', userRole);

    let query;
    let params;

    if (all === 'true') {
      // 获取所有学习计划，不受用户角色限制
      console.log('获取所有学习计划');
      query = `
        SELECT lp.*, u.username as creator_name
        FROM learning_plans lp
        JOIN users u ON lp.user_id = u.id
        ORDER BY lp.created_at DESC
      `;
      params = [];
    } else {
      // 只获取当前用户创建的学习计划
      console.log('只获取用户自己的学习计划');
      query = `
        SELECT * FROM learning_plans 
        WHERE user_id = ? 
        ORDER BY created_at DESC
      `;
      params = [userId];
    }

    console.log('执行查询:', query, '参数:', params);
    const [plans] = await db.query(query, params);
    console.log('查询结果数量:', plans.length);

    res.json({
      success: true,
      data: plans
    });
  } catch (error) {
    console.error('获取学习计划失败:', error);
    res.status(500).json({
      success: false,
      message: '获取学习计划失败'
    });
  }
});

// 获取特定学习计划
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    console.log('获取特定学习计划, planId:', id, 'userId:', userId); // 添加日志

    // 修改查询，允许所有用户查看任何学习计划
    const [plans] = await db.query(
      `SELECT lp.*, 
              u.username as creator_name,
              lpp.problem_id, 
              lpp.order_index, 
              lpp.section 
       FROM learning_plans lp
       JOIN users u ON lp.user_id = u.id
       LEFT JOIN learning_plan_problems lpp ON lp.id = lpp.plan_id
       WHERE lp.id = ?`,
      [id]
    );

    // 打印查询结果
    console.log('查询到的学习计划:', plans); // 打印从数据库获取的学习计划数据

    if (!plans || plans.length === 0) {
      return res.status(404).json({
        success: false,
        message: '学习计划不存在'
      });
    }

    // 处理返回数据，提取问题信息
    const planData = {
      ...plans[0],
      problems: plans.map(p => ({
        problem_id: p.problem_id,
        order_index: p.order_index,
        section: p.section
      })).filter(p => p.problem_id) // 过滤掉没有问题的记录
    };

    res.json({
      success: true,
      data: planData
    });
  } catch (error) {
    console.error('获取特定学习计划失败:', error);
    res.status(500).json({
      success: false,
      message: '获取特定学习计划失败'
    });
  }
});

// 创建学习计划
router.post('/', authenticateToken, async (req, res) => {
  console.log('请求体:', req.body); // 添加日志以调试请求体
  try {
    const { title, description, tagsInput, points, estimated_days, problems, difficulty_level } = req.body; // 确保提取必要字段

    console.log('标题:', title);
    console.log('描述:', description);
    console.log('计划时长:', estimated_days);
    
    // 确保 tagsInput 是字符串
    if (Array.isArray(tagsInput)) {
      return res.status(400).json({
        success: false,
        message: '标签输入必须是字符串'
      });
    }

    const tags = tagsInput.split(',').map(t => t.trim()).filter(t => t);
    
    // 确保必要字段不为空
    if (!title || !description || !estimated_days) {
      return res.status(400).json({
        success: false,
        message: '标题、描述和计划时长是必填项'
      });
    }

    // 直接使用 points，确保它是一个字符串
    const pointsString = points; // 直接使用 points

    const [result] = await db.query(
      `INSERT INTO learning_plans (title, description, estimated_days, points, tag, user_id, difficulty_level) 
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [title, description, estimated_days, pointsString, tags.join(','), req.user.id, difficulty_level] // 添加 difficulty_level
    );

    // 处理题目管理部分
    if (problems && problems.length > 0) {
      const values = problems.map(p => [result.insertId, p.problem_id, p.order_index, p.section]);
      await db.query(
        `INSERT INTO learning_plan_problems (plan_id, problem_id, order_index, section) 
         VALUES ?`,
        [values]
      );
    }

    res.json({
      success: true,
      data: {
        id: result.insertId,
        title,
        description,
        estimated_days,
        points: pointsString,
        tag: tags.join(',')
      }
    });
  } catch (error) {
    console.error('创建学习计划失败:', error);
    res.status(500).json({
      success: false,
      message: '创建学习计划失败'
    });
  }
});

// 更新学习计划
router.put('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    const { tagsInput, difficulty_level, ...rest } = req.body; // 提取 difficulty_level

    // 确保 rest 中包含必要的字段
    if (!rest.title || !rest.description) {
      return res.status(400).json({
        success: false,
        message: '缺少必要的字段'
      });
    }

    const tag = tagsInput.split(',').map(t => t.trim()).filter(t => t).join(','); // 使用单数形式的 tag
    
    console.log('更新学习计划, planId:', id, 'userId:', userId);

    // 检查计划是否存在且属于该用户
    const [plans] = await db.query(
      `SELECT * FROM learning_plans 
       WHERE id = ? AND user_id = ?`,
      [id, userId]
    );

    if (!plans || plans.length === 0) {
      return res.status(404).json({
        success: false,
        message: '学习计划不存在或无权修改'
      });
    }

    // 直接获取要点描述
    const pointsString = rest.points; // 直接使用 points

    await db.query(
      `UPDATE learning_plans 
       SET title = ?, description = ?, points = ?, tag = ?, difficulty_level = ? 
       WHERE id = ? AND user_id = ?`,
      [rest.title, rest.description, pointsString, tag, difficulty_level, id, userId] // 添加 difficulty_level
    );

    res.json({
      success: true,
      data: { id }, // 返回更新后的学习计划 ID
      message: '学习计划已更新'
    });
  } catch (error) {
    console.error('更新学习计划失败:', error);
    res.status(500).json({
      success: false,
      message: '更新学习计划失败'
    });
  }
});

// 删除学习计划
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    console.log('删除学习计划, planId:', id, 'userId:', userId);

    // 检查计划是否存在且属于该用户
    const [plans] = await db.query(
      `SELECT * FROM learning_plans 
       WHERE id = ? AND user_id = ?`,
      [id, userId]
    );

    if (!plans || plans.length === 0) {
      return res.status(404).json({
        success: false,
        message: '学习计划不存在或无权删除'
      });
    }

    await db.query(
      'DELETE FROM learning_plans WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    res.json({
      success: true,
      message: '学习计划已删除'
    });
  } catch (error) {
    console.error('删除学习计划失败:', error);
    res.status(500).json({
      success: false,
      message: '删除学习计划失败'
    });
  }
});

// 获取学习计划的题目列表
router.get('/:id/problems', authenticateToken, async (req, res) => {
  try {
    const planId = req.params.id;
    const userId = req.user.id;
    
    console.log('获取学习计划题目, planId:', planId, 'userId:', userId);

    // 获取学习计划题目，同时获取用户的完成状态
    const query = `
      SELECT 
        p.*,
        COALESCE(s.status, 'Not Started') as status
      FROM learning_plan_problems lpp
      JOIN problems p ON lpp.problem_id = p.id
      LEFT JOIN (
        SELECT problem_id, status
        FROM submissions
        WHERE user_id = ?
        AND status = 'Accepted'
        GROUP BY problem_id
      ) s ON p.id = s.problem_id
      WHERE lpp.plan_id = ?
      ORDER BY lpp.order_index
    `;

    const [problems] = await db.query(query, [userId, planId]);

    console.log('查询到的题目数据:', problems);

    res.json({
      success: true,
      data: problems.map(problem => ({
        ...problem,
        tags: problem.tags ? problem.tags.split(',').map(tag => tag.trim()) : [],
        acceptance_rate: parseFloat(problem.acceptance_rate) || 0,
        total_submissions: parseInt(problem.total_submissions) || 0
      }))
    });
  } catch (error) {
    console.error('获取学习计划题目失败:', error);
    res.status(500).json({
      success: false,
      message: '获取学习计划题目失败'
    });
  }
});

// 获取用户学习进度
router.get('/:id/progress', authenticateToken, async (req, res) => {
  try {
    const planId = req.params.id;
    const userId = req.user.id;
    
    console.log('获取用户学习进度, planId:', planId, 'userId:', userId);

    // 获取用户在该学习计划中已完成的题目
    const query = `
      SELECT 
        lp.id as plan_id,
        lp.title as plan_title,
        COUNT(DISTINCT s.problem_id) as completed_count,
        COUNT(DISTINCT lpp.problem_id) as total_problems,
        GROUP_CONCAT(DISTINCT s.problem_id) as completed_problems
      FROM learning_plans lp
      JOIN learning_plan_problems lpp ON lp.id = lpp.plan_id
      LEFT JOIN submissions s ON lpp.problem_id = s.problem_id 
        AND s.user_id = ? 
        AND s.status = 'Accepted'
      WHERE lp.id = ?
      GROUP BY lp.id
    `;

    const [progress] = await db.query(query, [userId, planId]);
    
    if (!progress || progress.length === 0) {
      return res.json({
        success: true,
        data: {
          completed_problems: [],
          completed_count: 0,
          total_problems: 0
        }
      });
    }

    const userProgress = {
      ...progress[0],
      completed_problems: progress[0].completed_problems 
        ? progress[0].completed_problems.split(',').map(id => parseInt(id))
        : []
    };

    console.log('用户进度数据:', userProgress);

    res.json({
      success: true,
      data: userProgress
    });
  } catch (error) {
    console.error('获取用户进度失败:', error);
    res.status(500).json({
      success: false,
      message: '获取用户进度失败'
    });
  }
});

// 开始学习计划
router.post('/:id/start', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    console.log('开始学习计划, planId:', id, 'userId:', userId);

    // 检查是否已经有进度记录
    const [existingProgress] = await db.query(
      `SELECT * FROM user_learning_plan_progress
       WHERE user_id = ? AND plan_id = ?`,
      [userId, id]
    );

    if (existingProgress && existingProgress.length > 0) {
      return res.json({
        success: true,
        data: existingProgress[0]
      });
    }

    // 创建新的进度记录
    const [result] = await db.query(
      `INSERT INTO user_learning_plan_progress (user_id, plan_id, completed_problems, started_at)
       VALUES (?, ?, '[]', NOW())`,
      [userId, id]
    );

    res.json({
      success: true,
      data: {
        id: result.insertId,
        user_id: userId,
        plan_id: id,
        completed_problems: [],
        started_at: new Date()
      }
    });
  } catch (error) {
    console.error('开始学习计划失败:', error);
    res.status(500).json({
      success: false,
      message: '开始学习计划失败'
    });
  }
});

// 获取当前用户的学习计划
router.get('/current', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取当前用户学习计划, userId:', userId);

    // 获取用户当前的学习计划
    const query = `
      SELECT 
        lp.*,
        COUNT(DISTINCT s.problem_id) as completed_count,
        (SELECT COUNT(*) FROM learning_plan_problems WHERE plan_id = lp.id) as total_problems
      FROM learning_plans lp
      LEFT JOIN learning_plan_problems lpp ON lp.id = lpp.plan_id
      LEFT JOIN submissions s ON lpp.problem_id = s.problem_id 
        AND s.user_id = ? 
        AND s.status = 'Accepted'
      WHERE lp.user_id = ?
      GROUP BY lp.id
      ORDER BY lp.created_at DESC
      LIMIT 1
    `;

    console.log('执行查询:', query);
    const [plans] = await db.query(query, [userId, userId]);
    console.log('查询结果:', plans);

    if (!plans || plans.length === 0) {
      return res.json({
        success: true,
        data: {
          id: null,
          title: '默认学习计划',
          description: '开始你的学习之旅',
          tag: '算法',
          icon: '/icons/algorithm.png',
          points: JSON.stringify([
            '系统学习算法基础',
            '掌握常见数据结构',
            '提高编程能力'
          ]),
          completed_count: 0,
          total_problems: 0
        }
      });
    }

    // 处理返回数据
    const planData = {
      ...plans[0],
      points: plans[0].points || JSON.stringify([
        '系统学习算法基础',
        '掌握常见数据结构',
        '提高编程能力'
      ]),
      icon: plans[0].icon || '/icons/algorithm.png',
      tag: plans[0].tag || '算法'
    };

    console.log('返回数据:', planData);

    res.json({
      success: true,
      data: planData
    });
  } catch (error) {
    console.error('获取当前学习计划失败:', error);
    res.status(500).json({
      success: false,
      message: '获取当前学习计划失败'
    });
  }
});

// 获取当前学习计划的题目
router.get('/current/problems', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取当前学习计划题目, userId:', userId);

    // 首先获取用户当前的学习计划ID
    const planQuery = `
      SELECT id 
      FROM learning_plans 
      WHERE user_id = ? 
      ORDER BY created_at DESC 
      LIMIT 1
    `;
    const [plans] = await db.query(planQuery, [userId]);
    
    if (!plans || plans.length === 0) {
      return res.json({
        success: true,
        data: []
      });
    }

    const planId = plans[0].id;

    // 获取该学习计划的所有题目
    const problemsQuery = `
      SELECT 
        p.*,
        lpp.order_index,
        lpp.section,
        COALESCE(s.status, 'Not Started') as status
      FROM learning_plan_problems lpp
      JOIN problems p ON lpp.problem_id = p.id
      LEFT JOIN (
        SELECT problem_id, status
        FROM submissions
        WHERE user_id = ?
        AND status = 'Accepted'
        GROUP BY problem_id
      ) s ON p.id = s.problem_id
      WHERE lpp.plan_id = ?
      ORDER BY lpp.order_index
    `;

    console.log('执行题目查询:', problemsQuery);
    const [problems] = await db.query(problemsQuery, [userId, planId]);
    console.log('查询到的题目数:', problems.length);

    res.json({
      success: true,
      data: problems.map(problem => ({
        ...problem,
        tags: problem.tags ? problem.tags.split(',').map(tag => tag.trim()) : [],
        acceptance_rate: parseFloat(problem.acceptance_rate) || 0,
        total_submissions: parseInt(problem.total_submissions) || 0,
        order_index: problem.order_index || 0,
        section: problem.section || ''
      }))
    });
  } catch (error) {
    console.error('获取学习计划题目失败:', error);
    res.status(500).json({
      success: false,
      message: '获取学习计划题目失败'
    });
  }
});

// 获取学习计划进度
router.get('/:id/progress', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    console.log('获取用户学习进度, planId:', id, 'userId:', userId);

    // 获取计划信息和完成情况
    const query = `
      SELECT 
        lp.id as plan_id,
        lp.title as plan_title,
        COUNT(DISTINCT s.problem_id) as completed_count,
        (SELECT COUNT(*) FROM learning_plan_problems WHERE plan_id = lp.id) as total_problems,
        JSON_ARRAYAGG(DISTINCT s.problem_id) as completed_problems
      FROM learning_plans lp
      LEFT JOIN learning_plan_problems lpp ON lp.id = lpp.plan_id
      LEFT JOIN submissions s ON lpp.problem_id = s.problem_id 
        AND s.user_id = ? 
        AND s.status = 'Accepted'
      WHERE lp.id = ?
      GROUP BY lp.id
    `;

    const [progress] = await db.query(query, [userId, id]);
    
    if (!progress || progress.length === 0) {
      return res.status(404).json({
        success: false,
        message: '学习计划不存在'
      });
    }

    // 处理返回数据
    const progressData = {
      ...progress[0],
      completed_problems: progress[0].completed_problems || []
    };

    console.log('用户进度数据:', progressData);

    res.json({
      success: true,
      data: progressData
    });
  } catch (error) {
    console.error('获取用户进度失败:', error);
    res.status(500).json({
      success: false,
      message: '获取用户进度失败'
    });
  }
});

// 获取学习计划统计信息
router.get('/stats', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取学习计划统计信息, userId:', userId);

    const [result] = await db.query(
      `SELECT COUNT(*) AS totalPlans
       FROM learning_plans 
       WHERE user_id = ?`,
      [userId]
    );

    console.log('统计结果:', result[0]);

    res.json({
      success: true,
      data: {
        totalPlans: parseInt(result[0].totalPlans) || 0
      }
    });
  } catch (error) {
    console.error('获取学习计划统计信息失败:', error);
    res.status(500).json({
      success: false,
      message: '获取学习计划统计信息失败'
    });
  }
});

// 更新学习计划题目
router.put('/:id/problems', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    const { problems } = req.body; // [{problem_id, order_index, section}]
    
    console.log('更新学习计划题目, planId:', id, 'userId:', userId);

    // 验证学习计划所有权
    const [plan] = await db.query(
      'SELECT * FROM learning_plans WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    if (!plan || plan.length === 0) {
      return res.status(404).json({
        success: false,
        message: '学习计划不存在或无权修改'
      });
    }

    // 开启事务
    await db.query('START TRANSACTION');

    try {
      // 删除原有题目
      await db.query('DELETE FROM learning_plan_problems WHERE plan_id = ?', [id]);

      // 插入新题目
      if (problems && problems.length > 0) {
        const values = problems.map(p => [id, p.problem_id, p.order_index, p.section]);
        await db.query(
          `INSERT INTO learning_plan_problems (plan_id, problem_id, order_index, section) 
           VALUES ?`,
          [values]
        );
      }

      await db.query('COMMIT');
      
      res.json({
        success: true,
        message: '学习计划题目已更新'
      });
    } catch (error) {
      await db.query('ROLLBACK');
      throw error;
    }
  } catch (error) {
    console.error('更新学习计划题目失败:', error);
    res.status(500).json({
      success: false,
      message: '更新学习计划题目失败'
    });
  } 
});

// 新增获取题目标题的 API
router.get('/problems/:problem_number', authenticateToken, async (req, res) => {
  try {
    const { problem_number } = req.params;
    console.log('获取题目标题, problemNumber:', problem_number);

    // 将 problem_number 转换为字符串格式，确保前导零被保留
    const problemNumberStr = problem_number.padStart(4, '0'); // 假设问题编号总是4位

    const [problem] = await db.query(
      `SELECT title FROM problems WHERE problem_number = ?`,
      [problemNumberStr] // 使用转换后的字符串进行查询
    );

    console.log('获取题目标题, problem:', problem); // 添加日志以调试

    if (!problem || problem.length === 0) {
      return res.status(404).json({
        success: false,
        message: '题目不存在'
      });
    }

    res.json({
      success: true,
      data: problem[0].title
    });
  } catch (error) {
    console.error('获取题目标题失败:', error);
    res.status(500).json({
      success: false,
      message: '获取题目标题失败'
    });
  }
});

// 新增上传学习计划图标的 API
router.post('/:id/icon', authenticateToken, (req, res, next) => {
  console.log('接收到上传请求');
  console.log('请求参数:', req.params);
  console.log('请求头:', req.headers);
  
  upload.single('icon')(req, res, (err) => {
    if (err) {
      console.error('文件上传错误:', err);
      return res.status(400).json({
        success: false,
        message: err.message || '文件上传失败'
      });
    }
    
    if (!req.file) {
      console.error('没有接收到文件');
      return res.status(400).json({
        success: false,
        message: '请选择要上传的文件'
      });
    }
    
    next();
  });
}, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    
    console.log('处理文件上传:', {
      planId: id,
      userId: userId,
      file: req.file
    });
    
    // 检查计划是否存在且属于该用户
    const [plan] = await db.query(
      'SELECT * FROM learning_plans WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    if (!plan || plan.length === 0) {
      // 如果文件已上传，删除它
      if (req.file) {
        console.log('删除无效的上传文件');
        fs.unlinkSync(req.file.path);
      }
      return res.status(404).json({
        success: false,
        message: '学习计划不存在或无权修改'
      });
    }

    // 获取旧图标路径
    const oldIconPath = plan[0].icon;
    if (oldIconPath) {
      const fullOldPath = path.join(__dirname, '../../../../frontend/public', oldIconPath);
      console.log('尝试删除旧图标:', fullOldPath);
      // 尝试删除旧图标
      try {
        if (fs.existsSync(fullOldPath)) {
          fs.unlinkSync(fullOldPath);
          console.log('成功删除旧图标');
        }
      } catch (err) {
        console.error('删除旧图标失败:', err);
      }
    }

    const iconPath = `/icons/${req.file.filename}`;
    console.log('新图标路径:', iconPath);

    // 更新数据库中的图标路径
    await db.query(
      'UPDATE learning_plans SET icon = ? WHERE id = ? AND user_id = ?',
      [iconPath, id, userId]
    );

    console.log('学习计划图标更新成功:', {
      planId: id,
      userId: userId,
      newIconPath: iconPath
    });

    res.json({
      success: true,
      message: '学习计划图标已更新',
      data: { icon: iconPath }
    });
  } catch (error) {
    console.error('更新学习计划图标失败:', error);
    // 如果上传失败，删除已上传的文件
    if (req.file) {
      try {
        fs.unlinkSync(req.file.path);
        console.log('已删除失败的上传文件');
      } catch (err) {
        console.error('删除失败的上传文件时出错:', err);
      }
    }
    res.status(500).json({
      success: false,
      message: '更新学习计划图标失败'
    });
  }
});

module.exports = router; 