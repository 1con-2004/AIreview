<template>
  <div class="profile-page">
    <nav-bar></nav-bar>
    <div class="profile-container">
      <Toast />
      <div class="grid">
        <!-- 个人信息卡片 -->
        <div class="col-12 md:col-8">
          <Card class="profile-card">
            <template #content>
              <div class="avatar-section">
                <div class="avatar-wrapper">
                  <img :src="getFullAvatarUrl(userProfile.avatar_url)" alt="用户头像" class="avatar-image">
                  <div class="avatar-overlay" @click="triggerFileInput" v-if="isCurrentUser">
                    <i class="pi pi-camera"></i>
                  </div>
                  <input 
                    type="file"
                    ref="fileInput"
                    style="display: none"
                    accept="image/*"
                    @change="handleAvatarUpload"
                  >
                </div>
              </div>
              
              <div class="profile-info">
                <!-- 账号(不可修改) -->
                <div class="field">
                  <label>账号</label>
                  <InputText v-model="userProfile.username" disabled class="w-full" />
                </div>

                <!-- 昵称 -->
                <div class="field">
                  <label>昵称</label>
                  <div class="p-inputgroup">
                    <InputText 
                      v-model="editForm.display_name" 
                      :disabled="!isCurrentUser"
                      class="w-full"
                      placeholder="设置昵称"
                    />
                    <Button 
                      v-if="isCurrentUser && isFieldChanged('display_name')"
                      icon="pi pi-check" 
                      @click="handleFieldUpdate('display_name', editForm.display_name)"
                    />
                  </div>
                </div>

                <!-- 性别 -->
                <div class="field">
                  <label>性别</label>
                  <div class="p-inputgroup">
                    <Dropdown
                      v-model="editForm.gender"
                      :options="genderOptions"
                      optionLabel="label"
                      optionValue="value"
                      :disabled="!isCurrentUser"
                      placeholder="选择性别"
                      class="w-full"
                    />
                    <Button 
                      v-if="isCurrentUser && isFieldChanged('gender')"
                      icon="pi pi-check" 
                      @click="handleFieldUpdate('gender', editForm.gender)"
                    />
                  </div>
                </div>

                <!-- 生日 -->
                <div class="field">
                  <label>生日</label>
                  <div class="p-inputgroup">
                    <Calendar 
                      v-model="editForm.birth_date" 
                      :disabled="!isCurrentUser"
                      dateFormat="yy-mm-dd"
                      :showIcon="true"
                      class="w-full"
                    />
                    <Button 
                      v-if="isCurrentUser && isFieldChanged('birth_date')"
                      icon="pi pi-check" 
                      @click="handleFieldUpdate('birth_date', editForm.birth_date)"
                    />
                  </div>
                </div>

                <!-- 现居地 -->
                <div class="field">
                  <label>现居地</label>
                  <div class="p-inputgroup">
                    <InputText 
                      v-model="editForm.location" 
                      :disabled="!isCurrentUser"
                      class="w-full"
                      placeholder="设置现居地"
                    />
                    <Button 
                      v-if="isCurrentUser && isFieldChanged('location')"
                      icon="pi pi-check" 
                      @click="handleFieldUpdate('location', editForm.location)"
                    />
                  </div>
                </div>

                <!-- 个人介绍 -->
                <div class="field">
                  <label>个人介绍</label>
                  <div class="p-inputgroup">
                    <Textarea 
                      v-model="editForm.bio" 
                      :disabled="!isCurrentUser"
                      rows="4" 
                      class="w-full"
                      placeholder="添加个人介绍..."
                    />
                    <Button 
                      v-if="isCurrentUser && isFieldChanged('bio')"
                      icon="pi pi-check" 
                      @click="handleFieldUpdate('bio', editForm.bio)"
                    />
                  </div>
                </div>
              </div>
            </template>
          </Card>
        </div>

        <!-- 统计卡片 -->
        <div class="col-12 md:col-4">
          <Card class="stats-card">
            <template #content>
              <div class="stats-grid">
                <div class="stat-item">
                  <div class="stat-value">{{ stats.solved_problems || 0 }}</div>
                  <div class="stat-label">已解决题目</div>
                </div>
                <div class="stat-item">
                  <div class="stat-value">{{ stats.posts || 0 }}</div>
                  <div class="stat-label">发帖数</div>
                </div>
                <div class="stat-item">
                  <div class="stat-value">{{ stats.likes || 0 }}</div>
                  <div class="stat-label">获赞数</div>
                </div>
              </div>
            </template>
          </Card>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useToast } from 'primevue/usetoast'

