import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import store from '@/store'

// 创建axios实例
const service = axios.create({
  baseURL: '', // 使用空字符串作为baseURL，确保使用相对路径
  timeout: 120000
})

// 设置全局token函数，确保登录后的token同步到全局
export const setGlobalToken = (token) => {
  if (token) {
    console.log('[全局Token] 正在设置全局token:', token.substring(0, 15) + '...')
    // 设置axios全局默认头
    axios.defaults.headers.common.Authorization = `Bearer ${token}`
    // 设置service实例默认头
    service.defaults.headers.common.Authorization = `Bearer ${token}`
    // 保存到localStorage (确保冗余存储)
    localStorage.setItem('accessToken', token)
    console.log('[全局Token] 全局token已设置成功')
    return true
  }
  return false
}

// 是否正在刷新token
let isRefreshing = false
// 重试队列
let requests = []

// 请求拦截器
service.interceptors.request.use(
  config => {
    const requestId = `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
    config.requestId = requestId

    console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 发送请求: ${config.method.toUpperCase()} ${config.url}`)

    // 记录请求数据
    if (config.data) {
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 请求数据:`,
        typeof config.data === 'object' ? JSON.stringify(config.data) : config.data)
    }

    // 记录请求参数
    if (config.params) {
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 请求参数:`, JSON.stringify(config.params))
    }

    // 特别记录 /user/profile/ 相关请求
    if (config.url && config.url.includes('/user/profile/')) {
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] ===用户资料请求===`)
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 请求URL: ${config.url}`)
    }

    // 增强令牌获取逻辑，从多个位置尝试获取令牌
    let accessToken = null

    // 首先检查请求头中是否已设置Authorization (比如在登录时直接设置)
    if (config.headers.Authorization) {
      // 如果已设置则保持不变
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 使用已设置的请求头Authorization`)
      return config
    }

    // 检查直接存储的token (优先使用这个)
    const directToken = localStorage.getItem('accessToken')
    if (directToken) {
      accessToken = directToken
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 从localStorage直接获取到令牌`)
    }
    // 如果直接获取失败，尝试从userInfo获取
    else {
      try {
        const userInfoStr = localStorage.getItem('userInfo')
        if (userInfoStr) {
          const userInfo = JSON.parse(userInfoStr)
          if (userInfo.accessToken) {
            accessToken = userInfo.accessToken
            console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 从userInfo中获取到令牌，用户: ${userInfo.username || '未知'}`)

            // 同步到localStorage中的独立令牌项
            localStorage.setItem('accessToken', userInfo.accessToken)
          }
        }
      } catch (e) {
        console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 解析userInfo出错:`, e)
      }
    }

    // 如果仍未获得token，尝试从Vuex中获取
    if (!accessToken && store.getters.token) {
      accessToken = store.getters.token
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 从Vuex中获取到令牌`)

      // 同步到localStorage
      localStorage.setItem('accessToken', accessToken)
    }
    // 如果找到令牌，添加到请求头
    if (accessToken) {
      config.headers.Authorization = `Bearer ${accessToken}`
      // 同时设置默认请求头，确保后续请求都使用此token
      service.defaults.headers.common.Authorization = `Bearer ${accessToken}`
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 添加认证令牌: Bearer ${accessToken.substring(0, 15)}...`)
      // 获取用户基本信息用于日志记录
      try {
        const userInfoStr = localStorage.getItem('userInfo')
        if (userInfoStr) {
          const userInfo = JSON.parse(userInfoStr)
          console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 当前用户: ${userInfo.username}, 角色: ${userInfo.role}`)
        }
      } catch (e) {
        console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 获取用户信息失败:`, e)
      }
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

// 响应拦截器
service.interceptors.response.use(
  response => {
    const requestId = response.config.requestId || `resp-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
    console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 收到响应: ${response.status} ${response.config.url}`)

    // 特别记录 /user/profile/ 相关响应
    if (response.config.url && response.config.url.includes('/user/profile/')) {
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] ===用户资料响应===`)
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 响应状态: ${response.status}`)
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 响应数据:`, JSON.stringify(response.data))
    }

    const res = response.data

    // 返回成功
    if (res.success === true || response.status === 200) {
      return res
    }

    // 返回失败
    ElMessage.error(res.message || '请求失败')
    return Promise.reject(new Error(res.message || '请求失败'))
  },
  error => {
    const requestId = error.config?.requestId || `err-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
    console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 响应错误:`, error)

    if (error.config?.url && error.config.url.includes('/user/profile/')) {
      console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] ===用户资料请求错误===`)
      console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 请求URL: ${error.config.url}`)
      console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 错误状态: ${error.response?.status}`)
      console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 错误信息: ${error.message}`)
    }

    // 处理401未授权错误(token过期)
    if (error.response && error.response.status === 401) {
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 检测到401未授权错误，尝试刷新令牌`)
      // 获取本地令牌信息
      const accessToken = localStorage.getItem('accessToken')
      const userInfoStr = localStorage.getItem('userInfo')
      const userInfo = userInfoStr ? JSON.parse(userInfoStr) : {}
      const refreshToken = userInfo.refreshToken || localStorage.getItem('refreshToken')
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 当前令牌状态: accessToken存在=${!!accessToken}, refreshToken存在=${!!refreshToken}`)

      if (refreshToken && !isRefreshing) {
        isRefreshing = true
        console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 开始刷新令牌流程`)

        // 尝试刷新token
        return service.post('/api/login/refresh-token', { refreshToken })
          .then(res => {
            isRefreshing = false

            if (res.success) {
              const { accessToken } = res.data
              console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 令牌刷新成功，更新存储`)

              // 更新store和localStorage中的token
              store.dispatch('updateTokens', {
                accessToken,
                refreshToken // refreshToken保持不变
              })
              // 同时直接更新localStorage中的独立token项
              localStorage.setItem('accessToken', accessToken)
              console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 已更新独立令牌存储项`)

              // 重新发送队列中的请求
              requests.forEach(cb => cb(accessToken))
              requests = []

              // 重试当前请求
              const config = error.config
              config.headers.Authorization = `Bearer ${accessToken}`
              console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 使用新令牌重试请求: ${config.url}`)

              return service(config)
            } else {
              // 刷新token失败，清除用户信息并跳转到登录页
              console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 令牌刷新返回失败`)
              store.dispatch('logout')
              router.push('/login')
              ElMessage.error('登录已过期，请重新登录')
              return Promise.reject(error)
            }
          })
          .catch(refreshError => {
            console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 刷新token失败:`, refreshError)
            // 刷新token失败，清除用户信息并跳转到登录页
            store.dispatch('logout')
            router.push('/login')
            ElMessage.error('登录已过期，请重新登录')
            return Promise.reject(error)
          })
      } else if (refreshToken && isRefreshing) {
        // 将请求加入队列
        console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 已有刷新请求在进行中，将请求加入队列`)
        return new Promise(resolve => {
          requests.push(token => {
            error.config.headers.Authorization = `Bearer ${token}`
            resolve(service(error.config))
          })
        })
      } else {
        // 没有refreshToken，直接跳转到登录页
        console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 没有可用的刷新令牌，需要重新登录`)
        localStorage.removeItem('userInfo')
        localStorage.removeItem('accessToken')
        localStorage.removeItem('refreshToken')
        store.dispatch('logout')
        router.push('/login')
        ElMessage.error('登录已过期，请重新登录')
      }
    }

    // 处理403禁止访问错误(权限不足)
    if (error.response && error.response.status === 403) {
      ElMessage.error('权限不足，无法访问')
    }

    // 处理404未找到错误
    if (error.response && error.response.status === 404) {
      ElMessage.error('请求的资源不存在')
    }

    // 处理500服务器错误
    if (error.response && error.response.status === 500) {
      ElMessage.error('服务器内部错误')
    }

    ElMessage.error(error.message || '请求失败')
    return Promise.reject(error)
  }
)

export default service
