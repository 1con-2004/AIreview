const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const pool = require('../../db');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { authenticateToken } = require('../../middleware/auth');
const mysql = require('mysql2');
const dbConfig = require('../../config/db');
const jwt = require('jsonwebtoken');
const jwtConfig = require('../../config/jwt');

// 配置文件上传
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const uploadDir = 'public/uploads/avatars';
    // 确保上传目录存在
    if (!fs.existsSync(uploadDir)){
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, 'avatar-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 限制5MB
  },
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|gif/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    if (extname && mimetype) {
      return cb(null, true);
    }
    cb(new Error('只支持图片文件!'));
  }
});

// 添加新用户
router.post('/add', authenticateToken, async (req, res) => {
  const connection = await pool.getConnection();
  try {
    console.log('添加新用户请求数据:', req.body);
    const { username, password, email, display_name, role } = req.body;

    // 验证必填字段
    if (!username || !password || !email || !role) {
      return res.status(400).json({
        success: false,
        message: '用户名、密码、邮箱和角色为必填项'
      });
    }

    // 开始事务
    await connection.beginTransaction();
    console.log('开始事务');

    // 检查用户名是否已存在
    const [existingUsers] = await connection.query(
      'SELECT id FROM users WHERE username = ?',
      [username]
    );

    if (existingUsers.length > 0) {
      await connection.rollback();
      return res.status(400).json({
        success: false,
        message: '用户名已存在'
      });
    }

    // 检查邮箱是否已存在
    const [existingEmails] = await connection.query(
      'SELECT id FROM users WHERE email = ?',
      [email]
    );

    if (existingEmails.length > 0) {
      await connection.rollback();
      return res.status(400).json({
        success: false,
        message: '邮箱已被使用'
      });
    }

    // 加密密码
    const hashedPassword = await bcrypt.hash(password, 10);
    console.log('密码加密完成');

    // 插入用户基本信息到users表
    const [userResult] = await connection.query(
      'INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, ?)',
      [username, hashedPassword, email, role]
    );
    console.log('用户基本信息插入完成，新用户ID:', userResult.insertId);

    // 获取新插入用户的ID
    const userId = userResult.insertId;

    // 插入用户详细信息到user_profile表
    try {
      const [profileResult] = await connection.query(
        'INSERT INTO user_profile (user_id, display_name, nickname) VALUES (?, ?, ?)',
        [userId, display_name || username, username]
      );
      console.log('用户详细信息插入完成，结果:', profileResult);

      // 验证profile是否成功创建
      const [profileCheck] = await connection.query(
        'SELECT * FROM user_profile WHERE user_id = ?',
        [userId]
      );
      
      if (!profileCheck || profileCheck.length === 0) {
        throw new Error('用户profile创建失败，回滚事务');
      }
      
      console.log('用户profile验证成功:', profileCheck[0]);
    } catch (profileError) {
      console.error('创建用户profile失败:', profileError);
      throw profileError;
    }

    // 提交事务
    await connection.commit();
    console.log('事务提交成功');

    res.json({
      success: true,
      message: '用户添加成功',
      data: {
        id: userId,
        username,
        email,
        role,
        display_name: display_name || username
      }
    });
  } catch (error) {
    // 如果发生错误，回滚事务
    await connection.rollback();
    console.error('添加用户失败:', error);
    res.status(500).json({
      success: false,
      message: '添加用户失败: ' + error.message
    });
  } finally {
    // 释放连接
    connection.release();
  }
});

// 获取用户信息
router.get('/info', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    
    const [rows] = await pool.query('SELECT id, username, email, avatar FROM users WHERE id = ?', [userId]);
    if (rows.length === 0) {
      return res.status(404).json({ message: '用户不存在' });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error('获取用户信息失败:', error);
    res.status(500).json({ message: '获取用户信息失败' });
  }
});

// 获取用户的所有题目完成状态
router.get('/problem-status', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    
    console.log('正在获取用户题目状态, userId:', userId);

    // 查询用户已通过的所有题目
    const query = `
      SELECT DISTINCT problem_id, 
        FIRST_VALUE(status) OVER (PARTITION BY problem_id ORDER BY created_at DESC) as status
      FROM submissions 
      WHERE user_id = ?
    `;
    
    const [results] = await pool.query(query, [userId]);
    console.log('查询到的用户题目状态:', results.length, '条记录');

    res.json({
      success: true,
      data: results
    });
  } catch (error) {
    console.error('获取用户题目状态失败:', error);
    res.status(500).json({
      success: false,
      message: '获取用户题目状态失败'
    });
  }
});

