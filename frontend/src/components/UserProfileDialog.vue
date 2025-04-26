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
          <img :src="mockUserData.avatarUrl" alt="用户头像" class="avatar-image">
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
            <InputText v-model="mockUserData.userId" disabled class="w-full" />
          </div>

          <!-- 用户名 -->
          <div class="field">
            <label>用户名</label>
            <div class="p-inputgroup">
              <InputText
                v-model="mockUserData.username"
                :disabled="!isCurrentUser"
                class="w-full"
                placeholder="设置用户名"
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
                @click="handleSave('username')"
              />
            </div>
          </div>

          <!-- 邮箱 -->
          <div class="field">
            <label>邮箱</label>
            <div class="p-inputgroup">
              <InputText
                v-model="mockUserData.email"
                :disabled="!isCurrentUser"
                class="w-full"
                placeholder="设置邮箱"
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
                @click="handleSave('email')"
              />
            </div>
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
                v-model="mockUserData.gender"
                :options="genderOptions"
                optionLabel="label"
                optionValue="value"
                :disabled="!isCurrentUser"
                placeholder="选择性别"
                class="w-full"
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
                @click="handleSave('gender')"
              />
            </div>
          </div>

          <!-- 生日 -->
          <div class="field">
            <label>生日</label>
            <div class="p-inputgroup">
              <Calendar
                v-model="mockUserData.birthDate"
                :disabled="!isCurrentUser"
                dateFormat="yy-mm-dd"
                class="w-full"
                placeholder="选择生日"
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
                @click="handleSave('birthDate')"
              />
            </div>
          </div>

          <!-- 地址 -->
          <div class="field">
            <label>地址</label>
            <div class="p-inputgroup">
              <InputText
                v-model="mockUserData.location"
                :disabled="!isCurrentUser"
                class="w-full"
                placeholder="设置地址"
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
                @click="handleSave('location')"
              />
            </div>
          </div>

          <!-- 个性签名 -->
          <div class="field">
            <label>个性签名</label>
            <div class="p-inputgroup">
              <Textarea
                v-model="mockUserData.bio"
                :disabled="!isCurrentUser"
                rows="3"
                class="w-full"
                placeholder="添加个性签名..."
              />
              <Button
                v-if="isCurrentUser"
                icon="pi pi-check"
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
import { ref, computed } from 'vue'
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
  setup (props) {
    const toast = useToast()

    // 模拟用户数据
    const mockUserData = ref({
      userId: 'USER_001',
      username: '测试用户',
      email: 'test@example.com',
      avatarUrl: '/uploads/avatars/default-avatar.png',
      gender: '男性',
      birthDate: null,
      location: '北京市',
      bio: '这是一个测试用户的个性签名'
    })

    const genderOptions = [
      { label: '男性', value: '男性' },
      { label: '女性', value: '女性' }
    ]

    // 判断是否为当前用户
    const isCurrentUser = computed(() => {
      return true // 暂时默认为true，后续可以根据实际需求修改
    })

    // 处理头像点击
    const handleAvatarClick = () => {
      toast.add({
        severity: 'info',
        summary: '提示',
        detail: '头像上传功能待实现'
      })
    }

    // 处理保存
    const handleSave = (field) => {
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: `${field}更新成功`
      })
    }

    return {
      mockUserData,
      genderOptions,
      isCurrentUser,
      handleAvatarClick,
      handleSave
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

/* 输入框样式 */
:deep(.p-inputtext),
:deep(.p-dropdown),
:deep(.p-calendar),
:deep(.p-textarea) {
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

:deep(.p-inputtext:enabled:hover),
:deep(.p-dropdown:not(.p-disabled):hover),
:deep(.p-calendar:not(.p-disabled):hover),
:deep(.p-textarea:enabled:hover) {
  border-color: rgba(138, 43, 226, 0.5);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(138, 43, 226, 0.2), inset 0 2px 4px rgba(0, 0, 0, 0.1);
}

:deep(.p-inputtext:enabled:focus),
:deep(.p-dropdown:not(.p-disabled).p-focus),
:deep(.p-calendar:not(.p-disabled).p-focus),
:deep(.p-textarea:enabled:focus) {
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

/* 日期选择器样式 */
:deep(.p-calendar-panel) {
  background: #1a1f2a;
  border: 1px solid rgba(138, 43, 226, 0.2);
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

:deep(.p-calendar-panel .p-datepicker-header) {
  background: #232936;
  border-bottom: 1px solid rgba(138, 43, 226, 0.2);
}

:deep(.p-calendar-panel .p-datepicker-calendar td > span) {
  color: #e6edf3;
  transition: all 0.3s ease;
}

:deep(.p-calendar-panel .p-datepicker-calendar td > span:hover) {
  background: rgba(138, 43, 226, 0.1);
  transform: scale(1.1);  /* 悬停时放大效果 */
}

:deep(.p-calendar-panel .p-datepicker-calendar td.p-datepicker-today > span) {
  background: rgba(138, 43, 226, 0.2);
  color: #fff;
  text-shadow: 0 0 5px rgba(255, 255, 255, 0.5);
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
