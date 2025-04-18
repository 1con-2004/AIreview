<template>
  <div class="students-management">
    <div class="action-bar">
      <div class="search-box">
        <input
          type="text"
          v-model="searchQuery"
          placeholder="搜索学号或姓名..."
          @input="handleSearch"
        />
        <button 
          v-if="/^\d+$/.test(searchQuery.trim())"
          class="exact-search-btn"
          :class="{ active: exactSearch }"
          @click="exactSearch = !exactSearch"
        >
          精确搜索
        </button>
      </div>
      <div class="action-buttons">
        <button class="btn-create" @click="openCreateClassDialog">
          <i class="fas fa-users"></i>
          新建班级信息
        </button>
        <button class="btn-create" @click="openCreateDialog">
          <i class="fas fa-plus"></i>
          新建学生信息
        </button>
      </div>
    </div>

    <!-- 新建学生信息表单 -->
    <el-dialog title="新建学生信息" v-model="showDialog" width="50%">
      <el-form :model="form" ref="formRef" :rules="formRules" label-width="100px">
        <el-form-item label="用户名" prop="username">
          <el-autocomplete
            v-model="form.username"
            :fetch-suggestions="searchUsers"
            placeholder="请输入用户名(初始英文ID)"
            :trigger-on-focus="true"
            @select="handleUserSelect"
            :loading="userSearchLoading"
          >
            <template #default="{ item }">
              <div class="user-option">
                <img :src="getFullAvatarUrl(item.avatar)" class="option-avatar">
                <span>{{ item.username }}</span>
                <span v-if="item.display_name" class="display-name">({{ item.display_name }})</span>
              </div>
            </template>
          </el-autocomplete>
        </el-form-item>
        <el-form-item label="学号" prop="student_no">
          <el-input v-model="form.student_no"></el-input>
        </el-form-item>
        <el-form-item label="姓名" prop="real_name">
          <el-input v-model="form.real_name"></el-input>
        </el-form-item>
        <el-form-item label="院系" prop="department">
          <el-input v-model="form.department"></el-input>
        </el-form-item>
        <el-form-item label="专业" prop="major">
          <el-input v-model="form.major"></el-input>
        </el-form-item>
        <el-form-item label="年级" prop="grade">
          <el-input v-model="form.grade"></el-input>
        </el-form-item>
        <el-form-item label="班级" prop="class_id">
          <el-autocomplete
            v-model="form.class_name"
            :fetch-suggestions="searchClasses"
            placeholder="请输入班级名称"
            :trigger-on-focus="true"
            @select="handleClassSelect"
          >
            <template #default="{ item }">
              <div class="class-option">
                <span>{{ item.class_name }}</span>
              </div>
            </template>
          </el-autocomplete>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showDialog = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>

    <div class="students-table">
      <div class="table-header">
        <div class="col-avatar">头像</div>
        <div class="col-student-no">学号</div>
        <div class="col-name">姓名</div>
        <div class="col-department">院系</div>
        <div class="col-major">专业</div>
        <div class="col-grade">年级</div>
        <div class="col-class">班级</div>
        <div class="col-actions">操作</div>
      </div>
      <div class="table-body">
        <div v-for="student in filteredStudents" :key="student.id" class="table-row">
          <div class="col-avatar">
            <img :src="getFullAvatarUrl(student.avatar_url)" class="avatar-img">
          </div>
          <div class="col-student-no">{{ student.student_no }}</div>
          <div class="col-name">{{ student.real_name }}</div>
          <div class="col-department">{{ student.department }}</div>
          <div class="col-major">{{ student.major }}</div>
          <div class="col-grade">{{ student.grade }}</div>
          <div class="col-class">{{ student.class_name }}</div>
          <div class="col-actions">
            <button class="btn-edit" @click="editStudent(student)">
              <i class="fas fa-edit"></i>
            </button>
            <button class="btn-delete" @click="deleteStudent(student)">
              <i class="fas fa-trash"></i>
            </button>
            <button class="btn-class-manage" v-if="student.class_id" @click="manageClass(student)">
              <i class="fas fa-users-cog"></i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 分页组件 -->
    <div class="pagination" v-if="students.length > 0">
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

    <!-- 编辑学生信息弹窗 -->
    <el-dialog
      title="编辑学生信息"
      v-model="showEditDialog"
      width="50%"
    >
      <el-form :model="editForm" ref="editFormRef" :rules="formRules" label-width="100px">
        <el-form-item label="学号" prop="student_no">
          <el-input v-model="editForm.student_no"></el-input>
        </el-form-item>
        <el-form-item label="姓名" prop="real_name">
          <el-input v-model="editForm.real_name"></el-input>
        </el-form-item>
        <el-form-item label="院系" prop="department">
          <el-input v-model="editForm.department"></el-input>
        </el-form-item>
        <el-form-item label="专业" prop="major">
          <el-input v-model="editForm.major"></el-input>
        </el-form-item>
        <el-form-item label="年级" prop="grade">
          <el-input v-model="editForm.grade"></el-input>
        </el-form-item>
        <el-form-item label="班级" prop="class_id">
          <el-autocomplete
            v-model="editForm.class_name"
            :fetch-suggestions="searchClasses"
            placeholder="请输入班级名称"
            :trigger-on-focus="true"
            @select="handleEditClassSelect"
          >
            <template #default="{ item }">
              <div class="class-option">
                <span>{{ item.class_name }}</span>
              </div>
            </template>
          </el-autocomplete>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showEditDialog = false">取消</el-button>
          <el-button type="primary" @click="submitEdit">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 删除确认弹窗 -->
    <el-dialog
      title="确认删除"
      v-model="showDeleteDialog"
      width="30%"
    >
      <div class="delete-confirm">
        <i class="fas fa-exclamation-triangle"></i>
        <p>确定要删除该学生信息吗？此操作不可恢复。</p>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showDeleteDialog = false">取消</el-button>
          <el-button type="danger" @click="confirmDelete">确定删除</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 新建班级信息弹窗 -->
    <el-dialog title="新建班级信息" v-model="showClassDialog" width="50%">
      <el-form :model="classForm" ref="classFormRef" :rules="classFormRules" label-width="100px">
        <el-form-item label="班级名称" prop="class_name">
          <el-input v-model="classForm.class_name" placeholder="请输入班级名称"></el-input>
        </el-form-item>
        
        <div class="student-management-section">
          <h3>学生管理</h3>
          <div class="student-search">
            <el-input
              v-model="studentSearchQuery"
              placeholder="输入学号搜索学生..."
              @keyup.enter="handleStudentSearch"
              style="width: 200px;"
            >
              <template #append>
                <el-button @click="handleStudentSearch">
                  <i class="fas fa-search"></i>
                </el-button>
              </template>
            </el-input>
          </div>

          <div class="selected-students">
            <h4>已选择的学生：</h4>
            <el-tag
              v-for="student in selectedStudents"
              :key="student.student_no"
              closable
              @close="removeSelectedStudent(student)"
              style="margin: 4px;"
            >
              {{ student.student_no }} - {{ student.real_name }}
            </el-tag>
          </div>

          <div v-if="searchResults.length > 0" class="search-results">
            <h4>搜索结果：</h4>
            <div
              v-for="student in searchResults"
              :key="student.student_no"
              class="search-result-item"
              @click="addStudent(student)"
            >
              <img :src="getFullAvatarUrl(student.avatar_url)" class="mini-avatar">
              <span>{{ student.student_no }} - {{ student.real_name }}</span>
            </div>
          </div>
        </div>
      </el-form>
      <template #footer>
        <el-button @click="showClassDialog = false">取消</el-button>
        <el-button type="primary" @click="submitClassForm">确定</el-button>
      </template>
    </el-dialog>

    <!-- 班级管理弹窗 -->
    <el-dialog
      title="班级管理"
      v-model="showClassManageDialog"
      width="60%"
    >
      <div v-if="currentClass" class="class-manage-container">
        <div class="class-info">
          <div class="class-header">
            <h3>班级信息</h3>
            <div class="class-stats">
              <div class="stat-item">
                <span class="stat-label">班级人数:</span>
                <span class="stat-value">{{ classStudentsCount }}</span>
              </div>
            </div>
          </div>
          
          <el-form :model="classManageForm" ref="classManageFormRef" label-width="100px">
            <el-form-item label="班级名称" prop="class_name">
              <el-input v-model="classManageForm.class_name" placeholder="请输入班级名称"></el-input>
            </el-form-item>
          </el-form>
          
          <div class="class-students-section">
            <h3>班级学生</h3>
            <div class="student-search">
              <el-input
                v-model="classStudentSearchQuery"
                placeholder="输入学号搜索学生..."
                @keyup.enter="handleClassStudentSearch"
                style="width: 200px;"
              >
                <template #append>
                  <el-button @click="handleClassStudentSearch">
                    <i class="fas fa-search"></i>
                  </el-button>
                </template>
              </el-input>
            </div>

            <div class="class-students-list">
              <h4>当前班级学生：</h4>
              <div v-if="classStudents.length === 0" class="empty-state">
                该班级暂无学生
              </div>
              <div v-else class="students-table mini-table">
                <div class="mini-table-header">
                  <div class="mini-col-avatar">头像</div>
                  <div class="mini-col-student-no">学号</div>
                  <div class="mini-col-name">姓名</div>
                  <div class="mini-col-actions">操作</div>
                </div>
                <div class="mini-table-body">
                  <div v-for="student in classStudents" :key="student.id" class="mini-table-row">
                    <div class="mini-col-avatar">
                      <img :src="getFullAvatarUrl(student.avatar_url)" class="mini-avatar">
                    </div>
                    <div class="mini-col-student-no">{{ student.student_no }}</div>
                    <div class="mini-col-name">{{ student.real_name }}</div>
                    <div class="mini-col-actions">
                      <button class="btn-remove" @click="removeStudentFromClass(student)">
                        <i class="fas fa-user-minus"></i>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div v-if="classSearchResults.length > 0" class="search-results">
              <h4>搜索结果：</h4>
              <div
                v-for="student in classSearchResults"
                :key="student.student_no"
                class="search-result-item"
                @click="addStudentToClass(student)"
              >
                <img :src="getFullAvatarUrl(student.avatar_url)" class="mini-avatar">
                <span>{{ student.student_no }} - {{ student.real_name }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showClassManageDialog = false">取消</el-button>
          <el-button type="primary" @click="saveClassChanges">保存更改</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useToast } from 'primevue/usetoast'
