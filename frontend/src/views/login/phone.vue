<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <img src="@/assets/logo.png" alt="Logo" class="logo">
        <h2>Soybean 管理系统</h2>
      </div>
      <h3 class="login-title">验证码登录</h3>
      
      <form @submit.prevent="handlePhoneLogin">
        <div class="form-item">
          <input 
            type="tel" 
            v-model="phoneForm.phone" 
            placeholder="请输入手机号"
            required
          >
        </div>
        <div class="form-item verification-code">
          <input 
            type="text" 
            v-model="phoneForm.code" 
            placeholder="请输入验证码"
            required
          >
          <button 
            type="button" 
            class="send-code-btn" 
            :disabled="countdown > 0"
            @click="sendVerificationCode"
          >
            {{ countdown > 0 ? `${countdown}秒后重试` : '获取验证码' }}
          </button>
        </div>
        <button type="submit">确认</button>
      </form>

      <div class="back-btn" @click="router.back()">返回</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LoginPhone'
}
</script>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const countdown = ref(0)
const phoneForm = reactive({
  phone: '',
  code: ''
})

// 发送验证码逻辑
const sendVerificationCode = async () => {
  // 验证手机号
  if (!/^1[3-9]\d{9}$/.test(phoneForm.phone)) {
    alert('请输入正确的手机号')
    return
  }
  
  try {
    // 调用发送验证码接口
    countdown.value = 60
    const timer = setInterval(() => {
      countdown.value--
      if (countdown.value <= 0) {
        clearInterval(timer)
      }
    }, 1000)
  } catch (error) {
    console.error('发送验证码失败：', error)
  }
}

const handlePhoneLogin = async () => {
  // 手机号登录逻辑
}
</script>

<style scoped>
/* 复用 App.vue 中的基础样式 */
.verification-code {
  position: relative;
}

.send-code-btn {
  position: absolute;
  right: 0;
  top: 0;
  width: auto;
  height: 100%;
  padding: 0 12px;
  background: transparent;
  color: #818cf8;
  font-size: 14px;
  border-left: 1px solid #e5e7eb;
}

.send-code-btn:disabled {
  color: #9ca3af;
  cursor: not-allowed;
}

.back-btn {
  text-align: center;
  color: #666;
  cursor: pointer;
  font-size: 14px;
  margin-top: 16px;
}

.back-btn:hover {
  color: #818cf8;
}
</style> 