export default {
  name: 'UserProfile',
  components: {
    NavBar
  },
  setup() {
    const toast = useToast()
    const route = useRoute()
    const defaultAvatar = ref('/default-avatar.png')
    const getFullAvatarUrl = (url) => {
      if (!url) return defaultAvatar.value;
      if (url.startsWith('http')) return url;
      const cleanUrl = url.startsWith('/') ? url : `/${url}`;
      return `http://localhost:3000${cleanUrl}`;
    }
    const userProfile = ref({})
    const stats = ref({})
    const editForm = ref({
      display_name: '',
      gender: null,
      birth_date: null,
      location: '',
      bio: ''
    })
    const genderOptions = ref([
      { label: '男性', value: '男性' },
      { label: '女性', value: '女性' }
    ])

    const isCurrentUser = computed(() => {
      const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
      return userInfo.username === route.params.username
    })

    const fetchUserProfile = async () => {
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        
        // 直接使用路由参数中的用户名，不做自动切换
        const targetUsername = route.params.username
        console.log('正在获取用户资料:', targetUsername)
        
        const response = await fetch(`http://localhost:3000/api/user/user-profile/${targetUsername}`, {
          headers: {
            Authorization: `Bearer ${userInfo.accessToken || userInfo.token}`
          }
        })
        const data = await response.json()
        if (response.ok) {
          userProfile.value = data
          editForm.value = {
            display_name: data.display_name || '',
            gender: data.gender || null,
            birth_date: data.birth_date ? new Date(data.birth_date) : null,
            location: data.location || '',
            bio: data.bio || ''
          }
        } else {
          toast.add({ severity: 'error', summary: '错误', detail: data.message || '获取用户资料失败' })
        }
      } catch (error) {
        console.error('获取用户资料失败:', error)
        toast.add({ severity: 'error', summary: '错误', detail: '获取用户资料失败' })
      }
    }

    const fetchUserStats = async () => {
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        
        // 直接使用路由参数中的用户名
        const targetUsername = route.params.username
        
        const response = await fetch(`http://localhost:3000/api/user/stats/${targetUsername}`, {
          headers: {
            Authorization: `Bearer ${userInfo.accessToken || userInfo.token}`
          }
        })
        const data = await response.json()
        if (response.ok) {
          stats.value = data
        } else {
          toast.add({ severity: 'error', summary: '错误', detail: data.message || '获取用户统计信息失败' })
        }
      } catch (error) {
        console.error('获取用户统计信息失败:', error)
        toast.add({ severity: 'error', summary: '错误', detail: '获取用户统计信息失败' })
      }
    }

    const isFieldChanged = (field) => {
      if (field === 'birth_date') {
        const currentDate = editForm.value[field] ? new Date(editForm.value[field]).toISOString().split('T')[0] : null
        const profileDate = userProfile.value[field] ? new Date(userProfile.value[field]).toISOString().split('T')[0] : null
        return currentDate !== profileDate
      }
      return editForm.value[field] !== userProfile.value[field]
    }

    const handleFieldUpdate = async (field, value) => {
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        // 处理日期格式
        let processedValue = value;
        if (field === 'birth_date' && value) {
          processedValue = new Date(value).toISOString().split('T')[0];
        }
        const response = await fetch('http://localhost:3000/api/user/user-profile', {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${userInfo.accessToken || userInfo.token}`
          },
          body: JSON.stringify({ [field]: processedValue })
        })
        const data = await response.json()
        if (response.ok) {
          toast.add({ severity: 'success', summary: '成功', detail: '更新成功' })
          await fetchUserProfile()
        } else {
          toast.add({ severity: 'error', summary: '错误', detail: data.message || '更新失败' })
        }
      } catch (error) {
        console.error('更新失败:', error)
        toast.add({ severity: 'error', summary: '错误', detail: '更新失败' })
      }
    }

    const fileInput = ref(null)
    const triggerFileInput = () => {
      fileInput.value.click()
    }

    const handleAvatarUpload = async (event) => {
      // 确保当前用户才能上传头像
      if (!isCurrentUser.value) {
        toast.add({ severity: 'error', summary: '错误', detail: '只能修改自己的头像' });
        return;
      }

      const file = event.target.files[0];
      if (!file) return;

      const formData = new FormData();
      formData.append('avatar', file);

      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}');
        const response = await fetch('http://localhost:3000/api/user/avatar', {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${userInfo.accessToken || userInfo.token}`
          },
          body: formData
        });

        const data = await response.json();
        if (response.ok) {
          userProfile.value.avatar_url = data.avatar_url;
          // 更新localStorage中的用户信息
          const currentUserInfo = JSON.parse(localStorage.getItem('userInfo') || '{}');
          currentUserInfo.avatar_url = data.avatar_url;
          localStorage.setItem('userInfo', JSON.stringify(currentUserInfo));
          
          // 触发全局事件，通知导航栏更新头像
          window.dispatchEvent(new Event('userAvatarUpdated'));
          
          toast.add({ severity: 'success', summary: '成功', detail: '头像上传成功' });
        } else {
          toast.add({ severity: 'error', summary: '错误', detail: data.message || '头像上传失败' });
        }
      } catch (error) {
        console.error('头像上传失败:', error);
        toast.add({ severity: 'error', summary: '错误', detail: '头像上传失败' });
      }
    };

    onMounted(() => {
      fetchUserProfile()
      fetchUserStats()
    })

    return {
      defaultAvatar,
      getFullAvatarUrl,
      userProfile,
      stats,
      editForm,
      genderOptions,
      isCurrentUser,
      isFieldChanged,
      handleFieldUpdate,
      fileInput,
      triggerFileInput,
      handleAvatarUpload
    }
  }
}
</script>

