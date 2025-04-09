const pool = require('../../db');
const path = require('path');
const fs = require('fs');

// 生成随机课堂码
const generateClassroomCode = () => {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // 去掉容易混淆的字符
  let code = '';
  for (let i = 0; i < 5; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return code;
};

// 获取所有课堂
const getAllClassrooms = async (req, res) => {
  try {
    console.log('获取所有课堂列表');
    const [rows] = await pool.query(`
      SELECT c.*, u.username as teacher_name 
      FROM classrooms c
      JOIN users u ON c.teacher_id = u.id
      ORDER BY c.created_at DESC
    `);
    
    res.json({
      code: 200,
      data: rows,
      message: '获取课堂列表成功'
    });
  } catch (error) {
    console.error('获取课堂列表失败:', error);
    res.status(500).json({
      code: 500,
      message: '获取课堂列表失败'
    });
  }
};

// 根据课堂码获取课堂信息
const getClassroomByCode = async (req, res) => {
  try {
    const { code } = req.params;
    console.log(`获取课堂信息，课堂码: ${code}`);
    
    const [rows] = await pool.query(`
      SELECT c.*, u.username as teacher_name 
      FROM classrooms c
      JOIN users u ON c.teacher_id = u.id
      WHERE c.classroom_code = ?
    `, [code]);
    
    if (rows.length === 0) {
      return res.status(404).json({
        code: 404,
        message: '课堂不存在'
      });
    }
    
    res.json({
      code: 200,
      data: rows[0],
      message: '获取课堂信息成功'
    });
  } catch (error) {
    console.error('获取课堂信息失败:', error);
    res.status(500).json({
      code: 500,
      message: '获取课堂信息失败'
    });
  }
};

// 创建新课堂
const createClassroom = async (req, res) => {
  try {
    const { title, description, teacher_id } = req.body;
    console.log(`创建新课堂: ${title}, 教师ID: ${teacher_id}`);
    
    if (!title || !teacher_id) {
      return res.status(400).json({
        code: 400,
        message: '课堂标题和教师ID不能为空'
      });
    }
    
    // 生成唯一课堂码
    let classroomCode;
    let isUnique = false;
    
    while (!isUnique) {
      classroomCode = generateClassroomCode();
      const [existingCodes] = await pool.query('SELECT id FROM classrooms WHERE classroom_code = ?', [classroomCode]);
      if (existingCodes.length === 0) {
        isUnique = true;
      }
    }
    
    const [result] = await pool.query(`
      INSERT INTO classrooms (classroom_code, teacher_id, title, description)
      VALUES (?, ?, ?, ?)
    `, [classroomCode, teacher_id, title, description || '']);
    
    res.status(201).json({
      code: 201,
      data: {
        id: result.insertId,
        classroom_code: classroomCode
      },
      message: '创建课堂成功'
    });
  } catch (error) {
    console.error('创建课堂失败:', error);
    res.status(500).json({
      code: 500,
      message: '创建课堂失败'
    });
  }
};

// 更新课堂信息
const updateClassroom = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, status } = req.body;
    console.log(`更新课堂信息，ID: ${id}`);
    
    if (!title) {
      return res.status(400).json({
        code: 400,
        message: '课堂标题不能为空'
      });
    }
    
    await pool.query(`
      UPDATE classrooms
      SET title = ?, description = ?, status = ?, updated_at = NOW()
      WHERE id = ?
    `, [title, description || '', status, id]);
    
    res.json({
      code: 200,
      message: '更新课堂信息成功'
    });
  } catch (error) {
    console.error('更新课堂信息失败:', error);
    res.status(500).json({
      code: 500,
      message: '更新课堂信息失败'
    });
  }
};

// 删除课堂
const deleteClassroom = async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`删除课堂，ID: ${id}`);
    
    // 删除课堂相关文件
    const [files] = await pool.query('SELECT file_path FROM classroom_files WHERE classroom_id = ?', [id]);
    
    for (const file of files) {
      const filePath = path.join(__dirname, '../../../uploads/classroom', path.basename(file.file_path));
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    }
    
    // 删除课堂记录（级联删除会自动删除相关的留言、文件和讨论记录）
    await pool.query('DELETE FROM classrooms WHERE id = ?', [id]);
    
    res.json({
      code: 200,
      message: '删除课堂成功'
    });
  } catch (error) {
    console.error('删除课堂失败:', error);
    res.status(500).json({
      code: 500,
      message: '删除课堂失败'
    });
  }
};

