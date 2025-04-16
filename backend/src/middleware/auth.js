const jwt = require('jsonwebtoken');
const jwtConfig = require('../config/jwt');

const authenticateToken = (req, res, next) => {
  console.log('验证请求头:', req.headers);
  const authHeader = req.headers['authorization'];
  console.log('Authorization头部:', authHeader);
  const token = authHeader && authHeader.split(' ')[1];
  console.log('提取的token:', token);

  if (!token) {
    return res.status(401).json({
      success: false,
      message: '未提供认证令牌'
    });
  }

  jwt.verify(token, jwtConfig.SECRET_KEY, (err, decoded) => {
    if (err) {
      console.error('令牌验证失败:', err.message);
      
      if (err.name === 'TokenExpiredError') {
        return res.status(401).json({
          success: false,
          message: '令牌已过期',
          code: 'TOKEN_EXPIRED'
        });
      }
      
      return res.status(403).json({
        success: false,
        message: '令牌无效',
        code: 'TOKEN_INVALID',
        error: err.message
      });
    }

    console.log('令牌验证成功，用户信息:', decoded);
    req.user = decoded;
    next();
  });
};

// 检查用户是否是管理员的中间件
const isAdmin = (req, res, next) => {
  console.log('检查管理员权限，用户信息:', req.user);
  if (req.user && req.user.role === 'admin') {
    next();
  } else {
    res.status(403).json({
      success: false,
      message: '需要管理员权限'
    });
  }
};

// 用户身份验证相关中间件

/**
 * 检查用户是否已登录的中间件
 */
const checkAuth = (req, res, next) => {
  // 检查用户是否已登录
  if (!req.user) {
    return res.status(401).json({
      code: 401,
      message: '未登录，请先登录'
    });
  }
  
  // 用户已登录，继续执行下一个中间件
  next();
};

/**
 * 检查用户是否具有管理员角色的中间件
 */
const checkAdminRole = (req, res, next) => {
  console.log('检查管理员权限');
  
  // 检查用户是否已登录
  if (!req.user) {
    return res.status(401).json({
      code: 401,
      message: '未登录，请先登录'
    });
  }

  // 检查用户是否具有管理员角色
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      code: 403,
      message: '权限不足，需要管理员权限'
    });
  }

  // 用户已登录且具有管理员角色，继续执行下一个中间件
  next();
};

/**
 * 检查用户是否具有教师角色的中间件
 */
const checkTeacherRole = (req, res, next) => {
  // 检查用户是否已登录
  if (!req.user) {
    return res.status(401).json({
      code: 401,
      message: '未登录，请先登录'
    });
  }

  // 检查用户是否具有教师角色
  if (req.user.role !== 'teacher' && req.user.role !== 'admin') {
    return res.status(403).json({
      code: 403,
      message: '权限不足，需要教师权限'
    });
  }

  // 用户已登录且具有教师角色，继续执行下一个中间件
  next();
};

module.exports = {
  authenticateToken,
  isAdmin,
  checkAuth,
  checkAdminRole,
  checkTeacherRole
}; 