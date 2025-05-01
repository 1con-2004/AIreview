<template>
  <div class="page-container">
    <nav-bar></nav-bar>
    <div class="learning-plans-container">
      <div class="header-section">
        <h1 class="page-title">学习计划</h1>
        <div class="search-box">
          <input
            type="text"
            v-model="searchQuery"
            placeholder="搜索学习计划..."
            @input="handleSearch"
          >
          <i class="search-icon">🔍</i>
        </div>
      </div>

      <!-- 计划列表 -->
      <div class="plans-grid">
        <div v-for="plan in displayedPlans" :key="plan.id" class="plan-card" @click="goToPlanDetail(plan.id)">
          <div class="plan-header">
            <img :src="plan.icon || '/icons/algorithm.png'" :alt="plan.title" class="plan-icon">
            <span class="plan-tag">{{ plan.tag }}</span>
          </div>
          <div class="plan-content">
            <h2 class="plan-title">{{ plan.title }}</h2>
            <p class="plan-description">{{ plan.description }}</p>
            <div class="plan-info">
              <span class="difficulty" :class="plan.difficulty_level">
                {{ plan.difficulty_level }}
              </span>
              <span class="estimated-days">
                预计 {{ plan.estimated_days }} 天
              </span>
            </div>
            <div class="plan-points">
              <ul>
                <li v-for="(point, index) in parsePoints(plan.points)" :key="index">
                  {{ point }}
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <!-- 分页组件 -->
      <div class="pagination">
        <button
          class="page-btn"
          :disabled="currentPage === 1"
          @click="changePage(currentPage - 1)"
        >
          上一页
        </button>
        <div class="page-numbers">
          <button
            v-for="page in displayedPages"
            :key="page"
            class="page-number"
            :class="{ active: currentPage === page }"
            @click="changePage(page)"
          >
            {{ page }}
          </button>
        </div>
        <button
          class="page-btn"
          :disabled="currentPage === totalPages"
          @click="changePage(currentPage + 1)"
        >
          下一页
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import { ElMessage } from 'element-plus'
import learningPlansApi from '@/api/learningPlans'

export default {
  name: 'LearningPlans',
  components: {
    NavBar
  },
  setup () {
    const router = useRouter()
    const plans = ref([])
    const filteredPlans = ref([])
    const searchQuery = ref('')
    const currentPage = ref(1)
    const itemsPerPage = 6 // 调整每一页的默认显示个数

    // 计算总页数
    const totalPages = computed(() => {
      return Math.max(1, Math.ceil(filteredPlans.value.length / itemsPerPage))
    })

    // 计算当前页显示的计划
    const displayedPlans = computed(() => {
      const start = (currentPage.value - 1) * itemsPerPage
      const end = start + itemsPerPage
      return filteredPlans.value.slice(start, end)
    })

    // 计算要显示的页码
    const displayedPages = computed(() => {
      const pages = []
      const maxVisiblePages = 5
      let start = Math.max(1, currentPage.value - Math.floor(maxVisiblePages / 2))
      const end = Math.min(totalPages.value, start + maxVisiblePages - 1)

      if (end - start + 1 < maxVisiblePages) {
        start = Math.max(1, end - maxVisiblePages + 1)
      }

      for (let i = start; i <= end; i++) {
        pages.push(i)
      }
      return pages
    })

    const parsePoints = (points) => {
      if (!points) return []
      try {
        return typeof points === 'string' ? JSON.parse(points) : points
      } catch (e) {
        console.error('解析学习要点失败:', e)
        return []
      }
    }

    const handleSearch = () => {
      if (!searchQuery.value.trim()) {
        filteredPlans.value = plans.value
      } else {
        const query = searchQuery.value.toLowerCase()
        filteredPlans.value = plans.value.filter(plan =>
          plan.title.toLowerCase().includes(query) ||
          plan.description.toLowerCase().includes(query) ||
          plan.tag.toLowerCase().includes(query)
        )
      }
      currentPage.value = 1 // 重置到第一页
    }

    const changePage = (page) => {
      if (page >= 1 && page <= totalPages.value) {
        currentPage.value = page
      }
    }

    const fetchPlans = async () => {
      try {
        const data = await learningPlansApi.getAllPlans()

        if (data) {
          plans.value = data.map(plan => ({
            id: plan.id,
            title: plan.title || '',
            description: plan.description || '',
            estimated_days: plan.estimated_days,
            points: plan.points,
            tag: plan.tag,
            difficulty_level: plan.difficulty_level,
            creator_name: plan.creator_name,
            creator_avatar: plan.creator_avatar,
            created_at: plan.created_at,
            icon: plan.icon
              ? (plan.icon.startsWith('http') ? plan.icon : `${plan.icon}`)
              : '/icons/default.png'
          }))
          filteredPlans.value = plans.value // 初始化过滤后的计划
          console.log('获取学习计划列表成功:', plans.value)
        } else {
          console.error('获取学习计划列表失败')
          ElMessage.error('获取学习计划列表失败')
        }
      } catch (error) {
        console.error('获取学习计划列表失败:', error)
        ElMessage.error('获取学习计划列表失败: ' + (error.message || '请检查网络连接或稍后重试'))
        plans.value = []
      }
    }

    const goToPlanDetail = (planId) => {
      // 引入analytics对象
      try {
        // 尝试获取全局注入的analytics对象
        const analytics = window.analytics || window.$analytics
        // 如果analytics存在，记录点击事件
        if (analytics) {
          analytics.trackClick('learning_plan_card', planId, {
            planId: planId
          })
        }
      } catch (error) {
        console.error('埋点事件记录失败:', error)
      }
      router.push('/learning-plans/' + planId)
    }

    // 监听搜索查询变化
    watch(searchQuery, handleSearch)

    onMounted(() => {
      fetchPlans()
    })

    return {
      plans,
      filteredPlans,
      displayedPlans,
      searchQuery,
      currentPage,
      totalPages,
      displayedPages,
      goToPlanDetail,
      parsePoints,
      handleSearch,
      changePage
    }
  }
}
</script>