// 获取用户资料
router.get('/profile/:username', async (req, res) => {
  try {
    const { username } = req.params;
    // 添加详细日志
    console.log(`[DEBUG] [${new Date().toISOString()}] 获取用户资料请求开始`);
    console.log(`[DEBUG] [${new Date().toISOString()}] 请求参数: username=${username}`);
    console.log(`[DEBUG] [${new Date().toISOString()}] 请求头: ${JSON.stringify(req.headers)}`);
    
    // 检查认证信息
    const authHeader = req.headers.authorization;
    if (authHeader) {
      const token = authHeader.split(' ')[1];
      console.log(`[DEBUG] [${new Date().toISOString()}] 认证令牌: ${token}`);
      
      try {
        const decoded = jwt.verify(token, jwtConfig.SECRET_KEY);
        console.log(`[DEBUG] [${new Date().toISOString()}] 令牌解析结果: ${JSON.stringify(decoded)}`);
        console.log(`[DEBUG] [${new Date().toISOString()}] 当前请求用户ID: ${decoded.id}, 用户名: ${decoded.username}`);
        console.log(`[DEBUG] [${new Date().toISOString()}] 尝试获取的用户资料: ${username}`);
      } catch (error) {
        console.log(`[DEBUG] [${new Date().toISOString()}] 令牌验证失败: ${error.message}`);
      }
    } else {
      console.log(`[DEBUG] [${new Date().toISOString()}] 请求中没有认证令牌`);
    }
    
    const query = `
      SELECT u.id, u.username, u.email, up.* 
      FROM users u 
      LEFT JOIN user_profile up ON u.id = up.user_id 
      WHERE u.username = ?
    `;
    console.log(`[DEBUG] [${new Date().toISOString()}] 执行SQL查询: ${query.replace(/\s+/g, ' ')}`);
    console.log(`[DEBUG] [${new Date().toISOString()}] 查询参数: [${username}]`);
    
    const [users] = await pool.query(query, [username]);
    
    console.log(`[DEBUG] [${new Date().toISOString()}] 查询结果数量: ${users.length}`);
    
    if (users.length === 0) {
      console.log(`[DEBUG] [${new Date().toISOString()}] 未找到用户: ${username}`);
      return res.status(404).json({ message: '用户不存在' });
    }

    const user = users[0];
    // 删除敏感信息
    delete user.password;
    
    console.log(`[DEBUG] [${new Date().toISOString()}] 返回用户资料: ${JSON.stringify(user)}`);
    res.json(user);
  } catch (error) {
    console.error(`[ERROR] [${new Date().toISOString()}] 获取用户资料失败:`, error);
    res.status(500).json({ message: '服务器错误' });
  }
});

// 更新用户资料
router.patch('/profile', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const updates = req.body;
    
    // 验证更新字段
    const allowedUpdates = ['display_name', 'gender', 'birth_date', 'location', 'bio'];
    const isValidOperation = Object.keys(updates).every(update => allowedUpdates.includes(update));
    
    if (!isValidOperation) {
      return res.status(400).json({ message: '无效的更新字段' });
    }

    // 开始事务
    const connection = await pool.getConnection();
    await connection.beginTransaction();

    try {
      // 检查用户资料是否存在
      const [existingProfile] = await connection.query(
        'SELECT id FROM user_profile WHERE user_id = ?',
        [userId]
      );

      if (existingProfile.length === 0) {
        // 如果不存在，创建新记录，使用username作为nickname
        const [userResult] = await connection.query(
          'SELECT username FROM users WHERE id = ?',
          [userId]
        );
        
        const username = userResult[0].username;
        const insertFields = ['user_id', 'nickname', ...Object.keys(updates)];
        const insertValues = [userId, username, ...Object.values(updates)];
        const insertQuery = `
          INSERT INTO user_profile (${insertFields.join(', ')})
          VALUES (${insertFields.map(() => '?').join(', ')})
        `;
        await connection.query(insertQuery, insertValues);
      } else {
        // 如果存在，只更新允许的字段
        const updateFields = Object.keys(updates)
          .map(field => `${field} = ?`)
          .join(', ');
        const values = [...Object.values(updates), userId];
        const updateQuery = `
          UPDATE user_profile 
          SET ${updateFields}
          WHERE user_id = ?
        `;
        await connection.query(updateQuery, values);
      }

      // 提交事务
      await connection.commit();
      console.log('用户资料更新成功');
      res.json({ message: '更新成功' });
    } catch (error) {
      // 回滚事务
      await connection.rollback();
      throw error;
    } finally {
      // 释放连接
      connection.release();
    }
  } catch (error) {
    console.error('更新用户资料失败:', error);
    res.status(500).json({ message: '服务器错误' });
  }
});

