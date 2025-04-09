<template>
  <div class="create-page">
    <nav-bar></nav-bar>
    <!-- 顶部卡片部分 -->
    <div class="content">
      <div class="top-card">
        <div class="card-content">
          <h2>创建新社区</h2>
          <p>在这里，你可以创建一个新的社区。填写以下信息来开始你的社区之旅。</p>
        </div>
        <div class="card-decoration">
          <div class="geometric-shape"></div>
        </div>
      </div>

      <div class="main-content">
        <!-- 左侧表单部分 -->
        <div class="form-section">
          <form @submit.prevent="handleSubmit" class="custom-form">
            <div class="form-group">
              <label>社区名称</label>
              <input 
                type="text" 
                v-model="formData.name" 
                placeholder="请输入社区名称"
                :class="{ 'error': errors.name }"
              >
              <span class="error-message" v-if="errors.name">{{ errors.name }}</span>
            </div>

            <div class="form-group">
              <label>社区类型</label>
              <div class="custom-select">
                <select v-model="formData.type">
                  <option value="" disabled selected>请选择社区类型</option>
                  <option value="official">官方社区</option>
                  <option value="class">班级社区</option>
                  <option value="college">学院社区</option>
                </select>
                <span class="select-arrow"></span>
              </div>
              <span class="error-message" v-if="errors.type">{{ errors.type }}</span>
            </div>

            <div class="form-group">
              <label>社区描述</label>
              <textarea 
                v-model="formData.description" 
                rows="4" 
                placeholder="请输入社区描述"
                :class="{ 'error': errors.description }"
              ></textarea>
              <span class="error-message" v-if="errors.description">{{ errors.description }}</span>
            </div>

            <div class="form-group">
              <label>社区图标 (URL)</label>
              <input 
                type="text" 
                v-model="formData.cover_image" 
                placeholder="请输入图标URL"
              >
              <div class="url-preview" v-if="formData.cover_image">
                <img :src="formData.cover_image" alt="预览" @error="handleImageError">
              </div>
            </div>

            <template v-if="formData.type === 'class' || formData.type === 'college'">
              <div class="form-group">
                <label>所属学校</label>
                <input 
                  type="text" 
                  v-model="formData.school" 
                  placeholder="请输入学校名称"
                  :class="{ 'error': errors.school }"
                >
                <span class="error-message" v-if="errors.school">{{ errors.school }}</span>
              </div>

              <div class="form-group" v-if="formData.type === 'college'">
                <label>所属学院</label>
                <input 
                  type="text" 
                  v-model="formData.college" 
                  placeholder="请输入学院名称"
                  :class="{ 'error': errors.college }"
                >
                <span class="error-message" v-if="errors.college">{{ errors.college }}</span>
              </div>

              <div class="form-group" v-if="formData.type === 'class'">
                <label>班级名称</label>
                <input 
                  type="text" 
                  v-model="formData.class_name" 
                  placeholder="请输入班级名称"
                  :class="{ 'error': errors.class_name }"
                >
                <span class="error-message" v-if="errors.class_name">{{ errors.class_name }}</span>
              </div>
            </template>

            <div class="form-group">
              <label>社区公告</label>
              <textarea 
                v-model="formData.announcement" 
                rows="4" 
                placeholder="请输入社区公告"
              ></textarea>
            </div>

            <div class="button-group">
              <button type="submit" class="submit-btn">创建社区</button>
              <div class="back-btn" @click="goBack">
                <i class="el-icon-arrow-left"></i>
                返回
              </div>
            </div>
          </form>
        </div>

        <!-- 右侧预览部分 -->
        <div class="preview-section">
          <div class="preview-card">
            <div class="preview-header">预览</div>
            <div class="community-card">
              <div class="community-icon">
                <img :src="formData.cover_image || defaultCover" alt="社区图标">
              </div>
              <div class="community-info">
                <h2>{{ formData.name || '社区名称' }}</h2>
                <p class="type-tag">{{ getTypeLabel(formData.type) }}</p>
                <p class="description">{{ formData.description || '社区描述' }}</p>
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
import { ElMessage } from 'element-plus'
import NavBar from '@/components/NavBar.vue'

