<template>
  <header class="header">
    <div class="logo-section">
      <h1>Online Judge</h1>
    </div>
    <nav class="nav-menu">
      <router-link to="/home" active-class="active">首页</router-link>
      <router-link to="/problems" active-class="active">题目</router-link>
      <router-link to="/contests" active-class="active">竞赛</router-link>
      <router-link to="/status" active-class="active">状态</router-link>
      <router-link to="/rank" active-class="active">排名</router-link>
      <router-link to="/about" active-class="active">关于</router-link>
    </nav>
    <div class="user-section">
      <router-link to="/login">登录</router-link>
      <router-link to="/register">注册</router-link>
    </div>
  </header>
</template>

<script>
export default {
  name: 'LayoutHeader'
}
</script> 