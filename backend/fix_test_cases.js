const mysql = require('mysql2/promise');
const { dbConfig } = require('./src/config/db');

async function fixTestCases() {
  let connection;
  try {
    // 连接数据库
    connection = await mysql.createConnection(dbConfig);
    
    // 获取题目ID为30的信息（最长连续序列）
    const [problems] = await connection.execute(
      'SELECT * FROM problems WHERE id = 30'
    );
    
    if (problems.length === 0) {
      console.log('没有找到ID为30的题目');
      return;
    }
    
    console.log('找到题目:', problems[0].title);
    
    // 检查现有测试用例
    const [existingTestCases] = await connection.execute(
      'SELECT * FROM problem_test_cases WHERE problem_id = 30'
    );
    
    console.log('现有测试用例数量:', existingTestCases.length);
    
    // 定义正确的测试用例
    const correctTestCases = [
      {
        input: '6\n100 4 200 1 3 2',
        output: '4',
        is_example: 1,
        order_num: 1
      },
      {
        input: '0',
        output: '0',
        is_example: 0,
        order_num: 2
      },
      {
        input: '1\n5',
        output: '1',
        is_example: 0,
        order_num: 3
      },
      {
        input: '8\n1 3 5 2 4 7 9 6',
        output: '9',
        is_example: 0,
        order_num: 4
      }
    ];
    
    // 开始事务
    await connection.beginTransaction();
    
    try {
      // 删除现有测试用例
      await connection.execute(
        'DELETE FROM problem_test_cases WHERE problem_id = 30'
      );
      console.log('删除了现有测试用例');
      
      // 插入新的测试用例
      for (const tc of correctTestCases) {
        await connection.execute(
          'INSERT INTO problem_test_cases (problem_id, problem_number, input, output, is_example, order_num) VALUES (?, ?, ?, ?, ?, ?)',
          [30, problems[0].problem_number, tc.input, tc.output, tc.is_example, tc.order_num]
        );
      }
      
      console.log('添加了新的测试用例');
      
      // 提交事务
      await connection.commit();
      console.log('测试用例修复成功');
    } catch (error) {
      // 发生错误时回滚事务
      await connection.rollback();
      console.error('修复测试用例失败，事务已回滚:', error);
    }
  } catch (error) {
    console.error('执行脚本时出错:', error);
  } finally {
    // 关闭数据库连接
    if (connection) {
      await connection.end();
      console.log('数据库连接已关闭');
    }
  }
}

// 执行修复函数
fixTestCases()
  .then(() => {
    console.log('脚本执行完毕');
    process.exit(0);
  })
  .catch((error) => {
    console.error('脚本执行失败:', error);
    process.exit(1);
  }); 