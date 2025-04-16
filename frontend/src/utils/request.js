import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import store from '@/store'

// 创建axios实例
const service = axios.create({
  baseURL: process.env.VUE_APP_BASE_API || 'http://localhost:3000',
  timeout: 15000
})

// 是否正在刷新token
let isRefreshing = false
// 重试队列
let requests = []

// 请求拦截器
service.interceptors.request.use(
  config => {
    // 从store中获取token
    const token = store.getters.getAccessToken || localStorage.getItem('accessToken')
    
    // 如果有token则添加到请求头
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`
    }
    
    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  response => {
    // 直接返回后端数据
    return response.data;
  },
  async error => {
    const originalRequest = error.config

    // 如果是401错误且错误代码为TOKEN_EXPIRED，尝试刷新token
    if (error.response?.status === 401 && 
        error.response?.data?.code === 'TOKEN_EXPIRED' && 
        !originalRequest._retry) {
      
      if (isRefreshing) {
        // 如果正在刷新，将请求添加到队列
        return new Promise(resolve => {
          requests.push(token => {
            originalRequest.headers['Authorization'] = `Bearer ${token}`
            resolve(service(originalRequest))
          })
        })
      }

      originalRequest._retry = true
      isRefreshing = true

      try {
        const refreshToken = store.getters.getRefreshToken
        if (!refreshToken) {
          throw new Error('No refresh token')
        }

        const response = await service.post('/api/login/refresh-token', {
          refreshToken
        })

        const { accessToken } = response.data
        store.dispatch('updateTokens', { 
          accessToken,
          refreshToken: store.getters.getRefreshToken 
        })

        // 重试所有请求
        requests.forEach(cb => cb(accessToken))
        requests = []

        return service(originalRequest)
      } catch (refreshError) {
        console.error('刷新token失败:', refreshError)
        store.dispatch('logout')
        router.push('/login')
        ElMessage({
          message: '登录已过期，请重新登录',
          type: 'error',
          duration: 5 * 1000
        })
        return Promise.reject(refreshError)
      } finally {
        isRefreshing = false
      }
    }

    // 其他错误
    console.error('响应错误:', error)
    const errorMsg = error.response?.data?.message || 
                    error.response?.data?.error || 
                    error.message || 
                    '请求失败'
    ElMessage({
      message: errorMsg,
      type: 'error',
      duration: 5 * 1000
    })
    return Promise.reject(error)
  }
)

export default service 