<template>
  <div class="dashboard">
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
    <div class="chart-section">
      <!-- 用户增长趋势 -->
      <div class="chart-card">
        <div class="chart-header">
          <h3>用户增长趋势</h3>
          <div class="chart-actions">
            <button
              v-for="period in ['7天', '30天']"
              :key="period"
              :class="['chart-period-btn', { active: userChartPeriod === period }]"
              @click="userChartPeriod = period"
            >
              {{ period }}
            </button>
          </div>
        </div>
        <div ref="userChart" class="chart-container"></div>
      </div>

      <!-- 访问量趋势 -->
      <div class="chart-card">
        <div class="chart-header">
          <h3>网站访问趋势</h3>
          <div class="chart-actions">
            <button
              v-for="period in ['7天', '30天']"
              :key="period"
              :class="['chart-period-btn', { active: visitChartPeriod === period }]"
              @click="visitChartPeriod = period"
            >
              {{ period }}
            </button>
          </div>
        </div>
        <div ref="visitChart" class="chart-container"></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import * as echarts from 'echarts'
import { useRouter } from 'vue-router'
import request from '@/utils/request'
import store from '@/store'

const router = useRouter()

// 统计卡片数据
const stats = ref([
  {
    label: '用户总数',
    value: '0',
    icon: 'fas fa-users',
    color: '#4ecdc4'
  },
  {
    label: '题目数量',
    value: '0',
    icon: 'fas fa-tasks',
    color: '#ff6b6b'
  },
  {
    label: '今日访问',
    value: '0',
    icon: 'fas fa-chart-line',
    color: '#ffd93d'
  }

])

// 获取统计数据
const fetchStats = async () => {
  try {
    console.log('获取统计数据...')
    // 从store和localStorage多处检查token
    const storeToken = store.getters.token
    const localToken = localStorage.getItem('accessToken')
    const token = storeToken || localToken

    console.log('当前token从store获取:', token)

    if (!token) {
      console.log('未找到有效token，跳过统计数据获取')
      return // 只是跳过获取，不跳转
    }

    // 确保token设置在请求头中
    if (!request.defaults.headers.common.Authorization) {
      console.log('请求头中未设置token，正在设置...')
      request.defaults.headers.common.Authorization = `Bearer ${token}`
    }

    const response = await request.get('/api/stats/dashboard')
    console.log('统计数据响应:', response)

    if (response.success) {
      const data = response.data
      console.log('更新前的统计卡片数据:', stats.value)

      // 更新统计卡片数据
      stats.value = [
        {
          label: '用户总数',
          value: data.total_users.toString(),
          icon: 'fas fa-users',
          color: '#4ecdc4'
        },
        {
          label: '题目数量',
          value: data.total_problems.toString(),
          icon: 'fas fa-tasks',
          color: '#ff6b6b'
        },
        {
          label: '今日访问',
          value: data.today_visits.toString(),
          icon: 'fas fa-chart-line',
          color: '#ffd93d'
        }

      ]

      console.log('更新后的统计卡片数据:', stats.value)
    }
  } catch (error) {
    console.log('获取统计数据失败，继续执行不中断:', error)
    // 统计获取失败不影响界面显示，显示默认值
  }
}

// 记录用户访问
const recordVisit = async () => {
  try {
    console.log('记录用户访问...')
    // 从store和localStorage多处检查token
    const storeToken = store.getters.token
    const localToken = localStorage.getItem('accessToken')
    const token = storeToken || localToken

    console.log('当前token从store获取:', token)

    if (!token) {
      console.log('未找到有效token，跳过访问记录')
      return // 只是跳过记录，不跳转
    }

    // 确保token设置在请求头中
    if (!request.defaults.headers.common.Authorization) {
      console.log('请求头中未设置token，正在设置...')
      request.defaults.headers.common.Authorization = `Bearer ${token}`
    }

    await request.post('/api/stats/record-visit')
  } catch (error) {
    console.log('记录访问失败，继续执行不中断:', error)
    // 访问记录失败不影响后续操作，静默失败
  }
}

// 图表相关
const userChart = ref(null)
const visitChart = ref(null)
const userChartPeriod = ref('7天')
const visitChartPeriod = ref('7天')

