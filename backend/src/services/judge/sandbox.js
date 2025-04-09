const { exec } = require('child_process');
const fs = require('fs').promises;
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const { performance } = require('perf_hooks');
const { execCommand, sleep } = require('./utils');
const util = require('util');
const execAsync = util.promisify(exec);

class Sandbox {
  constructor() {
    this.tempDir = path.join(__dirname, '../../temp');
    this.workDir = path.join(this.tempDir, uuidv4());
  }

  async init() {
    try {
      // 确保临时目录存在
      await fs.mkdir(this.tempDir, { recursive: true });
      await fs.mkdir(this.workDir, { recursive: true });
      
      // 创建并启动 Docker 容器
      this.containerId = `judge-${uuidv4()}`;
      const cmd = `docker run -d --network none --cpus=1 --memory=512m --name=${this.containerId} -w /app gcc:latest tail -f /dev/null`;
      
      await execCommand(cmd);
      console.log('Docker容器创建成功:', this.containerId);
      
      // 等待容器启动完成
      await sleep(1000);
      
      // 创建工作目录
      await execCommand(`docker exec ${this.containerId} mkdir -p /app`);
      console.log('容器工作目录创建成功');
      
      return this;
    } catch (error) {
      console.error('初始化沙箱环境失败:', error);
      throw error;
    }
  }

  async copyToContainer(sourceFile, targetPath) {
    try {
      await execCommand(`docker cp ${sourceFile} ${this.containerId}:${targetPath}`);
      console.log('文件复制到容器成功:', targetPath);
      return true;
    } catch (error) {
      console.error('复制文件到容器失败:', error);
      throw error;
    }
  }

  async runCommand(command, input) {
    try {
      // 创建临时输入文件
      const inputFile = path.join(this.workDir, 'input.txt');
      await fs.writeFile(inputFile, input);
      
      // 复制输入文件到容器
      await this.copyToContainer(inputFile, '/app/input.txt');
      
      // 执行命令，使用文件重定向
      const { stdout, stderr } = await execCommand(
        `docker exec ${this.containerId} bash -c "${command} < /app/input.txt"`
      );
      
      console.log('命令执行结果:', { stdout, stderr, input }); // 添加调试日志
      
      if (stderr) {
        return {
          status: 'runtime_error',
          error: stderr,
          memory: await this.getMemoryUsage()
        };
      }
      return {
        status: 'success',
        output: stdout.replace(/\r\n/g, '\n').trim(),  // 统一处理换行符
        memory: await this.getMemoryUsage()
      };
    } catch (error) {
      console.error('在容器中执行命令失败:', error);
      return {
        status: 'runtime_error',
        error: error.message,
        memory: await this.getMemoryUsage()
      };
    }
  }

  async getMemoryUsage() {
    try {
      const { stdout } = await execCommand(
        `docker stats ${this.containerId} --no-stream --format "{{.MemUsage}}" | awk '{print $1}' | sed 's/[A-Za-z]*$//'`
      );
      // 将内存使用量转换为KB
      const memoryStr = stdout.trim();
      let memory = parseFloat(memoryStr);
      if (memoryStr.includes('MB')) {
        memory *= 1024; // 转换为KB
      } else if (memoryStr.includes('GB')) {
        memory *= 1024 * 1024; // 转换为KB
      }
      return Math.round(memory);
    } catch (error) {
      console.error('获取内存使用情况失败:', error);
      return 0;
    }
  }

  async cleanup() {
    try {
      // 删除容器
      if (this.containerId) {
        try {
          await execCommand(`docker rm -f ${this.containerId}`);
          console.log('容器删除成功:', this.containerId);
        } catch (error) {
          console.error('删除容器失败:', error);
        }
      }
      
      // 删除临时文件
      if (this.workDir) {
        try {
          await fs.rm(this.workDir, { recursive: true, force: true });
          console.log('临时文件删除成功:', this.workDir);
        } catch (error) {
          console.error('删除临时文件失败:', error);
        }
      }
    } catch (error) {
      console.error('清理沙箱环境失败:', error);
    }
  }

  async compile(code, language) {
    try {
      console.log('开始编译代码...');
      
      // 创建临时文件
      const filename = `temp_${Date.now()}`;
      const sourceFile = path.join(this.tempDir, `${filename}.${language === 'cpp' ? 'cpp' : 'c'}`);
      const outputFile = path.join(this.tempDir, `${filename}.out`);

      // 确保临时目录存在
      await fs.mkdir(this.tempDir, { recursive: true });

      // 写入源代码
      await fs.writeFile(sourceFile, code);

      // 编译命令
      const compileCmd = language === 'cpp' 
        ? `g++ "${sourceFile}" -o "${outputFile}" -Wall`
        : `gcc "${sourceFile}" -o "${outputFile}" -Wall`;

      // 执行编译
      try {
        await execCommand(compileCmd);
        console.log('编译成功');
        
        // 清理源文件
        await fs.unlink(sourceFile);
        
        return {
          outputFile
        };
      } catch (error) {
        // 清理文件
        try {
          await fs.unlink(sourceFile);
          await fs.unlink(outputFile).catch(() => {});
        } catch (e) {
          console.error('清理文件失败:', e);
        }

        return {
          error: error.stderr || error.message
        };
      }
    } catch (error) {
      console.error('编译过程出错:', error);
      return {
        error: '编译过程发生系统错误'
      };
    }
  }

