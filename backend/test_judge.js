const { Executor } = require('./src/services/judge/executor');

async function testJudge() {
  // 测试Python代码
  const pythonCode = `
a, b = map(int, input().split())
print(a + b)
  `.trim();

  const testCases = [
    {
      input: '2 3',
      output: '5',
      is_example: true
    }
  ];

  console.log('开始测试判题系统...');
  console.log('测试代码:', pythonCode);
  console.log('测试用例:', testCases);

  const executor = new Executor(pythonCode, 'python', testCases, {
    timeLimit: 1000,
    memoryLimit: 256
  });

  try {
    console.log('执行判题...');
    const result = await executor.execute();
    console.log('判题结果:', result);
  } catch (error) {
    console.error('测试失败:', error);
  }
}

testJudge().catch(console.error); 