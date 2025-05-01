<!-- 埋点调试页面 -->
<template>
  <div class="analytics-debug">
    <nav-bar></nav-bar>
    <div class="debug-content">
      <h1>埋点数据调试页面</h1>
      <div class="control-panel">
        <div class="status-card">
          <div class="status-title">埋点系统状态</div>
          <div class="status-value" :class="analytics.enabled ? 'active' : 'inactive'">
            {{ analytics.enabled ? '已启用' : '已禁用' }}
          </div>
          <div class="status-actions">
            <button @click="toggleAnalytics" :class="analytics.enabled ? 'disable-btn' : 'enable-btn'">
              {{ analytics.enabled ? '禁用埋点' : '启用埋点' }}
            </button>
            <button @click="toggleDebugMode" :class="analytics.debugMode ? 'disable-btn' : 'enable-btn'">
              {{ analytics.debugMode ? '关闭调试' : '开启调试' }}
            </button>
          </div>
        </div>
        <div class="action-card">
          <div class="action-title">埋点操作</div>
          <div class="action-buttons">
            <button @click="clearEvents" class="clear-btn">清除所有埋点数据</button>
            <button @click="exportEvents" class="export-btn">导出埋点数据</button>
            <button @click="showViewer = true" class="view-btn">查看埋点数据</button>
          </div>
        </div>
        <div class="stats-card">
          <div class="stats-title">数据统计</div>
          <div class="stats-values">
            <div class="stat-item">
              <div class="stat-label">总事件数</div>
              <div class="stat-number">{{ events.length }}</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">页面访问</div>
              <div class="stat-number">{{ countByType('page_view') }}</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">点击事件</div>
              <div class="stat-number">{{ countByType('click') }}</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">筛选事件</div>
              <div class="stat-number">{{ countByType('filter') }}</div>
            </div>
          </div>
        </div>
      </div>
      <div class="test-panel">
        <h2>测试埋点</h2>
        <div class="test-form">
          <div class="form-group">
            <label>事件类型</label>
            <select v-model="testEvent.type">
              <option value="page_view">页面访问 (page_view)</option>
              <option value="click">点击事件 (click)</option>
              <option value="filter">筛选事件 (filter)</option>
              <option value="pagination">分页事件 (pagination)</option>
              <option value="custom">自定义事件</option>
            </select>
          </div>
          <!-- 页面访问事件 -->
          <template v-if="testEvent.type === 'page_view'">
            <div class="form-group">
              <label>页面名称</label>
              <input type="text" v-model="testEvent.pageName" placeholder="例如: home_page">
            </div>
            <div class="form-group">
              <label>页面参数 (JSON)</label>
              <textarea v-model="testEvent.pageParams" placeholder='例如: {"referrer": "https://example.com"}'></textarea>
            </div>
          </template>
          <!-- 点击事件 -->
          <template v-else-if="testEvent.type === 'click'">
            <div class="form-group">
              <label>元素名称</label>
              <input type="text" v-model="testEvent.elementName" placeholder="例如: submit_button">
            </div>
            <div class="form-group">
              <label>元素ID</label>
              <input type="text" v-model="testEvent.elementId" placeholder="例如: btn-123">
            </div>
            <div class="form-group">
              <label>额外数据 (JSON)</label>
              <textarea v-model="testEvent.extraData" placeholder='例如: {"location": "header", "action": "submit"}'></textarea>
            </div>
          </template>
          <!-- 筛选事件 -->
          <template v-else-if="testEvent.type === 'filter'">
            <div class="form-group">
              <label>筛选名称</label>
              <input type="text" v-model="testEvent.filterName" placeholder="例如: difficulty">
            </div>
            <div class="form-group">
              <label>筛选值</label>
              <input type="text" v-model="testEvent.filterValue" placeholder="例如: 简单">
            </div>
            <div class="form-group">
              <label>额外数据 (JSON)</label>
              <textarea v-model="testEvent.extraData" placeholder='例如: {"previous": "困难", "component": "search"}'></textarea>
            </div>
          </template>
          <!-- 分页事件 -->
          <template v-else-if="testEvent.type === 'pagination'">
            <div class="form-group">
              <label>分页类型</label>
              <input type="text" v-model="testEvent.pageType" placeholder="例如: problems">
            </div>
            <div class="form-group">
              <label>页码</label>
              <input type="number" v-model.number="testEvent.pageNumber" placeholder="例如: 2">
            </div>
            <div class="form-group">
              <label>额外数据 (JSON)</label>
              <textarea v-model="testEvent.extraData" placeholder='例如: {"previous_page": 1, "total_pages": 5}'></textarea>
            </div>
          </template>
          <!-- 自定义事件 -->
          <template v-else>
            <div class="form-group">
              <label>事件类别</label>
              <input type="text" v-model="testEvent.category" placeholder="例如: user">
            </div>
            <div class="form-group">
              <label>事件动作</label>
              <input type="text" v-model="testEvent.action" placeholder="例如: login">
            </div>
            <div class="form-group">
              <label>事件数据 (JSON)</label>
              <textarea v-model="testEvent.data" placeholder='例如: {"method": "github", "success": true}'></textarea>
            </div>
          </template>
          <div class="form-actions">
            <button @click="sendTestEvent" class="test-btn">发送测试事件</button>
            <button @click="resetTestForm" class="reset-btn">重置表单</button>
          </div>
        </div>
        <div v-if="lastSentEvent" class="last-event">
          <h3>最近发送的事件</h3>
          <pre>{{ JSON.stringify(lastSentEvent, null, 2) }}</pre>
        </div>
      </div>
      <div class="navigation-panel">
        <h2>跳转到测试页面</h2>
        <div class="navigation-links">
          <router-link to="/" class="nav-link">首页</router-link>
          <router-link to="/problems" class="nav-link">题目列表 (埋点演示)</router-link>
          <router-link to="/learning-plans" class="nav-link">学习计划</router-link>
        </div>
      </div>
    </div>
    <!-- 埋点数据查看器 -->
    <analytics-viewer v-if="showViewer" @close="showViewer = false" />
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'
import AnalyticsViewer from '@/components/AnalyticsViewer.vue'
import analytics from '@/utils/analytics'

