<template>
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

        <svg 
          viewBox="0 0 24 24" 
          class="header-icon lang-icon"
          @click="toggleLang"
        >
          <path 
            fill="currentColor" 
            d="M12.87 15.07l-2.54-2.51.03-.03c1.74-1.94 2.98-4.17 3.71-6.53H17V4h-7V2H8v2H1v1.99h11.17C11.5 7.92 10.44 9.75 9 11.35 8.07 10.32 7.3 9.19 6.69 8h-2c.73 1.63 1.73 3.17 2.98 4.56l-5.09 5.02L4 19l5-5 3.11 3.11.76-2.04zM18.5 10h-2L12 22h2l1.12-3h4.75L21 22h2l-4.5-12zm-2.62 7l1.62-4.33L19.12 17h-3.24z"
          />
        </svg>
      </div>
      
      <div class="login-header">
        <img src="@/assets/logo.png" alt="Logo" class="logo">
        <h2>Soybean 管理系统</h2>
      </div>
      
      <h3 class="login-title">密码登录</h3>
      
      <form @submit.prevent="handleLogin">
        <div class="form-item">
          <input 
            type="text" 
            v-model="loginForm.username" 
            placeholder="Soybean"
            required
          >
        </div>
        <div class="form-item">
          <input 
            :type="showPassword ? 'text' : 'password'"
            v-model="loginForm.password" 
            placeholder="123456"
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
        <button type="submit">确认</button>
      </form>

      <div class="other-login">
        <div class="divider">
          <span>其他账号登录</span>
        </div>
        <div class="login-methods">
          <button @click="router.push('/login/phone')" class="method-btn">验证码登录</button>
          <button @click="router.push('/register')" class="method-btn">注册账号</button>
        </div>
      </div>

      <div class="other-accounts">
        其他账号登录
        <div class="account-types">
          <div class="account-type">超级管理员</div>
          <div class="account-type">管理员</div>
          <div class="account-type">普通用户</div>
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
    const response = await fetch('http://localhost:3000/api/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        username: loginForm.username,
        password: loginForm.password
      })
    })
    
    const data = await response.json()

    if (data.success) {
      localStorage.setItem('userInfo', JSON.stringify({
        username: loginForm.username  // 使用登录表单中的用户名
      }))
      router.push('/home')
    } else {
      alert(data.message || '登录失败')
    }
  } catch (error) {
    console.error('登录错误：', error)
    alert('登录失败，请稍后重试')
  }
}

const toggleTheme = () => {
  isDarkMode.value = !isDarkMode.value
  document.body.classList.toggle('dark-mode')
  localStorage.setItem('theme', isDarkMode.value ? 'dark' : 'light')
}

const toggleLang = () => {
  console.log('切换语言')
}

onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme === 'dark') {
    isDarkMode.value = true
    document.body.classList.add('dark-mode')
  }
})
</script>

<style scoped>
.header-icon {
  width: 20px;
  height: 20px;
  color: #666;
  cursor: pointer;
  transition: all 0.3s ease;
}

.header-icon:hover {
  color: #818cf8;
}

.theme-icon {
  transition: transform 0.5s ease;
}

.theme-icon:hover {
  transform: rotate(360deg);
}

.lang-icon:hover {
  animation: bounce 0.5s ease;
}

@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-3px);
  }
}
</style> 