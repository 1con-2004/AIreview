const db = require('../db');

/**
 * 获取题目的所有测试用例
 * @param {number} problemId 题目ID
 * @returns {Promise<Array>} 测试用例数组
 */
async function getAllTestCases(problemId) {
    try {
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
        const sql = 'SELECT * FROM problem_test_cases WHERE problem_id = ? AND is_example = 1 ORDER BY order_num';
        const [examples] = await db.query(sql, [problemId]);
        return examples;
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
        const sql = 'INSERT INTO problem_test_cases (problem_id, input, output, is_example, order_num) VALUES (?, ?, ?, ?, ?)';
        const [result] = await db.query(sql, [
            testCase.problem_id,
            testCase.input,
            testCase.output,
            testCase.is_example || 0,
            testCase.order_num || 0
        ]);
        return { id: result.insertId, ...testCase };
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