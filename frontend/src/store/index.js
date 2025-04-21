import { createStore } from 'vuex'

export default createStore({
  state: {
    // 用户信息
    userInfo: JSON.parse(localStorage.getItem('userInfo')) || null,
    accessToken: localStorage.getItem('accessToken') || null,
    refreshToken: localStorage.getItem('refreshToken') || null
    // 其他全局状态...
  },
  mutations: {
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
      state.userInfo = null
      state.accessToken = null
      state.refreshToken = null
      localStorage.removeItem('userInfo')
      localStorage.removeItem('accessToken')
      localStorage.removeItem('refreshToken')
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
      commit('CLEAR_AUTH')
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
    getAccessToken: state => state.accessToken,
    getRefreshToken: state => state.refreshToken
    // 其他 getters...
  },
  modules: {
    // 可以添加其他模块...
  }
})
