exports.verifyToken = (req, res, next) => {
  // 从请求头获取令牌
  const token = getTokenFromHeader(req);
  
  if (!token) {
    return res.status(401).json({
      success: false,
      message: '未提供认证令牌'
    });
  }
  
  try {
    // 验证令牌
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // 检查令牌类型
    if (decoded.type !== 'access') {
      return res.status(401).json({
        success: false,
        message: '无效的令牌类型'
      });
    }
    
    // 将解码后的用户信息添加到请求对象
    req.user = decoded;
    next();
  } catch (error) {
    console.error('令牌验证失败:', error.message);
    
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: '令牌已过期'
      });
    }
    
    return res.status(401).json({
      success: false,
      message: '无效的认证令牌'
    });
  }
};

// 从请求头获取令牌的辅助函数
function getTokenFromHeader(req) {
  const authHeader = req.headers.authorization;
  
  if (authHeader && authHeader.startsWith('Bearer ')) {
    return authHeader.substring(7);
  }
  
  return null;
} 