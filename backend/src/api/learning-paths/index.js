const express = require('express');
const router = express.Router();
const db = require('../../db');
const { authenticateToken } = require('../../middleware/auth');

// 获取当前用户的学习路径
router.get('/current', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取当前用户学习路径, userId:', userId);

    // 获取用户当前的学习路径
    const query = `
      SELECT 
        lp.*,
        COUNT(DISTINCT s.problem_id) as completed_count,
        (SELECT COUNT(*) FROM learning_path_problems WHERE path_id = lp.id) as total_problems
      FROM learning_paths lp
      LEFT JOIN learning_path_problems lpp ON lp.id = lpp.path_id
      LEFT JOIN submissions s ON lpp.problem_id = s.problem_id 
        AND s.user_id = ? 
        AND s.status = 'Accepted'
      WHERE lp.user_id = ?
      GROUP BY lp.id
      ORDER BY lp.created_at DESC
      LIMIT 1
    `;

    console.log('执行查询:', query);
    const [paths] = await db.query(query, [userId, userId]);
    console.log('查询结果:', paths);

    if (!paths || paths.length === 0) {
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
          current_stage: 0,
          total_stages: 0,
          completed_count: 0,
          total_problems: 0
        }
      });
    }

    // 处理返回数据
    const pathData = {
      ...paths[0],
      points: paths[0].points || JSON.stringify([
        '系统学习算法基础',
        '掌握常见数据结构',
        '提高编程能力'
      ]),
      icon: paths[0].icon || '/icons/algorithm.png',
      tag: paths[0].tag || '算法'
    };

    console.log('返回数据:', pathData);

    res.json({
      success: true,
      data: pathData
    });
  } catch (error) {
    console.error('获取当前学习路径失败:', error);
    res.status(500).json({
      success: false,
      message: '获取当前学习路径失败'
    });
  }
});

// 获取当前学习路径的题目
router.get('/current/problems', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取当前学习路径题目, userId:', userId);

    // 首先获取用户当前的学习路径ID
    const pathQuery = `
      SELECT id 
      FROM learning_paths 
      WHERE user_id = ? 
      ORDER BY created_at DESC 
      LIMIT 1
    `;
    const [paths] = await db.query(pathQuery, [userId]);
    
    if (!paths || paths.length === 0) {
      return res.json({
        success: true,
        data: []
      });
    }

    const pathId = paths[0].id;

    // 获取该学习路径的所有题目
    const problemsQuery = `
      SELECT 
        p.*,
        lpp.order_index,
        COALESCE(s.status, 'Not Started') as status
      FROM learning_path_problems lpp
      JOIN problems p ON lpp.problem_id = p.id
      LEFT JOIN (
        SELECT problem_id, status
        FROM submissions
        WHERE user_id = ?
        AND status = 'Accepted'
        GROUP BY problem_id
      ) s ON p.id = s.problem_id
      WHERE lpp.path_id = ?
      ORDER BY lpp.order_index
    `;

    console.log('执行题目查询:', problemsQuery);
    const [problems] = await db.query(problemsQuery, [userId, pathId]);
    console.log('查询到的题目数:', problems.length);

    res.json({
      success: true,
      data: problems.map(problem => ({
        ...problem,
        tags: problem.tags ? problem.tags.split(',').map(tag => tag.trim()) : [],
        acceptance_rate: parseFloat(problem.acceptance_rate) || 0,
        total_submissions: parseInt(problem.total_submissions) || 0,
        order_index: problem.order_index || 0
      }))
    });
  } catch (error) {
    console.error('获取学习路径题目失败:', error);
    res.status(500).json({
      success: false,
      message: '获取学习路径题目失败'
    });
  }
});

module.exports = router; 