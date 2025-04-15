const problemPoolModel = require('./problemPoolModel');

/**
 * 获取题目池统计信息
 * @returns {Promise<Object>} 统计信息
 */
async function getStatistics() {
  try {
    const totalProblems = await problemPoolModel.getTotalProblems();
    const totalCategories = await problemPoolModel.getTotalCategories();
    const difficultyDistribution = await problemPoolModel.getDifficultyDistribution();
    
    return {
      totalProblems,
      totalCategories,
      difficultyDistribution
    };
  } catch (error) {
    console.error('获取题目池统计信息失败:', error);
    throw new Error('获取题目池统计信息失败');
  }
}

/**
 * 获取题目池列表
 * @param {Object} options 查询选项
 * @returns {Promise<Object>} 查询结果
 */
async function getProblemList(options) {
  try {
    return await problemPoolModel.getProblemList(options);
  } catch (error) {
    console.error('获取题目池列表失败:', error);
    throw new Error('获取题目池列表失败');
  }
}

/**
 * 获取题目池分类列表
 * @returns {Promise<Array>} 分类列表
 */
async function getCategoryList() {
  try {
    return await problemPoolModel.getCategoryList();
  } catch (error) {
    console.error('获取题目池分类列表失败:', error);
    throw new Error('获取题目池分类列表失败');
  }
}

/**
 * 获取题目标签列表
 * @returns {Promise<Array>} 标签列表
 */
async function getTagList() {
  try {
    return await problemPoolModel.getTagList();
  } catch (error) {
    console.error('获取题目标签列表失败:', error);
    throw new Error('获取题目标签列表失败');
  }
}

/**
 * 获取题目详情
 * @param {number} id 题目ID
 * @returns {Promise<Object>} 题目详情
 */
async function getProblemDetail(id) {
  try {
    return await problemPoolModel.getProblemDetail(id);
  } catch (error) {
    console.error(`获取题目(ID: ${id})详情失败:`, error);
    throw error;
  }
}

/**
 * 获取题目测试用例
 * @param {number} id 题目ID
 * @returns {Promise<Array>} 测试用例列表
 */
async function getProblemTestCases(id) {
  try {
    // 先检查题目是否存在
    const problem = await problemPoolModel.getProblemById(id);
    if (!problem) {
      throw new Error('题目不存在');
    }
    
    return await problemPoolModel.getProblemTestCases(id);
  } catch (error) {
    console.error(`获取题目(ID: ${id})测试用例失败:`, error);
    throw error;
  }
}

/**
 * 获取题目解决方案
 * @param {number} id 题目ID
 * @returns {Promise<Object>} 解决方案
 */
async function getProblemSolution(id) {
  try {
    // 先检查题目是否存在
    const problem = await problemPoolModel.getProblemById(id);
    if (!problem) {
      throw new Error('题目不存在');
    }
    
    const solution = await problemPoolModel.getProblemSolution(id);
    const solutionCode = await problemPoolModel.getProblemSolutionCode(id);
    
    // 将代码与解决方案合并
    if (solution) {
      solution.code = solutionCode || [];
    }
    
    return solution;
  } catch (error) {
    console.error(`获取题目(ID: ${id})解决方案失败:`, error);
    throw error;
  }
}

/**
 * 从题目池中删除题目
 * @param {number} id 题目ID
 * @returns {Promise<Object>} 操作结果
 */
async function deleteProblem(id) {
  try {
    // 先获取题目信息，确保题目存在
    const problemDetail = await problemPoolModel.getProblemDetail(id);
    
    // 执行删除操作
    await problemPoolModel.deleteProblem(id);
    
    return {
      message: '题目已从题目池中删除'
    };
  } catch (error) {
    console.error(`删除题目(ID: ${id})失败:`, error);
    throw error;
  }
}

/**
 * 将题目从题目池引用到正式题库
 * @param {number} id 题目池中的题目ID
 * @param {Object} data 修改后的题目数据
 * @returns {Promise<Object>} 引用结果
 */
async function importProblem(id, data) {
  try {
    // 校验数据
    validateImportData(data);
    
    // 执行导入操作
    return await problemPoolModel.importProblem(id, data);
  } catch (error) {
    console.error(`引用题目(ID: ${id})失败:`, error);
    throw error;
  }
}

/**
 * 校验导入数据
 * @param {Object} data 导入数据
 * @throws {Error} 校验失败时抛出错误
 */
function validateImportData(data) {
  if (!data.problem) {
    throw new Error('缺少题目基本信息');
  }
  
  if (!data.problem.title) {
    throw new Error('题目标题不能为空');
  }
  
  if (!data.problem.difficulty) {
    throw new Error('题目难度不能为空');
  }
  
  if (!data.problem.description) {
    throw new Error('题目描述不能为空');
  }
  
  if (data.test_cases && data.test_cases.length > 0) {
    data.test_cases.forEach((testCase, index) => {
      if (!testCase.input) {
        throw new Error(`第${index + 1}个测试用例的输入不能为空`);
      }
      if (!testCase.output) {
        throw new Error(`第${index + 1}个测试用例的输出不能为空`);
      }
    });
  }
  
  if (data.solutions) {
    if (!data.solutions.solution_approach) {
      throw new Error('解决方案说明不能为空');
    }
    
    if (data.solutions.code && data.solutions.code.length > 0) {
      data.solutions.code.forEach((code, index) => {
        if (!code.language_id) {
          throw new Error(`第${index + 1}个解决方案代码的语言ID不能为空`);
        }
        if (!code.standard_solution) {
          throw new Error(`第${index + 1}个解决方案代码的标准解法不能为空`);
        }
      });
    }
  }
}

module.exports = {
  getStatistics,
  getProblemList,
  getCategoryList,
  getTagList,
  getProblemDetail,
  getProblemTestCases,
  getProblemSolution,
  deleteProblem,
  importProblem
}; 