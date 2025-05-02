const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

// 优先加载.env.local文件的配置（如果存在）
const localEnvPath = path.resolve(__dirname, '../.env.local');
if (fs.existsSync(localEnvPath)) {
    console.log('检测到本地环境配置文件.env.local，优先使用本地配置');
    dotenv.config({ path: localEnvPath });
} else {
    // 如果.env.local不存在，则加载默认的.env文件
    dotenv.config();
    console.log('使用默认环境配置文件.env');
}

// 创建数据库连接池
const pool = mysql.createPool({
    host: process.env.DB_HOST || 'db', // 数据库主机
    user: process.env.DB_USER || 'root', // 数据库用户名
    password: process.env.DB_PASSWORD || 'root', // 数据库密码
    database: process.env.DB_NAME || 'AIreview', // 数据库名称
    port: process.env.DB_PORT || 3306, // 数据库端口
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    enableKeepAlive: true,
    keepAliveInitialDelay: 0,
    charset: 'utf8mb4', // 使用utf8mb4字符集支持完整的中文和表情符号
    collation: 'utf8mb4_unicode_ci', // 使用Unicode排序规则
    multipleStatements: true, // 允许多条语句查询
    timezone: '+08:00' // 设置时区为北京时间
});

// 测试连接
pool.getConnection()
    .then(async connection => {
        console.log('数据库连接成功');
        console.log(`当前连接到的数据库主机: ${process.env.DB_HOST}`);
        
        // 设置session字符集和时区
        await connection.query("SET NAMES utf8mb4");
        await connection.query("SET CHARACTER SET utf8mb4");
        await connection.query("SET character_set_connection=utf8mb4");
        await connection.query("SET character_set_results=utf8mb4");
        await connection.query("SET time_zone='+8:00'");
        console.log('会话字符集已设置为utf8mb4，时区已设置为北京时间');
        
        connection.release();
    })
    .catch(err => {
        console.error('数据库连接失败:', err);
        console.error(`尝试连接的数据库主机: ${process.env.DB_HOST}`);
        // 不要退出进程，因为我们可能需要继续运行其他服务
        // process.exit(1);
    });

module.exports = pool; 