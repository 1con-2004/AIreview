const { Executor, JudgeResult } = require('./executor');
const { createSandbox } = require('./sandbox');

// 定义统一的状态映射
const STATUS_MAP = {
  [JudgeResult.AC]: 'accepted',
  [JudgeResult.WA]: 'wrong_answer',
  [JudgeResult.TLE]: 'time_limit_exceeded',
  [JudgeResult.MLE]: 'memory_limit_exceeded',
  [JudgeResult.RE]: 'runtime_error',
  [JudgeResult.CE]: 'compilation_error',
  [JudgeResult.SE]: 'system_error'
};

async function executeCode(code, language, testCases) {
  const executor = new Executor();
  try {
    console.log('开始执行代码...');
    const result = await executor.execute(code, language, testCases);
    console.log('执行结果:', result);

    if (result.error) {
      // 处理编译错误
      if (result.error.includes('error:')) {
        return {
          status: 'compilation_error',
          error: `编译错误：\n${result.error}\n请检查代码语法是否正确。`
        };
      }
      // 处理运行时错误
      return {
        status: 'runtime_error',
        error: `运行时错误：\n${result.error}\n请检查是否存在数组越界、空指针等问题。`
      };
    }

    // 如果执行成功，返回输出结果
    return {
      status: 'success',
      output: result.output,
      runtime: result.runtime
    };

  } catch (error) {
    console.error('执行代码时发生错误:', error);
    return {
      status: 'system_error',
      error: '系统执行异常，请稍后重试。'
    };
  }
}

async function submitCode({ submissionId, code, language, problem, testCases }) {
  try {
    const executor = new Executor();
    console.log('开始判题，测试用例数量:', testCases.length);

    const result = await executor.execute({
      code,
      language,
      problemId: problem.id,
      timeLimit: problem.time_limit,
      memoryLimit: problem.memory_limit
    });
    
    console.log('执行结果:', result);

    // 确保所有字段都有默认值
    const status = STATUS_MAP[result.status] || 'system_error';
    let errorMessage = null;

    if (result.status === JudgeResult.WA && result.failedTestCase) {
      // 格式化错误消息，使其更加友好
      const testCase = result.failedTestCase;
      if (testCase.is_example) {
        errorMessage = `提交结果：答案错误\n\n测试用例：\n输入：${testCase.input}\n期望输出：${testCase.expected_output}\n您的输出：${testCase.actual}\n\n请检查您的代码逻辑是否正确。`;
      } else {
        errorMessage = '答案错误（隐藏用例）\n请检查您的代码逻辑是否正确。';
      }
    } else if (result.status === JudgeResult.CE) {
      // 编译错误的特殊处理
      errorMessage = `编译错误：\n${result.error}\n\n请检查代码的语法是否正确。`;
    } else if (result.status === JudgeResult.RE) {
      // 运行时错误的特殊处理
      errorMessage = `运行时错误：\n${result.error}\n\n请检查代码是否存在数组越界、空指针等问题。`;
    } else if (result.error) {
      errorMessage = result.error;
    }

    const response = {
      status: status,
      runtime: result.runtime || 0,
      memory: result.memory || 0,
      error_message: errorMessage,
      testCase: result.failedTestCase
    };

    console.log('返回结果:', response);
    return response;
  } catch (error) {
    console.error('判题过程出错:', error);
    return {
      status: 'system_error',
      runtime: 0,
      memory: 0,
      error_message: '系统错误：判题过程出现异常，请稍后重试。'
    };
  }
}

function formatErrorMessage(failedCase) {
  if (failedCase.status === 'Wrong Answer') {
    return `Wrong Answer\n输入: ${failedCase.input}\n期望输出: ${failedCase.expectedOutput}\n实际输出: ${failedCase.actualOutput}`;
  }
  return failedCase.error || '未知错误';
}

module.exports = {
  executeCode,
  submitCode
};