export default {
  name: 'CommunityCreate',
  components: {
    NavBar
  },
  data() {
    return {
      formData: {
        name: '',
        type: '',
        description: '',
        cover_image: '',
        school: '',
        college: '',
        class_name: '',
        announcement: ''
      },
      defaultCover: '/default-community-icon.svg',
      errors: {}
    }
  },
  methods: {
    getTypeLabel(type) {
      const types = {
        official: '官方社区',
        class: '班级社区',
        college: '学院社区'
      }
      return types[type] || '未选择类型'
    },
    handleImageError() {
      // 如果图片加载失败，使用备用的base64编码的小图标
      this.formData.cover_image = 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM0ZWNkYzQiIHN0cm9rZS13aWR0aD0iMiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj48cGF0aCBkPSJNMyAxMmgxOE0zIDZoMThNMyAxOGgxOCIvPjwvc3ZnPg=='
    },
    async handleSubmit() {
      this.errors = {}
      
      // 表单验证
      if (!this.formData.name) {
        this.errors.name = '请输入社区名称'
      } else if (this.formData.name.length < 2 || this.formData.name.length > 50) {
        this.errors.name = '长度在 2 到 50 个字符'
      }
      
      if (!this.formData.type) {
        this.errors.type = '请选择社区类型'
      }
      
      if (!this.formData.description) {
        this.errors.description = '请输入社区描述'
      }
      
      if (this.formData.type === 'class' || this.formData.type === 'college') {
        if (!this.formData.school) {
          this.errors.school = '请输入学校名称'
        }
        
        if (this.formData.type === 'college' && !this.formData.college) {
          this.errors.college = '请输入学院名称'
        }
        
        if (this.formData.type === 'class' && !this.formData.class_name) {
          this.errors.class_name = '请输入班级名称'
        }
      }
      
      // 如果有错误，不提交表单
      if (Object.keys(this.errors).length > 0) {
        return
      }
      
      try {
        // 如果用户没有提供图标URL，使用默认图标
        const formDataToSubmit = {
          ...this.formData,
          cover_image: this.formData.cover_image || this.defaultCover
        }
        
        await axios.post('http://localhost:3000/api/communities', formDataToSubmit)
        ElMessage.success('社区创建成功')
        this.$router.push('/community')
      } catch (error) {
        console.error('创建社区失败:', error)
        ElMessage.error('创建社区失败：' + (error.response?.data?.message || error.message))
      }
    },
    goBack() {
      this.$router.go(-1)
    }
  }
}
</script>

<style scoped>
.create-page {
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
  gap: 40px;
}

/* 顶部卡片样式 */
.top-card {
  background-color: #1e1e2e;
  border-radius: 16px;
  padding: 32px;
  display: flex;
  justify-content: space-between;
  position: relative;
  overflow: hidden;
  transition: transform 0.3s ease;
}

.top-card:hover {
  transform: translateY(-4px);
}

.card-content {
  flex: 2;
  z-index: 1;
}