  async run(code, language, input) {
    try {
      console.log('开始运行代码...');
      const startTime = process.hrtime();

      // 标准化语言名称
      const normalizedLanguage = language.toLowerCase();
      console.log('标准化后的语言:', normalizedLanguage);

      let result;
      if (normalizedLanguage === 'c' || normalizedLanguage === 'cpp') {
        // 编译并运行
        const compileResult = await this.compile(code, normalizedLanguage);
        if (compileResult.error) {
          return compileResult;
        }

        // 创建输入文件
        const inputFile = path.join(this.tempDir, `input_${Date.now()}.txt`);
        await fs.writeFile(inputFile, input || '');

        // 运行可执行文件
        try {
          result = await this.runExecutable(compileResult.outputFile, inputFile);
          
          // 计算运行时间
          const [seconds, nanoseconds] = process.hrtime(startTime);
          const runtime = seconds * 1000 + nanoseconds / 1000000; // 转换为毫秒

          // 获取内存使用情况
          const memory = await this.getMemoryUsage();
          
          // 清理文件
          await fs.unlink(compileResult.outputFile);
          await fs.unlink(inputFile);
          
          return {
            output: result.stdout,
            runtime,
            memory
          };
          
        } catch (error) {
          // 清理文件
          try {
            await fs.unlink(compileResult.outputFile);
            await fs.unlink(inputFile);
          } catch (e) {
            console.error('清理文件失败:', e);
          }

          return {
            error: error.stderr || '程序执行时发生错误'
          };
        }
      } else if (normalizedLanguage === 'python') {
        // 创建Python源文件和输入文件
        const pythonFile = path.join(this.tempDir, `temp_${Date.now()}.py`);
        const inputFile = path.join(this.tempDir, `input_${Date.now()}.txt`);
        
        await fs.writeFile(pythonFile, code);
        await fs.writeFile(inputFile, input || '');

        try {
          result = await this.runPython(pythonFile, inputFile);
          
          // 计算运行时间
          const [seconds, nanoseconds] = process.hrtime(startTime);
          const runtime = seconds * 1000 + nanoseconds / 1000000;

          // 获取内存使用情况
          const memory = await this.getMemoryUsage();
          
          // 清理文件
          await fs.unlink(pythonFile);
          await fs.unlink(inputFile);
          
          return {
            output: result.stdout,
            runtime,
            memory
          };
          
        } catch (error) {
          // 清理文件
          try {
            await fs.unlink(pythonFile);
            await fs.unlink(inputFile);
          } catch (e) {
            console.error('清理文件失败:', e);
          }

          return {
            error: error.stderr || '程序执行时发生错误'
          };
        }
      } else {
        return {
          error: '不支持的编程语言'
        };
      }
    } catch (error) {
      console.error('运行过程出错:', error);
      return {
        error: '运行过程发生系统错误'
      };
    }
  }

  async runExecutable(executablePath, inputPath) {
    return await execCommand(`"${executablePath}" < "${inputPath}"`);
  }

  async runPython(pythonFile, inputPath) {
    return await execCommand(`python3 "${pythonFile}" < "${inputPath}"`);
  }
}

async function createSandbox(language) {
  // 标准化语言名称为小写
  const normalizedLanguage = language.toLowerCase();
  const workDir = await createTempDirectory();
  const containerName = `judge-${uuidv4()}`;
  
  // 根据语言选择Docker镜像
  const images = {
    'c': 'gcc:latest',
    'cpp': 'gcc:latest',
    'python': 'python:3.9-slim',
    'java': 'openjdk:11'
  };
  
  // 检查语言是否支持
  if (!images[normalizedLanguage]) {
    throw new Error(`不支持的编程语言: ${language}`);
  }
  
  const image = images[normalizedLanguage];
  console.log('使用Docker镜像:', image);
  
  const cmd = `docker run -d --network none --cpus=1 --memory=512m --name=${containerName} -w /app ${image} tail -f /dev/null`;
  
  try {
    await execCommand(cmd);
    console.log('Docker容器创建成功:', containerName);
    
    // 等待容器启动完成
    console.log('等待容器启动完成');
    await sleep(1000);
    
    // 创建工作目录
    await execCommand(`docker exec ${containerName} mkdir -p /app`);
    console.log('容器工作目录创建成功');
    
    return new Sandbox(containerName, workDir);
  } catch (error) {
    console.error('创建沙箱环境失败:', error);
    throw error;
  }
}

async function createTempDirectory() {
  const tempDir = path.join(__dirname, '../../temp', uuidv4());
  await fs.mkdir(tempDir, { recursive: true });
  console.log('工作目录创建成功:', tempDir);
  return tempDir;
}

module.exports = {
  Sandbox
};
