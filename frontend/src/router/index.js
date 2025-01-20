import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '@/views/home/index.vue'
import Login from '@/views/login/index.vue'
import Problems from '@/views/problems/index.vue'
import ProblemDetail from '@/views/problems/detail/0000.vue'

const routes = [
  {
    path: '/home',
    name: 'HomePage',
    component: HomePage
  },
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/dashboard',
    redirect: '/home'
  },
  {
    path: '/problems',
    name: 'Problems',
    component: Problems
  },
  {
    path: '/problems/detail/:id',
    name: 'ProblemDetail',
    component: ProblemDetail
  },
  {
    path: '/contests',
    name: 'Contests',
    component: () => import('../views/contests/index.vue')
  },
  {
    path: '/status',
    name: 'Status',
    component: () => import('../views/status/index.vue')
  },
  {
    path: '/rank',
    name: 'Rank',
    component: () => import('../views/rank/index.vue')
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('../views/about/index.vue')
  },
  {
    path: '/login/phone',
    name: 'PhoneLogin',
    component: () => import('../views/login/phone.vue')
  },
  {
    path: '/login/reset-password',
    name: 'ResetPassword',
    component: () => import('../views/login/reset-password.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/login/register.vue')
  }
  
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 添加路由守卫
router.beforeEach((to, from, next) => {
  // 这里可以添加登录验证逻辑
  next()
})

export default router
