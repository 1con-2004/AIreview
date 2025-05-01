<template>
  <div class="admin-layout">
    <!-- 顶部导航栏 -->
    <div class="admin-navbar">
      <div class="nav-left">
        <div class="brand-container">
          <svg class="site-logo" width="45" height="40" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <defs>
              <linearGradient id="screenGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" style="stop-color:#3d3d4d"/>
                <stop offset="100%" style="stop-color:#2d2d3d"/>
              </linearGradient>
              <linearGradient id="monitorGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" style="stop-color:#8a8a9b"/>
                <stop offset="100%" style="stop-color:#6a6a7b"/>
              </linearGradient>
              <linearGradient id="planetGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" style="stop-color:#e0e0e0"/>
                <stop offset="100%" style="stop-color:#b0b0b0"/>
              </linearGradient>
              <filter id="glow">
                <feGaussianBlur stdDeviation="2" result="coloredBlur"/>
                <feMerge>
                  <feMergeNode in="coloredBlur"/>
                  <feMergeNode in="SourceGraphic"/>
                </feMerge>
              </filter>
            </defs>
            <!-- 显示器外壳 -->
            <rect x="100" y="100" width="824" height="624" rx="20" fill="url(#monitorGradient)" stroke="#9a9aab" stroke-width="10"/>
            <!-- 显示器屏幕 -->
            <rect x="120" y="120" width="784" height="584" rx="10" fill="url(#screenGradient)" stroke="#4a4a5a" stroke-width="4"/>
            <!-- 显示器支撑立柱 -->
            <rect x="487" y="724" width="50" height="100" fill="url(#monitorGradient)" stroke="#9a9aab" stroke-width="4"/>
            <!-- 显示器底座 -->
            <rect x="362" y="824" width="300" height="30" rx="5" fill="url(#monitorGradient)" stroke="#9a9aab" stroke-width="4"/>
            <!-- 屏幕内容 -->
            <g transform="translate(150, 150) scale(0.7)" filter="url(#glow)">
              <!-- 星星装饰 -->
              <path d="M200,200 L220,180 L200,160 L180,180 Z" fill="#fff"/>
              <path d="M800,300 L820,280 L800,260 L780,280 Z" fill="#fff"/>
              <path d="M700,700 L720,680 L700,660 L680,680 Z" fill="#fff"/>
              <path d="M300,600 L320,580 L300,560 L280,580 Z" fill="#fff"/>
              <!-- 行星主体 -->
              <circle cx="512" cy="512" r="300" fill="url(#planetGradient)"/>
              <!-- 行星环 -->
              <ellipse cx="512" cy="512" rx="400" ry="80" transform="rotate(-15,512,512)" fill="none" stroke="#fff" stroke-width="30"/>
            </g>
          </svg>
          <span class="logo-text">问知星球后台</span>
        </div>
      </div>
      <div class="nav-right">
        <router-link to="/home" class="back-to-front">
          <i class="fas fa-arrow-left"></i>
          返回前台
        </router-link>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="admin-content">
      <!-- 左侧菜单 -->
      <div class="admin-sidebar">
        <div class="menu-item" v-for="(item, index) in filteredMenuItems" :key="index">
          <router-link :to="item.path" class="menu-link">
            <i :class="item.icon"></i>
            <span>{{ item.name }}</span>
          </router-link>
        </div>
      </div>

      <!-- 右侧内容区域 -->
      <div class="admin-main">
        <router-view></router-view>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const menuItems = ref([
  { name: '系统首页', path: '/admin/dashboard', icon: 'fas fa-home' },
  { name: '用户管理', path: '/admin/users', icon: 'fas fa-users', hideForRoles: ['teacher'] }, // 老师不能访问
  { name: '题目管理', path: '/admin/problems', icon: 'fas fa-tasks' },
  // { name: '社区管理', path: '/admin/community', icon: 'fas fa-comments' },
  { name: '学生管理', path: '/admin/students', icon: 'fas fa-user-graduate' },
  { name: '课堂管理', path: '/admin/classrooms', icon: 'fas fa-chalkboard-teacher' },
  { name: '学习计划', path: '/admin/learning-plans', icon: 'fas fa-road', hideForRoles: ['teacher'] }, // 老师不能访问
  { name: '数据统计', path: '/admin/statistics', icon: 'fas fa-chart-bar' },
  { name: '埋点分析', path: '/admin/analytics-dashboard', icon: 'fas fa-chart-line', hideForRoles: ['teacher'] }, // 老师不能访问
  { name: '系统设置', path: '/admin/settings', icon: 'fas fa-cog' }
])

