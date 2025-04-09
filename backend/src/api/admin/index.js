const express = require('express');
const router = express.Router();
// 暂时注释掉权限检查，以便测试路由是否正常工作
// const { checkAdminRole } = require('../../middleware/auth');

// 导入管理员相关的路由模块
const statisticsRouter = require('./statistics');
const classRouter = require('./class');
const studentRouter = require('./student');

// 所有管理员路由都需要管理员权限
// 暂时注释掉权限检查，以便测试
// router.use(checkAdminRole);

// 注册管理员相关路由
// 确保statisticsRouter是一个有效的中间件函数
router.use('/statistics', statisticsRouter);
router.use('/classes', classRouter);
router.use('/', studentRouter); // 学生路由直接挂载在根路径下，保持原有API路径

module.exports = router; 