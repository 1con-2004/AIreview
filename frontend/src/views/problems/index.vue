<template>
  <div class="problems-page">
    <nav-bar></nav-bar>
    <div class="content">
      <div class="left-column">
        <div class="header">
          <h2>题目列表</h2>
          <div class="filter-controls">
            <label for="difficulty">难度：</label>
            <select id="difficulty" class="difficulty-select">
              <option>全部</option>
              <option>简单</option>
              <option>中等</option>
              <option>困难</option>
            </select>
            <input type="text" class="search-box" placeholder="关键词">
            <button class="reset-button">重置</button>
          </div>
        </div>
        <div class="table-container">
          <table class="topics-table">
            <thead>
              <tr>
                <th>编号</th>
                <th>标题</th>
                <th>难度</th>
                <th>提交总数</th>
                <th>通过率</th>
                <th>标签</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="problem in filterProblems()" :key="problem.id">
                <td>{{ problem.problem_number }}</td>
                <td>
                  <router-link :to="'/problems/detail/' + problem.problem_number" class="problem-title">{{ problem.title }}</router-link>
                </td>
                <td><span class="tag">{{ problem.difficulty }}</span></td>
                <td>{{ problem.total_submissions }}</td>
                <td>{{ problem.acceptance_rate }}%</td>
                <td>
                  <div class="label-container">
                    <span v-for="tag in problem.tags" :key="tag" class="tag">{{ tag }}</span>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="pagination">
          <button class="prev-button">&lt;</button>
          <button class="page-button active">1</button>
          <button class="page-button">2</button>
          <button class="page-button">3</button>
          <button class="page-button">4</button>
          <button class="next-button">&gt;</button>
        </div>
      </div>
      <div class="right-column">
        <h3>标签</h3>
        <div class="tag-buttons">
          <button 
            v-for="tag in tags" 
            :key="tag" 
            class="tag-button" 
            :class="{ 'active': selectedTags.includes(tag) }" 
            @click="selectTag(tag)"
          >
            {{ tag }}
          </button>
        </div>
        <button class="pick-button">选择</button>
      </div>
    </div>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'
import axios from 'axios';

export default {
  name: 'ProblemsPage',
  components: {
    NavBar
  },
  data() {
    return {
      problems: [], // 存储题目信息
      tags: [], // 存储标签
      selectedTags: [] // 存储选中的标签
    }
  },
  created() {
    this.fetchProblems(); // 组件创建时获取题目信息
    this.fetchTags(); // 获取标签
  },
  methods: {
    async fetchProblems() {
      try {
        console.log('Fetching problems...'); // 添加调试信息
        const response = await axios.get('http://localhost:3000/api/problems'); // 获取题目信息
        console.log('Problems fetched:', response.data); // 打印获取到的数据
        // 将 tags 字段处理为数组
        this.problems = response.data.map(problem => ({
          ...problem,
          tags: problem.tags.split(',') // 将 tags 字段转换为数组
        })); // 更新题目信息
      } catch (error) {
        console.error('获取题目失败:', error);
      }
    },
    async fetchTags() {
      try {
        const response = await axios.get('http://localhost:3000/api/problems/tags'); // 获取标签
        this.tags = response.data; // 更新标签
      } catch (error) {
        console.error('获取标签失败:', error);
      }
    },
    filterProblems() {
      // 根据选中的标签过滤题目
      if (this.selectedTags.length === 0) {
        return this.problems; // 如果没有选中标签，返回所有题目
      }
      return this.problems.filter(problem => {
        const problemTags = problem.tags; // 直接使用数组
        return this.selectedTags.some(tag => problemTags.includes(tag)); // 检查是否有选中的标签
      });
    },
    selectTag(tag) {
      if (this.selectedTags.includes(tag)) {
        this.selectedTags = this.selectedTags.filter(t => t !== tag); // 取消选中
      } else {
        this.selectedTags.push(tag); // 选中
      }
    }
  }
}
</script>

<style scoped>
.problems-page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f5f5f5; /* 浅灰色背景 */
  border-radius: 15px; /* 圆角 */
  overflow: hidden; /* 确保圆角效果 */
}

.content {
  display: flex;
  flex: 1; /* 使内容区域填充剩余空间 */
  padding: 20px;
}

.left-column {
  flex: 5; /* 左边部分占据更大空间 */
  display: flex;
  flex-direction: column;
  margin-right: 20px;
}

.header {
  display: flex;
  justify-content: space-between; /* 使标题和按钮分开 */
  align-items: center; /* 垂直居中 */
}

.filter-controls {
  display: flex;
  align-items: center;
}

.difficulty-select {
  margin-right: 10px;
  padding: 10px; /* 加大内边距 */
  font-size: 16px; /* 加大字体 */
}

.search-box {
  margin-right: 10px;
  padding: 10px; /* 加大内边距 */
  font-size: 16px; /* 加大字体 */
  border-radius: 15px; /* 圆角 */
}

.reset-button {
  background-color: #f0f0f0;
  border: none;
  padding: 10px 15px; /* 加大内边距 */
  border-radius: 5px;
  cursor: pointer;
  font-size: 16px; /* 加大字体 */
}

.table-container {
  background-color: #ffffff; /* 白色背景 */
  padding: 20px; /* 内边距 */
  border-radius: 15px; /* 圆角 */
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); /* 增加阴影效果 */
  margin-top: 20px; /* 与其他组件的间距 */
}

.topics-table {
  width: 100%;
  border-collapse: collapse;
}

.topics-table th,
.topics-table td {
  padding: 10px;
  text-align: left;
}

.topics-table th {
  background-color: #00796b;
  color: white;
}

.topics-table .tag {
  background-color: green;
  color: white;
  padding: 3px 6px;
  border-radius: 3px;
}

.topics-table .label-container {
  background-color: #ffffff; /* 白色背景 */
  padding: 5px; /* 内边距 */
  border-radius: 15px; /* 圆角 */
  display: inline-flex; /* 使标签在一行内显示 */
}

.topics-table .label {
  background-color: #e0e0e0;
  padding: 3px 6px;
  border-radius: 15px; /* 椭圆形 */
  margin-right: 5px;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.page-button,
.prev-button,
.next-button {
  background-color: #00796b;
  color: white;
  border: none;
  padding: 5px 10px;
  margin: 0 5px;
  border-radius: 5px;
  cursor: pointer;
}

.page-button.active {
  background-color: #004d40; /* 当前页的颜色 */
}

.page-button:hover,
.prev-button:hover,
.next-button:hover {
  background-color: #004d40; /* 悬停时的颜色 */
}

.right-column {
  flex: 1; /* 右侧标签选择区域，缩小宽度 */
  padding: 20px;
  background-color: #ffffff; /* 白色背景 */
  border-radius: 15px; /* 圆角 */
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); /* 增加阴影效果 */
}

.tag-buttons {
  display: flex;
  flex-direction: column;
  margin-bottom: 20px;
}

.tag-button {
  background-color: #e0e0e0;
  border: none;
  padding: 5px 10px;
  border-radius: 10px; /* 圆角矩形 */
  margin: 5px 0;
  cursor: pointer;
  width: auto; /* 自动宽度 */
  height: auto; /* 自动高度 */
  display: flex;
  align-items: center;
  justify-content: center;
}

.pick-button {
  background-color: #00796b;
  color: white;
  border: none;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
}

.tag-button.active {
  background-color: #00796b; /* 选中时的背景颜色 */
  color: white; /* 选中时的字体颜色 */
}
</style> 