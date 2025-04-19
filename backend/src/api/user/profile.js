const express = require('express');
const router = express.Router();
const db = require('../../db');
const { authenticateToken } = require('../../middleware/auth');

/**
 * 检查用户是否为学生
 * 通过查询student_info表中是否存在对应用户ID的记录
 */
router.get('/check-student', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log(`[调试信息] 检查用户是否为学生API被调用，用户ID: ${userId}`);

    // 直接通过用户ID查询student_info表
    const [rows] = await db.query(
      'SELECT * FROM student_info WHERE user_id = ?',
      [userId]
    );

    const isStudent = rows.length > 0;
    const studentInfo = isStudent ? rows[0] : null;

    console.log(`[调试信息] 查询结果: 是否为学生=${isStudent}, 用户ID=${userId}`);
    if (isStudent) {
      console.log(`[调试信息] 学生信息: ${JSON.stringify(studentInfo)}`);
    }

    res.json({
      success: true,
      isStudent,
      studentInfo
    });
  } catch (error) {
    console.error('检查用户是否为学生失败:', error);
    res.status(500).json({
      success: false,
      message: '检查用户是否为学生失败',
      error: error.message
    });
  }
});

/**
 * 获取用户题目完成情况统计
 */
router.get('/completion', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取用户题目完成情况统计, userId:', userId);

    // 首先检查用户是否为学生
    const [studentCheck] = await db.query(
      'SELECT * FROM student_info WHERE user_id = ?',
      [userId]
    );

    if (studentCheck.length === 0) {
      return res.status(403).json({
        success: false,
        message: '您并未登记学生信息，请联系管理员添加'
      });
    }

    const [stats] = await db.query(`
      SELECT 
        (SELECT COUNT(*) FROM problems) as total_problems,
        COUNT(DISTINCT CASE WHEN s.status = 'Accepted' THEN s.problem_id END) as completed_problems,
        (
          SELECT COUNT(*) 
          FROM problems p 
          WHERE NOT EXISTS (
            SELECT 1 FROM submissions s2 
            WHERE s2.problem_id = p.id AND s2.user_id = ?
          )
        ) as not_attempted_problems,
        COUNT(DISTINCT CASE WHEN s.status != 'Accepted' THEN s.problem_id END) as failed_problems
      FROM submissions s
      WHERE s.user_id = ?
    `, [userId, userId]);

    return res.json({
      success: true,
      message: '获取用户题目完成情况统计成功',
      data: stats[0]
    });
  } catch (error) {
    console.error('获取用户题目完成情况统计失败:', error);
    return res.status(500).json({
      success: false,
      message: '获取用户题目完成情况统计失败',
      error: error.message
    });
  }
});

/**
 * 获取用户知识点掌握情况
 */
router.get('/knowledge', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取用户知识点掌握情况, userId:', userId);

    // 首先检查用户是否为学生
    const [studentCheck] = await db.query(
      'SELECT * FROM student_info WHERE user_id = ?',
      [userId]
    );

    if (studentCheck.length === 0) {
      return res.status(403).json({
        success: false,
        message: '您并未登记学生信息，请联系管理员添加'
      });
    }

    const [stats] = await db.query(`
      SELECT 
        p.tags as knowledge_point,
        COUNT(*) as total_problems,
        SUM(CASE WHEN s.status = 'Accepted' THEN 1 ELSE 0 END) as completed_problems,
        ROUND(
          SUM(CASE WHEN s.status = 'Accepted' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
          2
        ) as mastery_percentage
      FROM problems p
      LEFT JOIN submissions s ON p.id = s.problem_id AND s.user_id = ?
      WHERE p.tags IS NOT NULL AND p.tags != ''
      GROUP BY p.tags
      HAVING mastery_percentage > 0
      ORDER BY mastery_percentage DESC
      LIMIT 8
    `, [userId]);

    return res.json({
      success: true,
      message: '获取用户知识点掌握情况成功',
      data: stats
    });
  } catch (error) {
    console.error('获取用户知识点掌握情况失败:', error);
    return res.status(500).json({
      success: false,
      message: '获取用户知识点掌握情况失败',
      error: error.message
    });
  }
});

/**
 * 获取用户错误类型分析
 */
router.get('/error-types', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取用户错误类型分析, userId:', userId);

    // 首先检查用户是否为学生
    const [studentCheck] = await db.query(
      'SELECT * FROM student_info WHERE user_id = ?',
      [userId]
    );

    if (studentCheck.length === 0) {
      return res.status(403).json({
        success: false,
        message: '您并未登记学生信息，请联系管理员添加'
      });
    }

    const [stats] = await db.query(`
      SELECT 
        CASE 
          WHEN status = 'Runtime Error' AND error_message LIKE '%expected%' THEN '语法错误'
          WHEN status = 'Runtime Error' AND error_message LIKE '%segmentation fault%' THEN '段错误'
          WHEN status = 'Runtime Error' AND error_message LIKE '%timeout%' THEN '超时错误'
          WHEN status = 'System Error' THEN '系统错误'
          WHEN status = 'Wrong Answer' THEN '答案错误'
          ELSE '其他错误'
        END as error_type,
        COUNT(*) as count
      FROM submissions 
      WHERE user_id = ? AND status != 'Accepted'
      GROUP BY error_type
      ORDER BY count DESC
    `, [userId]);

    return res.json({
      success: true,
      message: '获取用户错误类型分析成功',
      data: stats
    });
  } catch (error) {
    console.error('获取用户错误类型分析失败:', error);
    return res.status(500).json({
      success: false,
      message: '获取用户错误类型分析失败',
      error: error.message
    });
  }
});

