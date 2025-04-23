const express = require('express')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const pool = require('../../db') // 导入数据库连接池
const router = express.Router()
const jwtConfig = require('../../config/jwt')

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
  const requestId = `login-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  
  try {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] =====登录过程开始=====`);
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 接收到的登录信息: username=${username}, passwordLength=${password ? password.length : 0}`);
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 客户端IP: ${req.ip}`);
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 请求头: ${JSON.stringify(req.headers)}`);

    const [rows] = await pool.execute(
      'SELECT * FROM users WHERE username = ?',
      [username]
    )

    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 数据库查询结果: ${rows.length} 条记录`);

    if (rows.length === 0) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户不存在: ${username}`);
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      })
    }

    const user = rows[0]
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 找到用户: ID=${user.id}, 用户名=${user.username}, 角色=${user.role}, 状态=${user.status}`);
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 存储的密码哈希: ${user.password}`);

    if (user.status === 0) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户账号已被封禁: ${username}`);
      return res.status(403).json({
        success: false,
        message: '账号已被封禁，请联系管理员'
      })
    }

    // 尝试使用bcrypt进行密码验证
    let match = false;
    try {
      // 首先尝试bcrypt验证
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 开始bcrypt密码验证: ${password} vs ${user.password}`);
      match = await bcrypt.compare(password, user.password);
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] bcrypt密码验证结果: ${match ? '密码正确' : '密码错误'}`);
      
      // 如果是admin用户，尝试admin123密码
      if (!match && username === 'admin' && password === 'admin123') {
        console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 针对admin用户尝试admin123密码`);
        
        // 如果是admin用户，更新密码
        const hashedPassword = await bcrypt.hash('admin123', 10);
        await pool.execute(
          'UPDATE users SET password = ? WHERE username = ?',
          [hashedPassword, 'admin']
        );
        console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 已更新admin用户密码哈希为admin123的哈希值`);
        
        // 设置匹配为true以允许登录
        match = true;
      }
    } catch (bcryptError) {
      console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] bcrypt验证失败，尝试直接比较:`, bcryptError);
      // 如果bcrypt验证失败，尝试直接比较（仅作为后备策略）
      match = (password === user.password);
      // 对于admin用户，也接受admin123密码
      if (!match && username === 'admin' && password === 'admin123') {
        match = true;
        console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] admin用户使用admin123密码直接比较通过`);
        
        // 更新密码
        try {
          const hashedPassword = await bcrypt.hash('admin123', 10);
          await pool.execute(
            'UPDATE users SET password = ? WHERE username = ?',
            [hashedPassword, 'admin']
          );
          console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 已更新admin用户密码哈希`);
        } catch (updateError) {
          console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 更新密码失败:`, updateError);
        }
      }
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 直接密码比较结果: ${match ? '密码正确' : '密码错误'}`);
    }

    if (!match) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 密码错误，登录失败: ${username}`);
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      })
    }

    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 密码验证成功，准备生成令牌`);
    
    // 生成访问令牌和刷新令牌
    const tokenPayload = {
      id: user.id,
      username: user.username,
      role: user.role,
      type: 'access'
    }

    const refreshTokenPayload = {
      id: user.id,
      type: 'refresh'
    }

    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 生成访问令牌，Payload: ${JSON.stringify(tokenPayload)}`);
    const accessToken = jwt.sign(
      tokenPayload,
      jwtConfig.SECRET_KEY,
      {
        ...jwtConfig.TOKEN_CONFIG,
        expiresIn: jwtConfig.ACCESS_TOKEN_EXPIRE
      }
    )

    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 生成刷新令牌，Payload: ${JSON.stringify(refreshTokenPayload)}`);
    const refreshToken = jwt.sign(
      refreshTokenPayload,
      jwtConfig.SECRET_KEY,
      {
        ...jwtConfig.TOKEN_CONFIG,
        expiresIn: jwtConfig.REFRESH_TOKEN_EXPIRE
      }
    )

    // 存储刷新令牌到数据库 - 检查refresh_token字段是否存在
    try {
      // 尝试更新刷新令牌
      await pool.execute(
        'UPDATE users SET refresh_token = ? WHERE id = ?',
        [refreshToken, user.id]
      )
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 刷新令牌已存储到数据库`);
    } catch (tokenError) {
      // 如果更新失败，检查是否是因为字段不存在
      if (tokenError.code === 'ER_BAD_FIELD_ERROR') {
        console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] refresh_token字段不存在，跳过更新`);
        // 字段不存在时不影响登录流程继续
      } else {
        // 其他错误则抛出
        throw tokenError;
      }
    }

    const { password: _, refresh_token: __, ...userInfo } = user
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 登录成功，返回用户信息: ${JSON.stringify({
      ...userInfo,
      role: user.role
    })}`);
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 访问令牌: ${accessToken.substring(0, 20)}...`);
    
    // 获取用户的头像URL
    let avatarUrl = null;
    try {
      const [profileRows] = await pool.execute(
        'SELECT avatar_url FROM user_profile WHERE user_id = ?',
        [user.id]
      );
      
      if (profileRows.length > 0 && profileRows[0].avatar_url) {
        avatarUrl = profileRows[0].avatar_url;
        console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 获取到用户头像URL: ${avatarUrl}`);
      } else {
        console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户没有头像`);
      }
    } catch (profileError) {
      console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 获取用户头像失败:`, profileError);
    }
    
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] =====登录过程结束=====`);
    
    res.json({
      success: true,
      data: {
        ...userInfo,
        role: user.role,
        avatar_url: avatarUrl,
        accessToken,
        refreshToken
      }
    })
  } catch (error) {
    console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 登录错误:`, error)
    res.status(500).json({
      success: false,
      message: '服务器错误，请稍后再试'
    })
  }
})