<style scoped>
.profile-page {
  min-height: 100vh;
  background-color: var(--surface-ground);
  color: var(--text-color);
}

.profile-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
}

:deep(.p-card) {
  background: var(--surface-card);
  color: var(--text-color);
  border: none;
}

.avatar-section {
  display: flex;
  justify-content: center;
  margin-bottom: 32px;
}

.avatar-wrapper {
  position: relative;
  width: 150px;
  height: 150px;
  border-radius: 50%;
  overflow: hidden;
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
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
  cursor: pointer;
}

.avatar-wrapper:hover .avatar-overlay {
  opacity: 1;
}

.avatar-wrapper:hover .avatar-image {
  filter: blur(2px);
}

.pi-camera {
  font-size: 24px;
  color: white;
}

.profile-info {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.field label {
  color: var(--text-color-secondary);
  font-size: 14px;
}

:deep(.p-inputtext),
:deep(.p-dropdown),
:deep(.p-calendar),
:deep(.p-textarea) {
  width: 100%;
}

:deep(.p-inputtext:enabled:focus) {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 1px var(--primary-color);
}

:deep(.p-button) {
  background: var(--primary-color);
  border: none;
}

:deep(.p-button:enabled:hover) {
  background: var(--primary-600);
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(1, 1fr);
  gap: 24px;
}

.stat-item {
  text-align: center;
  padding: 20px;
  background: var(--surface-hover);
  border-radius: 12px;
}

.stat-value {
  font-size: 36px;
  font-weight: bold;
  color: var(--primary-color);
  margin-bottom: 8px;
}

.stat-label {
  color: var(--text-color-secondary);
  font-size: 14px;
}

@media screen and (max-width: 768px) {
  .profile-container {
    padding: 20px;
  }
}
</style> 