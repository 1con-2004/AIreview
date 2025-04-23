const express = require('express');
const router = express.Router(); // 创建一个路由器实例

// 导入所有路由
const problemsRouter = require('./problems/index'); // 导入 problems 路由
const loginRouter = require('./login/index'); // 导入 login 路由
const authRouter = require('../routes/auth'); // 添加 auth 路由
const learningPlansRouter = require('./learning-plans');
const classroomRouter = require('./classroom/index'); // 导入课堂路由

// 导入各个路由模块
const userRouter = require('./user');
const adminRouter = require('./admin');

router.use('/problems', problemsRouter); // 使用 problems 路由
router.use('/login', loginRouter); // 使用 login 路由
router.use('/auth', authRouter); // 使用 auth 路由
router.use('/learning-plans', learningPlansRouter);
router.use('/classroom', classroomRouter); // 使用课堂路由

// 注册路由
router.use('/user', userRouter);
router.use('/admin', adminRouter);

// 其他路由... 

router.get('/test', (req, res) => {
    res.send('Test route is working!');
});

// 导出路由器实例
module.exports = router; 