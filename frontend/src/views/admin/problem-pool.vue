<template>
  <div class="problem-pool">
    <!-- 顶部统计卡片 -->
    <div class="statistics-cards">
      <div class="stat-card">
        <div class="stat-icon">
          <i class="fas fa-code"></i>
        </div>
        <div class="stat-content">
          <div class="stat-value">{{ statistics.total || 0 }}</div>
          <div class="stat-label">总题目数</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">
          <i class="fas fa-tags"></i>
        </div>
        <div class="stat-content">
          <div class="stat-value">{{ statistics.categories || 0 }}</div>
          <div class="stat-label">题目分类</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">
          <i class="fas fa-chart-pie"></i>
        </div>
        <div class="stat-content">
          <div class="stat-distribution">
            <div class="difficulty-bar">
              <span class="difficulty-label">简单</span>
              <div class="bar-wrapper">
                <div class="bar easy" :style="{ width: getDifficultyPercentage('简单') + '%' }"></div>
              </div>
              <span class="difficulty-count">{{ getDifficultyCount('简单') }}</span>
            </div>
            <div class="difficulty-bar">
              <span class="difficulty-label">中等</span>
              <div class="bar-wrapper">
                <div class="bar medium" :style="{ width: getDifficultyPercentage('中等') + '%' }"></div>
              </div>
              <span class="difficulty-count">{{ getDifficultyCount('中等') }}</span>
            </div>
            <div class="difficulty-bar">
              <span class="difficulty-label">困难</span>
              <div class="bar-wrapper">
                <div class="bar hard" :style="{ width: getDifficultyPercentage('困难') + '%' }"></div>
              </div>
              <span class="difficulty-count">{{ getDifficultyCount('困难') }}</span>
            </div>
          </div>
          <div class="stat-label">难度分布</div>
        </div>
      </div>
      <!-- 添加返回按钮 -->
      <div class="back-button-container">
        <button class="btn-back" @click="goBack">
          <i class="fas fa-arrow-left"></i>
          返回题库
        </button>
      </div>
    </div>

    <!-- 操作栏 -->
    <div class="action-bar">
      <div class="search-box">
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="搜索题目标题、序号..."
          @input="handleSearch"
        >
      </div>
      <div class="action-buttons">
        <button class="btn-filter" @click="showFilterPanel = !showFilterPanel">
          <i class="fas fa-filter"></i>
          筛选
        </button>
      </div>
    </div>

    <!-- 筛选面板 -->
    <div class="filter-panel" v-if="showFilterPanel">
      <div class="filter-group">
        <h3>难度等级</h3>
        <div class="difficulty-filters">
          <el-select
            v-model="selectedDifficulty"
            placeholder="选择难度"
            class="difficulty-select"
            teleported
            :popper-class="'admin-problems-select'"
            @change="handleFilter"
          >
            <el-option
              v-for="item in difficulties"
              :key="item.code"
              :label="item.name"
              :value="item.code"
            />
          </el-select>
        </div>
      </div>
      <div class="filter-group">
        <h3>题目分类</h3>
        <div class="tag-search">
          <input 
            type="text" 
            v-model="tagSearchQuery" 
            placeholder="搜索标签..."
            class="tag-search-input"
          />
        </div>
        <div class="tag-list">
          <button
            v-for="tag in filteredTags"
            :key="tag"
            :class="['category-tag', { active: selectedTags.includes(tag) }]"
            @click="toggleTag(tag)"
          >
            {{ tag }}
          </button>
        </div>
      </div>
      <div class="filter-actions">
        <button class="btn-clear" @click="clearFilters">取消筛选</button>
      </div>
    </div>

    <!-- 题目列表 -->
    <div class="problems-table">
      <div class="table-header">
        <div class="col-id">序号</div>
        <div class="col-title">题目标题</div>
        <div class="col-difficulty">难度</div>
        <div class="col-tags">标签</div>
        <div class="col-category">分类</div>
        <div class="col-source">来源</div>
        <div class="col-creator">创建者</div>
        <div class="col-reference">引用次数</div>
        <div class="col-actions">操作</div>
      </div>
      <div class="table-body">
        <div v-for="problem in problems" :key="problem.id" class="table-row">
          <div class="col-id">#{{ problem.problem_number }}</div>
          <div class="col-title">{{ problem.title }}</div>
          <div class="col-difficulty">
            <span :class="'difficulty-' + problem.difficulty">
              {{ getDifficultyLabel(problem.difficulty) }}
            </span>
          </div>
          <div class="col-tags">
            <span class="category-tag" v-for="tag in problem.tags ? problem.tags.split(',') : []" :key="tag">
              {{ tag }}
            </span>
          </div>
          <div class="col-category">{{ problem.category_name || '未分类' }}</div>
          <div class="col-source">{{ problem.source }}</div>
          <div class="col-creator">
            <div class="creator-info">
              <img v-if="problem.creator && problem.creator.avatar" :src="getAvatarUrl(problem.creator.avatar)" alt="创建者头像" class="creator-avatar">
              <span v-else class="creator-avatar default-avatar">{{ problem.creator && problem.creator.username ? problem.creator.username.charAt(0).toUpperCase() : 'U' }}</span>
              <span class="creator-name">{{ problem.creator ? problem.creator.username : '未知' }}</span>
            </div>
          </div>
          <div class="col-reference">{{ problem.reference_count }}</div>
          <div class="col-actions">
            <button class="btn-import" @click="importProblem(problem)">
              <i class="fas fa-file-import"></i>
            </button>
            <button class="btn-delete" @click="deleteProblem(problem)">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 分页器 -->
    <div class="pagination">
      <button 
        :disabled="currentPage === 1" 
        @click="changePage(currentPage - 1)"
      >
        <i class="fas fa-chevron-left"></i>
      </button>
      <span class="page-info">第 {{ currentPage }} 页，共 {{ totalPages }} 页</span>
      <button 
        :disabled="currentPage === totalPages" 
        @click="changePage(currentPage + 1)"
      >
        <i class="fas fa-chevron-right"></i>
      </button>
    </div>

    <!-- 引用题目弹窗 -->
    <problem-import-dialog
      v-if="showImportDialog"
      :problem="selectedProblem"
      @close="showImportDialog = false"
      @import="handleImportProblem"
    />

    <!-- 删除确认弹窗 -->
    <delete-confirm-dialog
      v-if="showDeleteDialog"
      :item-name="selectedProblem ? selectedProblem.title : ''"
      @close="showDeleteDialog = false"
      @confirm="confirmDeleteProblem"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import ProblemImportDialog from '@/components/problem/ProblemImportDialog.vue'
