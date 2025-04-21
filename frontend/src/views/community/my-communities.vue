<template>
  <div class="my-communities-container">
    <div class="header-section">
      <h2>我的社区</h2>
      <div class="search-box">
        <el-input
          v-model="searchQuery"
          placeholder="搜索我的社区..."
          prefix-icon="el-icon-search"
          @input="handleSearch"
        />
      </div>
    </div>

    <div class="communities-grid">
      <div
        v-for="community in filteredCommunities"
        :key="community.id"
        class="community-card"
        @click="enterCommunity(community.id)"
      >
        <div class="card-cover">
          <img :src="community.cover_image || defaultCover" :alt="community.name">
          <div class="community-type" :class="community.type">
            {{ getTypeLabel(community.type) }}
          </div>
        </div>
        <div class="card-content">
          <h3>{{ community.name }}</h3>
          <p class="description">{{ community.description }}</p>
          <div class="community-info">
            <span class="member-count">
              <i class="el-icon-user"></i>
              {{ community.member_count || 0 }} 成员
            </span>
            <span class="post-count">
              <i class="el-icon-document"></i>
              {{ community.post_count || 0 }} 帖子
            </span>
          </div>
          <div class="role-tag" :class="community.role">
            {{ getRoleLabel(community.role) }}
          </div>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-if="filteredCommunities.length === 0" class="empty-state">
      <i class="el-icon-house"></i>
      <p>还没有加入任何社区</p>
      <el-button type="primary" @click="goToExplore">去发现社区</el-button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { ElMessage } from 'element-plus'

export default {
  name: 'MyCommunities',
  data () {
    return {
      communities: [],
      searchQuery: '',
      defaultCover: 'https://via.placeholder.com/300x200/1e1e2e/4ecdc4?text=Community'
    }
  },
  computed: {
    filteredCommunities () {
      if (!this.searchQuery) return this.communities
      const query = this.searchQuery.toLowerCase()
      return this.communities.filter(community =>
        community.name.toLowerCase().includes(query) ||
        community.description.toLowerCase().includes(query)
      )
    }
  },
  methods: {
    async fetchMyCommunities () {
      try {
        const response = await axios.get('/api/communities/my')
        this.communities = response.data
      } catch (error) {
        console.error('获取社区列表失败:', error)
        ElMessage.error('获取社区列表失败')
      }
    },
    handleSearch () {
      // 搜索逻辑已通过计算属性实现
    },
    getTypeLabel (type) {
      const labels = {
        official: '官方',
        class: '班级',
        college: '学院'
      }
      return labels[type] || '其他'
    },
    getRoleLabel (role) {
      const labels = {
        owner: '创建者',
        admin: '管理员',
        member: '成员'
      }
      return labels[role] || '成员'
    },
    enterCommunity (id) {
      this.$router.push(`/community/detail/${id}`)
    },
    goToExplore () {
      this.$router.push('/community')
    }
  },
  created () {
    this.fetchMyCommunities()
  }
}
</script>

<style scoped>
.my-communities-container {
  min-height: 100vh;
  padding: 40px;
  background: #0d1117;
}

.header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 40px;
}

h2 {
  color: #4ecdc4;
  margin: 0;
}

.search-box {
  width: 300px;
}

.communities-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 30px;
}

.community-card {
  background: #1e1e2e;
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
}

.community-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.card-cover {
  position: relative;
  height: 160px;
}

.card-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.community-type {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 0.9em;
  color: #fff;
}

.community-type.official {
  background: #4ecdc4;
}

.community-type.class {
  background: #f1c40f;
}

.community-type.college {
  background: #e74c3c;
}

.card-content {
  padding: 20px;
}

h3 {
  color: #fff;
  margin: 0 0 10px 0;
  font-size: 1.2em;
}

.description {
  color: #a6accd;
  margin: 0 0 15px 0;
  font-size: 0.9em;
  line-height: 1.5;
  height: 40px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.community-info {
  display: flex;
  gap: 20px;
  color: #6c7983;
  font-size: 0.9em;
}

.member-count,
.post-count {
  display: flex;
  align-items: center;
  gap: 5px;
}

.role-tag {
  position: absolute;
  top: 12px;
  left: 12px;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 0.9em;
  color: #fff;
}

.role-tag.owner {
  background: #9b59b6;
}

.role-tag.admin {
  background: #3498db;
}

.role-tag.member {
  background: #7f8c8d;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
  color: #a6accd;
}

.empty-state i {
  font-size: 48px;
  color: #4ecdc4;
  margin-bottom: 20px;
}

.empty-state p {
  margin-bottom: 20px;
  font-size: 1.1em;
}

.empty-state .el-button {
  background: #4ecdc4;
  border: none;
  padding: 12px 30px;
  font-size: 1.1em;
}

.empty-state .el-button:hover {
  background: #45b6af;
  transform: translateY(-2px);
}
</style>
