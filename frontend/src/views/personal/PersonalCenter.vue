<template>
  <div class="personal-center">
    <nav-bar></nav-bar>

    <!-- 学生信息验证失败的提示 -->
    <div v-if="!loading && !isStudent" class="student-notice">
      <div class="notice-content">
        <i class="fas fa-exclamation-circle notice-icon"></i>
        <h2>访问受限</h2>
        <p>{{ message || '您并未登记学生信息，请联系管理员添加' }}</p>
        <router-link to="/home" class="back-home-btn">
          <i class="fas fa-home"></i>
          返回主页
        </router-link>
      </div>
    </div>

    <!-- 主要内容区域 - 仅对学生显示 -->
    <div v-if="isStudent" class="content-container">
      <!-- 个人信息区域 -->
      <div class="profile-section">
        <div class="profile-header">
          <div class="profile-avatar">
            <i class="fas fa-user-graduate"></i>
          </div>
          <div class="profile-info">
            <h2>{{ studentInfo.real_name }}</h2>
            <div class="info-items">
              <div class="info-item">
                <i class="fas fa-id-badge"></i>
                <span>学号: {{ studentInfo.student_no }}</span>
              </div>
              <div class="info-item">
                <i class="fas fa-university"></i>
                <span>院系: {{ studentInfo.department }}</span>
              </div>
              <div class="info-item">
                <i class="fas fa-graduation-cap"></i>
                <span>专业: {{ studentInfo.major }}</span>
              </div>
              <div class="info-item">
                <i class="fas fa-user-clock"></i>
                <span>年级: {{ studentInfo.grade }}</span>
              </div>
            </div>
          </div>
          <div class="completion-stats">
            <el-progress
              type="circle"
              :percentage="
                Math.round(
                  (completionData?.completed_problems /
                    (completionData?.total_problems || 1)) *
                    100
                ) || 0
              "
              :stroke-width="10"
              :width="80"
              :color="'#67C23A'"
            />
            <p class="completion-text">题目完成率</p>
          </div>
        </div>
      </div>

      <!-- 学习路径区域 -->
      <div class="learning-path-section" v-loading="learningPathLoading">
        <div class="section-header">
          <h2 class="section-title">个性化学习路径</h2>
          <el-button
            type="primary"
            size="small"
            :icon="RefreshRight"
            @click="refreshLearningPath"
            :loading="refreshLoading"
            class="refresh-btn"
          >
            刷新学习路径
          </el-button>
        </div>

        <!-- 弱点分析板块 -->
        <div class="learning-path-weakness" v-if="weaknessAnalysis.length > 0">
          <h3 class="block-title">
            <i class="fas fa-crosshairs"></i>
            弱点分析
          </h3>
          <div class="card-container">
            <div class="weakness-card" v-for="(item, index) in weaknessAnalysis" :key="index">
              <div class="card-header">
                <div class="tag-badge">{{ item.tag }}</div>
              </div>
              <div class="card-content">
                <p v-html="formatContent(item.idea)"></p>
              </div>
            </div>
            <div class="empty-weakness" v-if="weaknessAnalysis.length === 0">
              <i class="fas fa-award"></i>
              <p>你的知识已经掌握的很好啦！</p>
            </div>
          </div>
        </div>

        <!-- 学习方向板块 -->
        <div class="learning-path-directions">
          <h3 class="block-title">
            <i class="fas fa-compass"></i>
            学习方向
          </h3>
          <div class="directions-container">
            <div class="direction-group-card" v-for="(group, groupIndex) in learningDirections" :key="groupIndex">
              <div class="direction-group-header">
                <div class="direction-group-tag">{{ group.tag }}</div>
              </div>
              <div class="direction-items">
                <div class="direction-card" v-for="(item, index) in group.items" :key="index">
                  <div class="direction-source">
                    <span class="platform-icon" v-if="item.source === '哔哩哔哩'">
                      <svg viewBox="0 0 1024 1024" width="16" height="16">
                        <path d="M306.005333 117.632L444.330667 256h135.296l138.368-138.325333a42.666667 42.666667 0 0 1 60.373333 60.373333L700.330667 256H789.333333A149.333333 149.333333 0 0 1 938.666667 405.333333v341.333334a149.333333 149.333333 0 0 1-149.333334 149.333333h-554.666666A149.333333 149.333333 0 0 1 85.333333 746.666667v-341.333334A149.333333 149.333333 0 0 1 234.666667 256h88.96L245.632 177.962667a42.666667 42.666667 0 0 1 60.373333-60.373334zM789.333333 341.333333h-554.666666a64 64 0 0 0-63.701334 57.856L170.666667 405.333333v341.333334a64 64 0 0 0 57.856 63.701333L234.666667 810.666667h554.666666a64 64 0 0 0 63.701334-57.856L853.333333 746.666667v-341.333334A64 64 0 0 0 789.333333 341.333333zM341.333333 469.333333a42.666667 42.666667 0 0 1 42.666667 42.666667v85.333333a42.666667 42.666667 0 0 1-85.333333 0v-85.333333a42.666667 42.666667 0 0 1 42.666666-42.666667z m341.333334 0a42.666667 42.666667 0 0 1 42.666666 42.666667v85.333333a42.666667 42.666667 0 0 1-85.333333 0v-85.333333a42.666667 42.666667 0 0 1 42.666667-42.666667z" fill="#20B0E3"></path>
                      </svg>
                    </span>
                    <span class="platform-icon" v-else-if="item.source === '抖音'">
                      <svg viewBox="0 0 1024 1024" width="16" height="16">
                        <path d="M937.4 423.9c-84 0-165.7-27.3-232.9-77.8v352.3c0 179.9-138.6 325.9-309.6 325.9S85.3 878.3 85.3 698.4c0-179.9 138.6-325.9 309.6-325.9 17.1 0 33.7 1.5 49.9 4.3v186.6c-15.5-6.1-32-9.2-49.9-9.2-76.3 0-138.2 65-138.2 144.2 0 79.2 61.9 144.2 138.2 144.2 76.2 0 138.1-65 138.2-144.1l1.4-620.1h169.8c15.5 99.4 86.8 177.4 177.4 201.5v144z" fill="#FF004F"></path>
                        <path d="M585.8 376.1v-144C495.2 208 423.9 130 408.4 30.6h-169.8l-1.4 620.1c-0.1 79.1-62 144.1-138.2 144.1-76.3 0-138.2-65-138.2-144.2 0-79.2 61.9-144.2 138.2-144.2 17.9 0 34.4 3.1 49.9 9.2V329c-16.2-2.8-32.8-4.3-49.9-4.3-171 0-309.6 146-309.6 325.9S77.4 976 248.4 976s309.6-146 309.6-325.9V297.8c67.2 50.5 148.9 77.8 232.9 77.8v-144c-90.6-24.1-161.9-102.1-177.4-201.5h-28.1c14.4 95.5 82.5 171.8 175.5 201.5v144.5z" fill="#FF004F" opacity=".03"></path>
                        <path d="M585.8 376.1v-144C492.8 202.4 424.7 126.1 410.3 30.6h-2c15.5 99.4 86.8 177.4 177.4 201.5v144z" fill="#FF004F" opacity=".09"></path>
                      </svg>
                    </span>
                    <span class="platform-icon" v-else-if="item.source === 'CSDN'">
                      <svg viewBox="0 0 1024 1024" width="16" height="16">
                        <path d="M512 1024C229.222 1024 0 794.778 0 512S229.222 0 512 0s512 229.222 512 512-229.222 512-512 512z" fill="#CE000D"></path>
                        <path d="M692.651 584.917c-23.936-15.667-50.185-24.873-80.97-24.873-19.226 0-37.556 3.96-52.556 11.09-14.999 7.129-27.951 16.71-38.14 28.445-9.77 11.736-17.448 24.873-23.452 39.185a132.707 132.707 0 0 0-8.29 45.85c0 16.603 2.59 32.084 7.774 46.02 5.183 13.935 13.009 26.23 22.933 36.508 10.344 10.275 22.937 18.349 38.14 24.391 14.785 5.823 32.088 8.89 50.91 8.89 25.58 0 48.517-4.822 66.712-14.463 18.197-9.642 33.982-23.792 46.497-41.863l-57.267-43.174c-4.343 10.275-10.775 17.711-19.485 23.333-8.707 5.824-20.057 8.891-33.018 8.891-16.433 0-29.604-4.604-39.789-13.19-10.184-8.889-16.004-21.309-17.648-37.33h176.888c0.485-3.238 0.924-6.471 1.122-9.48 0.198-3.011 0.34-5.902 0.34-8.913 0-16.602-3.035-32.237-8.927-47.016-5.894-14.785-15.023-27.927-26.774-39.278zM528.156 466.49c-27.95 0-52.036 8.93-71.7 26.612-19.85 17.687-33.25 41.645-40.227 71.457H414.2c-25.146-73.173-93.953-125.969-175.33-125.969-102.17 0-185.12 82.95-185.12 185.12 0 102.173 82.95 185.123 185.12 185.123 82.432 0 152.013-54.03 175.887-128.52h3.537c7.33 30.274 21.268 54.511 41.812 72.274 20.734 17.866 47.508 26.774 80.737 26.774 33.633 0 63.236-10.578 88.127-31.734 24.869-21.159 41.68-50.33 50.33-87.293h-72.051c-3.82 11.737-10.065 20.627-18.775 27.756-8.705 7.334-19.7 10.776-33.01 10.776-17.692 0-30.504-5.362-38.36-16.214-7.771-10.856-11.521-23.342-11.306-37.36h177.848c3.234-6.253 5.187-12.7 7.329-19.05 3.536-9.858 5.357-20.535 5.357-32.288 0-16.604-2.872-32.564-8.503-47.754-5.627-15.196-14.153-28.445-25.36-39.665-11.09-11.219-24.872-20.151-41.3-26.773-16.43-6.822-35.64-10.053-57.062-10.053z m-289.28 65.144c42.81 0 78.198 32.01 83.624 73.368h-34.603c-7.556-22.82-29.02-39.368-54.412-39.368-31.593 0-57.26 25.666-57.26 57.262 0 31.598 25.667 57.266 57.26 57.266 25.346 0 46.82-16.554 54.391-39.371h34.49c-5.358 41.41-40.766 73.374-83.639 73.374-46.303 0-83.881-37.58-83.881-83.885 0-46.306 37.578-83.885 83.881-83.885h0.149v-4.76z m289.303 44.61c14.568 0 25.96 3.798 33.649 11.395 7.604 7.6 12.268 17.63 14.128 30.07h-97.762c1.95-12.482 7.129-22.476 15.667-30.07 8.529-7.597 19.774-11.394 34.317-11.394z" fill="#FFFFFF"></path>
                      </svg>
                    </span>
                    {{ item.source }}
                  </div>
                  <div class="direction-title">{{ item.title }}</div>
                  <el-button type="primary" size="small" @click="openUrl(item.url)">
                    <i class="fas fa-external-link-alt"></i>
                    学习
                  </el-button>
                </div>
              </div>
            </div>
            <div class="empty-directions" v-if="learningDirections.length === 0">
              <i class="fas fa-book-reader"></i>
              <p>暂无学习资源推荐</p>
            </div>
          </div>
        </div>

        <!-- 题目推荐板块 -->
        <div class="learning-path-recommend">
          <h3 class="block-title">
            <i class="fas fa-map-signs"></i>
            题目推荐
          </h3>
          <div class="recommend-container">
            <div class="path-route">
              <div class="route-point" v-for="(item, index) in recommendProblems" :key="index"
                    @click="navigateToProblem(item.problem_number)">
                <div class="point-number" :style="{ background: getPointColor(index) }">{{ index + 1 }}</div>
                <div class="point-content">
                  <div class="problem-title">{{ item.title || '未命名题目' }}</div>
                  <div class="problem-number">题目 #{{ item.problem_number }}</div>
                  <div class="problem-difficulty" v-if="item.difficulty">
                    <el-tag
                      :type="item.difficulty === '简单' ? 'success' : item.difficulty === '中等' ? 'warning' : 'danger'"
                      size="small"
                      effect="dark"
                    >
                      {{ item.difficulty }}
                    </el-tag>
                  </div>
                </div>
                <div
                  class="route-line"
                  v-if="index < recommendProblems.length - 1"
                  :style="{ background: `linear-gradient(to bottom, ${getPointColor(index)}, ${getPointColor(index+1)})` }"
                ></div>
              </div>
              <div class="empty-recommend" v-if="recommendProblems.length === 0">
                <i class="fas fa-clipboard-check"></i>
                <p>暂无题目推荐</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 统计图表区域 -->
      <div class="charts-container">
        <div class="charts-row">
          <!-- 左侧图表 -->
          <div class="chart-column">
            <div class="chart-card">
              <h3>题目完成情况</h3>
              <div id="completionPieChart" class="chart"></div>
            </div>
            <div class="chart-card">
              <h3>提交错误类型分析</h3>
              <div id="errorTypePieChart" class="chart"></div>
            </div>
          </div>

          <!-- 右侧图表 -->
          <div class="chart-column">
            <div class="chart-card">
              <h3>知识点掌握情况</h3>
              <div id="knowledgeRadarChart" class="chart"></div>
            </div>
            <div class="chart-card">
              <h3>解题用时分析</h3>
              <div id="solvingTimeBoxChart" class="chart"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- 题目完成状态表格 -->
      <div class="table-container">
        <h2 class="section-title">题目完成状态</h2>
        <el-table
          v-loading="problemLoading"
          :data="problemList"
          stripe
          style="width: 100%"
          :header-cell-style="{
            background: '#2c2e3b',
            color: '#e6edf3',
            fontSize: '16px',
            padding: '8px 16px',
            fontWeight: 600,
            whiteSpace: 'nowrap'
          }"
          :cell-style="{
            fontSize: '15px',
            padding: '8px 16px',
            color: '#a6accd',
            background: '#1e1e2e',
            textAlign: 'center'
          }"
          :row-style="{
            background: '#252734'
          }"
          :row-class-name="rowClassName"
        >
          <el-table-column prop="problem_number" label="题目序号" width="130" align="center" />
          <el-table-column prop="title" label="题目标题" align="center" />
          <el-table-column prop="difficulty" label="难度" width="100" align="center">
            <template #default="scope">
              <el-tag
                :type="
                  scope.row.difficulty === '简单'
                    ? 'success'
                    : scope.row.difficulty === '中等'
                    ? 'warning'
                    : 'danger'
                "
                effect="plain"
                size="small"
              >
                {{ scope.row.difficulty }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="完成状态" width="130" align="center">
            <template #default="scope">
              <el-tag
                :type="scope.row.status === 'Accepted' ? 'success' : 'info'"
                effect="light"
              >
                {{ scope.row.status === 'Accepted' ? '已完成' : '未完成' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="submission_count" label="提交次数" width="130" align="center" />
        </el-table>

        <div class="pagination-container">
          <el-pagination
            background
            layout="total, prev, pager, next"
            :total="totalProblemsCount"
            :page-size="10"
            :current-page="problemCurrentPage"
            @current-change="handleProblemPageChange"
          />
        </div>
      </div>
    </div>

    <!-- 加载中 -->
    <div v-if="loading" class="loading-container">
      <el-loading :size="32" />
      <p>加载中...</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, onUnmounted } from 'vue'
import NavBar from '@/components/NavBar.vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import * as echarts from 'echarts'
import { useRouter } from 'vue-router'
import { RefreshRight } from '@element-plus/icons-vue'

const router = useRouter()

// 数据状态
const loading = ref(true)
const isStudent = ref(false)
const studentInfo = ref({})
const message = ref('')
const problemLoading = ref(false)
const problemList = ref([])
const totalProblemsCount = ref(0)
const problemCurrentPage = ref(1)

// 图表数据状态
const completionData = ref(null)
const errorTypeData = ref(null)
const knowledgeData = ref(null)
const solvingTimeData = ref(null)

// 学习路径数据
const learningPathLoading = ref(false)
const weaknessAnalysis = ref([])
const learningDirections = ref([])
const recommendProblems = ref([])

// 存储图表实例的引用
const charts = ref({
  completionChart: null,
  errorTypeChart: null,
  knowledgeChart: null,
  solvingTimeChart: null
})

// 刷新学习路径加载状态
const refreshLoading = ref(false)

// 检查用户是否为学生
const checkIsStudent = async () => {
  try {
    const response = await axios.get('/api/user/profile/check-student')
    isStudent.value = response.data.isStudent
    studentInfo.value = response.data.studentInfo || {}

    if (isStudent.value) {
      await fetchUserData()
      await fetchProblemList()
      await fetchLearningPath()
    }
  } catch (error) {
    console.error('检查用户是否为学生失败:', error)
    message.value = error.response?.data?.message || '检查用户身份失败，请稍后再试'
    isStudent.value = false
  } finally {
    loading.value = false
  }
}

// 获取学习路径数据
const fetchLearningPath = async (forceRefresh = false) => {
  learningPathLoading.value = true
  try {
    // 并行请求所有学习路径数据
    const [weaknessRes, directionsRes, recommendRes] = await Promise.all([
      axios.get('/api/learning-path/weakness', { params: { refresh: forceRefresh } }),
      axios.get('/api/learning-path/directions', { params: { refresh: forceRefresh } }),
      axios.get('/api/learning-path/recommend', { params: { refresh: forceRefresh } })
    ])

    weaknessAnalysis.value = weaknessRes.data.data || []

    // 处理学习方向数据，按标签分组
    const directions = directionsRes.data.data || []
    const groupedDirections = {}

    directions.forEach(item => {
      // 根据tag分组
      if (!groupedDirections[item.tag]) {
        groupedDirections[item.tag] = []
      }

      // 添加前缀
      if (item.source === '抖音') {
        item.url = item.url.includes('/search/')
          ? item.url.replace('/search/', '/search/编程')
          : item.url
      } else if (item.source === '哔哩哔哩') {
        item.url = item.url.includes('/search?')
          ? item.url.replace('/search?keyword=', '/search?keyword=编程')
          : item.url
      } else if (item.source === 'CSDN') {
        item.url = item.url.includes('/so/search/')
          ? item.url.replace('/so/search/s.do?q=', '/so/search/s.do?q=编程')
          : item.url
      }

      groupedDirections[item.tag].push(item)
    })

    // 转换为数组格式
    learningDirections.value = Object.entries(groupedDirections).map(([tag, items]) => ({
      tag,
      items
    }))

    recommendProblems.value = recommendRes.data.data || []
  } catch (error) {
    console.error('获取学习路径数据失败:', error)
    ElMessage.error('获取学习路径数据失败，请稍后再试')
  } finally {
    learningPathLoading.value = false
    refreshLoading.value = false
  }
}

// 刷新学习路径
const refreshLearningPath = async () => {
  refreshLoading.value = true
  await fetchLearningPath(true)
  ElMessage.success('学习路径已刷新')
}

// 打开外部学习资源
const openUrl = (url) => {
  window.open(url, '_blank')
}

// 导航到题目页面
const navigateToProblem = (problemNumber) => {
  if (problemNumber) {
    router.push(`/problems/detail/${problemNumber}`)
  }
}

// 获取用户统计数据
const fetchUserData = async () => {
  try {
    // 并行请求所有数据
    const [completionResponse, knowledgeResponse, errorTypeResponse, solvingTimeResponse] = await Promise.all([
      axios.get('/api/user/profile/completion'),
      axios.get('/api/user/profile/knowledge'),
      axios.get('/api/user/profile/error-types'),
      axios.get('/api/user/profile/solving-time')
    ])

    completionData.value = completionResponse.data.data
    knowledgeData.value = knowledgeResponse.data.data
    errorTypeData.value = errorTypeResponse.data.data
    solvingTimeData.value = solvingTimeResponse.data.data

    // 初始化图表
    nextTick(() => {
      initCharts()
    })
  } catch (error) {
    console.error('获取用户统计数据失败:', error)
    ElMessage.error('获取统计数据失败，请稍后再试')
  }
}

// 获取题目列表
const fetchProblemList = async () => {
  problemLoading.value = true
  try {
    const response = await axios.get('/api/user/profile/problems', {
      params: {
        page: problemCurrentPage.value,
        pageSize: 10
      }
    })

    problemList.value = response.data.data || []
    totalProblemsCount.value = response.data.total || 0
  } catch (error) {
    console.error('获取题目列表失败:', error)
    ElMessage.error('获取题目列表失败，请稍后再试')
  } finally {
    problemLoading.value = false
  }
}

// 初始化图表
const initCharts = () => {
  // 销毁之前的图表实例
  Object.values(charts.value).forEach(chart => {
    if (chart) {
      chart.dispose()
    }
  })

  // 确保 DOM 元素存在后再初始化图表
  const completionElement = document.getElementById('completionPieChart')
  const errorTypeElement = document.getElementById('errorTypePieChart')
  const knowledgeElement = document.getElementById('knowledgeRadarChart')
  const solvingTimeElement = document.getElementById('solvingTimeBoxChart')

  // 只在 DOM 元素存在时初始化图表
  if (completionElement) {
    charts.value.completionChart = echarts.init(completionElement)
  }
  if (errorTypeElement) {
    charts.value.errorTypeChart = echarts.init(errorTypeElement)
  }
  if (knowledgeElement) {
    charts.value.knowledgeChart = echarts.init(knowledgeElement)
  }
  if (solvingTimeElement) {
    charts.value.solvingTimeChart = echarts.init(solvingTimeElement)
  }

  // 设置题目完成情况饼图
  if (completionData.value && charts.value.completionChart) {
    const pieData = [
      { name: '已完成', value: completionData.value.completed_problems || 0 },
      { name: '未尝试', value: completionData.value.not_attempted_problems || 0 },
      { name: '失败', value: completionData.value.failed_problems || 0 }
    ]

    const colorPalette = ['#67C23A', '#409EFF', '#F56C6C']

    charts.value.completionChart.setOption({
      backgroundColor: 'transparent',
      color: colorPalette,
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c} ({d}%)',
        backgroundColor: 'rgba(50, 50, 50, 0.9)',
        borderColor: '#555',
        textStyle: {
          color: '#fff'
        }
      },
      legend: {
        orient: 'vertical',
        left: 'left',
        textStyle: {
          color: '#e6edf3'
        }
      },
      series: [{
        name: '题目完成情况',
        type: 'pie',
        radius: '50%',
        data: pieData,
        emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } },
        label: {
          color: '#ffffff',
          formatter: '{b}: {d}%'
        },
        labelLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.5)'
          }
        }
      }]
    })
  }

  // 设置错误类型分析饼图
  if (errorTypeData.value && charts.value.errorTypeChart) {
    const errorData = (errorTypeData.value || []).map(item => ({
      name: item.error_type || '未知错误',
      value: item.count || 0
    }))

    const colorPalette = ['#F56C6C', '#E6A23C', '#409EFF', '#67C23A', '#909399', '#FFEB3B']

    charts.value.errorTypeChart.setOption({
      backgroundColor: 'transparent',
      color: colorPalette,
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c} ({d}%)',
        backgroundColor: 'rgba(50, 50, 50, 0.9)',
        borderColor: '#555',
        textStyle: {
          color: '#fff'
        }
      },
      legend: {
        orient: 'vertical',
        left: 'left',
        textStyle: {
          color: '#e6edf3'
        },
        formatter: function (name) {
          // 如果名称太长，截断并加上省略号
          return name.length > 8 ? name.substring(0, 8) + '...' : name
        }
      },
      series: [{
        name: '错误类型',
        type: 'pie',
        radius: '50%',
        data: errorData.length > 0 ? errorData : [{ name: '暂无数据', value: 1 }],
        emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } },
        label: {
          color: '#ffffff',
          formatter: '{b}: {d}%'
        },
        labelLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.5)'
          }
        }
      }]
    })
  }

  // 设置知识点掌握情况雷达图
  if (knowledgeData.value && charts.value.knowledgeChart) {
    let data = knowledgeData.value || []

    // 确保有数据，否则提供默认数据
    if (data.length === 0) {
      data = [
        { knowledge_point: '暂无数据', mastery_percentage: 0 }
      ]
    }

    const indicators = data.map(item => ({
      name: item.knowledge_point || '未知知识点',
      max: 100
    }))

    const values = data.map(item => item.mastery_percentage || 0)

    // 防止雷达图在无数据时出错，确保至少有3个指标点
    if (indicators.length < 3) {
      while (indicators.length < 3) {
        indicators.push({ name: `示例${indicators.length + 1}`, max: 100 })
        values.push(0)
      }
    }

    charts.value.knowledgeChart.setOption({
      backgroundColor: 'transparent',
      tooltip: {
        trigger: 'axis',
        backgroundColor: 'rgba(50, 50, 50, 0.9)',
        borderColor: '#555',
        textStyle: {
          color: '#fff'
        }
      },
      radar: {
        indicator: indicators,
        shape: 'circle',
        center: ['50%', '50%'],
        radius: '60%',
        splitNumber: 5,
        axisName: {
          color: '#e6edf3',
          formatter: function (value) {
            if (value.length > 6) {
              return value.substring(0, 6) + '...'
            }
            return value
          }
        },
        splitArea: {
          show: true,
          areaStyle: {
            color: ['rgba(255, 255, 255, 0.05)', 'rgba(255, 255, 255, 0.1)']
          }
        },
        splitLine: {
          show: true,
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.2)'
          }
        },
        axisLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.3)'
          }
        }
      },
      series: [{
        type: 'radar',
        data: [{
          value: values,
          name: '知识点掌握度',
          symbolSize: 4,
          lineStyle: {
            width: 2,
            color: '#409EFF'
          },
          areaStyle: {
            opacity: 0.3,
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(64, 158, 255, 0.7)' },
              { offset: 1, color: 'rgba(64, 158, 255, 0.1)' }
            ])
          },
          label: {
            show: true,
            formatter: '{c}%',
            color: '#fff'
          }
        }]
      }]
    })
  }

  // 设置解题用时分析柱状图 - 完全按照statistics.vue的实现方式
  if (solvingTimeData.value && charts.value.solvingTimeChart) {
    const data = solvingTimeData.value || []

    // 确保有数据，否则提供默认数据
    const chartData = data.length > 0
      ? data
      : [
          { difficulty: '简单', avg_time: 0 },
          { difficulty: '中等', avg_time: 0 },
          { difficulty: '困难', avg_time: 0 }
        ]

    charts.value.solvingTimeChart.setOption({
      backgroundColor: 'transparent',
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'shadow'
        },
        backgroundColor: 'rgba(50, 50, 50, 0.9)',
        borderColor: '#555',
        textStyle: {
          color: '#fff'
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
        data: chartData.map(item => item.difficulty),
        axisLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.3)'
          }
        },
        axisLabel: {
          color: '#e6edf3'
        }
      },
      yAxis: {
        type: 'value',
        name: '解题时间（分钟）',
        nameTextStyle: {
          color: '#e6edf3'
        },
        axisLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.3)'
          }
        },
        axisLabel: {
          color: '#e6edf3'
        },
        splitLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.1)'
          }
        }
      },
      series: [
        {
          name: '平均用时',
          type: 'bar',
          barWidth: '60%',
          itemStyle: {
            color: function (params) {
              const colors = {
                简单: '#67C23A',
                中等: '#E6A23C',
                困难: '#F56C6C'
              }
              return colors[params.name] || '#409EFF'
            }
          },
          data: chartData.map(item => item.avg_time),
          label: {
            show: true,
            position: 'top',
            formatter: '{c} 分钟',
            color: '#e6edf3'
          }
        }
      ]
    })
  }
}

