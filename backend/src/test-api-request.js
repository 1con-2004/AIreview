const aiController = require('./controllers/ai-analysis.controller');

// 模拟Express请求和响应对象
const mockRequest = (body = {}) => ({
  body
});

const mockResponse = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};

// 测试代码分析接口
async function testCodeAnalysis() {
  console.log('====== 测试代码分析API ======');
  
  // 测试简单代码样本
  const testCode = `
function sum(a, b) {
  return a + b;
}

console.log(sum(5, 10));
`;

  // 测试reasoner模型
  console.log('测试deepseek-reasoner模型...');
  
  const req = mockRequest({
    model: 'deepseek-reasoner',
    code_content: testCode
  });
  
  const res = mockResponse();
  
  try {
    await aiController.codeAnalysis(req, res);
    
    // 输出响应参数
    console.log('Status Code:', res.status.mock.calls[0][0]);
    console.log('Response:', JSON.stringify(res.json.mock.calls[0][0], null, 2));
    
    console.log('====== 测试完成 ======');
  } catch (error) {
    console.error('测试失败:', error);
  }
}

// 测试获取模型接口
async function testGetModels() {
  console.log('====== 测试获取模型API ======');
  
  const req = mockRequest();
  const res = mockResponse();
  
  try {
    await aiController.getModels(req, res);
    
    console.log('Status Code:', res.status.mock.calls[0][0]);
    console.log('Response:', JSON.stringify(res.json.mock.calls[0][0], null, 2));
    
    console.log('====== 测试完成 ======');
  } catch (error) {
    console.error('测试失败:', error);
  }
}

// 执行测试
async function runTests() {
  await testGetModels();
  await testCodeAnalysis();
}

// 模拟Jest函数
const jest = {
  fn: () => {
    const mockFn = (...args) => {
      mockFn.mock.calls.push(args);
      return mockFn.mockReturnValue;
    };
    mockFn.mock = { calls: [] };
    mockFn.mockReturnValue = mockFn;
    return mockFn;
  }
};

runTests(); 