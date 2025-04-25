/* eslint-disable vue/multi-word-component-names */
<template>
  <div class="page-container">
    <div class="background-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>

    <div class="main-container">
      <!-- 左侧介绍区域 -->
      <div class="intro-section">
        <div class="intro-card">
          <div class="brand-container">
            <div class="logo-container">
              <svg class="planet-logo" width="120" height="120" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
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
            </div>
            <h1 class="brand-title">
              <span class="wave-text">QuizPlanet</span>
              <span class="highlight-text">for OIer</span>
            </h1>
            <div class="brand-tag flip-button">
              <div class="flip-button-inner">
                <div class="flip-button-front">全新一代AI辅助编程方式</div>
                <div class="flip-button-back">开启你的编程之旅</div>
              </div>
            </div>
            <p class="brand-subtitle">
              带OIer玩转代码世界的奇妙之旅
            </p>
          </div>

          <div class="features-list">
            <div class="feature-card">
              <Icon icon="carbon:ai-status" class="feature-icon" />
              <span>AI代码分析</span>
            </div>
            <div class="feature-card">
              <Icon icon="carbon:code" class="feature-icon" />
              <span>实时编程指导</span>
            </div>
            <div class="feature-card">
              <Icon icon="carbon:chart-relationship" class="feature-icon" />
              <span>学习路径可视化</span>
            </div>
          </div>

          <button class="start-button">
            <span>Get Started</span>
            <div class="button-effect"></div>
          </button>
        </div>
      </div>

      <!-- 右侧登录区域 -->
      <div class="login-section">
        <div class="login-box">
          <h2 class="login-title">Welcome QuizPlanet</h2>
          <p class="login-subtitle">输入你的账号</p>

          <form @submit.prevent="handleLogin">
            <div class="form-item">
              <Icon icon="carbon:user" class="input-icon" />
              <input
                type="text"
                v-model="loginForm.username"
                placeholder="请输入用户名"
                required
              >
            </div>

            <div class="form-item">
              <Icon icon="carbon:password" class="input-icon" />
              <input
                :type="showPassword ? 'text' : 'password'"
                v-model="loginForm.password"
                placeholder="请输入密码"
                required
              >
              <div class="password-toggle" @click="togglePassword">
                <Icon :icon="showPassword ? 'carbon:view' : 'carbon:view-off'" />
              </div>
            </div>

            <div class="form-options">
              <label class="remember-pwd">
                <input type="checkbox" v-model="loginForm.remember">
                <span>记住密码</span>
              </label>
            </div>

            <button type="submit" class="login-button">
              <span>点击开启AI编程之旅</span>
              <Icon icon="carbon:arrow-right" class="button-icon" />
            </button>
          </form>

          <div class="divider">
          </div>

          <div class="help-buttons">
            <button class="help-button" @click="router.push('/login/reset-password')">
              <Icon icon="mdi:lock-reset" />
              <span>忘记密码</span>
            </button>

            <button class="help-button" @click="router.push('/login/phone')">
              <Icon icon="carbon:mobile" />
              <span>验证码登录</span>
            </button>

            <button class="help-button" @click="router.push('/register')">
              <Icon icon="carbon:user-profile" />
              <span>注册账号</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { Icon } from '@iconify/vue'
import { ElMessage } from 'element-plus'
import store from '@/store'
import request, { setGlobalToken } from '@/utils/request'
/* import axios from 'axios' */

const router = useRouter()
const showPassword = ref(false)
const isDarkMode = ref(false)

const loginForm = reactive({
  username: '',
  password: '',
  remember: false
})

const togglePassword = () => {
  showPassword.value = !showPassword.value
}

// 测试localStorage是否可用
const testLocalStorage = () => {
  try {
    // 测试localStorage是否可用
    const testKey = '_test_storage_' + Date.now()
    localStorage.setItem(testKey, 'test')
    const testValue = localStorage.getItem(testKey)
    localStorage.removeItem(testKey)

    if (testValue !== 'test') {
      console.error('localStorage测试失败: 存储和读取值不匹配')
      return false
    }

    // 测试存储大对象
    const bigObject = {
      data: new Array(1000).fill('test').join(''),
      timestamp: Date.now()
    }

    try {
      localStorage.setItem('_test_big_object_', JSON.stringify(bigObject))
      localStorage.removeItem('_test_big_object_')
      console.log('localStorage大对象测试通过')
    } catch (e) {
      console.error('localStorage大对象测试失败:', e)
      return false
    }

    console.log('localStorage测试通过')
    return true
  } catch (e) {
    console.error('localStorage测试出错:', e)
    return false
  }
}

