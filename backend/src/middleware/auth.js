const jwt = require('jsonwebtoken');
const jwtConfig = require('../config/jwt');
const { logConfig } = require('../config/logging');

const authenticateToken = (req, res, next) => {
  const requestId = `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  
  // 根据日志级别决定是否输出详细认证日志
  const shouldLogDetailed = logConfig.auth.shouldLogDetailed();
  const shouldLogBasic = logConfig.auth.shouldLogBasic();
  const shouldLogErrors = logConfig.auth.shouldLogErrors();
  
  if (shouldLogDetailed) {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] =========认证开始=========`);
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 请求路径: ${req.method} ${req.originalUrl}`);
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 请求IP: ${req.ip}`);
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 请求头: ${JSON.stringify(req.headers)}`);
  }
  
  const authHeader = req.headers['authorization'];
  
  if (shouldLogDetailed) {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] Authorization头部: ${authHeader}`);
  }
  
  const token = authHeader && authHeader.split(' ')[1];
  
  if (shouldLogDetailed) {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 提取的token: ${token ? token.substring(0, 20) + '...' : 'null'}`);
  }

  if (!token) {
    if (shouldLogBasic) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 未提供认证令牌，拒绝请求`);
    }
    return res.status(401).json({
      success: false,
      message: '未提供认证令牌'
    });
  }

  // 记录使用的密钥前10个字符，用于调试
  if (shouldLogDetailed) {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 使用的密钥前缀: ${jwtConfig.SECRET_KEY.substring(0, 10)}...`);
  }
  
  try {
    const decoded = jwt.verify(token, jwtConfig.SECRET_KEY);
    
    if (shouldLogDetailed) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 令牌验证成功，用户信息:`, decoded);
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户ID: ${decoded.id}, 用户名: ${decoded.username}, 角色: ${decoded.role}`);
    } else if (shouldLogBasic) {
      console.log(`[INFO] [${new Date().toISOString()}] [${requestId}] 用户认证成功: ${decoded.username} (${decoded.role})`);
    }
    
    // 在请求对象中添加requestId以便在后续处理中使用
    req.requestId = requestId;
    req.user = decoded;
    
    if (shouldLogDetailed) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] =========认证完成=========`);
    }
    next();
  } catch (err) {
    if (shouldLogErrors) {
      console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 令牌验证失败:`, err.message);
    }
      
    if (err.name === 'TokenExpiredError') {
      if (shouldLogBasic) {
        console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 令牌已过期`);
      }
      return res.status(401).json({
        success: false,
        message: '令牌已过期',
        code: 'TOKEN_EXPIRED'
      });
    }
    
    // 增加令牌无效的详细错误信息
    if (shouldLogDetailed) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 令牌无效: ${err.name}, 错误: ${err.message}`);
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 令牌内容: ${token}`);
    
      try {
        // 尝试解码令牌而不验证，以查看内容
        const decoded = jwt.decode(token);
        console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 解码后的令牌内容:`, decoded);
      } catch (decodeErr) {
        console.error(`[ERROR] [${new Date().toISOString()}] [${requestId}] 无法解码令牌:`, decodeErr.message);
      }
    }
    
    return res.status(403).json({
      success: false,
      message: '令牌无效',
      code: 'TOKEN_INVALID',
      error: err.message
    });
  }
};

// 检查用户是否是管理员的中间件
const isAdmin = (req, res, next) => {
  const requestId = req.requestId || `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  const shouldLogDetailed = logConfig.auth.shouldLogDetailed();
  
  if (shouldLogDetailed) {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 检查管理员权限，用户信息:`, req.user);
  }
  
  if (req.user && req.user.role === 'admin') {
    if (shouldLogDetailed) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户具有管理员权限，允许访问`);
    }
    next();
  } else {
    if (shouldLogDetailed) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户缺乏管理员权限，拒绝访问`);
    }
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
  const requestId = req.requestId || `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  const shouldLogDetailed = logConfig.auth.shouldLogDetailed();
  
  if (shouldLogDetailed) {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 检查用户是否已登录`);
  }
  
  // 检查用户是否已登录
  if (!req.user) {
    if (shouldLogDetailed) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户未登录，拒绝访问`);
    }
    return res.status(401).json({
      code: 401,
      message: '未登录，请先登录'
    });
  }
  
  if (shouldLogDetailed) {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户已登录，允许访问`);
  }
  // 用户已登录，继续执行下一个中间件
  next();
};

/**
 * 检查用户是否具有管理员角色的中间件
 */
const checkAdminRole = (req, res, next) => {
  const requestId = req.requestId || `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  const shouldLogDetailed = logConfig.auth.shouldLogDetailed();
  
  if (shouldLogDetailed) {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 检查管理员权限`);
  }
  
  // 检查用户是否已登录
  if (!req.user) {
    if (shouldLogDetailed) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户未登录，拒绝访问`);
    }
    return res.status(401).json({
      code: 401,
      message: '未登录，请先登录'
    });
  }

  // 检查用户是否具有管理员角色
  if (req.user.role !== 'admin') {
    if (shouldLogDetailed) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户角色: ${req.user.role}，缺乏管理员权限，拒绝访问`);
    }
    return res.status(403).json({
      code: 403,
      message: '权限不足，需要管理员权限'
    });
  }

  if (shouldLogDetailed) {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户具有管理员权限，允许访问`);
  }
  // 用户已登录且具有管理员角色，继续执行下一个中间件
  next();
};

/**
 * 检查用户是否具有教师角色的中间件
 */
const checkTeacherRole = (req, res, next) => {
  const shouldLogDetailed = logConfig.auth.shouldLogDetailed();
  const requestId = req.requestId || `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  
  // 检查用户是否已登录
  if (!req.user) {
    if (shouldLogDetailed) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户未登录，拒绝访问`);
    }
    return res.status(401).json({
      code: 401,
      message: '未登录，请先登录'
    });
  }

  // 检查用户是否具有教师角色
  if (req.user.role !== 'teacher' && req.user.role !== 'admin') {
    if (shouldLogDetailed) {
      console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户角色: ${req.user.role}，缺乏教师权限，拒绝访问`);
    }
    return res.status(403).json({
      code: 403,
      message: '权限不足，需要教师权限'
    });
  }

  if (shouldLogDetailed) {
    console.log(`[DEBUG] [${new Date().toISOString()}] [${requestId}] 用户具有教师权限，允许访问`);
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