/**
 * 获取用户解题用时分析
 */
router.get('/solving-time', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取用户解题用时分析, userId:', userId);

    // 首先检查用户是否为学生
    const [studentCheck] = await db.query(
      'SELECT * FROM student_info WHERE user_id = ?',
      [userId]
    );

    if (studentCheck.length === 0) {
      return res.status(403).json({
        success: false,
        message: '您并未登记学生信息，请联系管理员添加'
      });
    }

    const [stats] = await db.query(`
      WITH FirstAttempts AS (
        SELECT 
          problem_id,
          MIN(created_at) as first_attempt
        FROM submissions
        WHERE user_id = ?
        GROUP BY problem_id
      ),
      SuccessfulAttempts AS (
        SELECT 
          problem_id,
          MIN(created_at) as success_time
        FROM submissions
        WHERE user_id = ? AND status = 'Accepted'
        GROUP BY problem_id
      )
      SELECT 
        p.difficulty,
        ROUND(AVG(
          CASE 
            WHEN TIMESTAMPDIFF(MINUTE, fa.first_attempt, sa.success_time) > 0 
            THEN TIMESTAMPDIFF(MINUTE, fa.first_attempt, sa.success_time)
            ELSE 1 
          END
        ), 2) as avg_time
      FROM problems p
      JOIN FirstAttempts fa ON p.id = fa.problem_id
      JOIN SuccessfulAttempts sa ON p.id = sa.problem_id
      GROUP BY p.difficulty
      ORDER BY 
        CASE p.difficulty
          WHEN '简单' THEN 1
          WHEN '中等' THEN 2
          WHEN '困难' THEN 3
        END
    `, [userId, userId]);

    return res.json({
      success: true,
      message: '获取用户解题用时分析成功',
      data: stats
    });
  } catch (error) {
    console.error('获取用户解题用时分析失败:', error);
    return res.status(500).json({
      success: false,
      message: '获取用户解题用时分析失败',
      error: error.message
    });
  }
});

/**
 * 获取用户题目完成状态列表
 */
router.get('/problems', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const { page = 1, pageSize = 10 } = req.query;
    const offset = (page - 1) * pageSize;
    
    console.log('获取用户题目完成状态列表:', { userId, page, pageSize });

    // 首先检查用户是否为学生
    const [studentCheck] = await db.query(
      'SELECT * FROM student_info WHERE user_id = ?',
      [userId]
    );

    if (studentCheck.length === 0) {
      return res.status(403).json({
        success: false,
        message: '您并未登记学生信息，请联系管理员添加'
      });
    }
    
    // 获取总数
    const [countResult] = await db.query(`
      SELECT COUNT(*) as total
      FROM problems
    `);
    
    const total = countResult[0].total;
    
    // 获取题目列表及完成情况
    const [problems] = await db.query(`
      SELECT 
        p.id,
        p.problem_number,
        p.title,
        p.difficulty,
        COALESCE(
          (SELECT status 
           FROM submissions s 
           WHERE s.user_id = ? AND s.problem_id = p.id 
           ORDER BY created_at DESC 
           LIMIT 1), 
          'Not Attempted'
        ) as status,
        (
          SELECT COUNT(*) 
          FROM submissions s 
          WHERE s.user_id = ? AND s.problem_id = p.id
        ) as submission_count,
        (
          SELECT created_at 
          FROM submissions s 
          WHERE s.user_id = ? AND s.problem_id = p.id 
          ORDER BY created_at DESC 
          LIMIT 1
        ) as last_submission_time,
        (
          SELECT created_at 
          FROM submissions s 
          WHERE s.user_id = ? AND s.problem_id = p.id 
          ORDER BY created_at ASC 
          LIMIT 1
        ) as first_submission_time,
        (
          SELECT AVG(runtime) 
          FROM submissions s 
          WHERE s.user_id = ? AND s.problem_id = p.id AND s.status = 'Accepted'
        ) as average_execution_time
      FROM problems p
      ORDER BY p.problem_number
      LIMIT ? OFFSET ?
    `, [userId, userId, userId, userId, userId, parseInt(pageSize), parseInt(offset)]);

    res.json({
      success: true,
      message: '获取用户题目完成状态列表成功',
      data: problems,
      total: total
    });
  } catch (error) {
    console.error('获取用户题目完成状态列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取用户题目完成状态列表失败',
      error: error.message
    });
  }
});

module.exports = router; 