const express = require('express');
const bcrypt = require('bcrypt');
const pool = require('../../db');
const router = express.Router();

// 注册用户
router.post('/', async (req, res) => {
  const { username, password, email, role = 'student' } = req.body;
  
  try {
    // 验证输入
    if (!username || !password) {
      return res.status(400).json({
        success: false,
        message: '用户名和密码不能为空'
      });
    }

    // 检查用户名是否已存在
    const [existingUsers] = await pool.execute(
      'SELECT * FROM users WHERE username = ?',
      [username]
    );

    if (existingUsers.length > 0) {
      return res.status(400).json({
        success: false,
        message: '用户名已存在'
      });
    }

    // 检查邮箱是否已存在
    if (email) {
      const [existingEmails] = await pool.execute(
        'SELECT * FROM users WHERE email = ?',
        [email]
      );

      if (existingEmails.length > 0) {
        return res.status(400).json({
          success: false,
          message: '邮箱已被注册'
        });
      }
    }

    // 加密密码
    const hashedPassword = await bcrypt.hash(password, 10);

    // 创建用户
    const [result] = await pool.execute(
      'INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, ?)',
      [username, hashedPassword, email, role]
    );

    res.status(201).json({
      success: true,
      message: '注册成功',
      data: {
        id: result.insertId,
        username,
        email,
        role
      }
    });
  } catch (error) {
    console.error('注册错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
});

module.exports = router; 