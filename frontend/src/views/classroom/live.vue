<!-- 课堂实时页面 -->
<template>
  <div class="live-classroom-page">
    <nav-bar></nav-bar>
    <div class="live-classroom-container">
      <!-- 课堂信息头部 -->
      <div class="classroom-header">
        <div class="classroom-info">
          <h1>{{ classroom.title || '加载中...' }}</h1>
          <div class="classroom-meta">
            <span class="meta-item">
              <i class="fas fa-user"></i> {{ studentInfo.real_name || userInfo.username }}
            </span>
            <span class="meta-item">
              <i class="fas fa-id-card"></i> {{ studentInfo.student_no || '未设置' }}
            </span>
            <span class="meta-item">
              <i class="fas fa-clock"></i> {{ currentTime }}
            </span>
          </div>
        </div>
        <div class="classroom-actions">
          <button class="action-btn" @click="leaveClassroom">
            <i class="fas fa-sign-out-alt"></i> 离开课堂
          </button>
        </div>
      </div>

      <!-- 课堂内容区域 -->
      <div class="classroom-content">
        <!-- 老师留言区 -->
        <div class="teacher-message-section">
          <div class="section-header">
            <h2><i class="fas fa-bullhorn"></i> 老师留言</h2>
          </div>
          <div class="teacher-messages">
            <div v-if="loading.messages" class="loading-container">
              <div class="loading-spinner"></div>
              <p>加载中...</p>
            </div>
            <div v-else-if="teacherMessages.length === 0" class="empty-message">
              <p>暂无留言</p>
            </div>
            <div v-else v-for="(message, index) in teacherMessages" :key="index" class="teacher-message">
              <div class="message-content">
                {{ message.content }}
              </div>
              <div class="message-time">{{ formatDate(message.created_at) }}</div>
            </div>
          </div>
        </div>

        <!-- 课堂文件区 -->
        <div class="classroom-files-section">
          <div class="section-header">
            <h2><i class="fas fa-file-alt"></i> 课堂文件</h2>
          </div>
          <div class="classroom-files">
            <div v-if="loading.files" class="loading-container">
              <div class="loading-spinner"></div>
              <p>加载中...</p>
            </div>
            <div v-else-if="classroomFiles.length === 0" class="empty-message">
              <p>暂无文件</p>
            </div>
            <div v-else v-for="(file, index) in classroomFiles" :key="index" class="file-item">
              <div class="file-icon">
                <i :class="getFileIcon(file.file_type)"></i>
              </div>
              <div class="file-info">
                <div class="file-name">{{ file.file_name }}</div>
                <div class="file-meta">
                  <span class="file-size">{{ formatFileSize(file.file_size) }}</span>
                  <span class="file-time">{{ formatDate(file.upload_time) }}</span>
                </div>
              </div>
              <div class="file-actions">
                <button class="file-action-btn" @click="downloadFile(file)">
                  <i class="fas fa-download"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 讨论区 -->
      <div class="discussion-section">
        <div class="section-header">
          <h2><i class="fas fa-comments"></i> 讨论区</h2>
        </div>
        <div class="discussion-messages" ref="discussionMessagesEl">
          <div v-if="loading.discussions" class="loading-container">
            <div class="loading-spinner"></div>
            <p>加载中...</p>
          </div>
          <div v-else-if="!discussionMessages || discussionMessages.length === 0" class="empty-message">
            <p>暂无消息，开始讨论吧！</p>
          </div>
          <template v-else>
            <div v-for="(message, index) in discussionMessages" :key="message.id || index" class="discussion-message" :class="{'my-message': message.user && message.user.id === userInfo.id}">
              <div class="message-bubble">
                <div class="message-sender">
                  {{ message.user ? (message.user.display_name || message.user.username || '未知用户') : '未知用户' }}
                  <span class="user-role" v-if="message.user && (message.user.role === 'teacher' || message.user.role === 'admin')">
                    (老师)
                  </span>
                  <span class="student-info" v-if="message.user && message.user.id === userInfo.id && studentInfo.student_no">
                    ({{ studentInfo.student_no }})
                  </span>
                </div>
                <div class="message-content">{{ message.content || '空消息' }}</div>
                <div class="message-time">{{ formatDate(message.created_at) }}</div>
              </div>
            </div>
          </template>
        </div>
        <div class="discussion-input">
          <input
            type="text"
            v-model="newMessage"
            placeholder="输入消息..."
            @keyup.enter="sendMessage"
          >
          <button class="send-btn" @click="sendMessage">
            <i class="fas fa-paper-plane"></i>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed, watch, nextTick } from 'vue'
