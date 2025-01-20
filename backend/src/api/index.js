const cors = require('cors');
const express = require('express');
const router = express.Router(); // 创建一个路由器实例
const problemsRouter = require('./problems/index'); // 导入 problems 路由
const loginRouter = require('./login/index'); // 导入 login 路由

router.use(cors()); // 允许跨域请求
router.use(express.json()); // 解析 JSON 请求体

router.use('/problems', problemsRouter); // 使用 problems 路由
router.use('/login', loginRouter); // 使用 login 路由

// 其他路由... 

router.get('/test', (req, res) => {
    res.send('Test route is working!');
});

// 导出路由器实例
module.exports = router; 