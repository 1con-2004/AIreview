<template>
  <div class="admin-classrooms">
    <div class="page-header">
      <h1>课堂管理</h1>
      <div class="header-actions">
        <div class="search-box">
          <i class="fas fa-search search-icon"></i>
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="搜索课堂标题、课堂码或描述..."
            @input="handleSearch"
          >
          <button v-if="searchQuery" class="clear-search" @click="clearSearch">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <button class="create-btn" @click="showCreateModal = true">
          <i class="fas fa-plus"></i> 创建新课堂
        </button>
      </div>
    </div>

    <!-- 课堂列表 -->
    <div class="classrooms-table">
      <div class="table-header">
        <div class="th">课堂码</div>
        <div class="th">课堂标题</div>
        <div class="th">课堂描述</div>
        <div class="th">创建者</div>
        <div class="th">创建时间</div>
        <div class="th">状态</div>
        <div class="th">操作</div>
      </div>
      
      <div v-if="loading" class="loading-container">
        <div class="loading-spinner"></div>
        <p>加载中...</p>
      </div>
      
      <div v-else-if="classrooms.length === 0" class="empty-data">
        <i class="fas fa-inbox"></i>
        <p>暂无课堂数据</p>
      </div>
      
      <div v-else class="table-body">
        <div v-for="classroom in paginatedClassrooms" :key="classroom.id" class="table-row">
          <div class="td classroom-code" style="font-size: 1.5em; font-weight: bold; color: #409eff;">{{ classroom.classroom_code }}</div>
          <div class="td classroom-title">{{ classroom.title }}</div>
          <div class="td classroom-description">{{ classroom.description || '-' }}</div>
          <div class="td classroom-teacher">{{ classroom.teacher_name }}</div>
          <div class="td classroom-time">{{ formatDate(classroom.created_at) }}</div>
          <div class="td classroom-status">
            <span :class="['status-badge', classroom.status ? 'status-active' : 'status-inactive']">
              {{ classroom.status ? '开放' : '关闭' }}
            </span>
          </div>
          <div class="td classroom-actions">
            <button class="action-btn" @click="openMessageModal(classroom)" title="课堂留言">
              <i class="fas fa-comment"></i>
            </button>
            <button class="action-btn" @click="openFileModal(classroom)" title="课堂文件">
              <i class="fas fa-file"></i>
            </button>
            <button class="action-btn" @click="toggleClassroomStatus(classroom)" title="课堂状态">
              <i :class="classroom.status ? 'fas fa-lock' : 'fas fa-lock-open'"></i>
            </button>
            <button class="action-btn delete-btn" @click="confirmDelete(classroom)" title="删除课堂">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
      </div>

      <!-- 分页组件 -->
      <div class="pagination" v-if="classrooms.length > 0">
        <button 
          :disabled="currentPage === 1" 
          @click="currentPage--"
        >
          <i class="fas fa-chevron-left"></i>
        </button>
        <span class="page-info">第 {{ currentPage }} 页，共 {{ totalPages }} 页</span>
        <button 
          :disabled="currentPage === totalPages" 
          @click="currentPage++"
        >
          <i class="fas fa-chevron-right"></i>
        </button>
      </div>
    </div>

    <!-- 创建课堂弹窗 -->
    <div v-if="showCreateModal" class="modal-backdrop" @click="showCreateModal = false"></div>
    <div v-if="showCreateModal" class="modal">
      <div class="modal-header">
        <h2>创建新课堂</h2>
        <button class="close-btn" @click="showCreateModal = false">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label>课堂标题</label>
          <input type="text" v-model="newClassroom.title" placeholder="请输入课堂标题">
        </div>
        <div class="form-group">
          <label>课堂描述</label>
          <textarea v-model="newClassroom.description" placeholder="请输入课堂描述"></textarea>
        </div>
        <button class="submit-btn" @click="createClassroom">创建课堂</button>
      </div>
    </div>

    <!-- 添加留言弹窗 -->
    <div v-if="showMessageModal" class="modal-backdrop" @click="closeMessageModal"></div>
    <div v-if="showMessageModal" class="modal">
      <div class="modal-header">
        <h2>课堂留言 - {{ currentClassroom.title }}</h2>
        <button class="close-btn" @click="closeMessageModal">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label>添加新留言</label>
          <textarea v-model="newMessage" placeholder="请输入留言内容"></textarea>
        </div>
        <button class="submit-btn" @click="addMessage">添加留言</button>
        
        <div class="message-list">
          <h3>已有留言</h3>
          <div v-if="messages.length === 0" class="empty-data">
            <p>暂无留言</p>
          </div>
          <div v-else class="message-items">
            <div v-for="message in messages" :key="message.id" class="message-item">
              <div class="message-content">{{ message.content }}</div>
              <div class="message-meta">
                <div class="message-time">{{ formatDate(message.created_at) }}</div>
                <button class="message-delete-btn" @click="confirmDeleteMessage(message)">
                  <i class="fas fa-trash"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 文件管理弹窗 -->
    <div v-if="showFileModal" class="modal-backdrop" @click="closeFileModal"></div>
    <div v-if="showFileModal" class="modal">
      <div class="modal-header">
        <h2>课堂文件 - {{ currentClassroom.title }}</h2>
        <button class="close-btn" @click="closeFileModal">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label>上传新文件</label>
          <div class="file-upload">
            <input type="file" ref="fileInputRef" @change="handleFileChange" style="display: none;">
            <button class="upload-btn" @click="triggerFileInput">
              <i class="fas fa-upload"></i> 上传文件
            </button>
          </div>
          <div v-if="uploadProgress > 0" class="upload-progress">
            <div class="progress-bar" :style="{width: uploadProgress + '%'}"></div>
            <span>{{ uploadProgress }}%</span>
          </div>
        </div>
        
        <div class="file-list">
          <h3>已上传文件</h3>
          <div v-if="files.length === 0" class="empty-data">
            <p>暂无文件</p>
          </div>
          <div v-else class="file-items">
            <div v-for="file in files" :key="file.id" class="file-item">
              <div class="file-icon">
                <i :class="getFileIcon(file.file_type)"></i>
              </div>
              <div class="file-info">
                <div class="file-name">{{ file.file_name }}</div>
                <div class="file-meta">
                  <span>{{ formatFileSize(file.file_size) }}</span>
                  <span>{{ formatDate(file.upload_time) }}</span>
                </div>
              </div>
              <div class="file-actions">
                <button class="action-btn download-btn" @click="downloadFile(file)">
                  <i class="fas fa-download"></i>
                </button>
                <button class="action-btn delete-btn" @click="confirmDeleteFile(file)">
                  <i class="fas fa-trash"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 确认删除弹窗 -->
    <div v-if="showDeleteConfirm" class="modal-backdrop" @click="showDeleteConfirm = false"></div>
    <div v-if="showDeleteConfirm" class="modal confirm-modal">
      <div class="modal-header">
        <h2>确认删除</h2>
        <button class="close-btn" @click="showDeleteConfirm = false">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="modal-body">
        <p>确定要删除课堂 "{{ currentClassroom.title }}" 吗？</p>
        <p class="warning-text">此操作将删除所有相关的留言、文件和讨论记录，且不可恢复！</p>
        <div class="confirm-actions">
          <button class="cancel-btn" @click="showDeleteConfirm = false">取消</button>
          <button class="delete-confirm-btn" @click="deleteClassroom">确认删除</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue';
