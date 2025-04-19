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
        <router-link to="/home" class="logo" @click="fixUserInfoBeforeNav">问知星球</router-link>
      </div>
    </div>
    <div class="nav-middle" style="padding-left: 250px;">
      <router-link to="/home" class="nav-item" @click="fixUserInfoBeforeNav">首页</router-link>
      <router-link to="/problems" class="nav-item" @click="fixUserInfoBeforeNav">题库与练习</router-link>
      <router-link to="/classroom" class="nav-item" @click="fixUserInfoBeforeNav">课堂辅助</router-link>
      <router-link to="/personal-center" class="nav-item" @click="fixUserInfoBeforeNav">个人中心</router-link>
    </div>
    <div class="nav-right">
      <template v-if="isLoggedIn">
        <router-link v-if="isAdminOrTeacher()" to="/admin" class="admin-btn" @click="fixUserInfoBeforeNav">
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
        <router-link to="/login" class="login-btn" @click="fixUserInfoBeforeNav">登录</router-link>
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

// 添加简单的防抖函数实现
const debounce = (fn, delay) => {
  let timer = null
  return function(...args) {
    if (timer) clearTimeout(timer)
    timer = setTimeout(() => {
      fn.apply(this, args)
    }, delay)
  }
}

const router = useRouter()
const isLoggedIn = ref(false)
const username = ref('')
const userRole = ref('')
const API_BASE_URL = 'http://localhost:3000'
const defaultAvatar = ref('http://localhost:3000/uploads/avatars/default-avatar.png')
const avatarUrl = ref(defaultAvatar.value)
const profileDialogVisible = ref(false)

const getFullAvatarUrl = (url) => {
  if (!url || url === 'null' || url === 'undefined') {
    return defaultAvatar.value;
  }
  
  if (url.startsWith('http')) {
    return url;
  }
  
  // 处理数据库中存储的路径
  if (url.includes('public/uploads/avatars/')) {
    const fileName = url.split('/').pop();
    const fullUrl = `${API_BASE_URL}/uploads/avatars/${fileName}?t=${Date.now()}`;
    return fullUrl;
  }
  
  // 处理其他情况
  const fullUrl = `${API_BASE_URL}${url}?t=${Date.now()}`;
  return fullUrl;
}

const isAdminOrTeacher = () => {
  console.log('isAdminOrTeacher called, current role:', userRole.value);
  const result = ['admin', 'teacher'].includes(userRole.value);
  console.log('isAdminOrTeacher result:', result);
  return result;
}

// 用于检查和修复登录一致性的方法
const checkUserConsistency = () => {
  const userInfoStr = localStorage.getItem('userInfo')
  if (!userInfoStr) return
  
  try {
    const userInfo = JSON.parse(userInfoStr)
    
    // 检查当前登录用户名是否与记录不一致
    const currentUsername = localStorage.getItem('currentUsername')
    
    if (currentUsername && currentUsername !== userInfo.username) {
      console.warn('检测到用户记录不一致，本地存储:', userInfo.username, '记录用户:', currentUsername)
      // 优先使用currentUsername记录的用户
      return;
    }
    
    // 保存之前的用户名以便于日志对比
    const prevUsername = username.value
    
    // 检查组件内状态与localStorage是否一致
    if (username.value && username.value !== userInfo.username) {
      console.warn('检测到用户名不一致:', username.value, '!=', userInfo.username)
      
      // 不再自动同步组件状态，而是提示用户刷新
      console.warn('建议刷新页面以恢复状态一致性')
      
      // 触发用户信息不一致事件
      window.dispatchEvent(new CustomEvent('userInfoInconsistent', {
        detail: { currentUsername: username.value, storedUsername: userInfo.username }
      }))
    }
  } catch (error) {
    console.error('检查用户一致性出错:', error)
  }
}

const checkLoginStatus = async () => {
  // 每次检查前先验证一致性
  checkUserConsistency()
  
  const userInfoStr = localStorage.getItem('userInfo')
  console.log('Checking login status, localStorage userInfo:', userInfoStr)
  
  if (userInfoStr) {
    try {
      const user = JSON.parse(userInfoStr)
      console.log('Parsed user info:', user)
      console.log('User role from storage:', user.role)
      
      // 更新登录状态和用户信息，但不主动请求新的用户信息
      isLoggedIn.value = true
      username.value = user.username
      userRole.value = user.role
      console.log('Set userRole.value to:', userRole.value)
      
      // 设置头像URL
      if (user.avatar_url) {
        avatarUrl.value = user.avatar_url
        console.log('使用localStorage中的头像URL:', avatarUrl.value)
      } else {
        // 使用默认头像，不再主动请求用户资料
        console.log('没有头像URL，使用默认头像')
        avatarUrl.value = defaultAvatar.value
      }
    } catch (error) {
      console.error('解析userInfo出错，视为未登录状态:', error)
      isLoggedIn.value = false
      username.value = ''
      userRole.value = ''
      avatarUrl.value = defaultAvatar.value
    }
  } else {
    console.log('No user info found in localStorage')
    isLoggedIn.value = false
    username.value = ''
    userRole.value = ''
    avatarUrl.value = defaultAvatar.value
  }
}

const forceReloadUserInfo = () => {
  console.log('强制刷新用户信息')
  checkLoginStatus()
}

// 使用防抖函数包装checkLoginStatus
const debouncedCheckLoginStatus = debounce(async () => {
  console.log('执行防抖后的登录状态检查')
  await checkLoginStatus()
}, 300)

const openUserProfileDialog = () => {
  // 确保使用当前显示的用户名，避免自动切换
  profileDialogVisible.value = true
}