// 获取当前用户角色
const getCurrentUserRole = () => {
  const userInfo = localStorage.getItem('userInfo')
  if (userInfo) {
    try {
      const user = JSON.parse(userInfo)
      return user.role || 'normal'
    } catch (e) {
      console.error('解析用户信息失败:', e)
      return 'normal'
    }
  }
  return 'normal'
}

// 根据用户角色过滤菜单项
const filteredMenuItems = computed(() => {
  const currentRole = getCurrentUserRole()
  console.log('当前用户角色:', currentRole)

  return menuItems.value.filter(item => {
    // 如果菜单项没有hideForRoles属性，或者当前角色不在hideForRoles列表中，则显示该菜单项
    return !item.hideForRoles || !item.hideForRoles.includes(currentRole)
  })
})

// 检查管理员权限
onMounted(() => {
  const userInfoStr = localStorage.getItem('userInfo')
  if (!userInfoStr) {
    console.log('未登录，跳转到登录页')
    router.push('/login')
    return
  }

  try {
    const userInfo = JSON.parse(userInfoStr)
    const userRole = userInfo.role || 'normal'

    console.log('当前用户角色:', userRole)

    if (userRole !== 'admin' && userRole !== 'teacher') {
      console.log('非管理员或教师账户，跳转到登录页')
      router.push('/login')
    }
  } catch (e) {
    console.error('解析用户信息失败:', e)
    router.push('/login')
  }
})
</script>

<style scoped>
.admin-layout {
  min-height: 100vh;
  background-color: #f0f2f5;
}

.admin-navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 24px;
  height: 64px;
  background-color: #1e1e2e;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
}

.nav-left {
  display: flex;
  align-items: center;
}

.brand-container {
  display: flex;
  align-items: center;
  gap: 15px;
}

.site-logo {
  transition: all 0.3s ease;
  min-width: 45px;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
}

.logo-text {
  font-size: 24px;
  font-weight: 700;
  color: #e0e0e0;
  letter-spacing: 1px;
}

.back-to-front {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  border-radius: 8px;
  background: linear-gradient(145deg, rgba(78,205,196,0.15), rgba(78,205,196,0.05));
  color: #4ecdc4;
  font-weight: 500;
  text-decoration: none;
  transition: all 0.3s ease;
  border: 1px solid rgba(78,205,196,0.2);
}

.back-to-front i {
  transition: transform 0.3s ease;
}

.back-to-front:hover {
  background: linear-gradient(145deg, rgba(78,205,196,0.25), rgba(78,205,196,0.1));
  color: #45b6af;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(78,205,196,0.15);
}

.back-to-front:hover i {
  transform: translateX(-4px);
}

.admin-content {
  display: flex;
  padding-top: 64px;
  min-height: calc(100vh - 64px);
}

.admin-sidebar {
  width: 240px;
  background-color: #1e1e2e;
  padding: 24px 0;
  position: fixed;
  left: 0;
  top: 64px;
  bottom: 0;
  overflow-y: auto;
}

.menu-item {
  padding: 4px 16px;
}

.menu-link {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  color: #e0e0e0;
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.menu-link i {
  width: 20px;
  text-align: center;
  font-size: 16px;
}

.menu-link:hover {
  background: linear-gradient(145deg, rgba(78,205,196,0.15), rgba(78,205,196,0.05));
  color: #4ecdc4;
  transform: translateX(4px);
}

.menu-link.router-link-active {
  background: linear-gradient(145deg, rgba(78,205,196,0.25), rgba(78,205,196,0.1));
  color: #4ecdc4;
  font-weight: 500;
}

.admin-main {
  flex: 1;
  margin-left: 240px;
  padding: 24px;
  background-color: #f0f2f5;
  min-height: calc(100vh - 64px);
}
</style>
