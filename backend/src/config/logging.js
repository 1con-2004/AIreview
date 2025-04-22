// 日志级别配置文件
// 控制应用程序中各种类型日志的输出

/**
 * 日志级别：
 * 0: 不输出任何日志（静默模式）
 * 1: 只输出错误和警告日志
 * 2: 输出常规操作日志 + 错误和警告
 * 3: 输出调试日志 + 常规操作日志 + 错误和警告
 * 4: 输出所有详细日志
 */

// 默认日志级别
const defaultLogLevel = 2;

// 不同类型日志的配置
const logConfig = {
  // 全局日志级别控制
  global: {
    level: process.env.LOG_LEVEL ? parseInt(process.env.LOG_LEVEL) : defaultLogLevel
  },
  
  // 身份验证相关日志
  auth: {
    // 继承全局设置，如果需要可以单独设置
    level: process.env.AUTH_LOG_LEVEL || null,
    
    // 获取有效日志级别（优先使用指定设置，没有则使用全局设置）
    getLevel() {
      return this.level !== null ? parseInt(this.level) : logConfig.global.level;
    },
    
    // 是否应该记录详细的认证日志
    shouldLogDetailed() {
      return this.getLevel() >= 3;
    },
    
    // 是否应该记录基本的认证成功/失败
    shouldLogBasic() {
      return this.getLevel() >= 2;
    },
    
    // 是否应该记录认证错误
    shouldLogErrors() {
      return this.getLevel() >= 1;
    }
  },
  
  // API请求相关日志
  api: {
    level: process.env.API_LOG_LEVEL || null,
    
    getLevel() {
      return this.level !== null ? parseInt(this.level) : logConfig.global.level;
    },
    
    shouldLogRequests() {
      return this.getLevel() >= 2;
    },
    
    shouldLogResponses() {
      return this.getLevel() >= 3;
    },
    
    shouldLogErrors() {
      return this.getLevel() >= 1;
    }
  },
  
  // 数据库操作相关日志
  database: {
    level: process.env.DB_LOG_LEVEL || null,
    
    getLevel() {
      return this.level !== null ? parseInt(this.level) : logConfig.global.level;
    },
    
    shouldLogQueries() {
      return this.getLevel() >= 3;
    },
    
    shouldLogResults() {
      return this.getLevel() >= 4;
    },
    
    shouldLogErrors() {
      return this.getLevel() >= 1;
    }
  }
};

// 动态设置日志级别的方法
const setLogLevel = (category, level) => {
  if (logConfig[category]) {
    logConfig[category].level = level;
    console.log(`日志级别已设置: ${category} = ${level}`);
  } else {
    console.error(`未知的日志类别: ${category}`);
  }
};

// 全局设置日志级别的方法
const setGlobalLogLevel = (level) => {
  logConfig.global.level = level;
  console.log(`全局日志级别已设置: ${level}`);
};

module.exports = {
  logConfig,
  setLogLevel,
  setGlobalLogLevel
}; 