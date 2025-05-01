import axios from 'axios'
import store from '@/store'

// 创建用于学习计划的API服务
const learningPlansApi = {
  // 获取所有学习计划
  getAllPlans: async () => {
    try {
      const response = await axios.get('/api/learning-plans')
      return response.data
    } catch (error) {
      console.error('获取学习计划列表失败:', error)
      throw error
    }
  },

  // 获取特定学习计划详情
  getPlanDetails: async (planId) => {
    try {
      const response = await axios.get(`/api/learning-plans/${planId}`)
      return response.data
    } catch (error) {
      console.error(`获取学习计划(ID: ${planId})详情失败:`, error)
      throw error
    }
  },

  // 获取学习计划的题目列表
  getPlanProblems: async (planId) => {
    try {
      const response = await axios.get(`/api/learning-plans/${planId}/problems`)
      return response.data
    } catch (error) {
      console.error(`获取学习计划(ID: ${planId})题目失败:`, error)
      throw error
    }
  },

  // 获取用户在学习计划中的进度
  getUserProgress: async (planId) => {
    try {
      // 首先尝试从Vuex store获取token
      const storeToken = store.getters.getAccessToken
      // 然后尝试从localStorage获取
      const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
      const localToken = userInfo.token || userInfo.accessToken
      // 使用store中的token优先，如果没有则使用localStorage中的token
      const token = storeToken || localToken
      if (!token) {
        console.log('获取进度失败：用户未登录')
        return null
      }

      const headers = { Authorization: `Bearer ${token}` }
      const response = await axios.get(`/api/learning-plans/${planId}/progress`, { headers })
      return response.data
    } catch (error) {
      console.error(`获取学习计划(ID: ${planId})进度失败:`, error)
      throw error
    }
  }
}

export default learningPlansApi