import DeleteConfirmDialog from '@/components/common/DeleteConfirmDialog.vue'

const router = useRouter()

// 添加API基础URL常量
const API_BASE_URL = 'http://localhost:3000'

// 数据状态
const problems = ref([])
const statistics = ref({
  total: 0,
  categories: 0,
  difficulty: {
    '简单': 0,
    '中等': 0,
    '困难': 0
  }
})
const currentPage = ref(1)
const pageSize = ref(10)
const totalPages = ref(1)
const totalItems = ref(0)
const searchQuery = ref('')
const selectedDifficulty = ref('')
const selectedTags = ref([])
const tagSearchQuery = ref('')
const showFilterPanel = ref(false)
const showImportDialog = ref(false)
const showDeleteDialog = ref(false)
const selectedProblem = ref(null)

// 定义难度选项
const difficulties = [
  { code: '', name: '全部' },
  { code: '简单', name: '简单' },
  { code: '中等', name: '中等' },
  { code: '困难', name: '困难' }
]

// 计算所有可用的标签
const allTags = ref([])

// 根据搜索过滤标签
const filteredTags = computed(() => {
  if (!tagSearchQuery.value) {
    return allTags.value
  }
  return allTags.value.filter(tag => 
    tag.toLowerCase().includes(tagSearchQuery.value.toLowerCase())
  )
})

