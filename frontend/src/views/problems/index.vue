/* eslint-disable vue/multi-word-component-names */
<template>
  <div class="problems-page">
    <nav-bar></nav-bar>
    <div class="content">
      <!-- 学习计划部分 -->
      <div class="learning-plans">
        <div class="section-header">
          <h2>学习计划</h2>
          <router-link to="/learning-plans" class="view-more">查看更多</router-link>
        </div>
        <div class="plan-cards">
          <router-link 
            v-for="(plan, index) in paginatedPlans" 
            :key="index"
            :to="`/learning-plans/${plan.id}`"
            class="plan-card"
          >
            <div class="plan-icon">
              <img :src="plan.icon" :alt="plan.title">
            </div>
            <div class="plan-info">
              <h3>{{ plan.title }}</h3>
              <p>{{ plan.description }}</p>
              <div class="plan-creator" v-if="plan.creator_name">
                <span>创建者: {{ plan.creator_name }}</span>
              </div>
            </div>
          </router-link>
        </div>
        <div class="pagination">
          <button class="page-button" @click="prevPlanPage" :disabled="currentPlanPage === 1">
            <svg class="arrow-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>
          <span class="page-info">第 {{ currentPlanPage }} 页，共 {{ totalPlanPages }} 页</span>
          <button class="page-button" @click="nextPlanPage" :disabled="currentPlanPage >= totalPlanPages">
            <svg class="arrow-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>
        </div>
      </div>

      <!-- 搜索控件部分 -->
      <div class="search-controls-wrapper">
        <div class="search-controls">
          <div class="difficulty-select-wrapper">
            <el-select
              v-model="selectedDifficulty"
              placeholder="选择难度"
              class="difficulty-select"
              popper-class="dark-select"
            >
              <el-option
                v-for="item in difficulties"
                :key="item.code"
                :label="item.name"
                :value="item.code"
              />
            </el-select>
          </div>
          <div class="status-select-wrapper">
            <el-select
              v-model="selectedStatus"
              placeholder="选择状态"
              class="status-select"
            >
              <el-option label="全部" value=""></el-option>
              <el-option label="已通过" value="Accepted"></el-option>
              <el-option label="未通过" value="Not Started"></el-option>
            </el-select>
          </div>
          <div class="search-box">
            <input 
              type="text" 
              v-model="searchQuery" 
              placeholder="搜索题目..."
            >
            <button 
              v-if="/^\d+$/.test(searchQuery.trim())"
              class="exact-search-btn"
              :class="{ active: isExactSearch }"
              @click="toggleExactSearch"
            >
              精确搜索
            </button>
            <i class="search-icon"></i>
          </div>
          <button class="reset-button" @click="resetFilters">重置</button>
        </div>
      </div>

      <div class="main-content">
        <!-- 左侧题目列表 -->
        <div class="problems-list">
          <div class="problem-cards">
            <router-link 
              v-for="problem in paginatedProblems" 
              :key="problem.id" 
              :to="'/problems/detail/' + problem.problem_number"
              class="problem-card"
            >
              <div class="problem-number">{{ problem.problem_number }}</div>
              <div class="problem-info">
                <div class="problem-title">
                  {{ problem.title }}
                  <template v-if="problem.status === 'Accepted'">
                    <span class="status-tag accepted">已通过</span>
                  </template>
                </div>
                <div class="problem-stats">
                  <span class="difficulty-tag" :class="problem.difficulty">{{ problem.difficulty }}</span>
                  <span class="submission-info">提交: {{ problem.total_submissions }}</span>
                  <span class="rate-info">通过率: {{ problem.acceptance_rate }}%</span>
                </div>
                <div class="problem-tags">
                  <span v-for="tag in problem.tags" :key="tag" class="tag">{{ tag }}</span>
                </div>
              </div>
            </router-link>
          </div>
          
          <div class="pagination">
            <button class="page-button" @click="prevPage" :disabled="currentPage === 1">
              <svg class="arrow-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
            <span class="page-info">第 {{ currentPage }} 页，共 {{ totalPages }} 页</span>
            <button class="page-button" @click="nextPage" :disabled="currentPage >= totalPages">
              <svg class="arrow-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
          </div>
        </div>

        <!-- 右侧分类栏 -->
        <div class="categories">
          <h3>题目分类</h3>
          <!-- 添加搜索框 -->
          <div class="tag-search">
            <input 
              type="text" 
              v-model="tagSearchQuery" 
              placeholder="搜索标签..."
              class="tag-search-input"
            />
          </div>
          <!-- 标签列表 -->
          <div class="tag-list">
            <button
              v-for="tag in paginatedTags"
              :key="tag"
              :class="['category-tag', { active: selectedTags.includes(tag) }]"
              @click="selectTag(tag)"
            >
              {{ tag }}
            </button>
          </div>
          <!-- 标签分页 -->
          <div class="tag-pagination">
            <button 
              class="page-button" 
              @click="prevTagPage" 
              :disabled="tagCurrentPage === 1"
            >
              <svg class="arrow-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
            <span class="page-info">{{ tagCurrentPage }} / {{ totalTagPages }}</span>
            <button 
              class="page-button" 
              @click="nextTagPage" 
              :disabled="tagCurrentPage >= totalTagPages"
            >
              <svg class="arrow-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'
