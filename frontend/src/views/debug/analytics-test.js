// 埋点测试脚本
import analytics from '@/utils/analytics'

// 启用埋点调试模式
analytics.debugMode = true

// 模拟题目详情页面的埋点测试
const testProblemDetailAnalytics = () => {
  console.log('=== 开始测试题目详情页埋点 ===')
  
  // 1. 模拟页面访问
  analytics.trackPageView('problem_detail', {
    problem_id: '1234',
    referrer: 'test'
  })
  
  // 2. 模拟标签切换
  analytics.trackClick('tab_switch', 'tab_solution', {
    problem_id: '1234',
    tab_name: 'solution'
  })
  
  // 3. 模拟复制样例
  analytics.trackClick('copy_example_input', '', {
    problem_id: '1234'
  })
  
  // 4. 模拟运行代码
  analytics.trackClick('run_code', '', {
    problem_id: '1234',
    language: 'Python',
    code_length: 500
  })
  
  // 5. 模拟提交代码
  analytics.trackClick('submit_code', '', {
    problem_id: '1234',
    language: 'Python',
    code_length: 500
  })
  
  // 6. 模拟AI分析
  analytics.trackClick('ai_analyze', 'deepseek-reasoner', {
    problem_id: '1234',
    language: 'Python',
    code_length: 500,
    ai_model: 'deepseek-reasoner'
  })
  
  // 7. 模拟筛选操作
  analytics.trackFilter('submission_filter', '{"status":"Accepted","language":"Python"}', {
    problem_id: '1234',
    status: 'Accepted',
    language: 'Python'
  })
  
  // 8. 模拟分页操作
  analytics.trackPagination('submissions', 2, {
    problem_id: '1234',
    total_pages: 5
  })
  
  console.log('=== 题目详情页埋点测试完成 ===')
  
  // 返回存储的埋点数据
  const eventsData = localStorage.getItem('analytics_events')
  const events = JSON.parse(eventsData || '[]')
  return events
}

export { testProblemDetailAnalytics } 