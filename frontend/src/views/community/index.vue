<template>
  <div class="page-container">
    <NavBar />
    <!-- 根据状态码控制显示内容 -->
    <template v-if="pageStatus === 1">
      <!-- 顶部公告区域 -->
      <div class="announcement-section" v-if="communityAnnouncements.length > 0">
        <el-carousel height="150px" indicator-position="outside">
          <el-carousel-item v-for="item in communityAnnouncements" :key="item.id">
            <div class="announcement-card">
              <h3>{{ item.community_name }}</h3>
              <p>{{ item.announcement }}</p>
              <span class="announcement-time">{{ formatDate(item.announcement_updated_at) }}</span>
            </div>
          </el-carousel-item>
        </el-carousel>
      </div>

      <div class="main-content">
        <!-- 左侧社区导航 -->
        <div class="left-section">
          <div class="search-box">
            <input 
              type="text" 
              v-model="searchQuery" 
              placeholder="搜索社区..." 
              @input="handleSearch"
            >
            <i class="search-icon"></i>
          </div>
          <div class="community-types">
            <div
              v-for="type in communityTypes"
              :key="type.value"
              :class="['type-item', { active: currentType === type.value }]"
              @click="selectType(type.value)"
            >
              <i :class="type.icon"></i>
              <span>{{ type.label }}</span>
            </div>
          </div>
        </div>

        <!-- 右侧功能区 -->
        <div class="right-section">
          <!-- 创建社区按钮 -->
          <el-button
            type="primary"
            class="create-btn"
            @click="goToCreateCommunity"
          >
            <i class="el-icon-plus"></i>
            创建新社区
          </el-button>

          <!-- 我的社区 -->
          <div class="my-communities">
            <div class="section-header">
              <h3>我的社区</h3>
            </div>
            <div class="community-list">
              <div
                v-for="community in paginatedCommunities"
                :key="community.id"
                class="community-item"
                @click="enterCommunity(community.id)"
              >
                <div class="community-avatar">
                  <img :src="community.cover_image || defaultCover" :alt="community.name">
                </div>
                <div class="community-info">
                  <h4>{{ community.name }}</h4>
                  <p>{{ community.description }}</p>
                </div>
              </div>
            </div>
            <!-- 分页控件 -->
            <div class="pagination-container" v-if="totalPages > 1">
              <div class="pagination">
                <button 
                  class="page-btn" 
                  :disabled="currentPage === 1"
                  @click="changePage(currentPage - 1)"
                  aria-label="上一页"
                >
                </button>
                <span class="page-info">{{ currentPage }} / {{ totalPages }}</span>
                <button 
                  class="page-btn" 
                  :disabled="currentPage === totalPages"
                  @click="changePage(currentPage + 1)"
                  aria-label="下一页"
                >
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
    
    <!-- 开发中提示 -->
    <template v-else>
      <div class="development-notice">
        <div class="notice-content">
          <i class="fas fa-users notice-icon"></i>
          <h2>功能开发中</h2>
          <p>社区论坛功能正在开发中，敬请期待...</p>
          <router-link to="/home" class="back-home-btn">
            <i class="fas fa-home"></i>
            返回主页
          </router-link>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import axios from 'axios'
import { formatDate } from '@/utils/date'
import { ElMessage } from 'element-plus'
import NavBar from '@/components/NavBar.vue'