// 获取题目池统计信息
const fetchStatistics = async () => {
  try {
    const response = await axios.get('/api/admin/problem-pool/statistics')
    // 根据API设计，后端返回的数据位于response.data.data下，而且字段名称和前端预期不同
    if (response.data.success && response.data.data) {
      const apiData = response.data.data
      statistics.value = {
        total: apiData.totalProblems || 0,
        categories: apiData.totalCategories || 0,
        difficulty: {
          '简单': apiData.difficultyDistribution?.['简单'] || 0,
          '中等': apiData.difficultyDistribution?.['中等'] || 0,
          '困难': apiData.difficultyDistribution?.['困难'] || 0
        }
      }
    }
  } catch (error) {
    console.error('获取题目池统计信息失败:', error)
  }
}

// 获取题目池列表
const fetchProblems = async () => {
  try {
    const params = {
      page: currentPage.value,
      limit: pageSize.value,
      query: searchQuery.value, // API设计中使用query而不是search
      difficulty: selectedDifficulty.value,
      tags: selectedTags.value.join(',')
    }
    
    const response = await axios.get('/api/admin/problem-pool/list', { params })
    
    // 根据API设计，后端返回的数据位于response.data.data下
    if (response.data.success && response.data.data) {
      problems.value = response.data.data.problems || []
      totalItems.value = response.data.data.total || 0
      totalPages.value = Math.ceil(totalItems.value / pageSize.value)
      
      // 更新所有标签
      const tags = new Set()
      problems.value.forEach(problem => {
        if (problem.tags) {
          problem.tags.split(',').forEach(tag => {
            tags.add(tag.trim())
          })
        }
      })
      allTags.value = Array.from(tags)

      // 获取每个问题创建者的头像
      await fetchCreatorsAvatars()
    } else {
      problems.value = []
      totalItems.value = 0
      totalPages.value = 1
    }
  } catch (error) {
    console.error('获取题目池列表失败:', error)
  }
}

// 获取难度百分比
const getDifficultyPercentage = (difficulty) => {
  const total = statistics.value.total || 1
  const count = statistics.value.difficulty?.[difficulty] || 0
  return Math.round((count / total) * 100)
}

// 获取难度数量
const getDifficultyCount = (difficulty) => {
  return statistics.value.difficulty?.[difficulty] || 0
}

// 获取难度标签
const getDifficultyLabel = (difficulty) => {
  switch (difficulty) {
    case '简单': return '简单'
    case '中等': return '中等'
    case '困难': return '困难'
    default: return difficulty
  }
}

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1
  fetchProblems()
}

// 筛选处理
const handleFilter = () => {
  currentPage.value = 1
  fetchProblems()
}

// 切换标签选择
const toggleTag = (tag) => {
  const index = selectedTags.value.indexOf(tag)
  if (index === -1) {
    selectedTags.value.push(tag)
  } else {
    selectedTags.value.splice(index, 1)
  }
  handleFilter()
}

// 清除筛选条件
const clearFilters = () => {
  selectedDifficulty.value = ''
  selectedTags.value = []
  tagSearchQuery.value = ''
  handleFilter()
}

// 切换页码
const changePage = (page) => {
  currentPage.value = page
  fetchProblems()
}

// 引用题目
const importProblem = async (problem) => {
  try {
    // 先获取完整的题目详情
    const response = await axios.get(`/api/admin/problem-pool/${problem.id}`);
    
    if (!response.data || !response.data.success) {
      console.error('获取题目详情失败:', response.data);
      alert('获取题目详情失败，请稍后重试');
      return;
    }
    
    const fullProblemData = response.data.data;
    console.log('完整题目详情:', fullProblemData);
    
    // 获取测试用例
    const testCasesResponse = await axios.get(`/api/admin/problem-pool/${problem.id}/test-cases`);
    console.log('测试用例响应:', testCasesResponse);
    
    const testCases = testCasesResponse.data && testCasesResponse.data.success ? 
      testCasesResponse.data.data.map(tc => ({
        input: tc.input || '',
        output: tc.output || '',
        is_example: tc.is_example === 1 || tc.is_example === true
      })) : [];
    
    console.log('获取到的测试用例:', testCases);
    
    // 确保题目包含所有必要字段，如果后端返回的数据缺少某些字段，设置默认值
    const completeProblem = {
      ...problem,
      ...fullProblemData.problem, // 合并后端返回的详细信息
      time_limit: fullProblemData.problem.time_limit || problem.time_limit || 1000,
      memory_limit: fullProblemData.problem.memory_limit || problem.memory_limit || 256,
      description: fullProblemData.problem.description || problem.description || '',
      // 确保这些字段存在，即使为空
      tags: fullProblemData.problem.tags || problem.tags || '',
      category: fullProblemData.problem.category_name || fullProblemData.problem.category || problem.category || '',
      // 添加测试用例
      testcases: testCases.length > 0 ? testCases : [{
        input: '',
        output: '',
        is_example: true
      }]
    };
    
    console.log('引用题目详情:', completeProblem);
    selectedProblem.value = completeProblem;
    showImportDialog.value = true;
  } catch (error) {
    console.error('获取题目详情失败:', error);
    alert('获取题目详情失败，请稍后重试');
  }
}

