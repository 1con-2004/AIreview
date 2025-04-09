// backend/routes/auth.js
const express = require('express')
const router = express.Router()
const transporter = require('../../config/email')
const pool = require('../db')
const bcrypt = require('bcrypt')

// 存储验证码的Map（实际项目中应该使用Redis）
const verificationCodes = new Map()

// 生成6位随机验证码
const generateVerificationCode = () => {
  return Math.floor(100000 + Math.random() * 900000).toString()
}

// 添加请求方法验证中间件
router.use((req, res, next) => {
  console.log('请求方法：', req.method)
  console.log('请求路径：', req.path)
  console.log('请求头：', req.headers)
  next()
})

// 添加测试路由
router.get('/test', (req, res) => {
  console.log('Auth test route accessed')
  res.json({ message: 'Auth route is working!' })
})

// 发送邮箱验证码
router.post('/send-email-code', async (req, res) => {
  if (req.method !== 'POST') {
    console.log('错误的请求方法：', req.method)
    return res.status(405).json({ success: false, message: '不支持的请求方法' })
  }

  console.log('收到发送验证码请求，请求体：', req.body)
  const { email } = req.body

  if (!email) {
    console.log('邮箱地址为空')
    return res.status(400).json({ success: false, message: '邮箱地址不能为空' })
  }

  try {
    // 生成验证码
    const code = generateVerificationCode()
    console.log('生成的验证码：', code)
    
    // 发送邮件
    console.log('开始发送邮件到：', email)
    await transporter.sendMail({
      from: '"QuizPlanet问知星球" <2456947952@qq.com>',
      to: email,
      subject: '验证码 - QuizPlanet问知星球 ',
      html: `
        <div style="padding: 20px; background-color: #f8f9fa; border-radius: 8px;">
          <h2 style="color: #333; margin-bottom: 20px;">验证码</h2>
          <p style="color: #666; margin-bottom: 20px;">您的验证码是：</p>
          <div style="background-color: #fff; padding: 15px; border-radius: 4px; text-align: center; font-size: 24px; font-weight: bold; color: #4ecdc4;">
            ${code}
          </div>
          <p style="color: #999; margin-top: 20px; font-size: 12px;">验证码有效期为5分钟，请勿泄露给他人。</p>
        </div>
      `
    })
    console.log('邮件发送成功')

    // 保存验证码（5分钟有效期）
    verificationCodes.set(email, {
      code,
      expires: Date.now() + 5 * 60 * 1000
    })

    res.json({ success: true })
  } catch (error) {
    console.error('发送邮件失败，详细错误：', error)
    console.error('错误名称：', error.name)
    console.error('错误信息：', error.message)
    if (error.response) {
      console.error('SMTP响应：', error.response)
    }
    res.status(500).json({ success: false, message: '发送验证码失败，错误信息：' + error.message })
  }
})

// 注册接口
router.post('/register', async (req, res) => {
  console.log('收到注册请求，请求体：', req.body);
  const { username, password, email, phone, code } = req.body

  try {
    // 验证必填字段
    if (!username || !password || !email || !code) {
      console.log('缺少必填字段');
      return res.status(400).json({ 
        success: false, 
        message: '用户名、密码、邮箱和验证码为必填项' 
      });
    }

    // 验证验证码
    console.log('验证码信息：', { savedCode: verificationCodes.get(email), inputCode: code });
    const savedCode = verificationCodes.get(email)
    if (!savedCode || savedCode.code !== code || Date.now() > savedCode.expires) {
      return res.status(400).json({ success: false, message: '验证码无效或已过期' })
    }

    // 检查用户名和邮箱是否已存在
    console.log('检查用户名和邮箱是否存在');
    const [existingUser] = await pool.query(
      'SELECT * FROM users WHERE username = ? OR email = ?',
      [username, email]
    )

    if (existingUser.length > 0) {
      console.log('用户名或邮箱已存在');
      return res.status(400).json({ success: false, message: '用户名或邮箱已存在' })
    }

    // 检查手机号是否已存在（如果提供了手机号）
    if (phone) {
      console.log('检查手机号是否存在');
      const [existingPhone] = await pool.query(
        'SELECT * FROM users WHERE phone = ?',
        [phone]
      )
      if (existingPhone.length > 0) {
        return res.status(400).json({ success: false, message: '手机号已被使用' })
      }
    }

    // 加密密码
    console.log('开始加密密码');
    const hashedPassword = await bcrypt.hash(password, 10)

    // 创建用户
    console.log('开始创建用户');
    const [result] = await pool.query(
      'INSERT INTO users (username, password, email, phone, role, status) VALUES (?, ?, ?, ?, ?, ?)',
      [username, hashedPassword, email, phone || null, 'normal', 1]
    )

    // 创建用户资料
    console.log('开始创建用户资料');
    if (result.insertId) {
      await pool.query(
        'INSERT INTO user_profile (user_id, nickname, display_name) VALUES (?, ?, ?)',
        [result.insertId, username, username]
      )
    }

    // 删除已使用的验证码
    verificationCodes.delete(email)
    console.log('注册成功');

    res.json({ 
      success: true,
      message: '注册成功'
    })
  } catch (error) {
    console.error('注册失败，详细错误：', error);
    res.status(500).json({ 
      success: false, 
      message: '注册失败：' + error.message 
    })
  }
})

