require('dotenv').config();

module.exports = {
    // JWT配置
    SECRET_KEY: process.env.JWT_SECRET || 'your-complex-secret-key-change-in-production',
    ACCESS_TOKEN_EXPIRE: '24h',  // 访问令牌有效期
    REFRESH_TOKEN_EXPIRE: '7d',  // 刷新令牌有效期
    
    // Token配置
    TOKEN_CONFIG: {
        algorithm: 'HS256',
        issuer: 'AIreview',
        audience: 'AIreview-client'
    }
}; 