const express = require('express');
const router = express.Router();
const mysql = require('../utils/mysql');

// 获取题目难度分布
router.get('/difficulty-distribution', async (req, res) => {
  try {
    const query = `
      SELECT 
        difficulty,
        COUNT(*) as value,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM problems), 2) as percentage
      FROM problems
      GROUP BY difficulty
      ORDER BY FIELD(difficulty, '简单', '中等', '困难');
    `;
    const [results] = await mysql.query(query, []);
    
    const data = results.map(item => ({
      name: item.difficulty,
      value: item.value,
      percentage: item.percentage
    }));
    
    res.json({ success: true, data });
  } catch (error) {
    console.error('获取题目难度分布失败:', error);
    res.status(500).json({ success: false, message: '获取题目难度分布失败' });
  }
});

// 获取题目分类树状图数据
router.get('/category-tree', async (req, res) => {
  try {
    const query = `
      SELECT 
        pc1.id as parent_id,
        pc1.name as parent_name,
        pc2.id as child_id,
        pc2.name as child_name,
        COUNT(DISTINCT pcr.problem_id) as problem_count
      FROM problem_categories pc1
      LEFT JOIN problem_categories pc2 ON pc2.parent_id = pc1.id
      LEFT JOIN problem_category_relations pcr ON pc2.id = pcr.category_id
      WHERE pc1.level = ?
      GROUP BY pc1.id, pc1.name, pc2.id, pc2.name
      ORDER BY pc1.name, pc2.name;
    `;
    const [results] = await mysql.query(query, [1]);
    
    // 转换为树状结构
    const treeData = {
      name: '题目分类',
      children: []
    };
    
    const categoryMap = new Map();
    results.forEach(row => {
      if (!categoryMap.has(row.parent_name)) {
        categoryMap.set(row.parent_name, {
          name: row.parent_name,
          children: []
        });
        treeData.children.push(categoryMap.get(row.parent_name));
      }
      
      if (row.child_name) {
        categoryMap.get(row.parent_name).children.push({
          name: row.child_name,
          value: row.problem_count
        });
      }
    });
    
    res.json({ success: true, data: treeData });
  } catch (error) {
    console.error('获取题目分类树状图数据失败:', error);
    res.status(500).json({ success: false, message: '获取题目分类树状图数据失败' });
  }
});

// 获取题目完成率排行
router.get('/completion-rank', async (req, res) => {
  try {
    const query = `
      SELECT 
        problem_number,
        title,
        difficulty,
        IFNULL(accepted_submissions, 0) as accepted_submissions,
        IFNULL(total_submissions, 0) as total_submissions,
        IFNULL(ROUND(acceptance_rate, 2), 0) as completion_rate,
        CASE 
          WHEN total_submissions < 50 THEN '提交次数较少'
          WHEN total_submissions < 100 THEN '提交次数适中'
          ELSE '提交次数充足'
        END as submission_level,
        CASE
          WHEN total_submissions >= 50 AND acceptance_rate >= 90 THEN '简单'
          WHEN total_submissions >= 50 AND acceptance_rate >= 70 THEN '适中'
          WHEN total_submissions >= 50 THEN '困难'
          ELSE '数据不足'
        END as difficulty_level
      FROM problems
      WHERE total_submissions >= 20  -- 设置最低提交次数门槛
      ORDER BY 
        CASE 
          WHEN total_submissions < 50 THEN 2  -- 提交次数少的排后面
          ELSE 1
        END,
        acceptance_rate DESC,
        total_submissions DESC
      LIMIT 10;
    `;
    const [results] = await mysql.query(query);
    
    // 添加额外的分析信息
    const data = results.map(item => ({
      ...item,
      analysis: `该题目共有${item.total_submissions}次提交，通过${item.accepted_submissions}次，` +
                `通过率${item.completion_rate}%。${item.submission_level}，` +
                `难度评估：${item.difficulty_level}。`
    }));
    
    res.json({ success: true, data });
  } catch (error) {
    console.error('获取题目完成率排行失败:', error);
    res.status(500).json({ success: false, message: '获取题目完成率排行失败' });
  }
});

// 获取难度分布柱状图数据
router.get('/difficulty-bar', async (req, res) => {
  try {
    const query = `
      SELECT 
        difficulty,
        COUNT(*) as count
      FROM problems
      GROUP BY difficulty
      ORDER BY FIELD(difficulty, '简单', '中等', '困难');
    `;
    const [results] = await mysql.query(query, []);
    
    const data = results.map(item => ({
      name: item.difficulty,
      value: item.count
    }));
    
    res.json({ success: true, data });
  } catch (error) {
    console.error('获取难度分布柱状图数据失败:', error);
    res.status(500).json({ success: false, message: '获取难度分布柱状图数据失败' });
  }
});

module.exports = router; 