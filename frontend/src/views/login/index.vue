/* eslint-disable vue/multi-word-component-names */
<template>
  <div class="page-container">
    <div class="background-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>
    <div class="login-container">
      <div class="login-box">
        <div class="header-icons">
          <svg 
            v-if="isDarkMode"
            viewBox="0 0 24 24" 
            class="header-icon theme-icon"
            @click="toggleTheme"
          >
            <path 
              fill="currentColor" 
              d="M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z"
            />
          </svg>
          <svg 
            v-else
            viewBox="0 0 24 24" 
            class="header-icon theme-icon"
            @click="toggleTheme"
          >
            <path 
              fill="currentColor" 
              d="M12,7a5,5,0,1,0,5,5A5,5,0,0,0,12,7ZM12,15a3,3,0,1,1,3-3A3,3,0,0,1,12,15ZM11,5V3a1,1,0,0,1,2,0V5a1,1,0,0,1-2,0Zm0,16v-2a1,1,0,0,1,2,0v2a1,1,0,0,1-2,0ZM19.778,6.636a1,1,0,1,1,1.414-1.414l1.414,1.414a1,1,0,0,1-1.414,1.414ZM1.394,19.02l1.414-1.414a1,1,0,0,1,1.414,1.414L2.808,20.434a1,1,0,0,1-1.414-1.414ZM21,11h2a1,1,0,0,1,0,2H21a1,1,0,0,1,0-2ZM3,11H1a1,1,0,0,1,0-2H3a1,1,0,0,1,0,2Zm16.192,6.606-1.414-1.414a1,1,0,0,1,1.414-1.414l1.414,1.414a1,1,0,0,1-1.414,1.414ZM4.222,6.636,2.808,5.222A1,1,0,0,1,4.222,3.808L5.636,5.222A1,1,0,0,1,4.222,6.636Z"
            />
          </svg>
        </div>

        <div class="login-content">
          <div class="login-header">
            <svg class="logo" width="64" height="64" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
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
            <h2>QuizPlanet 问知星球</h2>
          </div>

          <div class="feature-card">
            <div class="card-content">
              <h3>密码登录</h3>
              <form @submit.prevent="handleLogin">
                <div class="form-item">
                  <input 
                    type="text" 
                    v-model="loginForm.username" 
                    placeholder="请输入用户名"
                    required
                  >
                </div>
                <div class="form-item">
                  <input 
                    :type="showPassword ? 'text' : 'password'"
                    v-model="loginForm.password" 
                    placeholder="请输入密码"
                    required
                  >
                  <div class="password-suffix" @click="togglePassword">
                    <svg v-if="showPassword" class="icon" viewBox="0 0 1024 1024" width="16" height="16">
                      <path d="M942.2 486.2C847.4 286.5 704.1 186 512 186c-192.2 0-335.4 100.5-430.2 300.3a60.3 60.3 0 0 0 0 51.5C176.6 737.5 319.9 838 512 838c192.2 0 335.4-100.5 430.2-300.3 7.7-16.2 7.7-35 0-51.5zM512 766c-161.3 0-279.4-81.8-362.7-254C232.6 339.8 350.7 258 512 258c161.3 0 279.4 81.8 362.7 254C791.5 684.2 673.4 766 512 766zm-4-430c-97.2 0-176 78.8-176 176s78.8 176 176 176 176-78.8 176-176-78.8-176-176-176zm0 288c-61.9 0-112-50.1-112-112s50.1-112 112-112 112 50.1 112 112-50.1 112-112 112z" fill="currentColor"/>
                    </svg>
                    <svg v-else class="icon" viewBox="0 0 1024 1024" width="16" height="16">
                      <path d="M942.2 486.2Q889.47 375.11 816.7 305l-50.88 50.88C807.31 395.53 843.45 447.4 874.7 512 791.5 684.2 673.4 766 512 766q-72.67 0-133.87-22.38L323 798.75Q408 838 512 838q192.2 0 335.4-100.5a60.29 60.29 0 0 0 94.8-51.5v-51.5zM878.63 165.56L836 122.88a8 8 0 0 0-11.32 0L715.31 232.2Q624.86 186 512 186q-192.2 0-335.4 100.5a60.3 60.3 0 0 0 0 51.5q56.69 119.4 136.5 191.41L209.77 633.1a8 8 0 0 0 0 11.31L252.4 687a8 8 0 0 0 11.31 0L878.63 176.88a8 8 0 0 0 0-11.32zM149.3 512C232.6 339.8 350.7 258 512 258c54.54 0 104.13 9.36 149.12 28.39l-70.3 70.3a176 176 0 0 0-238.13 238.13l-83.42 83.42C223.1 637.49 183.3 582.28 149.3 512zm246.7 0a112.11 112.11 0 0 1 146.2-106.69L401.31 546.2A112 112 0 0 1 396 512z" fill="currentColor"/>
                    </svg>
                  </div>
                </div>
                <div class="form-options">
                  <label class="remember-pwd">
                    <input 
                      type="checkbox" 
                      v-model="loginForm.remember"
                    > 记住我
                  </label>
                  <a @click="router.push('/login/reset-password')" class="forget-pwd">忘记密码？</a>
                </div>
                <button type="submit" class="submit-button">
                  <span>登录</span>
                  <svg class="submit-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M5 12H19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M12 5L19 12L12 19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </button>
              </form>
            </div>
            <div class="card-decoration">
              <div class="geometric-shape"></div>
            </div>
          </div>

          <div class="login-footer">
            <button @click="router.push('/login/phone')" class="text-button">验证码登录</button>
            <router-link to="/register" class="text-button">注册账号</router-link>
            <router-link to="/login/reset-password" class="text-button">忘记密码？</router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LoginIndex'
}
</script>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import store from '@/store'

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