import axios from 'axios'

const toast = useToast()
const students = ref([])
const showDialog = ref(false)
const isEditing = ref(false)
const form = ref(initForm())
const searchQuery = ref('')
const exactSearch = ref(false)
const userOptions = ref([])
const userSearchLoading = ref(false)
const showEditDialog = ref(false)
const showDeleteDialog = ref(false)
const currentStudent = ref(null)
const editForm = ref({
  student_no: '',
  real_name: '',
  department: '',
  major: '',
  grade: '',
  class_id: null,
  class_name: ''
})
const editFormRef = ref(null)
const showClassDialog = ref(false)
const classForm = ref({
  class_name: '',
  student_nos: []
})
const studentSearchQuery = ref('')
const searchResults = ref([])
const selectedStudents = ref([])
const classFormRef = ref(null)
const classFormRules = {
  class_name: [{ required: true, message: '请输入班级名称', trigger: 'blur' }],
  student_nos: [{ required: true, message: '请选择学生', trigger: 'blur' }]
}
const currentPage = ref(1)
const pageSize = ref(10)
const totalPages = computed(() => Math.ceil(students.value.length / pageSize.value))
const showClassManageDialog = ref(false)
const currentClass = ref(null)
const classStudents = ref([])
const classStudentsCount = ref(0)
const classStudentSearchQuery = ref('')
const classSearchResults = ref([])
const classManageForm = ref({
  class_id: null,
  class_name: ''
})
const classManageFormRef = ref(null)