.card-content h2 {
  font-size: 32px;
  margin-bottom: 16px;
  background: linear-gradient(90deg, #fff, #f0f0f0);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.card-content p {
  font-size: 16px;
  color: #a6accd;
  margin-bottom: 24px;
  max-width: 600px;
}

.card-decoration {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}

.geometric-shape {
  width: 150px;
  height: 150px;
  background: linear-gradient(45deg, #4ecdc4, #45b6af);
  clip-path: polygon(50% 0%, 100% 50%, 50% 100%, 0% 50%);
  transition: transform 0.5s ease;
  opacity: 0.8;
}

.top-card:hover .geometric-shape {
  transform: rotate(45deg) scale(1.2);
  opacity: 1;
}

/* 主要内容区域样式 */
.main-content {
  display: flex;
  gap: 40px;
}

.form-section {
  flex: 3;
  background-color: #1e1e2e;
  border-radius: 16px;
  padding: 32px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}

.preview-section {
  flex: 2;
  max-width: 400px;
}

.preview-card {
  background-color: #1e1e2e;
  border-radius: 16px;
  padding: 24px;
  position: sticky;
  top: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}

.preview-header {
  color: #4ecdc4;
  font-size: 18px;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid rgba(78, 205, 196, 0.2);
}

.community-card {
  background-color: #2d2d3f;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  gap: 20px;
}

.community-icon {
  width: 80px;
  height: 80px;
  border-radius: 12px;
  overflow: hidden;
}

.community-icon img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.community-info h2 {
  color: #e0e0e0;
  margin: 0 0 10px 0;
  font-size: 20px;
}

.type-tag {
  display: inline-block;
  background-color: rgba(78, 205, 196, 0.1);
  color: #4ecdc4;
  padding: 4px 12px;
  border-radius: 6px;
  font-size: 14px;
  margin-bottom: 10px;
}

.description {
  color: #a6accd;
  font-size: 14px;
  margin: 0;
}

/* 表单控件样式 */
.custom-form {
  width: 100%;
}

.form-group {
  margin-bottom: 24px;
}

.form-group label {
  display: block;
  color: #4ecdc4;
  font-size: 14px;
  margin-bottom: 8px;
  font-weight: 500;
}

.form-group input,
.form-group textarea,
.custom-select select {
  width: 100%;
  background-color: #2d2d3f;
  border: 1px solid #363649;
  color: #e0e0e0;
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s ease;
  outline: none;
}

.form-group input:hover,
.form-group textarea:hover,
.custom-select select:hover {
  background-color: #363649;
  border-color: #4ecdc4;
}

.form-group input:focus,
.form-group textarea:focus,
.custom-select select:focus {
  background-color: #363649;
  border-color: #4ecdc4;
  box-shadow: 0 0 0 2px rgba(78, 205, 196, 0.2);
}

.form-group textarea {
  resize: vertical;
  min-height: 120px;
}

.custom-select {
  position: relative;
}

.custom-select select {
  appearance: none;
  padding-right: 40px;
  cursor: pointer;
}

.select-arrow {
  position: absolute;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  width: 0;
  height: 0;
  border-left: 6px solid transparent;
  border-right: 6px solid transparent;
  border-top: 6px solid #4ecdc4;
  pointer-events: none;
}

.error-message {
  color: #ff6b6b;
  font-size: 12px;
  margin-top: 4px;
  display: block;
}

.form-group input.error,
.form-group textarea.error {
  border-color: #ff6b6b;
}

.form-group input.error:focus,
.form-group textarea.error:focus {
  box-shadow: 0 0 0 2px rgba(255, 107, 107, 0.2);
}

.button-group {
  margin-top: 20px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  align-items: flex-end;
}

.submit-btn {
  width: 100%;
  height: 45px;
  background-color: #4ecdc4;
  border: none;
  color: #1e1e2e;
  font-size: 16px;
  font-weight: 500;
  border-radius: 8px;
  transition: all 0.3s ease;
  margin-bottom: 4px;
}

.submit-btn:hover {
  background-color: #45b6af;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(78, 205, 196, 0.2);
}

.back-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px 12px;
  border-radius: 6px;
  background-color: #2d2d3f;
  color: #a6accd;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid #3d3d4f;
  width: fit-content;
  font-size: 14px;

  &:hover {
    background-color: #3d3d4f;
    color: #4ecdc4;
    border-color: #4ecdc4;
  }

  i {
    font-size: 14px;
  }
}

.url-preview {
  margin-top: 10px;
  width: 100px;
  height: 100px;
  border-radius: 8px;
  overflow: hidden;
  background-color: #2d2d3f;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .main-content {
    flex-direction: column;
  }
  
  .preview-section {
    max-width: none;
  }
  
  .preview-card {
    position: static;
  }
}

@media (max-width: 768px) {
  .content {
    padding: 20px;
  }
  
  .top-card {
    padding: 24px;
  }
  
  .card-content h2 {
    font-size: 24px;
  }
  
  .geometric-shape {
    display: none;
  }
}
</style> 