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
      <router-link to="/ai-center" class="nav-item" @click="fixUserInfoBeforeNav">AI中心</router-link>
      <router-link to="/personal-center" class="nav-item" @click="fixUserInfoBeforeNav">个人中心</router-link>
      <router-link to="/classroom" class="nav-item" @click="fixUserInfoBeforeNav">课堂辅助</router-link>
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
        <!-- <a @click="handleRefreshUserState" class="refresh-btn" title="刷新用户状态">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.2"/>
          </svg>
        </a>
        <a @click="diagnoseLoginState" class="diagnose-btn" title="诊断登录状态">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <path d="M12 16v-4m0-4h.01"></path>
          </svg>
        </a> -->
        <a @click="handleLogout" class="logout-btn">登出</a>
      </template>
      <template v-else>
        <a @click="diagnoseLoginState" class="diagnose-btn" title="诊断登录状态">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <path d="M12 16v-4m0-4h.01"></path>
          </svg>
        </a>
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
// import { useRouter } from 'vue-router'
import UserProfileDialog from './UserProfileDialog.vue'
import { getResourceUrl } from '@/utils/api'
import { ElMessage } from 'element-plus'

// 获取router实例
// const router = useRouter()

// 添加简单的防抖函数实现
const debounce = (fn, delay) => {
  let timer = null
  return function (...args) {
    if (timer) clearTimeout(timer)
    timer = setTimeout(() => {
      fn.apply(this, args)
    }, delay)
  }
}

const isLoggedIn = ref(false)
const username = ref('')
const userRole = ref('')
const defaultAvatar = ref(getResourceUrl('uploads/avatars/default-avatar.png'))
const avatarUrl = ref(defaultAvatar.value)
const profileDialogVisible = ref(false)

const getFullAvatarUrl = (url) => {
  // 检查URL是否为空或无效
  if (!url || url === 'null' || url === 'undefined') {
    console.log('无效的头像URL，使用默认头像')
    return '/uploads/avatars/default-avatar.png?t=' + Date.now()
  }

  console.log('处理头像URL:', url)

  // 已经是完整URL的情况
  if (url.startsWith('http')) {
    return url
  }

  // 处理以public开头的路径 - 这是从服务器返回的常见格式
  if (url.startsWith('public/')) {
    // 移除public前缀，因为在nginx配置中，public目录已经映射到根目录
    const realPath = url.replace('public/', '')
    console.log('处理public/前缀头像，结果:', `/${realPath}?t=${Date.now()}`)
    return `/${realPath}?t=${Date.now()}`
  }

  // 如果url包含uploads/avatars，构建完整URL
  if (url.includes('uploads/avatars/')) {
    const fileName = url.split('/').pop().split('?')[0] // 获取文件名，去除查询参数
    console.log('处理uploads/avatars路径，结果:', `/uploads/avatars/${fileName}?t=${Date.now()}`)
    return `/uploads/avatars/${fileName}?t=${Date.now()}`
  }

  // 处理可能只有文件名的情况
  if (!url.includes('/') && !url.includes('?')) {
    console.log('处理纯文件名，结果:', `/uploads/avatars/${url}?t=${Date.now()}`)
    return `/uploads/avatars/${url}?t=${Date.now()}`
  }

  // 其他情况
  console.log('处理其他URL格式，结果:', `${url.startsWith('/') ? '' : '/'}${url}?t=${Date.now()}`)
  return `${url.startsWith('/') ? '' : '/'}${url}?t=${Date.now()}`
}

