const express = require('express');
const router = express.Router();
const testCaseService = require('../services/testCase');
const auth = require('../middleware/auth');

// 所有路由都需要先进行token验证
router.use(auth.authenticateToken);

// 获取题目的显示样例
router.get('/examples/:problemId', async (req, res) => {
    try {
        const examples = await testCaseService.getExampleTestCases(req.params.problemId);
        res.json(examples);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// 以下接口需要管理员权限
const adminRoutes = express.Router();
adminRoutes.use(auth.checkAdminRole);

// 获取题目的所有测试用例（包括隐藏的）
adminRoutes.get('/all/:problemId', async (req, res) => {
    try {
        const testCases = await testCaseService.getAllTestCases(req.params.problemId);
        res.json(testCases);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// 添加测试用例
adminRoutes.post('/', async (req, res) => {
    try {
        const testCase = await testCaseService.addTestCase(req.body);
        res.status(201).json(testCase);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// 更新测试用例
adminRoutes.put('/:id', async (req, res) => {
    try {
        const testCase = await testCaseService.updateTestCase(req.params.id, req.body);
        res.json(testCase);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// 删除测试用例
adminRoutes.delete('/:id', async (req, res) => {
    try {
        const success = await testCaseService.deleteTestCase(req.params.id);
        if (success) {
            res.status(204).send();
        } else {
            res.status(404).json({ message: '测试用例不存在' });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// 将管理员路由挂载到主路由
router.use('/admin', adminRoutes);

module.exports = router; 