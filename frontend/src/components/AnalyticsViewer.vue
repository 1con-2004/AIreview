<!-- 埋点数据查看器组件 -->
<template>
  <div class="analytics-viewer">
    <div class="analytics-header">
      <h2>埋点数据查看器</h2>
      <div class="actions">
        <button class="refresh-btn" @click="loadEvents">刷新数据</button>
        <button class="clear-btn" @click="clearEvents">清除数据</button>
        <button class="close-btn" @click="$emit('close')">关闭</button>
      </div>
    </div>
    
    <div class="analytics-stats">
      <div class="stat-item">
        <div class="stat-title">总事件数</div>
        <div class="stat-value">{{ events.length }}</div>
      </div>
      <div class="stat-item">
        <div class="stat-title">页面访问</div>
        <div class="stat-value">{{ countByType('page_view') }}</div>
      </div>
      <div class="stat-item">
        <div class="stat-title">点击事件</div>
        <div class="stat-value">{{ countByType('click') }}</div>
      </div>
      <div class="stat-item">
        <div class="stat-title">筛选事件</div>
        <div class="stat-value">{{ countByType('filter') }}</div>
      </div>
    </div>
    
    <div class="filter-bar">
      <input 
        type="text" 
        v-model="filter" 
        placeholder="搜索事件..." 
        class="filter-input"
      />
      <select v-model="typeFilter" class="type-filter">
        <option value="">全部类型</option>
        <option value="page_view">页面访问</option>
        <option value="click">点击事件</option>
        <option value="filter">筛选事件</option>
        <option value="pagination">分页事件</option>
      </select>
    </div>
    
    <div class="events-table-wrapper">
      <table class="events-table">
        <thead>
          <tr>
            <th>时间</th>
            <th>类型</th>
            <th>详情</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(event, index) in filteredEvents" :key="index">
            <td>{{ formatTime(event.timestamp) }}</td>
            <td>
              <span class="event-type" :class="event.type || event.category">
                {{ event.type || event.category }}
              </span>
            </td>
            <td>
              <div class="event-details">
                <!-- 页面访问事件 -->
                <template v-if="event.type === 'page_view'">
                  <div><strong>页面:</strong> {{ event.pageName }}</div>
                  <div v-if="event.pageParams?.referrer"><strong>来源:</strong> {{ event.pageParams.referrer }}</div>
                </template>
                
                <!-- 点击事件 -->
                <template v-else-if="event.type === 'click'">
                  <div><strong>元素:</strong> {{ event.elementName }}</div>
                  <div v-if="event.elementId"><strong>ID:</strong> {{ event.elementId }}</div>
                  <div v-if="event.action"><strong>动作:</strong> {{ event.action }}</div>
                </template>
                
                <!-- 筛选事件 -->
                <template v-else-if="event.type === 'filter'">
                  <div><strong>筛选项:</strong> {{ event.filterName }}</div>
                  <div><strong>值:</strong> {{ event.filterValue || '(重置)' }}</div>
                </template>
                
                <!-- 分页事件 -->
                <template v-else-if="event.type === 'pagination'">
                  <div><strong>分页类型:</strong> {{ event.pageType }}</div>
                  <div><strong>页码:</strong> {{ event.pageNumber }}</div>
                </template>
                
                <!-- 自定义事件 -->
                <template v-else>
                  <div><strong>类别:</strong> {{ event.category }}</div>
                  <div><strong>动作:</strong> {{ event.action }}</div>
                </template>
                
                <!-- 通用额外数据展示 -->
                <div class="extra-data" v-if="hasExtraData(event)">
                  <button @click="toggleExtraData(index)" class="toggle-extra-btn">
                    {{ expandedRows[index] ? '收起详情' : '查看详情' }}
                  </button>
                  <div v-if="expandedRows[index]" class="extra-data-content">
                    <pre>{{ formatExtraData(event) }}</pre>
                  </div>
                </div>
              </div>
            </td>
            <td>
              <button @click="copyEvent(event)" class="copy-btn">复制</button>
            </td>
          </tr>
          <tr v-if="filteredEvents.length === 0">
            <td colspan="4" class="no-data">
              没有找到匹配的埋点数据
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AnalyticsViewer',
  props: {
    visible: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      events: [],
      filter: '',
      typeFilter: '',
      expandedRows: {}
    }
  },
  computed: {
    filteredEvents() {
      return this.events.filter(event => {
        // 类型筛选
        if (this.typeFilter && event.type !== this.typeFilter) {
          return false;
        }
        
        // 关键词筛选
        if (this.filter) {
          const searchTerm = this.filter.toLowerCase();
          const eventStr = JSON.stringify(event).toLowerCase();
          return eventStr.includes(searchTerm);
        }
        
        return true;
      }).sort((a, b) => b.timestamp - a.timestamp); // 最新的事件在上面
    }
  },
  mounted() {
    this.loadEvents();
  },
  methods: {
    loadEvents() {
      try {
        const eventsStr = localStorage.getItem('analytics_events');
        this.events = eventsStr ? JSON.parse(eventsStr) : [];
        console.log(`加载了 ${this.events.length} 条埋点数据`);
      } catch (error) {
        console.error('加载埋点数据失败:', error);
        this.events = [];
      }
    },
    clearEvents() {
      if (confirm('确定要清除所有埋点数据吗？')) {
        localStorage.removeItem('analytics_events');
        this.events = [];
        console.log('已清除所有埋点数据');
      }
    },
    formatTime(timestamp) {
      if (!timestamp) return 'Unknown';
      
      const date = new Date(timestamp);
      return date.toLocaleString('zh-CN', {
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      });
    },
    countByType(type) {
      return this.events.filter(event => event.type === type).length;
    },
    hasExtraData(event) {
      // 检查事件是否有额外数据
      if (event.type === 'page_view' && event.pageParams && Object.keys(event.pageParams).length > 1) {
        return true;
      }
      
      if (event.type === 'click' && Object.keys(event).some(key => 
        !['type', 'elementName', 'elementId', 'timestamp', 'action'].includes(key))) {
        return true;
      }
      
      if (event.type === 'filter' && Object.keys(event).some(key => 
        !['type', 'filterName', 'filterValue', 'timestamp'].includes(key))) {
        return true;
      }
      
      if (event.category && event.action && Object.keys(event).length > 3) {
        return true;
      }
      
      return false;
    },
    toggleExtraData(index) {
      this.expandedRows = {
        ...this.expandedRows,
        [index]: !this.expandedRows[index]
      };
    },
    formatExtraData(event) {
      // 移除标准字段，只展示额外数据
      const standardFields = ['type', 'elementName', 'elementId', 'timestamp', 'category', 'action', 
                            'pageName', 'pageParams', 'filterName', 'filterValue', 'pageType', 'pageNumber'];
      
      const extraData = {};
      Object.keys(event).forEach(key => {
        if (!standardFields.includes(key)) {
          extraData[key] = event[key];
        }
      });
      
      // 如果是pageParams，单独展示
      if (event.pageParams && Object.keys(event.pageParams).length > 0) {
        extraData.pageParams = event.pageParams;
      }
      
      return JSON.stringify(extraData, null, 2);
    },
    copyEvent(event) {
      const eventStr = JSON.stringify(event, null, 2);
      navigator.clipboard.writeText(eventStr)
        .then(() => {
          alert('埋点数据已复制到剪贴板');
        })
        .catch(err => {
          console.error('复制失败:', err);
          alert('复制失败，请查看控制台日志');
        });
    }
  }
}
</script>