import axios from 'axios';

// 状态变量
const classrooms = ref([]);
const loading = ref(true);
const showCreateModal = ref(false);
const showMessageModal = ref(false);
const showFileModal = ref(false);
const showDeleteConfirm = ref(false);
const currentClassroom = ref({});
const messages = ref([]);
const files = ref([]);
const newClassroom = ref({
  title: '',
  description: ''
});
const newMessage = ref('');
const uploadProgress = ref(0);

// 分页相关
const currentPage = ref(1);
const pageSize = 10;

// 添加搜索相关的响应式变量
const searchQuery = ref('');
const filteredClassrooms = computed(() => {
  if (!searchQuery.value) {
    return classrooms.value;
  }
  
  const query = searchQuery.value.toLowerCase();
  return classrooms.value.filter(classroom => {
    return classroom.title?.toLowerCase().includes(query) ||
           classroom.classroom_code?.toLowerCase().includes(query) ||
           classroom.description?.toLowerCase().includes(query);
  });
});

// 修改分页计算，使用过滤后的数据
const totalPages = computed(() => Math.ceil(filteredClassrooms.value.length / pageSize));

const paginatedClassrooms = computed(() => {
  const start = (currentPage.value - 1) * pageSize;
  const end = start + pageSize;
  return filteredClassrooms.value.slice(start, end);
});

