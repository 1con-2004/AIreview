const { exec } = require('child_process');
const fs = require('fs').promises;
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const { performance } = require('perf_hooks');
const { execCommand, sleep } = require('./utils');
const util = require('util');
const execAsync = util.promisify(exec);

class Sandbox {
  constructor(containerId, workDir, language) {
    this.containerId = containerId;
    this.workDir = workDir;
    this.tempDir = path.join(__dirname, '../../temp');
    this.language = language;
  }

  async init() {
    try {
      // 确保临时目录存在
      await fs.mkdir(this.tempDir, { recursive: true });
      
      // 确保workDir存在，如果不存在则创建一个新的
      if (!this.workDir) {
        this.workDir = path.join(this.tempDir, uuidv4());
        console.log('创建新的工作目录:', this.workDir);
      }
      
      await fs.mkdir(this.workDir, { recursive: true });
      
      // 容器已由constructor创建，不需要重复创建
      console.log('使用已创建的容器:', this.containerId);
      
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

      // 预处理代码
      let processedCode = this.preprocessCode(code, language);

      // 写入处理后的源代码
      await fs.writeFile(sourceFile, processedCode);

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
      
      // 将c++标准化为cpp
      const standardLanguage = normalizedLanguage === 'c++' ? 'cpp' : normalizedLanguage;

      // 预处理代码
      let processedCode = this.preprocessCode(code, standardLanguage);

      let result;
      if (standardLanguage === 'c' || standardLanguage === 'cpp') {
        // 编译并运行
        const compileResult = await this.compile(processedCode, standardLanguage);
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
      } else if (standardLanguage === 'java') {
        // 创建Java源文件和输入文件
        const javaFile = path.join(this.tempDir, `temp_${Date.now()}.java`);
        const inputFile = path.join(this.tempDir, `input_${Date.now()}.txt`);
        
        await fs.writeFile(javaFile, processedCode);
        await fs.writeFile(inputFile, input || '');

        try {
          // 使用专门的Java执行方法
          result = await this.runJava(javaFile, inputFile);
          
          if (result.error) {
            // 清理文件
            try {
              await fs.unlink(javaFile);
              await fs.unlink(inputFile);
            } catch (e) {
              console.error('清理文件失败:', e);
            }
            
            return {
              error: result.error
            };
          }
          
          // 获取内存使用情况
          const memory = await this.getMemoryUsage();
          
          // 清理文件
          await fs.unlink(javaFile);
          await fs.unlink(inputFile);
          
          return {
            output: result.stdout,
            runtime: result.runtime || 0,
            memory
          };
        } catch (error) {
          // 清理文件
          try {
            await fs.unlink(javaFile);
            await fs.unlink(inputFile);
          } catch (e) {
            console.error('清理文件失败:', e);
          }

          return {
            error: error.message || '执行Java代码失败'
          };
        }
      } else if (standardLanguage === 'python') {
        // 创建Python源文件和输入文件
        const pythonFile = path.join(this.tempDir, `temp_${Date.now()}.py`);
        const inputFile = path.join(this.tempDir, `input_${Date.now()}.txt`);
        
        await fs.writeFile(pythonFile, processedCode);
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

  async runJava(javaFile, inputPath) {
    try {
      // 复制Java文件到容器
      const fileName = path.basename(javaFile);
      const containerPath = `/app/${fileName}`;
      await this.copyToContainer(javaFile, containerPath);
      
      // 复制输入文件到容器
      const inputFileName = path.basename(inputPath);
      const containerInputPath = `/app/${inputFileName}`;
      await this.copyToContainer(inputPath, containerInputPath);
      
      // 在容器中编译Java代码
      console.log(`编译Java文件: ${fileName}`);
      const compileCommand = `javac ${containerPath}`;
      const compileResult = await execCommand(`docker exec ${this.containerId} ${compileCommand}`);
      
      if (compileResult.stderr) {
        return {
          error: compileResult.stderr
        };
      }
      
      // 获取Java文件内容
      const fileContent = await fs.readFile(javaFile, 'utf8');
      
      // 尝试从文件内容中提取类名
      let className = 'Solution'; // 默认使用Solution类名（与preprocessJavaCode方法中的默认类名一致）
      const classMatch = fileContent.match(/\bclass\s+(\w+)\s*\{/);
      if (classMatch && classMatch[1]) {
        className = classMatch[1];
        console.log(`从代码中提取到类名: ${className}`);
      } else {
        console.log(`未找到类定义，使用默认类名: ${className}`);
      }
      
      // 在容器中运行Java代码 - 使用cat命令读取输入文件并通过管道传递给java程序
      console.log(`运行Java类: ${className}`);
      const runCommand = `docker exec ${this.containerId} bash -c "cat ${containerInputPath} | java -cp /app ${className}"`;
      
      const startTime = process.hrtime();
      const result = await execCommand(runCommand);
      const [seconds, nanoseconds] = process.hrtime(startTime);
      const runtime = seconds * 1000 + nanoseconds / 1000000;
      
      if (result.stderr) {
        return {
          error: result.stderr
        };
      }
      
      return {
        stdout: result.stdout,
        stderr: result.stderr,
        runtime
      };
    } catch (error) {
      console.error('执行Java代码失败:', error);
      return {
        error: error.message || '执行Java代码失败'
      };
    }
  }

  // 预处理用户代码，添加必要的数据结构和框架代码
  preprocessCode(code, language) {
    // 已经标准化了语言名称为小写
    const standardLanguage = language === 'c++' ? 'cpp' : language;
    
    // 通用的结构定义
    const commonStructures = {};
    
    // 处理空代码
    if (!code || code.trim() === '') {
      return '';
    }
    
    // 根据不同的语言处理代码
    switch (standardLanguage) {
      case 'c': 
        return this.preprocessCCode(code, commonStructures);
      case 'cpp':
        return this.preprocessCppCode(code, commonStructures);
      case 'python':
        return this.preprocessPythonCode(code, commonStructures);
      case 'java':
        return this.preprocessJavaCode(code, commonStructures);
      default:
        return code;
    }
  }

  // 预处理C代码
  preprocessCCode(code, commonStructures) {
    // 判断代码中是否包含main函数
    const hasMain = /\bint\s+main\s*\(/.test(code);
    
    // 如果已经有main函数，不进行额外处理
    if (hasMain) return code;
    
    const preamble = [];
    
    // 添加常用头文件
    preamble.push("#include <stdio.h>");
    preamble.push("#include <stdlib.h>");
    preamble.push("#include <string.h>");
    preamble.push("#include <stdbool.h>");
    
    // 检查并添加缺失的数据结构定义
    for (const [structName, structInfo] of Object.entries(commonStructures)) {
      if (structInfo.regex.test(code) && !structInfo.defRegex.c.test(code)) {
        preamble.push(structInfo.implementations.c);
      }
    }
    
    // 添加main函数
    const postamble = `

// 主函数 - 仅为满足编译要求
int main() {
    printf("代码成功编译！\\n");
    return 0;
}`;
    
    // 组合成完整代码
    return preamble.join("\n") + "\n\n" + code + postamble;
  }

  // 预处理C++代码
  preprocessCppCode(code, commonStructures) {
    // 判断代码中是否包含main函数
    const hasMain = /\bint\s+main\s*\(/.test(code);
    
    // 如果已经有main函数，不进行额外处理
    if (hasMain) return code;
    
    const preamble = [];
    
    // 添加常用头文件
    preamble.push("#include <iostream>");
    preamble.push("#include <vector>");
    preamble.push("#include <string>");
    preamble.push("#include <algorithm>");
    preamble.push("#include <queue>");
    preamble.push("#include <unordered_map>");
    preamble.push("#include <unordered_set>");
    
    // 检查并添加缺失的数据结构定义
    for (const [structName, structInfo] of Object.entries(commonStructures)) {
      if (structInfo.regex.test(code) && !structInfo.defRegex.cpp.test(code)) {
        preamble.push(structInfo.implementations.cpp);
      }
    }
    
    // 添加main函数
    const postamble = `

// 主函数 - 仅为满足编译要求
int main() {
    std::cout << "代码成功编译！" << std::endl;
    return 0;
}`;
    
    // 组合成完整代码
    return preamble.join("\n") + "\n\n" + code + postamble;
  }

  // 预处理Python代码
  preprocessPythonCode(code, commonStructures) {
    // 检查代码是否有if __name__ == "__main__"部分
    const hasMainBlock = /if\s+__name__\s*==\s*['"]__main__['"]/.test(code);
    
    const preamble = [];
    
    // 添加常用的导入
    preamble.push("# 自动添加的常用导入");
    preamble.push("import sys");
    preamble.push("import math");
    preamble.push("from typing import List, Optional");
    
    // 检查并添加缺失的数据结构定义
    for (const [structName, structInfo] of Object.entries(commonStructures)) {
      if (structInfo.regex.test(code) && !structInfo.defRegex.python.test(code)) {
        preamble.push(structInfo.implementations.python);
      }
    }
    
    // 如果没有main块，添加一个简单的main块，但不输出额外文本
    let postamble = "";
    if (!hasMainBlock) {
      postamble = `

# 主函数 - 仅为满足执行要求
if __name__ == "__main__":
    pass`;
    }
    
    // 组合成完整代码
    return preamble.join("\n") + "\n\n" + code + postamble;
  }

  // 预处理Java代码
  preprocessJavaCode(code, commonStructures) {
    // 检查代码中是否已经有类定义和main方法
    const hasClass = /\bclass\s+\w+\s*\{/.test(code);
    const hasMain = /public\s+static\s+void\s+main\s*\(\s*String\s*\[\]\s*\w*\s*\)/.test(code);
    
    // 如果已经有完整的类定义和main方法，则不进行预处理
    if (hasClass && hasMain) return code;
    
    // 准备添加的前置代码
    const preamble = [];
    
    // 添加数据结构定义
    for (const [structName, structInfo] of Object.entries(commonStructures)) {
      if (structInfo.regex.test(code) && !structInfo.defRegex.java.test(code)) {
        preamble.push(structInfo.implementations.java);
      }
    }
    
    // 处理代码
    let processedCode = code;
    
    // 如果没有类定义，添加类包装
    if (!hasClass) {
      // 使用自动生成的临时文件名作为类名，确保匹配
      const className = `Solution`;
      processedCode = `class ${className} {
    ${processedCode.replace(/^/gm, '    ')}
}`;
    }
    
    // 如果没有main方法，添加main方法
    if (!hasMain) {
      // 检查类的结束位置
      const lastBraceIndex = processedCode.lastIndexOf('}');
      if (lastBraceIndex !== -1) {
        // 在类的末尾插入main方法
        processedCode = processedCode.substring(0, lastBraceIndex) + `
    
    // 主函数 - 仅为满足编译要求
    public static void main(String[] args) {
        // 这里不需要输出任何内容
    }
` + processedCode.substring(lastBraceIndex);
      }
    }
    
    // 组合成完整代码
    return preamble.join("\n") + "\n\n" + processedCode;
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
    'c++': 'gcc:latest',  // 添加c++映射
    'python': 'python:3.9-slim',
    'java': 'openjdk:11'
  };
  
  // 检查语言是否支持
  if (!images[normalizedLanguage]) {
    throw new Error(`不支持的编程语言: ${language}`);
  }
  
  // 将c++标准化为cpp
  const standardLanguage = normalizedLanguage === 'c++' ? 'cpp' : normalizedLanguage;
  
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
    
    return new Sandbox(containerName, workDir, standardLanguage);
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
  Sandbox,
  createSandbox
};
