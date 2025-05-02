const express = require('express');
const router = express.Router();
const db = require('../../db');

/**
 * 获取所有班级列表
 */
router.get('/classes', async (req, res) => {
  try {
    console.log('获取班级列表');
    const [classes] = await db.query(`
      SELECT id, class_name 
      FROM classes 
      ORDER BY class_name
    `);
    
    return res.json({
      code: 0,
      message: '获取班级列表成功',
      data: classes
    });
  } catch (error) {
    console.error('获取班级列表失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取班级列表失败'
    });
  }
});

/**
 * 获取所有院系列表
 */
router.get('/departments', async (req, res) => {
  try {
    console.log('获取院系列表');
    const [departments] = await db.query(`
      SELECT DISTINCT department 
      FROM student_info 
      WHERE department IS NOT NULL AND department != ''
      ORDER BY department
    `);
    
    return res.json({
      code: 0,
      message: '获取院系列表成功',
      data: departments.map(item => item.department)
    });
  } catch (error) {
    console.error('获取院系列表失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取院系列表失败'
    });
  }
});

/**
 * 获取所有年级列表
 */
router.get('/grades', async (req, res) => {
  try {
    console.log('获取年级列表');
    const [grades] = await db.query(`
      SELECT DISTINCT grade 
      FROM student_info 
      WHERE grade IS NOT NULL AND grade != ''
      ORDER BY grade DESC
    `);
    
    return res.json({
      code: 0,
      message: '获取年级列表成功',
      data: grades.map(item => item.grade)
    });
  } catch (error) {
    console.error('获取年级列表失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取年级列表失败'
    });
  }
});

/**
 * 获取学生列表及其题目完成情况
 */
router.get('/students', async (req, res) => {
  try {
    const { page = 1, pageSize = 10, search = '', classId = '' } = req.query;
    const offset = (page - 1) * pageSize;
    
    console.log('获取学生列表参数:', { page, pageSize, search, classId });
    
    // 构建查询条件
    let whereConditions = [];
    let params = [];
    
    if (search) {
      whereConditions.push('(s.student_no LIKE ? OR s.real_name LIKE ?)');
      params.push(`%${search}%`, `%${search}%`);
    }
    
    if (classId) {
      whereConditions.push('s.class_id = ?');
      params.push(classId);
    }
    
    const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';
    
    // 获取总数
    const [countResult] = await db.query(`
      SELECT COUNT(*) as total
      FROM student_info s
      ${whereClause}
    `, params);
    
    const total = countResult[0].total;
    
    // 获取学生列表
    const [students] = await db.query(`
      SELECT 
        s.user_id,
        s.student_no,
        s.real_name,
        s.department,
        s.major,
        s.grade,
        c.class_name,
        (
          SELECT COUNT(DISTINCT problem_id) 
          FROM submissions sub
          WHERE sub.user_id = s.user_id AND sub.status = 'Accepted'
        ) as completed_count
      FROM student_info s
      LEFT JOIN classes c ON s.class_id = c.id
      ${whereClause}
      ORDER BY s.student_no
      LIMIT ? OFFSET ?
    `, [...params, parseInt(pageSize), parseInt(offset)]);
    
    console.log(`查询到 ${students.length} 条学生记录`);
    
    // 获取统计数据
    const [totalStudentsResult] = await db.query('SELECT COUNT(*) as count FROM student_info');
    const [totalProblemsResult] = await db.query('SELECT COUNT(*) as count FROM problems');
    const [totalClassesResult] = await db.query('SELECT COUNT(*) as count FROM classes');
    
    // 计算未完成题目数
    const totalProblems = totalProblemsResult[0].count;
    students.forEach(student => {
      student.incomplete_count = totalProblems - (student.completed_count || 0);
    });
    
    return res.json({
      code: 0,
      message: '获取学生列表成功',
      data: students,
      total,
      totalStudents: totalStudentsResult[0].count,
      totalProblems: totalProblemsResult[0].count,
      totalClasses: totalClassesResult[0].count
    });
  } catch (error) {
    console.error('获取学生列表失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取学生列表失败'
    });
  }
});

/**
 * 获取特定学生的题目完成情况
 */
