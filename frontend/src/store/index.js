import { createStore } from 'vuex'

export default createStore({
  state: {
    // 用户信息
    userInfo: null,
    accessToken: '',
    refreshToken: '',
    // 同步读取localStorage中的数据初始化状态
    initialized: false
    // 其他全局状态...
  },
  mutations: {
    // 初始化状态
    INITIALIZE_STATE(state) {
      // 尝试从localStorage读取token和用户信息
      try {
        const accessToken = localStorage.getItem('accessToken')
        const refreshToken = localStorage.getItem('refreshToken')
        const userInfoStr = localStorage.getItem('userInfo')
        
        if (accessToken) state.accessToken = accessToken
        if (refreshToken) state.refreshToken = refreshToken
        if (userInfoStr) state.userInfo = JSON.parse(userInfoStr)
        
        console.log('状态初始化完成，accessToken存在:', !!accessToken)
        console.log('状态初始化完成，userInfo存在:', !!userInfoStr)
      } catch (e) {
        console.error('初始化状态出错:', e)
      }
      
      state.initialized = true
    },
    // 设置用户信息
    SET_USER_INFO (state, userInfo) {
      // 检查是否有明显的用户变更
      if (state.userInfo && state.userInfo.username !== userInfo.username) {
        console.warn('用户信息发生变化:', state.userInfo.username, '->', userInfo.username)
        console.warn('这可能导致用户切换问题，如果非预期行为请刷新页面')
      }

      // 记录完整的用户信息更新
      console.log('更新Vuex存储的用户信息:', userInfo.username, '角色:', userInfo.role)

      state.userInfo = userInfo
      if (userInfo) {
        // 确保保存完整的用户信息
        if (!userInfo.accessToken && state.accessToken) {
          console.warn('用户信息中缺少token，正在修复...')
          userInfo.accessToken = state.accessToken
          userInfo.refreshToken = state.refreshToken
        }

        // 同步更新localStorage
        const userInfoJson = JSON.stringify(userInfo)
        localStorage.setItem('userInfo', userInfoJson)
        console.log('用户信息已同步到localStorage')
      } else {
        localStorage.removeItem('userInfo')
        console.log('用户信息已从localStorage移除')
      }
    },
    SET_TOKENS (state, { accessToken, refreshToken }) {
      state.accessToken = accessToken
      state.refreshToken = refreshToken

      try {
        // 更新localStorage中userInfo的token
        const userInfoStr = localStorage.getItem('userInfo')
        if (userInfoStr) {
          const userInfo = JSON.parse(userInfoStr)

          // 记录token更新，但不更改用户名
          console.log('更新用户token，用户名:', userInfo.username)

          userInfo.accessToken = accessToken
          userInfo.refreshToken = refreshToken
          localStorage.setItem('userInfo', JSON.stringify(userInfo))

          // 同步更新state.userInfo
          if (state.userInfo) {
            state.userInfo.accessToken = accessToken
            state.userInfo.refreshToken = refreshToken
          }
        }
      } catch (error) {
        console.error('更新token时出错:', error)
      }
    },
    CLEAR_AUTH (state) {
      console.log('执行清除认证状态操作')
      
      // 清除Vuex状态
      state.userInfo = null
      state.accessToken = null
      state.refreshToken = null
      
      // 清除所有与用户相关的localStorage项
      try {
        // 先获取原始值，用于记录日志
        const originalUserInfo = localStorage.getItem('userInfo')
        const originalToken = localStorage.getItem('accessToken')
        
        if (originalUserInfo) {
          try {
            const parsedInfo = JSON.parse(originalUserInfo)
            console.log(`正在移除用户数据: ${parsedInfo.username || '未知用户'}`)
          } catch (e) {
            console.log('无法解析原始userInfo')
          }
        }
        
        // 清除主要用户数据项
        localStorage.removeItem('userInfo')
        localStorage.removeItem('accessToken')
        localStorage.removeItem('refreshToken')
        localStorage.removeItem('currentUsername')
        localStorage.removeItem('last_active_user')
        
        // 清除会话存储
        sessionStorage.removeItem('current_user')
        sessionStorage.removeItem('last_active_user')
        
        // 验证清除结果
        const afterUserInfo = localStorage.getItem('userInfo')
        const afterToken = localStorage.getItem('accessToken')
        
        console.log('用户数据清除结果: userInfo存在=', !!afterUserInfo, 'accessToken存在=', !!afterToken)
        
        if (afterUserInfo || afterToken) {
          console.warn('用户数据未完全清除，尝试使用localStorage.clear()')
          localStorage.clear()
        }
      } catch (e) {
        console.error('清除localStorage时出错:', e)
        // 出错时尝试使用clear方法
        try {
          localStorage.clear()
        } catch (clearError) {
          console.error('使用localStorage.clear()也失败:', clearError)
        }
      }
    }
    // 其他 mutations...
  },
  actions: {
    // 登录
    login ({ commit }, { userInfo, accessToken, refreshToken }) {
      console.log('登录用户:', userInfo.username, '角色:', userInfo.role)

      // 清除之前可能存在的用户数据
      localStorage.removeItem('userInfo')
      localStorage.removeItem('accessToken')
      localStorage.removeItem('refreshToken')

      // 确保token存储在userInfo中
      userInfo.accessToken = accessToken
      userInfo.refreshToken = refreshToken

      // 保存access和refresh token
      localStorage.setItem('accessToken', accessToken)
      localStorage.setItem('refreshToken', refreshToken)
      localStorage.setItem('userInfo', JSON.stringify(userInfo))

      // 触发mutation更新state
      commit('SET_USER_INFO', userInfo)
      commit('SET_TOKENS', { accessToken, refreshToken })

      // 触发全局事件通知其他组件
      window.dispatchEvent(new CustomEvent('userLogin', {
        detail: { username: userInfo.username, role: userInfo.role }
      }))

      console.log('用户登录完成，所有状态已更新')
    },
    // 登出
    logout ({ commit }) {
      console.log('用户登出')
      
      // 先尝试获取用户信息，用于日志记录
      try {
        const userInfoStr = localStorage.getItem('userInfo')
        if (userInfoStr) {
          const userInfo = JSON.parse(userInfoStr)
          console.log(`用户 ${userInfo.username} 正在登出`)
        }
      } catch (e) {
        console.error('读取用户信息失败:', e)
      }
      
      // 清除Vuex中的认证状态
      commit('CLEAR_AUTH')
      
      // 彻底清理所有用户相关的本地存储
      localStorage.removeItem('userInfo')
      localStorage.removeItem('accessToken')
      localStorage.removeItem('refreshToken')
      localStorage.removeItem('currentUsername')
      localStorage.removeItem('last_active_user')
      
      // 清理会话存储
      sessionStorage.removeItem('current_user')
      
      // 检查清理结果
      const cleanCheck = {
        userInfo: localStorage.getItem('userInfo'),
        accessToken: localStorage.getItem('accessToken'),
        refreshToken: localStorage.getItem('refreshToken'),
        currentUsername: localStorage.getItem('currentUsername')
      }
      
      console.log('登出后的存储状态:', cleanCheck)
      
      // 触发全局事件通知其他组件
      window.dispatchEvent(new CustomEvent('userLogout'))
      
      console.log('用户登出完成，所有状态已清除')
    },
    updateTokens ({ commit }, { accessToken, refreshToken }) {
      commit('SET_TOKENS', { accessToken, refreshToken })
    }
    // 其他 actions...
  },
  getters: {
    // 是否已登录
    isLoggedIn: state => !!state.accessToken,
    // 获取用户信息
    getUserInfo: state => state.userInfo,
    // 获取token (主要token getter，用于请求中)
    token: state => state.accessToken,
    // 额外的token getter (保持兼容性)
    getAccessToken: state => state.accessToken,
    getRefreshToken: state => state.refreshToken
    // 其他 getters...
  },
  modules: {
    // 可以添加其他模块...
  }
})
