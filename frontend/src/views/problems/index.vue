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
                  <span v-if="problem.status === 'Accepted'" class="status-tag accepted">已通过</span>
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

          <!-- 添加分类搜索框 -->
          <div class="category-search">
            <input
              type="text"
              v-model="categorySearchQuery"
              placeholder="搜索分类..."
              class="category-search-input"
            />
          </div>

          <!-- 分类加载中状态 -->
          <div class="category-loading" v-if="loading.categories">
            <div class="loading-spinner"></div>
            <span>正在加载分类...</span>
          </div>

          <!-- 一级分类卡片列表 -->
          <div class="category-cards" v-else>
            <div
              v-for="category in filteredCategories"
              :key="category.id"
              class="parent-category-card"
              :class="{ 'active': expandedCategories[category.id] }"
              @click="toggleCategory(category.id)"
            >
              <div class="category-header">
                <div class="category-icon" :class="category.iconType || 'image'">
                  <template v-if="category.iconType === 'emoji'">
                    {{ category.emoji || '📚' }}
                  </template>
                  <img
                    v-else
                    :src="getCategoryIcon(category)"
                    :alt="category.name"
                    @error="handleIconError(category)"
                  />
                </div>
                <div class="category-title">{{ category.name }}</div>
                <div class="category-arrow" :class="{ 'expanded': expandedCategories[category.id] }">
                  <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M7 10L12 15L17 10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </div>
              </div>

              <!-- 子分类展开部分 -->
              <div
                class="sub-categories"
                v-if="expandedCategories[category.id]"
                :class="{ 'expanded': expandedCategories[category.id] }"
              >
                <div
                  v-for="subCategory in category.children"
                  :key="subCategory.id"
                  class="sub-category-card"
                  :class="{ 'active': selectedCategories.includes(subCategory.id) }"
                  @click.stop="selectSubCategory(subCategory.id)"
                >
                  {{ subCategory.name }}
                  <span class="check-icon" v-if="selectedCategories.includes(subCategory.id)">✓</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 如果标签还需要保留显示，可以添加一个标签区域 -->
          <div class="legacy-tags" v-if="false">
            <h4>标签</h4>
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
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'
import { ElSelect, ElOption } from 'element-plus'
import request from '@/utils/request'
import store from '@/store'

