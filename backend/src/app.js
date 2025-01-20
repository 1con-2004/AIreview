const express = require('express');
const cors = require('cors');
const app = express();
const apiRouter = require('./api/index'); // 导入 API 路由

// 配置 CORS
app.use(cors({
  origin: 'http://localhost:8080', // 替换为你的前端地址
  credentials: true
}));

// 解析 JSON 请求体
app.use(express.json());

// 使用 API 路由
app.use('/api', apiRouter); // 挂载 API 路由

// 启动服务器
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
}); 