import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '@/views/home/index.vue'
import Login from '@/views/login/index.vue'
import Problems from '@/views/problems/index.vue'
import Community from '@/views/community/index.vue'
import TokenDebug from '@/views/debug/TokenDebug.vue'

const routes = [
  {
    path: '/home',
    name: 'HomePage',
    component: HomePage
  },
  {
    path: '/',
    redirect: '/home'
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
    component: () => import('@/views/problems/detail/ProblemDetail.vue')
  },
  {
    path: '/ai-center',
    name: 'AICenter',
    component: () => import('@/views/ai-center/index.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/community',
    name: 'Community',
    component: Community
  },
  {
    path: '/community/create',
    name: 'CommunityCreate',
    component: () => import('@/views/community/create.vue')
  },
  {
    path: '/community/detail/:id',
    name: 'CommunityDetail',
    component: () => import('@/views/community/detail.vue')
  },
  {
    path: '/user/:username',
    name: 'UserProfile',
    component: () => import('@/views/user/UserProfile.vue')
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
  },
  {
    path: '/analysis',
    name: 'Analysis',
    component: () => import('@/views/analysis/Analysis.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/classroom',
    name: 'Classroom',
    component: () => import('@/views/classroom/index.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/classroom/attendance',
    name: 'ClassroomAttendance',
    component: () => import('@/views/classroom/attendance.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/classroom/live/:id',
    name: 'ClassroomLive',
    component: () => import('@/views/classroom/live.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/learning-plans',
    name: 'LearningPlans',
    component: () => import('@/views/learning-plans/index.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/learning-plans/:id',
    name: 'LearningPlanDetail',
    component: () => import('@/views/learning-plans/detail.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/debug/token',
    name: 'token-debug',
    component: TokenDebug,
    meta: {
      title: 'Token调试工具'
    }
  },
  {
    path: '/debug/analytics',
    name: 'analytics-debug',
    component: () => import('@/views/debug/analytics.vue'),
    meta: {
      title: '埋点数据调试'
    }
  },
  {
    path: '/debug/analytics-test',
    name: 'analytics-test',
    component: () => import('@/views/debug/analytics-test.vue'),
    meta: {
      title: '埋点功能测试'
    }
  },
  {
    path: '/statistics',
    name: 'Statistics',
    component: () => import('@/views/statistics/index.vue'),
    meta: {
      title: '统计'
    }
  }
]

// 添加后台管理相关路由
const adminRoutes = {
  path: '/admin',
  component: () => import('@/views/admin/AdminLayout.vue'),
  children: [
    {
      path: '',
      redirect: '/admin/dashboard'
    },
    {
      path: 'dashboard',
      name: 'AdminDashboard',
      component: () => import('@/views/admin/dashboard.vue')
    },
    {
      path: 'users',
      name: 'AdminUsers',
      component: () => import('@/views/admin/users.vue')
    },
    {
      path: 'problems',
      name: 'AdminProblems',
      component: () => import('@/views/admin/problems.vue')
    },
    {
      path: 'problem-pool',
      name: 'AdminProblemPool',
      component: () => import('@/views/admin/problem-pool.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: 'community',
      name: 'AdminCommunity',
      component: () => import('@/views/admin/community.vue')
    },
    {
      path: 'learning-plans',
      name: 'AdminLearningPlans',
      component: () => import('@/views/admin/learning-plans.vue')
    },
    {
      path: 'statistics',
      name: 'AdminStatistics',
      component: () => import('@/views/admin/statistics.vue')
    },
    {
      path: 'analytics-dashboard',
      name: 'AdminAnalyticsDashboard',
      component: () => import('@/views/admin/analytics-dashboard.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: 'settings',
      name: 'AdminSettings',
      component: () => import('@/views/admin/settings.vue')
    },
    {
      path: 'students',
      name: 'AdminStudents',
      component: () => import('@/views/admin/students.vue')
    },
    {
      path: 'classrooms',
      name: 'AdminClassrooms',
      component: () => import('@/views/admin/classrooms/index.vue'),
      meta: { requiresAuth: true, requiresTeacher: true }
    }
  ]
}

// 将adminRoutes添加到路由配置中
routes.push(adminRoutes)

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

// 添加路由守卫
router.beforeEach((to, from, next) => {
  const publicPages = ['/login', '/register', '/home', '/login/phone', '/login/reset-password', '/debug/token']
  const authRequired = !publicPages.includes(to.path)

  // 检查用户信息和token
  const userInfoStr = localStorage.getItem('userInfo')
  const accessToken = localStorage.getItem('accessToken')

  // 增加详细日志
  console.log(`[路由] 检查访问权限: ${to.path}`)
  console.log(`[路由] 用户信息存在: ${!!userInfoStr}, Token存在: ${!!accessToken}`)
  console.log(`[路由] 页面需要登录: ${authRequired}`)

  // 未登录且需要认证，跳转到登录页
  if (authRequired && (!userInfoStr || !accessToken)) {
    console.log('[路由] 需要登录但未登录，重定向到登录页')
    next('/login')
    return
  }

  // 检查角色权限
  if (userInfoStr) {
    try {
      const userInfo = JSON.parse(userInfoStr)
      console.log(`[路由] 当前用户角色: ${userInfo.role}`)

      // 路由需要管理员权限
      if (to.meta.requiresAdmin && userInfo.role !== 'admin') {
        console.log(`[路由] 需要管理员权限，当前用户角色: ${userInfo.role}，重定向到登录页`)
        next('/login')
        return
      }

      // 路由需要教师权限
      if (to.meta.requiresTeacher && userInfo.role !== 'teacher' && userInfo.role !== 'admin') {
        console.log(`[路由] 需要教师权限，当前用户角色: ${userInfo.role}，重定向到登录页`)
        next('/login')
        return
      }
    } catch (error) {
      console.error('[路由] 解析用户信息失败:', error)
      // 解析失败视为未登录
      if (authRequired) {
        next('/login')
        return
      }
    }
  }

  next()
})

export default router
