<template>
  <div class="nav-bar">
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
        <router-link to="/home" class="logo">问知星球</router-link>
      </div>
    </div>
    <div class="nav-middle" style="padding-left: 250px;">
      <router-link to="/home" class="nav-item">首页</router-link>
      <router-link to="/problems" class="nav-item">题库与练习</router-link>
      <router-link to="/community" class="nav-item">社区论坛</router-link>
      <router-link to="/classroom" class="nav-item">课堂辅助</router-link>
      <router-link to="/ai-center" class="nav-item">AI中心</router-link>
    </div>
    <div class="nav-right">
      <template v-if="isLoggedIn">
        <router-link v-if="isAdminOrTeacher()" to="/admin" class="admin-btn">
          <i class="fas fa-cog"></i>
          后台管理
        </router-link>
        <div @click="openUserProfileDialog" class="username">
          <img :src="getFullAvatarUrl(avatarUrl)" class="user-avatar" alt="用户头像">
          <span>{{ username }}</span>
        </div>
        <a @click="handleLogout" class="logout-btn">登出</a>
      </template>
      <template v-else>
        <router-link to="/login" class="login-btn">登录</router-link>
      </template>
    </div>
    
    <!-- 用户资料弹窗 -->
    <UserProfileDialog 
      :visible="profileDialogVisible" 
      :username="username"
      @update:visible="profileDialogVisible = $event"
    />
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import UserProfileDialog from './UserProfileDialog.vue'

const router = useRouter()
const isLoggedIn = ref(false)
const username = ref('')
const userRole = ref('')
const defaultAvatar = ref('/images/default-avatar.png')
const avatarUrl = ref(defaultAvatar.value)
const profileDialogVisible = ref(false)

const getFullAvatarUrl = (url) => {
  if (!url || url === 'null' || url === 'undefined') {
    console.log('没有头像URL，使用默认头像:', defaultAvatar.value);
    return defaultAvatar.value;
  }
  
  if (url.startsWith('http')) {
    console.log('使用完整的URL:', url);
    return url;
  }
  
  // 处理数据库中存储的路径
  if (url.includes('public/uploads/avatars/')) {
    const fileName = url.split('/').pop();
    const fullUrl = `http://localhost:3000/uploads/avatars/${fileName}?t=${Date.now()}`;
    console.log('转换后的头像URL:', fullUrl);
    return fullUrl;
  }
  
  // 处理其他情况
  const fullUrl = `http://localhost:3000${url}?t=${Date.now()}`;
  console.log('其他情况的头像URL:', fullUrl);
  return fullUrl;
}

const isAdminOrTeacher = () => {
  console.log('isAdminOrTeacher called, current role:', userRole.value);
  const result = ['admin', 'teacher'].includes(userRole.value);
  console.log('isAdminOrTeacher result:', result);
  return result;
}

const checkLoginStatus = async () => {
  const userInfo = localStorage.getItem('userInfo')
  console.log('Checking login status, localStorage userInfo:', userInfo)
  if (userInfo) {
    const user = JSON.parse(userInfo)
    console.log('Parsed user info:', user)
    console.log('User role from storage:', user.role)
    isLoggedIn.value = true
    username.value = user.username
    userRole.value = user.role // 从登录返回的数据中获取角色
    console.log('Set userRole.value to:', userRole.value)
    
    // 设置头像URL
    if (user.avatar_url) {
      avatarUrl.value = user.avatar_url
    } else {
      // 如果localStorage中没有头像URL，尝试从API获取用户资料
      try {
        const response = await fetch(`http://localhost:3000/api/user/profile/${user.username}`, {
          headers: {
            Authorization: `Bearer ${user.token}`
          }
        })
        const data = await response.json()
        if (response.ok && data.avatar_url) {
          avatarUrl.value = data.avatar_url
          // 更新localStorage中的用户信息
          user.avatar_url = data.avatar_url
          localStorage.setItem('userInfo', JSON.stringify(user))
        } else {
          avatarUrl.value = defaultAvatar.value
        }
      } catch (error) {
        console.error('获取用户资料失败:', error)
        avatarUrl.value = defaultAvatar.value
      }
    }
    console.log('设置头像URL:', avatarUrl.value)
  } else {
    console.log('No user info found in localStorage')
    isLoggedIn.value = false
    username.value = ''
    userRole.value = ''
    avatarUrl.value = defaultAvatar.value
  }
}

const openUserProfileDialog = () => {
  profileDialogVisible.value = true
}

const handleLogout = () => {
  localStorage.removeItem('userInfo')
  isLoggedIn.value = false
  username.value = ''
  userRole.value = ''
  avatarUrl.value = defaultAvatar.value
  router.push({ name: 'Login' })
}

onMounted(() => {
  checkLoginStatus()
  // 监听头像更新事件
  window.addEventListener('userAvatarUpdated', checkLoginStatus)
})

onUnmounted(() => {
  // 移除事件监听
  window.removeEventListener('userAvatarUpdated', checkLoginStatus)
})
</script>

