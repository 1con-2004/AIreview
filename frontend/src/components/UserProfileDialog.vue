<template>
  <Dialog 
    :visible="visible" 
    :header="'用户资料'" 
    :modal="true" 
    :style="{ width: '90%', maxWidth: '500px' }"
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
      
      <!-- 用户信息部分 -->
      <div class="profile-info">
        <!-- 账号(不可修改) -->
        <div class="field">
          <label>初始ID</label>
          <InputText v-model="userProfile.nickname" disabled class="w-full" />
        </div>

        <!-- 昵称 -->
        <div class="field">
          <label>用户名称</label>
          <div class="p-inputgroup">
            <InputText 
              v-model="editForm.display_name" 
              :disabled="!isCurrentUser"
              class="w-full"
              placeholder="设置用户名称"
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
            <InputText
              v-model="editForm.birth_date"
              :disabled="!isCurrentUser"
              type="date"
              class="w-full"
              placeholder="选择生日"
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
          <label>地址</label>
          <div class="p-inputgroup">
            <InputText 
              v-model="editForm.location" 
              :disabled="!isCurrentUser"
              class="w-full"
              placeholder="设置地址"
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
          <label>个性签名</label>
          <div class="p-inputgroup">
            <Textarea 
              v-model="editForm.bio" 
              :disabled="!isCurrentUser"
              rows="3" 
              class="w-full"
              placeholder="添加个性签名..."
            />
            <Button 
              v-if="isCurrentUser && isFieldChanged('bio')"
              icon="pi pi-check" 
              @click="handleFieldUpdate('bio', editForm.bio)"
            />
          </div>
        </div>
      </div>
    </div>
  </Dialog>
</template>

<script>
import { ref, computed, watch, onMounted } from 'vue'
import { useToast } from 'primevue/usetoast'

export default {
  name: 'UserProfileDialog',
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
  setup(props, { emit }) {
    const toast = useToast()
    const defaultAvatar = ref('/images/default-avatar.png')
    const userProfile = ref({})
    const fileInput = ref(null)
    
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
      return userInfo.username === props.username
    })

    const getFullAvatarUrl = (url) => {
      if (!url || url === 'null' || url === 'undefined') {
        console.log('没有头像URL，使用默认头像:', defaultAvatar.value);
        return defaultAvatar.value;
      }
      
      if (url.startsWith('http')) {
        console.log('使用完整的URL:', url);
        return url;
      }
      
      // 处理数据库中存储的路径
      if (url.includes('public/uploads/avatars/')) {
        const fileName = url.split('/').pop();
        const fullUrl = `http://localhost:3000/uploads/avatars/${fileName}?t=${Date.now()}`;
        console.log('转换后的头像URL:', fullUrl);
        return fullUrl;
      }
      
      // 处理其他情况
      const fullUrl = `http://localhost:3000${url}?t=${Date.now()}`;
      console.log('其他情况的头像URL:', fullUrl);
      return fullUrl;
    }

    const fetchUserProfile = async () => {
      try {
        console.log('获取用户资料:', props.username)
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        
        // 直接使用传入的用户名作为参数，确保获取正确的用户资料
        const username = props.username
        
        const response = await fetch(`http://localhost:3000/api/user/user-profile/${username}`, {
          headers: {
            Authorization: `Bearer ${userInfo.accessToken || userInfo.token}`
          }
        })
        
        const data = await response.json()
        if (response.ok) {
          console.log('获取到的用户资料:', data)
          userProfile.value = data
          editForm.value = {
            display_name: data.display_name || '',
            gender: data.gender || null,
            birth_date: data.birth_date ? new Date(data.birth_date).toISOString().split('T')[0] : null,
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

    const isFieldChanged = (field) => {
      if (field === 'birth_date') {
        const currentDate = editForm.value[field] || null
        const profileDate = userProfile.value[field] ? new Date(userProfile.value[field]).toISOString().split('T')[0] : null
        return currentDate !== profileDate
      }
      return editForm.value[field] !== userProfile.value[field]
    }

    const handleFieldUpdate = async (field, value) => {
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        // 处理日期格式
        let processedValue = value
        if (field === 'birth_date' && value) {
          processedValue = value // 已经是 YYYY-MM-DD 格式
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

    const triggerFileInput = () => {
      fileInput.value.click()
    }

    const handleAvatarUpload = async (event) => {
      const file = event.target.files[0]
      if (!file) return

      const formData = new FormData()
      formData.append('avatar', file)

      try {
        console.log('开始上传头像...')
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        const response = await fetch('http://localhost:3000/api/user/avatar', {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${userInfo.accessToken || userInfo.token}`
          },
          body: formData
        })

        const data = await response.json()
        if (response.ok) {
          console.log('头像上传成功，返回数据:', data)
          
          // 更新本地显示的头像
          if (data.avatar_url) {
            // 确保使用正确的路径格式
            userProfile.value.avatar_url = data.avatar_url
            
            console.log('更新后的头像路径:', userProfile.value.avatar_url)
            
            // 更新localStorage中的用户信息
            const currentUserInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
            currentUserInfo.avatar_url = data.avatar_url
            localStorage.setItem('userInfo', JSON.stringify(currentUserInfo))
            
            // 触发全局事件，通知导航栏更新头像
            window.dispatchEvent(new Event('userAvatarUpdated'))
          }
          
          toast.add({ severity: 'success', summary: '成功', detail: '头像上传成功' })
        } else {
          console.error('头像上传失败:', data)
          toast.add({ severity: 'error', summary: '错误', detail: data.message || '头像上传失败' })
        }
      } catch (error) {
        console.error('头像上传失败:', error)
        toast.add({ severity: 'error', summary: '错误', detail: '头像上传失败' })
      }
    }

    watch(() => props.visible, (newValue) => {
      if (newValue && props.username) {
        fetchUserProfile()
      }
    })

    watch(() => props.username, (newValue) => {
      if (props.visible && newValue) {
        fetchUserProfile()
      }
    })

    onMounted(() => {
      if (props.visible && props.username) {
        fetchUserProfile()
      }
    })

    return {
      userProfile,
      editForm,
      genderOptions,
      isCurrentUser,
      isFieldChanged,
      handleFieldUpdate,
      fileInput,
      triggerFileInput,
      handleAvatarUpload,
      getFullAvatarUrl
    }
  }
}
</script>

<style scoped>
.profile-dialog-content {
  padding: 1rem;
}

.avatar-section {
  display: flex;
  justify-content: center;
  margin-bottom: 1.5rem;
}

.avatar-wrapper {
  position: relative;
  width: 120px;
  height: 120px;
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
  gap: 1rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.field label {
  font-weight: 600;
  color: var(--text-color-secondary);
  font-size: 0.875rem;
}

:deep(.p-inputtext),
:deep(.p-dropdown),
:deep(.p-calendar),
:deep(.p-textarea) {
  width: 100%;
}

:deep(.p-button) {
  background: var(--primary-color);
  border: none;
}

:deep(.p-button:enabled:hover) {
  background: var(--primary-600);
}

:deep(.p-dialog-header) {
  padding: 1.25rem 1.5rem;
  background: var(--surface-card);
  color: var(--text-color);
  border-top-right-radius: 6px;
  border-top-left-radius: 6px;
}

:deep(.p-dialog-content) {
  padding: 0;
  background: var(--surface-card);
  color: var(--text-color);
}

:deep(.p-dialog-footer) {
  padding: 1.25rem 1.5rem;
  background: var(--surface-card);
  color: var(--text-color);
  border-bottom-right-radius: 6px;
  border-bottom-left-radius: 6px;
}
</style> 