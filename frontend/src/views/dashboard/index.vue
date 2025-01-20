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
      <!-- 公告栏部分 -->
      <div class="announcements">
        <div class="section-header">
          <h2>公告</h2>
          <button class="refresh-btn" @click="refreshAnnouncements">刷新</button>
        </div>
        <div class="announcement-content">
          {{ announcementText }}
        </div>
      </div>

      <div class="problem-header">
        <h2>题目列表</h2>
        <div class="filters">
          <div class="difficulty-filter">
            <span>难度</span>
            <select v-model="filters.difficulty">
              <option value="">全部</option>
              <option value="Low">简单</option>
              <option value="Medium">中等</option>
              <option value="High">困难</option>
            </select>
          </div>
          <div class="tags-filter">
            <span>标签</span>
            <label class="switch">
              <input type="checkbox" v-model="filters.showTags">
              <span class="slider"></span>
            </label>
          </div>
          <div class="search">
            <input 
              type="text" 
              v-model="filters.keyword" 
              placeholder="搜索关键词"
            >
            <button class="reset-btn" @click="resetFilters">重置</button>
          </div>
        </div>
      </div>

      <table class="problem-table">
        <thead>
          <tr>
            <th>编号</th>
            <th>标题</th>
            <th>难度</th>
            <th>提交数</th>
            <th>通过率</th>
            <th>标签</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="problem in filteredProblems" :key="problem.id">
            <td>{{ problem.id }}</td>
            <td>{{ problem.title }}</td>
            <td>
              <span :class="['level-tag', problem.level.toLowerCase()]">
                {{ getDifficultyText(problem.level) }}
              </span>
            </td>
            <td>{{ problem.total }}</td>
            <td>{{ problem.acRate }}%</td>
            <td>
              <span 
                v-for="tag in problem.tags" 
                :key="tag" 
                class="problem-tag"
              >
                {{ getTagText(tag) }}
              </span>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="pagination">
        <button class="prev-btn">&lt;</button>
        <button class="page-btn active">1</button>
        <button class="page-btn">2</button>
        <button class="page-btn">3</button>
        <button class="page-btn">4</button>
        <button class="next-btn">&gt;</button>
      </div>
    </main>

    <!-- 页脚部分 -->
    <footer class="footer">
      <div class="footer-content">
        <p>Online Judge Footer</p>
        <p>
          Powered by <a href="#" class="footer-link">OnlineJudge</a>
          Version: 20210928-acce7
        </p>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'DashboardIndex'
}
</script>

<script setup>
import { ref, reactive, computed } from 'vue'

const filters = reactive({
  difficulty: '',
  showTags: true,
  keyword: ''
})

const problems = ref([
  {
    id: '0000',
    title: 'A + B Problem',
    level: 'Low',
    total: 77,
    acRate: 68.83,
    tags: ['basic']
  },
  {
    id: 'contest_4_A',
    title: '打乒乓球',
    level: 'Low',
    total: 36,
    acRate: 19.44,
    tags: ['basic', 'oi']
  },
  // ... 添加更多题目数据
])

// 难度文本转换
const getDifficultyText = (level) => {
  const map = {
    'Low': '简单',
    'Medium': '中等',
    'High': '困难'
  }
  return map[level] || level
}

// 标签文本转换
const getTagText = (tag) => {
  const map = {
    'basic': '基础',
    'oi': '信息学竞赛'
  }
  return map[tag] || tag
}

const filteredProblems = computed(() => {
  return problems.value.filter(problem => {
    if (filters.difficulty && problem.level !== filters.difficulty) {
      return false
    }
    if (filters.keyword) {
      const keyword = filters.keyword.toLowerCase()
      return problem.title.toLowerCase().includes(keyword) ||
             problem.id.toLowerCase().includes(keyword)
    }
    return true
  })
})

const resetFilters = () => {
  filters.difficulty = ''
  filters.keyword = ''
}

// 添加公告相关的状态
const announcementText = ref('暂无公告')

// 刷新公告的逻辑
const refreshAnnouncements = () => {
  announcementText.value = '正在刷新公告...'
  setTimeout(() => {
    announcementText.value = '暂无公告'
  }, 1000)
}
</script>

<style scoped>
@import '@/assets/styles/common.css';

.dashboard-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.header {
  background-color: white;
  padding: 0 20px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.nav-menu {
  display: flex;
  gap: 24px;
}

.nav-menu a {
  color: #666;
  text-decoration: none;
  font-size: 14px;
  padding: 22px 0;
}

.nav-menu a.active {
  color: #1890ff;
  border-bottom: 2px solid #1890ff;
}

.user-section {
  display: flex;
  gap: 16px;
}

.user-section a {
  color: #666;
  text-decoration: none;
  font-size: 14px;
}

.main-content {
  flex: 1;
  padding: 24px;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

.problem-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.filters {
  display: flex;
  gap: 20px;
  align-items: center;
}

.problem-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
}

.problem-table th,
.problem-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e8e8e8;
}

.level-tag {
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.level-tag.low {
  background-color: #52c41a;
  color: white;
}

.problem-tag {
  display: inline-block;
  padding: 2px 8px;
  background-color: #f0f0f0;
  border-radius: 4px;
  margin-right: 4px;
  font-size: 12px;
}

.pagination {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-top: 20px;
}

.page-btn {
  padding: 4px 12px;
  border: 1px solid #d9d9d9;
  background-color: white;
  cursor: pointer;
}

.page-btn.active {
  background-color: #1890ff;
  color: white;
  border-color: #1890ff;
}

.prev-btn,
.next-btn {
  padding: 4px 12px;
  border: 1px solid #d9d9d9;
  background-color: white;
  cursor: pointer;
}

.switch {
  position: relative;
  display: inline-block;
  width: 40px;
  height: 20px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: .4s;
  border-radius: 20px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 16px;
  width: 16px;
  left: 2px;
  bottom: 2px;
  background-color: white;
  transition: .4s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #1890ff;
}

input:checked + .slider:before {
  transform: translateX(20px);
}

.search {
  display: flex;
  gap: 8px;
}

.search input {
  padding: 4px 8px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
}

.reset-btn {
  padding: 4px 12px;
  background-color: #f0f0f0;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.reset-btn:hover {
  background-color: #e0e0e0;
}

/* 添加公告栏样式 */
.announcements {
  background: white;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 24px;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.refresh-btn {
  padding: 6px 16px;
  background-color: #1890ff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.refresh-btn:hover {
  background-color: #40a9ff;
}

.announcement-content {
  color: #666;
  min-height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 页脚样式 */
.footer {
  background-color: white;
  padding: 20px;
  text-align: center;
  margin-top: auto;
}

.footer-content {
  color: #666;
  font-size: 14px;
}

.footer-link {
  color: #1890ff;
  text-decoration: none;
}

.footer-link:hover {
  text-decoration: underline;
}
</style> 