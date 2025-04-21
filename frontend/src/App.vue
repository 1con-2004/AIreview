<template>
  <router-view></router-view>
</template>

<script setup>
import { onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import store from '@/store'

const router = useRouter()

// 检查用户身份一致性的函数
const ensureUserConsistency = () => {
  try {
    // 获取本地存储的用户信息
    const userInfoStr = localStorage.getItem('userInfo')
    if (!userInfoStr) return

    const userInfo = JSON.parse(userInfoStr)

    // 记录当前活跃用户名
    localStorage.setItem('currentUsername', userInfo.username)

    // 检查Vuex中的用户数据与localStorage是否一致
    const storeUserInfo = store.getters.getUserInfo

    if (storeUserInfo && storeUserInfo.username !== userInfo.username) {
      console.log('检测到用户信息不一致:', storeUserInfo?.username, '!=', userInfo.username)
      console.log('正在同步Vuex中的用户信息...')

      // 同步用户信息到Vuex
      store.dispatch('login', {
        userInfo,
        accessToken: userInfo.accessToken,
        refreshToken: userInfo.refreshToken
      })
    }
  } catch (error) {
    console.error('检查用户一致性失败:', error)
  }
}

// 路由变化处理函数
const handleRouteChange = (to, from, next) => {
  // 每次路由变化时确保用户信息一致性
  ensureUserConsistency()

  // 检查是否需要登录权限的页面
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)
  const userInfoStr = localStorage.getItem('userInfo')

  if (requiresAuth && !userInfoStr) {
    console.log('访问需要登录的页面，但用户未登录，重定向到登录页')
    next('/login')
    return
  }

  // 检查是否有角色限制
  if (userInfoStr && to.meta.roles) {
    const userInfo = JSON.parse(userInfoStr)
    if (!to.meta.roles.includes(userInfo.role)) {
      console.log('用户角色无权访问此页面')
      next('/home')
      return
    }
  }

  next()
}

// 全局挂载用户一致性检查工具
const mountGlobalUtil = () => {
  // 挂载全局函数，方便任何组件调用
  window.$fixUserInfo = ensureUserConsistency
}

onMounted(() => {
  // 初始化时执行一次
  ensureUserConsistency()
  mountGlobalUtil()

  // 添加路由事件监听
  router.beforeEach(handleRouteChange)
})

onUnmounted(() => {
  // 移除全局函数
  if (window.$fixUserInfo === ensureUserConsistency) {
    delete window.$fixUserInfo
  }
})
</script>

<style>
@import 'primevue/resources/themes/lara-light-blue/theme.css';
@import 'primevue/resources/primevue.min.css';
@import 'primeicons/primeicons.css';
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');

:root {
  /* 全局颜色变量 */
  --primary-color: #4ecdc4;
  --primary-dark: #33b5ac;
  --primary-light: #a3ede8;
  --secondary-color: #ff6b6b;
  --secondary-dark: #e05050;
  --secondary-light: #ffa5a5;
  --accent-color: #ffe66d;
  --dark-color: #1a1b41;
  --light-color: #f7fff7;
  --success-color: #28a745;
  --warning-color: #ffc107;
  --error-color: #dc3545;
  --gray-100: #f8f9fa;
  --gray-200: #e9ecef;
  --gray-300: #dee2e6;
  --gray-400: #ced4da;
  --gray-500: #adb5bd;
  --gray-600: #6c757d;
  --gray-700: #495057;
  --gray-800: #343a40;
  --gray-900: #212529;

  /* 字体变量 */
  --body-font: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  --heading-font: var(--body-font);
  --monospace-font: SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace;

  /* 尺寸变量 */
  --header-height: 70px;
  --border-radius: 8px;
  --container-width: 1200px;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: var(--body-font);
  line-height: 1.6;
  color: var(--gray-800);
  background-color: var(--gray-100);
}

.p-component {
  font-family: var(--body-font);
}

.container {
  width: 100%;
  max-width: var(--container-width);
  margin: 0 auto;
  padding: 0 1rem;
}

/* Utility classes */
.text-center { text-align: center; }
.text-left { text-align: left; }
.text-right { text-align: right; }

