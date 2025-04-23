const pool = require('../db');

// 执行SQL查询
const query = async (sql, params = []) => {
  try {
    console.log('执行SQL查询:', sql);
    console.log('参数:', params);
    const [results] = await pool.execute(sql, params);
    console.log('查询结果:', results);
    return [results];
  } catch (error) {
    console.error('SQL查询错误:', {
      message: error.message,
      sql: sql,
      params: params,
      stack: error.stack
    });
    throw error;
  }
};

module.exports = {
  query
}; 