export default {
  name: 'ProblemsPage',
  components: {
    NavBar,
    ElSelect,
    ElOption
  },
  data () {
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
      categorySearchQuery: '',
      tagSearchQuery: '',
      tagCurrentPage: 1,
      tagsPerPage: 10,
      plans: [],
      isExactSearch: false,
      selectedStatus: '',
      currentPlanPage: 1,
      plansPerPage: 6,
      loading: {
        problems: false,
        tags: false,
        categories: false
      },
      total: 0,
      categories: [],
      activeCategory: null,
      expandedCategories: {},
      selectedCategories: []
    }
  },
  computed: {
    totalPages () {
      return Math.ceil(this.filterProblems().length / this.itemsPerPage)
    },
    paginatedProblems () {
      const start = (this.currentPage - 1) * this.itemsPerPage
      return this.filterProblems().slice(start, start + this.itemsPerPage)
    },
    // 过滤后的标签列表
    filteredTags () {
      if (!this.categorySearchQuery) return this.tags
      const query = this.categorySearchQuery.toLowerCase()
      return this.tags.filter(tag =>
        tag.toLowerCase().includes(query)
      )
    },
    // 标签总页数
    totalTagPages () {
      return Math.ceil(this.filteredTags.length / this.tagsPerPage)
    },
    // 当前页的标签
    paginatedTags () {
      const start = (this.tagCurrentPage - 1) * this.tagsPerPage
      return this.filteredTags.slice(start, start + this.tagsPerPage)
    },
    totalPlanPages () {
      return Math.ceil(this.plans.length / this.plansPerPage)
    },
    paginatedPlans () {
      const start = (this.currentPlanPage - 1) * this.plansPerPage
      return this.plans.slice(start, start + this.plansPerPage)
    },
    // 过滤后的分类列表
    filteredCategories () {
      if (!this.categorySearchQuery) return this.categories

      const query = this.categorySearchQuery.toLowerCase()
      return this.categories.map(category => {
        // 检查父分类名称是否匹配
        const isParentMatch = category.name.toLowerCase().includes(query)

        // 过滤匹配的子分类
        const matchedChildren = category.children.filter(child =>
          child.name.toLowerCase().includes(query)
        )

        // 如果父分类匹配或有匹配的子分类，则返回过滤后的分类
        if (isParentMatch || matchedChildren.length > 0) {
          return {
            ...category,
            children: isParentMatch ? category.children : matchedChildren
          }
        }

        // 如果既不匹配父分类也没有匹配的子分类，则返回null
        return null
      }).filter(Boolean) // 过滤掉null值
    }
  },
  async created () {
    // 初始化时首先检查用户登录状态是否一致
    try {
      const userInfoStr = localStorage.getItem('userInfo')
      if (userInfoStr) {
        const userInfo = JSON.parse(userInfoStr)
        console.log('Problems页面初始化，当前用户:', userInfo.username)

        // 直接将用户名存入sessionStorage，不调用可能导致用户切换的全局函数
        sessionStorage.setItem('current_user', userInfo.username)
      }
    } catch (err) {
      console.error('Problems页面检查用户状态出错:', err)
    }

    // 确保初始化完成后再获取数据
    await this.$nextTick()
    await this.fetchPlans()
    await this.fetchCategories()
    this.fetchProblems()
    this.updateItemsPerPage()
    window.addEventListener('resize', this.updateItemsPerPage)
  },
  methods: {
    async fetchPlans () {
      try {
        console.log('开始获取学习计划...')
        const response = await request.get('/api/learning-plans')

        console.log('学习计划响应:', response)

        if (response && Array.isArray(response)) {
          this.plans = response.map(plan => ({
            id: plan.id,
            title: plan.title || '',
            description: plan.description || '',
            icon: plan.icon
              ? this.getCorrectIconPath(plan.icon)
              : '/icons/default.png',
            creator_name: plan.creator_name || ''
          }))
          console.log('处理后的学习计划:', this.plans)
        } else {
          console.log('学习计划数据格式不正确:', response)
          this.plans = []
        }
      } catch (error) {
        console.error('获取学习计划失败:', error)
        if (error.response?.status === 401) {
          this.$message.error('获取学习计划失败，请稍后重试')
        } else {
          this.$message.error('获取学习计划失败: ' + (error.message || '请检查网络连接或稍后重试'))
        }
        this.plans = []
      }
    },
    getCorrectIconPath (iconPath) {
      // 如果是完整URL路径，直接返回
      if (iconPath.startsWith('http')) {
        return iconPath
      }

      // 处理icons路径
      if (iconPath.includes('/icons/')) {
        // 确保路径不以多个斜杠开头
        return iconPath.startsWith('/') ? iconPath : `/${iconPath}`
      }

      // 处理public/icons路径
      if (iconPath.includes('public/icons/')) {
        const fileName = iconPath.split('/').pop()
        return `/icons/${fileName}`
      }

      // 添加调试日志
      console.log('处理学习路径图标，原始路径:', iconPath)

      // 默认返回原路径，确保以/开头
      return iconPath.startsWith('/') ? iconPath : `/${iconPath}`
    },
    async fetchCategories () {
      try {
        this.loading.categories = true
        const token = store.getters.getAccessToken

        // 使用新的API端点获取分类数据
        const response = await request.get('/api/problems/all-categories', {
          headers: {
            Authorization: `Bearer ${token}`
          }
        })

        console.log('获取到的分类数据:', response)

        if (response && (response.data || response.code === 200)) {
          // 处理分类数据
          const categories = response.data?.categories || response.data || []
          const parentCategories = []
          const childrenMap = {}

          // 按级别分组
          categories.forEach(category => {
            if (category.level === 1) {
              parentCategories.push({
                id: category.id,
                name: category.name,
                description: category.description || '',
                slug: category.slug || '',
                icon: category.icon || 'default',
                // 为每个一级分类设置不同的emoji
                iconType: 'emoji',
                emoji: this.getCategoryEmoji(category.slug || category.name),
                children: []
              })
            } else if (category.level === 2 && category.parent_id) {
              if (!childrenMap[category.parent_id]) {
                childrenMap[category.parent_id] = []
              }
              childrenMap[category.parent_id].push({
                id: category.id,
                name: category.name,
                description: category.description || '',
                parentId: category.parent_id,
                slug: category.slug || ''
              })
            }
          })

          // 将子分类添加到父分类中
          parentCategories.forEach(parent => {
            if (childrenMap[parent.id]) {
              parent.children = childrenMap[parent.id]
            }
          })

          this.categories = parentCategories
          console.log('处理后的分类数据:', this.categories)
        } else {
          // 如果API返回格式不对，使用备用数据
          console.error('API返回格式不正确，使用备用数据')
          this.useFallbackCategories()
        }
      } catch (error) {
        console.error('获取分类失败:', error)
        if (error.response?.status === 401) {
          await store.dispatch('logout')
          this.$router.push('/login')
          this.$message.error('登录已过期，请重新登录')
        } else {
          console.error('使用备用数据:', error.message)
          this.useFallbackCategories()
        }
      } finally {
        this.loading.categories = false
      }
    },
    // 根据分类名称或slug获取对应的emoji
    getCategoryEmoji (category) {
      // 分类emoji映射
      const emojiMap = {
        'data-structure': '📊',
        algorithm: '🧩',
        math: '🔢',
        basic: '💻',
        array: '📋',
        string: '🔤',
        tree: '🌳',
        'linked-list': '🔗',
        'hash-table': '🔍',
        'dynamic-programming': '📈',
        greedy: '🏎️',
        backtracking: '🔄',
        sorting: '📊',
        recursion: '🔁',
        queue: '📦',
        stack: '📚'
      }

      // 转换分类名为小写，作为key查找
      const key = category.toLowerCase().replace(/\s+/g, '-')

      // 返回找到的emoji或默认emoji
      return emojiMap[key] || '📘'
    },
    // 使用备用分类数据
    useFallbackCategories () {
      const fallbackCategories = [
        {
          id: 1,
          name: '数据结构',
          description: '与数据结构相关的算法题',
          slug: 'data-structure',
          icon: 'structure',
          iconType: 'emoji',
          emoji: '📊',
          children: [
            { id: 101, name: '数组', description: '数组相关的题目', parentId: 1, slug: 'array' },
            { id: 102, name: '链表', description: '链表相关的题目', parentId: 1, slug: 'linked-list' },
            { id: 103, name: '树', description: '树相关的题目', parentId: 1, slug: 'tree' },
            { id: 104, name: '栈', description: '栈相关的题目', parentId: 1, slug: 'stack' },
            { id: 105, name: '队列', description: '队列相关的题目', parentId: 1, slug: 'queue' },
            { id: 106, name: '哈希表', description: '哈希表相关的题目', parentId: 1, slug: 'hash-table' }
          ]
        },
        {
          id: 2,
          name: '算法技巧',
          description: '常见算法技巧与思想',
          slug: 'algorithm',
          icon: 'algorithm',
          iconType: 'emoji',
          emoji: '🧩',
          children: [
            { id: 201, name: '动态规划', description: '动态规划相关的题目', parentId: 2, slug: 'dynamic-programming' },
            { id: 202, name: '贪心算法', description: '贪心算法相关的题目', parentId: 2, slug: 'greedy' },
            { id: 203, name: '回溯算法', description: '回溯算法相关的题目', parentId: 2, slug: 'backtracking' },
            { id: 204, name: '分治算法', description: '分治算法相关的题目', parentId: 2, slug: 'divide-and-conquer' },
            { id: 205, name: '排序算法', description: '排序算法相关的题目', parentId: 2, slug: 'sorting' }
          ]
        },
        {
          id: 3,
          name: '数学',
          description: '数学相关的问题',
          slug: 'math',
          icon: 'calculator',
          iconType: 'emoji',
          emoji: '🔢',
          children: [
            { id: 301, name: '基础数学', description: '基础数学题目', parentId: 3, slug: 'basic-math' },
            { id: 302, name: '概率统计', description: '概率统计相关题目', parentId: 3, slug: 'probability' },
            { id: 303, name: '线性代数', description: '线性代数相关题目', parentId: 3, slug: 'linear-algebra' },
            { id: 304, name: '数论', description: '数论相关题目', parentId: 3, slug: 'number-theory' }
          ]
        },
        {
          id: 4,
          name: '基础编程',
          description: '基础编程能力考察',
          slug: 'basic',
          icon: 'code',
          iconType: 'emoji',
          emoji: '💻',
          children: [
            { id: 401, name: '字符串处理', description: '字符串处理相关题目', parentId: 4, slug: 'string' },
            { id: 402, name: '位运算', description: '位运算相关题目', parentId: 4, slug: 'bit-manipulation' },
            { id: 403, name: '模拟', description: '模拟实现相关题目', parentId: 4, slug: 'simulation' },
            { id: 404, name: '正则表达式', description: '正则表达式相关题目', parentId: 4, slug: 'regex' }
          ]
        }
      ]

      this.categories = fallbackCategories
      console.log('使用备用分类数据:', this.categories)
    },
    async fetchProblems () {
      try {
        this.loading.problems = true
        const token = store.getters.getAccessToken
        const params = {
          page: this.currentPage,
          limit: this.itemsPerPage,
          search: this.searchQuery,
          difficulty: this.selectedDifficulty,
          status: this.selectedStatus,
          tags: this.selectedTags
        }

        const response = await request.get('/api/problems', {
          params,
          headers: {
            Authorization: `Bearer ${token}`
          }
        })
        console.log('获取到的题目数据:', response)

        if (response && response.data) {
          this.problems = response.data.map(problem => ({
            id: problem.id,
            problem_number: problem.problem_number || '',
            title: problem.title || '',
            difficulty: problem.difficulty || '简单',
            tags: typeof problem.tags === 'string' ? problem.tags.split(',').map(tag => tag.trim()) : [],
            total_submissions: parseInt(problem.total_submissions) || 0,
            acceptance_rate: parseFloat(problem.acceptance_rate) || 0,
            status: problem.status || 'Not Started',
            description: problem.description || ''
          }))
          this.total = response.total || this.problems.length
          console.log('处理后的题目列表:', this.problems)

          // 获取用户题目完成状态
          await this.fetchUserProblemStatus()

          // 添加调试信息：检查题目状态
          console.log('获取完用户状态后的题目列表:', this.problems.filter(p => p.status === 'Accepted').map(p => ({
            id: p.id,
            title: p.title,
            status: p.status
          })))
        } else {
          throw new Error('获取题目列表失败')
        }
      } catch (error) {
        console.error('获取问题列表失败:', error)
        if (error.response?.status === 401) {
          await store.dispatch('logout')
          this.$router.push('/login')
          this.$message.error('登录已过期，请重新登录')
        } else {
          this.$message.error('获取问题列表失败: ' + (error.message || '请检查网络连接或稍后重试'))
          this.problems = []
          this.total = 0
        }
      } finally {
        this.loading.problems = false
      }
    },
    // 获取用户题目完成状态
    async fetchUserProblemStatus () {
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        const token = userInfo.token || store.getters.getAccessToken
        if (!token) {
          console.log('用户未登录，跳过获取题目状态')
          return
        }

        // 提取所有题目ID - 确保都是有效数字
        const problemIds = this.problems
          .map(p => p.id)
          .filter(id => !isNaN(id) && id !== null && id !== undefined)

        if (problemIds.length === 0) {
          console.log('没有有效的题目ID，跳过获取状态')
          return
        }

        console.log('获取题目状态，题目IDs:', problemIds)

        // 获取用户提交状态
        const headers = { Authorization: `Bearer ${token}` }
        try {
          // 注意这里使用明确的完整API路径，避免路由混淆
          console.log('请求API路径：/api/problems/user-status')
          const response = await request.get('/api/problems/user-status', {
            params: { problem_ids: problemIds.join(',') },
            headers
          })

          console.log('获取到的用户题目状态:', response)

          if (response && response.success && Array.isArray(response.data)) {
            // 创建题目ID到状态的映射
            const statusMap = {}
            response.data.forEach(item => {
              if (item && item.problem_id && item.status) {
                statusMap[item.problem_id] = item.status
              }
            })

            // 更新题目完成状态
            if (Object.keys(statusMap).length > 0) {
              this.problems = this.problems.map(problem => ({
                ...problem,
                status: statusMap[problem.id] || problem.status || 'Not Started'
              }))

              console.log('更新后的题目状态:', this.problems.filter(p => p.status === 'Accepted').map(p => ({
                id: p.id,
                title: p.title,
                status: p.status
              })))
            } else {
              console.log('没有获取到任何题目状态数据')
            }
          } else {
            console.log('API响应格式不正确或没有数据:', response)
          }
        } catch (apiError) {
          console.error('API请求失败:', apiError)
          // 尝试备选方案：直接获取用户所有题目状态
          try {
            console.log('尝试备选方案获取用户题目状态，请求路径: /api/user/problem-status')
            const acceptedResponse = await request.get('/api/user/problem-status', { headers })

            if (acceptedResponse && acceptedResponse.success && Array.isArray(acceptedResponse.data)) {
              const statusMap = {}
              acceptedResponse.data.forEach(item => {
                if (item && item.problem_id) {
                  statusMap[item.problem_id] = item.status
                }
              })

              if (Object.keys(statusMap).length > 0) {
                this.problems = this.problems.map(problem => ({
                  ...problem,
                  status: statusMap[problem.id] || problem.status || 'Not Started'
                }))

                console.log('备选方案更新后的题目状态:',
                  this.problems.filter(p => p.status === 'Accepted').length, '道已通过')
              }
            }
          } catch (fallbackError) {
            console.error('备选方案获取用户题目状态失败:', fallbackError)
          }
        }
      } catch (error) {
        console.error('获取用户题目状态失败:', error)
        // 错误时不更新题目状态，保持原状态
      }
    },
    filterProblems () {
      let filteredProblems = this.problems

      // 使用新的分类过滤逻辑
      if (this.selectedCategories.length > 0) {
        filteredProblems = filteredProblems.filter(problem => {
          // 修改为"与"操作，确保问题包含所有已选分类
          return this.selectedCategories.every(categoryId => {
            // 在这里需要根据问题的标签和分类ID进行匹配
            const category = this.categories.flatMap(c => c.children).find(c => c.id === categoryId)
            return category && problem.tags.includes(category.name)
          })
        })
      } else if (this.selectedTags.length > 0) {
        // 保留原有的标签过滤逻辑作为备用
        filteredProblems = filteredProblems.filter(problem => {
          return this.selectedTags.every(tag => problem.tags.includes(tag))
        })
      }

      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase()

        if (/^\d+$/.test(query) && this.isExactSearch) {
          filteredProblems = filteredProblems.filter(problem =>
            problem.id.toString() === query
          )
        } else {
          filteredProblems = filteredProblems.filter(problem => {
            return (
              problem.id.toString().includes(query) ||
              problem.title.toLowerCase().includes(query)
            )
          })
        }
      }

      if (this.selectedDifficulty) {
        filteredProblems = filteredProblems.filter(problem =>
          problem.difficulty === this.selectedDifficulty
        )
      }

      if (this.selectedStatus) {
        // 状态筛选
        console.log('筛选状态:', this.selectedStatus)
        console.log('筛选前题目数:', filteredProblems.length)

        filteredProblems = filteredProblems.filter(problem => {
          const result = problem.status === this.selectedStatus
          return result
        })

        console.log('筛选后题目数:', filteredProblems.length)
      }

      return filteredProblems
    },
    selectTag (tag) {
      if (this.selectedTags.includes(tag)) {
        this.selectedTags = this.selectedTags.filter(t => t !== tag)
      } else {
        this.selectedTags.push(tag)
      }
      this.currentPage = 1
    },
    resetFilters () {
      this.selectedTags = []
      this.selectedCategories = []
      this.selectedDifficulty = ''
      this.searchQuery = ''
      this.currentPage = 1
      this.expandedCategories = {}
      this.activeCategory = null
    },
    nextPage () {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
      }
    },
    prevPage () {
      if (this.currentPage > 1) {
        this.currentPage--
      }
    },
    updateItemsPerPage () {
      const width = window.innerWidth
      if (width < 2000) {
        this.itemsPerPage = 10
      } else if (width < 3000) {
        this.itemsPerPage = 15
      } else {
        this.itemsPerPage = 20
      }
      this.currentPage = 1
    },
    // 标签分页方法
    prevTagPage () {
      if (this.tagCurrentPage > 1) {
        this.tagCurrentPage--
      }
    },
    nextTagPage () {
      if (this.tagCurrentPage < this.totalTagPages) {
        this.tagCurrentPage++
      }
    },
    toggleExactSearch () {
      this.isExactSearch = !this.isExactSearch
      this.currentPage = 1
    },
    nextPlanPage () {
      if (this.currentPlanPage < this.totalPlanPages) {
        this.currentPlanPage++
      }
    },
    prevPlanPage () {
      if (this.currentPlanPage > 1) {
        this.currentPlanPage--
      }
    },
    toggleCategory (categoryId) {
      // 使用Vue的响应式对象更新方式
      const newExpandedCategories = { ...this.expandedCategories }
      newExpandedCategories[categoryId] = !newExpandedCategories[categoryId]
      this.expandedCategories = newExpandedCategories

      // 如果展开了分类，则设置为活跃分类
      if (this.expandedCategories[categoryId]) {
        this.activeCategory = categoryId
      } else if (this.activeCategory === categoryId) {
        this.activeCategory = null
      }
    },
    selectSubCategory (categoryId) {
      const index = this.selectedCategories.indexOf(categoryId)
      if (index > -1) {
        // 如果已选中，则移除
        this.selectedCategories.splice(index, 1)
      } else {
        // 否则添加
        this.selectedCategories.push(categoryId)
      }
      // 重置到第一页
      this.currentPage = 1
    },
    getCategoryIcon (category) {
      // 图标映射表
      const iconMap = {
        structure: '/imgs/categories/data-structure.png',
        algorithm: '/imgs/categories/algorithm.png',
        calculator: '/imgs/categories/math.png',
        code: '/imgs/categories/code.png',
        default: '/imgs/categories/default.png'
      }

      if (category.icon) {
        // 如果是完整URL路径，直接使用
        if (category.icon.startsWith('http')) {
          return category.icon
        }

        // 如果是已知图标，使用映射
        if (iconMap[category.icon]) {
          return iconMap[category.icon]
        }

        // 尝试从/icons/路径获取
        return `/icons/${category.icon}.svg`
      }

      // 默认图标
      return '/imgs/categories/default.png'
    },
    // 处理图标加载错误
    handleIconError (category) {
      console.log('图标加载失败:', category.name)
      // 设置为使用emoji类型
      category.iconType = 'emoji'
      category.emoji = '📚' // 默认使用书籍emoji
    },
    async handlePageChange (page) {
      // ... existing code ...
    }
  },
  beforeUnmount () {
    window.removeEventListener('resize', this.updateItemsPerPage)
  },
  watch: {
    // 监听搜索条件变化
    searchQuery (newVal) {
      if (!/^\d+$/.test(newVal.trim())) {
        this.isExactSearch = false
      }
      this.currentPage = 1
    },
    // 监听难度选择变化
    selectedDifficulty () {
      this.currentPage = 1
    },
    // 监听标签选择变化
    selectedTags: {
      handler () {
        this.currentPage = 1
      },
      deep: true
    },
    // 监听分类搜索，重置展开状态
    categorySearchQuery () {
      // 将分类搜索同步到标签搜索以保持兼容性
      this.tagSearchQuery = this.categorySearchQuery
      this.tagCurrentPage = 1

      // 如果有搜索词，自动展开所有分类
      if (this.categorySearchQuery) {
        const newExpandedCategories = {}
        this.filteredCategories.forEach(category => {
          newExpandedCategories[category.id] = true
        })
        this.expandedCategories = newExpandedCategories
      } else {
        // 如果清空搜索词，折叠所有分类
        this.expandedCategories = {}
        this.activeCategory = null
      }
    },
    // 反向同步标签搜索和分类搜索
    tagSearchQuery () {
      if (this.categorySearchQuery !== this.tagSearchQuery) {
        this.categorySearchQuery = this.tagSearchQuery
      }
    },
    selectedStatus () {
      this.currentPage = 1
    }
  }
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
.category-search {
  margin-bottom: 16px;
}

