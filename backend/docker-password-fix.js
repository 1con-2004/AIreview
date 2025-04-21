const bcrypt = require('bcrypt');
const mysql = require('mysql2/promise');

// 创建连接池
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'db', // 使用Docker环境中的数据库主机名
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'root',
  database: process.env.DB_NAME || 'AIreview',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

async function fixAdminPassword() {
  console.log('开始修复admin用户密码...');
  
  try {
    // 1. 检查MySQL连接
    console.log('测试数据库连接...');
    const [rows] = await pool.query('SELECT 1 + 1 AS result');
    console.log(`数据库连接测试: ${rows[0].result}`);
    
    // 2. 检查users表是否存在
    console.log('检查users表结构...');
    const [tables] = await pool.query('SHOW TABLES LIKE "users"');
    if (tables.length === 0) {
      console.error('错误: users表不存在！');
      return;
    }
    
    // 3. 检查users表字段
    const [columns] = await pool.query('SHOW COLUMNS FROM users');
    const columnNames = columns.map(col => col.Field);
    console.log('users表字段:', columnNames.join(', '));
    
    // 4. 检查是否存在admin用户
    console.log('检查admin用户是否存在...');
    const [adminRows] = await pool.query('SELECT * FROM users WHERE username = ?', ['admin']);
    
    if (adminRows.length === 0) {
      console.log('Admin用户不存在，创建新的admin用户...');
      
      // 创建admin用户
      const password = 'admin123';
      const hashedPassword = await bcrypt.hash(password, 10);
      
      await pool.query(
        'INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, ?)',
        ['admin', hashedPassword, 'admin@example.com', 'admin']
      );
      
      console.log('成功创建admin用户，密码: admin123');
    } else {
      console.log('找到admin用户，正在更新密码...');
      
      // 更新admin密码
      const password = 'admin123';
      const hashedPassword = await bcrypt.hash(password, 10);
      
      await pool.query(
        'UPDATE users SET password = ? WHERE username = ?',
        [hashedPassword, 'admin']
      );
      
      // 测试密码验证
      const newPassword = 'admin123';
      const [updatedRows] = await pool.query('SELECT password FROM users WHERE username = ?', ['admin']);
      const storedHash = updatedRows[0].password;
      
      const testMatch = await bcrypt.compare(newPassword, storedHash);
      console.log(`密码更新后验证测试: ${testMatch ? '成功' : '失败'}`);
      
      console.log('成功更新admin用户密码为: admin123');
    }
    
    // 5. 检查refresh_token字段
    if (!columnNames.includes('refresh_token')) {
      console.log('添加缺失的refresh_token字段...');
      await pool.query('ALTER TABLE users ADD COLUMN refresh_token TEXT');
      console.log('成功添加refresh_token字段');
    }
    
    console.log('密码修复完成！');
  } catch (error) {
    console.error('执行过程中出错:', error);
  } finally {
    // 关闭连接池
    await pool.end();
  }
}

// 执行修复
fixAdminPassword(); 