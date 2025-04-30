<!-- 埋点测试页面 -->
<template>
  <div class="analytics-test">
    <nav-bar></nav-bar>
    <div class="test-content">
      <h1>埋点功能测试页面</h1>
      
      <div class="test-section">
        <div class="section-header">
          <h2>题目详情页埋点测试</h2>
          <div class="action-buttons">
            <button @click="runProblemDetailTest" class="test-btn">
              运行测试
            </button>
            <button @click="clearEvents" class="clear-btn">
              清除埋点数据
            </button>
          </div>
        </div>
        
        <div v-if="testResults.length > 0" class="test-results">
          <h3>测试结果 - 共 {{ testResults.length }} 条埋点数据</h3>
          
          <div class="result-summary">
            <div class="stat-item">
              <div class="stat-label">页面访问</div>
              <div class="stat-value">{{ countByType('page_view') }}</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">点击事件</div>
              <div class="stat-value">{{ countByType('click') }}</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">筛选事件</div>
              <div class="stat-value">{{ countByType('filter') }}</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">分页事件</div>
              <div class="stat-value">{{ countByType('pagination') }}</div>
            </div>
          </div>
          
          <div class="result-list">
            <div v-for="(event, index) in testResults" :key="index" class="event-card"
                :class="{ 'page-view': event.type === 'page_view', 
                          'click': event.type === 'click',
                          'filter': event.type === 'filter',
                          'pagination': event.type === 'pagination' }">
              <div class="event-header">
                <div class="event-type">{{ getEventTypeText(event) }}</div>
                <div class="event-time">{{ formatTime(event.timestamp) }}</div>
              </div>
              <div class="event-details">
                <pre>{{ JSON.stringify(event, null, 2) }}</pre>
              </div>
            </div>
          </div>
        </div>
        
        <div v-else class="no-results">
          <p>尚未运行测试或无测试结果</p>
        </div>
      </div>
      
      <div class="test-section">
        <div class="section-header">
          <h2>直接访问测试</h2>
          <div class="action-buttons">
            <router-link to="/problems/detail/1001" class="nav-link">
              访问题目详情页
            </router-link>
            <router-link to="/debug/analytics" class="nav-link view-link">
              查看埋点数据
            </router-link>
          </div>
        </div>
        <div class="direct-test-guide">
          <p>1. 点击"访问题目详情页"前往真实的题目页面</p>
          <p>2. 在题目页面进行各种操作：切换标签、运行代码、提交代码等</p>
          <p>3. 操作完成后点击"查看埋点数据"检查收集的数据</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'
import { testProblemDetailAnalytics } from './analytics-test.js'
import analytics from '@/utils/analytics'

export default {
  name: 'AnalyticsTest',
  components: {
    NavBar
  },
  data() {
    return {
      testResults: []
    }
  },
  methods: {
    runProblemDetailTest() {
      // 运行测试并获取结果
      this.testResults = testProblemDetailAnalytics()
      console.log('测试完成，收集了', this.testResults.length, '条埋点数据')
    },
    clearEvents() {
      localStorage.removeItem('analytics_events')
      this.testResults = []
      console.log('已清除所有埋点数据')
    },
    countByType(type) {
      return this.testResults.filter(event => event.type === type).length
    },
    getEventTypeText(event) {
      const typeMap = {
        'page_view': '页面访问',
        'click': '点击事件',
        'filter': '筛选事件',
        'pagination': '分页事件'
      }
      return typeMap[event.type] || event.type
    },
    formatTime(timestamp) {
      if (!timestamp) return 'Unknown'
      
      const date = new Date(timestamp)
      return date.toLocaleString('zh-CN', {
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      })
    }
  },
  mounted() {
    // 确保埋点已初始化
    if (!analytics.initialized) {
      analytics.init()
    }
    
    // 记录页面访问
    analytics.trackPageView('analytics_test_page')
  }
}
</script>

<style scoped>
.analytics-test {
  min-height: 100vh;
  background-color: #0d1117;
  color: #e6edf3;
}

.test-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
}

h1 {
  font-size: 32px;
  margin-bottom: 32px;
  color: #4ecdc4;
}

h2 {
  font-size: 24px;
  margin: 0;
  color: #e6edf3;
}

h3 {
  font-size: 18px;
  margin: 24px 0 16px;
  color: #4ecdc4;
}

.test-section {
  background-color: #1e293b;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 32px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.action-buttons {
  display: flex;
  gap: 12px;
}

button, .nav-link {
  padding: 10px 16px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  border: none;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
}

.test-btn {
  background-color: #4ecdc4;
  color: white;
}

.test-btn:hover {
  background-color: #3db1a8;
}

.clear-btn {
  background-color: #f43f5e;
  color: white;
}

.clear-btn:hover {
  background-color: #e11d48;
}

.nav-link {
  background-color: #3b82f6;
  color: white;
  text-decoration: none;
}

.nav-link:hover {
  background-color: #2563eb;
}

.view-link {
  background-color: #8b5cf6;
}

.view-link:hover {
  background-color: #7c3aed;
}

.no-results {
  padding: 32px;
  text-align: center;
  background-color: #1e1e2e;
  border-radius: 8px;
  color: #94a3b8;
}

.result-summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 16px;
  margin-bottom: 24px;
}

.stat-item {
  background-color: #1e1e2e;
  padding: 16px;
  border-radius: 8px;
  text-align: center;
}

.stat-label {
  font-size: 14px;
  color: #94a3b8;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #ffffff;
}

.result-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.event-card {
  background-color: #1e1e2e;
  border-radius: 8px;
  overflow: hidden;
  border-left: 4px solid #4b5563;
}

.event-card.page-view {
  border-left-color: #3b82f6;
}

.event-card.click {
  border-left-color: #10b981;
}

.event-card.filter {
  border-left-color: #f59e0b;
}

.event-card.pagination {
  border-left-color: #8b5cf6;
}

.event-header {
  padding: 12px 16px;
  background-color: rgba(0, 0, 0, 0.2);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.event-type {
  font-weight: 600;
  color: #e6edf3;
}

.event-time {
  font-size: 14px;
  color: #94a3b8;
}

.event-details {
  padding: 16px;
  font-family: 'Menlo', monospace;
  font-size: 14px;
  overflow-x: auto;
}

.event-details pre {
  margin: 0;
  white-space: pre-wrap;
  word-break: break-all;
}

.direct-test-guide {
  padding: 16px;
  background-color: rgba(78, 205, 196, 0.1);
  border-radius: 8px;
  margin-top: 16px;
}

.direct-test-guide p {
  margin: 8px 0;
  line-height: 1.5;
  color: #e6edf3;
}
</style> 