// 估算对象大小（字节）
const getObjectSize = (obj) => {
  const str = JSON.stringify(obj)
  // UTF-16编码中，一个字符占2个字节
  return str.length * 2
}

// 检查localStorage剩余空间
const checkLocalStorageSpace = () => {
  try {
    // 获取当前已使用空间
    let usedSpace = 0
    for (let i = 0; i < localStorage.length; i++) {
      const key = localStorage.key(i)
      const value = localStorage.getItem(key)
      usedSpace += (key.length + value.length) * 2 // UTF-16编码
    }

    // 大多数浏览器localStorage限制为5MB
    const MAX_SPACE = 5 * 1024 * 1024
    const remainingSpace = MAX_SPACE - usedSpace

    console.log(`localStorage已使用空间: ${(usedSpace / 1024 / 1024).toFixed(2)}MB`)
    console.log(`localStorage剩余空间: ${(remainingSpace / 1024 / 1024).toFixed(2)}MB`)

    return {
      usedSpace,
      remainingSpace,
      isEnoughSpace: remainingSpace > 50 * 1024 // 至少需要50KB
    }
  } catch (e) {
    console.error('检查localStorage空间失败:', e)
    return { usedSpace: 0, remainingSpace: 0, isEnoughSpace: false }
  }
}

// 添加检查记住的密码函数
const checkRememberedPassword = async (username) => {
  try {
    // 使用后端已实现的API路由
    const response = await request.get(`/api/login/remembered-password/${username}`)
    if (response.success && response.data.hasRememberedPassword) {
      loginForm.remember = true
      // 如果有记住的密码，自动填充密码字段
      const loginResponse = await request.post('/api/login', {
        username,
        password: '', // 发送空密码，因为我们只是想获取记住的密码
        getRemembered: true
      })
      if (loginResponse.success && loginResponse.data.rememberedPassword) {
        // 直接使用后端返回的原始密码
        loginForm.password = loginResponse.data.rememberedPassword
        console.log('成功获取记住的密码')
      }
    }
  } catch (error) {
    console.error('检查记住的密码失败:', error)
  }
}

// 监听用户名变化
watch(() => loginForm.username, async (newUsername) => {
  if (newUsername) {
    await checkRememberedPassword(newUsername)
  }
})

