const fs = require('fs').promises;
const path = require('path');
const testCaseService = require('../testCase');
const { Sandbox, createSandbox } = require('./sandbox');

// 定义判题结果常量
const JudgeResult = {
  AC: 'Accepted',
  WA: 'Wrong Answer',
  TLE: 'Time Limit Exceeded',
  MLE: 'Memory Limit Exceeded',
  RE: 'Runtime Error',
  CE: 'Compilation Error',
  SE: 'System Error'
};

class Executor {
  constructor() {
    this.sandbox = null;
    this.JudgeResult = JudgeResult; // 在构造函数中添加对JudgeResult的引用
  }

  async execute(submission) {
    try {
      // 获取所有测试用例
      const testCases = await testCaseService.getAllTestCases(submission.problemId || submission.problem_id);
      if (!testCases || testCases.length === 0) {
        throw new Error('题目没有测试用例');
      }

      const results = [];
      let totalTime = 0;
      let maxMemory = 0;
      let finalStatus = 'Accepted';
      let failedTestCase = null;

      // 标准化语言名称
      const normalizedLanguage = submission.language.toLowerCase();
      console.log('标准化后的语言:', normalizedLanguage);
      
      // 支持C++的不同写法
      const standardLanguage = normalizedLanguage === 'c++' ? 'cpp' : normalizedLanguage;
      
      // 创建沙箱环境
      this.sandbox = await createSandbox(normalizedLanguage);
      await this.sandbox.init();
      
      if (standardLanguage === 'c' || standardLanguage === 'cpp') {
        const compileResult = await this.sandbox.compile(submission.code, standardLanguage);
        if (compileResult.error) {
          console.error('编译错误:', compileResult.error);
          return {
            status: this.JudgeResult.CE,
            error: compileResult.error
          };
        }
      }

      // 依次执行每个测试用例
      for (const testCase of testCases) {
        console.log('执行测试用例:', testCase);
        
        const result = await this.sandbox.run(submission.code, submission.language, testCase.input);
        
        if (result.error) {
          return {
            status: this.JudgeResult.RE,
            error: result.error,
            testCase: testCase.is_example ? testCase : null
          };
        }

        const actualOutput = this.normalizeOutput(result.output);
        const expectedOutput = this.normalizeOutput(testCase.output);
        const isCorrect = actualOutput === expectedOutput;

        totalTime += result.runtime || 0;
        maxMemory = Math.max(maxMemory, result.memory || 0);

        // 记录测试结果
        const testResult = {
          input: testCase.is_example ? testCase.input : '隐藏用例',
          expectedOutput: testCase.is_example ? testCase.output : '隐藏用例',
          actualOutput: testCase.is_example ? actualOutput : '隐藏用例',
          status: isCorrect ? this.JudgeResult.AC : this.JudgeResult.WA,
          time: result.runtime || 0,
          memory: result.memory || 0
        };

        results.push(testResult);

        // 如果答案错误，立即终止并记录状态
        if (!isCorrect) {
          finalStatus = this.JudgeResult.WA;
          failedTestCase = {
            input: testCase.input,
            expected_output: testCase.output,
            actual: actualOutput,
            is_example: testCase.is_example
          };
          break;
        }
      }

      return {
        status: finalStatus,
        runtime: totalTime,
        memory: maxMemory,
        testCaseResults: results,
        failedTestCase: failedTestCase,
        message: finalStatus === this.JudgeResult.AC ? '通过所有测试用例' : '未通过全部测试用例'
      };
    } catch (error) {
      console.error('Error executing code:', error);
      return {
        status: this.JudgeResult.SE,
        message: error.message,
        testCaseResults: []
      };
    } finally {
      await this.sandbox.cleanup();
    }
  }

  // 添加新的调试执行方法
  async executeDebug(code, language, input) {
    try {
      console.log('准备调试执行代码...');
      
      // 标准化语言名称
      const normalizedLanguage = language.toLowerCase();
      console.log('标准化后的语言:', normalizedLanguage);
      
      // 支持C++的不同写法
      const standardLanguage = normalizedLanguage === 'c++' ? 'cpp' : normalizedLanguage;
      
      // 初始化沙箱
      this.sandbox = await createSandbox(normalizedLanguage);
      await this.sandbox.init();
      
      // 编译代码（如果需要）
      if (standardLanguage === 'c' || standardLanguage === 'cpp') {
        const compileResult = await this.sandbox.compile(code, standardLanguage);
        if (compileResult.error) {
          console.error('编译错误:', compileResult.error);
          return {
            status: 'error',
            error: compileResult.error
          };
        }
      }

      // 直接运行代码并返回结果
      const result = await this.sandbox.run(code, language, input);
      
      if (result.error) {
        console.error('运行时错误:', result.error);
        return {
          status: 'error',
          error: result.error
        };
      }

      // 返回执行结果
      return {
        status: 'success',
        output: this.normalizeOutput(result.output), // 直接使用输出结果
        runtime: result.runtime,
        memory: result.memory || 0
      };

    } catch (error) {
      console.error('执行器错误:', error);
      return {
        status: 'error',
        error: error.message
      };
    } finally {
      // 清理沙箱环境
      await this.sandbox.cleanup();
    }
  }

  normalizeOutput(output) {
    if (!output) return '';
    return output.toString().trim();
  }
}

module.exports = {
  Executor,
  JudgeResult
};
