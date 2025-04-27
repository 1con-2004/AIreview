const deepseekService = require('./services/ai/deepseek.service');

// 简单的测试代码样本
const testCode = `
function sum(a, b) {
  return a + b;
}

console.log(sum(5, 10));
`;

// 测试函数
async function testDeepseekReasoner() {
  console.log('====== 开始测试 DeepSeek-Reasoner 模型 ======');
  console.log('测试时间:', new Date().toISOString());
  
  try {
    // 先测试模型列表
    console.log('正在获取可用模型列表...');
    try {
      const models = await deepseekService.getAvailableModels();
      console.log('可用模型:', JSON.stringify(models, null, 2));
    } catch (error) {
      console.error('获取模型列表失败:', error.message);
    }
    
    // 测试账户余额
    console.log('正在查询账户余额...');
    try {
      const balance = await deepseekService.queryBalance();
      console.log('账户余额:', JSON.stringify(balance, null, 2));
    } catch (error) {
      console.error('查询余额失败:', error.message);
    }
    
    // 测试代码分析
    console.log('正在分析代码...');
    const result = await deepseekService.analyzeCode(testCode, 'deepseek-reasoner');
    
    console.log('====== 分析结果 ======');
    console.log('模型:', result.model);
    console.log('内容:', result.content);
    console.log('推理内容:', result.reasoning_content);
    console.log('用量:', result.usage);
    console.log('====== 测试完成 ======');
  } catch (error) {
    console.error('====== 测试失败 ======');
    console.error('错误信息:', error.message);
    console.error('====== 测试结束 ======');
  }
}

// 执行测试
testDeepseekReasoner(); 