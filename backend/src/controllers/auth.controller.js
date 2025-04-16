exports.login = async (req, res) => {
  try {
    const { username, password, remember } = req.body;
    
    console.log(`登录尝试: ${username}`);
    
    // 查询用户
    const [users] = await db.execute(
      'SELECT id, username, password, email, phone, created_at, status, token, role, role_expire_time, avatar_url FROM users WHERE username = ?',
      [username]
    );
    
    if (users.length === 0) {
      console.log(`登录失败: 用户不存在 - ${username}`);
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      });
    }
    
    const user = users[0];
    
    // 验证密码
    const match = await bcrypt.compare(password, user.password);
    
    if (!match) {
      console.log(`登录失败: 密码错误 - ${username}`);
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      });
    }
    
    // 生成令牌
    const payload = {
      id: user.id,
      username: user.username,
      role: user.role,
      type: 'access'
    };
    
    const accessToken = jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '24h' }
    );
    
    // 生成刷新令牌
    const refreshPayload = {
      id: user.id,
      type: 'refresh'
    };
    
    const refreshToken = jwt.sign(
      refreshPayload,
      process.env.JWT_REFRESH_SECRET || process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d' }
    );
    
    // 存储刷新令牌
    const refreshTokenHash = crypto.createHash('sha256').update(refreshToken).digest('hex');
    
    await db.execute(
      'REPLACE INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL ? DAY))',
      [user.id, refreshTokenHash, parseInt(process.env.JWT_REFRESH_DAYS || 7)]
    );
    
    // 返回用户信息，排除敏感字段
    const { password: _, ...userInfo } = user;
    
    console.log(`登录成功: ${username}, 角色: ${user.role}`);
    
    res.json({
      success: true,
      message: '登录成功',
      data: {
        ...userInfo,
        accessToken,
        refreshToken
      }
    });
    
  } catch (error) {
    console.error('登录过程出错:', error);
    res.status(500).json({
      success: false,
      message: '登录失败，服务器错误'
    });
  }
}; 