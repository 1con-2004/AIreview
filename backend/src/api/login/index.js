const express = require('express')
const bcrypt = require('bcrypt')
const pool = require('../../db') // 导入数据库连接池
const router = express.Router()

// 初始化默认用户
async function initDefaultUser() {
  try {
    // 检查是否已存在默认用户
    const [rows] = await pool.execute(
      'SELECT * FROM users WHERE username = ?',
      ['icon']
    )

    if (rows.length === 0) {
      // 如果不存在，创建默认用户
      const hashedPassword = await bcrypt.hash('123456', 10)
      await pool.execute(
        'INSERT INTO users (username, password) VALUES (?, ?)',
        ['icon', hashedPassword]
      )
      console.log('Default user created successfully')
    }
  } catch (error) {
    console.error('Error initializing default user:', error)
  }
}

// 在服务启动时初始化默认用户
initDefaultUser()

// 密码登录
router.post('/', async (req, res) => {
  const { username, password } = req.body
  
  try {
    console.log('Login attempt:', { username }) // 添加日志

    const [rows] = await pool.execute(
      'SELECT * FROM users WHERE username = ?',
      [username]
    )

    console.log('Database response:', rows) // 添加日志

    if (rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      })
    }

    const user = rows[0]
    const match = await bcrypt.compare(password, user.password)

    console.log('Password match:', match) // 添加日志

    if (!match) {
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      })
    }

    // 登录成功，返回用户信息（不包含密码）
    const { password: _, ...userInfo } = user
    res.json({
      success: true,
      data: userInfo
    })
  } catch (error) {
    console.error('登录错误：', error)
    res.status(500).json({
      success: false,
      message: '服务器错误',
      error: error.message // 添加详细错误信息
    })
  }
})

// 注册账号
router.post('/register', async (req, res) => {
  const { username, password, phone } = req.body
  
  try {
    // 检查用户名是否已存在
    const [existingUsers] = await pool.execute(
      'SELECT * FROM users WHERE username = ?',
      [username]
    )

    if (existingUsers.length > 0) {
      return res.json({
        success: false,
        message: '用户名已存在'
      })
    }

    // 检查手机号是否已绑定
    if (phone) {
      const [existingPhones] = await pool.execute(
        'SELECT * FROM users WHERE phone = ?',
        [phone]
      )

      if (existingPhones.length > 0) {
        return res.json({
          success: false,
          message: '手机号已被使用'
        })
      }
    }

    // 加密密码
    const hashedPassword = await bcrypt.hash(password, 10)

    // 插入新用户
    await pool.execute(
      'INSERT INTO users (username, password, phone) VALUES (?, ?, ?)',
      [username, hashedPassword, phone || null]
    )

    res.json({
      success: true,
      message: '注册成功'
    })
  } catch (error) {
    console.error('注册错误：', error)
    res.status(500).json({
      success: false,
      message: '服务器错误'
    })
  }
})

// 登录路由
router.post('/', (req, res) => {
    const { username, password } = req.body;
    // 这里添加您的登录逻辑
    if (username === 'icon' && password === '123456') {
        return res.status(200).json({ message: '登录成功' });
    }
    return res.status(401).json({ message: '用户名或密码错误' });
});

router.get('/', (req, res) => {
    res.status(200).json({ message: '请使用 POST 方法进行登录' });
});

module.exports = router 