// 监听页码变化，确保不超出范围
watch(currentPage, (newPage) => {
  if (newPage < 1) {
    currentPage.value = 1;
  } else if (newPage > totalPages.value) {
    currentPage.value = totalPages.value;
  }
});

// 获取用户信息
const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}');

// 获取课堂列表
const fetchClassrooms = async () => {
  try {
    loading.value = true;
    const response = await axios.get('/api/classroom');
    console.log('获取课堂列表响应:', response.data);
    
    const originalData = Array.isArray(response.data.data) ? response.data.data : [];
    classrooms.value = [...originalData];
  } catch (error) {
    console.error('获取课堂列表失败:', error);
    alert('获取课堂列表失败');
  } finally {
    loading.value = false;
  }
};

// 创建新课堂
const createClassroom = async () => {
  if (!newClassroom.value.title) {
    alert('请输入课堂标题');
    return;
  }
  
  try {
    const response = await axios.post('/api/classroom', {
      title: newClassroom.value.title,
      description: newClassroom.value.description,
      teacher_id: userInfo.id
    });
    
    alert(`创建成功，课堂码: ${response.data.data.classroom_code}`);
    showCreateModal.value = false;
    newClassroom.value = { title: '', description: '' };
    fetchClassrooms();
  } catch (error) {
    console.error('创建课堂失败:', error);
    alert('创建课堂失败');
  }
};

// 切换课堂状态
const toggleClassroomStatus = async (classroom) => {
  try {
    await axios.put(`/api/classroom/${classroom.id}`, {
      title: classroom.title,
      description: classroom.description,
      status: classroom.status ? 0 : 1
    });
    
    classroom.status = classroom.status ? 0 : 1;
  } catch (error) {
    console.error('更新课堂状态失败:', error);
    alert('更新课堂状态失败');
  }
};

// 显示留言弹窗
const openMessageModal = async (classroom) => {
  currentClassroom.value = classroom;
  showMessageModal.value = true;
  await fetchMessages(classroom.id);
};

// 关闭留言弹窗
const closeMessageModal = () => {
  showMessageModal.value = false;
  newMessage.value = '';
  messages.value = [];
};

// 获取课堂留言
const fetchMessages = async (classroomId) => {
  try {
    const response = await axios.get(`/api/classroom/${classroomId}/messages`);
    messages.value = response.data.data;
  } catch (error) {
    console.error('获取留言失败:', error);
    alert('获取留言失败');
  }
};

// 添加留言
const addMessage = async () => {
  if (!newMessage.value) {
    alert('请输入留言内容');
    return;
  }
  
  try {
    await axios.post(`/api/classroom/${currentClassroom.value.id}/messages`, {
      content: newMessage.value
    });
    
    newMessage.value = '';
    await fetchMessages(currentClassroom.value.id);
  } catch (error) {
    console.error('添加留言失败:', error);
    alert('添加留言失败');
  }
};

// 确认删除留言
const confirmDeleteMessage = (message) => {
  if (confirm(`确定要删除这条留言吗？此操作不可恢复！`)) {
    deleteMessage(message);
  }
};

// 删除留言
const deleteMessage = async (message) => {
  try {
    console.log(`删除留言: ID: ${message.id}`);
    await axios.delete(`/api/classroom/messages/${message.id}`);
    await fetchMessages(currentClassroom.value.id);
  } catch (error) {
    console.error('删除留言失败:', error);
    alert('删除留言失败: ' + (error.response?.data?.message || error.message));
  }
};

// 显示文件弹窗
const openFileModal = async (classroom) => {
  currentClassroom.value = classroom;
  showFileModal.value = true;
  await fetchFiles(classroom.id);
};

// 关闭文件弹窗
const closeFileModal = () => {
  showFileModal.value = false;
  files.value = [];
  uploadProgress.value = 0;
};

// 获取课堂文件
const fetchFiles = async (classroomId) => {
  try {
    const response = await axios.get(`/api/classroom/${classroomId}/files`);
    files.value = response.data.data;
  } catch (error) {
    console.error('获取文件列表失败:', error);
    alert('获取文件列表失败');
  }
};

// 处理文件选择
const handleFileChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    uploadFile(file);
  }
};

// 触发文件选择对话框
const triggerFileInput = () => {
  if (fileInputRef.value) {
    fileInputRef.value.click();
  } else {
    console.error('文件输入元素不存在');
  }
};

