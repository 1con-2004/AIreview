import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import store from '@/store'

/**
 * [API配置] 根据环境变量确定baseURL
 * 封装环境变量逻辑，支持开发环境和生产环境
 */
const getBaseUrl = () => {
  // 始终使用相对路径，确保通过Nginx代理
  return process.env.VUE_APP_BASE_API || '/api'

  // 注释掉以下代码，防止使用硬编码的localhost地址
  // 开发环境使用localhost
  // return process.env.VUE_APP_BASE_API || 'http://localhost:3000'
}

/**
 * [API配置] 创建axios实例
 * 统一管理API请求配置
 */
const apiService = axios.create({
  baseURL: getBaseUrl(),
  timeout: 15000
})

/**
 * [API路径] API路径构建函数
 * 用于构建API请求路径，处理不同环境下的路径差异
 */
export const getApiUrl = (path) => {
  // 确保path不以/开头，避免重复
  const cleanPath = path.startsWith('/') ? path.slice(1) : path

  // 始终使用相对路径
  return `${process.env.VUE_APP_BASE_API || '/api'}/${cleanPath}`

  // 注释掉以下代码，防止使用硬编码的localhost地址
  // 如果使用相对路径，直接返回相对路径
  // if (process.env.VUE_APP_USE_RELATIVE_PATH === 'true') {
  //   // 如果VUE_APP_BASE_API已经包含/api前缀，则不需要再添加
  //   return `${process.env.VUE_APP_BASE_API}/${cleanPath}`
  // }

  // 开发环境返回完整URL
  // return `${process.env.VUE_APP_BASE_API || 'http://localhost:3000'}/${cleanPath}`
}

/**
 * [资源路径] 资源URL构建函数
 * 用于构建图片等静态资源的URL
 */
export const getResourceUrl = (path) => {
  if (!path) return ''

  // 如果已经是完整URL，直接返回
  if (path.startsWith('http')) {
    return path
  }

  // 确保path不以/开头，避免重复
  const cleanPath = path.startsWith('/') ? path.slice(1) : path

  // 始终使用相对路径
  return `/${cleanPath}`

  // 注释掉以下代码，防止使用硬编码的localhost地址
  // 如果使用相对路径
  // if (process.env.VUE_APP_USE_RELATIVE_PATH === 'true') {
  //   // 如果path已经包含/uploads等前缀，则直接返回
  //   return `/${cleanPath}`
  // }

  // 开发环境返回完整URL
  // return `${process.env.VUE_APP_BASE_API || 'http://localhost:3000'}/${cleanPath}`
}

/**
 * [请求拦截] 请求拦截器
 * 在发送请求前添加认证令牌和请求日志
 */
apiService.interceptors.request.use(
  config => {
    const requestId = `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
    config.requestId = requestId

    console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 发送请求: ${config.method.toUpperCase()} ${config.url}`)

    // 从localStorage获取token并添加到请求头
    const userInfoStr = localStorage.getItem('userInfo')
    if (userInfoStr) {
      try {
        const userInfo = JSON.parse(userInfoStr)
        if (userInfo.accessToken) {
          config.headers.Authorization = `Bearer ${userInfo.accessToken}`
          console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 添加认证令牌，用户: ${userInfo.username || '未知'}`)
        }
      } catch (e) {
        console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 解析localStorage中userInfo出错:`, e)
      }
    }

    return config
  },
  error => {
    console.error(`[前端日志] [${new Date().toISOString()}] 请求错误:`, error)
    return Promise.reject(error)
  }
)

/**
 * [响应拦截] 响应拦截器
 * 统一处理响应数据和错误
 */
apiService.interceptors.response.use(
  response => {
    const requestId = response.config.requestId
    console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 收到响应: ${response.status}`)

    const res = response.data
    return res
  },
  error => {
    console.error('请求错误:', error)

    // 如果是401错误，可能是token过期
    if (error.response && error.response.status === 401) {
      // 这里可以添加token刷新逻辑
      ElMessage.error('登录已过期，请重新登录')
      store.dispatch('logout')
      router.push('/login')
    }

    return Promise.reject(error)
  }
)

export default apiService
