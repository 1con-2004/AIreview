const pool = require('../db');

/**
 * 获取题目池中的题目总数
 * @returns {Promise<number>} 题目总数
 */
async function getTotalProblems() {
  const [rows] = await pool.query('SELECT COUNT(*) AS total FROM problem_pool');
  return rows[0].total;
}

/**
 * 获取题目池中的分类总数
 * @returns {Promise<number>} 分类总数
 */
async function getTotalCategories() {
  const [rows] = await pool.query('SELECT COUNT(*) AS total FROM problem_pool_categories');
  return rows[0].total;
}

/**
 * 获取题目池中各难度题目的数量
 * @returns {Promise<Object>} 各难度题目数量 { '简单': 数量, '中等': 数量, '困难': 数量 }
 */
async function getDifficultyDistribution() {
  const [rows] = await pool.query(
    'SELECT difficulty, COUNT(*) AS count FROM problem_pool GROUP BY difficulty'
  );
  
  const distribution = { '简单': 0, '中等': 0, '困难': 0 };
  rows.forEach(row => {
    distribution[row.difficulty] = row.count;
  });
  
  return distribution;
}

/**
 * 获取题目池列表（带分页和筛选）
 * @param {Object} options 查询选项
 * @param {number} options.page 页码
 * @param {number} options.limit 每页条数
 * @param {string} options.query 搜索关键词
 * @param {string} options.difficulty 难度筛选
 * @param {string} options.tags 标签筛选
 * @returns {Promise<Object>} 查询结果
 */
async function getProblemList(options) {
  const { page = 1, limit = 10, query = '', difficulty = '', tags = '' } = options;
  const offset = (page - 1) * limit;
  
  let sql = `
    SELECT p.*, c.name AS category_name, 
           u.user_id as creator_id, u.display_name, u.avatar_url,
           u.nickname, us.username
    FROM problem_pool p
    LEFT JOIN problem_pool_categories c ON p.category = c.id
    LEFT JOIN user_profile u ON p.create_user_id = u.user_id
    LEFT JOIN users us ON u.user_id = us.id
    WHERE 1=1
  `;
  
  const params = [];
  
  // 添加查询条件
  if (query) {
    sql += ` AND (p.title LIKE ? OR p.problem_number LIKE ?)`;
    params.push(`%${query}%`, `%${query}%`);
  }
  
  // 添加难度筛选
  if (difficulty) {
    sql += ` AND p.difficulty = ?`;
    params.push(difficulty);
  }
  
  // 添加标签筛选
  if (tags) {
    const tagList = tags.split(',').map(tag => tag.trim());
    const tagPlaceholders = tagList.map(() => `p.tags LIKE ?`).join(' OR ');
    sql += ` AND (${tagPlaceholders})`;
    tagList.forEach(tag => {
      params.push(`%${tag}%`);
    });
  }
  
  // 获取总数
  const [countRows] = await pool.query(
    `SELECT COUNT(*) AS total FROM (${sql}) AS count_query`,
    params
  );
  const total = countRows[0].total;
  
  // 添加分页
  sql += ` ORDER BY p.id DESC LIMIT ? OFFSET ?`;
  params.push(parseInt(limit), offset);
  
  // 执行查询
  const [rows] = await pool.query(sql, params);
  
  // 格式化结果
  const problems = rows.map(row => {
    // 打印头像信息，以便调试
    console.log(`题目 ${row.title} - 创建者ID: ${row.creator_id}, 头像: ${row.avatar_url}`);
    
    return {
      id: row.id,
      problem_number: row.problem_number,
      title: row.title,
      difficulty: row.difficulty,
      tags: row.tags,
      category: row.category,
      category_name: row.category_name,
      source: row.source,
      creator_id: row.creator_id,
      create_user_id: row.create_user_id,
      creator: row.creator_id ? {
        id: row.creator_id,
        username: row.username || row.nickname || row.display_name || 'unknown',
        avatar: row.avatar_url
      } : null,
      reference_count: row.reference_count,
      created_at: row.created_at
    };
  });
  
  return {
    total,
    page: parseInt(page),
    limit: parseInt(limit),
    problems
  };
}

/**
 * 获取题目池分类列表
 * @returns {Promise<Array>} 分类列表
 */
async function getCategoryList() {
  const [rows] = await pool.query(
    'SELECT * FROM problem_pool_categories ORDER BY order_num'
  );
  return rows;
}

/**
 * 获取题目标签列表
 * @returns {Promise<Array>} 标签列表
 */
