const express = require('express');
const router = express.Router();
const db = require('../../db');
const { authenticateToken } = require('../../middleware/auth');

// 获取仪表盘统计数据
router.get('/dashboard', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取仪表盘统计数据, userId:', userId);

    // 分别查询每个统计数据，方便调试
    const [userCount] = await db.query('SELECT COUNT(*) as count FROM users');
    console.log('用户总数:', userCount[0].count);

    const [problemCount] = await db.query('SELECT COUNT(*) as count FROM problems');
    console.log('题目总数:', problemCount[0].count);

    const [visitCount] = await db.query(`
      SELECT COUNT(DISTINCT user_id) as count
      FROM user_visits 
      WHERE DATE(visit_date) = CURDATE()
    `);
    console.log('今日访问数:', visitCount[0].count);

    const [postCount] = await db.query(`
      SELECT COUNT(*) as count
      FROM community_posts 
      WHERE DATE(created_at) = CURDATE()
    `);
    console.log('今日帖子数:', postCount[0].count);

    // 组合所有统计数据
    const stats = {
      total_users: userCount[0].count,
      total_problems: problemCount[0].count,
      today_visits: visitCount[0].count,
      today_posts: postCount[0].count
    };

    console.log('返回的统计数据:', stats);

    res.json({
      success: true,
      data: stats
    });
  } catch (error) {
    console.error('获取仪表盘统计数据失败:', error);
    res.status(500).json({
      success: false,
      message: '获取仪表盘统计数据失败'
    });
  }
});

// 获取趋势数据
router.get('/trend/:type', authenticateToken, async (req, res) => {
  try {
    const { type } = req.params;
    const days = parseInt(req.query.days) || 7;
    console.log(`获取${type}趋势数据, 天数:`, days);

    let query = '';
    switch (type) {
      case 'users':
        // 获取用户注册趋势
        query = `
          SELECT 
            DATE(created_at) as date,
            COUNT(*) as count
          FROM users
          WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
          GROUP BY DATE(created_at)
          ORDER BY date
        `;
        break;
      
      case 'visits':
        // 获取访问量趋势
        query = `
          SELECT 
            visit_date as date,
            COUNT(DISTINCT user_id) as count
          FROM user_visits
          WHERE visit_date >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
          GROUP BY visit_date
          ORDER BY date
        `;
        break;
      
      default:
        return res.status(400).json({
          success: false,
          message: '不支持的趋势类型'
        });
    }

    const [rows] = await db.query(query, [days]);
    console.log(`${type}趋势数据:`, rows);

    // 生成完整的日期范围
    const dates = [];
    const values = [];
    const now = new Date();
    for (let i = days - 1; i >= 0; i--) {
      const date = new Date(now);
      date.setDate(date.getDate() - i);
      const dateStr = date.toISOString().split('T')[0];
      dates.push(dateStr);
      
      // 查找对应日期的数据
      const row = rows.find(r => r.date.toISOString().split('T')[0] === dateStr);
      values.push(row ? row.count : 0);
    }

    res.json({
      success: true,
      data: {
        dates,
        values
      }
    });
  } catch (error) {
    console.error('获取趋势数据失败:', error);
    res.status(500).json({
      success: false,
      message: '获取趋势数据失败'
    });
  }
});

// 记录用户访问
router.post('/record-visit', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('记录用户访问, userId:', userId);

    // 使用 INSERT ... ON DUPLICATE KEY UPDATE 语句
    await db.query(`
      INSERT INTO user_visits (user_id, visit_date, visit_count) 
      VALUES (?, CURDATE(), 1)
      ON DUPLICATE KEY UPDATE 
        visit_count = visit_count + 1
    `, [userId]);

    console.log('访问记录已更新');

    res.json({
      success: true,
      message: '访问记录已更新'
    });
  } catch (error) {
    console.error('记录用户访问失败:', error);
    res.status(500).json({
      success: false,
      message: '记录用户访问失败'
    });
  }
});

module.exports = router; 