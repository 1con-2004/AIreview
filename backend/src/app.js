const express = require('express');
const cors = require('cors');
const session = require('express-session');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
const app = express();
const apiRouter = require('./api');
const loginRouter = require('./api/login');
const registerRouter = require('./api/register');
const problemRouter = require('./api/problems');
const communityRouter = require('./api/community');
const judgeRouter = require('./api/judge');
const userRouter = require('./api/user');
const aiRouter = require('./api/ai');
const learningPlansRouter = require('./api/learning-plans');
const statsRouter = require('./api/stats');
const studentRouter = require('./api/admin/student');
const classRouter = require('./api/admin/class');
const testCaseRouter = require('./routes/testCase');
const authRoutes = require('./routes/auth');
const statisticsRoutes = require('./routes/statistics');
const learningPathRoutes = require('./api/learning-path');
const dockerHelper = require('./services/judge/docker-helper');
const { logConfig, setLogLevel, setGlobalLogLevel } = require('./config/logging');

// 添加请求日志中间件
app.use((req, res, next) => {
  // 排除健康检查路径的日志输出
  if (req.url === '/api/health' || req.url.startsWith('/api/health?') || 
      req.url === '/api/health/docker' || req.url.startsWith('/api/health/docker?')) {
    return next();
  }
  
  // 检查是否应该记录API请求
  if (logConfig.api.shouldLogRequests()) {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  }
  next();
});

// 添加日志级别控制的简单API
app.get('/api/log/level/:level', (req, res) => {
  const level = parseInt(req.params.level);
  
  if (isNaN(level) || level < 0 || level > 4) {
    return res.status(400).json({
      success: false,
      message: '无效的日志级别，应为0-4之间的整数'
    });
  }
  
  // 设置全局日志级别
  setGlobalLogLevel(level);
  
  // 响应
  res.json({
    success: true,
    message: `全局日志级别已设置为 ${level}`,
    levels: {
      global: logConfig.global.level,
      auth: logConfig.auth.getLevel(),
      api: logConfig.api.getLevel(),
      database: logConfig.database.getLevel()
    }
  });
});

// 获取当前日志级别
app.get('/api/log/level', (req, res) => {
  res.json({
    success: true,
    levels: {
      global: logConfig.global.level,
      auth: logConfig.auth.getLevel(),
      api: logConfig.api.getLevel(),
      database: logConfig.database.getLevel()
    }
  });
});