.mt-1 { margin-top: 0.25rem; }
.mt-2 { margin-top: 0.5rem; }
.mt-3 { margin-top: 1rem; }
.mt-4 { margin-top: 1.5rem; }
.mt-5 { margin-top: 3rem; }

.mb-1 { margin-bottom: 0.25rem; }
.mb-2 { margin-bottom: 0.5rem; }
.mb-3 { margin-bottom: 1rem; }
.mb-4 { margin-bottom: 1.5rem; }
.mb-5 { margin-bottom: 3rem; }

.ml-1 { margin-left: 0.25rem; }
.ml-2 { margin-left: 0.5rem; }
.ml-3 { margin-left: 1rem; }
.ml-4 { margin-left: 1.5rem; }
.ml-5 { margin-left: 3rem; }

.mr-1 { margin-right: 0.25rem; }
.mr-2 { margin-right: 0.5rem; }
.mr-3 { margin-right: 1rem; }
.mr-4 { margin-right: 1.5rem; }
.mr-5 { margin-right: 3rem; }

.p-1 { padding: 0.25rem; }
.p-2 { padding: 0.5rem; }
.p-3 { padding: 1rem; }
.p-4 { padding: 1.5rem; }
.p-5 { padding: 3rem; }

.btn {
  display: inline-block;
  font-weight: 500;
  text-align: center;
  vertical-align: middle;
  user-select: none;
  border: 1px solid transparent;
  padding: 0.5rem 1rem;
  font-size: 1rem;
  line-height: 1.5;
  border-radius: var(--border-radius);
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  cursor: pointer;
}

.btn-primary {
  color: #fff;
  background-color: var(--primary-color);
  border-color: var(--primary-color);
}

.btn-primary:hover {
  background-color: var(--primary-dark);
  border-color: var(--primary-dark);
}

.btn-secondary {
  color: #fff;
  background-color: var(--secondary-color);
  border-color: var(--secondary-color);
}

.btn-secondary:hover {
  background-color: var(--secondary-dark);
  border-color: var(--secondary-dark);
}

.card {
  background-color: #fff;
  border-radius: var(--border-radius);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

/* Dark mode overrides */
.dark-mode {
  background-color: var(--gray-900);
  color: var(--gray-100);
}

.dark-mode .card {
  background-color: var(--gray-800);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

/* Code displays */
pre {
  font-family: var(--monospace-font);
  background-color: var(--gray-800);
  color: var(--gray-100);
  padding: 1rem;
  border-radius: var(--border-radius);
  overflow-x: auto;
  margin: 1rem 0;
}

code {
  font-family: var(--monospace-font);
  background-color: var(--gray-200);
  color: var(--gray-800);
  padding: 0.2rem 0.4rem;
  border-radius: 4px;
}

.dark-mode code {
  background-color: var(--gray-700);
  color: var(--gray-100);
}

/* Forms */
.form-group {
  margin-bottom: 1rem;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

.form-control {
  display: block;
  width: 100%;
  padding: 0.5rem 0.75rem;
  font-size: 1rem;
  line-height: 1.5;
  color: var(--gray-700);
  background-color: #fff;
  background-clip: padding-box;
  border: 1px solid var(--gray-300);
  border-radius: var(--border-radius);
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}

.form-control:focus {
  color: var(--gray-700);
  background-color: #fff;
  border-color: var(--primary-light);
  outline: 0;
  box-shadow: 0 0 0 0.2rem rgba(78, 205, 196, 0.25);
}

.dark-mode .form-control {
  background-color: var(--gray-700);
  border-color: var(--gray-600);
  color: var(--gray-100);
}

.dark-mode .form-control:focus {
  background-color: var(--gray-700);
  border-color: var(--primary-color);
}

/* 添加一个加载状态的动画 */
@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-spinner {
  display: inline-block;
  width: 2rem;
  height: 2rem;
  vertical-align: text-bottom;
  border: 0.25em solid var(--gray-300);
  border-right-color: var(--primary-color);
  border-radius: 50%;
  animation: spin 0.75s linear infinite;
}

.dark-mode .loading-spinner {
  border-color: var(--gray-600);
  border-right-color: var(--primary-color);
}
</style>