// 添加课堂留言
const addClassroomMessage = async (req, res) => {
  try {
    const { id } = req.params;
    const { content } = req.body;
    console.log(`添加课堂留言，课堂ID: ${id}`);
    
    if (!content) {
      return res.status(400).json({
        code: 400,
        message: '留言内容不能为空'
      });
    }
    
    const [result] = await pool.query(`
      INSERT INTO classroom_messages (classroom_id, content)
      VALUES (?, ?)
    `, [id, content]);
    
    res.status(201).json({
      code: 201,
      data: {
        id: result.insertId
      },
      message: '添加留言成功'
    });
  } catch (error) {
    console.error('添加留言失败:', error);
    res.status(500).json({
      code: 500,
      message: '添加留言失败'
    });
  }
};

// 获取课堂留言
const getClassroomMessages = async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`获取课堂留言，课堂ID: ${id}`);
    
    const [rows] = await pool.query(`
      SELECT * FROM classroom_messages
      WHERE classroom_id = ?
      ORDER BY created_at DESC
    `, [id]);
    
    res.json({
      code: 200,
      data: rows,
      message: '获取留言成功'
    });
  } catch (error) {
    console.error('获取留言失败:', error);
    res.status(500).json({
      code: 500,
      message: '获取留言失败'
    });
  }
};

// 删除课堂留言
const deleteClassroomMessage = async (req, res) => {
  try {
    const { messageId } = req.params;
    console.log(`删除课堂留言，留言ID: ${messageId}`);
    
    // 查询留言是否存在
    const [messages] = await pool.query('SELECT * FROM classroom_messages WHERE id = ?', [messageId]);
    
    if (messages.length === 0) {
      return res.status(404).json({
        code: 404,
        message: '留言不存在'
      });
    }
    
    // 删除留言
    await pool.query('DELETE FROM classroom_messages WHERE id = ?', [messageId]);
    
    res.json({
      code: 200,
      message: '删除留言成功'
    });
  } catch (error) {
    console.error('删除留言失败:', error);
    res.status(500).json({
      code: 500,
      message: '删除留言失败'
    });
  }
};

// 上传课堂文件
const uploadClassroomFile = async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`上传课堂文件，课堂ID: ${id}`);
    
    if (!req.file) {
      return res.status(400).json({
        code: 400,
        message: '未上传文件'
      });
    }
    
    const { filename, originalname, mimetype, size, path: filePath } = req.file;
    console.log('上传文件信息:', { filename, originalname, mimetype, size });
    
    // 获取文件类型
    const fileExt = path.extname(originalname).toLowerCase().substring(1);
    
    // 获取正确的原始文件名（从请求对象中获取，如果存在）
    let correctOriginalName = originalname;
    if (req.fileOriginalNames && req.fileOriginalNames[filename]) {
      correctOriginalName = req.fileOriginalNames[filename];
      console.log('使用修正后的文件名:', correctOriginalName);
    }
    
    // 直接存储原始文件名
    const [result] = await pool.query(`
      INSERT INTO classroom_files (classroom_id, file_name, file_path, file_size, file_type)
      VALUES (?, ?, ?, ?, ?)
    `, [id, correctOriginalName, filename, size, fileExt]);
    
    res.status(201).json({
      code: 201,
      data: {
        id: result.insertId,
        file_name: correctOriginalName,
        file_size: size,
        file_type: fileExt
      },
      message: '上传文件成功'
    });
  } catch (error) {
    console.error('上传文件失败:', error);
    res.status(500).json({
      code: 500,
      message: '上传文件失败'
    });
  }
};

// 获取课堂文件列表
const getClassroomFiles = async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`获取课堂文件列表，课堂ID: ${id}`);
    
    const [rows] = await pool.query(`
      SELECT * FROM classroom_files
      WHERE classroom_id = ?
      ORDER BY upload_time DESC
    `, [id]);
    
    // 不再需要解码文件名
    res.json({
      code: 200,
      data: rows,
      message: '获取文件列表成功'
    });
  } catch (error) {
    console.error('获取文件列表失败:', error);
    res.status(500).json({
      code: 500,
      message: '获取文件列表失败'
    });
  }
};

