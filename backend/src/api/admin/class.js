const express = require('express');
const router = express.Router();
const db = require('../../db');
// 暂时注释掉权限验证中间件，以便测试
// const { authenticateToken, isAdmin } = require('../../middleware/auth');

// 创建新班级
router.post('/', async (req, res) => {
  const { class_name, student_nos = [] } = req.body;
  
  try {
    console.log('开始创建班级:', { class_name, student_nos });
    
    // 开启事务
    const connection = await db.getConnection();
    await connection.beginTransaction();
    
    try {
      // 1. 创建班级
      const [classResult] = await connection.execute(
        'INSERT INTO classes (class_name) VALUES (?)',
        [class_name]
      );
      const classId = classResult.insertId;
      console.log('班级创建成功，ID:', classId);

      // 2. 如果有学生列表，更新学生的班级关联
      if (student_nos.length > 0) {
        const placeholders = student_nos.map(() => '?').join(',');
        const [students] = await connection.execute(
          `SELECT id FROM student_info WHERE student_no IN (${placeholders})`,
          student_nos
        );
        
        console.log('找到的学生:', students);

        if (students.length > 0) {
          const updatePromises = students.map(student =>
            connection.execute(
              'UPDATE student_info SET class_id = ? WHERE id = ?',
              [classId, student.id]
            )
          );
          await Promise.all(updatePromises);
          console.log('学生班级关联更新成功');
        }
      }

      await connection.commit();
      res.json({
        success: true,
        message: '班级创建成功',
        data: { id: classId }
      });
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error('创建班级失败:', error);
    res.status(500).json({
      success: false,
      message: '创建班级失败',
      error: error.message
    });
  }
});

// 根据学号查询学生信息
router.get('/search-students', async (req, res) => {
  const { student_no, exclude_class_id } = req.query;
  
  try {
    console.log('搜索学生:', student_no, '排除班级ID:', exclude_class_id);
    
    let query = `
      SELECT 
        s.id,
        s.student_no, 
        s.real_name, 
        u.username, 
        up.avatar_url,
        c.class_name,
        c.id as class_id
      FROM student_info s
      JOIN users u ON s.user_id = u.id
      LEFT JOIN user_profile up ON u.id = up.user_id
      LEFT JOIN classes c ON s.class_id = c.id
      WHERE s.student_no LIKE ?
    `;
    
    const params = [`%${student_no}%`];
    
    if (exclude_class_id) {
      query += ` AND (s.class_id IS NULL OR s.class_id != ?)`;
      params.push(exclude_class_id);
    }
    
    const [students] = await db.execute(query, params);
    
    console.log('搜索结果:', students);
    
    res.json({
      success: true,
      data: students
    });
  } catch (error) {
    console.error('搜索学生失败:', error);
    res.status(500).json({
      success: false,
      message: '搜索学生失败',
      error: error.message
    });
  }
});

// 搜索班级
router.get('/search', async (req, res) => {
  const { class_name } = req.query;
  
  try {
    console.log('搜索班级:', class_name);
    
    const [classes] = await db.execute(`
      SELECT id, class_name
      FROM classes
      WHERE class_name LIKE ?
    `, [`%${class_name}%`]);
    
    console.log('搜索结果:', classes);
    
    res.json({
      success: true,
      data: classes
    });
  } catch (error) {
    console.error('搜索班级失败:', error);
    res.status(500).json({
      success: false,
      message: '搜索班级失败',
      error: error.message
    });
  }
});

// 获取班级学生列表
router.get('/:classId/students', async (req, res) => {
  const { classId } = req.params;
  
  try {
    console.log('获取班级学生列表, 班级ID:', classId);
    
    // 获取班级学生列表
    const [students] = await db.execute(`
      SELECT 
        s.id, 
        s.student_no, 
        s.real_name, 
        u.username, 
        up.avatar_url,
        s.department,
        s.major,
        s.grade
      FROM student_info s
      JOIN users u ON s.user_id = u.id
      LEFT JOIN user_profile up ON u.id = up.user_id
      WHERE s.class_id = ?
    `, [classId]);
    
    // 获取班级学生总数
    const [countResult] = await db.execute(`
      SELECT COUNT(*) as count
      FROM student_info
      WHERE class_id = ?
    `, [classId]);
    
    const count = countResult[0].count;
    
    console.log('班级学生列表:', students);
    console.log('班级学生总数:', count);
    
    res.json({
      success: true,
      data: students,
      count: count
    });
  } catch (error) {
    console.error('获取班级学生列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取班级学生列表失败',
      error: error.message
    });
  }
});

// 更新班级信息
router.put('/:classId', async (req, res) => {
  const { classId } = req.params;
  const { class_name } = req.body;
  
  try {
    console.log('更新班级信息, 班级ID:', classId, '新班级名称:', class_name);
    
    const [result] = await db.execute(`
      UPDATE classes
      SET class_name = ?
      WHERE id = ?
    `, [class_name, classId]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: '班级不存在'
      });
    }
    
    console.log('班级信息更新成功');
    
    res.json({
      success: true,
      message: '班级信息更新成功'
    });
  } catch (error) {
    console.error('更新班级信息失败:', error);
    res.status(500).json({
      success: false,
      message: '更新班级信息失败',
      error: error.message
    });
  }
});

// 添加学生到班级
router.post('/:classId/students', async (req, res) => {
  const { classId } = req.params;
  const { student_id } = req.body;
  
  try {
    console.log('添加学生到班级, 班级ID:', classId, '学生ID:', student_id);
    
    // 检查学生是否存在
    const [student] = await db.execute(`
      SELECT id, class_id
      FROM student_info
      WHERE id = ?
    `, [student_id]);
    
    if (student.length === 0) {
      return res.status(404).json({
        success: false,
        message: '学生不存在'
      });
    }
    
    // 检查班级是否存在
    const [classInfo] = await db.execute(`
      SELECT id
      FROM classes
      WHERE id = ?
    `, [classId]);
    
    if (classInfo.length === 0) {
      return res.status(404).json({
        success: false,
        message: '班级不存在'
      });
    }
    
    // 更新学生班级
    const [result] = await db.execute(`
      UPDATE student_info
      SET class_id = ?
      WHERE id = ?
    `, [classId, student_id]);
    
    console.log('学生添加到班级成功');
    
    res.json({
      success: true,
      message: '学生添加到班级成功'
    });
  } catch (error) {
    console.error('添加学生到班级失败:', error);
    res.status(500).json({
      success: false,
      message: '添加学生到班级失败',
      error: error.message
    });
  }
});

// 从班级中移除学生
router.delete('/:classId/students/:studentId', async (req, res) => {
  const { classId, studentId } = req.params;
  
  try {
    console.log('从班级中移除学生, 班级ID:', classId, '学生ID:', studentId);
    
    // 检查学生是否在该班级
    const [student] = await db.execute(`
      SELECT id
      FROM student_info
      WHERE id = ? AND class_id = ?
    `, [studentId, classId]);
    
    if (student.length === 0) {
      return res.status(404).json({
        success: false,
        message: '该学生不在此班级中'
      });
    }
    
    // 将学生的班级设置为NULL
    const [result] = await db.execute(`
      UPDATE student_info
      SET class_id = NULL
      WHERE id = ?
    `, [studentId]);
    
    console.log('学生从班级中移除成功');
    
    res.json({
      success: true,
      message: '学生从班级中移除成功'
    });
  } catch (error) {
    console.error('从班级中移除学生失败:', error);
    res.status(500).json({
      success: false,
      message: '从班级中移除学生失败',
      error: error.message
    });
  }
});

module.exports = router; 