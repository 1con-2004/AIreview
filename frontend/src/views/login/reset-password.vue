<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <img src="@/assets/logo.png" alt="Logo" class="logo">
        <h2>Soybean 管理系统</h2>
      </div>
      <h3 class="login-title">重置密码</h3>
      
      <form @submit.prevent="handleResetPassword">
        <div class="form-item">
          <input 
            type="tel" 
            v-model="resetForm.phone" 
            placeholder="请输入手机号"
            required
          >
        </div>
        <div class="form-item verification-code">
          <input 
            type="text" 
            v-model="resetForm.code" 
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
        <div class="form-item">
          <input 
            type="password" 
            v-model="resetForm.password" 
            placeholder="请输入新密码"
            required
          >
        </div>
        <div class="form-item">
          <input 
            type="password" 
            v-model="resetForm.confirmPassword" 
            placeholder="请再次输入新密码"
            required
          >
        </div>
        <button type="submit">确认</button>
      </form>

      <div class="back-btn" @click="router.back()">返回</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LoginResetPassword'
}
</script>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const countdown = ref(0)
const resetForm = reactive({
  phone: '',
  code: '',
  password: '',
  confirmPassword: ''
})

const sendVerificationCode = async () => {
  if (!/^1[3-9]\d{9}$/.test(resetForm.phone)) {
    alert('请输入正确的手机号')
    return
  }
  
  try {
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

const handleResetPassword = async () => {
  if (resetForm.password !== resetForm.confirmPassword) {
    alert('两次输入的密码不一致')
    return
  }
  // 重置密码逻辑
}
</script>

<style scoped>
/* 复用 App.vue 中的样式 */
</style> 