const formRules = {
  username: [{ required: true, message: '请选择关联用户', trigger: 'blur' }],
  student_no: [
    { required: true, message: '请输入学号', trigger: 'blur' },
    { pattern: /^\d{10,15}$/, message: '学号应为10-15位数字', trigger: 'blur' }
  ],
  real_name: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }]
}

// 添加获取头像URL的函数
const getFullAvatarUrl = (url) => {
  if (!url) return 'http://localhost:3000/uploads/avatars/default-avatar.png';
  if (url.startsWith('http')) return url;
  
  // 处理数据库中存储的路径，确保使用正确的URL格式
  // 数据库中存储的格式为 public/uploads/avatars/filename.jpeg
  // 需要转换为 http://localhost:3000/uploads/avatars/filename.jpeg
  if (url.includes('public/uploads/avatars/')) {
    // 提取文件名
    const fileName = url.split('/').pop();
    return `http://localhost:3000/uploads/avatars/${fileName}`;
  }
  
  // 处理其他情况
  return `http://localhost:3000${url}`;
}

async function fetchStudents() {
  try {
    const res = await axios.get('/api/admin/students')
    students.value = res.data.data
    currentPage.value = 1 // 重置当前页为1
  } catch (error) {
    handleError(error, '获取学生列表失败')
  }
}