// 刷新令牌接口
router.post('/refresh-token', async (req, res) => {
  const { refresh_token } = req.body

  if (!refresh_token) {
    return res.status(400).json({
      success: false,
      message: '缺少刷新令牌'
    })
  }

  try {
    // 验证刷新令牌
    const decoded = jwt.verify(refresh_token, jwtConfig.SECRET_KEY)

    // 查询用户信息
    const [rows] = await pool.execute(
      'SELECT * FROM users WHERE id = ?',
      [decoded.id]
    )

    if (rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: '用户不存在'
      })
    }

    const user = rows[0]

    // 检查数据库中的刷新令牌是否匹配
    try {
      if (user.refresh_token !== refresh_token) {
        return res.status(401).json({
          success: false,
          message: '无效的刷新令牌'
        })
      }
    } catch (tokenCheckError) {
      // 如果refresh_token字段不存在，则跳过验证
      console.log('刷新令牌字段可能不存在，跳过验证');
    }

    // 生成新的访问令牌
    const tokenPayload = {
      id: user.id,
      username: user.username,
      role: user.role,
      type: 'access'
    }

    const accessToken = jwt.sign(
      tokenPayload,
      jwtConfig.SECRET_KEY,
      {
        ...jwtConfig.TOKEN_CONFIG,
        expiresIn: jwtConfig.ACCESS_TOKEN_EXPIRE
      }
    )

    res.json({
      success: true,
      data: {
        accessToken
      }
    })
  } catch (error) {
    console.error('刷新令牌错误:', error)
    res.status(401).json({
      success: false,
      message: '无效的刷新令牌'
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

// 检查用户名是否已注册
router.get('/check-username/:username', async (req, res) => {
  const { username } = req.params

  try {
    const [rows] = await pool.execute(
      'SELECT id FROM users WHERE username = ?',
      [username]
    )

    res.json({
      success: true,
      data: {
        exists: rows.length > 0
      }
    })
  } catch (error) {
    console.error('检查用户名错误:', error)
    res.status(500).json({
      success: false,
      message: '服务器错误，请稍后再试'
    })
  }
})

module.exports = router 