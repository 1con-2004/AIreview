const express = require('express');
const router = express.Router();
const db = require('../../db'); // 确保路径正确

// 获取所有题目
router.get('/', async (req, res) => {
    console.log('GET /api/problems called'); // 添加日志
    try {
        const [rows] = await db.query('SELECT * FROM problems');
        res.json(rows); // 确保返回的每个问题都包含 tags 字段
    } catch (error) {
        res.status(500).json({ error: '数据库查询失败' });
    }
});

// 添加新题目
router.post('/', async (req, res) => {
    const { problem_number, title, difficulty, total_submissions, acceptance_rate, tags, description, input_example, output_example } = req.body;
    try {
        await db.query('INSERT INTO problems (problem_number, title, difficulty, total_submissions, acceptance_rate, tags, description, input_example, output_example) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', 
        [problem_number, title, difficulty, total_submissions, acceptance_rate, tags, description, input_example, output_example]);
        res.status(201).json({ message: '题目添加成功' });
    } catch (error) {
        res.status(500).json({ error: '添加题目失败' });
    }
});

router.get('/test', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT 1'); // 测试查询
        res.json({ success: true, data: rows });
    } catch (error) {
        res.status(500).json({ error: '数据库连接失败' });
    }
});

// 获取所有标签
router.get('/tags', async (req, res) => {
    try {
        const [tags] = await db.query('SELECT DISTINCT tags FROM problems'); // 获取所有标签
        const tagArray = tags.flatMap(tag => tag.tags.split(',')); // 将标签字符串拆分为数组并合并
        console.log('获取到的标签数据:', tagArray); // 在控制台打印获取到的标签数据
        res.json(tagArray); // 返回标签数组
    } catch (error) {
        console.error('获取标签失败:', error);
        res.status(500).json({ message: '获取标签失败' });
    }
});

module.exports = router;