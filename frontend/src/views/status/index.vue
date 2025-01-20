<template>
  <div class="container">
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

    <main class="main-content">
      <div class="status-header">
        <h2>提交状态</h2>
        <div class="filters">
          <select v-model="filters.status">
            <option value="">全部状态</option>
            <option value="AC">通过</option>
            <option value="WA">答案错误</option>
          </select>
          <input 
            type="text" 
            v-model="filters.author" 
            placeholder="搜索作者"
          >
          <button class="refresh-btn" @click="refreshStatus">刷新</button>
        </div>
      </div>

      <table class="status-table">
        <thead>
          <tr>
            <th>时间</th>
            <th>ID</th>
            <th>状态</th>
            <th>题目</th>
            <th>耗时</th>
            <th>内存</th>
            <th>语言</th>
            <th>作者</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td colspan="8" class="no-data">暂无数据</td>
          </tr>
        </tbody>
      </table>
    </main>

    <footer class="footer">
      <div class="footer-content">
        <p>Online Judge Footer</p>
        <p>Powered by OnlineJudge Version: 20210928-acce7</p>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'StatusIndex'
}
</script>

<script setup>
import { reactive } from 'vue'

const filters = reactive({
  status: '',
  author: ''
})

const refreshStatus = () => {
  // 刷新状态的逻辑
}
</script>

<style scoped>
@import '@/assets/styles/common.css';

.status-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.filters {
  display: flex;
  gap: 12px;
}

.status-table {
  width: 100%;
  border-collapse: collapse;
}

.status-table th,
.status-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e8e8e8;
}

.refresh-btn {
  padding: 4px 12px;
  background-color: #1890ff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.refresh-btn:hover {
  background-color: #40a9ff;
}
</style> 