// 健康检查API端点
let healthCheckCount = 0;
let lastHealthCheckLog = Date.now();
app.get('/api/health', async (req, res) => {
  // 只在首次请求、每隔5分钟或出错时记录日志
  const currentTime = Date.now();
  const shouldLog = healthCheckCount === 0 || 
                   (currentTime - lastHealthCheckLog > 5 * 60 * 1000);
  
  if (shouldLog) {
    console.log(`健康检查请求被调用 (第${healthCheckCount + 1}次)`);
    lastHealthCheckLog = currentTime;
  }
  
  healthCheckCount++;
  
  try {
    // 检查Docker可用性
    const isDockerAvailable = await dockerHelper.checkDockerAvailability();
    
    // 如果Docker不可用，获取更详细的诊断信息
    let dockerDiagnostics = null;
    if (!isDockerAvailable) {
      console.log('Docker不可用，进行详细诊断');
      dockerDiagnostics = await dockerHelper.diagnoseDockerPermissions();
    }
    
    // 返回健康状态
    res.json({
      status: 'ok',
      timestamp: new Date().toISOString(),
      dockerAvailable: isDockerAvailable,
      services: {
        api: true,
        judge: isDockerAvailable
      },
      diagnostics: isDockerAvailable ? null : dockerDiagnostics
    });
  } catch (error) {
    console.error('健康检查失败:', error);
    res.status(500).json({
      status: 'error',
      message: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

// 详细Docker诊断API端点
let dockerDiagnosticCount = 0;
let lastDockerDiagnosticLog = Date.now();
app.get('/api/health/docker', async (req, res) => {
  // 只在首次请求、每隔5分钟或出错时记录日志
  const currentTime = Date.now();
  const shouldLog = dockerDiagnosticCount === 0 || 
                   (currentTime - lastDockerDiagnosticLog > 5 * 60 * 1000);
  
  if (shouldLog) {
    console.log(`Docker诊断API请求被调用 (第${dockerDiagnosticCount + 1}次)`);
    lastDockerDiagnosticLog = currentTime;
  }
  
  dockerDiagnosticCount++;
  
  try {
    // 获取Docker信息
    const dockerInfo = await dockerHelper.getDockerInfo();
    
    // 获取Docker权限诊断
    const dockerDiagnostics = await dockerHelper.diagnoseDockerPermissions();
    
    // 返回诊断结果
    res.json({
      timestamp: new Date().toISOString(),
      dockerInfo,
      dockerDiagnostics
    });
  } catch (error) {
    console.error('Docker诊断失败:', error);
    res.status(500).json({
      status: 'error',
      message: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

// CORS配置
const corsOptions = {
  origin: function (origin, callback) {
    // 允许所有源
    callback(null, true);
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'Origin', 'Accept'],
  exposedHeaders: ['Content-Length', 'Content-Range'],
  optionsSuccessStatus: 200,
  maxAge: 86400 // 预检请求缓存24小时
};

app.use(cors(corsOptions));

// 配置 session
app.use(session({
  secret: 'your-secret-key',
  resave: false,
  saveUninitialized: true,
  cookie: {
    secure: false,
    maxAge: 24 * 60 * 60 * 1000 // 24小时
  }
}));

// 解析 JSON 请求体
app.use(express.json());

// 确保解析JSON请求体能够正常工作
app.use(express.urlencoded({ extended: true }));

// 添加响应头中间件，确保所有响应使用UTF-8编码，并添加跨域头
app.use((req, res, next) => {
  // 处理OPTIONS预检请求
  if (req.method === 'OPTIONS') {
    return res.status(204).end();
  }
  
  // 设置所有响应的字符集为UTF-8
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  
  // 增强JSON.stringify处理中文的能力
  const originalJson = res.json;
  res.json = function(obj) {
    // 直接调用原始json方法，不输出任何调试信息
    return originalJson.call(this, obj);
  };
  
  next();
});

// 静态文件服务
const uploadsPath = path.join(__dirname, '../public/uploads');
const iconsPath = path.join(__dirname, '../public/icons');
const avatarsPath = path.join(__dirname, '../public/uploads/avatars');
console.log('上传文件路径:', uploadsPath);
console.log('图标文件路径:', iconsPath);
console.log('头像文件路径:', avatarsPath);

// 确保目录存在
if (!fs.existsSync(uploadsPath)) {
    fs.mkdirSync(uploadsPath, { recursive: true });
    console.log('创建上传目录:', uploadsPath);
}
if (!fs.existsSync(iconsPath)) {
    fs.mkdirSync(iconsPath, { recursive: true });
    console.log('创建图标目录:', iconsPath);
}
if (!fs.existsSync(avatarsPath)) {
    fs.mkdirSync(avatarsPath, { recursive: true });
    console.log('创建头像目录:', avatarsPath);
}

// 配置静态文件中间件
app.use('/uploads', express.static(path.join(__dirname, '../public/uploads')));
// 添加 /api/uploads 路径，以便前端可以通过 /api/uploads 访问上传的文件
app.use('/api/uploads', express.static(path.join(__dirname, '../public/uploads')));

// 添加 /icons 路径，以便前端可以通过 /icons 访问图标文件
app.use('/icons', express.static(path.join(__dirname, '../public/icons')));

// 添加直接访问public目录的路径
app.use('/public', express.static(path.join(__dirname, '../public')));
app.use('/api/public', express.static(path.join(__dirname, '../public')));

app.use('/icons', express.static(iconsPath, {
    setHeaders: (res, path, stat) => {
        res.set('Access-Control-Allow-Origin', '*');
        res.set('Access-Control-Allow-Methods', 'GET');
        res.set('Cache-Control', 'public, max-age=3600');
    }
}));

// 为icons提供额外的路径支持
app.use('/api/icons', express.static(iconsPath, {
    setHeaders: (res, path, stat) => {
        res.set('Access-Control-Allow-Origin', '*');
        res.set('Access-Control-Allow-Methods', 'GET');
        res.set('Cache-Control', 'public, max-age=3600');
    }
}));

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, avatarsPath);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, 'avatar-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

// 使用 API 路由
app.use('/api', apiRouter);
app.use('/api/login', loginRouter);
app.use('/api/register', registerRouter);
app.use('/api/problems', problemRouter);
app.use('/api/communities', communityRouter);
app.use('/api/judge', judgeRouter);

// 用户个人中心API路由，需要先于通用用户路由注册
app.use('/api/user/profile', require('./api/user/profile'));

// 通用用户路由
app.use('/api/user', userRouter);

app.use('/api/ai', aiRouter);
app.use('/api/learning-plans', learningPlansRouter);
app.use('/api/stats', statsRouter);
app.use('/api/admin/classes', classRouter);
app.use('/api', studentRouter);
app.use('/api/testcases', testCaseRouter);
app.use('/api/auth', authRoutes);
app.use('/api/admin/statistics', statisticsRoutes);
app.use('/api/learning-path', learningPathRoutes);
// 添加analytics分析路由
app.use('/api/analytics', require('./api/analytics'));

// 添加调试日志，记录所有注册的路由
console.log('注册的路由列表:');
const listRoutes = (router, prefix = '') => {
  router.stack.forEach(layer => {
    if (layer.route) {
      // 路由层
      const path = prefix + layer.route.path;
      const methods = Object.keys(layer.route.methods).map(m => m.toUpperCase()).join(',');
      console.log(`${methods} ${path}`);
    } else if (layer.name === 'router' && layer.handle.stack) {
      // 路由中间件
      listRoutes(layer.handle, prefix);
    }
  });
};

// 遍历所有已注册路由并打印
Object.keys(app._router.stack).forEach(key => {
  const layer = app._router.stack[key];
  if (layer.route) {
    // 路由层
    const path = layer.route.path;
    const methods = Object.keys(layer.route.methods).map(m => m.toUpperCase()).join(',');
    console.log(`${methods} ${path}`);
  } else if (layer.name === 'router' && layer.handle.stack) {
    // 路由中间件
    listRoutes(layer.handle, layer.regexp.toString().includes('api') ? '/api' : '');
  }
});

// 确保捕获所有未处理路由
app.use((req, res, next) => {
  console.log(`[404] 未找到路由: ${req.method} ${req.originalUrl}`);
  res.status(404).json({
    success: false,
    message: `未找到请求的资源: ${req.method} ${req.originalUrl}`
  });
});

// 添加错误处理中间件
app.use((err, req, res, next) => {
    console.error('错误:', err);
    res.status(500).json({
        success: false,
        message: '服务器错误',
        error: err.message
    });
});

// 在app.listen之前添加初始化代码
// 初始化Docker环境
(async () => {
  try {
    await dockerHelper.initializeDockerEnvironment();
    console.log('Docker环境初始化成功，判题系统已就绪');
  } catch (error) {
    console.error('Docker环境初始化失败:', error.message);
    console.warn('判题系统可能无法正常工作，请检查Docker配置');
  }
})();

// 启动服务器
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

module.exports = app;