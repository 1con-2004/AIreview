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
          SELECT COUNT(*) 
          FROM user_problem_status ups 
          WHERE ups.user_id = s.user_id AND ups.status = 'Accepted'
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
    const { userId, page = 1, pageSize = 10 } = req.query;
    const offset = (page - 1) * pageSize;
    
    console.log('获取学生题目完成情况:', { userId, page, pageSize });
    
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
    
    // 获取题目列表及完成情况
    const [problems] = await db.query(`
      SELECT 
        p.id,
        p.problem_number,
        p.title,
        p.difficulty,
        IFNULL(ups.status, 'Not Attempted') as status,
        IFNULL(ups.submission_count, 0) as submission_count,
        ups.last_submission_time,
        ups.first_submission_time,
        ups.average_execution_time,
        ups.viewed_solution
      FROM problems p
      LEFT JOIN user_problem_status ups ON p.id = ups.problem_id AND ups.user_id = ?
      ORDER BY p.problem_number
      LIMIT ? OFFSET ?
    `, [userId, parseInt(pageSize), parseInt(offset)]);
    
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

module.exports = router; 