// 上传头像
router.post('/avatar', authenticateToken, upload.single('avatar'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: '请选择要上传的图片' });
    }

    console.log('上传的文件信息:', req.file);

    // 获取用户当前的头像URL
    const [currentUser] = await pool.query(
      'SELECT avatar_url FROM user_profile WHERE user_id = ?',
      [req.user.id]
    );

    // 如果存在旧头像，删除它
    if (currentUser.length > 0 && currentUser[0].avatar_url) {
      const oldAvatarPath = path.join(__dirname, '../../../', currentUser[0].avatar_url);
      try {
        if (fs.existsSync(oldAvatarPath)) {
          fs.unlinkSync(oldAvatarPath);
          console.log('成功删除旧头像:', oldAvatarPath);
        }
      } catch (err) {
        console.error('删除旧头像失败:', err);
        // 继续执行，不影响新头像上传
      }
    }

    // 设置头像URL，使用相对路径
    // 将路径格式化为 public/uploads/avatars/filename.jpg
    const avatarUrl = `public/uploads/avatars/${req.file.filename}`;
    console.log('新头像路径:', avatarUrl);
    
    // 更新数据库中的头像URL
    const query = `
      UPDATE user_profile 
      SET avatar_url = ? 
      WHERE user_id = ?
    `;
    
    await pool.query(query, [avatarUrl, req.user.id]);
    
    res.json({ 
      message: '头像上传成功',
      avatar_url: avatarUrl
    });
  } catch (error) {
    console.error('上传头像失败:', error);
    // 如果上传失败，删除已上传的文件
    if (req.file) {
      fs.unlinkSync(req.file.path);
    }
    res.status(500).json({ message: '服务器错误' });
  }
});

// 获取用户统计信息
router.get('/stats/:username', async (req, res) => {
  try {
    const { username } = req.params;
    
    // 获取用户ID
    const [user] = await pool.query('SELECT id FROM users WHERE username = ?', [username]);
    if (!user) {
      return res.status(404).json({ message: '用户不存在' });
    }

    // 获取统计信息
    const [stats] = await pool.query(`
      SELECT 
        (SELECT COUNT(DISTINCT problem_id) 
         FROM submissions 
         WHERE user_id = ? AND status = 'Accepted') as solved_problems,
        (SELECT COUNT(*) FROM community_posts WHERE user_id = ?) as posts,
        (SELECT COUNT(*) FROM likes WHERE target_type = 'post' AND target_id IN 
            (SELECT id FROM community_posts WHERE user_id = ?)) as likes
    `, [user[0].id, user[0].id, user[0].id]);

    res.json(stats[0]);
  } catch (error) {
    console.error('获取用户统计信息失败:', error);
    res.status(500).json({ message: '服务器错误' });
  }
});