// 上传文件
const uploadFile = async (file) => {
  if (!file) {
    alert('请选择文件');
    return;
  }
  
  // 检查文件大小
  if (file.size > 10 * 1024 * 1024) {
    alert('文件大小不能超过10MB');
    return;
  }
  
  const formData = new FormData();
  formData.append('file', file);
  
  try {
    uploadProgress.value = 0;
    
    await axios.post(`/api/classroom/${currentClassroom.value.id}/files`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      },
      onUploadProgress: (progressEvent) => {
        uploadProgress.value = Math.round((progressEvent.loaded * 100) / progressEvent.total);
      }
    });
    
    // 重置文件输入
    if (fileInputRef.value) {
      fileInputRef.value.value = '';
    }
    uploadProgress.value = 0;
    await fetchFiles(currentClassroom.value.id);
  } catch (error) {
    console.error('上传文件失败:', error);
    alert('上传文件失败: ' + (error.response?.data?.message || error.message));
    uploadProgress.value = 0;
  }
};

// 下载文件
const downloadFile = async (file) => {
  try {
    console.log(`下载文件: ${file.file_name}, ID: ${file.id}`);
    
    // 使用axios进行文件下载
    const response = await axios({
      url: `/api/classroom/files/${file.id}/download`,
      method: 'GET',
      responseType: 'blob', // 重要：设置响应类型为blob
    });
    
    // 创建一个临时的URL对象
    const url = window.URL.createObjectURL(new Blob([response.data]));
    
    // 创建一个临时的a标签
    const link = document.createElement('a');
    link.href = url;
    
    // 使用原始文件名作为下载文件名
    const fileName = file.file_name;
    console.log('下载文件名:', fileName);
    
    // 设置下载的文件名
    link.setAttribute('download', fileName);
    document.body.appendChild(link);
    
    // 模拟点击下载
    link.click();
    
    // 清理
    window.URL.revokeObjectURL(url);
    document.body.removeChild(link);
  } catch (error) {
    console.error('下载文件失败:', error);
    alert('下载文件失败: ' + (error.response?.data?.message || error.message));
  }
};

// 确认删除
const confirmDelete = (classroom) => {
  currentClassroom.value = classroom;
  showDeleteConfirm.value = true;
};

// 删除课堂
const deleteClassroom = async () => {
  try {
    await axios.delete(`/api/classroom/${currentClassroom.value.id}`);
    showDeleteConfirm.value = false;
    fetchClassrooms();
  } catch (error) {
    console.error('删除课堂失败:', error);
    alert('删除课堂失败');
  }
};

// 确认删除文件
const confirmDeleteFile = (file) => {
  if (confirm(`确定要删除文件 "${file.file_name}" 吗？此操作不可恢复！`)) {
    deleteFile(file);
  }
};

// 删除文件
const deleteFile = async (file) => {
  try {
    console.log(`删除文件: ${file.file_name}, ID: ${file.id}`);
    await axios.delete(`/api/classroom/files/${file.id}`);
    await fetchFiles(currentClassroom.value.id);
  } catch (error) {
    console.error('删除文件失败:', error);
    alert('删除文件失败: ' + (error.response?.data?.message || error.message));
  }
};

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
};

// 格式化文件大小
const formatFileSize = (size) => {
  if (size < 1024) {
    return size + ' B';
  } else if (size < 1024 * 1024) {
    return (size / 1024).toFixed(2) + ' KB';
  } else if (size < 1024 * 1024 * 1024) {
    return (size / (1024 * 1024)).toFixed(2) + ' MB';
  } else {
    return (size / (1024 * 1024 * 1024)).toFixed(2) + ' GB';
  }
};

// 获取文件图标
const getFileIcon = (type) => {
  const iconMap = {
    'pdf': 'fas fa-file-pdf',
    'doc': 'fas fa-file-word',
    'docx': 'fas fa-file-word',
    'xls': 'fas fa-file-excel',
    'xlsx': 'fas fa-file-excel',
    'ppt': 'fas fa-file-powerpoint',
    'pptx': 'fas fa-file-powerpoint',
    'jpg': 'fas fa-file-image',
    'jpeg': 'fas fa-file-image',
    'png': 'fas fa-file-image',
    'zip': 'fas fa-file-archive',
    'rar': 'fas fa-file-archive',
    'txt': 'fas fa-file-alt',
    'js': 'fab fa-js',
    'html': 'fab fa-html5',
    'css': 'fab fa-css3',
    'default': 'fas fa-file'
  };
  
  return iconMap[type] || iconMap.default;
};