const handleLogin = async () => {
  try {
    // 保存用户名到localStorage
    localStorage.setItem('lastUsername', loginForm.username)

    // 测试localStorage是否可用
    const isLocalStorageWorking = testLocalStorage()
    if (!isLocalStorageWorking) {
      console.error('localStorage不可用，将使用sessionStorage作为备用')
    }

    // 在发送请求前先清除所有存储的用户数据
    localStorage.clear() // 彻底清除所有localStorage数据
    sessionStorage.clear() // 彻底清除所有sessionStorage数据

    // 检查localStorage空间
    const { isEnoughSpace, remainingSpace } = checkLocalStorageSpace()
    if (!isEnoughSpace) {
      console.warn(`localStorage空间不足，只有${remainingSpace}字节可用，至少需要50KB`)
    }

    console.log('[登录] 发送登录请求，用户名:', loginForm.username)

    // 使用后端已实现的API路由
    const response = await request.post('/api/login', {
      username: loginForm.username,
      password: loginForm.password,
      remember: loginForm.remember
    })

    const data = response
    console.log('[登录] 登录返回数据:', data)

    if (data.success) {
      const { accessToken, refreshToken, ...userInfo } = data.data

      console.log(`成功登录用户: ${userInfo.username}, 角色: ${userInfo.role}`)

      // 处理头像URL
      if (userInfo.avatar_url) {
        // 确保avatar_url使用正确的格式
        console.log('原始头像URL:', userInfo.avatar_url)
        // 如果头像URL以public/开头，移除public/前缀
        if (userInfo.avatar_url.startsWith('public/')) {
          userInfo.avatar_url = userInfo.avatar_url.replace('public/', '')
          console.log('处理后的头像URL:', userInfo.avatar_url)
        }
      }

      // 如果选择记住密码，则保存密码
      if (loginForm.remember) {
        userInfo.password = loginForm.password
        userInfo.remember = true
      }

      // 将token也存储在userInfo中
      userInfo.accessToken = accessToken
      userInfo.refreshToken = refreshToken

      // 准备存储到localStorage的完整用户信息
      const userInfoStr = JSON.stringify(userInfo)
      const userInfoSize = getObjectSize(userInfo)
      console.log(`用户信息大小: ${userInfoSize} 字节 (${(userInfoSize / 1024).toFixed(2)} KB)`)

      try {
        // 确保直接设置token - 修复Docker环境下的问题
        console.log('存储令牌到localStorage')
        localStorage.setItem('accessToken', accessToken)
        localStorage.setItem('refreshToken', refreshToken)
        localStorage.setItem('currentUsername', userInfo.username)

        // 使用全局token设置函数确保token在所有请求中可用
        setGlobalToken(accessToken)

        // 存储完整用户信息
        localStorage.setItem('userInfo', userInfoStr)

        // 验证存储是否成功
        console.log('验证存储结果:')
        console.log('- accessToken 存在:', !!localStorage.getItem('accessToken'))
        console.log('- refreshToken 存在:', !!localStorage.getItem('refreshToken'))
        console.log('- userInfo 存在:', !!localStorage.getItem('userInfo'))
      } catch (storageError) {
        console.error('存储数据失败:', storageError)
        // 使用sessionStorage作为备选存储方式
        sessionStorage.setItem('accessToken', accessToken)
        sessionStorage.setItem('refreshToken', refreshToken)
        sessionStorage.setItem('userInfo', userInfoStr)
        console.log('已使用sessionStorage作为备用存储')
      }

      // 保存用户信息到Vuex
      store.dispatch('login', {
        userInfo,
        accessToken,
        refreshToken
      }).then(() => {
        // 确保Vuex状态已更新后再进行后续操作
        console.log('Vuex状态已更新，验证token存储')

        // 最终验证是否存储成功
        console.log('最终验证localStorage存储:')
        console.log('- userInfo:', !!localStorage.getItem('userInfo'))
        console.log('- accessToken:', !!localStorage.getItem('accessToken'))
        console.log('- currentUsername:', localStorage.getItem('currentUsername'))
        console.log('- Vuex Token:', !!store.getters.token)

        // 设置成功消息并跳转
        ElMessage.success('登录成功')

        // 修改这里：无论是哪种角色的用户，都跳转到首页
        router.push('/home')
      }).catch(error => {
        console.error('Vuex更新状态失败:', error)
        ElMessage.error('登录状态更新失败，请重试')
      })
    } else {
      // 处理登录失败
      ElMessage.error(data.message || '登录失败')
    }
  } catch (error) {
    console.error('[登录] 登录请求出错:', error)

    // 详细记录错误信息
    if (error.response) {
      console.error('[登录错误] 状态码:', error.response.status)
      console.error('[登录错误] 响应数据:', error.response.data)
      ElMessage.error(`登录失败: ${error.response.status} - ${error.response.statusText || '服务器错误'}`)
    } else if (error.request) {
      console.error('[登录错误] 请求已发送但未收到响应:', error.request)
      ElMessage.error('登录失败: 服务器无响应，请检查网络连接或稍后重试')
    } else {
      console.error('[登录错误] 请求配置错误:', error.message)
      ElMessage.error(`登录失败: ${error.message || '网络错误，请稍后重试'}`)
    }
  }
}

/*
添加登录诊断功能
const diagnoseLoginState = () => {
  console.group('===== 登录状态诊断 =====')

  // 检查localStorage
  console.log('LocalStorage 内容:')
  const userInfoStr = localStorage.getItem('userInfo')
  console.log('- userInfo:', userInfoStr ? JSON.parse(userInfoStr) : '未找到')
  console.log('- accessToken:', localStorage.getItem('accessToken') ? '存在' : '未找到')
  console.log('- refreshToken:', localStorage.getItem('refreshToken') ? '存在' : '未找到')

  // 检查sessionStorage
  console.log('\nSessionStorage 内容:')
  console.log('- current_user:', sessionStorage.getItem('current_user'))
  console.log('- accessToken:', sessionStorage.getItem('accessToken') ? '存在' : '未找到')

  // 检查axios请求头
  console.log('\n请求头状态:')
  console.log('- axios全局:', axios.defaults.headers.common.Authorization || '未设置')
  console.log('- request实例:', request.defaults.headers.common.Authorization || '未设置')

  // 检查Vuex状态
  console.log('\nVuex状态:')
  console.log('- accessToken:', store.getters.token ? '存在' : '未找到')
  console.log('- userInfo:', store.getters.getUserInfo ? '存在' : '未找到')

  // 诊断结果
  console.log('\n诊断结果:')
  if (userInfoStr) {
    console.log('- 用户信息存在，正常情况下应当已登录')

    // 检查头像URL
    try {
      const userInfo = JSON.parse(userInfoStr)
      if (userInfo.accessToken) {
        console.log('- 用户信息中的token存在')
      } else {
        console.log('- 警告：用户信息中token不存在')
      }

      if (userInfo.avatar_url) {
        console.log('- 头像URL:', userInfo.avatar_url)
        if (userInfo.avatar_url.startsWith('public/')) {
          console.log('  ⚠️ 头像URL以public/开头，可能需要处理')
        }
      } else {
        console.log('- 无头像URL')
      }
    } catch (e) {
      console.error('解析用户信息失败:', e)
    }
  } else {
    console.log('- 未找到用户信息，正常情况下应当未登录')
  }

  // 检查Docker环境
  console.log('\n环境检查:')
  console.log('- 当前环境:', process.env.NODE_ENV)
  console.log('- baseURL:', request.defaults.baseURL)

  // 测试localStorage是否可用
  const testKey = '_test_' + Date.now()
  try {
    localStorage.setItem(testKey, 'test')
    localStorage.removeItem(testKey)
    console.log('- localStorage: 可用')
  } catch (e) {
    console.log('- localStorage: 不可用', e)
  }

  console.groupEnd()

  ElMessage.info('登录诊断完成，请查看控制台输出')
}
*/

onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme === 'dark') {
    isDarkMode.value = true
    document.body.classList.add('dark-mode')
  }

  // 从localStorage获取上次登录的用户名
  const lastUsername = localStorage.getItem('lastUsername')
  if (lastUsername) {
    loginForm.username = lastUsername
    checkRememberedPassword(lastUsername)
  }
})
</script>

<style scoped>
.page-container {
  font-family: 'Source Han Sans SC', sans-serif;
  position: relative;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: linear-gradient(135deg, #13111C 0%, #2D1F3D 100%);
}

.main-container {
  display: flex;
  width: 100%;
  height: 100%;
  padding: 2rem;
}

/* 左侧介绍区域样式 */
.intro-section {
  flex: 0 0 40%;
  padding: 2rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.intro-card {
  background: rgba(30, 30, 46, 0.6);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  padding: 2.5rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.intro-card:hover {
  transform: scale(1.05);
  border-color: rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.logo-container {
  display: flex;
  justify-content: center;
  margin-bottom: 1.5rem;
}

.planet-logo {
  filter: drop-shadow(0 0 20px rgba(78, 205, 196, 0.3));
}

.brand-container {
  text-align: center;
  margin-bottom: 2rem;
}

.wave-text {
  background: linear-gradient(45deg, #4ecdc4, #ff6b6b);
  background-size: 200% auto;
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: wave 3s linear infinite;
  font-size: 3rem;
  font-weight: bold;
}

.highlight-text {
  color: #ff6b6b;
  font-size: 2.5rem;
  margin-left: 1rem;
}

.brand-subtitle {
  color: #a6accd;
  font-size: 1.4rem;
  line-height: 1.6;
  margin: 1.5rem 0;
  font-style: italic;
  text-shadow: 0 0 10px rgba(166, 172, 205, 0.3);
}

.flip-button {
  position: relative;
  height: 40px;
  perspective: 1000px;
  cursor: pointer;
}

.flip-button-inner {
  position: relative;
  width: 100%;
  height: 100%;
  text-align: center;
  transition: transform 0.6s;
  transform-style: preserve-3d;
}

.flip-button:hover .flip-button-inner {
  transform: rotateX(180deg);
}

.flip-button-front,
.flip-button-back {
  position: absolute;
  width: 100%;
  height: 100%;
  backface-visibility: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(78, 205, 196, 0.1);
  border-radius: 20px;
  color: #4ecdc4;
  padding: 0.5rem 1rem;
}

.flip-button-back {
  background: rgba(255, 107, 107, 0.1);
  color: #ff6b6b;
  transform: rotateX(180deg);
}

.features-list {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin: 2rem 0;
}

.feature-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 16px;
  color: #fff;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.feature-card:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(78, 205, 196, 0.2);
}

.feature-icon {
  font-size: 2rem;
  color: #4ecdc4;
}

.start-button {
  position: relative;
  width: 100%;
  padding: 1rem 2rem;
  background: linear-gradient(45deg, #4ecdc4, #ff6b6b);
  border: none;
  border-radius: 8px;
  color: white;
  font-size: 1.2rem;
  cursor: pointer;
  overflow: hidden;
  transition: all 0.3s ease;
}

.start-button:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(78, 205, 196, 0.3);
}

.button-effect {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.3) 0%, transparent 60%);
  transform: rotate(0deg);
  transition: all 0.3s ease;
}

.start-button:hover .button-effect {
  transform: rotate(180deg);
}

/* 右侧登录区域样式 */
.login-section {
  flex: 0 0 60%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.login-box {
  width: 100%;
  max-width: 480px;
  background: rgba(30, 30, 46, 0.6);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  padding: 2.5rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.login-title {
  font-size: 2rem;
  margin-bottom: 1.5rem;
  text-align: center;
  background: linear-gradient(45deg, #4ecdc4, #ff6b6b);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: glow 2s ease-in-out infinite alternate;
}

.login-subtitle {
  color: #a6accd;
  font-size: 1.2rem;
  text-align: center;
  margin-bottom: 2rem;
  opacity: 0.8;
  animation: fadeInOut 2s ease-in-out infinite;
}

.form-item {
  position: relative;
  margin-bottom: 1.5rem;
}

.input-icon {
  position: absolute;
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
  color: #a6accd;
}

.form-item input {
  width: 100%;
  padding: 1rem 1rem 1rem 3rem;
  background: rgba(45, 45, 63, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: #fff;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.form-item input:focus {
  border-color: #4ecdc4;
  box-shadow: 0 0 15px rgba(78, 205, 196, 0.3);
}

.password-toggle {
  position: absolute;
  right: 1rem;
  top: 50%;
  transform: translateY(-50%);
  color: #a6accd;
  cursor: pointer;
}

.form-options {
  margin-bottom: 1.5rem;
}

.remember-pwd {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #4ecdc4;
  cursor: pointer;
}

.remember-pwd input[type="checkbox"] {
  width: 18px;
  height: 18px;
  background: rgba(45, 45, 63, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  cursor: pointer;
  appearance: none;
  transition: all 0.3s ease;
  position: relative;
}

.remember-pwd input[type="checkbox"]:checked {
  background-color: transparent;
  border-color: #4ecdc4;
}

.remember-pwd input[type="checkbox"]:checked::after {
  content: '✓';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #4ecdc4;
  font-size: 12px;
  font-weight: bold;
}

.remember-pwd input[type="checkbox"]:hover {
  border-color: #4ecdc4;
  box-shadow: 0 0 5px rgba(78, 205, 196, 0.3);
}

.login-button {
  width: 100%;
  padding: 1rem;
  background: linear-gradient(45deg, #4ecdc4, #ff6b6b);
  border: none;
  border-radius: 8px;
  color: white;
  font-size: 1.1rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.login-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(78, 205, 196, 0.3);
}

.divider {
  display: flex;
  align-items: center;
  margin: 2rem 0;
}

.divider::before,
.divider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: rgba(255, 255, 255, 0.1);
}

.divider span {
  padding: 0 1rem;
  color: #4ecdc4;
  font-size: 1.1rem;
  background: transparent;
}

.help-buttons {
  display: flex;
  flex-direction: column;
  gap: 0.8rem;
}

.help-button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  color: #fff;
  font-size: 1.1rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.help-button:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateX(5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.help-button .iconify {
  font-size: 1.5rem;
  color: #4ecdc4;
}

@keyframes wave {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

@keyframes glow {
  0% { text-shadow: 0 0 10px rgba(78, 205, 196, 0.5); }
  100% { text-shadow: 0 0 20px rgba(255, 107, 107, 0.8); }
}

@keyframes fadeInOut {
  0% { opacity: 0.6; }
  50% { opacity: 1; }
  100% { opacity: 0.6; }
}

/* 保留原有的背景动画样式 */
.background-decoration {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 0;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: linear-gradient(45deg, rgba(78, 205, 196, 0.1), rgba(255, 107, 107, 0.1));
  filter: blur(40px);
}

.circle-1 {
  width: 300px;
  height: 300px;
  top: -150px;
  left: -150px;
}

.circle-2 {
  width: 400px;
  height: 400px;
  top: 40%;
  right: -200px;
}

.circle-3 {
  width: 250px;
  height: 250px;
  bottom: -125px;
  left: 30%;
}

@media (max-width: 1024px) {
  .main-container {
    flex-direction: column;
  }

  .intro-section,
  .login-section {
    flex: none;
    width: 100%;
  }

  .intro-section {
    padding: 1rem;
  }

  .wave-text,
  .highlight-text {
    font-size: 2rem;
  }

  .features-list {
    flex-direction: column;
  }

  .feature-card {
    flex-direction: row;
    justify-content: center;
  }
}
</style>