const handleLogin = async () => {
  try {
    // 在发送请求前先清除所有存储的用户数据
    localStorage.clear(); // 彻底清除所有localStorage数据
    sessionStorage.clear(); // 彻底清除所有sessionStorage数据
    
    const response = await fetch('http://localhost:3000/api/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        username: loginForm.username,
        password: loginForm.password,
        remember: loginForm.remember
      })
    })
    
    const data = await response.json()
    console.log('登录返回数据:', data)

    if (data.success) {
      const { accessToken, refreshToken, ...userInfo } = data.data
      
      console.log(`成功登录用户: ${userInfo.username}, 角色: ${userInfo.role}`);
      
      // 如果选择记住密码，则保存密码
      if (loginForm.remember) {
        userInfo.password = loginForm.password
        userInfo.remember = true
      }
      
      // 将token也存储在userInfo中
      userInfo.accessToken = accessToken
      userInfo.refreshToken = refreshToken
      
      // 保存用户信息到localStorage
      localStorage.setItem('userInfo', JSON.stringify(userInfo))
      localStorage.setItem('accessToken', accessToken)
      localStorage.setItem('refreshToken', refreshToken)
      localStorage.setItem('currentUsername', userInfo.username)
      
      // 保存用户信息到Vuex
      store.dispatch('login', {
        userInfo,
        accessToken,
        refreshToken
      })
      
      ElMessage.success('登录成功')
      
      // 直接重定向到主页，避免可能的路由问题
      window.location.href = '/home'
    } else {
      ElMessage.error(data.message || '登录失败')
    }
  } catch (error) {
    console.error('登录错误：', error)
    ElMessage.error('登录失败，请稍后重试')
  }
}

const toggleTheme = () => {
  isDarkMode.value = !isDarkMode.value
  document.body.classList.toggle('dark-mode')
  localStorage.setItem('theme', isDarkMode.value ? 'dark' : 'light')
}

onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme === 'dark') {
    isDarkMode.value = true
    document.body.classList.add('dark-mode')
  }
  
  const savedUserInfo = localStorage.getItem('userInfo')
  if (savedUserInfo) {
    const userInfo = JSON.parse(savedUserInfo)
    if (userInfo.remember) {
      loginForm.username = userInfo.username
      loginForm.password = userInfo.password
      loginForm.remember = true
    }
  }
})
</script>

<style scoped>
.page-container {
  position: relative;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: linear-gradient(135deg, #13111C 0%, #2D1F3D 100%);
}

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

.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  padding: 20px;
  position: relative;
  z-index: 1;
}