import { useRoute, useRouter, onBeforeRouteLeave } from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import axios from 'axios'

// 全局变量，用于跟踪组件实例状态
// 使用window对象确保在所有实例间共享
window.liveClassroomActive = false

const route = useRoute()
const router = useRouter()

// 获取路由参数
const classroomCode = computed(() => route.params.id || '')

// 用户信息
const userInfo = ref(JSON.parse(localStorage.getItem('userInfo') || '{}'))
const studentInfo = ref({})

// 课堂信息
const classroom = ref({})

// 加载状态
const loading = ref({
  classroom: true,
  messages: true,
  files: true,
  discussions: true
})

// 如果没有用户信息，重定向到课堂主页
if (!userInfo.value.id) {
  router.push('/classroom')
}

// 当前时间
const currentTime = ref(new Date().toLocaleTimeString())
const timeTimer = ref(null)

// 老师留言数据
const teacherMessages = ref([])

// 课堂文件数据
const classroomFiles = ref([])

// 讨论区消息
const discussionMessages = ref([])

// 新消息输入
const newMessage = ref('')
const discussionMessagesEl = ref(null)

// 定时器引用
const discussionTimer = ref(null)
const classroomDataTimer = ref(null)

// 添加一个标记，表示组件是否已卸载
const isComponentUnmounted = ref(false) // 改回默认为false，避免阻止初始化加载

// 获取用户信息
const getUserInfo = async () => {
  // 检查组件是否已卸载，但初始化时不检查
  if (isComponentUnmounted.value && !window.liveClassroomActive) {
    console.log('组件已卸载，取消获取用户信息')
    return
  }

  try {
    // 获取学生信息
    const response = await axios.get(`/api/user/student-info/${userInfo.value.id}`)
    if (response.data.code === 200 && response.data.data) {
      studentInfo.value = response.data.data
    }
  } catch (error) {
    console.error('获取用户信息失败:', error)
  }
}

// 获取课堂信息
const getClassroomInfo = async () => {
  // 检查组件是否已卸载，但初始化时不检查
  if (isComponentUnmounted.value && !window.liveClassroomActive) {
    console.log('组件已卸载，取消获取课堂信息')
    return
  }

  try {
    loading.value.classroom = true
    const response = await axios.get(`/api/classroom/${classroomCode.value}`)
    classroom.value = response.data.data
    loading.value.classroom = false
  } catch (error) {
    console.error('获取课堂信息失败:', error)
    alert('获取课堂信息失败，可能课堂不存在或已关闭')
    router.push('/classroom')
  }
}

// 获取课堂留言
const getClassroomMessages = async () => {
  // 检查组件是否已卸载，但初始化时不检查
  if (isComponentUnmounted.value && !window.liveClassroomActive) {
    console.log('组件已卸载，取消获取课堂留言')
    return
  }

  try {
    loading.value.messages = true
    const response = await axios.get(`/api/classroom/${classroom.value.id}/messages`)
    teacherMessages.value = response.data.data
    loading.value.messages = false
  } catch (error) {
    console.error('获取课堂留言失败:', error)
    loading.value.messages = false
  }
}

// 获取课堂文件
const getClassroomFiles = async () => {
  // 检查组件是否已卸载，但初始化时不检查
  if (isComponentUnmounted.value && !window.liveClassroomActive) {
    console.log('组件已卸载，取消获取课堂文件')
    return
  }

  try {
    loading.value.files = true
    const response = await axios.get(`/api/classroom/${classroom.value.id}/files`)
    classroomFiles.value = response.data.data
    loading.value.files = false
  } catch (error) {
    console.error('获取课堂文件失败:', error)
    loading.value.files = false
  }
}