// 下载课堂文件
const downloadClassroomFile = async (req, res) => {
  try {
    const { fileId } = req.params;
    console.log(`下载课堂文件，文件ID: ${fileId}`);
    
    const [files] = await pool.query('SELECT * FROM classroom_files WHERE id = ?', [fileId]);
    
    if (files.length === 0) {
      return res.status(404).json({
        code: 404,
        message: '文件不存在'
      });
    }
    
    const file = files[0];
    const filePath = path.join(__dirname, '../../../uploads/classroom', file.file_path);
    
    if (!fs.existsSync(filePath)) {
      console.error(`文件路径不存在: ${filePath}`);
      return res.status(404).json({
        code: 404,
        message: '文件不存在'
      });
    }
    
    // 直接使用数据库中存储的文件名
    const fileName = file.file_name;
    console.log(`下载文件: ${fileName}, 路径: ${filePath}`);
    
    // 设置正确的Content-Type
    const fileExt = path.extname(fileName).toLowerCase();
    const mimeType = getMimeType(fileExt);
    res.setHeader('Content-Type', mimeType);
    
    // 设置Content-Disposition头，确保中文文件名正确编码
    const encodedFileName = encodeURIComponent(fileName).replace(/['()]/g, escape);
    res.setHeader('Content-Disposition', `attachment; filename="${encodedFileName}"; filename*=UTF-8''${encodedFileName}`);
    
    // 使用流式传输文件
    const fileStream = fs.createReadStream(filePath);
    fileStream.pipe(res);
    
    // 处理错误
    fileStream.on('error', (error) => {
      console.error('文件流错误:', error);
      if (!res.headersSent) {
        res.status(500).json({
          code: 500,
          message: '下载文件失败'
        });
      }
    });
  } catch (error) {
    console.error('下载文件失败:', error);
    res.status(500).json({
      code: 500,
      message: '下载文件失败'
    });
  }
};

// 获取MIME类型
const getMimeType = (ext) => {
  const mimeTypes = {
    '.pdf': 'application/pdf',
    '.doc': 'application/msword',
    '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    '.xls': 'application/vnd.ms-excel',
    '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    '.ppt': 'application/vnd.ms-powerpoint',
    '.pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    '.txt': 'text/plain',
    '.zip': 'application/zip',
    '.rar': 'application/x-rar-compressed',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png',
    '.gif': 'image/gif',
    '.js': 'application/javascript',
    '.html': 'text/html',
    '.css': 'text/css',
    '.java': 'text/x-java',
    '.cpp': 'text/x-c++src',
    '.c': 'text/x-csrc',
    '.py': 'text/x-python',
    '.h': 'text/x-c',
    '.cs': 'text/plain',
    '.php': 'text/plain',
    '.go': 'text/plain',
    '.swift': 'text/plain',
    '.ts': 'text/plain',
    '.jsx': 'text/plain',
    '.vue': 'text/plain',
    '.json': 'application/json',
    '.xml': 'application/xml',
    '.sql': 'text/plain'
  };
  
  return mimeTypes[ext] || 'application/octet-stream';
};

// 删除课堂文件
const deleteClassroomFile = async (req, res) => {
  try {
    const { fileId } = req.params;
    console.log(`删除课堂文件，文件ID: ${fileId}`);
    
    // 查询文件信息
    const [files] = await pool.query('SELECT * FROM classroom_files WHERE id = ?', [fileId]);
    
    if (files.length === 0) {
      return res.status(404).json({
        code: 404,
        message: '文件不存在'
      });
    }
    
    const file = files[0];
    const filePath = path.join(__dirname, '../../../uploads/classroom', file.file_path);
    
    // 删除数据库记录
    await pool.query('DELETE FROM classroom_files WHERE id = ?', [fileId]);
    
    // 尝试删除物理文件
    try {
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        console.log(`成功删除文件: ${filePath}`);
      } else {
        console.log(`文件不存在，仅删除数据库记录: ${filePath}`);
      }
    } catch (fileError) {
      console.error('删除物理文件失败:', fileError);
      // 即使物理文件删除失败，也返回成功，因为数据库记录已删除
    }
    
    res.json({
      code: 200,
      message: '文件删除成功'
    });
  } catch (error) {
    console.error('删除文件失败:', error);
    res.status(500).json({
      code: 500,
      message: '删除文件失败'
    });
  }
};

// 添加讨论消息
const addDiscussionMessage = async (req, res) => {
  try {
    const { id } = req.params;
    const { user_id, content } = req.body;
    console.log(`添加讨论消息，课堂ID: ${id}, 用户ID: ${user_id}`);
    
    if (!content || !user_id) {
      return res.status(400).json({
        code: 400,
        message: '消息内容和用户ID不能为空'
      });
    }
    
    const [result] = await pool.query(`
      INSERT INTO classroom_discussions (classroom_id, user_id, content)
      VALUES (?, ?, ?)
    `, [id, user_id, content]);
    
    // 获取用户信息
    const [users] = await pool.query(`
      SELECT u.id, u.username, u.avatar, u.role, 
             CASE WHEN s.real_name IS NOT NULL THEN s.real_name ELSE u.username END as display_name
      FROM users u
      LEFT JOIN student_info s ON u.id = s.user_id
      WHERE u.id = ?
    `, [user_id]);
    
    const user = users[0];
    
    res.status(201).json({
      code: 201,
      data: {
        id: result.insertId,
        user: {
          id: user.id,
          username: user.username,
          display_name: user.display_name,
          avatar: user.avatar,
          role: user.role
        },
        content,
        created_at: new Date()
      },
      message: '发送消息成功'
    });
  } catch (error) {
    console.error('发送消息失败:', error);
    res.status(500).json({
      code: 500,
      message: '发送消息失败'
    });
  }
};

// 获取讨论消息
const getDiscussionMessages = async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`获取讨论消息，课堂ID: ${id}`);
    
    // 调试信息
    console.log('开始查询讨论消息');
    
    const [rows] = await pool.query(`
      SELECT d.id, d.user_id, d.content, d.created_at,
             u.username, u.role,
             CASE WHEN s.real_name IS NOT NULL THEN s.real_name ELSE u.username END as display_name
      FROM classroom_discussions d
      JOIN users u ON d.user_id = u.id
      LEFT JOIN student_info s ON u.id = s.user_id
      WHERE d.classroom_id = ?
      ORDER BY d.created_at ASC
    `, [id]);
    
    console.log(`查询到 ${rows.length} 条讨论消息`);
    
    const messages = rows.map(row => ({
      id: row.id,
      user: {
        id: row.user_id,
        username: row.username,
        display_name: row.display_name,
        role: row.role
      },
      content: row.content,
      created_at: row.created_at
    }));
    
    console.log('讨论消息处理完成，准备返回');
    
    res.status(200).json({
      code: 200,
      data: messages,
      message: '获取讨论消息成功'
    });
  } catch (error) {
    console.error('获取讨论消息失败:', error);
    res.status(500).json({
      code: 500,
      message: '获取讨论消息失败'
    });
  }
};

