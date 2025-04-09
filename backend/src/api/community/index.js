const express = require('express');
const router = express.Router();
const pool = require('../../db');

// 获取公告列表
router.get('/announcements', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM community_announcements ORDER BY announcement_updated_at DESC LIMIT 5');
    res.json(rows);
  } catch (error) {
    console.error('获取公告失败:', error);
    res.status(500).json({ message: '获取公告失败' });
  }
});

// 获取我的社区列表
router.get('/my', async (req, res) => {
  try {
    // 这里应该根据用户ID获取其加入的社区
    // 暂时返回所有社区作为示例
    const [rows] = await pool.query('SELECT * FROM communities ORDER BY created_at DESC');
    res.json(rows);
  } catch (error) {
    console.error('获取社区列表失败:', error);
    res.status(500).json({ message: '获取社区列表失败' });
  }
});

// 获取社区详情
router.get('/:id', async (req, res) => {
  try {
    const communityId = req.params.id;
    const [community] = await pool.query(
      'SELECT * FROM communities WHERE id = ?',
      [communityId]
    );
    
    if (community.length === 0) {
      return res.status(404).json({ message: '社区不存在' });
    }
    
    res.json(community[0]);
  } catch (error) {
    console.error('获取社区详情失败:', error);
    res.status(500).json({ message: '获取社区详情失败' });
  }
});

// 创建社区
router.post('/', async (req, res) => {
  try {
    const { name, type, description, cover_image, school, college, class_name, announcement } = req.body;
    
    // 验证必填字段
    if (!name || !type) {
      return res.status(400).json({ message: '社区名称和类型为必填项' });
    }

    // 暂时使用固定的用户ID（应该从会话中获取）
    const created_by = 1; // 这里应该是从会话中获取的用户ID

    const [result] = await pool.query(
      `INSERT INTO communities 
       (name, type, description, cover_image, school, college, class_name, announcement, created_by, status) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)`,
      [name, type, description, cover_image, school, college, class_name, announcement, created_by]
    );

    // 创建成功后，将创建者添加为社区所有者
    await pool.query(
      `INSERT INTO community_members (community_id, user_id, role) VALUES (?, ?, 'owner')`,
      [result.insertId, created_by]
    );

    res.status(201).json({ 
      id: result.insertId, 
      message: '社区创建成功' 
    });
  } catch (error) {
    console.error('创建社区失败:', error);
    res.status(500).json({ message: '创建社区失败' });
  }
});

// 获取社区帖子列表
router.get('/:id/posts', async (req, res) => {
  try {
    const communityId = req.params.id;
    const page = parseInt(req.query.page) || 1;
    const pageSize = parseInt(req.query.pageSize) || 10;
    const offset = (page - 1) * pageSize;
    
    // 获取总帖子数
    const [totalResult] = await pool.query(
      'SELECT COUNT(*) as total FROM community_posts WHERE community_id = ?',
      [communityId]
    );
    
    // 获取帖子列表
    const [posts] = await pool.query(
      `SELECT * FROM community_posts 
       WHERE community_id = ? 
       ORDER BY created_at DESC 
       LIMIT ? OFFSET ?`,
      [communityId, pageSize, offset]
    );
    
    res.json({
      posts,
      total: totalResult[0].total,
      page,
      pageSize
    });
  } catch (error) {
    console.error('获取帖子列表失败:', error);
    res.status(500).json({ message: '获取帖子列表失败' });
  }
});

// 获取社区成员列表
router.get('/:id/members', async (req, res) => {
  try {
    const communityId = req.params.id;
    
    // 先验证社区是否存在
    const [community] = await pool.query(
      'SELECT id FROM communities WHERE id = ?',
      [communityId]
    );
    
    if (community.length === 0) {
      return res.status(404).json({ message: '社区不存在' });
    }
    
    // 获取该社区的成员列表
    const [members] = await pool.query(
      `SELECT cm.community_id, cm.user_id, cm.role, u.username 
       FROM community_members cm 
       JOIN users u ON cm.user_id = u.id 
       WHERE cm.community_id = ?
       ORDER BY 
         CASE cm.role 
           WHEN 'owner' THEN 1 
           WHEN 'admin' THEN 2 
           ELSE 3 
         END,
         u.username`,
      [communityId]
    );
    
    res.json({
      members: members,
      total: members.length
    });
  } catch (error) {
    console.error('获取成员列表失败:', error);
    res.status(500).json({ message: '获取成员列表失败' });
  }
});

// 获取社区的热门帖子
router.get('/:id/featured-posts', async (req, res) => {
  try {
    const communityId = req.params.id;
    
    // 定义热门帖子的条件：浏览量>1000或点赞数>200或评论数>50
    const [featuredPosts] = await pool.query(
      `SELECT * FROM community_posts 
       WHERE community_id = ? 
       AND (view_count > 1000 OR like_count > 200 OR comment_count > 50)
       ORDER BY view_count DESC, like_count DESC, comment_count DESC 
       LIMIT 5`,
      [communityId]
    );
    
    res.json(featuredPosts);
  } catch (error) {
    console.error('获取热门帖子失败:', error);
    res.status(500).json({ message: '获取热门帖子失败' });
  }
});

// 加入社区
router.post('/:id/join', async (req, res) => {
  try {
    const communityId = req.params.id;
    // 暂时使用固定的用户ID（应该从会话中获取）
    const userId = 1;

    // 检查用户是否已经是社区成员
    const [existingMember] = await pool.query(
      'SELECT * FROM community_members WHERE community_id = ? AND user_id = ?',
      [communityId, userId]
    );

    if (existingMember.length > 0) {
      return res.status(400).json({ message: '您已经是社区成员' });
    }

    // 添加用户为社区成员
    await pool.query(
      'INSERT INTO community_members (community_id, user_id, role) VALUES (?, ?, "member")',
      [communityId, userId]
    );

    res.status(200).json({ message: '成功加入社区' });
  } catch (error) {
    console.error('加入社区失败:', error);
    res.status(500).json({ message: '加入社区失败' });
  }
});

// 获取用户加入状态
router.get('/:id/join-status', async (req, res) => {
  try {
    const communityId = req.params.id;
    // 暂时使用固定的用户ID（应该从会话中获取）
    const userId = 1;

    const [member] = await pool.query(
      'SELECT * FROM community_members WHERE community_id = ? AND user_id = ?',
      [communityId, userId]
    );

    res.json({ isJoined: member.length > 0 });
  } catch (error) {
    console.error('获取加入状态失败:', error);
    res.status(500).json({ message: '获取加入状态失败' });
  }
});

// 退出社区
router.post('/:id/leave', async (req, res) => {
  try {
    const communityId = req.params.id;
    // 暂时使用固定的用户ID（应该从会话中获取）
    const userId = 1;

    // 检查用户是否是社区成员
    const [member] = await pool.query(
      'SELECT role FROM community_members WHERE community_id = ? AND user_id = ?',
      [communityId, userId]
    );

    if (member.length === 0) {
      return res.status(400).json({ message: '您不是该社区成员' });
    }

    // 检查是否是社区所有者
    if (member[0].role === 'owner') {
      return res.status(400).json({ message: '社区所有者不能退出社区' });
    }

    // 删除用户的社区成员记录
    await pool.query(
      'DELETE FROM community_members WHERE community_id = ? AND user_id = ?',
      [communityId, userId]
    );

    res.status(200).json({ message: '成功退出社区' });
  } catch (error) {
    console.error('退出社区失败:', error);
    res.status(500).json({ message: '退出社区失败' });
  }
});

module.exports = router; 