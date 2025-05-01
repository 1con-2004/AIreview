<template>
  <div class="analytics-dashboard">
    <h2 class="page-title">埋点数据分析</h2>
    <!-- 时间筛选器 -->
    <div class="filter-section">
      <div class="date-range-picker">
        <span class="filter-label">时间范围：</span>
        <el-date-picker
          v-model="dateRange"
          type="daterange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          :shortcuts="dateShortcuts"
          @change="handleDateChange"
        />
      </div>
      <div class="event-type-filter">
        <span class="filter-label">事件类型：</span>
        <el-select v-model="selectedEventType" placeholder="选择事件类型" @change="fetchData">
          <el-option
            v-for="type in eventTypes"
            :key="type.value"
            :label="type.label"
            :value="type.value"
          />
        </el-select>
      </div>
      <el-button type="primary" @click="fetchData">刷新数据</el-button>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards">
      <div class="stat-card" v-for="(stat, index) in stats" :key="index">
        <div class="stat-icon" :style="{ backgroundColor: stat.color }">
          <i :class="stat.icon"></i>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stat.value }}</div>
          <div class="stat-label">{{ stat.label }}</div>
        </div>
      </div>
    </div>

    <!-- 图表区域 -->
    <div class="charts-row">
      <!-- 埋点事件趋势 -->
      <div class="chart-card">
        <div class="chart-header">
          <h3>埋点事件趋势</h3>
        </div>
        <div ref="eventTrendChart" class="chart-container"></div>
      </div>
      <!-- 事件类型分布 -->
      <div class="chart-card">
        <div class="chart-header">
          <h3>事件类型分布</h3>
        </div>
        <div ref="eventTypeChart" class="chart-container"></div>
      </div>
    </div>

    <div class="charts-row">
      <!-- 热门点击元素 -->
      <div class="chart-card">
        <div class="chart-header">
          <h3>热门点击元素</h3>
        </div>
        <div ref="clickElementsChart" class="chart-container"></div>
      </div>
      <!-- 页面访问分布 -->
      <div class="chart-card">
        <div class="chart-header">
          <h3>页面访问分布</h3>
        </div>
        <div ref="pageViewChart" class="chart-container"></div>
      </div>
    </div>

    <!-- 用户行为路径 -->
    <div class="chart-card full-width">
      <div class="chart-header">
        <h3>用户行为路径</h3>
      </div>
      <div ref="userPathChart" class="chart-container path-chart"></div>
    </div>

    <!-- 最近埋点事件列表 -->
    <div class="events-table-section">
      <div class="section-header">
        <h3>最近埋点事件</h3>
        <el-button size="small" @click="exportEvents">导出数据</el-button>
      </div>
      <el-table :data="recentEvents" stripe style="width: 100%" :max-height="400">
        <el-table-column prop="timestamp" label="时间" width="180">
          <template #default="scope">
            {{ formatDate(scope.row.timestamp) }}
          </template>
        </el-table-column>
        <el-table-column prop="type" label="事件类型" width="120" />
        <el-table-column prop="userId" label="用户ID" width="120" />
        <el-table-column prop="pageName" label="页面" width="150" />
        <el-table-column prop="elementName" label="元素" width="150" />
        <el-table-column prop="elementId" label="元素ID" width="120" />
        <el-table-column label="详情">
          <template #default="scope">
            <el-button size="small" @click="showEventDetails(scope.row)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination">
        <el-pagination
          layout="prev, pager, next"
          :total="totalEvents"
          :page-size="pageSize"
          :current-page="currentPage"
          @current-change="handlePageChange"
        />
      </div>
    </div>

    <!-- 事件详情对话框 -->
    <el-dialog
      v-model="detailsDialogVisible"
      title="事件详情"
      width="50%"
    >
      <div v-if="selectedEvent" class="event-details">
        <pre>{{ JSON.stringify(selectedEvent, null, 2) }}</pre>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import * as echarts from 'echarts'
import request from '@/utils/request'
import store from '@/store'
import { ElMessage } from 'element-plus'

