const express = require('express')
const router = express.Router()
const pool = require('../../db')

// 获取学生列表
router.get('/students', async (req, res) => {
  try {
    console.log('正在获取学生列表...')
    const [students] = await pool.execute(`
      SELECT 
        s.*, 
        u.username, 
        up.avatar_url,
        c.class_name
      FROM student_info s
      JOIN users u ON s.user_id = u.id
      LEFT JOIN user_profile up ON u.id = up.user_id
      LEFT JOIN classes c ON s.class_id = c.id
    `)
    console.log('获取到的学生列表:', students)
    res.json({
      success: true,
      data: students
    })
  } catch (error) {
    console.error('获取学生列表失败:', error)
    res.status(500).json({
      success: false,
      message: '获取学生列表失败',
      error: error.message
    })
  }
})

// 创建学生信息
router.post('/students', async (req, res) => {
  try {
    const { user_id, student_no, real_name, department, major, grade, class_id } = req.body
    console.log('接收到的创建学生信息请求:', req.body)

    // 检查学号是否已存在
    const [existingStudent] = await pool.execute(
      'SELECT id FROM student_info WHERE student_no = ?',
      [student_no]
    )

    if (existingStudent.length > 0) {
      return res.status(400).json({
        success: false,
        message: '该学号已存在'
      })
    }

    // 检查用户ID是否已关联学生信息
    const [existingUserStudent] = await pool.execute(
      'SELECT id FROM student_info WHERE user_id = ?',
      [user_id]
    )

    if (existingUserStudent.length > 0) {
      return res.status(400).json({
        success: false,
        message: '该用户已关联其他学生信息'
      })
    }

    // 如果提供了class_id，检查班级是否存在
    if (class_id) {
      const [existingClass] = await pool.execute(
        'SELECT id FROM classes WHERE id = ?',
        [class_id]
      )

      if (existingClass.length === 0) {
        return res.status(400).json({
          success: false,
          message: '指定的班级不存在'
        })
      }
    }

    // 插入学生信息
    const [result] = await pool.execute(
      'INSERT INTO student_info (user_id, student_no, real_name, department, major, grade, class_id) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [user_id, student_no, real_name, department, major, grade, class_id]
    )

    console.log('学生信息创建成功:', result)
    res.json({
      success: true,
      message: '学生信息创建成功',
      data: { id: result.insertId }
    })
  } catch (error) {
    console.error('创建学生信息失败:', error)
    res.status(500).json({
      success: false,
      message: '创建学生信息失败',
      error: error.message
    })
  }
})

// 搜索用户
router.get('/users/search', async (req, res) => {
  try {
    const { q } = req.query
    console.log('搜索用户，关键词:', q)

    if (!q) {
      return res.status(400).json({
        success: false,
        message: '搜索关键词不能为空'
      })
    }

    const [users] = await pool.execute(`
      SELECT u.id, u.username, COALESCE(up.avatar_url, u.avatar) as avatar, 
             up.display_name
      FROM users u
      LEFT JOIN user_profile up ON u.id = up.user_id
      WHERE u.username LIKE ? 
      LIMIT 10
    `, [`%${q}%`])

    console.log('搜索到的用户:', users)
    res.json({
      success: true,
      data: users
    })
  } catch (error) {
    console.error('搜索用户失败:', error)
    res.status(500).json({
      success: false,
      message: '搜索用户失败',
      error: error.message
    })
  }
})

// 更新学生信息
router.put('/students/:id', async (req, res) => {
  try {
    const { id } = req.params
    const { student_no, real_name, department, major, grade, class_id } = req.body
    console.log('正在更新学生信息:', { id, ...req.body })

    // 检查学号是否已被其他学生使用
    const [existingStudent] = await pool.execute(
      'SELECT id FROM student_info WHERE student_no = ? AND id != ?',
      [student_no, id]
    )

    if (existingStudent.length > 0) {
      return res.status(400).json({
        success: false,
        message: '该学号已被其他学生使用'
      })
    }

    // 如果提供了class_id，检查班级是否存在
    if (class_id) {
      const [existingClass] = await pool.execute(
        'SELECT id FROM classes WHERE id = ?',
        [class_id]
      )

      if (existingClass.length === 0) {
        return res.status(400).json({
          success: false,
          message: '指定的班级不存在'
        })
      }
    }

    // 更新学生信息
    const [result] = await pool.execute(
      `UPDATE student_info 
       SET student_no = ?, real_name = ?, department = ?, major = ?, grade = ?, 
           class_id = ?, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?`,
      [student_no, real_name, department, major, grade, class_id, id]
    )

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: '未找到该学生信息'
      })
    }

    console.log('学生信息更新成功:', result)
    res.json({
      success: true,
      message: '学生信息更新成功'
    })
  } catch (error) {
    console.error('更新学生信息失败:', error)
    res.status(500).json({
      success: false,
      message: '更新学生信息失败',
      error: error.message
    })
  }
})

// 删除学生信息
router.delete('/students/:id', async (req, res) => {
  try {
    const { id } = req.params
    console.log('正在删除学生信息:', id)

    const [result] = await pool.execute(
      'DELETE FROM student_info WHERE id = ?',
      [id]
    )

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: '未找到该学生信息'
      })
    }

    console.log('学生信息删除成功:', result)
    res.json({
      success: true,
      message: '学生信息删除成功'
    })
  } catch (error) {
    console.error('删除学生信息失败:', error)
    res.status(500).json({
      success: false,
      message: '删除学生信息失败',
      error: error.message
    })
  }
})

module.exports = router