// 获取讨论消息
const getDiscussionMessages = async () => {
  // 检查组件是否已卸载，但初始化时不检查
  if (isComponentUnmounted.value && !window.liveClassroomActive) {
    console.log('组件已卸载，取消获取讨论消息')
    return
  }

  try {
    // 只在首次加载时显示加载状态
    if (discussionMessages.value.length === 0) {
      loading.value.discussions = true
    }

    console.log('获取讨论消息，课堂ID:', classroom.value.id)
    const response = await axios.get(`/api/classroom/${classroom.value.id}/discussions`)

    // 再次检查组件是否已卸载（可能在请求过程中被卸载）
    if (isComponentUnmounted.value && !window.liveClassroomActive) {
      console.log('组件在请求过程中被卸载，取消处理讨论消息')
      return
    }

    // 只在控制台输出简要信息，避免大量日志
    console.log('获取讨论消息:', response.data.data ? response.data.data.length : 0, '条')

    // 确保 discussionMessages 是数组
    const newMessages = Array.isArray(response.data.data) ? response.data.data : []

    // 检查是否有新消息（通过比较最后一条消息的ID）
    const hasNewMessages =
      newMessages.length > 0 &&
      (discussionMessages.value.length === 0 ||
       newMessages[newMessages.length - 1].id !== discussionMessages.value[discussionMessages.value.length - 1].id)

    // 只有在有新消息时才更新并滚动
    if (hasNewMessages) {
      discussionMessages.value = newMessages
      console.log('更新讨论消息，数量:', discussionMessages.value.length)

      // 滚动到底部
      nextTick(() => {
        scrollToBottom()
      })
    }

    loading.value.discussions = false
  } catch (error) {
    console.error('获取讨论消息失败:', error)
    loading.value.discussions = false
  }
}

// 发送消息
const sendMessage = async () => {
  if (!newMessage.value.trim()) return

  // 检查组件是否已卸载
  if (isComponentUnmounted.value || !window.liveClassroomActive) {
    console.log('组件已卸载，取消发送消息')
    return
  }

  try {
    console.log('发送消息，课堂ID:', classroom.value.id, '用户ID:', userInfo.value.id)
    const response = await axios.post(`/api/classroom/${classroom.value.id}/discussions`, {
      user_id: userInfo.value.id,
      content: newMessage.value
    })

    // 再次检查组件是否已卸载
    if (isComponentUnmounted.value || !window.liveClassroomActive) {
      console.log('组件在请求过程中被卸载，取消处理发送消息响应')
      return
    }

    console.log('发送消息响应:', response.data)

    // 确保 discussionMessages 是数组，然后添加新消息
    if (!Array.isArray(discussionMessages.value)) {
      discussionMessages.value = []
    }
    discussionMessages.value.push(response.data.data)
    console.log('添加消息后数量:', discussionMessages.value.length)

    newMessage.value = ''

    // 滚动到底部
    scrollToBottom()
  } catch (error) {
    console.error('发送消息失败:', error)
    alert('发送消息失败: ' + (error.message || '未知错误'))
  }
}

// 监听消息变化，自动滚动到底部
watch(discussionMessages, () => {
  if (isComponentUnmounted.value || !window.liveClassroomActive) return

  nextTick(() => {
    scrollToBottom()
  })
}, { deep: true })

// 滚动到底部
const scrollToBottom = () => {
  if (isComponentUnmounted.value || !window.liveClassroomActive) return

  nextTick(() => {
    const messagesEl = discussionMessagesEl.value || document.querySelector('.discussion-messages')
    if (messagesEl) {
      console.log('滚动到底部，元素高度:', messagesEl.scrollHeight)
      messagesEl.scrollTop = messagesEl.scrollHeight
    } else {
      console.warn('讨论区元素不存在，无法滚动')
    }
  })
}