// 删除题目
const deleteProblem = (problem) => {
  selectedProblem.value = problem
  showDeleteDialog.value = true
}

// 确认删除题目
const confirmDeleteProblem = async () => {
  try {
    const response = await axios.delete(`/api/admin/problem-pool/${selectedProblem.value.id}`)
    
    if (response.data.success) {
      showDeleteDialog.value = false
      // 刷新列表
      fetchProblems()
      // 刷新统计信息
      fetchStatistics()
    } else {
      alert('删除题目失败: ' + (response.data.error?.message || '未知错误'))
    }
  } catch (error) {
    console.error('删除题目失败:', error)
    alert('删除题目失败: ' + (error.response?.data?.error?.message || error.message || '未知错误'))
  }
}

// 监听筛选条件变化
watch([selectedTags], () => {
  handleFilter()
})

// 获取创建者头像
const fetchCreatorsAvatars = async () => {
  try {
    // 获取所有创建者ID
    const creatorIds = problems.value
      .filter(problem => problem.creator_id)
      .map(problem => problem.creator_id)
    
    if (creatorIds.length === 0) return
    
    // 去重
    const uniqueIds = [...new Set(creatorIds)]
    
    // 获取用户信息
    const response = await axios.post('/api/user/profiles', { userIds: uniqueIds })
    
    if (response.data.success && response.data.data) {
      const userProfiles = response.data.data
      
      // 将用户信息添加到问题中
      problems.value.forEach(problem => {
        if (problem.creator_id) {
          const userProfile = userProfiles.find(profile => profile.user_id === problem.creator_id)
          if (userProfile) {
            problem.creator = {
              username: userProfile.username || userProfile.display_name || 'unknown',
              avatar: userProfile.avatar_url
            }
            
            // 打印日志，检查头像路径
            console.log(`用户 ${problem.creator.username} 的头像路径:`, problem.creator.avatar);
          }
        }
      })
    }
  } catch (error) {
    console.error('获取创建者头像失败:', error)
  }
}

// 获取完整的头像URL
const getAvatarUrl = (avatar) => {
  if (!avatar) return `${API_BASE_URL}/uploads/avatars/default-avatar.png`
  if (avatar.startsWith('http')) return avatar
  
  // 处理数据库中存储的路径，确保使用正确的URL格式
  // 数据库中存储的格式为 public/uploads/avatars/filename.jpeg
  // 需要转换为 http://localhost:3000/uploads/avatars/filename.jpeg
  if (avatar.includes('public/uploads/avatars/')) {
    // 提取文件名
    const fileName = avatar.split('/').pop()
    return `${API_BASE_URL}/uploads/avatars/${fileName}`
  }
  
  // 处理其他情况 - 如果只有文件名
  if (!avatar.includes('/')) {
    return `${API_BASE_URL}/uploads/avatars/${avatar}`
  }
  
  return `${API_BASE_URL}${avatar.startsWith('/') ? '' : '/'}${avatar}`
}

// 返回上一页
const goBack = () => {
  router.push('/admin/problems')
}

