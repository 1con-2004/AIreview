const { exec } = require('child_process');
const { promisify } = require('util');

const execAsync = promisify(exec);

// 添加延迟函数
const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function execCommand(command) {
  try {
    console.log('执行命令:', command);
    const { stdout, stderr } = await execAsync(command, {
      timeout: 10000, // 10秒超时
      maxBuffer: 1024 * 1024 // 1MB缓冲区
    });
    
    if (stderr) {
      console.error('命令执行产生错误输出:', stderr);
    }
    
    return { stdout, stderr };
  } catch (error) {
    console.error('命令执行失败:', error);
    throw error;
  }
}

module.exports = {
  execCommand,
  sleep
}; 