const isAdminOrTeacher = () => {
  console.log('isAdminOrTeacher called, current role:', userRole.value)
  const result = ['admin', 'teacher'].includes(userRole.value)
  console.log('isAdminOrTeacher result:', result)
  return result
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
      return
    }

    // 保存之前的用户名以便于日志对比
    // const prevUsername = username.value

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

      // 检查令牌是否存在并将其保存到localStorage
      if (user.accessToken) {
        localStorage.setItem('accessToken', user.accessToken)
        console.log('已保存令牌到localStorage: accessToken')
      } else {
        console.warn('用户信息中没有找到令牌')
      }

      // 保存刷新令牌
      if (user.refreshToken) {
        localStorage.setItem('refreshToken', user.refreshToken)
        console.log('已保存令牌到localStorage: refreshToken')
      }

      // 更新登录状态和用户信息，但不主动请求新的用户信息
      isLoggedIn.value = true
      username.value = user.username
      userRole.value = user.role
      console.log('Set userRole.value to:', userRole.value)

      // 调试日志：详细输出头像URL信息
      console.log('用户头像URL信息:', user.avatar_url)

      // 优化头像URL处理逻辑，减少多次重复设置
      if (user.avatar_url) {
        // 确保每次获取都应用正确的URL转换逻辑
        const processedAvatarUrl = getFullAvatarUrl(user.avatar_url)
        console.log('处理后的头像URL:', processedAvatarUrl)
        avatarUrl.value = processedAvatarUrl
      } else {
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
    // 避免重复设置相同的值
    if (isLoggedIn.value || username.value || userRole.value || avatarUrl.value !== defaultAvatar.value) {
      console.log('No user info found in localStorage, resetting state')
      isLoggedIn.value = false
      username.value = ''
      userRole.value = ''
      avatarUrl.value = defaultAvatar.value
    }
  }
}

/* const forceReloadUserInfo = () => {
  console.log('强制刷新用户信息')
  checkLoginStatus()
} */

// 使用防抖函数包装checkLoginStatus
const debouncedCheckLoginStatus = debounce(async () => {
  console.log('执行防抖后的登录状态检查')
  await checkLoginStatus()
}, 300)

const openUserProfileDialog = () => {
  // 每次打开弹窗前，强制同步一次登录状态
  checkLoginStatus()
  if (!username.value || username.value === 'undefined') {
    ElMessage.error('用户信息异常，请刷新页面或重新登录')
    return
  }
  profileDialogVisible.value = true
}

// 创建变量存储定时器引用
let statusCheckInterval = null