export default {
  name: 'AnalyticsDebug',
  components: {
    NavBar,
    AnalyticsViewer
  },
  data () {
    return {
      analytics, // 引用全局埋点工具
      events: [],
      showViewer: false,
      testEvent: {
        type: 'page_view',
        pageName: '',
        pageParams: '',
        elementName: '',
        elementId: '',
        filterName: '',
        filterValue: '',
        pageType: '',
        pageNumber: 1,
        category: '',
        action: '',
        data: '',
        extraData: ''
      },
      lastSentEvent: null
    }
  },
  mounted () {
    // 记录调试页面访问
    analytics.trackPageView('analytics_debug_page')
    this.loadEvents()
  },
  methods: {
    loadEvents () {
      try {
        const eventsStr = localStorage.getItem('analytics_events')
        this.events = eventsStr ? JSON.parse(eventsStr) : []
      } catch (error) {
        console.error('加载埋点数据失败:', error)
        this.events = []
      }
    },
    clearEvents () {
      if (confirm('确定要清除所有埋点数据吗？')) {
        localStorage.removeItem('analytics_events')
        this.events = []
        this.loadEvents()
      }
    },
    toggleAnalytics () {
      analytics.enabled = !analytics.enabled
      // 记录切换状态
      if (analytics.enabled) {
        analytics.trackEvent('system', 'analytics_enabled')
      }
    },
    toggleDebugMode () {
      analytics.debugMode = !analytics.debugMode
      // 记录调试模式切换
      if (analytics.enabled) {
        analytics.trackEvent('system', 'debug_mode_changed', { enabled: analytics.debugMode })
      }
    },
    exportEvents () {
      try {
        const eventsStr = JSON.stringify(this.events, null, 2)
        const blob = new Blob([eventsStr], { type: 'application/json' })
        const url = URL.createObjectURL(blob)
        const a = document.createElement('a')
        a.href = url
        a.download = `analytics_events_${new Date().toISOString().slice(0, 10)}.json`
        document.body.appendChild(a)
        a.click()
        setTimeout(() => {
          document.body.removeChild(a)
          URL.revokeObjectURL(url)
        }, 100)
      } catch (error) {
        console.error('导出数据失败:', error)
        alert('导出数据失败: ' + error.message)
      }
    },
    sendTestEvent () {
      try {
        if (this.testEvent.type === 'page_view') {
          // 发送页面访问事件
          const pageParams = this.testEvent.pageParams ? JSON.parse(this.testEvent.pageParams) : {}
          analytics.trackPageView(this.testEvent.pageName, pageParams)
          this.lastSentEvent = {
            type: 'page_view',
            pageName: this.testEvent.pageName,
            pageParams
          }
        } else if (this.testEvent.type === 'click') {
          // 发送点击事件
          const extraData = this.testEvent.extraData ? JSON.parse(this.testEvent.extraData) : {}
          analytics.trackClick(this.testEvent.elementName, this.testEvent.elementId, extraData)
          this.lastSentEvent = {
            type: 'click',
            elementName: this.testEvent.elementName,
            elementId: this.testEvent.elementId,
            ...extraData
          }
        } else if (this.testEvent.type === 'filter') {
          // 发送筛选事件
          const extraData = this.testEvent.extraData ? JSON.parse(this.testEvent.extraData) : {}
          analytics.trackFilter(this.testEvent.filterName, this.testEvent.filterValue, extraData)
          this.lastSentEvent = {
            type: 'filter',
            filterName: this.testEvent.filterName,
            filterValue: this.testEvent.filterValue,
            ...extraData
          }
        } else if (this.testEvent.type === 'pagination') {
          // 发送分页事件
          const extraData = this.testEvent.extraData ? JSON.parse(this.testEvent.extraData) : {}
          analytics.trackPagination(this.testEvent.pageType, this.testEvent.pageNumber, extraData)
          this.lastSentEvent = {
            type: 'pagination',
            pageType: this.testEvent.pageType,
            pageNumber: this.testEvent.pageNumber,
            ...extraData
          }
        } else {
          // 发送自定义事件
          const data = this.testEvent.data ? JSON.parse(this.testEvent.data) : {}
          analytics.trackEvent(this.testEvent.category, this.testEvent.action, data)
          this.lastSentEvent = {
            category: this.testEvent.category,
            action: this.testEvent.action,
            ...data
          }
        }
        // 重新加载事件数据
        setTimeout(() => this.loadEvents(), 100)
      } catch (error) {
        console.error('发送测试事件失败:', error)
        alert('发送测试事件失败: ' + error.message)
      }
    },
    resetTestForm () {
      this.testEvent = {
        type: 'page_view',
        pageName: '',
        pageParams: '',
        elementName: '',
        elementId: '',
        filterName: '',
        filterValue: '',
        pageType: '',
        pageNumber: 1,
        category: '',
        action: '',
        data: '',
        extraData: ''
      }
      this.lastSentEvent = null
    },
    countByType (type) {
      return this.events.filter(event => event.type === type).length
    }
  }
}
</script>

