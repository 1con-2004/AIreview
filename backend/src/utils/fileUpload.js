const multer = require('multer');
const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
require('dotenv').config();

// 使用环境变量中的上传目录，如果没有则使用默认值
const uploadDir = path.join(__dirname, '..', '..', process.env.UPLOAD_DIR || 'uploads', 'classroom');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// 配置存储
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    // 生成唯一文件名
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    
    // 处理文件扩展名
    let originalname = file.originalname;
    
    // 检测并修复乱码文件名
    try {
      // 如果文件名已经是乱码，尝试使用Buffer转换
      if (/æ|ø|å|ð|ñ|ò|ó|ô|õ|ö/.test(originalname)) {
        console.log('检测到可能的乱码文件名，尝试修复');
        // 尝试不同的编码方式
        const encodings = ['utf8', 'latin1', 'ascii', 'utf16le'];
        for (const encoding of encodings) {
          try {
            const decoded = Buffer.from(originalname, encoding).toString('utf8');
            if (decoded && decoded !== originalname && !/æ|ø|å|ð|ñ|ò|ó|ô|õ|ö/.test(decoded)) {
              originalname = decoded;
              console.log(`成功修复文件名，使用编码: ${encoding}`);
              break;
            }
          } catch (e) {
            console.error(`尝试使用 ${encoding} 解码失败:`, e.message);
          }
        }
      }
    } catch (error) {
      console.error('修复文件名失败:', error);
    }
    
    // 获取文件扩展名
    const ext = path.extname(originalname);
    
    // 使用MD5哈希作为文件名，避免中文文件名问题
    const hash = crypto.createHash('md5').update(uniqueSuffix.toString()).digest('hex');
    const filename = hash + ext;
    
    console.log('保存文件:', {
      originalName: originalname,
      storedAs: filename
    });
    
    // 在请求对象中保存原始文件名，以便后续使用
    if (!req.fileOriginalNames) {
      req.fileOriginalNames = {};
    }
    req.fileOriginalNames[filename] = originalname;
    
    cb(null, filename);
  }
});

// 文件过滤器
const fileFilter = (req, file, cb) => {
  // 允许的文件类型
  const allowedTypes = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'text/plain',
    'application/zip',
    'application/x-rar-compressed',
    'image/jpeg',
    'image/png',
    'image/gif',
    'application/x-javascript',
    'text/javascript',
    'text/html',
    'text/css',
    // 添加编程文件类型
    'text/x-java',
    'text/x-c++src',
    'text/x-csrc',
    'text/x-python',
    'text/x-c',
    'text/x-java-source',
    'application/octet-stream' // 用于处理未知的二进制文件类型
  ];

  // 允许的文件扩展名
  const allowedExtensions = [
    '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
    '.txt', '.zip', '.rar', '.jpg', '.jpeg', '.png', '.gif',
    '.js', '.html', '.css',
    // 添加编程文件扩展名
    '.java', '.cpp', '.c', '.py', '.h', '.cs', '.php', '.go', '.swift',
    '.ts', '.jsx', '.vue', '.json', '.xml', '.sql'
  ];

  // 获取文件扩展名
  const ext = path.extname(file.originalname).toLowerCase();
  
  // 检查MIME类型或扩展名是否允许
  if (allowedTypes.includes(file.mimetype) || allowedExtensions.includes(ext)) {
    cb(null, true);
  } else {
    console.log(`拒绝文件: ${file.originalname}, MIME类型: ${file.mimetype}, 扩展名: ${ext}`);
    cb(new Error('不支持的文件类型'), false);
  }
};

// 配置上传
const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 10 * 1024 * 1024 // 限制文件大小为10MB
  }
});

module.exports = { upload }; 