// 添加一个会话存储管理器
const sessionStorageManager = {
  // 保存用户信息到sessionStorage
  saveUserInfo (userInfo) {
    try {
      sessionStorage.setItem('session_user_info', JSON.stringify(userInfo))
      sessionStorage.setItem('session_username', userInfo.username)
      sessionStorage.setItem('session_role', userInfo.role || 'user')
      sessionStorage.setItem('session_avatar_url', userInfo.avatar_url || '')
      if (userInfo.accessToken) {
        sessionStorage.setItem('session_accessToken', userInfo.accessToken)
      }
      if (userInfo.refreshToken) {
        sessionStorage.setItem('session_refreshToken', userInfo.refreshToken)
      }
      console.log('已保存用户信息到sessionStorage:', userInfo.username)
      return true
    } catch (e) {
      console.error('保存用户信息到sessionStorage失败:', e)
      return false
    }
  },

  // 获取用户信息从sessionStorage
  getUserInfo () {
    try {
      // 先尝试获取完整对象
      const userInfoStr = sessionStorage.getItem('session_user_info')
      if (userInfoStr) {
        return JSON.parse(userInfoStr)
      }

      // 如果没有完整对象，但有用户名，则构建基本对象
      const username = sessionStorage.getItem('session_username')
      if (username) {
        return {
          username: username,
          role: sessionStorage.getItem('session_role') || 'user',
          accessToken: sessionStorage.getItem('session_accessToken') || '',
          refreshToken: sessionStorage.getItem('session_refreshToken') || '',
          avatar_url: sessionStorage.getItem('session_avatar_url') || ''
        }
      }
      return null
    } catch (e) {
      console.error('从sessionStorage获取用户信息失败:', e)
      return null
    }
  },

  // 清除所有用户相关的会话存储
  clearUserInfo () {
    try {
      sessionStorage.removeItem('session_user_info')
      sessionStorage.removeItem('session_username')
      sessionStorage.removeItem('session_role')
      sessionStorage.removeItem('session_avatar_url')
      sessionStorage.removeItem('session_accessToken')
      sessionStorage.removeItem('session_refreshToken')
      console.log('已清除sessionStorage中的用户信息')
      return true
    } catch (e) {
      console.error('清除sessionStorage中用户信息失败:', e)
      return false
    }
  },

  // 同步会话存储到localStorage
  syncToLocalStorage () {
    try {
      const userInfo = this.getUserInfo()
      if (!userInfo) return false

      // 尝试保存到localStorage
      try {
        localStorage.setItem('userInfo', JSON.stringify(userInfo))
        localStorage.setItem('accessToken', userInfo.accessToken || '')
        localStorage.setItem('refreshToken', userInfo.refreshToken || '')
        localStorage.setItem('currentUsername', userInfo.username)
        console.log('已同步会话存储到localStorage')
        return true
      } catch (e) {
        console.warn('同步到localStorage失败:', e)
        return false
      }
    } catch (e) {
      console.error('准备同步数据失败:', e)
      return false
    }
  }
}
// 暂时注释掉诊断按钮
// 修改诊断登录状态函数
const diagnoseLoginState = () => {
  console.group('===== 实时登录状态诊断 =====')

  console.log('当前组件状态:')
  console.log('- 是否登录:', isLoggedIn.value)
  console.log('- 用户名:', username.value)
  console.log('- 角色:', userRole.value)
  console.log('- 头像URL:', avatarUrl.value)

  // 检查会话存储
  const sessionUserInfo = sessionStorageManager.getUserInfo()
  console.log('\n会话存储内容:')
  if (sessionUserInfo) {
    console.log('- 用户名:', sessionUserInfo.username)
    console.log('- 角色:', sessionUserInfo.role)
    console.log('- 令牌存在:', !!sessionUserInfo.accessToken)
    console.log('- 头像URL:', sessionUserInfo.avatar_url)
  } else {
    console.log('会话存储中没有用户信息')
  }

  // 检查localStorage
  console.log('\nLocalStorage 内容:')
  // let userInfo = null
  let userInfoStr = null
  try {
    userInfoStr = localStorage.getItem('userInfo')
    if (userInfoStr) {
      // userInfo = JSON.parse(userInfoStr)
      console.log('- userInfo 数据存在')
    } else {
      console.log('- userInfo: 未找到')
    }
  } catch (e) {
    console.log('解析userInfo失败:', e)
    // userInfo = null
  }

  // 检查可能的问题
  console.log('\n可能的问题:')
  let problemsFound = false

  // 检查组件状态与会话存储的一致性
  if (isLoggedIn.value && !sessionUserInfo) {
    console.log('× 组件显示已登录，但会话存储中没有用户信息')
    problemsFound = true

    // 恢复会话存储
    if (username.value) {
      const userData = {
        username: username.value,
        role: userRole.value || 'user',
        avatar_url: avatarUrl.value,
        accessToken: localStorage.getItem('accessToken') || '',
        refreshToken: localStorage.getItem('refreshToken') || ''
      }

      sessionStorageManager.saveUserInfo(userData)
      console.log('已从组件状态恢复会话存储')
    }
  } else if (!isLoggedIn.value && sessionUserInfo) {
    console.log('× 组件显示未登录，但会话存储中有用户信息')
    problemsFound = true
  }

  // 检查头像URL是否丢失
  if (isLoggedIn.value && (!avatarUrl.value || avatarUrl.value === defaultAvatar.value) &&
      sessionUserInfo && sessionUserInfo.avatar_url) {
    avatarUrl.value = getFullAvatarUrl(sessionUserInfo.avatar_url)
    console.log('已恢复丢失的头像URL')
  }

  console.groupEnd()

  // 修复问题
  if (problemsFound) {
    console.log('尝试修复登录状态...')

    // 从会话存储恢复组件状态
    if (!isLoggedIn.value && sessionUserInfo) {
      isLoggedIn.value = true
      username.value = sessionUserInfo.username
      userRole.value = sessionUserInfo.role || 'user'

      if (sessionUserInfo.avatar_url) {
        avatarUrl.value = getFullAvatarUrl(sessionUserInfo.avatar_url)
      }

      console.log('已从会话存储恢复登录状态')

      // 尝试同步到localStorage
      sessionStorageManager.syncToLocalStorage()
    }
    // 从组件状态恢复会话存储
    else if (isLoggedIn.value && !sessionUserInfo && username.value) {
      const userData = {
        username: username.value,
        role: userRole.value || 'user',
        avatar_url: avatarUrl.value,
        accessToken: localStorage.getItem('accessToken') || '',
        refreshToken: localStorage.getItem('refreshToken') || ''
      }

      sessionStorageManager.saveUserInfo(userData)
      console.log('已从组件状态恢复会话存储')

      // 尝试同步到localStorage
      sessionStorageManager.syncToLocalStorage()
    }

    // 添加消息提示
    ElMessage({
      message: '已修复登录状态',
      type: 'success',
      duration: 3000
    })
  } else {
    console.log('诊断完成，未发现需要修复的问题')
  }

  return {
    isLoggedIn: isLoggedIn.value,
    username: username.value,
    sessionStorageHasUser: !!sessionUserInfo,
    localStorageHasUser: !!userInfoStr
  }
}