import axios from 'axios';
import { ElSelect, ElOption } from 'element-plus'

export default {
  name: 'ProblemsPage',
  components: {
    NavBar,
    ElSelect,
    ElOption
  },
  data() {
    return {
      problems: [],
      tags: [],
      selectedTags: [],
      searchQuery: '',
      currentPage: 1,
      itemsPerPage: 10,
      selectedDifficulty: '',
      difficulties: [
        { name: '全部难度', code: '' },
        { name: '简单', code: '简单' },
        { name: '中等', code: '中等' },
        { name: '困难', code: '困难' }
      ],
      tagSearchQuery: '',
      tagCurrentPage: 1,
      tagsPerPage: 10,
      plans: [],
      isExactSearch: false,
      selectedStatus: '',
      currentPlanPage: 1,
      plansPerPage: 6,
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.filterProblems().length / this.itemsPerPage);
    },
    paginatedProblems() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      return this.filterProblems().slice(start, start + this.itemsPerPage);
    },
    // 过滤后的标签列表
    filteredTags() {
      if (!this.tagSearchQuery) return this.tags;
      const query = this.tagSearchQuery.toLowerCase();
      return this.tags.filter(tag => 
        tag.toLowerCase().includes(query)
      );
    },
    // 标签总页数
    totalTagPages() {
      return Math.ceil(this.filteredTags.length / this.tagsPerPage);
    },
    // 当前页的标签
    paginatedTags() {
      const start = (this.tagCurrentPage - 1) * this.tagsPerPage;
      return this.filteredTags.slice(start, start + this.tagsPerPage);
    },
    totalPlanPages() {
      return Math.ceil(this.plans.length / this.plansPerPage);
    },
    paginatedPlans() {
      const start = (this.currentPlanPage - 1) * this.plansPerPage;
      return this.plans.slice(start, start + this.plansPerPage);
    }
  },
  async created() {
    await this.fetchPlans();
    this.fetchProblems();
    this.fetchTags();
    this.updateItemsPerPage();
    window.addEventListener('resize', this.updateItemsPerPage);
  },
  methods: {
    async fetchPlans() {
      try {
        console.log('开始获取学习计划...');
        const userInfoStr = localStorage.getItem('userInfo');
        if (!userInfoStr) {
          console.warn('用户未登录，没有userInfo');
          this.plans = [];
          return;
        }

        let userInfo;
        try {
          userInfo = JSON.parse(userInfoStr);
        } catch (e) {
          console.error('解析userInfo失败:', e);
          this.plans = [];
          return;
        }

        if (!userInfo || !userInfo.token) {
          console.warn('无效的用户信息或token');
          this.plans = [];
          return;
        }

        console.log('准备发送请求，token:', userInfo.token);
        console.log('当前用户角色:', userInfo.role);
        
        const response = await axios.get('http://localhost:3000/api/learning-plans', {
          headers: {
            'Authorization': `Bearer ${userInfo.token}`
          },
          params: {
            all: true
          }
        });

        console.log('服务器返回数据:', response.data);
        
        if (!response.data || !response.data.success) {
          console.warn('服务器返回错误:', response.data);
          this.plans = [];
          return;
        }

        const plansData = response.data.data;
        if (!Array.isArray(plansData)) {
          console.error('返回数据格式不正确，期望数组但收到:', typeof plansData);
          this.plans = [];
          return;
        }

        this.plans = plansData.map(plan => {
          const iconPath = plan.icon?.startsWith('http') 
            ? plan.icon 
            : plan.icon || '/icons/default.png';
            
          return {
            id: plan.id,
            title: plan.title,
            description: plan.description,
            icon: iconPath,
            tag: plan.tag,
            creator_name: plan.creator_name || ''
          };
        });

        console.log('处理后的学习计划:', this.plans);
      } catch (error) {
        console.error('获取学习计划失败:', error);
        console.error('错误详情:', {
          status: error.response?.status,
          data: error.response?.data,
          message: error.message
        });
        this.plans = [];
        this.$message.error('获取学习计划失败，请稍后重试');
      }
    },
    async fetchProblems() {
      try {
        console.log('开始获取题目列表...');
        const userInfoStr = localStorage.getItem('userInfo');
        const token = userInfoStr ? JSON.parse(userInfoStr).token : null;
        
        if (!token) {
          console.error('未找到用户token');
          throw new Error('请先登录');
        }

        const headers = { Authorization: `Bearer ${token}` };
        console.log('发送请求，headers:', headers);

        // 获取题目列表
        const response = await axios.get('http://localhost:3000/api/problems/user/list', { headers });
        console.log('获取到的题目数据:', response.data);
        
        if (response.data && response.data.code === 200 && response.data.data) {
          const problemsData = response.data.data.problems || [];
          console.log('解析的题目数据:', problemsData);
          
          this.problems = problemsData.map(problem => ({
            id: problem.id,
            problem_number: problem.problem_number || '',
            title: problem.title || '',
            difficulty: problem.difficulty || '简单',
            tags: Array.isArray(problem.tags) ? problem.tags : 
                  (problem.tags ? problem.tags.split(',').map(tag => tag.trim()) : []),
            acceptance_rate: parseFloat(problem.acceptance_rate) || 0,
            total_submissions: parseInt(problem.total_submissions) || 0,
            status: problem.status || 'Not Started',
            description: problem.description || ''
          }));
          
          console.log('处理后的题目列表:', this.problems);
        } else {
          console.error('API返回格式不正确:', response.data);
          throw new Error('获取题目列表失败');
        }
      } catch (error) {
        console.error('获取题目列表失败:', error);
        if (error.response?.status === 401) {
          localStorage.removeItem('userInfo');
          this.$message.error('登录已过期，请重新登录');
        } else {
          this.$message.error(error.message || '获取题目列表失败，请稍后重试');
        }
        this.problems = [];
      }
    },
    async fetchTags() {
      try {
        console.log('开始获取标签列表...');
        const response = await axios.get('http://localhost:3000/api/problems/tags');
        console.log('获取到的标签数据:', response.data);
        
        if (response.data && response.data.code === 200) {
          // 确保数据存在且是数组
          const tags = response.data.data || [];
          // 去重并排序
          this.tags = [...new Set(tags)].sort();
          console.log('处理后的标签列表:', this.tags);
        } else {
          console.error('获取标签失败:', response.data);
          throw new Error('获取标签失败');
        }
      } catch (error) {
        console.error('获取标签失败:', error);
        this.$message.error('获取标签失败，请检查网络连接或稍后重试');
        this.tags = [];
      }
    },
    filterProblems() {
      let filteredProblems = this.problems;

      if (this.selectedTags.length > 0) {
        filteredProblems = filteredProblems.filter(problem => {
          return this.selectedTags.every(tag => problem.tags.includes(tag));
        });
      }

      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase();
        
        if (/^\d+$/.test(query) && this.isExactSearch) {
          filteredProblems = filteredProblems.filter(problem => 
            problem.id.toString() === query
          );
        } else {
          filteredProblems = filteredProblems.filter(problem => {
            return (
              problem.id.toString().includes(query) ||
              problem.title.toLowerCase().includes(query)
            );
          });
        }
      }

      if (this.selectedDifficulty) {
        filteredProblems = filteredProblems.filter(problem => 
          problem.difficulty === this.selectedDifficulty
        );
      }

      if (this.selectedStatus) {
        filteredProblems = filteredProblems.filter(problem => 
          problem.status === this.selectedStatus
        );
      }

      return filteredProblems;
    },
    selectTag(tag) {
      if (this.selectedTags.includes(tag)) {
        this.selectedTags = this.selectedTags.filter(t => t !== tag);
      } else {
        this.selectedTags.push(tag);
      }
      this.currentPage = 1;
    },
    resetFilters() {
      this.selectedTags = [];
      this.selectedDifficulty = '';
      this.searchQuery = '';
      this.currentPage = 1;
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
      }
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
      }
    },
    updateItemsPerPage() {
      const width = window.innerWidth;
      if (width < 2000) {
        this.itemsPerPage = 10;
      } else if (width < 3000) {
        this.itemsPerPage = 15;
      } else {
        this.itemsPerPage = 20;
      }
      this.currentPage = 1;
    },
    // 标签分页方法
    prevTagPage() {
      if (this.tagCurrentPage > 1) {
        this.tagCurrentPage--;
      }
    },
    nextTagPage() {
      if (this.tagCurrentPage < this.totalTagPages) {
        this.tagCurrentPage++;
      }
    },
    toggleExactSearch() {
      this.isExactSearch = !this.isExactSearch
      this.currentPage = 1
    },
    nextPlanPage() {
      if (this.currentPlanPage < this.totalPlanPages) {
        this.currentPlanPage++;
      }
    },
    prevPlanPage() {
      if (this.currentPlanPage > 1) {
        this.currentPlanPage--;
      }
    },
  },
  beforeUnmount() {
    window.removeEventListener('resize', this.updateItemsPerPage);
  },
  watch: {
    // 监听搜索条件变化
    searchQuery(newVal) {
      if (!/^\d+$/.test(newVal.trim())) {
        this.isExactSearch = false;
      }
      this.currentPage = 1;
    },
    // 监听难度选择变化
    selectedDifficulty() {
      this.currentPage = 1;
    },
    // 监听标签选择变化
    selectedTags: {
      handler() {
        this.currentPage = 1;
      },
      deep: true
    },
    // 监听标签搜索，重置页码
    tagSearchQuery() {
      this.tagCurrentPage = 1;
    },
    selectedStatus() {
      this.currentPage = 1;
    },
  },
}
</script>