// 事件处理函数
const handleResize = () => {
  Object.values(charts.value).forEach(chart => {
    if (chart && typeof chart.resize === 'function') {
      try {
        chart.resize()
      } catch (error) {
        console.warn('图表重置大小时发生错误:', error)
      }
    }
  })
}

// 处理题目列表分页变化
const handleProblemPageChange = (page) => {
  problemCurrentPage.value = page
  fetchProblemList()
}

// 生命周期钩子
onMounted(() => {
  checkIsStudent()
  window.addEventListener('resize', handleResize)
})

// 表格行样式
const rowClassName = ({ rowIndex }) => {
  return rowIndex % 2 === 0 ? 'dark-row' : 'darker-row'
}

// 组件卸载时移除事件监听
onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  Object.values(charts.value).forEach(chart => {
    if (chart) {
      chart.dispose()
    }
  })
})

// 格式化内容，支持换行符和基本Markdown风格
const formatContent = (content) => {
  if (!content) return ''

  // 处理换行符
  let formatted = content.replace(/\n/g, '<br>')

  // 处理markdown风格的粗体
  formatted = formatted.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')

  // 处理markdown风格的列表
  formatted = formatted.replace(/- (.*?)(<br>|$)/g, '<li>$1</li>')

  // 如果有列表项，添加ul标签
  if (formatted.includes('<li>')) {
    formatted = formatted.replace(/(<li>.*?<\/li>)+/g, '<ul>$&</ul>')
  }

  return formatted
}

