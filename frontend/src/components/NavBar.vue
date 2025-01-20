<template>
  <div class="nav-bar">
    <div class="nav-left">
      <router-link to="/home" class="logo">Online Judge</router-link>
    </div>
    <div class="nav-middle">
      <router-link to="/home" class="nav-item">首页</router-link>
      <router-link to="/problems" class="nav-item">题目</router-link>
      <router-link to="/contests" class="nav-item">竞赛</router-link>
      <router-link to="/status" class="nav-item">状态</router-link>
      <router-link to="/ranking" class="nav-item">排名</router-link>
      <router-link to="/about" class="nav-item">关于</router-link>
    </div>
    <div class="nav-right">
      <template v-if="isLoggedIn">
        <router-link :to="'/user/' + username" class="username">{{ username }}</router-link>
        <a @click="handleLogout" class="logout-btn">登出</a>
      </template>
      <template v-else>
        <router-link to="/login" class="login-btn">登录</router-link>
      </template>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NavBar',
  data() {
    return {
      isLoggedIn: false,
      username: ''
    }
  },
  created() {
    this.checkLoginStatus()
  },
  methods: {
    checkLoginStatus() {
      const userInfo = localStorage.getItem('userInfo')
      console.log('Checking login status:', userInfo)
      if (userInfo) {
        const user = JSON.parse(userInfo)
        console.log('User info:', user)
        this.isLoggedIn = true
        this.username = user.username
      }
    },
    handleLogout() {
      localStorage.removeItem('userInfo')
      this.isLoggedIn = false
      this.username = ''
      this.$router.push({ name: 'Login' })
    }
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
  background-color: #ffffff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.nav-left .logo {
  font-size: 24px;
  font-weight: bold;
  color: #00796b;
}

.nav-middle {
  display: flex;
  gap: 30px;
}

.nav-item {
  font-size: 18px;
  color: #00796b;
  text-decoration: none;
  transition: all 0.3s;
  padding: 5px 10px;
  border-radius: 5px;
}

.nav-item:hover {
  background-color: #b2ebf2;
  color: #004d40;
}

.nav-right {
  display: flex;
  align-items: center;
  gap: 15px;
}

a {
  text-decoration: none;
  color: #666;
}

a:hover {
  color: #1890ff;
}

.username {
  color: #333;
  font-weight: 500;
  cursor: pointer;
}

.username:hover {
  color: #1890ff;
  text-decoration: underline;
}

.logout-btn {
  cursor: pointer;
  color: #666;
  padding: 6px 15px;
  border-radius: 4px;
  background-color: #f0f0f0;
}

.logout-btn:hover {
  background-color: #e0e0e0;
  color: #1890ff;
}

.login-btn {
  padding: 6px 15px;
  border-radius: 4px;
  background-color: #1890ff;
  color: white;
}

.login-btn:hover {
  background-color: #40a9ff;
}
</style> 