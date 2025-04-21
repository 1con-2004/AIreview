/**
 * 中文编码修复脚本
 * 用于Docker环境下修复MySQL的字符集设置及已有数据的中文编码问题
 */

const mysql = require('mysql2/promise');
require('dotenv').config();

async function fixEncoding() {
  console.log('=== 开始修复数据库编码问题 ===');
  
  // 创建连接
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'db',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'root',
    database: process.env.DB_NAME || 'AIreview',
    charset: 'utf8mb4',
    collation: 'utf8mb4_unicode_ci'
  });

  try {
    // 1. 设置连接字符集
    console.log('设置连接字符集...');
    await connection.query('SET NAMES utf8mb4');
    await connection.query('SET CHARACTER SET utf8mb4');
    await connection.query('SET character_set_connection=utf8mb4');
    await connection.query('SET character_set_results=utf8mb4');

    // 2. 检查数据库字符集
    console.log('检查数据库字符集...');
    const [dbResults] = await connection.query(`
      SELECT default_character_set_name, default_collation_name
      FROM information_schema.SCHEMATA
      WHERE schema_name = ?
    `, [process.env.DB_NAME || 'AIreview']);
    
    console.log('数据库默认字符集:', dbResults[0]);
    
    // 如果字符集不是utf8mb4，尝试修改
    if (dbResults[0].default_character_set_name !== 'utf8mb4') {
      console.log('修改数据库字符集为utf8mb4...');
      await connection.query(`
        ALTER DATABASE \`${process.env.DB_NAME || 'AIreview'}\` 
        CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
      `);
      console.log('数据库字符集已更新');
    }

    // 3. 检查表字符集
    console.log('检查表字符集...');
    const [tables] = await connection.query(`
      SELECT table_name, table_collation
      FROM information_schema.TABLES
      WHERE table_schema = ?
    `, [process.env.DB_NAME || 'AIreview']);
    
    for (const table of tables) {
      if (!table.table_collation.startsWith('utf8mb4')) {
        console.log(`修改表 ${table.table_name} 的字符集为utf8mb4...`);
        await connection.query(`
          ALTER TABLE \`${table.table_name}\` 
          CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
        `);
        console.log(`表 ${table.table_name} 字符集已更新`);
      }
    }

    // 4. 检查并修复problems表中的乱码
    try {
      console.log('检查problems表中的乱码...');
      
      // 获取所有问题记录
      const [problems] = await connection.query('SELECT id, title, description, tags, difficulty FROM problems');
      console.log(`找到 ${problems.length} 条题目记录`);
      
      // 定义常见乱码映射
      const difficultyMap = {
        'ç®€å•': '简单',
        'ä¸­ç­‰': '中等',
        'å›°é›£': '困难'
      };
      
      const tagMap = {
        'æ•°ç»„': '数组',
        'å"ˆå¸Œè¡¨': '哈希表',
        'é"¾è¡¨': '链表',
        'å­—ç¬¦ä¸²': '字符串',
        'åŠ¨æ€è§„åˆ': '动态规划',
        'è´ªå¿ƒç®—æ³•': '贪心算法'
      };
      
      // 修复每条记录
      for (const problem of problems) {
        let needsUpdate = false;
        const updates = {};
        
        // 检查并修复difficulty
        if (problem.difficulty && difficultyMap[problem.difficulty]) {
          updates.difficulty = difficultyMap[problem.difficulty];
          needsUpdate = true;
          console.log(`修复题目 ${problem.id} 的难度: ${problem.difficulty} -> ${updates.difficulty}`);
        }
        
        // 检查并修复tags
        if (problem.tags) {
          // 先按逗号分割
          const tags = problem.tags.split(',');
          let tagsChanged = false;
          
          // 修复每个标签
          const fixedTags = tags.map(tag => {
            const trimmedTag = tag.trim();
            if (tagMap[trimmedTag]) {
              tagsChanged = true;
              return tagMap[trimmedTag];
            }
            return trimmedTag;
          });
          
          if (tagsChanged) {
            updates.tags = fixedTags.join(',');
            needsUpdate = true;
            console.log(`修复题目 ${problem.id} 的标签: ${problem.tags} -> ${updates.tags}`);
          }
        }
        
        // 检查是否需要更新
        if (needsUpdate) {
          const updateFields = Object.keys(updates).map(field => `${field} = ?`).join(', ');
          const values = [...Object.values(updates), problem.id];
          
          await connection.query(`UPDATE problems SET ${updateFields} WHERE id = ?`, values);
          console.log(`题目 ${problem.id} 已更新`);
        }
      }
    } catch (err) {
      console.error('修复problems表数据时出错:', err);
    }

    console.log('=== 编码修复完成 ===');
  } catch (err) {
    console.error('修复编码失败:', err);
  } finally {
    await connection.end();
  }
}

// 执行修复
fixEncoding().catch(console.error); 