// 修改同步用户状态函数
const syncUserState = () => {
  console.log('执行用户状态同步...')

  // 优先从会话存储获取用户信息
  const sessionUserInfo = sessionStorageManager.getUserInfo()
  if (sessionUserInfo) {
    console.log('从会话存储获取到用户信息:', sessionUserInfo.username)

    // 更新组件状态
    isLoggedIn.value = true
    username.value = sessionUserInfo.username
    userRole.value = sessionUserInfo.role || 'user'

    // 处理头像URL
    if (sessionUserInfo.avatar_url) {
      avatarUrl.value = getFullAvatarUrl(sessionUserInfo.avatar_url)
      console.log('同步用户状态：从会话存储设置头像URL:', sessionUserInfo.avatar_url)
    } else {
      avatarUrl.value = defaultAvatar.value
      console.log('同步用户状态：会话存储中没有头像URL，使用默认头像')
    }

    console.log('已从会话存储同步用户状态')

    // 尝试同步到localStorage
    sessionStorageManager.syncToLocalStorage()
    return
  }

  // 如果会话存储中没有，再尝试从localStorage获取
  const userInfoStr = localStorage.getItem('userInfo')
  if (!userInfoStr) {
    console.log('localStorage和会话存储中没有用户信息')

    // 检查是否当前显示为已登录状态
    if (isLoggedIn.value && username.value) {
      console.log('检测到用户已登录但存储中无数据，保存当前状态...')

      // 保存当前状态到会话存储
      const userData = {
        username: username.value,
        role: userRole.value || 'user',
        avatar_url: avatarUrl.value,
        accessToken: localStorage.getItem('accessToken') || '',
        refreshToken: localStorage.getItem('refreshToken') || ''
      }

      sessionStorageManager.saveUserInfo(userData)
      console.log('已保存当前登录状态到会话存储')

      // 尝试同步到localStorage
      sessionStorageManager.syncToLocalStorage()
      return
    }

    // 如果没有登录状态，则设置为未登录
    console.log('设置为未登录状态')
    isLoggedIn.value = false
    username.value = ''
    userRole.value = ''
    avatarUrl.value = defaultAvatar.value
    return
  }

  try {
    console.log('解析localStorage中的用户信息')
    const userInfo = JSON.parse(userInfoStr)
    console.log('获取到用户信息:', userInfo)

    // 保存到会话存储
    sessionStorageManager.saveUserInfo(userInfo)

    // 更新组件状态
    isLoggedIn.value = true
    username.value = userInfo.username
    userRole.value = userInfo.role || 'user'

    // 处理头像URL
    if (userInfo.avatar_url) {
      avatarUrl.value = getFullAvatarUrl(userInfo.avatar_url)
      console.log('同步用户状态：处理后的头像URL:', avatarUrl.value)
    } else {
      avatarUrl.value = defaultAvatar.value
      console.log('同步用户状态：没有头像URL，使用默认头像')
    }

    console.log('已同步用户状态:', userInfo.username)
  } catch (error) {
    console.error('同步用户状态失败:', error)
  }
}

