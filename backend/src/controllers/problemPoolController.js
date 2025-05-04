const problemPoolService = require('../services/problemPoolService');

/**
 * 获取题目池统计信息
 * @param {Object} req Express请求对象
 * @param {Object} res Express响应对象
 * @returns {void}
 */
async function getStatistics(req, res) {
  try {
    const statistics = await problemPoolService.getStatistics();
    res.json({
      success: true,
      data: statistics
    });
  } catch (error) {
    console.error('获取题目池统计信息失败:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '获取题目池统计信息失败'
      }
    });
  }
}

/**
 * 获取题目池列表
 * @param {Object} req Express请求对象
 * @param {Object} res Express响应对象
 * @returns {void}
 */
async function getProblemList(req, res) {
  try {
    const options = {
      page: parseInt(req.query.page) || 1,
      limit: parseInt(req.query.limit) || 10,
      query: req.query.query || '',
      difficulty: req.query.difficulty || '',
      tags: req.query.tags || ''
    };
    
    const result = await problemPoolService.getProblemList(options);
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('获取题目池列表失败:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '获取题目池列表失败'
      }
    });
  }
}

/**
 * 获取题目池分类列表
 * @param {Object} req Express请求对象
 * @param {Object} res Express响应对象
 * @returns {void}
 */
async function getCategoryList(req, res) {
  try {
    const categories = await problemPoolService.getCategoryList();
    res.json({
      success: true,
      data: {
        categories
      }
    });
  } catch (error) {
    console.error('获取题目池分类列表失败:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '获取题目池分类列表失败'
      }
    });
  }
}

/**
 * 获取题目标签列表
 * @param {Object} req Express请求对象
 * @param {Object} res Express响应对象
 * @returns {void}
 */
async function getTagList(req, res) {
  try {
    const tags = await problemPoolService.getTagList();
    res.json({
      success: true,
      data: {
        tags
      }
    });
  } catch (error) {
    console.error('获取题目标签列表失败:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '获取题目标签列表失败'
      }
    });
  }
}

/**
 * 获取题目详情
 * @param {Object} req Express请求对象
 * @param {Object} res Express响应对象
 * @returns {void}
 */
async function getProblemDetail(req, res) {
  try {
    const id = parseInt(req.params.id);
    if (isNaN(id)) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: '无效的题目ID'
        }
      });
    }
    
    const problemDetail = await problemPoolService.getProblemDetail(id);
    res.json({
      success: true,
      data: problemDetail
    });
  } catch (error) {
    console.error('获取题目详情失败:', error);
    
    if (error.message === '题目不存在') {
      return res.status(404).json({
        success: false,
        error: {
          code: 'PROBLEM_NOT_FOUND',
          message: '题目不存在'
        }
      });
    }
    
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '获取题目详情失败'
      }
    });
  }
}

/**
 * 获取题目测试用例
 * @param {Object} req Express请求对象
 * @param {Object} res Express响应对象
 * @returns {void}
 */
async function getProblemTestCases(req, res) {
  try {
    const id = parseInt(req.params.id);
    if (isNaN(id)) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: '无效的题目ID'
        }
      });
    }
    
    console.log(`正在获取题目ID[${id}]的测试用例`);
    
    // 直接从数据库查询测试用例
    const pool = require('../db');
    const [rows] = await pool.query(
      'SELECT * FROM problem_pool_test_cases WHERE problem_pool_id = ? ORDER BY order_num',
      [id]
    );
    
    console.log(`找到${rows.length}个测试用例`);
    
    res.json({
      success: true,
      data: rows
    });
  } catch (error) {
    console.error('获取题目测试用例失败:', error);
    
    if (error.message === '题目不存在') {
      return res.status(404).json({
        success: false,
        error: {
          code: 'PROBLEM_NOT_FOUND',
          message: '题目不存在'
        }
      });
    }
    
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '获取题目测试用例失败'
      }
    });
  }
}

/**
 * 获取题目解决方案
 * @param {Object} req Express请求对象
 * @param {Object} res Express响应对象
 * @returns {void}
 */