// 获取文件图标
const getFileIcon = (type) => {
  const iconMap = {
    pdf: 'fas fa-file-pdf',
    doc: 'fas fa-file-word',
    docx: 'fas fa-file-word',
    xls: 'fas fa-file-excel',
    xlsx: 'fas fa-file-excel',
    ppt: 'fas fa-file-powerpoint',
    pptx: 'fas fa-file-powerpoint',
    jpg: 'fas fa-file-image',
    jpeg: 'fas fa-file-image',
    png: 'fas fa-file-image',
    zip: 'fas fa-file-archive',
    rar: 'fas fa-file-archive',
    txt: 'fas fa-file-alt',
    js: 'fab fa-js',
    html: 'fab fa-html5',
    css: 'fab fa-css3',
    default: 'fas fa-file'
  }

  return iconMap[type] || iconMap.default
}

// 格式化文件大小
const formatFileSize = (size) => {
  if (size < 1024) {
    return size + ' B'
  } else if (size < 1024 * 1024) {
    return (size / 1024).toFixed(2) + ' KB'
  } else if (size < 1024 * 1024 * 1024) {
    return (size / (1024 * 1024)).toFixed(2) + ' MB'
  } else {
    return (size / (1024 * 1024 * 1024)).toFixed(2) + ' GB'
  }
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  // 不显示年份，只显示月-日 时:分
  return `${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`
}

// 下载文件
const downloadFile = (file) => {
  // 检查组件是否已卸载
  if (isComponentUnmounted.value || !window.liveClassroomActive) {
    console.log('组件已卸载，取消下载文件')
    return
  }

  try {
    console.log('下载文件:', file.id, file.file_name)

    // 创建一个隐藏的a标签用于下载
    const downloadLink = document.createElement('a')

    // 设置下载链接
    downloadLink.href = `/api/classroom/files/${file.id}/download`

    // 设置下载文件名
    downloadLink.download = file.file_name

    // 添加到文档中
    document.body.appendChild(downloadLink)

    // 触发点击事件
    downloadLink.click()

    // 移除元素
    document.body.removeChild(downloadLink)
  } catch (error) {
    console.error('下载文件失败:', error)
    alert('下载文件失败: ' + (error.message || '未知错误'))
  }
}

// 清除所有定时器的函数
const clearAllTimers = () => {
  console.log('开始清除所有定时器')

  // 设置全局状态为非活动
  window.liveClassroomActive = false

  // 清除当前时间定时器
  if (timeTimer.value) {
    clearInterval(timeTimer.value)
    timeTimer.value = null
    console.log('已清除时间定时器')
  }

  // 清除讨论消息定时器
  if (discussionTimer.value) {
    clearInterval(discussionTimer.value)
    discussionTimer.value = null
    console.log('已清除讨论消息定时器')
  }

  // 清除课堂数据定时器
  if (classroomDataTimer.value) {
    clearInterval(classroomDataTimer.value)
    classroomDataTimer.value = null
    console.log('已清除课堂数据定时器')
  }

  // 清除可能存在的其他定时器
  const highestTimeoutId = setTimeout(';')
  for (let i = 0; i < highestTimeoutId; i++) {
    clearTimeout(i)
  }

  console.log('所有定时器已清除')
}

// 路由离开前的守卫
onBeforeRouteLeave((to, from, next) => {
  console.log('路由即将离开课堂页面')
  isComponentUnmounted.value = true
  clearAllTimers()
  next()
})

// 离开课堂
const leaveClassroom = () => {
  if (confirm('确定要离开课堂吗？')) {
    // 先标记组件已卸载，防止定时器中的API调用
    isComponentUnmounted.value = true
    // 清除所有定时器
    clearAllTimers()
    console.log('离开课堂，已清除所有定时器')
    // 延迟一点点再跳转，确保定时器已被清除
    setTimeout(() => {
      router.push('/classroom')
    }, 100)
  }
}