async function searchUsers(query, cb) {
  if (!query) {
    cb([])
    return
  }
  
  userSearchLoading.value = true
  try {
    const res = await axios.get(`/api/users/search?q=${query}`)
    const suggestions = res.data.data.map(user => ({
      value: user.username,
      username: user.username,
      avatar: user.avatar_url ? getFullAvatarUrl(user.avatar_url) : '/src/assets/images/default-avatar.png',
      display_name: user.display_name,
      id: user.id
    }))
    cb(suggestions)
  } catch (error) {
    handleError(error, '用户搜索失败')
    cb([])
  } finally {
    userSearchLoading.value = false
  }
}

function handleUserSelect(item) {
  form.value.user_id = item.id // 保存用户ID
  form.value.username = item.username // 保存用户名用于显示
}

const filteredStudents = computed(() => {
  const query = searchQuery.value.toLowerCase()
  const filtered = students.value.filter(student => {
    if (!query) return true
    
    if (exactSearch.value) {
      return student.student_no === query
    }
    return student.student_no.includes(query) || 
           student.real_name.toLowerCase().includes(query)
  })
  
  // 分页处理
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return filtered.slice(start, end) // 只返回当前页的学生
})

function openCreateDialog() {
  isEditing.value = false
  form.value = initForm()
  showDialog.value = true
}

async function submitForm() {
  try {
    if (!form.value.user_id) {
      toast.add({ severity: 'error', summary: '错误', detail: '请选择用户' })
      return
    }

    await axios.post('/api/admin/students', {
      user_id: form.value.user_id,
      student_no: form.value.student_no,
      real_name: form.value.real_name,
      department: form.value.department,
      major: form.value.major,
      grade: form.value.grade,
      class_id: form.value.class_id
    })
    toast.add({ severity: 'success', summary: '成功', detail: '学生信息创建成功' })
    showDialog.value = false
    fetchStudents()
  } catch (error) {
    handleError(error, '创建学生信息失败')
  }
}

function initForm() {
  return {
    username: '',
    user_id: '',
    student_no: '',
    real_name: '',
    department: '',
    major: '',
    grade: '',
    class_id: null,
    class_name: ''
  }
}

function handleError(error, message) {
  console.error(message, error)
  toast.add({ severity: 'error', summary: '错误', detail: `${message}: ${error.response?.data?.message || error.message}` })
}

// 编辑学生信息
function editStudent(student) {
  currentStudent.value = student
  editForm.value = {
    student_no: student.student_no,
    real_name: student.real_name,
    department: student.department,
    major: student.major,
    grade: student.grade,
    class_id: student.class_id,
    class_name: student.class_name
  }
  showEditDialog.value = true
}

// 提交编辑
async function submitEdit() {
  try {
    await editFormRef.value.validate()
    const response = await axios.put(`/api/admin/students/${currentStudent.value.id}`, {
      student_no: editForm.value.student_no,
      real_name: editForm.value.real_name,
      department: editForm.value.department,
      major: editForm.value.major,
      grade: editForm.value.grade,
      class_id: editForm.value.class_id
    })
    if (response.data.success) {
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: '学生信息更新成功',
        life: 3000
      })
      showEditDialog.value = false
      fetchStudents() // 刷新列表
    }
  } catch (error) {
    handleError(error, '更新学生信息失败')
  }
}