async function getTagList() {
  const [rows] = await pool.query(
    'SELECT tags FROM problem_pool WHERE tags IS NOT NULL AND tags != ""'
  );
  
  // 提取并去重所有标签
  const tagSet = new Set();
  rows.forEach(row => {
    if (row.tags) {
      // 先将中文逗号替换为英文逗号
      const normalizedTags = row.tags.replace(/，/g, ',');
      normalizedTags.split(',').forEach(tag => {
        tag = tag.trim();
        if (tag) {
          tagSet.add(tag);
        }
      });
    }
  });
  
  return Array.from(tagSet).sort();
}

/**
 * 获取题目详情
 * @param {number} id 题目ID
 * @returns {Promise<Object>} 题目详情
 */
async function getProblemDetail(id) {
  // 获取题目基本信息
  const [problemRows] = await pool.query(
    `SELECT p.*, c.name AS category_name
     FROM problem_pool p
     LEFT JOIN problem_pool_categories c ON p.category = c.id
     WHERE p.id = ?`,
    [id]
  );
  
  if (problemRows.length === 0) {
    throw new Error('题目不存在');
  }
  
  const problem = problemRows[0];
  
  // 获取题目测试用例
  const [testCaseRows] = await pool.query(
    `SELECT * FROM problem_pool_test_cases WHERE problem_pool_id = ? ORDER BY order_num`,
    [id]
  );
  
  // 获取题目解决方案
  const [solutionRows] = await pool.query(
    `SELECT * FROM problem_pool_solutions WHERE problem_pool_id = ?`,
    [id]
  );
  
  const solutions = [];
  
  for (const solution of solutionRows) {
    // 获取解决方案代码
    const [codeRows] = await pool.query(
      `SELECT psc.*, sl.language_name AS language_name
       FROM problem_pool_solution_code psc
       LEFT JOIN solution_languages sl ON psc.language_id = sl.id
       WHERE psc.pool_solution_id = ?`,
      [solution.id]
    );
    
    solutions.push({
      id: solution.id,
      solution_approach: solution.solution_approach,
      time_complexity: solution.time_complexity,
      space_complexity: solution.space_complexity,
      code: codeRows
    });
  }
  
  return {
    problem,
    test_cases: testCaseRows,
    solutions
  };
}

/**
 * 通过ID获取题目
 * @param {number} id 题目ID
 * @returns {Promise<Object|null>} 题目信息
 */
async function getProblemById(id) {
  const [rows] = await pool.query(
    'SELECT * FROM problem_pool WHERE id = ?',
    [id]
  );
  
  return rows.length > 0 ? rows[0] : null;
}

/**
 * 获取题目测试用例
 * @param {number} id 题目ID
 * @returns {Promise<Array>} 测试用例列表
 */
async function getProblemTestCases(id) {
  const [rows] = await pool.query(
    'SELECT * FROM problem_pool_test_cases WHERE problem_pool_id = ? ORDER BY order_num',
    [id]
  );
  
  return rows;
}

/**
 * 获取题目解决方案
 * @param {number} id 题目ID
 * @returns {Promise<Object|null>} 解决方案
 */
async function getProblemSolution(id) {
  const [rows] = await pool.query(
    'SELECT * FROM problem_pool_solutions WHERE problem_pool_id = ? LIMIT 1',
    [id]
  );
  
  return rows.length > 0 ? rows[0] : null;
}

/**
 * 获取题目解决方案代码
 * @param {number} id 题目ID
 * @returns {Promise<Array>} 解决方案代码列表
 */
async function getProblemSolutionCode(id) {
  // 首先获取解决方案ID
  const [solutionRows] = await pool.query(
    'SELECT id FROM problem_pool_solutions WHERE problem_pool_id = ? LIMIT 1',
    [id]
  );
  
  if (solutionRows.length === 0) {
    return [];
  }
  
  const solutionId = solutionRows[0].id;
  
  // 获取解决方案代码
  const [codeRows] = await pool.query(
    `SELECT psc.*, sl.language_name AS language_name
     FROM problem_pool_solution_code psc
     LEFT JOIN solution_languages sl ON psc.language_id = sl.id
     WHERE psc.pool_solution_id = ?`,
    [solutionId]
  );
  
  return codeRows;
}

/**
 * 从题目池中删除题目
 * @param {number} id 题目ID
 * @returns {Promise<boolean>} 是否删除成功
 */
