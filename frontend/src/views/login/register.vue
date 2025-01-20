<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <img src="@/assets/logo.png" alt="Logo" class="logo">
        <h2>Soybean 管理系统</h2>
      </div>
      <h3 class="login-title">注册账号</h3>
      
      <form @submit.prevent="handleRegister">
        <div class="form-item">
          <input 
            type="text" 
            v-model="registerForm.username" 
            placeholder="请输入用户名"
            required
          >
        </div>
        <div class="form-item">
          <input 
            :type="showPassword ? 'text' : 'password'"
            v-model="registerForm.password" 
            placeholder="请输入密码"
            required
          >
          <div class="password-suffix" @click="togglePassword">
            <!-- 使用与登录页相同的密码显示/隐藏图标 -->
          </div>
        </div>
        <div class="form-item">
          <input 
            :type="showPassword ? 'text' : 'password'"
            v-model="registerForm.confirmPassword" 
            placeholder="请再次输入密码"
            required
          >
        </div>
        <div class="form-item">
          <input 
            type="tel" 
            v-model="registerForm.phone" 
            placeholder="请输入手机号（选填）"
          >
        </div>
        <button type="submit">注册</button>
      </form>

      <div class="back-btn" @click="router.back()">返回</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LoginRegister'
}
</script>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const showPassword = ref(false)

const registerForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  phone: ''
})

const togglePassword = () => {
  showPassword.value = !showPassword.value
}

const handleRegister = async () => {
  // 表单验证
  if (registerForm.password !== registerForm.confirmPassword) {
    alert('两次输入的密码不一致')
    return
  }

  if (registerForm.phone && !/^1[3-9]\d{9}$/.test(registerForm.phone)) {
    alert('请输入正确的手机号')
    return
  }

  try {
    const response = await fetch('http://your-backend-url/api/register', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        username: registerForm.username,
        password: registerForm.password,
        phone: registerForm.phone || null
      })
    })
    
    const data = await response.json()
    if (data.success) {
      alert('注册成功')
      router.push('/login')
    } else {
      alert(data.message || '注册失败')
    }
  } catch (error) {
    console.error('注册错误：', error)
    alert('注册失败，请稍后重试')
  }
}
</script>

<style scoped>
/* 复用 login.css 中的样式 */
</style> 