// 获取用户列表（支持分页、角色筛选和搜索）
router.get('/admin/list', authenticateToken, async (req, res) => {
  try {
    // 先获取用户的完整信息
    const [userInfo] = await pool.query(
      'SELECT id, username, role FROM users WHERE id = ?',
      [req.user.id]
    );

    console.log('用户完整信息:', userInfo);

    // 验证用户是否为管理员
    if (!userInfo || userInfo.length === 0) {
      console.log('未找到用户信息');
      return res.status(403).json({
        code: 403,
        message: '用户信息不存在'
      });
    }

    const userRole = userInfo[0].role;
    console.log('用户角色:', userRole);

    if (userRole !== 'admin') {
      console.log('用户角色不是管理员:', userRole);
      return res.status(403).json({
        code: 403,
        message: '权限不足，只有管理员可以访问此接口'
      });
    }

    console.log('管理员验证通过');
    console.log('获取用户列表请求参数:', req.query);

    const { 
      page = 1, 
      pageSize = 15, 
      role = 'all',
      search = '' 
    } = req.query;

    const offset = (page - 1) * pageSize;
    
    // 构建基础查询
    let query = `
      SELECT 
        u.id,
        u.username,
        COALESCE(up.display_name, u.username) as displayName,
        u.email,
        u.role,
        up.avatar_url as avatar,
        u.created_at as createdAt,
        u.status
      FROM users u
      LEFT JOIN user_profile up ON u.id = up.user_id
      WHERE 1=1
    `;
    
    const queryParams = [];
    
    // 添加角色筛选
    if (role !== 'all') {
      query += ' AND u.role = ?';
      queryParams.push(role);
    }
    
    // 添加搜索条件
    if (search) {
      query += ' AND (u.username LIKE ? OR up.display_name LIKE ?)';
      queryParams.push(`%${search}%`, `%${search}%`);
    }
    
    // 获取总数的查询
    const countQuery = query.replace('SELECT \n        u.id,\n        u.username,\n        COALESCE(up.display_name, u.username) as displayName,\n        u.email,\n        u.role,\n        up.avatar_url as avatar,\n        u.created_at as createdAt,\n        u.status', 'SELECT COUNT(*) as total');
    
    console.log('统计查询SQL:', countQuery);
    console.log('统计查询参数:', queryParams);
    
    const [countResult] = await pool.query(countQuery, queryParams);
    const total = countResult[0].total;
    
    // 添加分页
    query += ' ORDER BY u.created_at DESC LIMIT ? OFFSET ?';
    queryParams.push(parseInt(pageSize), offset);
    
    console.log('列表查询SQL:', query);
    console.log('列表查询参数:', queryParams);
    
    const [users] = await pool.query(query, queryParams);
    
    console.log('查询结果:', users);
    
    res.json({
      code: 200,
      data: {
        list: users,
        total,
        page: parseInt(page),
        pageSize: parseInt(pageSize)
      }
    });
  } catch (error) {
    console.error('获取用户列表错误:', error);
    res.status(500).json({
      code: 500,
      message: '获取用户列表失败',
      error: error.message
    });
  }
});

// 获取各角色用户数量统计
router.get('/admin/role-stats', authenticateToken, async (req, res) => {
  try {
    // 先获取用户的完整信息
    const [userInfo] = await pool.query(
      'SELECT id, username, role FROM users WHERE id = ?',
      [req.user.id]
    );

    console.log('用户完整信息:', userInfo);

    // 验证用户是否为管理员
    if (!userInfo || userInfo.length === 0) {
      console.log('未找到用户信息');
      return res.status(403).json({
        code: 403,
        message: '用户信息不存在'
      });
    }

    const userRole = userInfo[0].role;
    console.log('用户角色:', userRole);

    if (userRole !== 'admin') {
      console.log('用户角色不是管理员:', userRole);
      return res.status(403).json({
        code: 403,
        message: '权限不足，只有管理员可以访问此接口'
      });
    }

    console.log('管理员验证通过');
    console.log('获取角色统计开始');
    
    const query = `
      SELECT 
        role,
        COUNT(*) as count
      FROM users
      GROUP BY role
    `;
    
    console.log('统计查询SQL:', query);
    
    const [results] = await pool.query(query);
    
    console.log('统计结果:', results);
    
    // 初始化所有角色的计数
    const roleStats = {
      normal: 0,
      vip: 0,
      super_vip: 0,
      teacher: 0,
      admin: 0
    };
    
    // 更新实际的计数
    results.forEach(({ role, count }) => {
      if (roleStats.hasOwnProperty(role)) {
        roleStats[role] = count;
      }
    });
    
    // 计算总用户数
    const totalUsers = results.reduce((sum, { count }) => sum + count, 0);
    
    console.log('最终统计结果:', { total: totalUsers, stats: roleStats });
    
    res.json({
      code: 200,
      data: {
        total: totalUsers,
        stats: roleStats
      }
    });
  } catch (error) {
    console.error('获取角色统计错误:', error);
    res.status(500).json({
      code: 500,
      message: '获取角色统计失败',
      error: error.message
    });
  }
});