<style scoped>
.analytics-viewer {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(15, 23, 42, 0.95);
  z-index: 9999;
  color: #e2e8f0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  display: flex;
  flex-direction: column;
  padding: 20px;
  box-sizing: border-box;
  overflow: hidden;
}

.analytics-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.analytics-header h2 {
  font-size: 24px;
  font-weight: 600;
  margin: 0;
  color: #4ecdc4;
}

.actions {
  display: flex;
  gap: 8px;
}

.actions button {
  padding: 8px 16px;
  border-radius: 4px;
  border: none;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
}

.refresh-btn {
  background-color: #3b82f6;
  color: white;
}

.refresh-btn:hover {
  background-color: #2563eb;
}

.clear-btn {
  background-color: #ef4444;
  color: white;
}

.clear-btn:hover {
  background-color: #dc2626;
}

.close-btn {
  background-color: #4b5563;
  color: white;
}

.close-btn:hover {
  background-color: #374151;
}

.analytics-stats {
  display: flex;
  gap: 16px;
  margin: 16px 0;
}

.stat-item {
  background-color: rgba(30, 41, 59, 0.8);
  border-radius: 8px;
  padding: 16px;
  flex: 1;
  text-align: center;
}

.stat-title {
  font-size: 14px;
  color: #94a3b8;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #ffffff;
}

.filter-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
}

.filter-input {
  flex: 1;
  padding: 10px 16px;
  border-radius: 6px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background-color: rgba(30, 41, 59, 0.8);
  color: white;
  font-size: 14px;
}

.type-filter {
  width: 160px;
  padding: 10px 16px;
  border-radius: 6px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background-color: rgba(30, 41, 59, 0.8);
  color: white;
  font-size: 14px;
}

.events-table-wrapper {
  flex: 1;
  overflow: auto;
  border-radius: 8px;
  background-color: rgba(30, 41, 59, 0.8);
}

.events-table {
  width: 100%;
  border-collapse: collapse;
}

.events-table th {
  padding: 12px 16px;
  text-align: left;
  position: sticky;
  top: 0;
  background-color: #1e293b;
  z-index: 1;
  color: #94a3b8;
  font-weight: 600;
  font-size: 14px;
}

.events-table td {
  padding: 12px 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.05);
  vertical-align: top;
}

.events-table tr:hover {
  background-color: rgba(51, 65, 85, 0.5);
}

.event-type {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.event-type.page_view {
  background-color: #3b82f6;
  color: white;
}

.event-type.click {
  background-color: #10b981;
  color: white;
}

.event-type.filter {
  background-color: #f59e0b;
  color: white;
}

.event-type.pagination {
  background-color: #8b5cf6;
  color: white;
}

.event-type.user {
  background-color: #ec4899;
  color: white;
}

.event-type.system {
  background-color: #6b7280;
  color: white;
}

.event-type.error {
  background-color: #ef4444;
  color: white;
}

.event-type.data_load {
  background-color: #22d3ee;
  color: white;
}

.event-details {
  font-size: 14px;
  line-height: 1.5;
}

.extra-data {
  margin-top: 8px;
}

.toggle-extra-btn {
  background-color: transparent;
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: #94a3b8;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.toggle-extra-btn:hover {
  color: white;
  border-color: rgba(255, 255, 255, 0.5);
}

.extra-data-content {
  margin-top: 8px;
  padding: 8px;
  background-color: rgba(15, 23, 42, 0.5);
  border-radius: 4px;
  max-height: 120px;
  overflow: auto;
}

.extra-data-content pre {
  margin: 0;
  font-family: monospace;
  font-size: 12px;
  white-space: pre-wrap;
  word-break: break-all;
}

.copy-btn {
  background-color: transparent;
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: #94a3b8;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.copy-btn:hover {
  color: white;
  border-color: rgba(255, 255, 255, 0.5);
}

.no-data {
  text-align: center;
  color: #94a3b8;
  padding: 40px 0 !important;
  font-style: italic;
}
</style> 