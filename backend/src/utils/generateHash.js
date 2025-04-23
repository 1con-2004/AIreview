const bcrypt = require('bcrypt');

/**
 * 生成密码哈希值，用于数据库初始化
 */
async function generatePasswordHash() {
  try {
    const password = 'admin123';
    const hash = await bcrypt.hash(password, 10);
    console.log('密码:', password);
    console.log('bcrypt 哈希值:', hash);
    console.log('这个哈希值可以直接用于数据库初始化脚本中');
  } catch (error) {
    console.error('生成密码哈希时出错:', error);
  }
}

generatePasswordHash();

// 运行此脚本: node src/utils/generateHash.js 