// 页面加载时获取数据
onMounted(() => {
  fetchStatistics()
  fetchProblems()
  
  // 添加事件监听器，检测图片加载错误
  setTimeout(() => {
    const avatarImages = document.querySelectorAll('.creator-avatar');
    avatarImages.forEach(img => {
      if (img.tagName === 'IMG') {
        // 为每个头像图片添加错误处理
        img.addEventListener('error', function(e) {
          console.error('头像加载失败:', this.src);
          // 替换为默认头像
          this.src = `${API_BASE_URL}/uploads/avatars/default-avatar.png`;
        });
        
        // 添加加载成功处理
        img.addEventListener('load', function(e) {
          console.log('头像加载成功:', this.src);
        });
        
        // 如果图片已经加载完成但发生了错误，则重新加载
        if (img.complete && img.naturalHeight === 0) {
          console.warn('头像已加载但高度为0，可能加载失败:', img.src);
          img.src = `${API_BASE_URL}/uploads/avatars/default-avatar.png`;
        }
      }
    });
  }, 1000);
})

// 处理导入题目
const handleImportProblem = async (importedProblem) => {
  console.log('导入题目结果:', importedProblem);
  
  if (importedProblem.imported) {
    // 显示导入成功消息
    alert(`题目"${importedProblem.title}"已成功导入到题库，题号：${importedProblem.problem_number || '新题号'}`);
    
    // 关闭导入弹窗
    showImportDialog.value = false;
    
    // 立即更新当前列表中的引用次数
    if (importedProblem.id) {
      const problemIndex = problems.value.findIndex(p => p.id === importedProblem.id);
      if (problemIndex !== -1) {
        // 更新引用次数
        problems.value[problemIndex].reference_count = importedProblem.reference_count || 
                                                      (problems.value[problemIndex].reference_count || 0) + 1;
        console.log(`更新题目 ${importedProblem.id} 的引用次数为: ${problems.value[problemIndex].reference_count}`);
      }
    }
    
    // 刷新列表
    fetchProblems();
    
    // 更新统计信息
    fetchStatistics();
  }
}
</script>

<style scoped>
.problem-pool {
  padding: 24px;
  background-color: #f5f5f7;
  min-height: 100vh;
  position: relative;
}

.statistics-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 24px;
  margin-bottom: 32px;
  margin-top: 50px;
}

.back-button-container {
  position: absolute;
  top: 24px;
  left: 24px;
  z-index: 10;
}