.category-search-input {
  width: 100%;
  padding: 8px 12px;
  background-color: #2d2d3f;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  font-size: 14px;
  transition: all 0.3s ease;
}

.category-search-input:focus {
  outline: none;
  border-color: #4ecdc4;
  box-shadow: 0 0 0 2px rgba(78, 205, 196, 0.2);
}

.category-search-input::placeholder {
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
    user-select: none;
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
  padding: 3px 8px;
  border-radius: 4px;
  margin-left: 8px;
  display: inline-block;
  font-weight: 500;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
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
  cursor: default;
  transition: all 0.3s ease;
  font-size: 15px;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: space-between;
  user-select: none !important;
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

/* 新增分类卡片样式 */
.category-cards {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 20px;
}

.parent-category-card {
  background-color: #1e1e2e;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
  user-select: none !important;
}

.parent-category-card:hover {
  transform: translateY(-2px);
  border-color: #4ecdc4;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.parent-category-card.active {
  border-color: #4ecdc4;
  background-color: #252536;
}

.category-header {
  display: flex;
  align-items: center;
  padding: 16px;
  gap: 12px;
}

.category-icon {
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.category-icon.emoji {
  font-size: 20px;
  background-color: rgba(78, 205, 196, 0.1);
  border-radius: 50%;
  width: 32px;
  height: 32px;
}

.category-icon img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.category-title {
  flex: 1;
  font-size: 16px;
  font-weight: 500;
  color: #fff;
  user-select: none;
}

.category-arrow {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #a6accd;
  transition: transform 0.3s ease;
}

.category-arrow.expanded {
  transform: rotate(180deg);
  color: #4ecdc4;
}

.sub-categories {
  background-color: #252536;
  padding: 0;
  max-height: 0;
  overflow: hidden;
  transition: all 0.3s ease;
}

.sub-categories.expanded {
  padding: 8px 16px 16px;
  max-height: 500px; /* 调整为合适的高度 */
}

.sub-category-card {
  padding: 12px 16px;
  margin: 8px 0;
  background-color: #2d2d3f;
  border-radius: 8px;
  color: #a6accd;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  justify-content: space-between;
  align-items: center;
  user-select: none;
}

.sub-category-card:hover {
  background-color: rgba(78, 205, 196, 0.1);
  color: #fff;
  transform: translateX(5px);
}

.sub-category-card.active {
  background-color: #4ecdc4;
  color: white;
}

.check-icon {
  font-weight: bold;
}

/* 加载状态样式 */
.category-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 0;
  gap: 16px;
  color: #a6accd;
}

.loading-spinner {
  width: 32px;
  height: 32px;
  border: 3px solid rgba(78, 205, 196, 0.2);
  border-top-color: #4ecdc4;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* 响应式调整 */
@media (max-width: 1200px) {
  .sub-categories.expanded {
    max-height: 300px;
  }

  .sub-category-card {
    padding: 10px 12px;
    margin: 6px 0;
  }
}

@media (max-width: 768px) {
  .parent-category-card {
    margin-bottom: 10px;
  }

  .category-header {
    padding: 12px;
  }

  .sub-categories.expanded {
    padding: 6px 12px 12px;
  }
}

.code-keyword {
  color: #ff79c6;
}

.code-string {
  color: #f1fa8c;
}

.code-function {
  color: #50fa7b;
}

.code-number {
  color: #bd93f9;
}

.code-comment {
  color: #6272a4;
}
</style>
