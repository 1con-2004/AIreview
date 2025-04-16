const express = require('express')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const pool = require('../../db') // 导入数据库连接池
const router = express.Router()

// 初始化默认用户
async function initDefaultUser() {
  try {
    // 检查是否已存在默认用户
    const [rows] = await pool.execute(
      'SELECT * FROM users WHERE username = ?',
      ['admin']
    )

    if (rows.length === 0) {
      // 如果不存在，创建默认用户
      const hashedPassword = await bcrypt.hash('123456', 10)
      await pool.execute(
        'INSERT INTO users (username, password, email) VALUES (?, ?, ?)',
        ['admin', hashedPassword, 'admin@example.com']
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
    // 详细的调试日志
    console.log('=== 登录调试信息 ===')
    console.log('1. 接收到的登录信息：', { 
      username,
      passwordLength: password ? password.length : 0
    })

    // 获取用户信息和角色
    const [rows] = await pool.execute(
      'SELECT * FROM users WHERE username = ?',
      [username]
    )

    console.log('2. 数据库查询结果：', rows)

    if (rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      })
    }

    const user = rows[0]

    // 检查用户状态
    if (user.status === 0) {
      return res.status(403).json({
        success: false,
        message: '账号已被封禁，请联系管理员'
      })
    }
    
    console.log('3. 密码比对信息：')
    console.log('- 用户输入的密码：', password)
    console.log('- 数据库中的密码哈希：', user.password)
    
    // 直接测试已知正确的密码
    const testMatch = await bcrypt.compare('123456', user.password)
    console.log('- 测试固定密码"123456"的匹配结果：', testMatch)
    
    // 测试用户输入的密码
    const match = await bcrypt.compare(password, user.password)
    console.log('- 用户输入密码的匹配结果：', match)

    if (!match) {
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      })
    }

    // 生成JWT token
    const token = jwt.sign(
      { id: user.id, username: user.username },
      'your-secret-key',
      { expiresIn: '24h' }
    )

    // 登录成功，返回用户信息和token
    const { password: _, ...userInfo } = user
    res.json({
      success: true,
      data: {
        ...userInfo,
        role: user.role, // 直接使用users表中的role字段
        token
      }
    })
  } catch (error) {
    console.error('登录错误：', error)
    res.status(500).json({
      success: false,
      message: '服务器错误',
      error: error.message
    })
  }
})

// 注册账号
router.post('/register', async (req, res) => {
  const { username, password, email, phone } = req.body
  
  try {
    // 检查用户名和邮箱是否已存在
    const [existingUsers] = await pool.execute(
      'SELECT * FROM users WHERE username = ? OR email = ?',
      [username, email]
    )

    if (existingUsers.length > 0) {
      return res.json({
        success: false,
        message: '用户名或邮箱已存在'
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
      'INSERT INTO users (username, password, email, phone) VALUES (?, ?, ?, ?)',
      [username, hashedPassword, email, phone || null]
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

router.get('/', (req, res) => {
    res.status(200).json({ message: '请使用 POST 方法进行登录' });
});

// 添加测试路由
router.get('/test-bcrypt', async (req, res) => {
  try {
    const testPassword = '123456'
    const hash = await bcrypt.hash(testPassword, 10)
    const match = await bcrypt.compare(testPassword, hash)
    
    res.json({
      testPassword,
      hash,
      match,
      storedHash: '$2b$10$x8qrPbcdBYOYwUuJJ0yzXO2Zl/9FID/Jf85p4xIWpyGtFZyoZGp8O'
    })
  } catch (error) {
    res.status(500).json({ error: error.message })
  }
})

// 添加一个完整的 bcrypt 测试路由
router.get('/test-full', async (req, res) => {
  try {
    // 1. 生成新的哈希
    const password = '123456'
    const salt = await bcrypt.genSalt(10)
    console.log('Salt:', salt)
    
    const hash = await bcrypt.hash(password, salt)
    console.log('New hash:', hash)
    
    // 2. 测试新生成的哈希
    const match1 = await bcrypt.compare(password, hash)
    console.log('Test with new hash:', match1)
    
    // 3. 测试数据库中的哈希
    const dbHash = '$2b$10$YEiRwJpQj9HvKxwQX9VYpOyy0qzHVVv5EZOyVQHCxVNZyqP.JVmPi'
    const match2 = await bcrypt.compare(password, dbHash)
    console.log('Test with DB hash:', match2)
    
    // 4. 生成多个哈希进行对比
    const hashes = []
    for(let i = 0; i < 5; i++) {
      const newHash = await bcrypt.hash(password, 10)
      hashes.push(newHash)
      const testMatch = await bcrypt.compare(password, newHash)
      console.log(`Test ${i+1}:`, { hash: newHash, match: testMatch })
    }
    
    res.json({
      salt,
      newHash: hash,
      newHashMatch: match1,
      dbHash,
      dbHashMatch: match2,
      testHashes: hashes
    })
  } catch (error) {
    console.error('Bcrypt test error:', error)
    res.status(500).json({ error: error.message })
  }
})

// 添加一个生成新密码哈希的路由
router.get('/generate-hash', async (req, res) => {
  try {
    const password = '123456'
    const hashedPassword = await bcrypt.hash(password, 10)
    const testMatch = await bcrypt.compare(password, hashedPassword)
    
    // 如果哈希验证成功，则更新数据库
    if (testMatch) {
      await pool.execute(
        'UPDATE users SET password = ? WHERE username = ?',
        [hashedPassword, 'admin']
      )
      
      res.json({
        success: true,
        message: '密码已更新',
        hash: hashedPassword,
        testMatch
      })
    } else {
      res.json({
        success: false,
        message: '哈希验证失败'
      })
    }
  } catch (error) {
    res.status(500).json({ error: error.message })
  }
})

module.exports = router 