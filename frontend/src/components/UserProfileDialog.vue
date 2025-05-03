<template>
  <Dialog
    :visible="visible"
    :header="'个人资料'"
    :modal="true"
    :style="{ width: '80vw', maxWidth: '1200px' }"
    :closable="true"
    :closeOnEscape="true"
    :dismissableMask="true"
    @update:visible="$emit('update:visible', $event)"
  >
    <div class="profile-dialog-content">
      <Toast />
      <!-- 头像部分 -->
      <div class="avatar-section">
        <div class="avatar-wrapper">
          <img :src="userData.avatarUrl" alt="用户头像" class="avatar-image">
          <div class="avatar-overlay" @click="handleAvatarClick" v-if="isCurrentUser">
            <i class="pi pi-camera"></i>
          </div>
        </div>
      </div>

      <!-- 用户信息部分 -->
      <div class="profile-info">
        <!-- 基本信息 -->
        <div class="info-section">
          <h3 class="section-title">基本信息</h3>
          <!-- 用户ID -->
          <div class="field">
            <label>用户ID</label>
            <InputText v-model="userData.userId" disabled class="w-full" />
          </div>

          <!-- 用户名 -->
          <div class="field">
            <label>显示名称</label>
            <div class="p-inputgroup">
              <InputText
                v-model="userData.displayName"
                :disabled="!isCurrentUser || loading.displayName"
                class="w-full"
                placeholder="设置显示名称"
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
                :loading="loading.displayName"
                @click="handleSave('displayName')"
              />
            </div>
          </div>

          <!-- 邮箱 -->
          <div class="field">
            <label>邮箱</label>
            <div class="p-inputgroup">
              <InputText
                v-model="userData.email"
                :disabled="!isCurrentUser || loading.email"
                class="w-full"
                placeholder="设置邮箱"
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
                :loading="loading.email"
                @click="handleSave('email')"
              />
            </div>
          </div>
        </div>
        
        <!-- 修改密码部分 -->
        <div class="info-section">
          <h3 class="section-title">修改密码</h3>
          <!-- 原密码 -->
          <div class="field">
            <label>原密码</label>
            <div class="p-inputgroup">
              <Password
                v-model="passwordData.oldPassword"
                :disabled="loading.password"
                class="w-full"
                placeholder="请输入原密码"
                toggleMask
                :feedback="false"
              />
            </div>
          </div>
          
          <!-- 新密码 -->
          <div class="field">
            <label>新密码</label>
            <div class="p-inputgroup">
              <Password
                v-model="passwordData.newPassword"
                :disabled="loading.password"
                class="w-full"
                placeholder="请输入新密码"
                toggleMask
              />
            </div>
          </div>
          
          <!-- 提交按钮 -->
          <div class="field">
            <Button
              label="修改密码"
              icon="pi pi-lock"
              :loading="loading.password"
              @click="handleChangePassword"
              class="password-submit-btn"
            />
          </div>
        </div>

        <!-- 个人资料 -->
        <div class="info-section">
          <h3 class="section-title">个人资料</h3>

          <!-- 性别 -->
          <div class="field">
            <label>性别</label>
            <div class="p-inputgroup">
              <Dropdown
                v-model="userData.gender"
                :options="genderOptions"
                optionLabel="label"
                optionValue="value"
                :disabled="!isCurrentUser || loading.gender"
                placeholder="选择性别"
                class="w-full"
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
                :loading="loading.gender"
                @click="handleSave('gender')"
              />
            </div>
          </div>

          <!-- 地址 -->
          <div class="field">
            <label>地址</label>
            <div class="p-inputgroup">
              <InputText
                v-model="userData.location"
                :disabled="!isCurrentUser || loading.location"
                class="w-full"
                placeholder="设置地址"
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
                :loading="loading.location"
                @click="handleSave('location')"
              />
            </div>
          </div>

          <!-- 个性签名 -->
          <div class="field">
            <label>个性签名</label>
            <div class="p-inputgroup">
              <Textarea
                v-model="userData.bio"
                :disabled="!isCurrentUser || loading.bio"
                rows="3"
                class="w-full"
                placeholder="添加个性签名..."
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
                :loading="loading.bio"
                @click="handleSave('bio')"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </Dialog>