.login-box {
  width: 100%;
  max-width: 480px;
  position: relative;
  backdrop-filter: blur(20px);
  border-radius: 24px;
  padding: 40px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: rgba(30, 30, 46, 0.6);
}

.header-icons {
  position: absolute;
  top: -40px;
  right: 0;
  display: flex;
  gap: 16px;
}

.header-icon {
  width: 24px;
  height: 24px;
  color: #11183c;
  cursor: pointer;
  transition: all 0.3s ease;
}

.header-icon:hover {
  color: #4ecdc4;
}

.theme-icon {
  transition: transform 0.5s ease;
}

.theme-icon:hover {
  transform: rotate(360deg);
}

.login-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.login-header {
  text-align: center;
  margin-bottom: 16px;
}

.logo {
  width: 64px;
  height: 64px;
  margin-bottom: 16px;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
}

.login-header h2 {
  color: #fff;
  font-size: 24px;
  margin: 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.feature-card {
  background-color: rgba(30, 30, 46, 0.8);
  border-radius: 16px;
  padding: 32px;
  display: flex;
  position: relative;
  overflow: hidden;
  transition: transform 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.feature-card:hover {
  transform: translateY(-4px);
  border-color: rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.card-content {
  flex: 2;
  z-index: 1;
}

.card-content h3 {
  font-size: 20px;
  color: #fff;
  margin: 0 0 24px 0;
}

.form-item {
  position: relative;
  margin-bottom: 16px;
}

.form-item input {
  width: 100%;
  padding: 12px;
  background-color: rgba(45, 45, 63, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: #fff;
  font-size: 14px;
  transition: all 0.3s ease;
}

.form-item input:focus {
  outline: none;
  background-color: rgba(61, 61, 79, 0.8);
  border-color: rgba(78, 205, 196, 0.5);
  box-shadow: 0 0 0 2px rgba(78, 205, 196, 0.2);
}

.password-suffix {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  color: #a6accd;
  transition: color 0.3s ease;
}

.password-suffix:hover {
  color: #4ecdc4;
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  color: #363c5d;
  font-size: 14px;
}

.remember-pwd {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.remember-pwd input[type="checkbox"] {
  width: 16px;
  height: 16px;
  border-radius: 4px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  background-color: rgba(45, 45, 63, 0.8);
  cursor: pointer;
  appearance: none;
  transition: all 0.3s ease;
}

.remember-pwd input[type="checkbox"]:checked {
  background-color: #4ecdc4;
  border-color: #4ecdc4;
}

.forget-pwd {
  color: #4ecdc4;
  text-decoration: none;
  cursor: pointer;
  transition: color 0.3s ease;
}

.forget-pwd:hover {
  color: #3db8b0;
}

.submit-button {
  width: 100%;
  padding: 12px;
  background-color: #4ecdc4;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.submit-button:hover {
  background-color: #3db8b0;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(78, 205, 196, 0.3);
}

.submit-icon {
  width: 20px;
  height: 20px;
}

.card-decoration {
  position: absolute;
  right: -20px;
  top: 50%;
  transform: translateY(-50%);
}

.geometric-shape {
  width: 150px;
  height: 150px;
  background: linear-gradient(45deg, rgba(255, 107, 107, 0.2), rgba(78, 205, 196, 0.2));
  clip-path: polygon(50% 0%, 100% 50%, 50% 100%, 0% 50%);
  transition: transform 0.5s ease;
  opacity: 0.3;
}

.feature-card:hover .geometric-shape {
  transform: rotate(45deg) scale(1.2);
  opacity: 0.4;
}

.login-footer {
  display: flex;
  justify-content: center;
  gap: 24px;
}

.text-button {
  background: none;
  border: none;
  color: #a6accd;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  padding: 4px 8px;
  position: relative;
}

.text-button::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  width: 0;
  height: 1px;
  background-color: #4ecdc4;
  transition: all 0.3s ease;
  transform: translateX(-50%);
}

.text-button:hover {
  color: #4ecdc4;
}

.text-button:hover::after {
  width: 100%;
}

@media (max-width: 768px) {
  .login-box {
    padding: 20px;
  }
  
  .feature-card {
    padding: 24px;
  }
  
  .geometric-shape {
    display: none;
  }
  
  .circle {
    opacity: 0.5;
  }
}
</style> 