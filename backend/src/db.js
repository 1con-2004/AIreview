const mysql = require('mysql2/promise');

// 创建数据库连接池
const pool = mysql.createPool({
    host: 'localhost', // 数据库主机
    user: 'root', // 数据库用户名
    password: 'root', // 数据库密码
    database: 'AIreview', // 数据库名称
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

module.exports = pool; 