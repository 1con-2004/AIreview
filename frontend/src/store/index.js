import { createStore } from 'vuex'

export default createStore({
  state: {
    // 用户信息
    userInfo: JSON.parse(localStorage.getItem('userInfo')) || null,
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
    // 其他 mutations...
  },
  actions: {
    // 登录
    login({ commit }, userInfo) {
      commit('SET_USER_INFO', userInfo)
    },
    // 登出
    logout({ commit }) {
      commit('SET_USER_INFO', null)
    },
    // 其他 actions...
  },
  getters: {
    // 是否已登录
    isLoggedIn: state => !!state.userInfo,
    // 获取用户信息
    getUserInfo: state => state.userInfo,
    // 其他 getters...
  },
  modules: {
    // 可以添加其他模块...
  }
}) 