</template>

<script>
import { computed, reactive, onMounted, watch } from 'vue'
import { useToast } from 'primevue/usetoast'
import axios from 'axios'
import { useStore } from 'vuex'
import Password from 'primevue/password'

export default {
  name: 'UserProfileDialog',
  components: {
    Password
  },
  props: {
    visible: {
      type: Boolean,
      required: true
    },
    username: {
      type: String,
      required: true
    }
  },
  emits: ['update:visible'],
  setup (props) {
    const toast = useToast()
    const store = useStore()

    // 用户数据
    const userData = reactive({
      userId: '',
      displayName: '',
      email: '',
      avatarUrl: '/uploads/avatars/default-avatar.png',
      gender: '',
      location: '',
      bio: ''
    })

    // 密码修改数据
    const passwordData = reactive({
      oldPassword: '',
      newPassword: ''
    })

    // 加载状态
    const loading = reactive({
      profile: false,
      displayName: false,
      email: false,
      gender: false,
      location: false,
      bio: false,
      avatar: false,
      password: false
    })

    // 性别选项
    const genderOptions = [
      { label: '男性', value: '男性' },
      { label: '女性', value: '女性' }
    ]

    // 判断是否为当前用户
    const isCurrentUser = computed(() => {
      const currentUsername = store.state.user?.username
      console.log('当前用户对比：组件用户名=', props.username, '，当前登录用户=', currentUsername)
      // 确保即使未登录用户也能编辑自己的资料
      return true // 始终允许编辑以方便开发调试
    })

    // 获取用户资料
    const fetchUserProfile = async () => {
      loading.profile = true
      try {
        const response = await axios.get(`/api/user/user-profile/${props.username}`)

        if (response.data.success) {
          const data = response.data.data
          console.log('获取到的用户资料:', data)

          // 更新用户数据
          userData.userId = data.userId // 从nickname获取
          userData.displayName = data.displayName // 从display_name获取
          userData.email = data.email
          userData.avatarUrl = data.avatarUrl
          userData.gender = data.gender
          userData.location = data.location
          userData.bio = data.bio
        } else {
          toast.add({
            severity: 'error',
            summary: '错误',
            detail: '获取用户资料失败',
            life: 3000
          })
        }
      } catch (error) {
        console.error('获取用户资料失败:', error)
        toast.add({
          severity: 'error',
          summary: '错误',
          detail: error.response?.data?.message || '获取用户资料失败',
          life: 3000
        })
      } finally {
        loading.profile = false
      }
    }

    // 处理头像点击
    const handleAvatarClick = () => {
      // 创建文件选择元素
      const fileInput = document.createElement('input')
      fileInput.type = 'file'
      fileInput.accept = 'image/*'
      fileInput.onchange = uploadAvatar
      fileInput.click()
    }
    // 上传头像
    const uploadAvatar = async (event) => {
      const file = event.target.files[0]
      if (!file) return

      // 验证文件类型
      const allowedTypes = ['image/jpeg', 'image/png', 'image/gif']
      if (!allowedTypes.includes(file.type)) {
        toast.add({
          severity: 'error',
          summary: '错误',
          detail: '只能上传JPG、PNG或GIF格式的图片',
          life: 3000
        })
        return
      }

      // 验证文件大小
      if (file.size > 5 * 1024 * 1024) {
        toast.add({
          severity: 'error',
          summary: '错误',
          detail: '图片大小不能超过5MB',
          life: 3000
        })
        return
      }

      loading.avatar = true

      // 创建FormData对象
      const formData = new FormData()
      formData.append('avatar', file)

      try {
        const response = await axios.post('/api/user/avatar', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        // 更新头像
        userData.avatarUrl = response.data.avatar_url.replace('public', '')
        toast.add({
          severity: 'success',
          summary: '成功',
          detail: '头像上传成功',
          life: 3000
        })
      } catch (error) {
        console.error('头像上传失败:', error)
        toast.add({
          severity: 'error',
          summary: '错误',
          detail: error.response?.data?.message || '头像上传失败',
          life: 3000
        })
      } finally {
        loading.avatar = false
      }
    }
    
    // 处理修改密码
    const handleChangePassword = async () => {
      // 验证输入
      if (!passwordData.oldPassword || !passwordData.newPassword) {
        toast.add({
          severity: 'warn',
          summary: '警告',
          detail: '请输入原密码和新密码',
          life: 3000
        })
        return
      }
      
      // 检查新旧密码是否相同
      if (passwordData.oldPassword === passwordData.newPassword) {
        toast.add({
          severity: 'error',
          summary: '错误',
          detail: '新密码不能与原密码相同',
          life: 3000
        })
        return
      }
      
      loading.password = true
      
      try {
        const response = await axios.post('/api/user/update-password', {
          oldPassword: passwordData.oldPassword,
          newPassword: passwordData.newPassword
        })
        
        if (response.data.success) {
          toast.add({
            severity: 'success',
            summary: '成功',
            detail: '密码修改成功',
            life: 3000
          })
          
          // 清空密码字段
          passwordData.oldPassword = ''
          passwordData.newPassword = ''
        } else {
          toast.add({
            severity: 'error',
            summary: '错误',
            detail: response.data.message || '密码修改失败',
            life: 3000
          })
        }
      } catch (error) {
        console.error('密码修改失败:', error)
        
        // 判断错误类型
        if (error.response?.status === 401) {
          toast.add({
            severity: 'error',
            summary: '错误',
            detail: '原密码错误，如忘记密码请使用找回密码功能',
            life: 5000
          })
        } else {
          toast.add({
            severity: 'error',
            summary: '错误',
            detail: error.response?.data?.message || '密码修改失败',
            life: 3000
          })
        }
      } finally {
        loading.password = false
      }
    }
    
    // 处理保存
    const handleSave = async (field) => {
      loading[field] = true

      const data = {}
      data[field] = userData[field]

      try {
        const response = await axios.patch('/api/user/user-profile', data)
        if (response.data.success) {
          // 如果更新了邮箱，更新Vuex状态
          if (field === 'email') {
            store.commit('setUser', {
              ...store.state.user,
              email: response.data.data.email
            })
          }
          toast.add({
            severity: 'success',
            summary: '成功',
            detail: `${field}更新成功`,
            life: 3000
          })
        } else {
          toast.add({
            severity: 'error',
            summary: '错误',
            detail: response.data.message || `${field}更新失败`,
            life: 3000
          })
        }
      } catch (error) {
        console.error(`${field}更新失败:`, error)
        toast.add({
          severity: 'error',
          summary: '错误',
          detail: error.response?.data?.message || `${field}更新失败`,
          life: 3000
        })
      } finally {
        loading[field] = false
      }
    }
    // 监听对话框可见性变化
    watch(() => props.visible, (newVal) => {
      if (newVal) {
        fetchUserProfile()
      }
    })
    // 监听用户名变化
    watch(() => props.username, (newVal) => {
      if (props.visible && newVal) {
        fetchUserProfile()
      }
    })
    // 页面挂载时获取用户资料
    onMounted(() => {
      if (props.visible) {
        fetchUserProfile()
      }
    })
    return {
      userData,
      passwordData,
      loading,
      genderOptions,
      isCurrentUser,
      handleAvatarClick,
      handleSave,
      handleChangePassword
    }
  }
}
</script>

<style scoped>
/* 重写Dialog样式 */
:deep(.p-dialog) {
  background: #0d1117;
  border: 1px solid rgba(107, 115, 255, 0.2);
  box-shadow: 0 0 30px rgba(107, 115, 255, 0.1);
  border-radius: 16px;
}

.profile-dialog-content {
  padding: 2.5rem 3rem;
  background: #0d1117;
  color: #e6edf3;
}

/* 头像部分样式 */
.avatar-section {
  display: flex;
  justify-content: center;
  margin-bottom: 4rem;
}

.avatar-wrapper {
  position: relative;
  width: 180px;
  height: 180px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px solid rgba(138, 43, 226, 0.4);  /* 更改为紫色系边框 */
  box-shadow: 0 0 20px rgba(138, 43, 226, 0.2);
  transition: all 0.3s ease;
}

.avatar-wrapper:hover {
  border-color: rgba(138, 43, 226, 0.8);
  box-shadow: 0 0 30px rgba(138, 43, 226, 0.4);
  transform: scale(1.02);
}

.avatar-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: filter 0.3s ease;
}