// 删除学生信息
function deleteStudent(student) {
  currentStudent.value = student
  showDeleteDialog.value = true
}

// 确认删除
async function confirmDelete() {
  try {
    const response = await axios.delete(`/api/admin/students/${currentStudent.value.id}`)
    if (response.data.success) {
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: '学生信息删除成功',
        life: 3000
      })
      showDeleteDialog.value = false
      fetchStudents() // 刷新列表
    }
  } catch (error) {
    handleError(error, '删除学生信息失败')
  }
}

function openCreateClassDialog() {
  showClassDialog.value = true
  classForm.value = {
    class_name: '',
    student_nos: []
  }
  studentSearchQuery.value = ''
  searchResults.value = []
  selectedStudents.value = []
}

async function handleStudentSearch() {
  if (!studentSearchQuery.value.trim()) {
    toast.add({
      severity: 'warn',
      summary: '提示',
      detail: '请输入学号',
      life: 3000
    })
    return
  }

  try {
    const res = await axios.get('/api/admin/classes/search-students', {
      params: {
        student_no: studentSearchQuery.value.trim()
      }
    })
    searchResults.value = res.data.data
    
    if (searchResults.value.length === 0) {
      toast.add({
        severity: 'info',
        summary: '提示',
        detail: '未找到相关学生',
        life: 3000
      })
    }
  } catch (error) {
    handleError(error, '搜索学生失败')
  }
}

function addStudent(student) {
  selectedStudents.value.push(student)
  classForm.value.student_nos.push(student.student_no)
  searchResults.value = searchResults.value.filter(s => s.student_no !== student.student_no)
}

function removeSelectedStudent(student) {
  selectedStudents.value = selectedStudents.value.filter(s => s.student_no !== student.student_no)
  classForm.value.student_nos = classForm.value.student_nos.filter(s => s !== student.student_no)
  searchResults.value.push(student)
}

async function submitClassForm() {
  try {
    await classFormRef.value.validate()
    const response = await axios.post('/api/admin/classes', classForm.value)
    if (response.data.success) {
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: '班级信息创建成功',
        life: 3000
      })
      showClassDialog.value = false
      fetchStudents() // 刷新列表
    }
  } catch (error) {
    handleError(error, '创建班级信息失败')
  }
}

async function searchClasses(query, cb) {
  if (!query) {
    cb([])
    return
  }
  
  try {
    const res = await axios.get('/api/admin/classes/search', {
      params: { class_name: query }
    })
    cb(res.data.data)
  } catch (error) {
    handleError(error, '搜索班级失败')
    cb([])
  }
}

function handleClassSelect(item) {
  form.value.class_id = item.id
  form.value.class_name = item.class_name
}

function handleEditClassSelect(item) {
  editForm.value.class_id = item.id
  editForm.value.class_name = item.class_name
}

// 添加页码变化监听
watch(currentPage, (newPage) => {
  if (newPage < 1) {
    currentPage.value = 1
  } else if (newPage > totalPages.value) {
    currentPage.value = totalPages.value
  }
})

// 班级管理
function manageClass(student) {
  if (!student.class_id) return
  
  currentClass.value = {
    id: student.class_id,
    class_name: student.class_name
  }
  
  classManageForm.value = {
    class_id: student.class_id,
    class_name: student.class_name
  }
  
  fetchClassStudents(student.class_id)
  showClassManageDialog.value = true
}

// 获取班级学生
async function fetchClassStudents(classId) {
  try {
    const res = await axios.get(`/api/admin/classes/${classId}/students`)
    classStudents.value = res.data.data
    classStudentsCount.value = res.data.count || classStudents.value.length
    console.log('班级学生列表:', classStudents.value)
  } catch (error) {
    handleError(error, '获取班级学生列表失败')
  }
}

