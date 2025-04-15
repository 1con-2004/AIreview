import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '@/views/home/index.vue'
import Login from '@/views/login/index.vue'
import Problems from '@/views/problems/index.vue'
import Community from '@/views/community/index.vue'
import UserProfile from '@/views/user/UserProfile.vue'

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
    path: '/ai-center',
    name: 'AICenter',
    component: () => import('@/views/ai/AICenter.vue'),
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
  const publicPages = ['/login', '/register', '/home', '/login/phone', '/login/reset-password'];
  const authRequired = !publicPages.includes(to.path);
  const userInfo = localStorage.getItem('userInfo');

  if (authRequired && !userInfo) {
    next('/login');
  } else {
    next();
  }
})

export default router