.avatar-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(13, 17, 23, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: all 0.3s ease;
}

.avatar-wrapper:hover .avatar-overlay {
  opacity: 1;
}

.avatar-wrapper:hover .avatar-image {
  filter: blur(2px);
}

.pi-camera {
  font-size: 2rem;
  color: #6b73ff;
  transition: transform 0.3s ease;
}

.avatar-wrapper:hover .pi-camera {
  transform: scale(1.1);
}

/* 信息部分样式 */
.profile-info {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 3rem;  /* 增加列间距 */
  margin: 0 auto;  /* 居中布局 */
  max-width: 100%;  /* 确保不超出容器 */
}

.info-section {
  background: linear-gradient(145deg, #161b22, #1a1f2a);  /* 渐变背景 */
  border-radius: 16px;
  padding: 2.5rem;
  border: 1px solid rgba(138, 43, 226, 0.1);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2),
              inset 0 2px 10px rgba(138, 43, 226, 0.1);  /* 添加内外阴影 */
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  backdrop-filter: blur(5px);  /* 毛玻璃效果 */
}

.info-section:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 25px rgba(138, 43, 226, 0.2),
              inset 0 2px 10px rgba(138, 43, 226, 0.2);
}

.section-title {
  margin: 0 0 2.5rem 0;
  font-size: 1.5rem;
  background: linear-gradient(90deg, #ff6b6b, #6b73ff, #4ecdc4);  /* 更丰富的渐变色 */
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  font-weight: 600;
  text-shadow: 0 0 10px rgba(107, 115, 255, 0.3);  /* 添加文字光晕 */
}

.field {
  margin-bottom: 2rem;
}

.field label {
  display: block;
  margin-bottom: 0.8rem;
  color: #a8b2d1;  /* 提高标签对比度 */
  font-size: 1rem;
  font-weight: 500;
  text-shadow: 0 0 5px rgba(168, 178, 209, 0.3);  /* 添加文字光晕 */
}

/* 修改密码按钮样式 */
.password-submit-btn {
  width: 100%;
  margin-top: 1rem;
}

/* 输入框样式 */
:deep(.p-inputtext),
:deep(.p-dropdown),
:deep(.p-calendar),
:deep(.p-textarea),
:deep(.p-password input) {
  width: 100%;
  background: #1a1f2a;  /* 稍微调亮背景色 */
  border: 1px solid rgba(138, 43, 226, 0.2);  /* 更改为紫色系边框 */
  color: #e6edf3;
  border-radius: 10px;
  padding: 0.8rem 1rem;
  font-size: 1rem;
  line-height: 1.5;
  height: auto;
  min-height: 42px;
  backdrop-filter: blur(5px);  /* 添加毛玻璃效果 */
  transition: all 0.3s ease;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.2);  /* 内阴影 */
}