// 修改挂载函数
onMounted(() => {
  console.log('NavBar组件挂载，开始检查登录状态...')

  // 先从会话存储恢复状态
  const sessionUserInfo = sessionStorageManager.getUserInfo()
  if (sessionUserInfo) {
    console.log('从会话存储恢复用户状态:', sessionUserInfo.username)

    isLoggedIn.value = true
    username.value = sessionUserInfo.username
    userRole.value = sessionUserInfo.role || 'user'

    if (sessionUserInfo.avatar_url) {
      avatarUrl.value = getFullAvatarUrl(sessionUserInfo.avatar_url)
      console.log('已恢复头像URL:', sessionUserInfo.avatar_url)
    }

    // 尝试同步到localStorage
    sessionStorageManager.syncToLocalStorage()
  }
  // 如果会话存储中没有，则同步用户状态
  else {
    syncUserState()
  }

  console.log('初始同步完成，登录状态:', isLoggedIn.value, '用户名:', username.value)

  // 监听头像更新事件，使用防抖函数避免频繁调用
  window.addEventListener('userAvatarUpdated', debouncedCheckLoginStatus)

  // 监听用户信息变更事件，直接同步状态而不是仅检查一致性
  window.addEventListener('userInfoChanged', userInfoChangeHandler)

  // 监听存储变化事件
  window.addEventListener('storage', storageChangeHandler)

  // 添加页面刷新前检测
  window.addEventListener('beforeunload', beforeUnloadHandler)

  // 添加全局方法以强制重新加载
  window.forceReloadUserInfo = () => {
    console.log('执行全局强制重新加载用户信息')
    syncUserState()
  }

  // 定期检查登录状态保持一致性
  statusCheckInterval = setInterval(() => {
    const sessionUserInfo = sessionStorageManager.getUserInfo()
    const hasSessionUserInfo = !!sessionUserInfo

    // 检查状态是否一致
    if (isLoggedIn.value !== hasSessionUserInfo) {
      console.warn('登录状态不一致，会话存储:', hasSessionUserInfo, '组件状态:', isLoggedIn.value)

      if (hasSessionUserInfo && !isLoggedIn.value) {
        // 会话存储有用户信息但组件显示未登录，同步到组件
        isLoggedIn.value = true
        username.value = sessionUserInfo.username
        userRole.value = sessionUserInfo.role || 'user'

        if (sessionUserInfo.avatar_url) {
          avatarUrl.value = getFullAvatarUrl(sessionUserInfo.avatar_url)
        }

        console.log('已从会话存储恢复组件状态')
      } else if (isLoggedIn.value && !hasSessionUserInfo) {
        // 组件显示已登录但会话存储无用户信息，保存到会话存储
        const userData = {
          username: username.value,
          role: userRole.value || 'user',
          avatar_url: avatarUrl.value,
          accessToken: localStorage.getItem('accessToken') || '',
          refreshToken: localStorage.getItem('refreshToken') || ''
        }

        sessionStorageManager.saveUserInfo(userData)
        console.log('已从组件状态恢复会话存储')
      }
    }

    // 检查头像是否丢失
    if (isLoggedIn.value && (!avatarUrl.value || avatarUrl.value === defaultAvatar.value) &&
        sessionUserInfo && sessionUserInfo.avatar_url) {
      avatarUrl.value = getFullAvatarUrl(sessionUserInfo.avatar_url)
      console.log('已恢复丢失的头像URL')
    }
  }, 5000) // 每5秒检查一次
})

