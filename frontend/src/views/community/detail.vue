<template>
  <div class="detail-page">
    <div class="header">
      <div class="back-btn" @click="goBack">
        <i class="el-icon-arrow-left"></i>
        返回
      </div>
    </div>

    <div class="community-header">
      <img :src="communityData.cover_image" alt="社区图标" class="community-icon">
      <div class="community-info">
        <h1>
          {{ communityData.name }}
          <span class="community-type">
            {{ 
              communityData.type === 'official' ? '官方社区' : 
              communityData.type === 'college' ? '学院社区' :
              '班级社区' 
            }}
          </span>
        </h1>
        <p class="description">{{ communityData.description }}</p>
      </div>
      <div class="join-btn" @click="handleJoin" v-if="!isJoined">
        <i class="el-icon-plus"></i>
        加入社区
      </div>
      <div class="joined-btn" @click="handleLeave" v-else>
        <i class="el-icon-check"></i>
        已加入
      </div>
    </div>

    <div class="main-content">
      <div class="posts-section">
        <div class="create-post-btn" @click="createPost" v-if="isJoined">
          <i class="el-icon-edit"></i>
          发布帖子
        </div>

        <!-- 热门帖子 -->
        <h2 class="section-title">
          <i class="el-icon-star-on"></i>
          热门帖子
        </h2>
        <div class="featured-posts">
          <div v-for="post in featuredPosts" :key="post.id" class="post-item">
            <div class="post-title">{{ post.title }}</div>
            <div class="post-stats">
              <span><i class="el-icon-view"></i> {{ post.view_count }}</span>
              <span><i class="el-icon-star-on"></i> {{ post.like_count }}</span>
              <span><i class="el-icon-chat-dot-round"></i> {{ post.comment_count }}</span>
            </div>
          </div>
        </div>

        <!-- 全部帖子 -->
        <h2 class="section-title">
          <i class="el-icon-document"></i>
          全部帖子
        </h2>
        <div class="posts-grid">
          <div v-for="post in posts" :key="post.id" class="post-card">
            <div class="post-title">{{ post.title }}</div>
            <div class="post-meta">
              <span><i class="el-icon-view"></i> {{ post.view_count }}</span>
              <span><i class="el-icon-star-on"></i> {{ post.like_count }}</span>
              <span><i class="el-icon-chat-dot-round"></i> {{ post.comment_count }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 社区成员 -->
      <div class="members-section">
        <h2>社区成员 ({{ members?.length || 0 }})</h2>
        <div class="members-list">
          <div v-for="member in members" :key="member.id" class="member-item">
            <div class="member-avatar">
              {{ member.username.charAt(0).toUpperCase() }}
            </div>
            <div class="member-info">
              <div class="username">{{ member.username }}</div>
              <div class="role" :class="{
                'owner': member.role === 'owner',
                'admin': member.role === 'admin',
                'member': member.role === 'member'
              }">
                {{ member.role === 'owner' ? '所有者' : member.role === 'admin' ? '管理员' : '成员' }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { formatDate } from '@/utils/date'
import { ElMessage } from 'element-plus'

export default {
  name: 'CommunityDetail',
  data() {
    return {
      communityData: {},
      posts: [],
      featuredPosts: [],
      members: null,
      currentPage: 1,
      pageSize: 10,
      totalPosts: 0,
      totalMembers: 0,
      defaultCover: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><rect width="100" height="100" fill="%231e1e2e"/><text x="50" y="50" font-family="Arial" font-size="40" fill="%234ecdc4" text-anchor="middle" dy=".3em">C</text></svg>',
      defaultAvatar: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="50" fill="%231e1e2e"/><text x="50" y="50" font-family="Arial" font-size="40" fill="%234ecdc4" text-anchor="middle" dy=".3em">U</text></svg>',
      isJoined: false
    }
  },
  methods: {
    formatDate,
    async fetchCommunityData() {
      try {
        const { id } = this.$route.params
        const response = await axios.get(`http://localhost:3000/api/communities/${id}`)
        this.communityData = response.data
      } catch (error) {
        console.error('获取社区信息失败:', error)
        ElMessage.error('获取社区信息失败')
      }
    },
    async fetchPosts() {
      try {
        const { id } = this.$route.params
        const response = await axios.get(`http://localhost:3000/api/communities/${id}/posts`, {
          params: {
            page: this.currentPage,
            pageSize: this.pageSize
          }
        })
        this.posts = response.data.posts
        this.totalPosts = response.data.total
      } catch (error) {
        console.error('获取帖子失败:', error)
        ElMessage.error('获取帖子失败')
      }
    },
    async fetchFeaturedPosts() {
      try {
        const { id } = this.$route.params
        const response = await axios.get(`http://localhost:3000/api/communities/${id}/featured-posts`)
        this.featuredPosts = response.data
      } catch (error) {
        console.error('获取热门帖子失败:', error)
        ElMessage.error('获取热门帖子失败')
      }
    },
    async fetchMembers() {
      try {
        const { id } = this.$route.params
        const response = await axios.get(`http://localhost:3000/api/communities/${id}/members`)
        this.members = response.data.members
        this.totalMembers = response.data.total
      } catch (error) {
        console.error('获取成员列表失败:', error)
        ElMessage.error('获取成员列表失败')
      }
    },
    handlePageChange(page) {
      this.currentPage = page
      this.fetchPosts()
    },
    createPost() {
      this.$router.push(`/community/${this.$route.params.id}/create-post`)
    },
    goBack() {
      this.$router.go(-1)
    },
    async handleJoin() {
      try {
        const { id } = this.$route.params
        await axios.post(`http://localhost:3000/api/communities/${id}/join`)
        this.isJoined = true
        await this.fetchMembers() // 重新获取成员列表
        ElMessage.success('成功加入社区')
      } catch (error) {
        console.error('加入社区失败:', error)
        ElMessage.error('加入社区失败：' + (error.response?.data?.message || error.message))
      }
    },
    async handleLeave() {
      try {
        const { id } = this.$route.params
        await axios.post(`http://localhost:3000/api/communities/${id}/leave`)
        this.isJoined = false
        await this.fetchMembers() // 重新获取成员列表
        ElMessage.success('已退出社区')
      } catch (error) {
        console.error('退出社区失败:', error)
        ElMessage.error('退出社区失败：' + (error.response?.data?.message || error.message))
      }
    },
    async checkJoinStatus() {
      try {
        const { id } = this.$route.params
        const response = await axios.get(`http://localhost:3000/api/communities/${id}/join-status`)
        this.isJoined = response.data.isJoined
      } catch (error) {
        console.error('获取加入状态失败:', error)
      }
    }
  },
  created() {
    this.fetchCommunityData()
    this.fetchPosts()
    this.fetchFeaturedPosts()
    this.fetchMembers()
    this.checkJoinStatus()
  }
}
</script>

<style scoped>
.detail-page {
  min-height: 100vh;
  background: #0d1117;
  padding: 12px;
}

.header {
  margin-bottom: 16px;
  background-color: #1e1e2e;
  padding: 12px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.back-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  border-radius: 6px;
  background-color: #2d2d3f;
  color: #a6accd;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid #3d3d4f;
  
  &:hover {
    background-color: #3d3d4f;
    color: #4ecdc4;
    border-color: #4ecdc4;
  }

  i {
    font-size: 16px;
  }
}

.community-header {
  display: flex;
  align-items: center;
  gap: 16px;
  background: #1e1e2e;
  padding: 12px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  margin-bottom: 12px;
}

.community-icon {
  width: 80px;
  height: 80px;
  border-radius: 12px;
  object-fit: cover;
}

.community-info {
  flex: 1;
  
  h1 {
    color: #e0e0e0;
    margin: 0 0 8px 0;
    font-size: 24px;
    display: flex;
    align-items: center;
    gap: 12px;
  }

  .community-type {
    display: inline-block;
    padding: 4px 12px;
    border-radius: 4px;
    font-size: 14px;
    background: linear-gradient(135deg, #4ecdc4, #2d9cdb);
    color: #fff;
    margin-left: 8px;
  }
}

.description {
  color: #a6accd;
  margin: 0;
  font-size: 16px;
}

.main-content {
  display: flex;
  gap: 20px;
  max-width: 1400px;
  margin: 0 auto;
}

.posts-section {
  flex: 1;
}

.featured-posts {
  margin-top: 12px;
  padding: 12px;
  background-color: #2d2d3f;
  border-radius: 8px;
  border: 1px solid #3d3d4f;

  .post-item {
    padding: 8px;
    border-radius: 6px;
    margin-bottom: 8px;
    background-color: #252538;
    transition: all 0.3s ease;
    cursor: pointer;

    &:hover {
      transform: translateX(5px);
      background-color: #2d2d4f;
    }

    .post-title {
      color: #a6accd;
      font-size: 14px;
      margin-bottom: 8px;
    }

    .post-stats {
      display: flex;
      gap: 16px;
      color: #8b949e;
      font-size: 12px;
    }
  }
}

h2 {
  color: #4ecdc4;
  margin: 0 0 20px 0;
  font-size: 24px;
}

.posts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-top: 24px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.post-card {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 20px;
  transition: all 0.3s ease;
  border: 1px solid #2d2d3f;
  cursor: pointer;

  &:hover {
    transform: translateY(-2px);
    border-color: #4ecdc4;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  }

  .post-title {
    color: #e0e0e0;
    margin: 0 0 12px 0;
    font-size: 16px;
    line-height: 1.4;
  }

  .post-meta {
    display: flex;
    gap: 16px;
    color: #8b949e;
    font-size: 12px;

    span {
      display: flex;
      align-items: center;
      gap: 4px;
    }
  }
}

.section-title {
  color: #4ecdc4;
  font-size: 20px;
  margin: 8px 0 8px;
  display: flex;
  align-items: center;
  gap: 8px;

  i {
    font-size: 18px;
  }
}

.post-content {
  color: #a6accd;
  margin: 0 0 15px 0;
  font-size: 14px;
  line-height: 1.6;
}

.post-stats {
  display: flex;
  gap: 20px;
  color: #6c7983;
  font-size: 14px;
}

.post-stats span {
  display: flex;
  align-items: center;
  gap: 5px;
}

.members-section {
  width: 300px;
  background: #1e1e2e;
  border-radius: 16px;
  padding: 20px;
  height: fit-content;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);

  h2 {
    color: #4ecdc4;
    font-size: 20px;
    margin-bottom: 16px;
    padding-bottom: 12px;
    border-bottom: 1px solid rgba(78, 205, 196, 0.2);
  }
}

.members-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.member-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: #2d2d3f;
  border-radius: 8px;
  border: 1px solid #3d3d4f;
  transition: all 0.3s ease;

  &:hover {
    transform: translateX(4px);
    border-color: #4ecdc4;
    background: #363649;
  }

  .member-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: linear-gradient(135deg, #4ecdc4, #2d9cdb);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    font-size: 16px;
    font-weight: 500;
  }

  .member-info {
    flex: 1;

    .username {
      color: #e0e0e0;
      font-size: 14px;
      font-weight: 500;
      margin-bottom: 4px;
    }

    .role {
      font-size: 12px;
      padding: 2px 8px;
      border-radius: 4px;
      width: fit-content;

      &.owner {
        color: #ffd700;
        background: rgba(255, 215, 0, 0.1);
        border: 1px solid rgba(255, 215, 0, 0.2);
      }

      &.admin {
        color: #4ecdc4;
        background: rgba(78, 205, 196, 0.1);
        border: 1px solid rgba(78, 205, 196, 0.2);
      }

      &.member {
        color: #a6accd;
        background: rgba(166, 172, 205, 0.1);
        border: 1px solid rgba(166, 172, 205, 0.2);
      }
    }
  }
}

:deep(.el-pagination) {
  margin-top: 30px;
  text-align: center;
}

:deep(.el-pagination .btn-prev),
:deep(.el-pagination .btn-next) {
  background: #1e1e2e;
  color: #4ecdc4;
}

:deep(.el-pagination .el-pager li) {
  background: #1e1e2e;
  color: #e0e0e0;
}

:deep(.el-pagination .el-pager li.active) {
  background: #4ecdc4;
  color: #1e1e2e;
}

.join-btn, .joined-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 24px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 16px;
  margin-left: auto;
  font-weight: 500;
}

.join-btn {
  background-color: #4ecdc4;
  color: #1e1e2e;
  border: none;

  &:hover {
    background-color: #45b6af;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(78, 205, 196, 0.2);
  }

  i {
    font-size: 16px;
  }
}

.joined-btn {
  background-color: #2d2d3f;
  color: #4ecdc4;
  border: 1px solid #4ecdc4;
  cursor: pointer;

  &:hover {
    background-color: #ff6b6b;
    color: #fff;
    border-color: #ff6b6b;
  }

  i {
    font-size: 16px;
  }
}

.create-post-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 24px;
  border-radius: 8px;
  background-color: #4ecdc4;
  color: #1e1e2e;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 16px;
  font-weight: 500;
  margin-bottom: 20px;
  width: fit-content;

  &:hover {
    background-color: #45b6af;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(78, 205, 196, 0.2);
  }

  i {
    font-size: 16px;
  }
}
</style> 