async function getProblemSolution(req, res) {
  try {
    const id = parseInt(req.params.id);
    if (isNaN(id)) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: '无效的题目ID'
        }
      });
    }
    
    const solution = await problemPoolService.getProblemSolution(id);
    res.json({
      success: true,
      data: solution
    });
  } catch (error) {
    console.error('获取题目解决方案失败:', error);
    
    if (error.message === '题目不存在') {
      return res.status(404).json({
        success: false,
        error: {
          code: 'PROBLEM_NOT_FOUND',
          message: '题目不存在'
        }
      });
    }
    
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '获取题目解决方案失败'
      }
    });
  }
}

/**
 * 从题目池中删除题目
 * @param {Object} req Express请求对象
 * @param {Object} res Express响应对象
 * @returns {void}
 */
async function deleteProblem(req, res) {
  try {
    const id = parseInt(req.params.id);
    if (isNaN(id)) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: '无效的题目ID'
        }
      });
    }
    
    const result = await problemPoolService.deleteProblem(id);
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('删除题目失败:', error);
    
    if (error.message === '题目不存在') {
      return res.status(404).json({
        success: false,
        error: {
          code: 'PROBLEM_NOT_FOUND',
          message: '题目不存在'
        }
      });
    }
    
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '删除题目失败'
      }
    });
  }
}

/**
 * 将题目从题目池引用到正式题库
 * @param {Object} req Express请求对象
 * @param {Object} res Express响应对象
 * @returns {void}
 */
async function importProblem(req, res) {
  try {
    const id = parseInt(req.params.id);
    if (isNaN(id)) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: '无效的题目ID'
        }
      });
    }
    
    const data = req.body;
    const result = await problemPoolService.importProblem(id, data);
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('引用题目失败:', error);
    
    if (error.message === '题目不存在') {
      return res.status(404).json({
        success: false,
        error: {
          code: 'PROBLEM_NOT_FOUND',
          message: '题目不存在'
        }
      });
    }
    
    if (error.message.includes('不能为空')) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: error.message
        }
      });
    }
    
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '引用题目失败'
      }
    });
  }
}

/**
 * 直接将题目从题目池导入到正式题库（前端提供所有数据）
 * @param {Object} req Express请求对象
 * @param {Object} res Express响应对象
 * @returns {void}
 */