// 密码登录
router.post('/', async (req, res) => {
  const { username, password } = req.body
  
  try {
    // 详细的调试日志
    console.log('=== 登录调试信息 ===')
    console.log('1. 接收到的登录信息：', { 
      username,
      password,
      passwordLength: password ? password.length : 0
    })

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
      error: error.message
    })
  }
})

// 添加一个测试路由来验证 bcrypt 是否正常工作
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

// 发送重置密码验证码
router.post('/send-reset-code', async (req, res) => {
  console.log('收到发送重置密码验证码请求，请求体：', req.body)
  const { email } = req.body

  if (!email) {
    console.log('邮箱地址为空')
    return res.status(400).json({ success: false, message: '邮箱地址不能为空' })
  }

  try {
    // 检查邮箱是否存在
    const [existingUser] = await pool.query(
      'SELECT * FROM users WHERE email = ?',
      [email]
    )

    if (existingUser.length === 0) {
      return res.status(400).json({ success: false, message: '该邮箱未注册' })
    }

    // 生成验证码
    const code = generateVerificationCode()
    console.log('生成的验证码：', code)
    
    // 发送邮件
    console.log('开始发送邮件到：', email)
    await transporter.sendMail({
      from: '"QuizPlanet问知星球" <2456947952@qq.com>',
      to: email,
      subject: '重置密码验证码 - QuizPlanet问知星球',
      html: `
        <div style="padding: 20px; background-color: #f8f9fa; border-radius: 8px;">
          <h2 style="color: #333; margin-bottom: 20px;">重置密码验证码</h2>
          <p style="color: #666; margin-bottom: 20px;">您的验证码是：</p>
          <div style="background-color: #fff; padding: 15px; border-radius: 4px; text-align: center; font-size: 24px; font-weight: bold; color: #4ecdc4;">
            ${code}
          </div>
          <p style="color: #999; margin-top: 20px; font-size: 12px;">验证码有效期为5分钟，请勿泄露给他人。</p>
        </div>
      `
    })
    console.log('邮件发送成功')

    // 保存验证码（5分钟有效期）
    verificationCodes.set(email, {
      code,
      expires: Date.now() + 5 * 60 * 1000,
      type: 'reset' // 标记这是重置密码的验证码
    })

    res.json({ success: true })
  } catch (error) {
    console.error('发送重置密码验证码失败：', error)
    res.status(500).json({ 
      success: false, 
      message: '发送验证码失败：' + error.message 
    })
  }
})

// 重置密码
router.post('/reset-password', async (req, res) => {
  console.log('收到重置密码请求，请求体：', req.body)
  const { email, code, newPassword } = req.body

  try {
    // 验证必填字段
    if (!email || !code || !newPassword) {
      return res.status(400).json({ 
        success: false, 
        message: '邮箱、验证码和新密码为必填项' 
      })
    }

    // 验证验证码
    const savedCode = verificationCodes.get(email)
    if (!savedCode || savedCode.code !== code || Date.now() > savedCode.expires || savedCode.type !== 'reset') {
      return res.status(400).json({ success: false, message: '验证码无效或已过期' })
    }

    // 加密新密码
    const hashedPassword = await bcrypt.hash(newPassword, 10)

    // 更新密码
    const [result] = await pool.query(
      'UPDATE users SET password = ? WHERE email = ?',
      [hashedPassword, email]
    )

    if (result.affectedRows === 0) {
      return res.status(400).json({ success: false, message: '更新密码失败，邮箱不存在' })
    }

    // 删除已使用的验证码
    verificationCodes.delete(email)

    res.json({ 
      success: true,
      message: '密码重置成功'
    })
  } catch (error) {
    console.error('重置密码失败：', error)
    res.status(500).json({ 
      success: false, 
      message: '重置密码失败：' + error.message 
    })
  }
})

module.exports = router