<template>
  <div class="analytics-dashboard">
    <h2>埋点数据分析</h2>
    
    <!-- 筛选器 -->
    <div class="filter-section">
      <el-date-picker
        v-model="dateRange"
        type="daterange"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        value-format="x"
        :default-time="['00:00:00', '23:59:59']"
        @change="handleDateChange"
      />
      <el-select 
        v-model="selectedEventType" 
        placeholder="选择事件类型" 
        @change="handleEventTypeChange"
        popper-class="analytics-event-select"
      >
        <el-option
          v-for="type in eventTypes"
          :key="type.value"
          :label="type.label"
          :value="type.value"
        />
      </el-select>
      <el-button type="primary" @click="fetchData">刷新数据</el-button>
    </div>

    <!-- 基础统计 -->
    <div class="stats-section">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card shadow="hover">
            <div class="stat-item">
              <div class="stat-title">总事件数</div>
              <div class="stat-value">{{ stats.totalEvents }}</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover">
            <div class="stat-item">
              <div class="stat-title">页面访问量</div>
              <div class="stat-value">{{ stats.pageViews }}</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover">
            <div class="stat-item">
              <div class="stat-title">点击事件数</div>
              <div class="stat-value">{{ stats.clickEvents }}</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover">
            <div class="stat-item">
              <div class="stat-title">活跃用户数</div>
              <div class="stat-value">{{ stats.activeUsers }}</div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 事件列表 -->
    <div class="events-section">
      <div class="section-header">
        <h3>埋点事件列表</h3>
        <el-button type="primary" size="small" @click="exportEvents">导出数据</el-button>
      </div>
      <el-table 
        :data="events" 
        border 
        style="width: 100%" 
        v-loading="loading"
        :header-cell-style="{ background: '#f5f7fa' }"
      >
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="event_type" label="事件类型" width="100" />
        <el-table-column prop="user_id" label="用户ID" width="100" />
        <el-table-column prop="page_name" label="页面" min-width="120" />
        <el-table-column prop="element_name" label="元素名称" min-width="120" />
        <el-table-column prop="element_id" label="元素ID" min-width="120" />
        <el-table-column label="时间" width="160">
          <template #default="scope">
            {{ formatTimestamp(scope.row.timestamp) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="80" fixed="right">
          <template #default="scope">
            <el-button link type="primary" @click="showDetails(scope.row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页器 -->
      <div class="pagination">
        <el-select
          v-model="pageSize"
          @change="handleSizeChange"
          style="width: 120px; margin-right: 20px;"
        >
          <el-option
            v-for="size in [10, 20, 50, 100]"
            :key="size"
            :label="`${size}条/页`"
            :value="size"
          />
        </el-select>
        <button
          class="page-btn"
          :disabled="currentPage === 1"
          @click="handleCurrentChange(currentPage - 1)"
        >
          <i class="fas fa-chevron-left"></i>
        </button>
        <span class="page-info">第 {{ currentPage }} 页，共 {{ Math.ceil(total / pageSize) }} 页</span>
        <button
          class="page-btn"
          :disabled="currentPage === Math.ceil(total / pageSize)"
          @click="handleCurrentChange(currentPage + 1)"
        >
          <i class="fas fa-chevron-right"></i>
        </button>
      </div>
    </div>

    <!-- 详情弹窗 -->
    <el-dialog
      v-model="detailsVisible"
      title="事件详情"
      width="50%"
      destroy-on-close
    >
      <div v-if="selectedEvent" class="event-details">
        <div class="detail-item">
          <span class="detail-label">事件ID：</span>
          <span class="detail-value">{{ selectedEvent.id }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">事件类型：</span>
          <span class="detail-value">{{ selectedEvent.event_type || '-' }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">用户ID：</span>
          <span class="detail-value">{{ selectedEvent.user_id }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">页面名称：</span>
          <span class="detail-value">{{ selectedEvent.page_name || '-' }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">元素名称：</span>
          <span class="detail-value">{{ selectedEvent.element_name || '-' }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">元素ID：</span>
          <span class="detail-value">{{ selectedEvent.element_id || '-' }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">IP地址：</span>
          <span class="detail-value">{{ selectedEvent.ip || '-' }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">时间：</span>
          <span class="detail-value">{{ formatTimestamp(selectedEvent.timestamp) }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">创建时间：</span>
          <span class="detail-value">{{ selectedEvent.created_at || '-' }}</span>
        </div>
        <div class="detail-item" v-if="selectedEvent.metadata">
          <span class="detail-label">元数据：</span>
          <pre class="detail-value metadata">{{ JSON.stringify(selectedEvent.metadata, null, 2) }}</pre>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import request from '@/utils/request'
import { ElMessage } from 'element-plus'

// 状态变量
const dateRange = ref([])
const selectedEventType = ref('')
const events = ref([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const detailsVisible = ref(false)
const selectedEvent = ref(null)
const stats = ref({
  totalEvents: 0,
  pageViews: 0,
  clickEvents: 0,
  activeUsers: 0
})

// 事件类型选项
const eventTypes = [
  { label: '全部事件', value: '' },
  { label: '页面访问', value: 'page_view' },
  { label: '点击事件', value: 'click' }
]

// 格式化时间戳
const formatTimestamp = (timestamp) => {
  if (!timestamp) return '-'
  const date = new Date(Number(timestamp))
  return date.toLocaleString()
}

// 处理日期变化
const handleDateChange = () => {
  fetchData()
}

// 处理事件类型变化
const handleEventTypeChange = () => {
  fetchData()
}

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val
  fetchEvents()
}

// 处理每页条数变化
const handleSizeChange = (val) => {
  pageSize.value = val
  fetchEvents()
}

// 获取统计数据
const fetchStats = async () => {
  try {
    const params = {
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1],
      eventType: selectedEventType.value
    }
    
    // 添加日志以便调试
    console.log('Fetching stats with params:', params)
    
    const res = await request.get('/api/analytics/stats', { params })
    if (res.success) {
      stats.value = res.data
    }
  } catch (error) {
    console.error('获取统计数据失败:', error)
    ElMessage.error('获取统计数据失败')
  }
}

// 获取事件列表
const fetchEvents = async () => {
  loading.value = true
  try {
    const params = {
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1],
      eventType: selectedEventType.value,
      page: currentPage.value,
      pageSize: pageSize.value
    }
    
    // 添加日志以便调试
    console.log('Fetching events with params:', params)
    
    const res = await request.get('/api/analytics/events', { params })
    if (res.success) {
      events.value = res.data.events
      total.value = res.data.total
    }
  } catch (error) {
    console.error('获取事件列表失败:', error)
    ElMessage.error('获取事件列表失败')
  } finally {
    loading.value = false
  }
}

// 获取所有数据
const fetchData = () => {
  fetchStats()
  fetchEvents()
}

// 显示事件详情
const showDetails = (event) => {
  selectedEvent.value = event
  detailsVisible.value = true
}

// 导出事件数据
const exportEvents = async () => {
  try {
    const params = {
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1],
      eventType: selectedEventType.value
    }
    
    const res = await request.get('/api/analytics/export', { 
      params,
      responseType: 'blob'
    })
    
    const url = window.URL.createObjectURL(new Blob([res]))
    const link = document.createElement('a')
    link.href = url
    link.setAttribute('download', `埋点数据_${new Date().toISOString().split('T')[0]}.csv`)
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)
  } catch (error) {
    console.error('导出数据失败:', error)
    ElMessage.error('导出数据失败')
  }
}

// 组件挂载时初始化
onMounted(() => {
  // 设置默认时间范围为最近7天
  const end = new Date()
  end.setHours(23, 59, 59, 999)  // 设置为当天结束时间
  const start = new Date()
  start.setHours(0, 0, 0, 0)  // 设置为当天开始时间
  start.setTime(start.getTime() - 7 * 24 * 60 * 60 * 1000)
  dateRange.value = [start.getTime(), end.getTime()]
  
  fetchData()
})
</script>

<style scoped>
.analytics-dashboard {
  padding: 20px;
}

.filter-section {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
}

.stats-section {
  margin-bottom: 20px;
}

.stat-item {
  text-align: center;
}

.stat-title {
  font-size: 14px;
  color: #666;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #409EFF;
}

.events-section {
  background: #fff;
  padding: 20px;
  border-radius: 4px;
  margin-bottom: 20px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 500;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.page-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  margin: 0 4px;
  border: 1px solid #dcdfe6;
  background: #fff;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s;
}

.page-btn:hover:not(:disabled) {
  color: #409eff;
  border-color: #409eff;
}

.page-btn:disabled {
  cursor: not-allowed;
  color: #c0c4cc;
  background: #f4f4f5;
}

.page-info {
  margin: 0 12px;
  font-size: 14px;
  color: #606266;
}

.el-table {
  margin-bottom: 20px;
}

.el-table :deep(th) {
  background-color: #f5f7fa !important;
}

.el-table :deep(td),
.el-table :deep(th) {
  padding: 8px 0;
}

.event-details {
  padding: 16px;
  background: #f8f9fa;
  border-radius: 8px;
  max-height: 600px;
  overflow-y: auto;
}

.detail-item {
  margin-bottom: 12px;
  display: flex;
  align-items: flex-start;
}

.detail-label {
  width: 100px;
  color: #606266;
  font-weight: 500;
}

.detail-value {
  flex: 1;
  color: #303133;
}

.metadata {
  background: #fff;
  padding: 8px;
  border-radius: 4px;
  border: 1px solid #dcdfe6;
  font-family: monospace;
  white-space: pre-wrap;
  word-break: break-all;
}

/* 覆盖下拉框的样式 */
:deep(.el-select-dropdown) {
  background-color: #fff !important;
}

:deep(.el-select-dropdown__item) {
  color: #606266 !important;
}

:deep(.el-select-dropdown__item.hover),
:deep(.el-select-dropdown__item:hover) {
  background-color: #f5f7fa !important;
}

:deep(.el-select-dropdown__item.selected) {
  color: #409eff !important;
  background-color: #f5f7fa !important;
}

/* 确保弹出层在最顶层 */
:deep(.el-select__popper) {
  z-index: 2000 !important;
}

/* 添加全局样式 */
</style>

<style>
/* 全局样式，确保下拉框样式正确 */
.analytics-event-select {
  background-color: #fff !important;
  border: 1px solid #dcdfe6 !important;
}

.analytics-event-select .el-select-dropdown__item {
  color: #606266 !important;
}

.analytics-event-select .el-select-dropdown__item.hover,
.analytics-event-select .el-select-dropdown__item:hover {
  background-color: #f5f7fa !important;
}

.analytics-event-select .el-select-dropdown__item.selected {
  color: #409eff !important;
  background-color: #f5f7fa !important;
}
</style>
