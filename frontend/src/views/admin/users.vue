<template>
  <div class="users-container">
    <!-- 角色分类标签 -->
    <div class="role-tabs">
      <div class="role-header">
        <el-radio-group v-model="currentRole" class="role-group">
          <el-radio-button label="all">全部用户 ({{ totalUsers }})</el-radio-button>
          <el-radio-button label="normal">普通用户 ({{ roleCount.normal || 0 }})</el-radio-button>
          <el-radio-button label="vip">会员用户 ({{ roleCount.vip || 0 }})</el-radio-button>
          <el-radio-button label="super_vip">超级会员 ({{ roleCount.super_vip || 0 }})</el-radio-button>
          <el-radio-button label="teacher">教师用户 ({{ roleCount.teacher || 0 }})</el-radio-button>
          <el-radio-button label="admin">管理员 ({{ roleCount.admin || 0 }})</el-radio-button>
        </el-radio-group>
        <el-button
          v-if="isAdminOrTeacher"
          type="primary"
          class="add-user-btn"
          @click="handleAdd"
        >
          <i class="fas fa-user-plus"></i>
          添加用户
        </el-button>
      </div>

      <!-- 搜索框 -->
      <div class="search-box">
        <el-input
          v-model="searchQuery"
          placeholder="搜索用户名或显示名称..."
          :prefix-icon="Search"
          clearable
          class="search-input"
        />
      </div>
    </div>

    <!-- 用户列表 -->
    <div class="user-list">
      <el-table
        :data="filteredUsers"
        style="width: 100%"
        @sort-change="handleSortChange"
        :default-sort="{ prop: 'createdAt', order: 'descending' }"
      >
        <el-table-column label="头像" width="80" align="center">
          <template #default="{ row }">
            <el-avatar
              :size="40"
              :src="getAvatarUrl(row.avatar)"
              @error="() => avatarLoadError(row)"
            >
              {{ row.username.charAt(0).toUpperCase() }}
            </el-avatar>
          </template>
        </el-table-column>
        <el-table-column
          prop="username"
          label="用户名"
          sortable
          align="center"
          width="150"
        >
          <template #header="{ column }">
            <span>用户名</span>
            <span class="sort-icon"></span>
          </template>
        </el-table-column>
        <el-table-column
          prop="displayName"
          label="显示名称"
          align="center"
          width="150"
        />
        <el-table-column
          prop="email"
          label="邮箱"
          align="center"
          min-width="200"
        />
        <el-table-column
          prop="role"
          label="角色"
          sortable
          align="center"
          width="120"
        >
          <template #header="{ column }">
            <span>角色</span>
            <span class="sort-icon"></span>
          </template>
          <template #default="{ row }">
            <el-tag :class="getRoleType(row.role)" effect="plain">
              {{ getRoleLabel(row.role) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column
          prop="createdAt"
          label="注册时间"
          sortable
          align="center"
          width="180"
        >
          <template #header="{ column }">
            <span>注册时间</span>
            <span class="sort-icon"></span>
          </template>
          <template #default="{ row }">
            {{ formatDateTime(row.createdAt) }}
          </template>
        </el-table-column>
        <el-table-column
          label="操作"
          width="200"
          align="center"
          fixed="right"
        >
          <template #default="{ row }">
            <div class="operation-buttons">
              <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
              <el-button
                v-if="isAdmin && row.role !== 'admin'"
                type="danger"
                size="small"
                @click="handleDelete(row)"
              >删除</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 分页 -->
    <div class="pagination">
      <el-select
        v-model="pageSize"
        :page-sizes="[15, 30, 50, 100]"
        @change="handleSizeChange"
        style="width: 120px; margin-right: 20px;"
      >
        <el-option
          v-for="size in [15, 30, 50, 100]"
          :key="size"
          :label="`${size}条/页`"
          :value="size"
        />
      </el-select>
      <button
        class="page-btn"
        :disabled="currentPage === 1"
        @click="handleCurrentChange(currentPage - 1)"
      >
        <i class="fas fa-chevron-left"></i>
      </button>
      <span class="page-info">第 {{ currentPage }} 页，共 {{ Math.ceil(totalUsers / pageSize) }} 页</span>
      <button
        class="page-btn"
        :disabled="currentPage === Math.ceil(totalUsers / pageSize)"
        @click="handleCurrentChange(currentPage + 1)"
      >
        <i class="fas fa-chevron-right"></i>
      </button>
    </div>
  </div>

  <!-- 添加用户弹窗 -->
  <el-dialog
    v-model="addDialogVisible"
    title="添加新用户"
    width="500px"
    destroy-on-close
  >
    <el-form
      ref="addFormRef"
      :model="addForm"
      :rules="addRules"
      label-width="100px"
      class="add-form"
    >
      <el-form-item label="用户名" prop="username">
        <el-input v-model="addForm.username" placeholder="请输入用户名" />
      </el-form-item>

      <el-form-item label="显示名称" prop="displayName">
        <el-input v-model="addForm.displayName" placeholder="请输入显示名称" />
      </el-form-item>

      <el-form-item label="密码" prop="password">
        <el-input
          v-model="addForm.password"
          type="password"
          placeholder="请输入密码"
          show-password
        />
      </el-form-item>

      <el-form-item label="邮箱" prop="email">
        <el-input v-model="addForm.email" placeholder="请输入邮箱" />
      </el-form-item>

      <el-form-item label="角色" prop="role">
        <el-select v-model="addForm.role" placeholder="请选择角色">
          <el-option label="普通用户" value="normal" />
          <el-option label="会员用户" value="vip" />
          <el-option label="超级会员" value="super_vip" />
          <el-option
            v-if="isAdmin"
            label="教师用户"
            value="teacher"
          />
          <el-option
            v-if="isAdmin"
            label="管理员"
            value="admin"
          />
        </el-select>
      </el-form-item>
    </el-form>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="addDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveAdd" :loading="saveLoading">
          确定添加
        </el-button>
      </div>
    </template>
  </el-dialog>

  <!-- 编辑用户弹窗 -->
  <el-dialog
    v-model="editDialogVisible"
    :title="'编辑用户 - ' + (currentEditUser?.username || '')"
    width="500px"
    destroy-on-close
  >
    <el-form
      ref="editFormRef"
      :model="editForm"
      :rules="editRules"
      label-width="100px"
      class="edit-form"
    >
      <el-form-item label="用户名">
        <el-input v-model="editForm.username" disabled />
      </el-form-item>

      <el-form-item label="显示名称" prop="displayName">
        <el-input v-model="editForm.displayName" placeholder="请输入显示名称" />
      </el-form-item>

      <el-form-item label="邮箱" prop="email">
        <el-input v-model="editForm.email" placeholder="请输入邮箱" />
      </el-form-item>

      <el-form-item label="角色" prop="role" v-if="isAdmin">
        <el-select v-model="editForm.role" placeholder="请选择角色">
          <el-option label="普通用户" value="normal" />
          <el-option label="会员用户" value="vip" />
          <el-option label="超级会员" value="super_vip" />
          <el-option label="教师用户" value="teacher" />
          <el-option label="管理员" value="admin" />
        </el-select>
      </el-form-item>

      <el-form-item label="账号状态">
        <div class="status-switch">
          <el-switch
            v-model="editForm.status"
            :active-value="1"
            :inactive-value="0"
            active-text="正常"
            inactive-text="封禁"
          />
          <span class="status-tip">{{ editForm.status === 1 ? '用户可以正常登录和使用系统' : '用户账号已被封禁，无法登录系统' }}</span>
        </div>
      </el-form-item>
    </el-form>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveEdit" :loading="saveLoading">
          保存
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { Search } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'
// 导入API工具函数
import apiService, { getResourceUrl } from '@/utils/api'

// 获取令牌的通用函数
const getToken = () => {
  const accessToken = localStorage.getItem('accessToken')
  if (accessToken) return accessToken
  
  const userInfoStr = localStorage.getItem('userInfo')
  if (userInfoStr) {
    try {
      const userInfo = JSON.parse(userInfoStr)
      if (userInfo.accessToken) return userInfo.accessToken
      if (userInfo.token) return userInfo.token
    } catch (e) {
      console.error('解析userInfo失败:', e)
    }
  }
  return null
}

// 获取router实例
const router = useRouter()

// 获取完整的头像URL，使用getResourceUrl函数
const getAvatarUrl = (avatar) => {
  try {
    // 如果没有头像，返回默认头像
    if (!avatar) return getResourceUrl('uploads/avatars/default-avatar.png')
    // 如果是完整的URL，直接返回
    if (avatar.startsWith('http')) return avatar

    // 处理数据库中存储的路径，确保使用正确的URL格式
    if (avatar.includes('public/uploads/avatars/')) {
      // 提取文件名
      const fileName = avatar.split('/').pop()
      return getResourceUrl(`uploads/avatars/${fileName}`)
    }

    // 处理可能的相对路径情况
    if (avatar.includes('uploads/avatars/')) {
      return getResourceUrl(avatar)
    }
    
    // 如果只是文件名，添加完整路径
    if (!avatar.includes('/')) {
      return getResourceUrl(`uploads/avatars/${avatar}`)
    }

    // 处理其他情况
    return getResourceUrl(avatar)
  } catch (error) {
    console.error('处理头像URL时出错:', error)
    // 出错时返回默认头像
    return getResourceUrl('uploads/avatars/default-avatar.png')
  }
}

// 处理头像加载错误
const avatarLoadError = (user) => {
  console.error('头像加载失败:', user.username)
  // 使用首字母作为备用显示方式，无需额外处理，el-avatar组件会自动显示默认内容
}

// 角色数据
const currentRole = ref('all')
const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(15)
const totalUsers = ref(0)
const roleCount = ref({
  normal: 0,
  vip: 0,
  super_vip: 0,
  teacher: 0,
  admin: 0
})

// 模拟用户数据
const users = ref([
  {
    id: 1,
    username: 'user1',
    displayName: '用户1',
    email: 'user1@example.com',
    role: 'admin',
    createdAt: '2024-02-03 16:35:24',
    avatar: ''
  }
])

// 角色标签映射
const getRoleLabel = (role) => {
  const roleMap = {
    normal: '普通用户',
    vip: '会员用户',
    super_vip: '超级会员',
    teacher: '教师用户',
    admin: '管理员'
  }
  return roleMap[role] || role
}

// 角色标签类型
const getRoleType = (role) => {
  return `role-tag-${role}`
}

// 在 script setup 部分添加排序相关的变量和方法
const sortBy = ref('createdAt') // 默认按注册时间排序
const sortOrder = ref('descending') // 默认降序

// 过滤后的用户列表
const filteredUsers = computed(() => {
  let result = users.value

  // 按角色过滤
  if (currentRole.value !== 'all') {
    result = result.filter(user => user.role === currentRole.value)
  }

  // 按搜索词过滤
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(user =>
      user.username.toLowerCase().includes(query) ||
      user.displayName.toLowerCase().includes(query)
    )
  }

  // 排序
  result = [...result].sort((a, b) => {
    const order = sortOrder.value === 'ascending' ? 1 : -1

    switch (sortBy.value) {
      case 'username':
        return order * a.username.localeCompare(b.username)
      case 'role':
        const roleOrder = { admin: 1, teacher: 2, super_vip: 3, vip: 4, normal: 5 }
        return order * (roleOrder[a.role] - roleOrder[b.role])
      case 'createdAt':
        return order * (new Date(a.createdAt) - new Date(b.createdAt))
      default:
        return 0
    }
  })

  return result
})

// 获取用户列表
const fetchUsers = async () => {
  try {
    console.log('请求参数:', {
      page: currentPage.value,
      pageSize: pageSize.value,
      role: currentRole.value,
      search: searchQuery.value
    })

    // 获取令牌并验证是否存在
    const token = getToken()
    if (!token) {
      console.error('用户未登录或令牌不存在')
      ElMessage.error('登录已过期，请重新登录后再试')
      return
    }
    
    // 使用apiService替代原有的axios请求
    // 这里直接使用axios创建一个新的实例，避免使用apiService可能的全局拦截器问题
    const response = await axios({
      method: 'get',
      url: '/api/user/admin/list',
      params: {
        page: currentPage.value,
        pageSize: pageSize.value,
        role: currentRole.value,
        search: searchQuery.value
      },
      headers: {
        Authorization: `Bearer ${token}`
      }
    })

    console.log('获取用户列表响应:', response)

    // 处理响应，根据实际响应结构调整
    if (response.data && response.data.code === 200) {
      users.value = response.data.data.list || []
      totalUsers.value = response.data.data.total || 0
    } else if (response.data && response.data.success) {
      // 兼容其他可能的成功响应格式
      users.value = response.data.data.list || []
      totalUsers.value = response.data.data.total || 0
    } else {
      throw new Error(response.data.message || '获取用户列表失败')
    }
  } catch (error) {
    console.error('获取用户列表错误:', error)
    
    // 特殊处理401未授权错误，但不强制跳转
    if (error.response && error.response.status === 401) {
      ElMessage.error('登录已过期，请刷新页面或重新登录')
    } else {
      ElMessage.error(error.message || '获取用户列表失败')
    }
    
    // 清空用户列表，确保UI不显示过期数据
    users.value = []
    totalUsers.value = 0
  }
}

// 获取角色统计
const fetchRoleStats = async () => {
  try {
    console.log('开始获取角色统计')
    
    // 获取令牌并验证是否存在
    const token = getToken()
    if (!token) {
      console.error('获取角色统计失败: 用户未登录或令牌不存在')
      ElMessage.error('登录已过期，请重新登录后再试')
      return
    }
    
    // 直接使用axios发送请求
    const response = await axios({
      method: 'get',
      url: '/api/user/admin/role-stats',
      headers: {
        Authorization: `Bearer ${token}`
      }
    })

    console.log('角色统计响应:', response)

    // 处理响应，根据实际响应结构调整
    if (response.data && response.data.code === 200) {
      roleCount.value = response.data.data.stats || {}
      totalUsers.value = response.data.data.total || 0
    } else if (response.data && response.data.success) {
      // 兼容其他可能的成功响应格式
      roleCount.value = response.data.data.stats || {}
      totalUsers.value = response.data.data.total || 0
    } else {
      throw new Error(response.data.message || '获取角色统计失败')
    }
  } catch (error) {
    console.error('获取角色统计错误:', error)
    
    // 特殊处理401未授权错误，但不强制跳转
    if (error.response && error.response.status === 401) {
      ElMessage.error('登录已过期，请刷新页面或重新登录')
    } else {
      ElMessage.error(error.message || '获取角色统计失败')
    }
    
    // 初始化空数据，确保UI显示正常
    roleCount.value = {
      normal: 0,
      vip: 0,
      super_vip: 0,
      teacher: 0,
      admin: 0
    }
  }
}

// 监听筛选条件变化
watch([currentRole, searchQuery], () => {
  currentPage.value = 1 // 重置页码
  fetchUsers()
})

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val
  fetchUsers()
}