// 更新用户信息
router.put('/admin/update/:id', authenticateToken, async (req, res) => {
  try {
    // 验证当前用户是否有权限
    const currentUser = req.user;
    console.log('当前用户信息:', currentUser);
    
    // 获取完整的用户信息
    const [userInfo] = await pool.query(
      'SELECT role FROM users WHERE id = ?',
      [currentUser.id]
    );

    if (!userInfo || userInfo.length === 0) {
      return res.status(403).json({
        success: false,
        message: '用户信息不存在'
      });
    }

    const currentUserRole = userInfo[0].role;
    console.log('当前用户角色:', currentUserRole);

    // 检查权限
    if (!['admin', 'teacher'].includes(currentUserRole)) {
      return res.status(403).json({
        success: false,
        message: '权限不足'
      });
    }

    const userId = req.params.id;
    const { displayName, email, role, status } = req.body;
    console.log('更新用户信息:', { userId, displayName, email, role, status });

    // 如果是修改角色，只有管理员可以操作
    if (role && currentUserRole !== 'admin') {
      return res.status(403).json({
        success: false,
        message: '只有管理员可以修改用户角色'
      });
    }

    // 开始事务
    const connection = await pool.getConnection();
    await connection.beginTransaction();

    try {
      // 更新用户基本信息
      await connection.query(
        `UPDATE users 
         SET email = ?, 
             status = ?
             ${role ? ', role = ?' : ''}
         WHERE id = ?`,
        role 
          ? [email, status, role, userId]
          : [email, status, userId]
      );

      // 更新用户资料
      await connection.query(
        `INSERT INTO user_profile (user_id, display_name, nickname) 
         VALUES (?, ?, ?)
         ON DUPLICATE KEY UPDATE 
         display_name = ?`,
        [userId, displayName, displayName, displayName]
      );

      // 提交事务
      await connection.commit();

      // 添加调试日志
      console.log('用户信息更新成功');

      res.json({
        success: true,
        message: '用户信息更新成功'
      });
    } catch (error) {
      // 回滚事务
      await connection.rollback();
      throw error;
    } finally {
      // 释放连接
      connection.release();
    }
  } catch (error) {
    console.error('更新用户信息失败:', error);
    res.status(500).json({
      success: false,
      message: '更新用户信息失败',
      error: error.message
    });
  }
});

// 获取教师列表
router.get('/teachers', authenticateToken, async (req, res) => {
  try {
    const connection = await pool.getConnection();
    
    const [teachers] = await connection.execute(`
      SELECT id, username, email, role, avatar, created_at
      FROM users
      WHERE role IN ('admin', 'teacher')
      ORDER BY id ASC
    `);
    
    connection.release();
    
    res.json({
      success: true,
      data: teachers
    });
  } catch (error) {
    console.error('获取教师列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取教师列表失败',
      error: error.message
    });
  }
});

// 获取学生信息
router.get('/student-info/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    console.log(`获取学生信息，用户ID: ${userId}`);
    
    const [rows] = await pool.query(`
      SELECT * FROM student_info
      WHERE user_id = ?
    `, [userId]);
    
    if (rows.length === 0) {
      return res.json({
        code: 404,
        message: '未找到学生信息'
      });
    }
    
    res.json({
      code: 200,
      data: rows[0],
      message: '获取学生信息成功'
    });
  } catch (error) {
    console.error('获取学生信息失败:', error);
    res.status(500).json({
      code: 500,
      message: '获取学生信息失败'
    });
  }
});

// 获取多个用户的个人资料（按用户ID列表）
router.post('/profiles', async (req, res) => {
  try {
    const { userIds } = req.body;
    
    if (!userIds || !Array.isArray(userIds) || userIds.length === 0) {
      return res.status(400).json({
        success: false,
        message: '请提供有效的用户ID列表'
      });
    }
    
    console.log('请求获取用户资料，ID列表:', userIds);
    
    // 使用 IN 查询获取多个用户的资料
    const placeholders = userIds.map(() => '?').join(',');
    const query = `
      SELECT up.user_id, u.username, up.display_name, up.avatar_url, up.bio, up.nickname
      FROM user_profile up
      JOIN users u ON up.user_id = u.id
      WHERE up.user_id IN (${placeholders})
    `;
    
    const [rows] = await pool.query(query, userIds);
    console.log('获取到的用户资料:', rows);
    
    res.json({
      success: true,
      data: rows
    });
  } catch (error) {
    console.error('获取用户资料失败:', error);
    res.status(500).json({
      success: false,
      message: '获取用户资料失败: ' + error.message
    });
  }
});