// 搜索处理函数
const handleSearch = () => {
  currentPage.value = 1; // 重置页码到第一页
};

// 清除搜索
const clearSearch = () => {
  searchQuery.value = '';
  currentPage.value = 1;
};

// 组件挂载时获取数据
onMounted(() => {
  fetchClassrooms();
});
</script>

<style scoped>
.admin-classrooms {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.page-header h1 {
  font-size: 24px;
  color: #333;
  margin: 0;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}

.search-box {
  position: relative;
  width: 300px;
}

.search-box input {
  width: 100%;
  padding: 10px 36px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: white;
}

.search-box input:focus {
  border-color: #4ecdc4;
  box-shadow: 0 0 0 3px rgba(78, 205, 196, 0.1);
  outline: none;
}

.search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #909399;
}

.clear-search {
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #909399;
  cursor: pointer;
  padding: 4px;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.clear-search:hover {
  background: #f5f5f5;
  color: #606266;
}

.create-btn {
  background: linear-gradient(135deg, #4ecdc4, #45b6af);
  color: white;
  border: none;
  border-radius: 8px;
  padding: 10px 16px;
  font-size: 14px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s;
}

.create-btn:hover {
  background: linear-gradient(135deg, #45b6af, #3ca49d);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* 表格样式 */
.classrooms-table {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  width: 100%;
}

.table-header {
  display: grid;
  grid-template-columns: 10% 15% 25% 10% 15% 10% 15%;
  background: #f5f7fa;
  padding: 16px;
  font-weight: 600;
  color: #606266;
}

.table-row {
  display: grid;
  grid-template-columns: 10% 15% 25% 10% 15% 10% 15%;
  padding: 16px;
  border-top: 1px solid #ebeef5;
  transition: background 0.3s;
}

.table-row:hover {
  background: #f5f7fa;
}

.th, .td {
  display: flex;
  align-items: center;
  padding: 0 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.classroom-code {
  font-family: monospace;
  font-weight: 600;
  color: #409eff;
}

.classroom-title {
  font-weight: 500;
}

.classroom-description {
  color: #606266;
  font-size: 0.9em;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.classroom-teacher {
  font-weight: 500;
}

.classroom-actions {
  display: flex;
  gap: 8px;
  justify-content: flex-start;
  flex-wrap: wrap;
}

.action-btn {
  width: 32px;
  height: 32px;
  border-radius: 4px;
  border: none;
  background: #f5f7fa;
  color: #606266;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.action-btn:hover {
  background: #ecf5ff;
  color: #409eff;
}

.delete-btn:hover {
  background: #fef0f0;
  color: #f56c6c;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.status-active {
  background: #f0f9eb;
  color: #67c23a;
}

.status-inactive {
  background: #f4f4f5;
  color: #909399;
}

/* 加载状态 */
.loading-container {
  padding: 40px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #f3f3f3;
  border-top: 3px solid #4ecdc4;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 空数据状态 */
.empty-data {
  padding: 40px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #909399;
}

.empty-data i {
  font-size: 48px;
  margin-bottom: 16px;
  opacity: 0.5;
}

/* 弹窗样式 */
.modal-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  z-index: 1000;
}

.modal {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background: white;
  border-radius: 8px;
  width: 90%;
  max-width: 600px;
  z-index: 1001;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  border-bottom: 1px solid #ebeef5;
}

.modal-header h2 {
  margin: 0;
  font-size: 18px;
  color: #303133;
}

.close-btn {
  background: none;
  border: none;
  font-size: 18px;
  color: #909399;
  cursor: pointer;
}

.modal-body {
  padding: 24px;
  max-height: 70vh;
  overflow-y: auto;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
  color: #606266;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  font-size: 14px;
  transition: border-color 0.3s;
}

.form-group textarea {
  min-height: 100px;
  resize: vertical;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #4ecdc4;
}

.submit-btn {
  width: 100%;
  padding: 12px;
  background: linear-gradient(135deg, #4ecdc4, #45b6af);
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s;
}

.submit-btn:hover {
  background: linear-gradient(135deg, #45b6af, #3ca49d);
}

/* 留言列表样式 */
.message-list {
  margin-top: 24px;
}

.message-list h3 {
  font-size: 16px;
  margin-bottom: 16px;
  color: #303133;
}

.message-items {
  max-height: 300px;
  overflow-y: auto;
}

.message-item {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 12px 16px;
  margin-bottom: 12px;
}

.message-content {
  margin-bottom: 8px;
  line-height: 1.5;
}

.message-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.message-time {
  font-size: 12px;
  color: #909399;
}

.message-delete-btn {
  background: none;
  border: none;
  color: #909399;
  cursor: pointer;
  transition: all 0.3s;
  padding: 4px 8px;
  border-radius: 4px;
}

.message-delete-btn:hover {
  color: #f56c6c;
  background: #fef0f0;
}

/* 文件上传样式 */
.file-upload {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
}

.file-upload input[type="file"] {
  display: none;
}

.upload-btn {
  padding: 10px 16px;
  background: #409eff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s;
}

.upload-btn:hover {
  background: #66b1ff;
}

.upload-progress {
  height: 6px;
  background: #ebeef5;
  border-radius: 3px;
  margin-top: 8px;
  position: relative;
}

.progress-bar {
  height: 100%;
  background: #4ecdc4;
  border-radius: 3px;
  transition: width 0.3s;
}

.upload-progress span {
  position: absolute;
  right: 0;
  top: -20px;
  font-size: 12px;
  color: #606266;
}

/* 文件列表样式 */
.file-list {
  margin-top: 24px;
}

.file-list h3 {
  font-size: 16px;
  margin-bottom: 16px;
  color: #303133;
}

.file-items {
  max-height: 300px;
  overflow-y: auto;
}

.file-item {
  display: flex;
  align-items: center;
  background: #f5f7fa;
  border-radius: 8px;
  padding: 12px 16px;
  margin-bottom: 12px;
}

.file-icon {
  font-size: 24px;
  color: #409eff;
  margin-right: 16px;
}

.file-info {
  flex: 1;
}

.file-name {
  font-weight: 500;
  margin-bottom: 4px;
}

.file-meta {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: #909399;
}

.file-actions {
  display: flex;
  gap: 12px;
}

.download-btn {
  background: #ecf5ff;
  color: #409eff;
}

.download-btn:hover {
  background: #409eff;
  color: white;
}

.delete-btn {
  background: #fef0f0;
  color: #f56c6c;
}

.delete-btn:hover {
  background: #f56c6c;
  color: white;
}

/* 确认删除弹窗 */
.confirm-modal {
  max-width: 400px;
}

.warning-text {
  color: #f56c6c;
  font-weight: 500;
}

.confirm-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 24px;
}

.cancel-btn {
  padding: 8px 16px;
  background: #f5f7fa;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  color: #606266;
  cursor: pointer;
  transition: all 0.3s;
}

.cancel-btn:hover {
  background: #ebeef5;
}

.delete-confirm-btn {
  padding: 8px 16px;
  background: #f56c6c;
  border: none;
  border-radius: 4px;
  color: white;
  cursor: pointer;
  transition: all 0.3s;
}

.delete-confirm-btn:hover {
  background: #f78989;
}

/* 分页样式 */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 24px;
  padding: 10px;
}

.pagination button {
  padding: 8px 16px;
  border-radius: 8px;
  border: none;
  background: white;
  color: #007AFF;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.pagination button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination button:not(:disabled):hover {
  background: rgba(0, 122, 255, 0.1);
}

.page-info {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

/* 响应式调整 */
@media (max-width: 1200px) {
  .table-header, .table-row {
    grid-template-columns: 10% 15% 20% 10% 15% 10% 20%;
  }
}

@media (max-width: 992px) {
  .table-header, .table-row {
    grid-template-columns: 15% 20% 20% 15% 15% 15%;
  }
  
  .classroom-description {
    display: none;
  }
}

@media (max-width: 768px) {
  .table-header, .table-row {
    grid-template-columns: 20% 30% 25% 25%;
  }
  
  .classroom-teacher, .classroom-time {
    display: none;
  }
  
  .search-box {
    width: 100%;
    margin-bottom: 10px;
  }
  
  .header-actions {
    flex-direction: column;
    align-items: stretch;
  }
}

@media (max-width: 576px) {
  .table-header, .table-row {
    grid-template-columns: 30% 40% 30%;
  }
  
  .classroom-status {
    display: none;
  }
}
</style> 