async function importProblemDirect(req, res) {
  try {
    const pool = require('../db');
    const data = req.body;
    
    // 必要字段验证
    if (!data.problem_pool_id) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: '题目ID不能为空'
        }
      });
    }
    
    if (!data.title) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: '题目标题不能为空'
        }
      });
    }
    
    if (!data.description) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: '题目描述不能为空'
        }
      });
    }
    
    // 获取最新题号并生成新题号
    const [maxNumberResult] = await pool.query('SELECT MAX(CAST(SUBSTR(problem_number, 1, 4) AS UNSIGNED)) AS max_number FROM problems');
    const maxNumber = maxNumberResult[0].max_number || 0;
    const newNumber = maxNumber + 1;
    const formattedNumber = String(newNumber).padStart(4, '0');
    
    // 开始事务
    await pool.query('START TRANSACTION');
    
    try {
      // 1. 插入题目基本信息
      const [problemResult] = await pool.query(
        'INSERT INTO problems (problem_number, title, difficulty, tags, description, time_limit, memory_limit) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [formattedNumber, data.title, data.difficulty, data.tags, data.description, data.time_limit, data.memory_limit]
      );
      
      const newProblemId = problemResult.insertId;
      
      // 处理标签与分类的关联
      if (data.tags && data.tags.trim()) {
        console.log(`处理题目ID ${newProblemId} 的标签 "${data.tags}" 与分类关联`);
        
        // 获取所有分类
        const [categories] = await pool.query('SELECT id, name FROM problem_categories');
        const categoryMap = {};
        categories.forEach(cat => {
          categoryMap[cat.name.toLowerCase()] = cat.id;
        });

        // 处理标签
        const tagList = data.tags.replace(/，/g, ',').split(',').map(tag => tag.trim()).filter(tag => tag);
        
        // 为每个标签创建关联
        for (const tag of tagList) {
          let categoryId = categoryMap[tag.toLowerCase()];
          
          // 如果标签不存在，则创建新标签
          if (!categoryId) {
            console.log(`未找到标签 "${tag}"，将自动创建新标签`);
            
            // 创建新标签
            const [insertResult] = await pool.query(
              'INSERT INTO problem_categories (name, description, level, order_num) VALUES (?, ?, ?, ?)',
              [tag, '待修改', 1, 0]
            );
            
            categoryId = insertResult.insertId;
            console.log(`成功创建新标签 "${tag}"，分类ID: ${categoryId}`);
            
            // 更新本地缓存
            categoryMap[tag.toLowerCase()] = categoryId;
          }
          
          // 创建题目与标签的关联
          await pool.query(
            'INSERT INTO problem_category_relations (problem_id, category_id) VALUES (?, ?)',
            [newProblemId, categoryId]
          );
          console.log(`为题目 ${newProblemId} 添加标签 ${tag}，分类ID: ${categoryId}`);
        }
      }
      
      // 2. 插入测试用例
      if (data.test_cases && data.test_cases.length > 0) {
        console.log(`使用提交的测试用例，数量: ${data.test_cases.length}`);
        // 确保每个测试用例都有正确的order_num
        let orderIndex = 1;
        for (const testCase of data.test_cases) {
          // 如果测试用例没有order_num或order_num为0，则使用自增序号
          const orderNum = (testCase.order_num && testCase.order_num > 0) ? testCase.order_num : orderIndex;
          
          console.log(`添加测试用例 ${orderIndex}/${data.test_cases.length}, order_num=${orderNum}, is_example=${testCase.is_example ? 1 : 0}`);
          
          await pool.query(
            'INSERT INTO problem_test_cases (problem_id, problem_number, input, output, is_example, order_num) VALUES (?, ?, ?, ?, ?, ?)',
            [newProblemId, formattedNumber, testCase.input, testCase.output, testCase.is_example ? 1 : 0, orderNum]
          );
          
          orderIndex++;
        }
      } else {
        // 如果没有提供测试用例，尝试从题目池中获取
        console.log(`未提供测试用例，尝试从题目池获取，题目池ID: ${data.problem_pool_id}`);
        
        if (data.problem_pool_id) {
          // 获取题目池中的测试用例
          const [poolTestCases] = await pool.query(
            'SELECT * FROM problem_pool_test_cases WHERE problem_pool_id = ?',
            [data.problem_pool_id]
          );
          
          if (poolTestCases.length > 0) {
            // 使用题目池的测试用例
            console.log(`从题目池获取到测试用例，数量: ${poolTestCases.length}`);
            let orderIndex = 1;
            for (const testCase of poolTestCases) {
              // 使用测试用例原有的order_num或者使用自增序号
              const orderNum = (testCase.order_num && testCase.order_num > 0) ? testCase.order_num : orderIndex;
              
              console.log(`添加题目池测试用例 ${orderIndex}/${poolTestCases.length}, order_num=${orderNum}, is_example=${testCase.is_example ? 1 : 0}`);
              
              await pool.query(
                'INSERT INTO problem_test_cases (problem_id, problem_number, input, output, is_example, order_num) VALUES (?, ?, ?, ?, ?, ?)',
                [newProblemId, formattedNumber, testCase.input, testCase.output, testCase.is_example, orderNum]
              );
              
              orderIndex++;
            }
          } else {
            // 尝试通过problem_number查询
            const [problemNumberResult] = await pool.query(
              'SELECT problem_number FROM problem_pool WHERE id = ?',
              [data.problem_pool_id]
            );
            
            if (problemNumberResult.length > 0) {
              const poolProblemNumber = problemNumberResult[0].problem_number;
              
              const [poolTestCasesByNumber] = await pool.query(
                'SELECT * FROM problem_pool_test_cases WHERE problem_number = ?',
                [poolProblemNumber]
              );
              
              if (poolTestCasesByNumber.length > 0) {
                // 使用通过problem_number查询到的测试用例
                console.log(`通过problem_number获取到测试用例，数量: ${poolTestCasesByNumber.length}`);
                let orderIndex = 1;
                for (const testCase of poolTestCasesByNumber) {
                  // 使用测试用例原有的order_num或者使用自增序号
                  const orderNum = (testCase.order_num && testCase.order_num > 0) ? testCase.order_num : orderIndex;
                  
                  console.log(`添加通过problem_number获取的测试用例 ${orderIndex}/${poolTestCasesByNumber.length}, order_num=${orderNum}, is_example=${testCase.is_example ? 1 : 0}`);
                  
                  await pool.query(
                    'INSERT INTO problem_test_cases (problem_id, problem_number, input, output, is_example, order_num) VALUES (?, ?, ?, ?, ?, ?)',
                    [newProblemId, formattedNumber, testCase.input, testCase.output, testCase.is_example, orderNum]
                  );
                  
                  orderIndex++;
                }
              } else {
                // 创建默认测试用例
                console.log(`未找到测试用例，添加默认测试用例`);
                await pool.query(
                  'INSERT INTO problem_test_cases (problem_id, problem_number, input, output, is_example, order_num) VALUES (?, ?, ?, ?, ?, ?)',
                  [newProblemId, formattedNumber, '// 示例输入', '// 示例输出', 1, 1]
                );
              }
            } else {
              // 创建默认测试用例
              console.log(`未找到题目池问题编号，添加默认测试用例`);
              await pool.query(
                'INSERT INTO problem_test_cases (problem_id, problem_number, input, output, is_example, order_num) VALUES (?, ?, ?, ?, ?, ?)',
                [newProblemId, formattedNumber, '// 示例输入', '// 示例输出', 1, 1]
              );
            }
          }
        } else {
          // 创建默认测试用例
          console.log(`未找到题目池ID，添加默认测试用例`);
          await pool.query(
            'INSERT INTO problem_test_cases (problem_id, problem_number, input, output, is_example, order_num) VALUES (?, ?, ?, ?, ?, ?)',
            [newProblemId, formattedNumber, '// 示例输入', '// 示例输出', 1, 1]
          );
        }
      }
      
      // 3. 插入解决方案
      if (data.solution) {
        const [solutionResult] = await pool.query(
          'INSERT INTO solution_main (problem_id, solution_approach, time_complexity, space_complexity) VALUES (?, ?, ?, ?)',
          [newProblemId, data.solution.solution_approach, data.solution.time_complexity, data.solution.space_complexity]
        );
        
        const newSolutionId = solutionResult.insertId;
        
        // 4. 插入解决方案代码
        if (data.solution.codes && data.solution.codes.length > 0) {
          for (const code of data.solution.codes) {
            await pool.query(
              'INSERT INTO solution_code (solution_id, language_id, standard_solution) VALUES (?, ?, ?)',
              [newSolutionId, code.language_id, code.standard_solution]
            );
          }
        }
      }
      
      // 5. 更新题目池中的引用计数
      if (data.problem_pool_id) {
        console.log(`更新题目池ID ${data.problem_pool_id} 的引用计数`);
        await pool.query(
          'UPDATE problem_pool SET reference_count = reference_count + 1 WHERE id = ?',
          [data.problem_pool_id]
        );
      }
      
      // 提交事务
      await pool.query('COMMIT');
      
      res.json({
        success: true,
        data: {
          message: '题目已成功导入到题库',
          new_problem_id: newProblemId,
          problem_number: formattedNumber
        }
      });
    } catch (error) {
      // 回滚事务
      await pool.query('ROLLBACK');
      throw error;
    }
  } catch (error) {
    console.error('导入题目失败:', error);
    
    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: error.message || '导入题目失败'
      }
    });
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
  importProblem,
  importProblemDirect
}; 