.btn-back {
  padding: 10px 16px;
  background: linear-gradient(135deg, #007AFF, #0056b3);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 10px rgba(0, 122, 255, 0.3);
}

.btn-back:hover {
  background: linear-gradient(135deg, #0056b3, #003d80);
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 122, 255, 0.4);
}

.stat-card {
  background: white;
  border-radius: 16px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  transition: transform 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: linear-gradient(135deg, #007AFF, #5856D6);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 20px;
}

.stat-content {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: #1d1d1f;
}

.stat-label {
  font-size: 14px;
  color: #86868b;
  margin-top: 4px;
}

.stat-distribution {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 8px;
}

.difficulty-bar {
  display: flex;
  align-items: center;
  gap: 8px;
}

.difficulty-label {
  width: 36px;
  font-size: 12px;
  color: #1d1d1f;
}

.bar-wrapper {
  flex: 1;
  height: 6px;
  background-color: #f5f5f7;
  border-radius: 3px;
  overflow: hidden;
}

.bar {
  height: 100%;
  border-radius: 3px;
}

.bar.easy {
  background-color: #34C759;
}

.bar.medium {
  background-color: #FF9500;
}

.bar.hard {
  background-color: #FF3B30;
}

.difficulty-count {
  width: 30px;
  font-size: 12px;
  color: #86868b;
  text-align: right;
}

.action-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.search-box {
  position: relative;
  flex: 1;
  max-width: 400px;
}

.search-box input {
  width: 100%;
  padding: 12px 16px;
  border-radius: 8px;
  border: 1px solid #eaeaea;
  background: white;
  font-size: 14px;
  outline: none;
  transition: all 0.3s ease;
}

.action-buttons {
  display: flex;
  gap: 12px;
}

.btn-filter {
  padding: 12px 20px;
  border-radius: 12px;
  border: none;
  font-size: 14px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  background: rgba(0, 122, 255, 0.1);
  color: #007AFF;
}

.btn-filter:hover {
  background: rgba(0, 122, 255, 0.2);
}

.filter-panel {
  background: white;
  border-radius: 16px;
  padding: 24px;
  margin-bottom: 24px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.filter-group {
  margin-bottom: 20px;
}

.filter-group h3 {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 12px;
  color: #1d1d1f;
}

.difficulty-filters {
  margin-bottom: 16px;
}

.difficulty-select {
  width: 100%;
}

.tag-search {
  margin-bottom: 16px;
}

.tag-search-input {
  width: 100%;
  padding: 8px 12px;
  border-radius: 8px;
  border: 1px solid #eaeaea;
  background: white;
  font-size: 14px;
  outline: none;
}

.tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.category-tag {
  padding: 4px 12px;
  border-radius: 100px;
  background: #f5f5f7;
  color: #1d1d1f;
  font-size: 12px;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
}

.category-tag.active {
  background: #007AFF;
  color: white;
}

.filter-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}

.btn-clear {
  padding: 8px 16px;
  border-radius: 8px;
  border: 1px solid #eaeaea;
  background: white;
  color: #1d1d1f;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-clear:hover {
  background: #f5f5f7;
}

.problems-table {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  margin-bottom: 24px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.table-header {
  display: grid;
  grid-template-columns: 80px 2fr 1fr 1.5fr 1fr 1fr 1.5fr 1fr 100px;
  padding: 16px 24px;
  background: #f5f5f7;
  font-weight: 600;
  color: #1d1d1f;
  border-bottom: 1px solid #eaeaea;
}

.table-row {
  display: grid;
  grid-template-columns: 80px 2fr 1fr 1.5fr 1fr 1fr 1.5fr 1fr 100px;
  padding: 16px 24px;
  border-bottom: 1px solid #eaeaea;
  align-items: center;
  transition: all 0.3s ease;
}

.table-row:hover {
  background: rgba(0, 122, 255, 0.05);
}

.table-row:last-child {
  border-bottom: none;
}

.col-id {
  font-weight: 500;
  color: #007AFF;
}

.difficulty-简单 {
  color: #34C759;
  font-weight: 500;
}

.difficulty-中等 {
  color: #FF9500;
  font-weight: 500;
}

.difficulty-困难 {
  color: #FF3B30;
  font-weight: 500;
}

.col-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

.col-tags .category-tag {
  padding: 2px 8px;
  background: #f5f5f7;
  color: #1d1d1f;
  font-size: 12px;
}

.creator-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.creator-avatar {
  width: 24px;
  height: 24px;
  border-radius: 12px;
  object-fit: cover;
}

.default-avatar {
  width: 24px;
  height: 24px;
  border-radius: 12px;
  background: #007AFF;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 600;
}

.creator-name {
  font-size: 14px;
  color: #1d1d1f;
}

.col-actions {
  display: flex;
  gap: 8px;
  justify-content: center;
}

.btn-import, .btn-delete {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-import {
  background: rgba(0, 122, 255, 0.1);
  color: #007AFF;
}

.btn-import:hover {
  background: rgba(0, 122, 255, 0.2);
}

.btn-delete {
  background: rgba(255, 59, 48, 0.1);
  color: #FF3B30;
}

.btn-delete:hover {
  background: rgba(255, 59, 48, 0.2);
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 32px;
}

.pagination button {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  border: 1px solid #eaeaea;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #007AFF;
}

.pagination button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination button:not(:disabled):hover {
  background: #f5f5f7;
}

.page-info {
  font-size: 14px;
  color: #86868b;
}

@media (max-width: 1200px) {
  .table-header, .table-row {
    grid-template-columns: 60px 2fr 1fr 1.5fr 1fr 1fr 1fr 0.5fr 80px;
  }
  
  .table-header .col-source, .table-row .col-source {
    display: none;
  }
}

@media (max-width: 768px) {
  .statistics-cards {
    grid-template-columns: 1fr;
  }
  
  .problems-table {
    overflow-x: auto;
  }
  
  .table-header, .table-row {
    width: 1000px;
  }
}
</style> 