async function deleteProblem(id) {
  const connection = await pool.getConnection();
  
  try {
    await connection.beginTransaction();
    
    // 删除题目相关数据
    await connection.query('DELETE FROM problem_pool_solution_code WHERE pool_solution_id IN (SELECT id FROM problem_pool_solutions WHERE problem_pool_id = ?)', [id]);
    await connection.query('DELETE FROM problem_pool_solutions WHERE problem_pool_id = ?', [id]);
    await connection.query('DELETE FROM problem_pool_test_cases WHERE problem_pool_id = ?', [id]);
    await connection.query('DELETE FROM problem_pool WHERE id = ?', [id]);
    
    await connection.commit();
    return true;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

/**
 * 将题目从题目池引用到正式题库
 * @param {number} id 题目池中的题目ID
 * @param {Object} data 修改后的题目数据
 * @returns {Promise<Object>} 引用结果
 */
async function importProblem(id, data) {
  const connection = await pool.getConnection();
  
  try {
    await connection.beginTransaction();
    
    // 获取题目池中的题目信息
    const [poolProblemRows] = await connection.query(
      'SELECT * FROM problem_pool WHERE id = ?',
      [id]
    );
    
    if (poolProblemRows.length === 0) {
      throw new Error('题目不存在');
    }
    
    const poolProblem = poolProblemRows[0];
    
    // 获取测试用例
    const [testCaseRows] = await connection.query(
      'SELECT * FROM problem_pool_test_cases WHERE problem_pool_id = ?',
      [id]
    );
    
    console.log(`题目池ID ${id} 的测试用例数量: ${testCaseRows.length}`);
    
    // 如果测试用例数量为0，尝试通过problem_number查询
    if (testCaseRows.length === 0) {
      console.log(`未找到题目池ID ${id} 的测试用例，尝试通过problem_number查询`);
      
      const [problemNumberRows] = await connection.query(
        'SELECT problem_number FROM problem_pool WHERE id = ?',
        [id]
      );
      
      if (problemNumberRows.length > 0) {
        const problemNumber = problemNumberRows[0].problem_number;
        console.log(`题目编号: ${problemNumber}`);
        
        const [altTestCaseRows] = await connection.query(
          'SELECT * FROM problem_pool_test_cases WHERE problem_number = ?',
          [problemNumber]
        );
        
        console.log(`通过problem_number ${problemNumber} 查询到的测试用例数量: ${altTestCaseRows.length}`);
        
        if (altTestCaseRows.length > 0) {
          // 使用通过problem_number查询到的测试用例
          Object.assign(testCaseRows, altTestCaseRows);
        }
      }
    }
    
    // 获取解决方案
    const [solutionRows] = await connection.query(
      'SELECT * FROM problem_pool_solutions WHERE problem_pool_id = ?',
      [id]
    );
    
    // 获取下一个题目编号
    const [maxNumRows] = await connection.query(
      'SELECT MAX(CAST(SUBSTRING(problem_number, 2) AS UNSIGNED)) AS max_num FROM problems'
    );
    
    const nextNumber = maxNumRows[0].max_num ? maxNumRows[0].max_num + 1 : 1;
    const problemNumber = `P${String(nextNumber).padStart(3, '0')}`;
    
    // 创建新题目
    const [insertResult] = await connection.query(
      `INSERT INTO problems (
        problem_number, title, difficulty, tags, description,
        time_limit, memory_limit, total_submissions, acceptance_rate, accepted_submissions
      ) VALUES (?, ?, ?, ?, ?, ?, ?, 0, 0, 0)`,
      [
        problemNumber,
        data.problem.title || poolProblem.title,
        data.problem.difficulty || poolProblem.difficulty,
        data.problem.tags || poolProblem.tags,
        data.problem.description || poolProblem.description,
        data.problem.time_limit || poolProblem.time_limit,
        data.problem.memory_limit || poolProblem.memory_limit
      ]
    );
    
    const newProblemId = insertResult.insertId;
    
    // 处理标签与分类的关联
    const tags = data.problem.tags || poolProblem.tags;
    if (tags && tags.trim()) {
      console.log(`处理题目ID ${newProblemId} 的标签 "${tags}" 与分类关联`);
      
      // 获取所有分类
      const [categories] = await connection.query('SELECT id, name FROM problem_categories');
      const categoryMap = {};
      categories.forEach(cat => {
        categoryMap[cat.name.toLowerCase()] = cat.id;
      });

      // 处理标签
      const tagList = tags.replace(/，/g, ',').split(',').map(tag => tag.trim()).filter(tag => tag);
      
      // 为每个标签创建关联
      for (const tag of tagList) {
        let categoryId = categoryMap[tag.toLowerCase()];
        
        // 如果标签不存在，则创建新标签
        if (!categoryId) {
          console.log(`未找到标签 "${tag}"，将自动创建新标签`);
          
          // 创建新标签
          const [insertResult] = await connection.query(
            'INSERT INTO problem_categories (name, description, level, order_num) VALUES (?, ?, ?, ?)',
            [tag, '待修改', 1, 0]
          );
          
          categoryId = insertResult.insertId;
          console.log(`成功创建新标签 "${tag}"，分类ID: ${categoryId}`);
          
          // 更新本地缓存
          categoryMap[tag.toLowerCase()] = categoryId;
        }
        
        // 创建题目与标签的关联
        await connection.query(
          'INSERT INTO problem_category_relations (problem_id, category_id) VALUES (?, ?)',
          [newProblemId, categoryId]
        );
        console.log(`为题目 ${newProblemId} 添加标签 ${tag}，分类ID: ${categoryId}`);
      }
    }
    
    // 添加测试用例
    if (data.test_cases && data.test_cases.length > 0) {
      // 使用提交的测试用例
      console.log(`使用提交的测试用例，数量: ${data.test_cases.length}`);
      for (const testCase of data.test_cases) {
        await connection.query(
          `INSERT INTO problem_test_cases (
            problem_id, problem_number, input, output, is_example, order_num
          ) VALUES (?, ?, ?, ?, ?, ?)`,
          [
            newProblemId,
            problemNumber,
            testCase.input,
            testCase.output,
            testCase.is_example || false,
            testCase.order_num || 0
          ]
        );
      }
    } else if (testCaseRows.length > 0) {
      // 使用原题目池的测试用例
      console.log(`使用原题目池的测试用例，数量: ${testCaseRows.length}`);
      for (const testCase of testCaseRows) {
        await connection.query(
          `INSERT INTO problem_test_cases (
            problem_id, problem_number, input, output, is_example, order_num
          ) VALUES (?, ?, ?, ?, ?, ?)`,
          [
            newProblemId,
            problemNumber,
            testCase.input,
            testCase.output,
            testCase.is_example,
            testCase.order_num
          ]
        );
      }
    } else {
      // 没有测试用例，添加默认测试用例
      console.log(`未找到测试用例，添加默认测试用例`);
      await connection.query(
        `INSERT INTO problem_test_cases (
          problem_id, problem_number, input, output, is_example, order_num
        ) VALUES (?, ?, ?, ?, ?, ?)`,
        [
          newProblemId,
          problemNumber,
          '// 示例输入',
          '// 示例输出',
          1,
          1
        ]
      );
      
      // 记录警告
      console.warn(`警告：题目 ${problemNumber} (ID: ${newProblemId}) 没有测试用例，已添加默认测试用例。请管理员补充真实测试用例。`);
    }
    
    // 添加解决方案
    let solutionId = null;
    if (data.solutions) {
      // 使用提交的解决方案
      const [solutionResult] = await connection.query(
        `INSERT INTO solution_main (
          problem_id, solution_approach, time_complexity, space_complexity
        ) VALUES (?, ?, ?, ?)`,
        [
          newProblemId,
          data.solutions.solution_approach,
          data.solutions.time_complexity,
          data.solutions.space_complexity
        ]
      );
      
      solutionId = solutionResult.insertId;
      
      // 添加解决方案代码
      if (data.solutions.code && data.solutions.code.length > 0) {
        for (const code of data.solutions.code) {
          await connection.query(
            `INSERT INTO solution_code (
              solution_id, language_id, standard_solution
            ) VALUES (?, ?, ?)`,
            [
              solutionId,
              code.language_id,
              code.standard_solution
            ]
          );
        }
      }
    } else if (solutionRows.length > 0) {
      // 使用原题目池的解决方案
      const poolSolution = solutionRows[0];
      
      const [solutionResult] = await connection.query(
        `INSERT INTO solution_main (
          problem_id, solution_approach, time_complexity, space_complexity
        ) VALUES (?, ?, ?, ?)`,
        [
          newProblemId,
          poolSolution.solution_approach,
          poolSolution.time_complexity,
          poolSolution.space_complexity
        ]
      );
      
      solutionId = solutionResult.insertId;
      
      // 获取解决方案代码
      const [codeRows] = await connection.query(
        'SELECT * FROM problem_pool_solution_code WHERE pool_solution_id = ?',
        [poolSolution.id]
      );
      
      // 添加解决方案代码
      for (const code of codeRows) {
        await connection.query(
          `INSERT INTO solution_code (
            solution_id, language_id, standard_solution
          ) VALUES (?, ?, ?)`,
          [
            solutionId,
            code.language_id,
            code.standard_solution
          ]
        );
      }
    }
    
    // 更新题目池中的引用计数
    await connection.query(
      'UPDATE problem_pool SET reference_count = reference_count + 1 WHERE id = ?',
      [id]
    );
    
    await connection.commit();
    
    return {
      message: '题目成功引用到正式题库',
      problem_id: newProblemId,
      problem_number: problemNumber
    };
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

module.exports = {
  getTotalProblems,
  getTotalCategories,
  getDifficultyDistribution,
  getProblemList,
  getCategoryList,
  getTagList,
  getProblemDetail,
  getProblemById,
  getProblemTestCases,
  getProblemSolution,
  getProblemSolutionCode,
  deleteProblem,
  importProblem
}; 