require('dotenv').config();
const { dbConfig } = require('./db');
const jwtConfig = require('./jwt');

const config = {
  // 数据库配置
  db: dbConfig,
  
  // JWT配置
  jwt: jwtConfig,
  
  // DeepSeek配置
  DEEPSEEK_API_KEY: process.env.DEEPSEEK_API_KEY || 'sk-b593d34ca1f24fc6a8c66c216de03399',
  DEEPSEEK_API_URL: process.env.DEEPSEEK_API_URL || 'https://api.deepseek.com/v1/chat/completions',
  DEEPSEEK_BALANCE_URL: process.env.DEEPSEEK_BALANCE_URL || 'https://api.deepseek.com/user/balance',
  DEEPSEEK_MODELS_URL: process.env.DEEPSEEK_MODELS_URL || 'https://api.deepseek.com/models'
};

module.exports = config; 