// 获取图表数据
const fetchChartData = async (type, days) => {
  try {
    // 从store和localStorage多处检查token
    const storeToken = store.getters.token
    const localToken = localStorage.getItem('accessToken')
    const token = storeToken || localToken

    if (!token) {
      console.log(`未找到有效token，跳过${type}趋势数据获取`)
      return null // 只是返回null，不跳转
    }

    // 确保token设置在请求头中
    if (!request.defaults.headers.common.Authorization) {
      console.log('请求头中未设置token，正在设置...')
      request.defaults.headers.common.Authorization = `Bearer ${token}`
    }

    const response = await request.get(`/api/stats/trend/${type}`, {
      params: { days }
    })

    if (response.success) {
      return response.data
    }
    return null
  } catch (error) {
    console.log(`获取${type}趋势数据失败，返回null:`, error)
    return null
  }
}

// 初始化图表
const initChart = (chartRef, title, data) => {
  const chart = echarts.init(chartRef)
  const option = {
    title: {
      text: title,
      show: false
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: data.dates,
      axisLabel: {
        rotate: 45
      }
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        name: title,
        type: 'line',
        data: data.values,
        smooth: true,
        showSymbol: false,
        areaStyle: {
          opacity: 0.3,
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#4ecdc4' },
            { offset: 1, color: 'rgba(78,205,196,0.1)' }
          ])
        },
        lineStyle: {
          width: 3,
          color: '#4ecdc4'
        },
        itemStyle: {
          color: '#4ecdc4'
        }
      }
    ]
  }
  chart.setOption(option)
  return chart
}

// 更新图表数据
const updateChart = async (chart, type, days) => {
  const data = await fetchChartData(type, days)
  if (data) {
    chart.setOption({
      xAxis: {
        data: data.dates
      },
      series: [{
        data: data.values
      }]
    })
  }
}

// 监听周期变化
watch([userChartPeriod, visitChartPeriod], async ([newUserPeriod, newVisitPeriod]) => {
  const userDays = newUserPeriod === '7天' ? 7 : 30
  const visitDays = newVisitPeriod === '7天' ? 7 : 30

  if (userChartInstance.value) {
    await updateChart(userChartInstance.value, 'users', userDays)
  }

  if (visitChartInstance.value) {
    await updateChart(visitChartInstance.value, 'visits', visitDays)
  }
})

// 保存图表实例
const userChartInstance = ref(null)
const visitChartInstance = ref(null)

onMounted(async () => {
  try {
    // 记录访问并获取统计数据
    await recordVisit()
    await fetchStats()

    // 获取初始图表数据
    const userData = await fetchChartData('users', 7)
    const visitData = await fetchChartData('visits', 7)

    // 初始化图表
    if (userData && userChart.value) {
      userChartInstance.value = initChart(userChart.value, '用户数量', userData)
    }
    if (visitData && visitChart.value) {
      visitChartInstance.value = initChart(visitChart.value, '访问量', visitData)
    }

    // 监听窗口大小变化
    window.addEventListener('resize', () => {
      userChartInstance.value?.resize()
      visitChartInstance.value?.resize()
    })
  } catch (error) {
    console.log('初始化图表时出错:', error)
    // 错误不会影响页面其他部分
  }
})
</script>

<style scoped>
.dashboard {
  padding: 24px;
}

.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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

.chart-section {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
  margin-top: 24px;
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

.chart-actions {
  display: flex;
  gap: 8px;
}

.chart-period-btn {
  padding: 4px 12px;
  border: 1px solid #e0e0e0;
  border-radius: 6px;
  background: white;
  color: #666;
  cursor: pointer;
  transition: all 0.3s ease;
}

.chart-period-btn:hover {
  border-color: #4ecdc4;
  color: #4ecdc4;
}

.chart-period-btn.active {
  background: #4ecdc4;
  border-color: #4ecdc4;
  color: white;
}

.chart-container {
  height: 400px;
  width: 100%;
}

@media (max-width: 1200px) {
  .chart-section {
    grid-template-columns: 1fr;
  }

  .chart-container {
    height: 300px;
  }
}
</style>