<style scoped>
.analytics-debug {
  min-height: 100vh;
  background-color: #0d1117;
  color: #e2e8f0;
}

.debug-content {
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
  margin: 32px 0 16px;
  color: #4ecdc4;
}

h3 {
  font-size: 18px;
  margin: 16px 0 8px;
  color: #e2e8f0;
}

.control-panel {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
  margin-bottom: 40px;
}

.status-card, .action-card, .stats-card {
  background-color: #1e293b;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.status-title, .action-title, .stats-title {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 16px;
  color: #e2e8f0;
}

.status-value {
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 16px;
}

.status-value.active {
  color: #10b981;
}

.status-value.inactive {
  color: #ef4444;
}

.status-actions, .action-buttons {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

button {
  padding: 10px 16px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  border: none;
  transition: all 0.2s;
}

.enable-btn {
  background-color: #10b981;
  color: white;
}

.enable-btn:hover {
  background-color: #059669;
}

.disable-btn {
  background-color: #ef4444;
  color: white;
}

.disable-btn:hover {
  background-color: #dc2626;
}

.clear-btn {
  background-color: #ef4444;
  color: white;
}

.clear-btn:hover {
  background-color: #dc2626;
}

.export-btn {
  background-color: #3b82f6;
  color: white;
}

.export-btn:hover {
  background-color: #2563eb;
}

.view-btn {
  background-color: #8b5cf6;
  color: white;
}

.view-btn:hover {
  background-color: #7c3aed;
}

.stats-values {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
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

.stat-number {
  font-size: 24px;
  font-weight: 700;
  color: #ffffff;
}

.test-panel {
  background-color: #1e293b;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 40px;
}

.test-form {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.form-group {
  margin-bottom: 16px;
}

label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #94a3b8;
}

input, select, textarea {
  width: 100%;
  padding: 10px 12px;
  background-color: #1e1e2e;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  color: #e2e8f0;
  font-size: 14px;
}

textarea {
  height: 100px;
  resize: vertical;
}

input:focus, select:focus, textarea:focus {
  outline: none;
  border-color: #4ecdc4;
}

.form-actions {
  grid-column: 1 / -1;
  display: flex;
  gap: 12px;
  margin-top: 16px;
}

.test-btn {
  background-color: #4ecdc4;
  color: white;
}

.test-btn:hover {
  background-color: #3db1a8;
}

.reset-btn {
  background-color: #4b5563;
  color: white;
}

.reset-btn:hover {
  background-color: #374151;
}

.last-event {
  grid-column: 1 / -1;
  margin-top: 24px;
  padding: 16px;
  background-color: #1e1e2e;
  border-radius: 8px;
  overflow: auto;
}

.last-event pre {
  margin: 0;
  white-space: pre-wrap;
  word-break: break-all;
  font-family: monospace;
  font-size: 14px;
  line-height: 1.5;
  color: #e2e8f0;
}

.navigation-panel {
  background-color: #1e293b;
  border-radius: 12px;
  padding: 24px;
}

.navigation-links {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
}

.nav-link {
  display: inline-block;
  padding: 12px 20px;
  background-color: #4ecdc4;
  color: white;
  text-decoration: none;
  border-radius: 8px;
  font-weight: 500;
  transition: all 0.2s;
}

.nav-link:hover {
  background-color: #3db1a8;
  transform: translateY(-2px);
}

@media (max-width: 768px) {
  .control-panel {
    grid-template-columns: 1fr;
  }
  .test-form {
    grid-template-columns: 1fr;
  }
  .stats-values {
    grid-template-columns: 1fr;
  }
}
</style>