onUnmounted(() => {
  // 移除事件监听
  window.removeEventListener('userAvatarUpdated', debouncedCheckLoginStatus)
  window.removeEventListener('userInfoChanged', userInfoChangeHandler)
  window.removeEventListener('storage', storageChangeHandler)
  window.removeEventListener('beforeunload', beforeUnloadHandler)

  // 移除全局方法
  if (typeof window.forceReloadUserInfo === 'function') {
    delete window.forceReloadUserInfo
  }

  // 清除定时器
  if (statusCheckInterval) {
    clearInterval(statusCheckInterval)
    statusCheckInterval = null
  }
})

// 修改用户登出函数
const handleLogout = () => {
  const logoutUsername = username.value // 记录当前登出的用户名
  console.log(`执行用户登出操作: ${logoutUsername}`)

  try {
    // 清除会话存储
    sessionStorageManager.clearUserInfo()

    // 使用Vuex的logout action
    import('@/store').then(({ default: store }) => {
      store.dispatch('logout')
      console.log('已通过Vuex执行登出操作')
    }).catch(error => {
      console.error('Vuex登出失败，回退到手动清理:', error)
      // 手动清理所有数据
      manualCleanup()
    })
  } catch (error) {
    console.error('登出过程出错，回退到手动清理:', error)
    // 手动清理所有数据
    manualCleanup()
  }

  // 更新组件状态
  isLoggedIn.value = false
  username.value = ''
  userRole.value = ''
  avatarUrl.value = defaultAvatar.value

  console.log('用户已登出状态已重置')

  // 直接刷新页面跳转到登录页
  window.location.href = '/login'
}

// 手动清理所有存储的函数
const manualCleanup = () => {
  console.log('执行手动数据清理...')

  // 清除所有localStorage
  localStorage.removeItem('userInfo')
  localStorage.removeItem('accessToken')
  localStorage.removeItem('refreshToken')
  localStorage.removeItem('currentUsername')
  localStorage.removeItem('last_active_user')

  // 清除所有sessionStorage
  sessionStorage.removeItem('current_user')
  sessionStorage.removeItem('last_active_user')

  console.log('手动数据清理完成')
}