// 根据索引获取不同颜色
const getPointColor = (index) => {
  const colors = ['#2196F3', '#FF5722', '#4CAF50', '#9C27B0', '#FF9800', '#03A9F4', '#E91E63']
  return colors[index % colors.length]
}
</script>

<style scoped>
.personal-center {
  min-height: 100vh;
  background-color: #0d1117;
  color: white;
}

.content-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
}

.student-notice {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 70px); /* 减去导航栏高度 */
  padding: 20px;
}

.notice-content {
  background: #1e1e2e;
  padding: 2.5rem;
  border-radius: 1rem;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  max-width: 90%;
  width: 400px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.notice-icon {
  font-size: 3.5rem;
  color: #f56c6c;
  margin-bottom: 1.5rem;
}

.notice-content h2 {
  color: #e6edf3;
  margin-bottom: 1rem;
  font-size: 1.75rem;
  font-weight: 600;
}

.notice-content p {
  color: #a6accd;
  margin-bottom: 2rem;
  font-size: 1.1rem;
  line-height: 1.5;
}

.back-home-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  background: linear-gradient(135deg, #2196f3, #1976d2);
  color: white;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.3s ease;
  border: none;
  font-size: 1rem;
}

.back-home-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(33, 150, 243, 0.3);
  background: linear-gradient(135deg, #1e88e5, #1565c0);
}

.profile-section {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 24px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.profile-header {
  display: flex;
  align-items: center;
}

.profile-avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: rgba(33, 150, 243, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 24px;
  font-size: 30px;
  color: #2196f3;
}

.profile-info {
  flex: 1;
}

.profile-info h2 {
  font-size: 24px;
  margin-bottom: 16px;
  color: #e6edf3;
}

.info-items {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}

.info-item {
  display: flex;
  align-items: center;
  color: #a6accd;
}

.info-item i {
  margin-right: 8px;
  color: #2196f3;
}

.completion-stats {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-left: 24px;
}

.completion-text {
  margin-top: 12px;
  color: #67C23A;
  font-weight: bold;
}

.learning-path-section {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 24px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.section-title {
  font-size: 20px;
  font-weight: 600;
  color: #e6edf3;
  margin: 0;
}

.block-title {
  font-size: 18px;
  color: #a6accd;
  margin-bottom: 16px;
  display: flex;
  align-items: center;
}

.block-title i {
  margin-right: 8px;
  color: #409EFF;
}

.card-container {
  display: flex;
  gap: 16px;
  overflow-x: auto;
  padding: 4px;
  margin-bottom: 24px;
}

.weakness-card {
  min-width: 300px;
  background: #252734;
  border-radius: 8px;
  padding: 16px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.3s ease;
}

.weakness-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
  border-color: rgba(33, 150, 243, 0.3);
}

.card-header {
  margin-bottom: 12px;
}

.tag-badge {
  display: inline-block;
  background: linear-gradient(135deg, #2196f3, #1976d2);
  color: white;
  padding: 6px 10px;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
}

.card-content {
  color: #a6accd;
  font-size: 14px;
  line-height: 1.5;
}

.card-content :deep(p) {
  margin: 0;
}

.card-content :deep(ul) {
  padding-left: 20px;
  margin: 8px 0;
}

.card-content :deep(li) {
  margin-bottom: 4px;
}

.card-content :deep(strong) {
  color: #e6edf3;
  font-weight: 600;
}

.empty-weakness {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 0;
  width: 100%;
  color: #a6accd;
}

.empty-weakness i {
  font-size: 48px;
  color: #67C23A;
  margin-bottom: 16px;
}

.directions-container {
  width: 100%;
  display: block;
}

.direction-group-card {
  width: 100%;
  background: #252734;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 24px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.direction-group-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
  border-color: rgba(33, 150, 243, 0.3);
}

.direction-group-header {
  margin-bottom: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding-bottom: 12px;
}

.direction-group-tag {
  display: inline-block;
  background: linear-gradient(135deg, #2196f3, #1976d2);
  color: white;
  padding: 8px 16px;
  border-radius: 4px;
  font-size: 16px;
  font-weight: 500;
}

.direction-items {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  width: 100%;
}

.direction-card {
  flex: 1;
  min-width: 220px;
  max-width: calc(33.33% - 16px);
  background: #1e1e2e;
  border-radius: 8px;
  padding: 12px;
  display: flex;
  flex-direction: column;
  border: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.3s ease;
}

.direction-card:hover {
  background: #2d3748;
  border-color: rgba(33, 150, 243, 0.3);
  transform: translateY(-2px);
}

.direction-source {
  font-size: 12px;
  color: #67C23A;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
}

.platform-icon {
  display: inline-flex;
  align-items: center;
  margin-right: 5px;
}

.direction-title {
  font-size: 16px;
  color: #e6edf3;
  margin-bottom: 16px;
  flex-grow: 1;
}

.empty-directions {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  grid-column: 1 / -1;
  padding: 40px 0;
  color: #a6accd;
}

.empty-directions i {
  font-size: 48px;
  color: #E6A23C;
  margin-bottom: 16px;
}

.recommend-container {
  margin-bottom: 24px;
}

.path-route {
  display: flex;
  flex-direction: column;
  gap: 12px;
  position: relative;
  padding: 20px;
  background: #252734;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.route-point {
  display: flex;
  align-items: flex-start;
  cursor: pointer;
  padding: 16px;
  border-radius: 12px;
  transition: all 0.3s ease;
  position: relative;
  background: rgba(30, 30, 46, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.route-point:hover {
  background: rgba(45, 55, 72, 0.8);
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.point-number {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  margin-right: 16px;
  z-index: 1;
  font-size: 18px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
}

.point-content {
  flex-grow: 1;
  padding: 4px 0;
}

.problem-title {
  font-size: 18px;
  color: #e6edf3;
  font-weight: 600;
  margin-bottom: 8px;
}

.problem-number {
  font-size: 14px;
  color: #a6accd;
  margin-bottom: 8px;
}

.problem-difficulty {
  margin-top: 4px;
}

.route-line {
  position: absolute;
  left: 28px;
  top: 52px;
  width: 2px;
  height: calc(100% - 20px);
  z-index: 0;
}

.empty-recommend {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 0;
  color: #a6accd;
}

.empty-recommend i {
  font-size: 48px;
  color: #F56C6C;
  margin-bottom: 16px;
}

.charts-container {
  margin: 24px 0;
}

.charts-row {
  display: flex;
  gap: 24px;
  margin-bottom: 24px;
}

.chart-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.chart-card {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.chart-card h3 {
  margin: 0 0 16px 0;
  color: #e6edf3;
  font-size: 18px;
  font-weight: 600;
}

.chart {
  height: 300px;
  width: 100%;
}

.table-container {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.2);
  margin-bottom: 24px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.loading-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 70px);
  color: #e6edf3;
}

/* 响应式调整 */
@media (max-width: 992px) {
  .charts-row {
    flex-direction: column;
  }

  .profile-header {
    flex-direction: column;
    text-align: center;
  }

  .profile-avatar {
    margin-right: 0;
    margin-bottom: 20px;
  }

  .profile-info {
    margin-bottom: 20px;
  }

  .info-items {
    grid-template-columns: 1fr;
  }

  .completion-stats {
    margin-left: 0;
  }

  .direction-card {
    max-width: 100%;
  }

  .card-container {
    flex-direction: column;
  }

  .weakness-card {
    width: auto;
    min-width: 0;
  }
}

.el-table {
  --el-table-border-color: #30363d;
  --el-table-border: 1px solid var(--el-table-border-color);
  --el-table-text-color: #e6edf3;
  --el-table-header-text-color: #e6edf3;
  --el-table-row-hover-background-color: #2d3748;

  border-radius: 8px;
  overflow: hidden;
  border: var(--el-table-border);
}

.dark-row {
  background-color: #252734 !important;
}

.darker-row {
  background-color: #1e1e2e !important;
}

.el-table__body tr:hover > td {
  background-color: #2d3748 !important;
}

.el-pagination {
  margin-top: 20px;
  --el-pagination-bg-color: #252734;
  --el-pagination-text-color: #e6edf3;
  --el-pagination-button-color: #a6accd;
  --el-pagination-hover-color: #409EFF;
}

/* 确保表格内容居中 */
.el-table .cell {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 分页容器 */
.pagination-container {
  margin-top: 24px;
  display: flex;
  justify-content: center;
}

.refresh-btn {
  display: flex;
  align-items: center;
  gap: 5px;
}
</style>