router.get('/student-problems', async (req, res) => {
  try {
    const { userId, page = 1, pageSize = 10, solved = false } = req.query;
    const offset = (page - 1) * pageSize;
    
    console.log('获取学生题目完成情况:', { userId, page, pageSize, solved });
    
    if (!userId) {
      return res.status(400).json({
        code: 400,
        message: '缺少必要参数: userId'
      });
    }
    
    // 获取总数
    const [countResult] = await db.query(`
      SELECT COUNT(*) as total
      FROM problems
    `);
    
    const total = countResult[0].total;
    
    // 根据solved参数决定使用哪种SQL查询
    let query;
    if (solved === 'true') {
      // 当solved=true时，只要曾经通过过题目（有Accepted记录），就标记为Accepted
      query = `
        SELECT 
          p.id,
          p.problem_number,
          p.title,
          p.difficulty,
          CASE 
            WHEN EXISTS (
              SELECT 1 
              FROM submissions s 
              WHERE s.user_id = ? AND s.problem_id = p.id AND s.status = 'Accepted'
            ) THEN 'Accepted'
            ELSE 'Not Attempted'
          END as status,
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
      `;
    } else {
      // 默认行为：获取最新的状态
      query = `
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
      `;
    }
    
    const [problems] = await db.query(query, [userId, userId, userId, userId, userId, parseInt(pageSize), parseInt(offset)]);
    
    console.log(`查询到 ${problems.length} 条题目记录`);
    
    return res.json({
      code: 0,
      message: '获取题目完成情况成功',
      data: problems,
      total
    });
  } catch (error) {
    console.error('获取题目完成情况失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取题目完成情况失败'
    });
  }
});

/**
 * 获取学生题目完成情况统计
 */
router.get('/student-completion/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    console.log('获取学生题目完成情况统计:', userId);

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
      code: 0,
      message: '获取学生题目完成情况统计成功',
      data: stats[0]
    });
  } catch (error) {
    console.error('获取学生题目完成情况统计失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取学生题目完成情况统计失败'
    });
  }
});

/**
 * 获取学生错误类型分析
 */
router.get('/student-error-types/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    console.log('获取学生错误类型分析:', userId);

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
      code: 0,
      message: '获取学生错误类型分析成功',
      data: stats
    });
  } catch (error) {
    console.error('获取学生错误类型分析失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取学生错误类型分析失败'
    });
  }
});

/**
 * 获取学生知识点掌握情况
 */
router.get('/student-knowledge/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    console.log('获取学生知识点掌握情况:', userId);

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
      code: 0,
      message: '获取学生知识点掌握情况成功',
      data: stats
    });
  } catch (error) {
    console.error('获取学生知识点掌握情况失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取学生知识点掌握情况失败'
    });
  }
});

/**
 * 获取学生解题时间分析
 */
router.get('/student-solving-time/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    console.log('获取学生解题时间分析:', userId);

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
      code: 0,
      message: '获取学生解题时间分析成功',
      data: stats
    });
  } catch (error) {
    console.error('获取学生解题时间分析失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取学生解题时间分析失败'
    });
  }
});

/**
 * 获取学生每日提交趋势
 */
router.get('/student-daily-submissions/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    console.log('获取学生每日提交趋势:', userId);

    const [stats] = await db.query(`
      WITH RECURSIVE DateRange AS (
        SELECT CURDATE() - INTERVAL 29 DAY as date
        UNION ALL
        SELECT date + INTERVAL 1 DAY
        FROM DateRange
        WHERE date < CURDATE()
      )
      SELECT 
        dr.date,
        COUNT(s.id) as total_submissions,
        SUM(CASE WHEN s.status = 'Accepted' THEN 1 ELSE 0 END) as accepted_submissions
      FROM DateRange dr
      LEFT JOIN submissions s ON DATE(s.created_at) = dr.date AND s.user_id = ?
      GROUP BY dr.date
      ORDER BY dr.date
    `, [userId]);

    return res.json({
      code: 0,
      message: '获取学生每日提交趋势成功',
      data: stats
    });
  } catch (error) {
    console.error('获取学生每日提交趋势失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取学生每日提交趋势失败'
    });
  }
});

/**
 * 获取学生提交时间分布
 */
router.get('/student-submission-time/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    console.log('获取学生提交时间分布:', userId);

    const [stats] = await db.query(`
      SELECT 
        HOUR(created_at) as hour,
        COUNT(*) as submission_count
      FROM submissions
      WHERE user_id = ?
      GROUP BY HOUR(created_at)
      ORDER BY hour
    `, [userId]);

    return res.json({
      code: 0,
      message: '获取学生提交时间分布成功',
      data: stats
    });
  } catch (error) {
    console.error('获取学生提交时间分布失败:', error);
    return res.status(500).json({
      code: 500,
      message: '服务器错误，获取学生提交时间分布失败'
    });
  }
});

module.exports = router; 