export default {
  name: 'CommunityIndex',
  components: {
    NavBar
  },
  data() {
    return {
      pageStatus: 0, // 默认为0，表示开发中状态
      searchQuery: '',
      currentPage: 1,
      pageSize: 6,
      currentType: 'all',
      communityTypes: [
        { label: '全部社区', value: 'all', icon: 'el-icon-s-home' },
        { label: '官方社区', value: 'official', icon: 'el-icon-s-flag' },
        { label: '班级社区', value: 'class', icon: 'el-icon-s-custom' },
        { label: '学院社区', value: 'college', icon: 'el-icon-school' }
      ],
      communityAnnouncements: [],
      myCommunities: [],
      filteredCommunities: [],
      defaultCover: '/default-community-icon.svg'
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.filteredCommunities.length / this.pageSize)
    },
    paginatedCommunities() {
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return this.filteredCommunities.slice(start, end)
    }
  },
  methods: {
    formatDate,
    async fetchAnnouncements() {
      try {
        const response = await axios.get('http://localhost:3000/api/communities/announcements')
        this.communityAnnouncements = response.data
      } catch (error) {
        console.error('获取公告失败:', error)
        ElMessage.error('获取公告失败')
      }
    },
    async fetchMyCommunities() {
      try {
        const response = await axios.get('http://localhost:3000/api/communities/my')
        this.myCommunities = response.data
        this.filteredCommunities = this.myCommunities
      } catch (error) {
        console.error('获取我的社区失败:', error)
        ElMessage.error('获取我的社区失败')
      }
    },
    handleSearch() {
      if (!this.searchQuery) {
        this.filterCommunities()
        return
      }
      
      const query = this.searchQuery.toLowerCase()
      this.filteredCommunities = this.myCommunities.filter(community => {
        return community.name.toLowerCase().includes(query) ||
               community.description.toLowerCase().includes(query)
      })
    },
    selectType(type) {
      this.currentType = type
      this.filterCommunities()
    },
    filterCommunities() {
      if (this.currentType === 'all') {
        this.filteredCommunities = this.myCommunities
      } else {
        this.filteredCommunities = this.myCommunities.filter(
          community => community.type === this.currentType
        )
      }
      
      // 如果有搜索关键词，继续过滤
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase()
        this.filteredCommunities = this.filteredCommunities.filter(community => {
          return community.name.toLowerCase().includes(query) ||
                 community.description.toLowerCase().includes(query)
        })
      }
    },
    goToCreateCommunity() {
      this.$router.push('/community/create')
    },
    goToMyCommunities() {
      this.$router.push('/community/my-communities')
    },
    enterCommunity(id) {
      this.$router.push(`/community/detail/${id}`)
    },
    changePage(page) {
      this.currentPage = page
    }
  },
  created() {
    // 只有在页面状态为1时才加载数据
    if (this.pageStatus === 1) {
      this.fetchAnnouncements()
      this.fetchMyCommunities()
    }
  }
}
</script>

<style scoped>
.page-container {
  padding: 0;
  background: #0d1117;
  min-height: 100vh;
}

.announcement-section {
  margin: 40px;
  margin-bottom: 0;
}

.announcement-card {
  background: #1e1e2e;
  padding: 20px;
  border-radius: 12px;
  height: 100%;
  transition: all 0.3s ease;
  cursor: pointer;
}

.announcement-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.announcement-card h3 {
  color: #4ecdc4;
  margin-bottom: 10px;
}

.announcement-card p {
  color: #a6accd;
  margin-bottom: 15px;
}

.announcement-time {
  color: #6c7983;
  font-size: 0.9em;
}

.main-content {
  display: flex;
  gap: 30px;
  padding: 40px;
  padding-top: 20px;
}

.left-section {
  flex: 1;
  max-width: 300px;
}

.search-box {
  position: relative;
  margin-bottom: 20px;
}

.search-box input {
  width: 100%;
  background-color: #2d2d3f;
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 8px;
  font-size: 14px;
  transition: background-color 0.3s ease;
}

.search-box input:hover {
  background-color: #3d3d4f;
}

.search-box input:focus {
  background-color: #3d3d4f;
  outline: none;
  box-shadow: 0 0 0 2px rgba(78, 205, 196, 0.2);
}

.search-box .search-icon {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 20px;
  height: 20px;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='rgba(255, 255, 255, 0.6)'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z'%3E%3C/path%3E%3C/svg%3E");
  background-size: contain;
  background-repeat: no-repeat;
  opacity: 0.6;
  transition: opacity 0.3s ease;
}

.search-box input:focus + .search-icon {
  opacity: 1;
}

.community-types {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 15px;
}

.type-item {
  display: flex;
  align-items: center;
  padding: 12px;
  cursor: pointer;
  color: #a6accd;
  transition: all 0.3s ease;
  border-radius: 8px;
  margin-bottom: 8px;
}

.type-item:hover {
  background: #2d2d3f;
  color: #4ecdc4;
}

.type-item.active {
  background: #2d2d3f;
  color: #4ecdc4;
}

.type-item i {
  margin-right: 10px;
  font-size: 1.2em;
}

.right-section {
  flex: 2;
}