// 状态变量
const dateRange = ref([new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), new Date()])
const selectedEventType = ref('')
const stats = ref([
  { label: '总埋点事件', value: '0', icon: 'fas fa-chart-bar', color: '#4ecdc4' },
  { label: '页面访问量', value: '0', icon: 'fas fa-eye', color: '#ff6b6b' },
  { label: '点击事件', value: '0', icon: 'fas fa-mouse-pointer', color: '#ffd93d' },
  { label: '活跃用户', value: '0', icon: 'fas fa-users', color: '#7c4dff' }
])
const recentEvents = ref([])
const totalEvents = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const detailsDialogVisible = ref(false)
const selectedEvent = ref(null)

// 图表引用
const eventTrendChart = ref(null)
const eventTypeChart = ref(null)
const clickElementsChart = ref(null)
const pageViewChart = ref(null)
const userPathChart = ref(null)

// 图表实例
const chartInstances = ref({
  eventTrend: null,
  eventType: null,
  clickElements: null,
  pageView: null,
  userPath: null
})

// 事件类型选项
const eventTypes = [
  { label: '全部事件', value: '' },
  { label: '页面访问', value: 'page_view' },
  { label: '点击事件', value: 'click' },
  { label: '筛选事件', value: 'filter' },
  { label: '分页事件', value: 'pagination' }
]

// 日期快捷选项
const dateShortcuts = [
  {
    text: '最近一周',
    value: () => {
      const end = new Date()
      const start = new Date()
      start.setTime(start.getTime() - 3600 * 1000 * 24 * 7)
      return [start, end]
    }
  },
  {
    text: '最近一个月',
    value: () => {
      const end = new Date()
      const start = new Date()
      start.setTime(start.getTime() - 3600 * 1000 * 24 * 30)
      return [start, end]
    }
  },
  {
    text: '最近三个月',
    value: () => {
      const end = new Date()
      const start = new Date()
      start.setTime(start.getTime() - 3600 * 1000 * 24 * 90)
      return [start, end]
    }
  }
]