// 搜索可添加到班级的学生
async function handleClassStudentSearch() {
  if (!classStudentSearchQuery.value.trim()) {
    toast.add({
      severity: 'warn',
      summary: '提示',
      detail: '请输入学号',
      life: 3000
    })
    return
  }

  try {
    const res = await axios.get('/api/admin/classes/search-students', {
      params: {
        student_no: classStudentSearchQuery.value.trim(),
        exclude_class_id: currentClass.value.id // 排除已在班级中的学生
      }
    })
    classSearchResults.value = res.data.data
    
    if (classSearchResults.value.length === 0) {
      toast.add({
        severity: 'info',
        summary: '提示',
        detail: '未找到相关学生',
        life: 3000
      })
    }
  } catch (error) {
    handleError(error, '搜索学生失败')
  }
}

// 添加学生到班级
async function addStudentToClass(student) {
  try {
    const res = await axios.post(`/api/admin/classes/${currentClass.value.id}/students`, {
      student_id: student.id
    })
    
    if (res.data.success) {
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: '学生已添加到班级',
        life: 3000
      })
      
      // 刷新班级学生列表
      fetchClassStudents(currentClass.value.id)
      // 从搜索结果中移除
      classSearchResults.value = classSearchResults.value.filter(s => s.id !== student.id)
    }
  } catch (error) {
    handleError(error, '添加学生到班级失败')
  }
}

// 从班级中移除学生
async function removeStudentFromClass(student) {
  try {
    const res = await axios.delete(`/api/admin/classes/${currentClass.value.id}/students/${student.id}`)
    
    if (res.data.success) {
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: '学生已从班级中移除',
        life: 3000
      })
      
      // 刷新班级学生列表
      fetchClassStudents(currentClass.value.id)
    }
  } catch (error) {
    handleError(error, '从班级中移除学生失败')
  }
}

// 保存班级更改
async function saveClassChanges() {
  try {
    const res = await axios.put(`/api/admin/classes/${currentClass.value.id}`, {
      class_name: classManageForm.value.class_name
    })
    
    if (res.data.success) {
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: '班级信息已更新',
        life: 3000
      })
      
      showClassManageDialog.value = false
      fetchStudents() // 刷新学生列表以更新班级名称
    }
  } catch (error) {
    handleError(error, '更新班级信息失败')
  }
}

onMounted(fetchStudents)
</script>

<style scoped>
.students-management {
  padding: 24px;
  background-color: #f5f7fa;
  border-radius: 12px;
}