<style scoped>
.problems-page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #0d1117;
  color: white;
}

.content {
  padding: 40px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* 学习计划样式 */
.learning-plans {
  padding: 20px;
  margin: 0;
  background-color: #1e1e2d;
  border-radius: 8px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-header h2 {
  font-size: 20px;
  color: #fff;
  margin: 0;
}

.view-more {
  color: #4ecdc4;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s ease;
}

.view-more:hover {
  color: #5fede4;
}

.plan-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr); /* 修改为固定3列布局 */
  gap: 20px;
}

.plan-card {
  display: flex;
  align-items: center;
  padding: 20px;
  background: #282836;
  border-radius: 12px;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.plan-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  border-color: #4ecdc4;
  background: #2f2f40;
}

.plan-icon {
  width: 60px;
  height: 60px;
  margin-right: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.plan-icon img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.plan-info {
  flex: 1;
}

.plan-info h3 {
  margin: 0 0 8px 0;
  font-size: 16px;
  color: #fff;
}

.plan-info p {
  margin: 0;
  font-size: 14px;
  color: #a6accd;
  line-height: 1.4;
}

.plan-creator {
  margin-top: 8px;
  font-size: 12px;
  color: #6a7a8c;
  display: flex;
  align-items: center;
}

.plan-creator span {
  background-color: rgba(78, 205, 196, 0.1);
  padding: 2px 8px;
  border-radius: 4px;
  color: #4ecdc4;
}

/* 响应式布局 */
@media (max-width: 1200px) {
  .plan-cards {
    grid-template-columns: repeat(2, 1fr); /* 中等屏幕显示2列 */
  }
}

@media (max-width: 768px) {
  .plan-cards {
    grid-template-columns: 1fr; /* 小屏幕显示1列 */
  }
  
  .plan-card {
    padding: 15px;
  }
  
  .plan-icon {
    width: 50px;
    height: 50px;
  }
}

/* 新的搜索控件样式 */
.search-controls-wrapper {
  margin: 0;
  padding: 0 20px;
  margin-bottom: -10px;
}

.search-controls {
  display: flex;
  gap: 16px;
  align-items: center;
  background: #282836;
  padding: 16px;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.difficulty-select-wrapper {
  min-width: 120px;
}

.difficulty-select {
  width: 120px;
}

.status-select-wrapper {
  min-width: 120px;
}

.search-box {
  position: relative;
  flex: 1;
  max-width: 400px;
}

.search-box input {
  width: 100%;
  padding: 8px 12px;
  border-radius: 6px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #2d2d3f;
  color: white;
  font-size: 14px;
  padding-right: 100px; /* 为精确搜索按钮留出空间 */
}

.exact-search-btn {
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  padding: 4px 8px;
  border-radius: 4px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: #2d2d3f;
  color: #a6accd;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.exact-search-btn.active {
  background: #4ecdc4;
  color: white;
  border-color: #4ecdc4;
}

.exact-search-btn:hover {
  background: #4ecdc4;
  color: white;
  border-color: #4ecdc4;
}

.reset-button {
  padding: 8px 16px;
  border-radius: 6px;
  background: transparent;
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: #a6accd;
  cursor: pointer;
  transition: all 0.3s ease;
}

.reset-button:hover {
  border-color: #4ecdc4;
  color: #fff;
}

/* 响应式布局调整 */
@media (max-width: 768px) {
  .search-controls {
    flex-direction: column;
    gap: 12px;
  }

  .difficulty-select-wrapper {
    width: 100%;
  }

  .search-box {
    width: 100%;
  }

  .reset-button {
    width: 100%;
  }
}

/* 主要内容区域样式 */
.main-content {
  display: flex;
  gap: 40px;
  margin-top: 10px;
}

.problems-list {
  flex: 3;
}

.problem-cards {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.problem-card {
  background-color: #1e1e2e;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  gap: 20px;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
  text-decoration: none;
  color: inherit;
  cursor: pointer;
}

.problem-card:hover {
  transform: translateX(8px);
  border-color: rgba(255, 255, 255, 0.2);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.problem-number {
  font-size: 24px;
  font-weight: bold;
  color: #a6accd;
  min-width: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.problem-info {
  flex: 1;
}

.problem-title {
  display: flex;
  align-items: center;
  font-size: 16px;
  font-weight: 500;
  color: #e6edf3;
  margin-bottom: 8px;
}

.problem-card:hover .problem-title {
  color: #4ecdc4;
}

.problem-stats {
  margin-top: 8px;
  display: flex;
  gap: 16px;
  color: #a6accd;
  font-size: 14px;
}

.difficulty-tag {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.difficulty-tag.简单 {
  background-color: #4caf50;
  color: white;
}

.difficulty-tag.中等 {
  background-color: #ff9800;
  color: white;
}

.difficulty-tag.困难 {
  background-color: #f44336;
  color: white;
}

.problem-tags {
  margin-top: 8px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.tag {
  background-color: #2d2d3f;
  color: #a6accd;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

/* 分页控件样式 */
.pagination {
  margin-top: 24px;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
}

.page-button {
  background-color: #2d2d3f;
  border: none;
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.page-button:hover:not(:disabled) {
  background-color: #3d3d4f;
}

.page-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  color: #a6accd;
}

/* 右侧分类栏样式 */
.categories {
  flex: 1;
  background-color: #1e1e2e;
  border-radius: 16px;
  padding: 24px;
  height: fit-content;
}

.categories h3 {
  font-size: 20px;
  margin-bottom: 16px;
  color: #fff;
}

/* 标签搜索框样式 */
.tag-search {
  margin-bottom: 16px;
}

.tag-search-input {
  width: 100%;
  padding: 8px 12px;
  background-color: #2d2d3f;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  font-size: 14px;
  transition: all 0.3s ease;
}

.tag-search-input:focus {
  outline: none;
  border-color: #4ecdc4;
  box-shadow: 0 0 0 2px rgba(78, 205, 196, 0.2);
}

.tag-search-input::placeholder {
  color: #a6accd;
}

/* 标签分页样式 */
.tag-pagination {
  margin-top: 16px;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 12px;
}

.tag-pagination .page-button {
  width: 32px;
  height: 32px;
  background-color: #2d2d3f;
  border: none;
  border-radius: 6px;
  color: #a6accd;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.tag-pagination .page-button:hover:not(:disabled) {
  background-color: #3d3d4f;
  color: white;
}

.tag-pagination .page-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.tag-pagination .page-info {
  color: #a6accd;
  font-size: 14px;
}

.tag-pagination .arrow-icon {
  width: 16px;
  height: 16px;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .main-content {
    flex-direction: column;
  }
  
  .categories {
    order: -1;
  }
  
  .tag-list {
    flex-direction: row;
    flex-wrap: wrap;
    gap: 12px;
  }
  
  .category-tag {
    width: calc(50% - 6px);
    padding: 12px 16px;
  }
}

@media (max-width: 768px) {
  .content {
    padding: 20px;
  }
  
  .search-controls {
    flex-direction: column;
  }
  
  .problem-card {
    flex-direction: column;
  }
  
  .problem-number {
    text-align: left;
  }
}

/* 添加箭头图标样式 */
.arrow-icon {
  width: 24px;
  height: 24px;
  color: #a6accd;
}

.page-button:hover:not(:disabled) .arrow-icon {
  color: #fff;
}

.page-button:disabled .arrow-icon {
  color: rgba(166, 172, 205, 0.5);
}

.status-tag {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
  margin-left: 8px;
  display: inline-block;
}

.status-tag.accepted {
  background-color: #4ecdc4;
  color: white;
}

.tag-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.category-tag {
  width: 100%;
  background-color: #2d2d3f;
  color: #a6accd;
  border: 1px solid rgba(255, 255, 255, 0.1);
  padding: 16px 20px;
  border-radius: 12px;
  text-align: left;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 15px;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.category-tag:hover {
  background-color: rgba(78, 205, 196, 0.1);
  border-color: #4ecdc4;
  transform: translateX(8px);
  color: #fff;
}

.category-tag.active {
  background-color: #4ecdc4;
  color: white;
  border-color: #4ecdc4;
  position: relative;
}

.category-tag.active::after {
  content: "✓";
  margin-left: 8px;
  font-weight: bold;
}

/* 重新设计的下拉框样式 */
:deep(.el-select) {
  --el-select-border-color-hover: #4ecdc4;
  --el-fill-color-blank: #1e1e2d;
  --el-border-color: rgba(255, 255, 255, 0.1);
  --el-text-color-regular: #fff;
}

:deep(.el-input__wrapper) {
  background-color: #1e1e2d !important;
  box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.1) !important;
  border-radius: 6px;
  padding: 0 8px;
}

:deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #4ecdc4 !important;
}

:deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #4ecdc4 !important;
}

:deep(.el-input__inner) {
  color: #fff !important;
  height: 35px;
  line-height: 35px;
  font-size: 14px;
}

:deep(.el-input__inner::placeholder) {
  color: #a6accd !important;
}

:deep(.el-select__caret) {
  color: #a6accd;
}

:global(.dark-select) {
  background-color: #1e1e2d !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 6px !important;
}

:global(.dark-select .el-select-dropdown__item) {
  color: #a6accd !important;
  height: 35px;
  line-height: 35px;
  padding: 0 12px;
}

:global(.dark-select .el-select-dropdown__item:hover) {
  background-color: #282836 !important;
  color: #4ecdc4 !important;
}

:global(.dark-select .el-select-dropdown__item.selected) {
  background-color: #282836 !important;
  color: #4ecdc4 !important;
  font-weight: 500;
}

:global(.dark-select .el-popper__arrow::before) {
  background-color: #1e1e2d !important;
  border-color: rgba(255, 255, 255, 0.1) !important;
}

:global(.dark-select .el-select-dropdown__wrap) {
  background-color: #1e1e2d !important;
}

:global(.el-select__popper.el-popper) {
  background: #1e1e2d !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3) !important;
}

/* 移除旧的PrimeVue相关样式 */
:deep(.p-dropdown),
:deep(.p-dropdown-panel),
:deep(.p-dropdown-items),
:deep(.p-dropdown-item) {
  display: none;
}

.status-select {
    background-color: #333; /* 深色背景 */
    color: #fff; /* 白色字体 */
}

.status-select .el-select-dropdown {
    background-color: #444; /* 深色下拉菜单背景 */
    color: #fff; /* 白色字体 */
}

.status-select .el-option {
    color: #fff; /* 白色字体 */
}

.status-select .el-option:hover {
    background-color: #555; /* 悬停时的深色背景 */
}
</style> 