// 格式化日期
const formatDate = (timestamp) => {
  const date = new Date(timestamp)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}:${String(date.getSeconds()).padStart(2, '0')}`
}

// 时间范围变更
const handleDateChange = () => {
  fetchData()
}

// 分页变更
const handlePageChange = (page) => {
  currentPage.value = page
  fetchEvents()
}

// 获取埋点统计数据
const fetchStats = async () => {
  try {
    const token = store.getters.token || localStorage.getItem('accessToken')
    if (!token) return

    if (!request.defaults.headers.common.Authorization) {
      request.defaults.headers.common.Authorization = `Bearer ${token}`
    }

    const startDate = dateRange.value[0]?.getTime()
    const endDate = dateRange.value[1]?.getTime()

    const response = await request.get('/api/analytics/stats', {
      params: {
        startDate,
        endDate,
        eventType: selectedEventType.value
      }
    })

    if (response.success) {
      stats.value = [
        { label: '总埋点事件', value: response.data.totalEvents.toString(), icon: 'fas fa-chart-bar', color: '#4ecdc4' },
        { label: '页面访问量', value: response.data.pageViews.toString(), icon: 'fas fa-eye', color: '#ff6b6b' },
        { label: '点击事件', value: response.data.clickEvents.toString(), icon: 'fas fa-mouse-pointer', color: '#ffd93d' },
        { label: '活跃用户', value: response.data.activeUsers.toString(), icon: 'fas fa-users', color: '#7c4dff' }
      ]
    }
  } catch (error) {
    console.error('获取统计数据失败:', error)
  }
}

// 获取埋点事件列表
const fetchEvents = async () => {
  try {
    const token = store.getters.token || localStorage.getItem('accessToken')
    if (!token) return

    if (!request.defaults.headers.common.Authorization) {
      request.defaults.headers.common.Authorization = `Bearer ${token}`
    }

    const startDate = dateRange.value[0]?.getTime()
    const endDate = dateRange.value[1]?.getTime()

    const response = await request.get('/api/analytics/events', {
      params: {
        startDate,
        endDate,
        eventType: selectedEventType.value,
        page: currentPage.value,
        limit: pageSize.value
      }
    })

    if (response.success) {
      recentEvents.value = response.data.events
      totalEvents.value = response.data.total
    }
  } catch (error) {
    console.error('获取埋点事件列表失败:', error)
  }
}

// 获取图表数据
const fetchChartData = async () => {
  try {
    const token = store.getters.token || localStorage.getItem('accessToken')
    if (!token) return

    if (!request.defaults.headers.common.Authorization) {
      request.defaults.headers.common.Authorization = `Bearer ${token}`
    }

    const startDate = dateRange.value[0]?.getTime()
    const endDate = dateRange.value[1]?.getTime()

    const response = await request.get('/api/analytics/chart-data', {
      params: {
        startDate,
        endDate,
        eventType: selectedEventType.value
      }
    })

    if (response.success) {
      updateCharts(response.data)
    }
  } catch (error) {
    console.error('获取图表数据失败:', error)
  }
}

// 获取所有数据
const fetchData = () => {
  fetchStats()
  fetchEvents()
  fetchChartData()
}

// 查看事件详情
const showEventDetails = (event) => {
  selectedEvent.value = event
  detailsDialogVisible.value = true
}

// 导出埋点数据
const exportEvents = async () => {
  try {
    const token = store.getters.token || localStorage.getItem('accessToken')
    if (!token) return

    if (!request.defaults.headers.common.Authorization) {
      request.defaults.headers.common.Authorization = `Bearer ${token}`
    }

    const startDate = dateRange.value[0]?.getTime()
    const endDate = dateRange.value[1]?.getTime()

    const response = await request.get('/api/analytics/export', {
      params: {
        startDate,
        endDate,
        eventType: selectedEventType.value
      },
      responseType: 'blob'
    })

    const url = window.URL.createObjectURL(new Blob([response]))
    const link = document.createElement('a')
    link.href = url
    link.setAttribute('download', `埋点数据_${new Date().toISOString().split('T')[0]}.csv`)
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)
  } catch (error) {
    console.error('导出埋点数据失败:', error)
    ElMessage.error('导出埋点数据失败')
  }
}

// 初始化图表
const initCharts = () => {
  // 埋点事件趋势图
  chartInstances.value.eventTrend = echarts.init(eventTrendChart.value)
  chartInstances.value.eventTrend.setOption({
    title: { text: '埋点事件趋势', show: false },
    tooltip: { trigger: 'axis' },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'category', boundaryGap: false, data: [] },
    yAxis: { type: 'value' },
    series: [{
      name: '事件数量',
      type: 'line',
      smooth: true,
      data: [],
      areaStyle: {
        opacity: 0.3,
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: '#4ecdc4' },
          { offset: 1, color: 'rgba(78,205,196,0.1)' }
        ])
      },
      lineStyle: { width: 3, color: '#4ecdc4' },
      itemStyle: { color: '#4ecdc4' }
    }]
  })

  // 事件类型分布图
  chartInstances.value.eventType = echarts.init(eventTypeChart.value)
  chartInstances.value.eventType.setOption({
    title: { text: '事件类型分布', show: false },
    tooltip: { trigger: 'item', formatter: '{a} <br/>{b}: {c} ({d}%)' },
    legend: { orient: 'vertical', left: 'left' },
    series: [{
      name: '事件类型',
      type: 'pie',
      radius: ['50%', '70%'],
      avoidLabelOverlap: false,
      label: { show: false },
      emphasis: { label: { show: true, fontSize: '16' } },
      labelLine: { show: false },
      data: []
    }]
  })

  // 热门点击元素图
  chartInstances.value.clickElements = echarts.init(clickElementsChart.value)
  chartInstances.value.clickElements.setOption({
    title: { text: '热门点击元素', show: false },
    tooltip: { trigger: 'axis' },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'value' },
    yAxis: { type: 'category', data: [] },
    series: [{
      name: '点击次数',
      type: 'bar',
      data: [],
      itemStyle: { color: '#ff6b6b' }
    }]
  })

  // 页面访问分布图
  chartInstances.value.pageView = echarts.init(pageViewChart.value)
  chartInstances.value.pageView.setOption({
    title: { text: '页面访问分布', show: false },
    tooltip: { trigger: 'item', formatter: '{a} <br/>{b}: {c} ({d}%)' },
    legend: { orient: 'vertical', left: 'left' },
    series: [{
      name: '页面访问',
      type: 'pie',
      radius: '55%',
      data: [],
      emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } }
    }]
  })

  // 用户行为路径图
  chartInstances.value.userPath = echarts.init(userPathChart.value)
  chartInstances.value.userPath.setOption({
    title: { text: '用户行为路径', show: false },
    tooltip: { trigger: 'item', formatter: '{a} <br/>{b} : {c}' },
    series: [{
      name: '用户行为',
      type: 'sankey',
      layout: 'none',
      emphasis: { focus: 'adjacency' },
      data: [],
      links: [],
      lineStyle: { color: 'gradient', curveness: 0.5 }
    }]
  })

  // 监听窗口大小变化
  window.addEventListener('resize', () => {
    Object.values(chartInstances.value).forEach(chart => {
      chart?.resize()
    })
  })
}

// 更新图表数据
const updateCharts = (data) => {
  // 更新埋点事件趋势图
  if (chartInstances.value.eventTrend && data.eventTrend) {
    chartInstances.value.eventTrend.setOption({
      xAxis: { data: data.eventTrend.dates },
      series: [{ data: data.eventTrend.values }]
    })
  }

  // 更新事件类型分布图
  if (chartInstances.value.eventType && data.eventTypeDistribution) {
    chartInstances.value.eventType.setOption({
      series: [{ data: data.eventTypeDistribution }]
    })
  }

  // 更新热门点击元素图
  if (chartInstances.value.clickElements && data.popularClickElements) {
    chartInstances.value.clickElements.setOption({
      yAxis: { data: data.popularClickElements.elements },
      series: [{ data: data.popularClickElements.counts }]
    })
  }

  // 更新页面访问分布图
  if (chartInstances.value.pageView && data.pageViewDistribution) {
    chartInstances.value.pageView.setOption({
      series: [{ data: data.pageViewDistribution }]
    })
  }

  // 更新用户行为路径图
  if (chartInstances.value.userPath && data.userBehaviorPath) {
    chartInstances.value.userPath.setOption({
      series: [{
        data: data.userBehaviorPath.nodes,
        links: data.userBehaviorPath.links
      }]
    })
  }
}

// 组件挂载时初始化
onMounted(() => {
  initCharts()
  fetchData()
})
</script>

<style scoped>
.analytics-dashboard {
  padding: 24px;
}

.page-title {
  font-size: 24px;
  margin-bottom: 24px;
  color: #1e1e2e;
}

.filter-section {
  display: flex;
  align-items: center;
  margin-bottom: 24px;
  flex-wrap: wrap;
  gap: 16px;
}

.filter-label {
  font-size: 14px;
  color: #666;
  margin-right: 8px;
}

.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 24px;
  margin-bottom: 24px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 24px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #1e1e2e;
  line-height: 1.2;
}

.stat-label {
  font-size: 14px;
  color: #666;
  margin-top: 4px;
}

.charts-row {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
  margin-bottom: 24px;
}

.chart-card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.chart-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
}

.full-width {
  grid-column: 1 / -1;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.chart-header h3 {
  font-size: 18px;
  color: #1e1e2e;
  margin: 0;
}

.chart-container {
  height: 300px;
  width: 100%;
}

.path-chart {
  height: 400px;
}

.events-table-section {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  margin-top: 24px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.section-header h3 {
  font-size: 18px;
  color: #1e1e2e;
  margin: 0;
}

.pagination {
  margin-top: 16px;
  display: flex;
  justify-content: center;
}

.event-details {
  background-color: #f8f9fa;
  padding: 16px;
  border-radius: 8px;
  max-height: 400px;
  overflow-y: auto;
}

.event-details pre {
  margin: 0;
  white-space: pre-wrap;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
}

@media (max-width: 1200px) {
  .charts-row {
    grid-template-columns: 1fr;
  }
}
</style>