// 初始化数据
const initData = async () => {
  // 设置全局状态为活动，确保初始化能正常进行
  window.liveClassroomActive = true

  await getUserInfo()
  await getClassroomInfo()

  if (classroom.value.id) {
    console.log('初始化课堂数据，课堂ID:', classroom.value.id)
    try {
      await Promise.all([
        getClassroomMessages(),
        getClassroomFiles(),
        getDiscussionMessages()
      ])

      // 再次检查组件是否已卸载
      if (isComponentUnmounted.value) {
        console.log('组件在初始化过程中被卸载，取消设置定时器')
        window.liveClassroomActive = false
        return
      }

      console.log('初始化完成，讨论消息数量:', discussionMessages.value.length)

      // 设置当前时间定时器
      if (!timeTimer.value) {
        timeTimer.value = setInterval(() => {
          if (!isComponentUnmounted.value && window.liveClassroomActive) {
            currentTime.value = new Date().toLocaleTimeString()
          } else {
            clearInterval(timeTimer.value)
            timeTimer.value = null
          }
        }, 1000)
      }

      // 设置定时器，定期刷新数据
      if (!discussionTimer.value) {
        discussionTimer.value = setInterval(() => {
          if (!isComponentUnmounted.value && window.liveClassroomActive) {
            getDiscussionMessages()
          } else {
            clearInterval(discussionTimer.value)
            discussionTimer.value = null
          }
        }, 10000) // 每10秒刷新一次讨论消息，减少刷新频率
      }

      if (!classroomDataTimer.value) {
        classroomDataTimer.value = setInterval(() => {
          if (!isComponentUnmounted.value && window.liveClassroomActive) {
            getClassroomMessages()
            getClassroomFiles()
          } else {
            clearInterval(classroomDataTimer.value)
            classroomDataTimer.value = null
          }
        }, 30000) // 每30秒刷新一次留言和文件
      }
    } catch (error) {
      console.error('初始化数据失败:', error)
    }
  }
}

// 组件挂载后初始化数据
onMounted(() => {
  console.log('组件挂载')

  // 先清除可能存在的定时器
  clearAllTimers()

  // 重置组件卸载标记
  isComponentUnmounted.value = false

  // 设置全局状态为活动
  window.liveClassroomActive = true

  // 初始化数据
  initData()

  // 使用 nextTick 确保 DOM 已经渲染后设置引用
  nextTick(() => {
    discussionMessagesEl.value = document.querySelector('.discussion-messages')
    console.log('讨论区元素:', discussionMessagesEl.value)
  })
})

// 组件销毁时清除定时器
onUnmounted(() => {
  console.log('组件销毁，清除所有定时器')
  isComponentUnmounted.value = true
  clearAllTimers()
})
</script>

<style scoped>
.live-classroom-page {
  min-height: 100vh;
  background-color: #0d1117;
  color: #e6edf3;
}

.live-classroom-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  display: flex;
  flex-direction: column;
  height: calc(100vh - 70px); /* 减去导航栏高度 */
}

/* 课堂头部 */
.classroom-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 15px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  margin-bottom: 20px;
  flex-shrink: 0; /* 防止头部被压缩 */
}

.classroom-info h1 {
  font-size: 1.8rem;
  color: #4ecdc4;
  margin-bottom: 5px;
}

.classroom-meta {
  display: flex;
  gap: 15px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 5px;
  color: #a6accd;
  font-size: 0.9rem;
}

.action-btn {
  padding: 8px 16px;
  background: linear-gradient(135deg, #f25f5c, #e74c3c);
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: all 0.3s;
}

.action-btn:hover {
  background: linear-gradient(135deg, #e74c3c, #c0392b);
  transform: translateY(-2px);
}

/* 课堂内容区域 */
.classroom-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 20px;
  flex: 1;
  min-height: 0; /* 允许内容区域缩小 */
  max-height: calc(100vh - 300px); /* 限制最大高度，为讨论区留出空间 */
  overflow: hidden; /* 防止内容溢出 */
}

.section-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  flex-shrink: 0; /* 防止头部被压缩 */
}

.section-header h2 {
  font-size: 1.2rem;
  color: #4ecdc4;
  display: flex;
  align-items: center;
  gap: 8px;
}

/* 老师留言区 */
.teacher-message-section {
  background: #1e1e2e;
  border-radius: 10px;
  padding: 15px;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden; /* 防止内容溢出 */
}

.teacher-messages {
  flex: 1;
  overflow-y: auto; /* 启用垂直滚动 */
  padding-right: 5px;
}

.teacher-message {
  background: #2d2b40;
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 10px;
}

.message-content {
  color: #e6edf3;
  line-height: 1.5;
  margin-bottom: 8px;
}

