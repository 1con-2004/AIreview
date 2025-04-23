require('dotenv').config();

const dbConfig = {
  host: process.env.DB_HOST || 'db',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'root',
  database: process.env.DB_NAME || 'AIreview',
  port: process.env.DB_PORT || 3306
};

module.exports = {
  dbConfig
}; 