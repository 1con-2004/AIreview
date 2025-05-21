import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import store from '@/store'

/**
 * [API配置] 根据环境变量确定baseURL
 * 封装环境变量逻辑，支持开发环境和生产环境
 */
const getBaseUrl = () => {
  // 本地开发环境强制使用/api路径
  return '/api'
}

/**
 * [API配置] 创建axios实例
 * 统一管理API请求配置
 */
const apiService = axios.create({
  baseURL: getBaseUrl(),
  timeout: 120000
})

/**
 * [API路径] API路径构建函数
 * 用于构建API请求路径，处理不同环境下的路径差异
 */
export const getApiUrl = (path) => {
  // 确保path不以/开头，避免重复
  const cleanPath = path.startsWith('/') ? path.slice(1) : path

  // 检查cleanPath是否已经包含api前缀，如果是，不要添加/api
  if (cleanPath.startsWith('api/')) {
    return `/${cleanPath}`
  }

  // 始终使用相对路径
  return `/api/${cleanPath}`
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
  // 移除public/前缀，因为资源文件在静态目录中不包含此前缀
  let processedPath = cleanPath
  if (processedPath.startsWith('public/')) {
    processedPath = processedPath.replace('public/', '')
    console.log(`移除public/前缀，处理后的路径: ${processedPath}`)
  }

  // 添加调试日志，帮助定位问题
  console.log(`构建资源URL，原始路径: ${path}, 清理后: ${processedPath}`)

  // 获取配置的资源基础URL
  const resourceBaseUrl = process.env.VUE_APP_RESOURCE_BASE_URL || ''
  // 处理不同类型的资源路径
  if (processedPath.includes('uploads/avatars/')) {
    // 获取用户认证令牌
    const accessToken = localStorage.getItem('accessToken') || 
      (localStorage.getItem('userInfo') ? 
        JSON.parse(localStorage.getItem('userInfo')).accessToken || 
        JSON.parse(localStorage.getItem('userInfo')).token : 
        null)

    // 使用API访问静态资源以便携带认证令牌
    if (accessToken && window.location.hostname !== 'localhost') {
      // 提取文件名
      const fileName = processedPath.split('/').pop().split('?')[0]
      // 使用API端点访问头像
      return `/api/uploads/avatars/${fileName}?t=${Date.now()}`
    }

    // 本地环境或无令牌时使用普通路径
    // 添加时间戳避免缓存问题
    if (processedPath.includes('?t=')) {
      return `${resourceBaseUrl}/${processedPath}`
    } else {
      return `${resourceBaseUrl}/${processedPath}?t=${Date.now()}`
    }
  } else if (processedPath.includes('icons/')) {
    // 图标资源使用相对路径
    return `${resourceBaseUrl}/${processedPath}`
  } else if (processedPath.includes('public/')) {
    // 处理public目录下的资源
    const fileName = processedPath.split('/').pop()
    const dirPath = processedPath.split('/').slice(-2, -1)[0]
    return `${resourceBaseUrl}/${dirPath}/${fileName}`
  }

  // 默认使用相对路径
  return `${resourceBaseUrl}/${processedPath}`
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

    // 增强令牌获取逻辑，从多个位置尝试获取令牌
    let accessToken = null
    // 先从localStorage直接获取accessToken
    const directToken = localStorage.getItem('accessToken')
    if (directToken) {
      accessToken = directToken
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 从localStorage直接获取到令牌`)
    }
    // 如果直接获取失败，尝试从userInfo获取
    else {
      const userInfoStr = localStorage.getItem('userInfo')
      if (userInfoStr) {
        try {
          const userInfo = JSON.parse(userInfoStr)
          if (userInfo.accessToken) {
            accessToken = userInfo.accessToken
            console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 从userInfo中获取到令牌，用户: ${userInfo.username || '未知'}`)
            // 同步到localStorage中的独立令牌项
            localStorage.setItem('accessToken', userInfo.accessToken)
          }
        } catch (e) {
          console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 解析localStorage中userInfo出错:`, e)
        }
      }
    }
    // 如果找到令牌，添加到请求头
    if (accessToken) {
      config.headers.Authorization = `Bearer ${accessToken}`
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 添加认证令牌到请求头`)
    } else {
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 未找到认证令牌`)
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
  async error => {
    console.error('请求错误:', error)

    // 如果是401错误，可能是token过期
    if (error.response && error.response.status === 401) {
      console.log('[前端日志] 捕获到401错误，尝试刷新令牌')

      // 尝试刷新token
      const refreshToken = localStorage.getItem('refreshToken') || 
                        (localStorage.getItem('userInfo') ? 
                         JSON.parse(localStorage.getItem('userInfo')).refreshToken : null)
      
      // 如果没有refreshToken，直接跳转登录页
      if (!refreshToken) {
        console.error('[前端日志] 无法刷新令牌：refreshToken不存在')
        ElMessage.error('登录已过期，请重新登录')
        store.dispatch('logout')
        router.push('/login')
        return Promise.reject(error)
      }

      try {
        // 尝试使用refreshToken获取新的accessToken
        console.log('[前端日志] 开始刷新令牌')
        const result = await refreshAccessToken(refreshToken)
        
        if (result.success) {
          console.log('[前端日志] 令牌刷新成功，重新发送原始请求')
          const { accessToken, refreshToken: newRefreshToken } = result.data
          
          // 更新本地存储的token
          localStorage.setItem('accessToken', accessToken)
          localStorage.setItem('refreshToken', newRefreshToken)
          
          // 更新userInfo中的token
          const userInfoStr = localStorage.getItem('userInfo')
          if (userInfoStr) {
            const userInfo = JSON.parse(userInfoStr)
            userInfo.accessToken = accessToken
            userInfo.refreshToken = newRefreshToken
            localStorage.setItem('userInfo', JSON.stringify(userInfo))
          }
          
          // 更新Vuex中的token
          store.dispatch('updateTokens', { accessToken, refreshToken: newRefreshToken })
          
          // 使用新的token重新发送之前失败的请求
          error.config.headers.Authorization = `Bearer ${accessToken}`
          return apiService(error.config)
        } else {
          console.error('[前端日志] 令牌刷新失败:', result.message)
          throw new Error(result.message || '令牌刷新失败')
        }
      } catch (refreshError) {
        console.error('[前端日志] 令牌刷新异常:', refreshError)
        ElMessage.error('登录已过期，请重新登录')
        store.dispatch('logout')
        router.push('/login')
      }
    }

    return Promise.reject(error)
  }
)

/**
 * [令牌刷新] 刷新访问令牌
 * 当访问令牌过期时使用刷新令牌获取新的访问令牌
 */
async function refreshAccessToken(refreshToken) {
  try {
    console.log('[前端日志] 发送刷新令牌请求')
    // 创建一个新的axios实例用于刷新令牌，避免循环拦截
    const refreshResponse = await axios.post('/api/login/refresh-token', { refresh_token: refreshToken })
    
    console.log('[前端日志] 刷新令牌响应:', refreshResponse.data)
    return refreshResponse.data
  } catch (error) {
    console.error('[前端日志] 刷新令牌请求失败:', error)
    throw error
  }
}

export default apiService
