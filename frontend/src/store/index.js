import { createStore } from 'vuex'

export default createStore({
  state: {
    // 用户信息
    userInfo: JSON.parse(localStorage.getItem('userInfo')) || null,
    accessToken: localStorage.getItem('accessToken') || null,
    refreshToken: localStorage.getItem('refreshToken') || null,
    // 其他全局状态...
  },
  mutations: {
    // 设置用户信息
    SET_USER_INFO(state, userInfo) {
      state.userInfo = userInfo
      if (userInfo) {
        localStorage.setItem('userInfo', JSON.stringify(userInfo))
      } else {
        localStorage.removeItem('userInfo')
      }
    },
    SET_TOKENS(state, { accessToken, refreshToken }) {
      state.accessToken = accessToken
      state.refreshToken = refreshToken
      
      // 更新localStorage中userInfo的token
      const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
      userInfo.accessToken = accessToken
      userInfo.refreshToken = refreshToken
      localStorage.setItem('userInfo', JSON.stringify(userInfo))
    },
    CLEAR_AUTH(state) {
      state.userInfo = null
      state.accessToken = null
      state.refreshToken = null
      localStorage.removeItem('userInfo')
    },
    // 其他 mutations...
  },
  actions: {
    // 登录
    login({ commit }, { userInfo, accessToken, refreshToken }) {
      // 确保token存储在userInfo中
      userInfo.accessToken = accessToken
      userInfo.refreshToken = refreshToken
      commit('SET_USER_INFO', userInfo)
    },
    // 登出
    logout({ commit }) {
      commit('CLEAR_AUTH')
    },
    updateTokens({ commit }, { accessToken, refreshToken }) {
      commit('SET_TOKENS', { accessToken, refreshToken })
    },
    // 其他 actions...
  },
  getters: {
    // 是否已登录
    isLoggedIn: state => !!state.accessToken,
    // 获取用户信息
    getUserInfo: state => state.userInfo,
    getAccessToken: state => state.accessToken,
    getRefreshToken: state => state.refreshToken,
    // 其他 getters...
  },
  modules: {
    // 可以添加其他模块...
  }
}) 