const handleLogout = () => {
  const logoutUsername = username.value; // 记录当前登出的用户名
  
  // 清除所有存储的用户数据
  localStorage.clear();
  sessionStorage.clear();
  
  // 更新组件状态
  isLoggedIn.value = false
  username.value = ''
  userRole.value = ''
  avatarUrl.value = defaultAvatar.value
  
  console.log('用户已登出:', logoutUsername)
  
  // 直接刷新页面跳转到登录页
  window.location.href = '/login'
}

// 添加用户信息修复函数
const fixUserInfoBeforeNav = (event) => {
  console.log('点击导航链接，准备跳转...')
  
  // 获取当前用户名
  const currentUserInfoStr = localStorage.getItem('userInfo')
  if (!currentUserInfoStr) return
  
  try {
    const currentUserInfo = JSON.parse(currentUserInfoStr)
    const currentUsername = currentUserInfo.username
    
    // 如果当前组件显示的用户名与localStorage不一致，则阻止导航并刷新页面
    if (username.value && username.value !== currentUsername) {
      console.warn('导航前检测到用户名不一致:', username.value, '!=', currentUsername)
      console.warn('阻止导航，刷新以恢复一致性...')
      
      event.preventDefault() // 阻止链接默认行为
      window.location.reload() // 刷新页面以恢复一致性
      return
    }
  } catch (error) {
    console.error('导航前检查用户信息出错:', error)
  }
}

const diagnoseUserInfoStatus = () => {
  console.group('===== 用户状态诊断 =====');
  
  // 检查localStorage中的数据
  console.log('localStorage中的userInfo:');
  try {
    const userInfoStr = localStorage.getItem('userInfo');
    if (userInfoStr) {
      const userInfo = JSON.parse(userInfoStr);
      console.log('- 用户名:', userInfo.username);
      console.log('- 角色:', userInfo.role);
      console.log('- 头像:', userInfo.avatar_url);
      console.log('- 令牌存在:', !!userInfo.accessToken);
    } else {
      console.log('未找到用户信息');
    }
  } catch (e) {
    console.error('解析用户信息失败:', e);
  }
  
  // 检查组件中的状态
  console.log('\n组件中的状态:');
  console.log('- 是否登录:', isLoggedIn.value);
  console.log('- 用户名:', username.value);
  console.log('- 角色:', userRole.value);
  console.log('- 头像URL:', avatarUrl.value);
  
  // 检查sessionStorage中的数据
  console.log('\nsessionStorage中的数据:');
  console.log('- current_user:', sessionStorage.getItem('current_user'));
  
  // 检查其他可能影响用户状态的存储项
  console.log('\n其他相关存储项:');
  const userRelatedItems = [];
  
  for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i);
    if (key && (key.includes('user') || key.includes('token'))) {
      userRelatedItems.push({ key, storage: 'localStorage' });
    }
  }
  
  for (let i = 0; i < sessionStorage.length; i++) {
    const key = sessionStorage.key(i);
    if (key && (key.includes('user') || key.includes('token'))) {
      userRelatedItems.push({ key, storage: 'sessionStorage' });
    }
  }
  
  if (userRelatedItems.length > 0) {
    userRelatedItems.forEach(item => {
      console.log(`- ${item.storage}: ${item.key}`);
    });
  } else {
    console.log('未找到其他相关存储项');
  }
  
  console.groupEnd();
  
  return {
    componentState: {
      isLoggedIn: isLoggedIn.value,
      username: username.value,
      role: userRole.value
    },
    localStorage: localStorage.getItem('userInfo'),
    sessionStorage: sessionStorage.getItem('current_user')
  };
};

// 挂载到window对象，方便在浏览器控制台中调用
window.diagnoseUserInfo = diagnoseUserInfoStatus;

// 添加强制同步用户状态的函数
const syncUserState = () => {
  const userInfoStr = localStorage.getItem('userInfo')
  if (!userInfoStr) {
    isLoggedIn.value = false
    username.value = ''
    userRole.value = ''
    avatarUrl.value = defaultAvatar.value
    return
  }

  try {
    const userInfo = JSON.parse(userInfoStr)
    isLoggedIn.value = true
    username.value = userInfo.username
    userRole.value = userInfo.role
    
    // 保存当前用户名到localStorage
    localStorage.setItem('currentUsername', userInfo.username)
    
    if (userInfo.avatar_url) {
      avatarUrl.value = userInfo.avatar_url
    } else {
      avatarUrl.value = defaultAvatar.value
    }
    
    console.log('已同步用户状态:', userInfo.username)
  } catch (error) {
    console.error('同步用户状态失败:', error)
  }
}

onMounted(() => {
  // 首先同步用户状态
  syncUserState()
  
  // 监听头像更新事件，使用防抖函数避免频繁调用
  window.addEventListener('userAvatarUpdated', debouncedCheckLoginStatus)
  
  // 监听用户信息变更事件
  window.addEventListener('userInfoChanged', checkUserConsistency)
  
  // 监听存储变化事件
  window.addEventListener('storage', (event) => {
    if (event.key === 'userInfo' || event.key === 'currentUsername') {
      console.log('检测到存储变化，重新同步用户状态')
      syncUserState()
    }
  })
  
  // 添加全局方法以强制重新加载
  window.forceReloadUserInfo = syncUserState
})

onUnmounted(() => {
  // 移除事件监听
  window.removeEventListener('userAvatarUpdated', debouncedCheckLoginStatus)
  window.removeEventListener('userInfoChanged', checkUserConsistency)
  
  // 移除全局方法
  if (window.forceReloadUserInfo === syncUserState) {
    delete window.forceReloadUserInfo
  }
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
