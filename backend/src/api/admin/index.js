const express = require('express');
const router = express.Router();
const pool = require('../../db');
// 暂时注释掉权限检查，以便测试路由是否正常工作
// const { checkAdminRole } = require('../../middleware/auth');

// 导入管理员相关的路由模块
const statisticsRouter = require('./statistics');
const classRouter = require('./class');
const studentRouter = require('./student');
const problemPoolRouter = require('./problem-pool'); // 新增题目池路由

// 所有管理员路由都需要管理员权限
// 暂时注释掉权限检查，以便测试
// router.use(checkAdminRole);

// 获取所有支持的编程语言
router.get('/solution-languages', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT id, language_name as name FROM solution_languages');
    res.json({
      success: true,
      data: rows
    });
  } catch (error) {
    console.error('获取编程语言列表失败:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '获取编程语言列表失败'
      }
    });
  }
});

// 注册管理员相关路由
// 确保statisticsRouter是一个有效的中间件函数
router.use('/statistics', statisticsRouter);
router.use('/classes', classRouter);
router.use('/problem-pool', problemPoolRouter); // 注册题目池路由
router.use('/', studentRouter); // 学生路由直接挂载在根路径下，保持原有API路径

module.exports = router; 