.action-bar {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.search-box {
  position: relative;
  flex: 1;
  max-width: 400px;
}

.search-box input {
  width: 100%;
  padding: 12px 16px;
  border-radius: 8px;
  border: 1px solid #eaeaea;
  background: white;
  font-size: 14px;
  outline: none;
  transition: all 0.3s ease;
  padding-right: 100px;
}

.exact-search-btn {
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  padding: 4px 8px;
  border-radius: 4px;
  border: 1px solid #eaeaea;
  background: #f5f5f7;
  color: #666;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.exact-search-btn.active {
  background: #007AFF;
  color: white;
  border-color: #007AFF;
}

.exact-search-btn:hover {
  background: #007AFF;
  color: white;
  border-color: #007AFF;
}

.action-buttons {
  display: flex;
  gap: 12px;
}

.btn-create {
  padding: 12px 20px;
  border-radius: 12px;
  border: none;
  font-size: 14px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  background: #007AFF;
  color: white;
}

.btn-create:hover {
  background: #0066CC;
}

.students-table {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.table-header {
  display: grid;
  grid-template-columns: 60px 150px 120px 1fr 1fr 100px 150px 120px;
  padding: 12px 20px;
  background: #f8fafc;
  font-weight: 600;
  align-items: center;
}

.table-row {
  display: grid;
  grid-template-columns: 60px 150px 120px 1fr 1fr 100px 150px 120px;
  padding: 12px 20px;
  border-bottom: 1px solid #f1f5f9;
  align-items: center;
}

.col-avatar {
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar-img {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  object-fit: cover;
}

.col-actions {
  display: flex;
  justify-content: center;
  gap: 16px;
}

.btn-edit, .btn-delete {
  padding: 8px 12px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 36px;
}

.btn-edit {
  background-color: rgba(0, 122, 255, 0.1);
  color: #007AFF;
}

.btn-edit:hover {
  background-color: rgba(0, 122, 255, 0.2);
  color: #007AFF;
}

.btn-delete {
  background-color: rgba(255, 59, 48, 0.1);
  color: #FF3B30;
}

.btn-delete:hover {
  background-color: rgba(255, 59, 48, 0.2);
  color: #FF3B30;
}

.btn-class-manage {
  padding: 8px 12px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 36px;
  background-color: rgba(255, 204, 0, 0.1);
  color: #FFCC00;
}

.btn-class-manage:hover {
  background-color: rgba(255, 204, 0, 0.2);
  color: #FFCC00;
}

/* 用户选择下拉框样式 */
.user-option {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px;
}

.option-avatar {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  object-fit: cover;
}

.display-name {
  color: #666;
  font-size: 0.9em;
}

:deep(.el-autocomplete) {
  width: 100%;
}

:deep(.el-autocomplete-suggestion) {
  min-width: 300px !important;
}

:deep(.el-autocomplete-suggestion__wrap) {
  padding: 0;
}

:deep(.el-autocomplete-suggestion__list) {
  margin: 0;
  padding: 0;
}

:deep(.el-autocomplete-suggestion__list li) {
  padding: 0;
  line-height: normal;
}

:deep(.el-autocomplete-suggestion__list li:hover) {
  background-color: #f5f7fa;
}

/* 图标样式 */
.btn-edit i, .btn-delete i {
  font-size: 14px;
}

.delete-confirm {
  text-align: center;
  padding: 20px;
}

.delete-confirm i {
  font-size: 48px;
  color: #FF3B30;
  margin-bottom: 16px;
}

.delete-confirm p {
  color: #1d1d1f;
  margin-bottom: 20px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.student-management-section {
  margin-top: 20px;
}

.student-search {
  margin-bottom: 16px;
}

.selected-students {
  margin-bottom: 16px;
}

.search-results {
  margin-top: 16px;
}

.search-result-item {
  padding: 8px;
  border: 1px solid #eaeaea;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
}

.mini-avatar {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  object-fit: cover;
}

.class-option {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px;
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

.class-manage-container {
  padding: 20px;
}

.class-info {
  background: white;
  border-radius: 8px;
  padding: 20px;
}

.class-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.class-stats {
  display: flex;
  gap: 16px;
}

.stat-item {
  display: flex;
  flex-direction: column;
}

.stat-label {
  font-size: 12px;
  color: #666;
}

.stat-value {
  font-size: 14px;
  font-weight: 500;
}

.class-students-section {
  margin-top: 20px;
}

.class-students-list {
  margin-top: 16px;
}

.empty-state {
  text-align: center;
  padding: 20px;
  color: #666;
}

.students-table.mini-table {
  margin-top: 16px;
}

.mini-table-header {
  display: grid;
  grid-template-columns: 60px 150px 120px 80px;
  padding: 12px 20px;
  background: #f8fafc;
  font-weight: 600;
  align-items: center;
}

.mini-table-body {
  padding: 12px 20px;
  border-bottom: 1px solid #f1f5f9;
}

.mini-table-row {
  display: grid;
  grid-template-columns: 60px 150px 120px 80px;
  padding: 8px 0;
  align-items: center;
}

.mini-col-avatar {
  display: flex;
  align-items: center;
  justify-content: center;
}

.mini-col-student-no {
  display: flex;
  align-items: center;
  justify-content: center;
}

.mini-col-name {
  display: flex;
  align-items: center;
  justify-content: center;
}

.mini-col-actions {
  display: flex;
  justify-content: center;
}

.btn-remove {
  padding: 8px 12px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 36px;
}

.btn-remove:hover {
  background-color: rgba(255, 59, 48, 0.1);
  color: #FF3B30;
}

/* 为班级列添加右边距 */
.col-class {
  margin-right: 20px; /* 调整此值以增加或减少间距 */
}
</style> 