// 删除用户
router.delete('/admin/delete/:id', authenticateToken, async (req, res) => {
  try {
    // 验证当前用户是否为管理员
    const currentUser = req.user;
    const [userInfo] = await pool.query(
      'SELECT role FROM users WHERE id = ?',
      [currentUser.id]
    );

    if (!userInfo || userInfo.length === 0) {
      return res.status(403).json({
        success: false,
        message: '用户信息不存在'
      });
    }

    const currentUserRole = userInfo[0].role;
    
    // 只有管理员可以删除用户
    if (currentUserRole !== 'admin') {
      return res.status(403).json({
        success: false,
        message: '权限不足，只有管理员可以删除用户'
      });
    }

    const userId = req.params.id;
    console.log('删除用户，用户ID:', userId);

    // 检查要删除的用户是否存在
    const [userToDelete] = await pool.query(
      'SELECT role FROM users WHERE id = ?',
      [userId]
    );

    if (!userToDelete || userToDelete.length === 0) {
      return res.status(404).json({
        success: false,
        message: '要删除的用户不存在'
      });
    }

    // 不允许删除管理员用户
    if (userToDelete[0].role === 'admin') {
      return res.status(403).json({
        success: false,
        message: '不能删除管理员用户'
      });
    }

    // 开始事务
    const connection = await pool.getConnection();
    await connection.beginTransaction();

    try {
      // 查询communities表中是否有引用此用户的记录
      const [communityRecords] = await connection.query(
        'SELECT id FROM communities WHERE created_by = ?',
        [userId]
      );
      
      // 如果有社区记录，将其创建者更新为系统管理员(ID为1的用户)
      if (communityRecords && communityRecords.length > 0) {
        await connection.query(
          'UPDATE communities SET created_by = 1 WHERE created_by = ?',
          [userId]
        );
        
        console.log(`用户ID ${userId} 删除前，已将其创建的 ${communityRecords.length} 个社区转移给管理员`);
      }
      
      // 处理其他外键约束
      console.log(`开始处理用户ID ${userId} 的所有关联数据`);
      
      // 删除或更新classroom_discussions中的记录
      await connection.query('DELETE FROM classroom_discussions WHERE user_id = ?', [userId]);
      
      // 更新classrooms表中的teacher_id
      const [classrooms] = await connection.query('SELECT id FROM classrooms WHERE teacher_id = ?', [userId]);
      if (classrooms && classrooms.length > 0) {
        await connection.query('UPDATE classrooms SET teacher_id = 1 WHERE teacher_id = ?', [userId]);
        console.log(`已将 ${classrooms.length} 个教室的教师转移给管理员`);
      }
      
      // 处理community_members表中的记录
      await connection.query('DELETE FROM community_members WHERE user_id = ?', [userId]);
      await connection.query('UPDATE community_members SET invited_by = 1 WHERE invited_by = ?', [userId]);
      
      // 删除learning_plans
      await connection.query('DELETE FROM learning_plans WHERE user_id = ?', [userId]);
      
      // 删除likes
      await connection.query('DELETE FROM likes WHERE user_id = ?', [userId]);
      
      // 处理posts表
      await connection.query('DELETE FROM posts WHERE user_id = ?', [userId]);
      
      // 更新problem_pool表中的创建者
      await connection.query('UPDATE problem_pool SET create_user_id = 1 WHERE create_user_id = ?', [userId]);
      
      // 删除problem_pool_usage
      await connection.query('DELETE FROM problem_pool_usage WHERE user_id = ?', [userId]);
      
      // 删除submissions
      await connection.query('DELETE FROM submissions WHERE user_id = ?', [userId]);
      
      // 删除user_visits
      await connection.query('DELETE FROM user_visits WHERE user_id = ?', [userId]);

      // 删除用户资料
      await connection.query('DELETE FROM user_profile WHERE user_id = ?', [userId]);
      
      // 如果有学生信息，删除学生信息
      await connection.query('DELETE FROM student_info WHERE user_id = ?', [userId]);
      
      // 最后删除用户
      await connection.query('DELETE FROM users WHERE id = ?', [userId]);

      // 提交事务
      await connection.commit();
      
      console.log('用户删除成功');
      res.json({
        success: true,
        message: '用户删除成功'
      });
    } catch (error) {
      // 回滚事务
      await connection.rollback();
      throw error;
    } finally {
      // 释放连接
      connection.release();
    }
  } catch (error) {
    console.error('删除用户失败:', error);
    res.status(500).json({
      success: false,
      message: '删除用户失败',
      error: error.message
    });
  }
});

module.exports = router;