// 验证课堂码
const verifyClassroomCode = async (req, res) => {
  try {
    const { code } = req.body;
    console.log(`验证课堂码: ${code}`);
    
    if (!code) {
      return res.status(400).json({
        code: 400,
        message: '课堂码不能为空'
      });
    }
    
    const [rows] = await pool.query(`
      SELECT c.*, u.username as teacher_name 
      FROM classrooms c
      JOIN users u ON c.teacher_id = u.id
      WHERE c.classroom_code = ? AND c.status = 1
    `, [code]);
    
    if (rows.length === 0) {
      return res.status(404).json({
        code: 404,
        message: '课堂不存在或已关闭'
      });
    }
    
    res.json({
      code: 200,
      data: rows[0],
      message: '课堂验证成功'
    });
  } catch (error) {
    console.error('验证课堂码失败:', error);
    res.status(500).json({
      code: 500,
      message: '验证课堂码失败'
    });
  }
};

module.exports = {
  getAllClassrooms,
  getClassroomByCode,
  createClassroom,
  updateClassroom,
  deleteClassroom,
  addClassroomMessage,
  getClassroomMessages,
  deleteClassroomMessage,
  uploadClassroomFile,
  getClassroomFiles,
  downloadClassroomFile,
  deleteClassroomFile,
  addDiscussionMessage,
  getDiscussionMessages,
  verifyClassroomCode
}; 