<style scoped>
.page-container {
  min-height: 100vh;
  background-color: #0d1117;
  color: #c9d1d9;
}

.learning-plans-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.page-title {
  font-size: 24px;
  margin: 20px 0;
  color: #c9d1d9;
  font-weight: 600;
}

.search-box {
  position: relative;
  width: 300px;
}

.search-box input {
  width: 100%;
  padding: 10px 40px 10px 15px;
  border: 1px solid #30363d;
  border-radius: 6px;
  background-color: #161b22;
  color: #c9d1d9;
  font-size: 14px;
}

.search-box input:focus {
  outline: none;
  border-color: #58a6ff;
  box-shadow: 0 0 0 3px rgba(88, 166, 255, 0.1);
}

.search-icon {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #8b949e;
}

.plans-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  padding-bottom: 40px;
}

.plan-card {
  background: #161b22;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.2);
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid #30363d;
}

.plan-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
  border-color: #58a6ff;
}

.plan-header {
  position: relative;
  padding: 15px;
  background: #21262d;
  border-bottom: 1px solid #30363d;
}

.plan-icon {
  width: 40px;
  height: 40px;
  object-fit: contain;
}

.plan-tag {
  position: absolute;
  right: 15px;
  top: 15px;
  padding: 4px 12px;
  background: #1f6feb;
  color: #ffffff;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

.plan-content {
  padding: 20px;
}

.plan-title {
  font-size: 18px;
  margin-bottom: 10px;
  color: #c9d1d9;
  font-weight: 600;
}

.plan-description {
  font-size: 14px;
  color: #8b949e;
  margin-bottom: 15px;
  line-height: 1.5;
}

.plan-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.difficulty {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

.difficulty.简单 {
  background: #238636;
  color: #ffffff;
}

.difficulty.中等 {
  background: #db6d28;
  color: #ffffff;
}

.difficulty.困难 {
  background: #da3633;
  color: #ffffff;
}

.estimated-days {
  font-size: 13px;
  color: #8b949e;
  display: flex;
  align-items: center;
}

.plan-points {
  border-top: 1px solid #30363d;
  padding-top: 15px;
  margin-top: 15px;
}

.plan-points ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.plan-points li {
  font-size: 13px;
  color: #8b949e;
  margin-bottom: 8px;
  padding-left: 20px;
  position: relative;
  line-height: 1.5;
}

.plan-points li::before {
  content: "•";
  position: absolute;
  left: 0;
  color: #58a6ff;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 30px;
  padding-bottom: 30px;
  gap: 10px;
}

.page-numbers {
  display: flex;
  gap: 8px;
  margin: 0 10px;
}

.page-btn,
.page-number {
  min-width: 40px;
  height: 40px;
  padding: 0 12px;
  border: 1px solid #30363d;
  background-color: #161b22;
  color: #c9d1d9;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  border-color: #21262d;
}

.page-btn:not(:disabled):hover,
.page-number:hover {
  background-color: #21262d;
  border-color: #58a6ff;
}

.page-number.active {
  background-color: #1f6feb;
  border-color: #1f6feb;
  color: #ffffff;
  font-weight: 500;
}

@media (max-width: 768px) {
  .learning-plans-container {
    padding: 15px;
  }

  .header-section {
    flex-direction: column;
    gap: 15px;
  }

  .search-box {
    width: 100%;
  }

  .plans-grid {
    grid-template-columns: 1fr;
  }

  .page-title {
    font-size: 20px;
    margin: 15px 0;
  }

  .pagination {
    gap: 5px;
  }

  .page-numbers {
    gap: 5px;
  }

  .page-btn,
  .page-number {
    min-width: 36px;
    height: 36px;
    padding: 0 8px;
    font-size: 13px;
  }
}
</style>