const handleCurrentChange = (val) => {
  currentPage.value = val
  fetchUsers()
}

// 编辑相关的响应式变量
const editDialogVisible = ref(false)
const currentEditUser = ref(null)
const editFormRef = ref(null)
const saveLoading = ref(false)

// 编辑表单数据
const editForm = ref({
  username: '',
  displayName: '',
  email: '',
  role: '',
  status: 1
})

// 表单验证规则
const editRules = {
  displayName: [
    { required: true, message: '请输入显示名称', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  role: [
    { required: true, message: '请选择角色', trigger: 'change' }
  ]
}

// 判断当前用户是否为管理员
const isAdmin = computed(() => {
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  return userInfo.role === 'admin'
})

// 判断当前用户是否为管理员或教师
const isAdminOrTeacher = computed(() => {
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  return ['admin', 'teacher'].includes(userInfo.role)
})

// 编辑用户按钮点击事件
const handleEdit = (user) => {
  if (!isAdminOrTeacher.value) {
    ElMessage.warning('您没有编辑权限')
    return
  }

  currentEditUser.value = user
  editForm.value = {
    username: user.username,
    displayName: user.displayName || '',
    email: user.email || '',
    role: user.role,
    status: user.status ?? 1
  }
  editDialogVisible.value = true
}

// 保存编辑
const handleSaveEdit = async () => {
  if (!editFormRef.value) return

  try {
    await editFormRef.value.validate()

    saveLoading.value = true
    const token = getToken()
    if (!token) {
      ElMessage.error('登录已过期，请重新登录后再试')
      saveLoading.value = false
      return
    }
    
    // 直接使用axios发送请求
    const response = await axios({
      method: 'put',
      url: `/api/user/admin/update/${currentEditUser.value.id}`,
      data: editForm.value,
      headers: {
        Authorization: `Bearer ${token}`
      }
    })

    if (response.data && response.data.success) {
      ElMessage.success('保存成功')
      editDialogVisible.value = false
      // 刷新用户列表和角色统计
      await fetchUsers()
      await fetchRoleStats()
    } else {
      throw new Error(response.data.message || '保存失败')
    }
  } catch (error) {
    console.error('保存失败:', error)
    if (error.response && error.response.status === 401) {
      ElMessage.error('登录已过期，请刷新页面或重新登录')
    } else {
      ElMessage.error(error.message || '保存失败')
    }
  } finally {
    saveLoading.value = false
  }
}

// 时间格式化函数
const formatDateTime = (dateTimeString) => {
  if (!dateTimeString) return ''
  const date = new Date(dateTimeString)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')

  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}

// 处理排序变化
const handleSortChange = ({ prop, order }) => {
  sortBy.value = prop
  sortOrder.value = order
}

// 添加用户相关的响应式变量
const addDialogVisible = ref(false)
const addFormRef = ref(null)

// 添加表单数据
const addForm = ref({
  username: '',
  displayName: '',
  password: '',
  email: '',
  role: 'normal'
})

// 添加表单验证规则
const addRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  displayName: [
    { required: true, message: '请输入显示名称', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  role: [
    { required: true, message: '请选择角色', trigger: 'change' }
  ]
}

// 添加用户按钮点击事件
const handleAdd = () => {
  addForm.value = {
    username: '',
    displayName: '',
    password: '',
    email: '',
    role: 'normal'
  }
  addDialogVisible.value = true
}

// 保存添加
const handleSaveAdd = async () => {
  if (!addFormRef.value) return

  try {
    await addFormRef.value.validate()
    saveLoading.value = true

    console.log('准备添加新用户:', addForm.value)
    const token = getToken()
    if (!token) {
      ElMessage.error('登录已过期，请重新登录后再试')
      saveLoading.value = false
      return
    }
    
    // 直接使用axios发送请求
    const response = await axios({
      method: 'post',
      url: '/api/user/add',
      data: {
        username: addForm.value.username,
        password: addForm.value.password,
        email: addForm.value.email,
        display_name: addForm.value.displayName,
        role: addForm.value.role
      },
      headers: {
        Authorization: `Bearer ${token}`
      }
    })

    console.log('添加用户响应:', response)

    if (response.data && response.data.success) {
      ElMessage.success('添加用户成功')
      addDialogVisible.value = false
      // 刷新用户列表和角色统计
      await fetchUsers()
      await fetchRoleStats()
    } else {
      throw new Error(response.data.message || '添加用户失败')
    }
  } catch (error) {
    console.error('添加用户失败:', error)
    if (error.response && error.response.status === 401) {
      ElMessage.error('登录已过期，请刷新页面或重新登录')
    } else {
      ElMessage.error(error.response?.data?.message || error.message || '添加用户失败')
    }
  } finally {
    saveLoading.value = false
  }
}

// 删除用户相关
const deleteLoading = ref(false)

// 删除用户按钮点击事件
const handleDelete = (user) => {
  if (!isAdmin.value) {
    ElMessage.warning('只有管理员才能删除用户')
    return
  }

  if (user.role === 'admin') {
    ElMessage.warning('不能删除管理员用户')
    return
  }

  ElMessageBox.confirm(
    `确定要删除用户 "${user.username}" 吗？此操作不可恢复！`,
    '删除用户',
    {
      confirmButtonText: '确定删除',
      cancelButtonText: '取消',
      type: 'warning',
      draggable: true
    }
  )
    .then(() => {
      deleteUser(user.id)
    })
    .catch(() => {
      ElMessage.info('已取消删除操作')
    })
}

// 删除用户的API调用
const deleteUser = async (userId) => {
  try {
    deleteLoading.value = true
    const token = getToken()
    if (!token) {
      ElMessage.error('登录已过期，请重新登录后再试')
      deleteLoading.value = false
      return
    }
    
    // 直接使用axios发送请求
    const response = await axios({
      method: 'delete',
      url: `/api/user/admin/delete/${userId}`,
      headers: {
        Authorization: `Bearer ${token}`
      }
    })

    if (response.data && response.data.success) {
      ElMessage.success('用户删除成功')
      // 刷新用户列表和角色统计
      await fetchUsers()
      await fetchRoleStats()
    } else {
      throw new Error(response.data.message || '删除用户失败')
    }
  } catch (error) {
    console.error('删除用户失败:', error)
    if (error.response && error.response.status === 401) {
      ElMessage.error('登录已过期，请刷新页面或重新登录')
    } else {
      ElMessage.error(error.response?.data?.message || error.message || '删除用户失败')
    }
  } finally {
    deleteLoading.value = false
  }
}

// 页面加载时获取数据
onMounted(() => {
  console.log('页面加载，开始获取数据')
  
  // 检查用户是否已登录
  const token = getToken()
  
  if (!token) {
    console.error('用户未登录或令牌不存在')
    ElMessage.error('请先登录')
    return
  }
  
  // 检查用户角色权限
  try {
    const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
    if (!['admin', 'teacher'].includes(userInfo.role)) {
      console.error('用户无权限访问此页面')
      ElMessage.error('您没有权限访问此页面')
      return
    }
    
    // 正常进入页面后加载数据
    fetchRoleStats()
    fetchUsers()
  } catch (error) {
    console.error('解析用户信息失败:', error)
    ElMessage.error('获取用户信息失败，请重新登录')
  }
})
</script>

<style scoped>
.users-container {
  padding: 20px;
}

.role-tabs {
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.role-group {
  flex-grow: 1;
  margin-right: 20px;
}

.search-box {
  width: 300px;
}

.search-input {
  background-color: white;
  border-radius: 4px;
}

.search-input :deep(.el-input__wrapper) {
  background-color: white;
  box-shadow: 0 0 0 1px #dcdfe6 inset;
}

.search-input :deep(.el-input__wrapper):hover {
  box-shadow: 0 0 0 1px #409eff inset;
}

.search-input :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #409eff inset;
}

.user-list {
  background-color: white;
  border-radius: 4px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 20px;
  padding: 15px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.page-btn {
  background: transparent;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  padding: 6px 12px;
  margin: 0 8px;
  cursor: pointer;
  transition: all 0.3s;
  color: #606266;
}

.page-btn:not(:disabled):hover {
  color: #409eff;
  border-color: #409eff;
}

.page-btn:disabled {
  background-color: #f5f7fa;
  border-color: #e4e7ed;
  color: #c0c4cc;
  cursor: not-allowed;
}

.page-info {
  color: #606266;
  margin: 0 15px;
  font-size: 14px;
}

.pagination :deep(.el-select .el-input__wrapper) {
  background-color: transparent;
}

/* 移除旧的分页样式 */

/* 表格行hover效果 */
.el-table :deep(tbody tr:hover) {
  background-color: #f5f7fa;
}

.el-table {
  margin-top: 10px;
  border-radius: 8px;
  overflow: hidden;
}

.el-table :deep(th.el-table__cell) {
  background-color: #f5f7fa;
  color: #606266;
  font-weight: bold;
  height: 50px;
}

.el-table :deep(th.el-table__cell.is-sortable) {
  cursor: pointer;
}

/* 自定义排序图标 */
.el-table :deep(th.el-table__cell.is-sortable .sort-icon) {
  display: inline-block;
  position: relative;
  width: 10px;
  height: 24px;  /* 增加高度以容纳两个箭头 */
  margin-left: 5px;
  vertical-align: middle;
}

.el-table :deep(th.el-table__cell.is-sortable .sort-icon::before),
.el-table :deep(th.el-table__cell.is-sortable .sort-icon::after) {
  content: '';
  position: absolute;
  left: 0;
  border-style: solid;
  border-width: 4px;  /* 稍微调小箭头大小 */
  border-color: transparent;
}

/* 向上箭头 */
.el-table :deep(th.el-table__cell.is-sortable .sort-icon::before) {
  top: 0;  /* 调整到顶部 */
  border-bottom-color: #dcdfe6;
}

/* 向下箭头 */
.el-table :deep(th.el-table__cell.is-sortable .sort-icon::after) {
  bottom: 0;  /* 调整到底部 */
  border-top-color: #dcdfe6;
}

/* 升序状态 */
.el-table :deep(th.el-table__cell.ascending .sort-icon::before) {
  border-bottom-color: #409eff;
}

/* 降序状态 */
.el-table :deep(th.el-table__cell.descending .sort-icon::after) {
  border-top-color: #409eff;
}

/* 移除原有的排序图标样式 */
.el-table :deep(th.el-table__cell.is-sortable .sort-caret) {
  display: none;
}

/* 鼠标悬停效果 */
.el-table :deep(th.el-table__cell.is-sortable:hover .sort-icon::before) {
  border-bottom-color: #409eff;
}

.el-table :deep(th.el-table__cell.is-sortable:hover .sort-icon::after) {
  border-top-color: #409eff;
}

.el-table :deep(.el-table__row) {
  transition: all 0.3s ease;
}

.el-table :deep(.el-table__row:hover) {
  background-color: #f0f9ff !important;
}

.role-tabs {
  background-color: white;
  padding: 15px;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

/* 标签样式优化 */
.el-tag {
  font-weight: 500;
  letter-spacing: 1px;
  min-width: 80px;
  text-align: center;
}

/* 按钮样式优化 */
.el-button--small {
  padding: 8px 16px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.el-button--small:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* 分页样式优化 */
.pagination {
  background-color: white;
  padding: 15px;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

/* 添加自定义角色标签样式 */
:deep(.role-tag-normal) {
  background-color: #e1f3ff;
  color: #409EFF;
  border-color: #b3d8ff;
}

:deep(.role-tag-vip) {
  background-color: #ffe1e1;
  color: #ff4d4f;
  border-color: #ffb3b3;
}

:deep(.role-tag-super_vip) {
  background: linear-gradient(45deg, #fff3e0, #ffd700);
  color: #b8860b;
  border-color: #ffd700;
}

:deep(.role-tag-teacher) {
  background-color: #e1f8e1;
  color: #006400;
  border-color: #b3e6b3;
}

:deep(.role-tag-admin) {
  background: linear-gradient(120deg, #1a237e 0%, #7c4dff 50%, #0d47a1 100%);
  color: #fff;
  border: none;
  text-shadow: 0 0 10px rgba(124, 77, 255, 0.5);
  position: relative;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(124, 77, 255, 0.3);
  animation: adminGlow 2s infinite;
}

@keyframes adminGlow {
  0% {
    box-shadow: 0 2px 10px rgba(124, 77, 255, 0.3);
  }
  50% {
    box-shadow: 0 2px 20px rgba(124, 77, 255, 0.5);
  }
  100% {
    box-shadow: 0 2px 10px rgba(124, 77, 255, 0.3);
  }
}

:deep(.role-tag-admin)::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(
    45deg,
    transparent,
    rgba(255, 255, 255, 0.1),
    transparent
  );
  transform: rotate(45deg);
  animation: adminShine 3s infinite;
}

@keyframes adminShine {
  0% {
    transform: translateX(-100%) rotate(45deg);
  }
  50% {
    transform: translateX(100%) rotate(45deg);
  }
  100% {
    transform: translateX(-100%) rotate(45deg);
  }
}

/* 添加账号状态开关和说明文字的样式 */
.status-switch {
  display: flex;
  align-items: center;
  gap: 20px;
}

.status-tip {
  color: #606266;
  font-size: 13px;
  margin-left: 12px;
  position: relative;
  padding-left: 12px;
}

.status-tip::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 2px;
  height: 14px;
  background: #e0e0e0;
  border-radius: 1px;
}

:deep(.el-switch) {
  min-width: 60px;
}

:deep(.el-switch__label) {
  font-size: 13px;
}

:deep(.el-switch__label--active) {
  color: #409EFF;
}

:deep(.el-switch__label--inactive) {
  color: #ff4d4f;
}

.role-header {
  display: flex;
  align-items: center;
  gap: 20px;
}

.add-user-btn {
  height: 32px;
  padding: 0 16px;
  display: flex;
  align-items: center;
  gap: 6px;
  font-weight: 500;
  background: linear-gradient(45deg, #4CAF50, #45a049);
  border: none;
  transition: all 0.3s ease;
}

.add-user-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
  background: linear-gradient(45deg, #45a049, #3d8b40);
}

.add-user-btn i {
  font-size: 14px;
}

/* 添加表单样式 */
.add-form {
  padding: 20px 0;
}

.add-form :deep(.el-form-item__label) {
  font-weight: 500;
}

.add-form :deep(.el-input__wrapper),
.add-form :deep(.el-select) {
  width: 100%;
}

.add-form :deep(.el-select .el-input) {
  width: 100%;
}

/* 操作按钮样式 */
.operation-buttons {
  display: flex;
  justify-content: center;
  gap: 8px;
}

.operation-buttons .el-button--danger {
  background-color: #f56c6c;
  border-color: #f56c6c;
}

.operation-buttons .el-button--danger:hover {
  background-color: #e64242;
  border-color: #e64242;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(230, 66, 66, 0.2);
}
</style>
