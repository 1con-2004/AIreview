const db = require('../db');

/**
 * 获取题目的所有测试用例
 * @param {number|string} problemId 题目ID或题目编号
 * @returns {Promise<Array>} 测试用例数组
 */
async function getAllTestCases(problemId) {
    try {
        // 判断传入的是ID还是题目编号
        if (isNaN(problemId) || problemId.toString().length === 4) {
            // 可能是题目编号
            const sql = 'SELECT * FROM problem_test_cases WHERE problem_number = ? ORDER BY order_num';
            const [testCases] = await db.query(sql, [problemId]);
            if (testCases && testCases.length > 0) {
                return testCases;
            }
        }

        // 尝试通过problem_id查询
        const sql = 'SELECT * FROM problem_test_cases WHERE problem_id = ? ORDER BY order_num';
        const [testCases] = await db.query(sql, [problemId]);
        return testCases;
    } catch (error) {
        console.error('Error getting test cases:', error);
        throw error;
    }
}

/**
 * 获取题目的显示样例
 * @param {number} problemId 题目ID
 * @returns {Promise<Array>} 显示样例数组
 */
async function getExampleTestCases(problemId) {
    try {
        // 判断传入的是ID还是题目编号
        if (isNaN(problemId) || problemId.toString().length === 4) {
            // 可能是题目编号
            const sql = 'SELECT * FROM problem_test_cases WHERE problem_number = ? AND CAST(is_example AS UNSIGNED) = 1 ORDER BY order_num';
            const [testCases] = await db.query(sql, [problemId]);
            if (testCases && testCases.length > 0) {
                return testCases;
            }
        }

        // 尝试通过problem_id查询
        const sql = 'SELECT * FROM problem_test_cases WHERE problem_id = ? AND CAST(is_example AS UNSIGNED) = 1 ORDER BY order_num';
        const [testCases] = await db.query(sql, [problemId]);
        return testCases;
    } catch (error) {
        console.error('Error getting example test cases:', error);
        throw error;
    }
}

/**
 * 添加测试用例
 * @param {Object} testCase 测试用例对象
 * @returns {Promise<Object>} 创建的测试用例
 */
async function addTestCase(testCase) {
    try {
        // 查询题目信息，获取 problem_number
        let problemNumber = testCase.problem_number;
        if (!problemNumber && testCase.problem_id) {
            const [problem] = await db.query('SELECT problem_number FROM problems WHERE id = ?', [testCase.problem_id]);
            if (problem && problem.length > 0) {
                problemNumber = problem[0].problem_number;
            }
        }

        const sql = 'INSERT INTO problem_test_cases (problem_id, problem_number, input, output, is_example, order_num) VALUES (?, ?, ?, ?, ?, ?)';
        const [result] = await db.query(sql, [
            testCase.problem_id,
            problemNumber,
            testCase.input,
            testCase.output,
            testCase.is_example || 0,
            testCase.order_num || 0
        ]);
        return { id: result.insertId, ...testCase, problem_number: problemNumber };
    } catch (error) {
        console.error('Error adding test case:', error);
        throw error;
    }
}

/**
 * 更新测试用例
 * @param {number} id 测试用例ID
 * @param {Object} testCase 测试用例对象
 * @returns {Promise<Object>} 更新后的测试用例
 */
async function updateTestCase(id, testCase) {
    try {
        const sql = 'UPDATE problem_test_cases SET ? WHERE id = ?';
        await db.query(sql, [testCase, id]);
        return { id, ...testCase };
    } catch (error) {
        console.error('Error updating test case:', error);
        throw error;
    }
}

/**
 * 删除测试用例
 * @param {number} id 测试用例ID
 * @returns {Promise<boolean>} 是否删除成功
 */
async function deleteTestCase(id) {
    try {
        const sql = 'DELETE FROM problem_test_cases WHERE id = ?';
        const [result] = await db.query(sql, [id]);
        return result.affectedRows > 0;
    } catch (error) {
        console.error('Error deleting test case:', error);
        throw error;
    }
}

module.exports = {
    getAllTestCases,
    getExampleTestCases,
    addTestCase,
    updateTestCase,
    deleteTestCase
}; 