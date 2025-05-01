/* eslint-disable vue/multi-word-component-names */
<template>
  <div class="plan-detail-page">
    <nav-bar></nav-bar>
    <div class="content">
      <!-- 返回按钮 -->
      <div class="back-button" @click="$router.go(-1)">
        <i class="back-icon">←</i>
      </div>

      <!-- 题集信息头部 -->
      <div class="plan-header">
        <div class="plan-icon">
          <img :src="planIcon" :alt="planTitle">
        </div>
        <div class="plan-info">
          <div class="plan-meta">
            <span class="plan-tag">{{ planTag }}</span>
            <h1>{{ planTitle }}</h1>
            <div class="creator-info" v-if="creatorName">
              <span>创建者: {{ creatorName }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="main-content">
        <!-- 左侧题目列表 -->
        <div class="problems-list">
          <div class="problem-cards">
            <div
              v-for="problem in problems"
              :key="problem.id"
              class="problem-card"
              :class="{ 'completed': problem.completed }"
              @click="goToProblem(problem.problem_number)"
            >
              <div class="checkbox">
                <div class="circle" :class="{ 'checked': problem.completed }"></div>
              </div>
              <div class="problem-info">
                <div class="problem-title">
                  <span>{{ problem.title }}</span>
                  <span class="difficulty-tag" :class="problem.difficulty">{{ problem.difficulty }}</span>
                </div>
                <div class="problem-stats">
                  <span class="acceptance-rate">通过率: {{ problem.acceptance_rate || 0 }}%</span>
                  <span class="submission-count">提交: {{ problem.total_submissions || 0 }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 右侧概述 -->
        <div class="overview">
          <div class="overview-card">
            <h2>概述</h2>
            <div class="overview-content">
              <div class="overview-item">
                <i class="overview-icon">📝</i>
                <p>{{ description }}</p>
              </div>
              <div class="overview-points">
                <div v-for="(point, index) in points" :key="index" class="point">
                  • {{ point }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import learningPlansApi from '@/api/learningPlans'
import store from '@/store'

export default {
  name: 'LearningPlanDetail',
  components: {
    NavBar
  },
  data () {
    return {
      planId: null,
      planIcon: '',
      planTag: '',
      planTitle: '',
      description: '',
      points: [],
      problems: [],
      userProgress: null,
      creatorName: ''
    }
  },
  async created () {
    // 从路由参数获取计划ID
    this.planId = this.$route.params.id
    await this.fetchPlanDetails()
    await this.fetchPlanProblems()
    await this.fetchUserProgress()
  },
  methods: {
    async fetchPlanDetails () {
      try {
        console.log('开始获取计划详情，计划ID:', this.planId)

        // 获取学习计划详情
        const response = await learningPlansApi.getPlanDetails(this.planId)
        console.log('获取到的原始响应:', response)

        if (!response || !response.success) {
          console.error('API返回格式不正确:', response)
          throw new Error('获取计划详情失败')
        }

        const plan = response.data
        console.log('处理后的计划数据:', plan)

        // 设置默认图标
        const defaultIcon = '/icons/algorithm.png'

        // 处理图标路径
        this.planIcon = plan.icon
          ? (plan.icon.startsWith('http') ? plan.icon : `${plan.icon.startsWith('/') ? plan.icon : `/${plan.icon}`}`)
          : `${defaultIcon}`

        this.planTag = plan.tag || '算法'
        this.planTitle = plan.title || '学习计划'
        this.description = plan.description || ''
        this.creatorName = plan.creator_name || ''

        // 处理学习要点
        try {
          this.points = Array.isArray(plan.points)
            ? plan.points
            : (plan.points ? JSON.parse(plan.points) : [])
        } catch (e) {
          console.warn('解析points失败，使用默认空数组:', e)
          this.points = []
        }

        console.log('数据处理完成:', {
          planIcon: this.planIcon,
          planTag: this.planTag,
          planTitle: this.planTitle,
          description: this.description,
          points: this.points,
          creatorName: this.creatorName
        })
      } catch (error) {
        console.error('获取计划详情失败:', error)
        ElMessage.error(error.message || '获取计划详情失败，请稍后重试')
      }
    },

    async fetchPlanProblems () {
      try {
        console.log('开始获取计划题目，计划ID:', this.planId)

        // 获取学习路径的题目列表
        const response = await learningPlansApi.getPlanProblems(this.planId)
        console.log('API返回的原始数据:', response)

        if (!response || !response.success) {
          console.error('API返回格式不正确:', response)
          throw new Error('获取计划题目失败')
        }

        const problemsData = response.data
        if (!Array.isArray(problemsData)) {
          console.error('API返回的题目数据不是数组格式:', problemsData)
          throw new Error('题目数据格式错误')
        }

        this.problems = problemsData.map(problem => ({
          id: problem.id,
          problem_number: problem.problem_number,
          title: problem.title,
          difficulty: problem.difficulty,
          completed: problem.status === 'Accepted',
          order_index: problem.order_index || 0,
          section: problem.section || '',
          acceptance_rate: parseFloat(problem.acceptance_rate) || 0,
          total_submissions: parseInt(problem.total_submissions) || 0,
          tags: Array.isArray(problem.tags)
            ? problem.tags
            : (problem.tags ? problem.tags.split(',').map(tag => tag.trim()) : [])
        }))

        console.log('处理后的题目列表:', this.problems)
      } catch (error) {
        console.error('获取计划题目失败:', error)
        ElMessage.error(error.message || '获取计划题目失败，请稍后重试')
      }
    },

    async fetchUserProgress () {
      try {
        console.log('开始获取用户进度...')
        // 首先尝试从Vuex store获取token
        const storeToken = store.getters.getAccessToken
        // 然后尝试从localStorage获取
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        const localToken = userInfo.token || userInfo.accessToken
        // 使用store中的token优先，如果没有则使用localStorage中的token
        const token = storeToken || localToken
        if (!token) {
          console.log('用户未登录，跳过获取进度')
          return
        }

        try {
          // 从学习计划进度API获取数据
          const response = await learningPlansApi.getUserProgress(this.planId)

          console.log('获取到的用户进度数据:', response)

          if (!response || !response.success) {
            throw new Error('获取用户进度失败')
          }

          this.userProgress = response.data

          // 更新题目完成状态
          if (this.userProgress?.completed_problems) {
            const completedSet = new Set(this.userProgress.completed_problems)
            this.problems = this.problems.map(problem => ({
              ...problem,
              completed: problem.completed || completedSet.has(problem.id)
            }))
          }
        } catch (error) {
          console.error('从学习计划获取进度失败，尝试备选方案:', error)

          // 备选方案：从用户题目状态API获取完成数据
          try {
            // 获取所有题目ID
            const problemIds = this.problems.map(p => p.id).filter(id => id)
            if (problemIds.length === 0) return

            const headers = { Authorization: `Bearer ${token}` }
            // 方案1：使用问题状态API
            const problemStatusResponse = await axios.get('/api/problems/user-status', {
              params: { problem_ids: problemIds.join(',') },
              headers
            })

            if (problemStatusResponse.data && problemStatusResponse.data.success) {
              const statusMap = {}
              problemStatusResponse.data.data.forEach(item => {
                if (item.status === 'Accepted') {
                  statusMap[item.problem_id] = true
                }
              })

              // 更新题目完成状态
              this.problems = this.problems.map(problem => ({
                ...problem,
                completed: problem.completed || statusMap[problem.id] || false
              }))

              console.log('备选方案1更新的题目状态:',
                this.problems.filter(p => p.completed).length, '道已完成')
            }
          } catch (fallbackError) {
            console.error('备选方案1失败，尝试备选方案2:', fallbackError)

            // 方案2：使用用户问题状态API
            try {
              const headers = { Authorization: `Bearer ${token}` }
              const userStatusResponse = await axios.get('/api/user/problem-status', { headers })

              if (userStatusResponse.data && userStatusResponse.data.success) {
                const statusMap = {}
                userStatusResponse.data.data.forEach(item => {
                  if (item.status === 'Accepted') {
                    statusMap[item.problem_id] = true
                  }
                })

                // 更新题目完成状态
                this.problems = this.problems.map(problem => ({
                  ...problem,
                  completed: problem.completed || statusMap[problem.id] || false
                }))

                console.log('备选方案2更新的题目状态:',
                  this.problems.filter(p => p.completed).length, '道已完成')
              }
            } catch (finalError) {
              console.error('所有备选方案均失败:', finalError)
            }
          }
        }

        console.log('更新后的题目列表:', this.problems)
      } catch (error) {
        console.error('获取用户进度失败:', error)
        if (error.response?.status === 401) {
          localStorage.removeItem('userInfo')
          ElMessage.error('登录已过期，请重新登录')
        }
      }
    },
    goToProblem (problemNumber) {
      // 跳转到题目详情页面
      this.$router.push(`/problems/detail/${problemNumber}`)
    }
  }
}

</script>

<style scoped>
.plan-detail-page {
  min-height: 100vh;
  background-color: #0d1117;
  color: white;
}

.content {
  padding: 20px 40px;
}

.back-button {
  display: inline-flex;
  align-items: center;
  color: #a6accd;
  cursor: pointer;
  padding: 8px;
  margin-bottom: 20px;
  transition: color 0.3s;
}

.back-button:hover {
  color: #fff;
}

.back-icon {
  font-size: 20px;
  margin-right: 8px;
}

/* 题集头部样式 */
.plan-header {
  display: flex;
  align-items: center;
  gap: 24px;
  margin-bottom: 40px;
}

.plan-icon {
  width: 80px;
  height: 80px;
  border-radius: 12px;
  overflow: hidden;
}

.plan-icon img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.plan-info {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.plan-meta h1 {
  font-size: 24px;
  margin: 8px 0;
}

.plan-tag {
  background: #4ecdc4;
  color: #fff;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 14px;
}

.creator-info {
  margin-top: 8px;
  font-size: 14px;
  color: #a6accd;
}

.creator-info span {
  background-color: rgba(78, 205, 196, 0.1);
  padding: 4px 10px;
  border-radius: 4px;
  color: #4ecdc4;
}

.start-button {
  background: #4ecdc4;
  color: #fff;
  border: none;
  padding: 12px 32px;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.3s;
}

.start-button:hover {
  background: #3dbdb4;
  transform: translateY(-2px);
}

/* 主要内容区域 */
.main-content {
  display: flex;
  gap: 40px;
}

.problems-list {
  flex: 2;
}

.problem-cards {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.problem-card {
  display: flex;
  align-items: center;
  padding: 16px;
  background: #1e1e2d;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.3s ease;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  margin-bottom: 12px;
}

.problem-card:hover {
  transform: translateX(8px);
  border-color: #4ecdc4;
  background: #282836;
}

.problem-card:active {
  transform: translateX(4px);
  background: #242430;
}

.checkbox {
  margin-right: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.circle {
  width: 24px;
  height: 24px;
  border: 2px solid #4ecdc4;
  border-radius: 50%;
  transition: all 0.3s;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}

.circle.checked {
  background: #4ecdc4;
}

.circle.checked::after {
  content: "✓";
  color: white;
  font-size: 16px;
  font-weight: bold;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.problem-card.completed {
  border-left: 4px solid #4ecdc4;
  background: linear-gradient(90deg, rgba(78, 205, 196, 0.1) 0%, rgba(30, 30, 45, 1) 100%);
}

.problem-card.completed .problem-title {
  color: #4ecdc4;
}

.problem-card.completed .circle {
  border-color: #4ecdc4;
  background: #4ecdc4;
}

.problem-info {
  flex: 1;
  margin-left: 8px;
}

.problem-title {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 16px;
  font-weight: 500;
  color: #e6edf3;
  margin-bottom: 4px;
}

.difficulty-tag {
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.difficulty-tag.简单 {
  background: #00af9b;
  color: white;
}

.difficulty-tag.中等 {
  background: #ffb800;
  color: white;
}

.difficulty-tag.困难 {
  background: #ff2d55;
  color: white;
}

.problem-stats {
  display: flex;
  gap: 16px;
  margin-top: 8px;
  font-size: 13px;
  color: #a6accd;
}

.acceptance-rate {
  color: #4ecdc4;
}

.submission-count {
  color: #a6accd;
}

/* 右侧概述 */
.overview {
  flex: 1;
  min-width: 300px;
}

.overview-card {
  background: #1e1e2d;
  border-radius: 8px;
  padding: 24px;
}

.overview-card h2 {
  font-size: 18px;
  margin: 0 0 20px 0;
  color: #fff;
}

.overview-content {
  color: #a6accd;
}

.overview-item {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.overview-icon {
  font-size: 20px;
}

.overview-points {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.point {
  color: #a6accd;
  line-height: 1.6;
}

/* 响应式布局 */
@media (max-width: 1024px) {
  .main-content {
    flex-direction: column;
  }

  .overview {
    min-width: 100%;
  }
}

@media (max-width: 768px) {
  .content {
    padding: 20px;
  }

  .plan-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }

  .plan-info {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }

  .start-button {
    width: 100%;
  }

  .problem-stats {
    flex-direction: column;
    gap: 4px;
  }
}
</style>
