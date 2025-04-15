const express = require('express');
const router = express.Router();
const problemPoolController = require('../../controllers/problemPoolController');

// 获取题目池统计信息
router.get('/statistics', problemPoolController.getStatistics);

// 获取题目池列表（带分页和筛选）
router.get('/list', problemPoolController.getProblemList);

// 获取题目池分类列表
router.get('/categories', problemPoolController.getCategoryList);

// 获取题目标签列表
router.get('/tags', problemPoolController.getTagList);

// 获取题目详情
router.get('/:id', problemPoolController.getProblemDetail);

// 获取题目测试用例
router.get('/:id/test-cases', problemPoolController.getProblemTestCases);

// 获取题目解决方案
router.get('/:id/solution', problemPoolController.getProblemSolution);

// 引用题目到正式题库
router.post('/import/:id', problemPoolController.importProblem);

// 新增接口：直接将题目导入到正式题库
router.post('/import', problemPoolController.importProblemDirect);

// 从题目池删除题目
router.delete('/:id', problemPoolController.deleteProblem);

module.exports = router; 