.message-time {
  color: #a6accd;
  font-size: 0.8rem;
  text-align: right;
}

/* 课堂文件区 */
.classroom-files-section {
  background: #1e1e2e;
  border-radius: 10px;
  padding: 15px;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden; /* 防止内容溢出 */
}

.classroom-files {
  flex: 1;
  overflow-y: auto; /* 启用垂直滚动 */
  padding-right: 5px;
  max-height: 100%; /* 确保内容可以滚动 */
}

.file-item {
  display: flex;
  align-items: center;
  background: #2d2b40;
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 10px;
  transition: all 0.3s;
}

.file-item:hover {
  background: #363450;
}

.file-icon {
  font-size: 1.5rem;
  color: #4ecdc4;
  margin-right: 15px;
  flex-shrink: 0; /* 防止图标被压缩 */
}

.file-info {
  flex: 1;
  min-width: 0; /* 允许内容缩小 */
  overflow: hidden; /* 防止内容溢出 */
}

.file-name {
  font-weight: 500;
  color: #e6edf3;
  margin-bottom: 5px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis; /* 文件名过长时显示省略号 */
}

.file-meta {
  display: flex;
  gap: 15px;
  color: #a6accd;
  font-size: 0.8rem;
}

.file-actions {
  display: flex;
  gap: 10px;
  flex-shrink: 0; /* 防止操作按钮被压缩 */
}

.file-action-btn {
  background: none;
  border: none;
  color: #a6accd;
  font-size: 1rem;
  cursor: pointer;
  transition: color 0.3s;
}

.file-action-btn:hover {
  color: #4ecdc4;
}

/* 讨论区 */
.discussion-section {
  background: #1e1e2e;
  border-radius: 10px;
  padding: 15px;
  display: flex;
  flex-direction: column;
  height: 400px; /* 增加讨论区高度为原来的2倍 */
  flex-shrink: 0; /* 防止讨论区被压缩 */
  margin-top: auto; /* 将讨论区推到底部 */
}

.discussion-messages {
  flex: 1;
  overflow-y: auto; /* 启用垂直滚动 */
  padding-right: 5px;
  margin-bottom: 15px;
}

.discussion-message {
  display: flex;
  margin-bottom: 15px;
  padding: 0 10px;
}

.my-message {
  flex-direction: row-reverse;
}

.message-bubble {
  background: #2d2b40;
  border-radius: 12px;
  padding: 10px 15px;
  max-width: 80%; /* 增加消息气泡宽度 */
}

.my-message .message-bubble {
  background: #3a7bd5;
}

.message-sender {
  font-weight: 600;
  font-size: 0.9rem;
  margin-bottom: 5px;
}

.user-role {
  font-size: 0.8rem;
  color: #4ecdc4;
  font-weight: normal;
}

.student-info {
  font-size: 0.8rem;
  color: #a6accd;
  font-weight: normal;
  margin-left: 5px;
}

.discussion-input {
  display: flex;
  gap: 10px;
  flex-shrink: 0; /* 防止输入框被压缩 */
}

.discussion-input input {
  flex: 1;
  padding: 12px 15px;
  background: #2d2b40;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: #e6edf3;
  font-size: 1rem;
}

.discussion-input input:focus {
  outline: none;
  border-color: #4ecdc4;
}

.send-btn {
  padding: 0 15px;
  background: linear-gradient(135deg, #4ecdc4, #45b6af);
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.send-btn:hover {
  background: linear-gradient(135deg, #45b6af, #3ca49d);
}

.empty-message {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100px;
  color: #a6accd;
  font-style: italic;
}

/* 加载状态 */
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100px;
}

.loading-spinner {
  width: 30px;
  height: 30px;
  border: 3px solid rgba(78, 205, 196, 0.1);
  border-top: 3px solid #4ecdc4;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 10px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 滚动条样式 */
::-webkit-scrollbar {
  width: 6px;
}

::-webkit-scrollbar-track {
  background: #1e1e2e;
  border-radius: 3px;
}

::-webkit-scrollbar-thumb {
  background: #4ecdc4;
  border-radius: 3px;
}

::-webkit-scrollbar-thumb:hover {
  background: #45b6af;
}
</style>