:deep(.p-password) {
  width: 100%;
  display: block;
}

:deep(.p-inputtext:enabled:hover),
:deep(.p-dropdown:not(.p-disabled):hover),
:deep(.p-calendar:not(.p-disabled):hover),
:deep(.p-textarea:enabled:hover),
:deep(.p-password input:enabled:hover) {
  border-color: rgba(138, 43, 226, 0.5);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(138, 43, 226, 0.2), inset 0 2px 4px rgba(0, 0, 0, 0.1);
}

:deep(.p-inputtext:enabled:focus),
:deep(.p-dropdown:not(.p-disabled).p-focus),
:deep(.p-calendar:not(.p-disabled).p-focus),
:deep(.p-textarea:enabled:focus),
:deep(.p-password input:enabled:focus) {
  border-color: rgba(138, 43, 226, 0.8);
  box-shadow: 0 0 0 2px rgba(138, 43, 226, 0.2), inset 0 2px 4px rgba(0, 0, 0, 0.1);
  background: #232936;  /* 聚焦时稍微调亮背景 */
}

/* 按钮样式 */
:deep(.p-button) {
  background: linear-gradient(135deg, #8a2be2, #4ecdc4);  /* 渐变背景 */
  border: none;
  padding: 0.8rem 1.2rem;
  font-size: 1rem;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(138, 43, 226, 0.3);  /* 添加阴影 */
}

:deep(.p-button:enabled:hover) {
  background: linear-gradient(135deg, #9d3cf3, #5fdfd5);  /* 悬停时更亮的渐变 */
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(138, 43, 226, 0.4);
}

/* 下拉菜单样式 */
:deep(.p-dropdown) {
  background: #1a1f2a;
  border: 1px solid rgba(138, 43, 226, 0.2);
  transition: all 0.3s ease;
}

:deep(.p-dropdown:not(.p-disabled).p-focus) {
  border-color: rgba(138, 43, 226, 0.8);
  box-shadow: 0 0 0 2px rgba(138, 43, 226, 0.2);
  background: #232936;
}

:deep(.p-dropdown:hover) {
  border-color: rgba(138, 43, 226, 0.5);
  background: #232936;
}

:deep(.p-dropdown-panel) {
  background: #1a1f2a;
  border: 1px solid rgba(138, 43, 226, 0.2);
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
}

:deep(.p-dropdown-item) {
  color: #e6edf3;
  transition: all 0.3s ease;
  padding: 0.8rem 1rem;
}

:deep(.p-dropdown-item:hover) {
  background: rgba(138, 43, 226, 0.1);
  transform: translateX(5px);
}

:deep(.p-dropdown-item.p-highlight) {
  background: rgba(138, 43, 226, 0.2);
  color: #fff;
  text-shadow: 0 0 5px rgba(255, 255, 255, 0.5);
}

/* 修复下拉框选中状态 */
:deep(.p-dropdown .p-dropdown-trigger) {
  background: transparent;
  color: #e6edf3;
}

:deep(.p-dropdown .p-dropdown-label) {
  background: transparent;
  color: #e6edf3;
}

:deep(.p-dropdown .p-dropdown-label.p-placeholder) {
  color: #8b949e;
}

:deep(.p-dropdown:not(.p-disabled):hover) {
  border-color: rgba(138, 43, 226, 0.5);
}

:deep(.p-dropdown-panel .p-dropdown-items-wrapper) {
  background: #1a1f2a;
}

:deep(.p-dropdown-panel .p-dropdown-items) {
  padding: 0.5rem 0;
  background: #1a1f2a;
}

/* 修复下拉框选项hover状态 */
:deep(.p-dropdown-items .p-dropdown-item:not(.p-highlight):not(.p-disabled):hover) {
  background: rgba(138, 43, 226, 0.1);
  color: #fff;
}

/* 修复下拉框展开时的背景 */
:deep(.p-dropdown.p-component.p-inputwrapper.p-dropdown-clearable) {
  background: #1a1f2a;
}

:deep(.p-dropdown.p-component.p-inputwrapper.p-dropdown-clearable:not(.p-disabled).p-focus) {
  background: #232936;
}

/* 输入组样式 */
:deep(.p-inputgroup) {
  display: flex;
  align-items: center;
  gap: 1rem;
}

/* 响应式设计调整 */
@media (max-width: 1200px) {
  :deep(.p-dialog) {
    width: 95vw !important;
    min-width: auto !important;
  }

  .profile-info {
    grid-template-columns: 1fr;
  }

  .profile-dialog-content {
    padding: 1.5rem;
  }

  .info-section {
    padding: 1.5rem;
  }
}
</style>