.create-btn {
  width: 100%;
  margin-bottom: 20px;
  background: #4ecdc4;
  border: none;
  height: 50px;
  font-size: 1.1em;
  transition: all 0.3s ease;
}

.create-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(78, 205, 196, 0.2);
  background: #45b6af;
}

.my-communities {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 20px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-header h3 {
  color: #4ecdc4;
  margin: 0;
}

.community-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.community-avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  overflow: hidden;
  background-color: #2d2d3f;
  flex-shrink: 0;
  transition: transform 0.3s ease;
  border: 2px solid rgba(78, 205, 196, 0.1);
}

.community-avatar:hover {
  transform: scale(1.05);
  border-color: rgba(78, 205, 196, 0.3);
}

.community-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.community-avatar img:hover {
  transform: scale(1.1);
}

.community-item {
  display: flex;
  gap: 20px;
  padding: 20px;
  background-color: #1e1e2e;
  border-radius: 12px;
  transition: all 0.3s ease;
  border: 1px solid rgba(78, 205, 196, 0.1);
  cursor: pointer;
}

.community-item:hover {
  transform: translateY(-2px);
  border-color: rgba(78, 205, 196, 0.3);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}

.community-info {
  padding: 15px;
}

.community-info h4 {
  color: #fff;
  margin: 0 0 8px 0;
}

.community-info p {
  color: #a6accd;
  font-size: 0.9em;
  margin: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
}

.pagination-container {
  margin-top: 30px;
  display: flex;
  justify-content: center;
}

.pagination {
  display: flex;
  align-items: center;
  gap: 16px;
  background-color: #2d2d3f;
  padding: 12px 24px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(78, 205, 196, 0.1);
}

.page-btn {
  background-color: #1e1e2e;
  border: 1px solid rgba(78, 205, 196, 0.2);
  color: #4ecdc4;
  cursor: pointer;
  padding: 8px 16px;
  border-radius: 8px;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  min-width: 48px;
  height: 48px;
  position: relative;
}

.page-btn::before {
  content: '';
  width: 12px;
  height: 12px;
  border-style: solid;
  border-width: 2px 2px 0 0;
  border-color: currentColor;
  position: absolute;
  top: 50%;
  left: 50%;
  transition: all 0.3s ease;
}

.page-btn:first-child::before {
  transform: translate(-40%, -50%) rotate(-135deg);
}

.page-btn:last-child::before {
  transform: translate(-60%, -50%) rotate(45deg);
}

.page-btn:hover:not(:disabled) {
  background-color: #4ecdc4;
  color: #1e1e2e;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(78, 205, 196, 0.2);
}

.page-btn:disabled {
  background-color: #1e1e2e;
  color: #6c7983;
  cursor: not-allowed;
  opacity: 0.5;
}

.page-btn:disabled::before {
  border-color: #6c7983;
}

.page-info {
  color: #e0e0e0;
  font-size: 16px;
  min-width: 80px;
  text-align: center;
  font-weight: 500;
  background-color: #1e1e2e;
  padding: 8px 16px;
  border-radius: 8px;
  border: 1px solid rgba(78, 205, 196, 0.1);
}

/* 开发中提示样式 */
.development-notice {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 70px); /* 减去导航栏高度 */
  padding: 20px;
}

.notice-content {
  background: #1e1e2e;
  padding: 2.5rem;
  border-radius: 1rem;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  max-width: 90%;
  width: 400px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.notice-icon {
  font-size: 3.5rem;
  color: #4ecdc4;
  margin-bottom: 1.5rem;
  filter: drop-shadow(0 0 10px rgba(78, 205, 196, 0.3));
}

.notice-content h2 {
  color: #e6edf3;
  margin-bottom: 1rem;
  font-size: 1.75rem;
  font-weight: 600;
}

.notice-content p {
  color: #a6accd;
  margin-bottom: 2rem;
  font-size: 1.1rem;
  line-height: 1.5;
}

.back-home-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  background: linear-gradient(135deg, #4ecdc4, #45b6af);
  color: white;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.3s ease;
  border: none;
  font-size: 1rem;
}

.back-home-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(78, 205, 196, 0.3);
  background: linear-gradient(135deg, #45b6af, #3ca49d);
}

.back-home-btn i {
  font-size: 1.1rem;
}
</style>