// 添加用户信息修复函数
const fixUserInfoBeforeNav = (event) => {
  console.log('点击导航链接，准备跳转...')

  // 获取当前用户名
  const currentUserInfoStr = localStorage.getItem('userInfo')
  if (!currentUserInfoStr) {
    console.warn('localStorage中没有用户信息，可能用户未登录')
    return
  }

  try {
    const currentUserInfo = JSON.parse(currentUserInfoStr)

    // 重新同步令牌到localStorage，确保令牌可用
    if (currentUserInfo.accessToken) {
      localStorage.setItem('accessToken', currentUserInfo.accessToken)
      console.log('导航前已更新令牌: accessToken')
    }

    if (currentUserInfo.refreshToken) {
      localStorage.setItem('refreshToken', currentUserInfo.refreshToken)
      console.log('导航前已更新令牌: refreshToken')
    }

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
  console.group('===== 用户状态诊断 =====')

  // 检查localStorage中的数据
  console.log('localStorage中的userInfo:')
  try {
    const userInfoStr = localStorage.getItem('userInfo')
    if (userInfoStr) {
      const userInfo = JSON.parse(userInfoStr)
      console.log('- 用户名:', userInfo.username)
      console.log('- 角色:', userInfo.role)
      console.log('- 头像:', userInfo.avatar_url)
      console.log('- 令牌存在:', !!userInfo.accessToken)
    } else {
      console.log('未找到用户信息')
    }
  } catch (e) {
    console.error('解析用户信息失败:', e)
  }

  // 检查组件中的状态
  console.log('\n组件中的状态:')
  console.log('- 是否登录:', isLoggedIn.value)
  console.log('- 用户名:', username.value)
  console.log('- 角色:', userRole.value)
  console.log('- 头像URL:', avatarUrl.value)

  // 检查sessionStorage中的数据
  console.log('\nsessionStorage中的数据:')
  console.log('- current_user:', sessionStorage.getItem('current_user'))

  // 检查其他可能影响用户状态的存储项
  console.log('\n其他相关存储项:')
  const userRelatedItems = []

  for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i)
    if (key && (key.includes('user') || key.includes('token'))) {
      userRelatedItems.push({ key, storage: 'localStorage' })
    }
  }

  for (let i = 0; i < sessionStorage.length; i++) {
    const key = sessionStorage.key(i)
    if (key && (key.includes('user') || key.includes('token'))) {
      userRelatedItems.push({ key, storage: 'sessionStorage' })
    }
  }

  if (userRelatedItems.length > 0) {
    userRelatedItems.forEach(item => {
      console.log(`- ${item.storage}: ${item.key}`)
    })
  } else {
    console.log('未找到其他相关存储项')
  }

  console.groupEnd()

  return {
    componentState: {
      isLoggedIn: isLoggedIn.value,
      username: username.value,
      role: userRole.value
    },
    localStorage: localStorage.getItem('userInfo'),
    sessionStorage: sessionStorage.getItem('current_user')
  }
}

// 挂载到window对象，方便在浏览器控制台中调用
window.diagnoseUserInfo = diagnoseUserInfoStatus

// 创建事件处理函数的引用，以便于绑定和解绑
const userInfoChangeHandler = () => {
  console.log('检测到用户信息变更事件，重新同步状态')
  syncUserState()
}

const storageChangeHandler = (event) => {
  if (event.key === 'userInfo' || event.key === 'currentUsername' || event.key === 'accessToken') {
    console.log('检测到存储变化，重新同步用户状态')
    syncUserState()
  }
}

const beforeUnloadHandler = () => {
  // 记录当前用户状态，以便页面刷新后恢复
  if (isLoggedIn.value && username.value) {
    console.log('页面即将刷新，保存当前用户状态:', username.value)
    sessionStorage.setItem('last_active_user', username.value)
  }
}
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

.refresh-btn {
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #e0e0e0;
  padding: 6px;
  border-radius: 50%;
  background: linear-gradient(145deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05));
  transition: all 0.3s ease;
  border: 1px solid rgba(255,255,255,0.1);
  width: 30px;
  height: 30px;
}

.refresh-btn:hover {
  background: linear-gradient(145deg, rgba(24,144,255,0.15), rgba(24,144,255,0.05));
  color: #1890ff;
  border-color: rgba(24,144,255,0.3);
  transform: rotate(180deg);
  box-shadow: 0 0 10px rgba(24,144,255,0.2);
}

.diagnose-btn {
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #e0e0e0;
  padding: 6px;
  border-radius: 50%;
  background: linear-gradient(145deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05));
  transition: all 0.3s ease;
  border: 1px solid rgba(255,255,255,0.1);
  width: 30px;
  height: 30px;
}

.diagnose-btn:hover {
  background: linear-gradient(145deg, rgba(250,173,20,0.15), rgba(250,173,20,0.05));
  color: #faad14;
  border-color: rgba(250,173,20,0.3);
  transform: scale(1.1);
  box-shadow: 0 0 10px rgba(250,173,20,0.2);
}
</style>
