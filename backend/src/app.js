const express = require('express');
const cors = require('cors');
const session = require('express-session');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
const app = express();
const apiRouter = require('./api');
const loginRouter = require('./api/login');
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

// 添加请求日志中间件
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

// 配置 CORS
app.use(cors({
  origin: 'http://localhost:8080', // 修改为正确的前端地址
  credentials: true
}));

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

app.use('/icons', express.static(iconsPath, {
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

// 启动服务器
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

module.exports = app; 