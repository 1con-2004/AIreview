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

      <!-- 右侧重置密码区域 -->
      <div class="login-section">
        <div class="login-box">
          <h2 class="login-title">Welcome QuizPlanet</h2>
          <p class="login-subtitle">重置密码</p>

          <form @submit.prevent="handleResetPassword">
            <div class="form-item">
              <Icon icon="carbon:email" class="input-icon" />
              <input
                type="email"
                v-model="resetForm.email"
                placeholder="请输入邮箱"
                required
              >
            </div>

            <div class="form-item">
              <Icon icon="carbon:password" class="input-icon" />
              <input
                type="text"
                v-model="resetForm.code"
                placeholder="请输入验证码"
                required
              >
              <div class="password-toggle" @click="sendVerificationCode" :class="{ disabled: countdown > 0 }">
                {{ countdown > 0 ? `${countdown}s` : '获取验证码' }}
              </div>
            </div>

            <div class="form-item">
              <Icon icon="carbon:password" class="input-icon" />
              <input
                type="password"
                v-model="resetForm.newPassword"
                placeholder="请输入新密码"
                required
              >
            </div>

            <div class="form-item">
              <Icon icon="carbon:password" class="input-icon" />
              <input
                type="password"
                v-model="resetForm.confirmPassword"
                placeholder="请确认新密码"
                required
              >
            </div>

            <button type="submit" class="login-button">
              <span>重置密码</span>
              <Icon icon="carbon:arrow-right" class="button-icon" />
            </button>
          </form>

          <div class="divider">
          </div>

          <div class="help-buttons">
            <button class="help-button" @click="router.push('/login')">
              <Icon icon="carbon:user-profile" />
              <span>返回登录</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { Icon } from '@iconify/vue'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'

const router = useRouter()
const countdown = ref(0)
const resetForm = reactive({
  email: '',
  code: '',
  newPassword: '',
  confirmPassword: ''
})

const sendVerificationCode = async () => {
  if (countdown.value > 0) return

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(resetForm.email)) {
    ElMessage.error('请输入正确的邮箱地址')
    return
  }

  try {
    console.log('开始发送验证码请求')
    const response = await request.post('/api/auth/send-email-code', {
      email: resetForm.email
    })

    console.log('收到响应:', response)
    if (response.success) {
      countdown.value = 60
      const timer = setInterval(() => {
        countdown.value--
        if (countdown.value <= 0) {
          clearInterval(timer)
        }
      }, 1000)
      ElMessage.success('验证码发送成功')
    } else {
      ElMessage.error(response.message || '发送验证码失败')
    }
  } catch (error) {
    console.error('发送验证码失败，详细错误：', error)
    ElMessage.error('发送验证码失败，请稍后重试')
  }
}

const handleResetPassword = async () => {
  // 表单验证
  if (!resetForm.email || !resetForm.code || !resetForm.newPassword || !resetForm.confirmPassword) {
    ElMessage.error('请填写所有必填项')
    return
  }

  if (resetForm.newPassword !== resetForm.confirmPassword) {
    ElMessage.error('两次输入的密码不一致')
    return
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(resetForm.email)) {
    ElMessage.error('请输入正确的邮箱地址')
    return
  }

  try {
    console.log('开始重置密码请求')
    const response = await request.post('/api/auth/reset-password', {
      email: resetForm.email,
      code: resetForm.code,
      newPassword: resetForm.newPassword
    })

    console.log('重置密码响应：', response)
    if (response.success) {
      ElMessage.success(response.message || '密码重置成功')
      router.push('/login')
    } else {
      ElMessage.error(response.message || '密码重置失败')
    }
  } catch (error) {
    console.error('重置密码错误：', error)
    ElMessage.error(error.response?.data?.message || '密码重置失败，请稍后重试')
  }
}
</script>

<style scoped>
/* 复用index.vue的所有样式 */
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
  color: #4ecdc4;
  cursor: pointer;
  font-size: 0.9rem;
}

.password-toggle.disabled {
  color: #6272a4;
  cursor: not-allowed;
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