<style scoped>
.nav-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  height: 70px;
  background-color: #1e1e2e;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
}

.nav-left {
  display: flex;
  align-items: center;
}

.brand-container {
  display: flex;
  align-items: center;
  gap: 15px;
  text-decoration: none;
  padding-top: 8px;
}

.site-logo {
  transition: all 0.3s ease;
  min-width: 45px;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
}

.site-logo:hover {
  transform: scale(1.1);
  filter: drop-shadow(0 0 8px rgba(255,215,0,0.6));
}

.nav-left .logo {
  font-size: 32px;
  font-weight: 900;
  letter-spacing: 2px;
  white-space: nowrap;
  color: #e0e0e0;
  font-family: 'Arial Black', sans-serif;
  padding: 5px 10px;
  margin-top: 5px;
  transition: all 0.3s ease;
  text-decoration: none;
  display: inline-block;
  text-rendering: optimizeLegibility;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-shadow:
    0 2px 4px rgba(0,0,0,0.3),
    0 0 10px rgba(255,255,255,0.2);
}

.nav-left .logo:hover {
  color: #ffd700;
  transform: scale(1.02);
  text-shadow:
    0 2px 4px rgba(0,0,0,0.3),
    0 0 15px rgba(255,215,0,0.4);
}

.nav-middle {
  display: flex;
  gap: 35px;
  align-items: center;
  position: relative;
  z-index: 1;
}

.nav-item {
  font-size: 22px;
  font-weight: 700;
  text-decoration: none;
  padding: 8px 16px;
  position: relative;
  background: linear-gradient(145deg, rgba(224, 224, 224, 0.8), rgba(192, 192, 192, 0.8));
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  text-shadow:
    1px 1px 0 rgba(0,0,0,0.2),
    -1px -1px 0 rgba(255,255,255,0.05),
    0 0 8px rgba(255,255,255,0.1);
  transition: all 0.3s ease;
  font-family: 'Arial', sans-serif;
  letter-spacing: 1px;
  opacity: 0.85;
}

.nav-item:hover {
  background: linear-gradient(145deg, rgba(255, 215, 0, 0.9), rgba(255, 165, 0, 0.9));
  -webkit-background-clip: text;
  background-clip: text;
  transform: scale(1.05);
  text-shadow:
    1px 1px 0 rgba(0,0,0,0.2),
    -1px -1px 0 rgba(255,255,255,0.05),
    0 0 12px rgba(255, 215, 0, 0.3);
  opacity: 1;
}

.nav-item::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, transparent, #ffd700, transparent);
  transform: scaleX(0);
  transition: transform 0.3s ease;
  box-shadow: 0 0 8px rgba(255, 215, 0, 0.5);
}

.nav-right {
  display: flex;
  align-items: center;
  gap: 20px;
  position: relative;
}

a {
  text-decoration: none;
  color: #666;
}

a:hover {
  color: #1890ff;
}

.username {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #e0e0e0;
  font-weight: 500;
  cursor: pointer;
  padding: 6px 12px;
  border-radius: 8px;
  background: linear-gradient(145deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05));
  transition: all 0.3s ease;
}

.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid rgba(255,255,255,0.1);
  transition: all 0.3s ease;
}

.username:hover .user-avatar {
  border-color: rgba(255,215,0,0.5);
  transform: scale(1.05);
}

.logout-btn {
  cursor: pointer;
  color: #e0e0e0;
  padding: 6px 15px;
  border-radius: 8px;
  background: linear-gradient(145deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05));
  transition: all 0.3s ease;
  border: 1px solid rgba(255,255,255,0.1);
}

.logout-btn:hover {
  background: linear-gradient(145deg, rgba(255,0,0,0.15), rgba(255,0,0,0.05));
  color: #ff4d4f;
  border-color: rgba(255,77,79,0.3);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(255,77,79,0.1);
}

.login-btn {
  padding: 8px 20px;
  border-radius: 8px;
  background: linear-gradient(145deg, #4ecdc4, #45b6af);
  color: #ffffff;
  font-weight: 600;
  transition: all 0.3s ease;
  border: none;
  box-shadow: 0 2px 6px rgba(78,205,196,0.2);
}

.login-btn:hover {
  background: linear-gradient(145deg, #45b6af, #3ca49d);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(78,205,196,0.3);
}

.admin-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px 15px;
  border-radius: 8px;
  background: linear-gradient(145deg, rgba(255,193,7,0.15), rgba(255,152,0,0.05));
  color: #ffa000;
  font-weight: 500;
  transition: all 0.3s ease;
  border: 1px solid rgba(255,193,7,0.2);
}

.admin-btn i {
  font-size: 16px;
  transition: transform 0.3s ease;
}

.admin-btn:hover {
  background: linear-gradient(145deg, rgba(255,193,7,0.25), rgba(255,152,0,0.1));
  color: #ffc107;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(255,193,7,0.15);
}

.admin-btn:hover i {
  transform: rotate(180deg);
}
</style>
