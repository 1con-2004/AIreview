<template>
  <div class="learning-plans-management">
    <div class="action-bar">
      <div class="search-box">
        <input
          type="text"
          v-model="searchQuery"
          placeholder="搜索学习计划标题..."
          @input="handleSearch"
        >
      </div>
      <div class="action-buttons">
        <button class="btn-create" @click="openCreateDialog">
          <i class="fas fa-plus"></i>
          新建学习计划
        </button>
      </div>
    </div>

    <div class="learning-plans-table">
      <div class="table-header">
        <div class="col-id">序号</div>
        <div class="col-title">学习计划标题</div>
        <div class="col-description">描述</div>
        <div class="col-date">创建日期</div>
        <div class="col-actions">操作</div>
      </div>
      <div class="table-body">
        <div v-for="plan in sortedPlans" :key="plan.id" class="table-row">
          <div class="col-id">{{ plan.id }}</div>
          <div class="col-title">{{ plan.title }}</div>
          <div class="col-description">{{ plan.description || '暂无描述' }}</div>
          <div class="col-date">{{ formatDate(plan.created_at) }}</div>
          <div class="col-actions">
            <button class="btn-edit" @click="editPlan(plan)">
              <i class="fas fa-edit"></i>
            </button>
            <button class="btn-delete" @click="deletePlan(plan)">
              <i class="fas fa-trash-alt"></i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 分页器 -->
    <div class="pagination">
      <button
        class="pagination-btn"
        :disabled="currentPage === 1"
        @click="changePage(currentPage - 1)"
      >
        <i class="fas fa-chevron-left"></i>
      </button>
      <span class="page-info">第 {{ currentPage }} 页，共 {{ totalPages }} 页</span>
      <button
        class="pagination-btn"
        :disabled="currentPage === totalPages"
        @click="changePage(currentPage + 1)"
      >
        <i class="fas fa-chevron-right"></i>
      </button>
    </div>

    <!-- 新建/编辑学习计划对话框 -->
    <el-dialog
      :title="isEditing ? '编辑学习计划' : '新建学习计划'"
      v-model="showDialog"
      width="70%"
      :close-on-click-modal="false"
    >
      <el-form :model="form" ref="formRef" :rules="formRules" label-width="100px">
        <el-form-item label="学习计划图标" prop="icon">
          <div class="icon-container">
            <img v-if="form.icon" :src="form.icon" class="icon-preview" />
            <img v-else src="/icons/default.png" class="icon-preview" />
            <el-upload
              class="upload-icon"
              :headers="{
                Authorization: `Bearer ${getAuthToken()}`
              }"
              :data="{ id: form.id }"
              :on-success="handleIconUploadSuccess"
              :on-error="handleIconUploadError"
              :before-upload="beforeIconUpload"
              :show-file-list="false"
              accept="image/*"
              name="icon"
              :auto-upload="true"
              :http-request="customUpload"
            >
              <el-button size="default" type="primary" class="upload-button">上传图标</el-button>
            </el-upload>
          </div>
        </el-form-item>
        <el-form-item label="计划标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入学习计划标题"></el-input>
        </el-form-item>
        <el-form-item label="计划描述" prop="description">
          <el-input
            type="textarea"
            v-model="form.description"
            placeholder="请输入学习计划描述"
            :rows="4"
          ></el-input>
        </el-form-item>
        <el-form-item label="难度" prop="difficulty_level">
          <el-select
            v-model="form.difficulty_level"
            placeholder="选择难度"
            popper-class="learning-plan-difficulty-select"
            :popper-append-to-body="true"
            :teleported="true"
          >
            <el-option label="简单" value="简单"></el-option>
            <el-option label="中等" value="中等"></el-option>
            <el-option label="困难" value="困难"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="计划标签" prop="tags">
          <el-input
            v-model="form.tagsInput"
            placeholder="请输入标签，多个标签用英文逗号分隔"
            @change="handleTagsInput"
          ></el-input>
          <div class="form-tip">多个标签请用英文逗号分隔，例如：算法,面试,SQL</div>
        </el-form-item>
        <el-form-item label="计划时长" prop="duration">
          <el-input-number
            v-model="form.duration"
            :min="1"
            :max="365"
            placeholder="请输入计划时长(天)"
          ></el-input-number>
          <span class="unit-label">天</span>
        </el-form-item>
        <el-form-item label="要点描述" prop="points" class="points-description">
          <el-input
            type="textarea"
            v-model="form.points"
            placeholder="请输入要点描述，多个要点用逗号或换行分隔"
            :rows="3"
          ></el-input>
          <div class="form-tip">
            按照固定格式进行描述,例如:---------["要点1","要点2","要点3"]---------最后每个要点会在展示页面各占1行

          </div>
        </el-form-item>
        <el-form-item label="题目管理">
          <div class="problem-list">
            <div v-for="(problem, index) in form.problems" :key="index" class="problem-item">
              <div class="problem-fields">
                <span class="input-label">题目ID-->>></span>
                <el-input-number
                  v-model="problem.problem_id"
                  :min="1"
                  controls-position="right"
                  placeholder="题目ID"
                  style="width: 150px; margin-right: 10px;"
                  @change="fetchProblemTitle(problem, index)"
                ></el-input-number>

                <span class="input-label">题目标题-->>></span>
                <el-input
                  v-model="problem.title"
                  placeholder="修改后显示"
                  style="width: 200px;"
                  disabled
                ></el-input>

                <span class="input-label">题目顺序-->>></span>
                <el-input-number
                  v-model="problem.order_index"
                  :min="1"
                  controls-position="right"
                  placeholder="顺序"
                  style="width: 120px; margin-right: 10px;"
                ></el-input-number>

                <span class="input-label">题目所属章节-->>></span>
                <el-input
                  v-model="problem.section"
                  placeholder="所属章节"
                  style="width: 200px;"
                ></el-input>
              </div>

              <el-button
                type="text"
                class="btn-delete"
                @click="removeProblem(index)"
                style="color: #EF4444;"
              >
                <i class="fas fa-trash-alt"></i>
              </el-button>
            </div>
            <el-button
              type="primary"
              plain
              @click="addProblem"
              style="margin-top: 10px;"
            >
              添加题目
            </el-button>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="closeDialog">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>

    <el-dialog
      title="确认删除"
      v-model="showDeleteDialog"
      width="30%"
      @close="closeDeleteDialog"
    >
      <span>你确定要删除此学习计划吗？</span>
      <template #footer>
        <el-button @click="closeDeleteDialog">取消</el-button>
        <el-button type="primary" @click="confirmDelete">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useToast } from 'primevue/usetoast'
import axios from 'axios'
import { useStore } from 'vuex'

const toast = useToast()
const store = useStore()

// 状态数据
const learningPlans = ref([])
const showDialog = ref(false)
const isEditing = ref(false)
const formRef = ref(null)
const form = ref({
  title: '',
  description: '',
  tagsInput: '',
  points: '',
  duration: 30,
  problems: [],
  pendingIcon: null,
  icon: null,
  difficulty_level: ''
})
const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const showDeleteDialog = ref(false)
const planToDelete = ref(null)

// 表单校验规则
const formRules = {
  title: [
    { required: true, message: '请输入学习计划标题', trigger: 'blur' },
    { min: 2, max: 50, message: '标题长度应在2-50个字符之间', trigger: 'blur' }
  ],
  description: [
    { required: true, message: '请输入学习计划描述', trigger: 'blur' },
    { min: 10, max: 500, message: '描述长度应在10-500个字符之间', trigger: 'blur' }
  ],
  duration: [
    { required: true, message: '请设置计划时长', trigger: 'blur' },
    { type: 'number', min: 1, max: 365, message: '时长应在1-365天之间', trigger: 'blur' }
  ],
  difficulty_level: [
    { required: true, message: '请选择难度级别', trigger: 'change' }
  ]
}

// 获取认证令牌
const getAuthToken = () => {
  // 首先尝试从Vuex获取token
  const storeToken = store.getters.getAccessToken
  if (storeToken) {
    return storeToken
  }

  // 回退到localStorage
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  return userInfo.accessToken
}

// 设置axios请求头
const setAuthHeader = () => {
  const token = getAuthToken()
  if (token) {
    axios.defaults.headers.common.Authorization = `Bearer ${token}`
  }
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return '未知日期'
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  })
}

// 获取学习计划
const fetchLearningPlans = async () => {
  try {
    console.log('获取学习计划列表...')
    console.log('当前认证令牌:', getAuthToken())

    // 使用store中的request工具或axios实例
    const response = await axios.get('/api/learning-plans', {
      headers: {
        Authorization: `Bearer ${getAuthToken()}`
      }
    })

    console.log('学习计划API响应:', response)
    console.log('响应数据类型:', typeof response.data)
    console.log('响应数据:', response.data)

    // 处理不同格式的响应
    if (response.data && response.data.success && Array.isArray(response.data.data)) {
      // 标准格式: { success: true, data: [...] }
      learningPlans.value = response.data.data
      console.log('标准格式设置学习计划数据:', learningPlans.value)
    } else if (Array.isArray(response.data)) {
      // 直接返回数组的情况
      learningPlans.value = response.data
      console.log('数组格式设置学习计划数据:', learningPlans.value)
    } else {
      console.error('API响应格式不符合预期:', response.data)
      toast.add({
        severity: 'error',
        summary: '数据格式错误',
        detail: '获取学习计划失败: 服务器返回的数据格式不正确'
      })
    }
  } catch (error) {
    console.error('获取学习计划失败:', error)
    console.error('错误响应:', error.response)
    console.error('错误详情:', error.response?.data || error.message)

    // 检查是否为认证错误
    if (error.response?.status === 401 || error.response?.status === 403) {
      toast.add({
        severity: 'error',
        summary: '认证错误',
        detail: '登录已过期或权限不足，请重新登录'
      })
    } else {
      toast.add({
        severity: 'error',
        summary: '错误',
        detail: `获取学习计划失败: ${error.response?.data?.message || error.message || '未知错误'}`
      })
    }
  }
}

// 计算总页数
const totalPages = computed(() => {
  return Math.ceil(filteredPlans.value.length / pageSize.value) || 1
})

// 计算过滤后的学习计划
const filteredPlans = computed(() => {
  if (!searchQuery.value) return learningPlans.value
  return learningPlans.value.filter(plan =>
    plan.title.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

// 计算分页后的学习计划
const paginatedPlans = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return filteredPlans.value.slice(start, start + pageSize.value)
})

// 计算排序后的学习计划
const sortedPlans = computed(() => {
  return learningPlans.value.sort((a, b) => a.id - b.id) // 按 ID 升序排序
})

// 打开新建学习计划对话框
const openCreateDialog = () => {
  isEditing.value = false
  form.value = {
    title: '',
    description: '',
    tagsInput: '',
    points: '',
    duration: 30,
    problems: [],
    pendingIcon: null,
    icon: null,
    difficulty_level: ''
  }
  showDialog.value = true
}

// 编辑学习计划
const editPlan = async (plan) => {
  isEditing.value = true
  form.value = {
    id: plan.id,
    title: plan.title,
    description: plan.description || '',
    tagsInput: plan.tags || '',
    points: plan.points || '',
    duration: plan.duration || 30,
    problems: [],
    difficulty_level: plan.difficulty_level || '',
    icon: plan.icon || null
  }

  await fetchPlanDetails(plan.id)
  showDialog.value = true
}

// 修改获取学习计划详情的方法
const fetchPlanDetails = async (planId) => {
  try {
    const response = await axios.get(`/api/learning-plans/${planId}`)
    if (response.data.success) {
      // eslint-disable-next-line camelcase
      const { title, description, tag, points, duration, problems, icon, difficulty_level } = response.data.data

      form.value = {
        ...form.value,
        title,
        description,
        tagsInput: tag || '',
        points: points || '',
        duration: duration || 30,
        problems: problems || [],
        // eslint-disable-next-line camelcase
        difficulty_level: difficulty_level || '',
        icon: form.value.icon
      }
    }
  } catch (error) {
    console.error('获取学习计划详情失败:', error)
    toast.add({ severity: 'error', summary: '错误', detail: '获取学习计划详情失败' })
  }
}

// 删除学习计划
const deletePlan = async (plan) => {
  planToDelete.value = plan // 保存要删除的计划
  showDeleteDialog.value = true // 显示确认对话框
}

// 确认删除
const confirmDelete = async () => {
  try {
    setAuthHeader()
    const response = await axios.delete(`/api/learning-plans/${planToDelete.value.id}`)
    if (response.data.success) {
      toast.add({ severity: 'success', summary: '成功', detail: '学习计划删除成功' })
      fetchLearningPlans() // 重新获取学习计划列表
    }
  } catch (error) {
    console.error('删除学习计划失败:', error)
    toast.add({ severity: 'error', summary: '错误', detail: '删除学习计划失败' })
  } finally {
    closeDeleteDialog() // 关闭对话框
  }
}

// 关闭删除对话框
const closeDeleteDialog = () => {
  showDeleteDialog.value = false
  planToDelete.value = null // 清空要删除的计划
}

// 关闭对话框
const closeDialog = () => {
  showDialog.value = false
  formRef.value?.resetFields()
}

// 提交表单
const submitForm = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        setAuthHeader()
        const url = isEditing.value
          ? `/api/learning-plans/${form.value.id}`
          : '/api/learning-plans'
        const method = isEditing.value ? 'put' : 'post'

        // 在提交前处理标签
        const payload = {
          ...form.value,
          tagsInput: processTags().join(','),
          points: form.value.points.split(/[,\n]/).map(p => p.trim()).filter(p => p).join(','),
          estimated_days: form.value.duration,
          difficulty_level: form.value.difficulty_level
        }

        const response = await axios[method](url, payload)

        if (response.data.success) {
          // 保存新创建的计划ID
          const planId = response.data.data.id
          form.value.id = planId // 更新表单中的ID

          // 如果有待上传的图标，现在上传
          if (form.value.pendingIcon) {
            await uploadPendingIcon()
          }

          // 更新题目列表
          await axios.put(`/api/learning-plans/${planId}/problems`, {
            problems: form.value.problems
          }, {
            headers: { Authorization: `Bearer ${getAuthToken()}` }
          })

          toast.add({
            severity: 'success',
            summary: '成功',
            detail: `学习计划${isEditing.value ? '修改' : '创建'}成功`
          })
          closeDialog()
          fetchLearningPlans()
        }
      } catch (error) {
        console.error(`${isEditing.value ? '修改' : '创建'}学习计划失败:`, error)
        toast.add({
          severity: 'error',
          summary: '错误',
          detail: `${isEditing.value ? '修改' : '创建'}学习计划失败`
        })
      }
    }
  })
}

// 处理搜索
const handleSearch = () => {
  currentPage.value = 1 // 重置到第一页
}

// 切换页面
const changePage = (page) => {
  currentPage.value = page
}

// 新增获取题目方法
const fetchPlanProblems = async (planId) => {
  try {
    const response = await axios.get(`/api/learning-plans/${planId}/problems`)
    form.value.problems = response.data.data.map(p => ({
      problem_id: p.problem_id,
      order_index: p.order_index,
      section: p.section
    }))
  } catch (error) {
    console.error('获取题目列表失败:', error)
    toast.add({ severity: 'error', summary: '错误', detail: '获取题目列表失败' })
  }
}

// 添加题目管理方法
const addProblem = () => {
  form.value.problems.push({
    problem_id: null,
    order_index: form.value.problems.length + 1,
    section: ''
  })
}

// 处理标签输入
const handleTagsInput = () => {
  form.value.tagsInput = form.value.tagsInput.replace(/，/g, ',') // 替换中文逗号
}

// 修改提交前的处理
const processTags = () => {
  return form.value.tagsInput.split(',')
    .map(t => t.trim())
    .filter(t => t)
}

// 删除题目管理中的题目
const removeProblem = (index) => {
  form.value.problems.splice(index, 1) // 从题目列表中移除指定的题目
}

// 获取题目标题的方法
const fetchProblemTitle = async (problem, index) => {
  if (!problem.problem_id) {
    problem.title = '' // 如果没有输入ID，清空标题
    return
  }

  // 将 problem_id 转换为字符串并添加前导零
  const problemNumberStr = problem.problem_id.toString().padStart(4, '0')

  try {
    const response = await axios.get(`/api/learning-plans/problems/${problemNumberStr}`)
    if (response.data.success) {
      problem.title = response.data.data // 更新题目标题
      console.log(`题目ID: ${problem.problem_id}, 标题: ${problem.title}`) // 打印日志
    } else {
      problem.title = '题目不存在' // 处理题目不存在的情况
    }
  } catch (error) {
    console.error('获取题目标题失败:', error)
    problem.title = '获取失败' // 处理请求失败的情况
  }
}

// 组件挂载时获取数据
onMounted(() => {
  fetchLearningPlans()
})

// 修改自定义上传方法
const customUpload = async (options) => {
  console.log('开始自定义上传', options)
  console.log('当前计划ID:', form.value.id)

  // 检查是否有计划ID
  if (!form.value.id) {
    console.log('新建计划，保存图标到 pendingIcon')
    form.value.pendingIcon = options.file
    // 预览选择的图片
    const reader = new FileReader()
    reader.onload = (e) => {
      form.value.icon = e.target.result
    }
    reader.readAsDataURL(options.file)

    toast.add({
      severity: 'info',
      summary: '提示',
      detail: '图标将在保存学习计划后自动上传'
    })

    // 提供一个模拟的成功响应
    const mockResponse = {
      success: true,
      data: {
        icon: URL.createObjectURL(options.file)
      },
      message: '图标已暂存，将在保存学习计划后上传'
    }

    if (options.onSuccess) {
      options.onSuccess(mockResponse)
    }
    return
  }

  await uploadIcon(options)
}

// 新增上传图标的方法
const uploadIcon = async (options) => {
  const formData = new FormData()
  formData.append('icon', options.file)

  try {
    const uploadUrl = `/api/learning-plans/${form.value.id}/icon`
    console.log('发送请求到:', uploadUrl)

    const response = await axios.post(
      uploadUrl,
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
          Authorization: `Bearer ${getAuthToken()}`
        },
        onUploadProgress: (progressEvent) => {
          if (options.onProgress && progressEvent.total) {
            options.onProgress({
              percent: (progressEvent.loaded / progressEvent.total) * 100
            })
          }
        }
      }
    )

    console.log('上传响应:', response)
    if (response.data && response.data.success) {
      handleIconUploadSuccess(response.data)
      if (options.onSuccess) {
        options.onSuccess(response.data)
      }
    } else {
      const error = new Error(response.data?.message || '上传失败')
      handleIconUploadError(error)
      if (options.onError) {
        options.onError(error)
      }
    }
  } catch (error) {
    console.error('上传失败:', error)
    handleIconUploadError(error)
    if (options.onError) {
      options.onError(error)
    }
  }
}

// 新增处理待上传图标的方法
const uploadPendingIcon = async () => {
  if (!form.value.pendingIcon) return

  await uploadIcon({
    file: form.value.pendingIcon,
    onProgress: (progress) => {
      console.log('上传进度:', progress)
    }
  })

  // 清除待上传的图标
  form.value.pendingIcon = null
}

// 修改处理上传成功的方法
const handleIconUploadSuccess = (response) => {
  console.log('上传成功响应:', response)

  // 如果响应是undefined或null，显示错误信息
  if (!response) {
    console.error('上传响应为空')
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: '上传失败：服务器响应为空'
    })
    return
  }

  try {
    // 处理不同的响应格式
    const responseData = response.data || response
    const isSuccess = response.success || responseData.success
    const iconData = responseData.icon || responseData.data?.icon

    if (isSuccess && iconData) {
      // 如果是临时预览URL，直接使用
      if (iconData instanceof Blob || (typeof iconData === 'string' && iconData.startsWith('blob:'))) {
        form.value.icon = iconData
      } else {
        // 使用相对路径，让Nginx处理代理
        form.value.icon = iconData.startsWith('http')
          ? iconData
          : iconData // 直接使用相对路径
      }

      toast.add({
        severity: 'success',
        summary: '成功',
        detail: response.message || responseData.message || '图标上传成功'
      })
    } else {
      throw new Error('上传响应格式无效')
    }
  } catch (error) {
    console.error('处理上传响应时出错:', error)
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: '处理上传响应时出错：' + (error.message || '未知错误')
    })
  }
}

// 修改错误处理函数
const handleIconUploadError = (error) => {
  console.error('图标上传失败:', error)
  console.error('错误详情:', error.response || error.message || error)

  let errorMessage = '图标上传失败'
  if (error.response) {
    errorMessage = error.response.data.message || errorMessage
  } else if (error.message) {
    errorMessage = error.message
  }

  toast.add({
    severity: 'error',
    summary: '错误',
    detail: errorMessage
  })
}

// 修改上传前验证
const beforeIconUpload = (file) => {
  console.log('准备上传文件:', file)

  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5

  if (!isImage) {
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: '只能上传图片文件!'
    })
    return false
  }
  if (!isLt5M) {
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: '图片大小不能超过 5MB!'
    })
    return false
  }

  // 检查认证信息
  const token = getAuthToken()
  if (!token) {
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: '未登录或登录已过期，请重新登录!'
    })
    return false
  }

  return true
}
</script>

<style>
/* 全局样式，确保下拉框样式正确 */
.learning-plan-difficulty-select {
  background-color: #fff !important;
  border: 1px solid #dcdfe6 !important;
  z-index: 3000 !important; /* 提高z-index确保显示在最上层 */
}

.learning-plan-difficulty-select .el-select-dropdown__item {
  color: #606266 !important;
  padding: 0 20px !important;
}

.learning-plan-difficulty-select .el-select-dropdown__item.hover,
.learning-plan-difficulty-select .el-select-dropdown__item:hover {
  background-color: #f5f7fa !important;
}

.learning-plan-difficulty-select .el-select-dropdown__item.selected {
  color: #409eff !important;
  font-weight: bold !important;
}

/* 确保弹出层在最顶层 */
.el-select__popper {
  z-index: 3000 !important;
}

/* 添加下拉框的基础样式 */
.el-select-dropdown {
  border: 1px solid #dcdfe6 !important;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,.1) !important;
}

/* 确保下拉选项可见 */
.el-select-dropdown__list {
  padding: 6px 0 !important;
  margin: 0 !important;
  box-sizing: border-box !important;
  max-height: 274px !important;
}
</style>

<style scoped>
.learning-plans-management {
  padding: 24px;
  background-color: #f5f7fa;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.action-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  gap: 16px;
}

.search-box {
  flex: 1;
  max-width: 400px;
}

.search-box input {
  width: 100%;
  padding: 12px 16px;
  border-radius: 10px;
  border: 1px solid #e2e8f0;
  font-size: 15px;
  background-color: white;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.search-box input:focus {
  outline: none;
  border-color: #4F46E5;
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.2);
}

.action-buttons {
  display: flex;
  gap: 12px;
}

.btn-create {
  padding: 12px 20px;
  border-radius: 10px;
  border: none;
  background-color: #4F46E5;
  color: white;
  font-weight: 600;
  font-size: 15px;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  transition: background-color 0.2s;
}

.btn-create:hover {
  background-color: #4338ca;
}

.learning-plans-table {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  margin-bottom: 24px;
}

.table-header {
  display: grid;
  grid-template-columns: 80px 2fr 3fr 1fr 120px;
  padding: 16px 20px;
  background: #f8fafc;
  font-weight: 600;
  color: #4b5563;
  border-bottom: 1px solid #e2e8f0;
}

.table-row {
  display: grid;
  grid-template-columns: 80px 2fr 3fr 1fr 120px;
  padding: 16px 20px;
  border-bottom: 1px solid #f1f5f9;
  transition: background-color 0.2s;
}

.table-row:hover {
  background-color: #f8fafc;
}

.col-id {
  color: #6b7280;
  font-weight: 500;
}

.col-title {
  font-weight: 600;
  color: #1e293b;
}

.col-description {
  color: #64748b;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.col-date {
  color: #64748b;
  text-align: center;
}

.col-actions {
  display: flex;
  justify-content: center;
  gap: 8px;
}

.btn-edit, .btn-delete {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background-color 0.2s;
}

.btn-edit {
  background: rgba(245, 158, 11, 0.1);
  color: #F59E0B;
}

.btn-edit:hover {
  background: rgba(245, 158, 11, 0.2);
}

.btn-delete {
  background: rgba(239, 68, 68, 0.1);
  color: #EF4444;
  border: none;
  border-radius: 8px;
  padding: 8px;
  cursor: pointer;
  transition: background-color 0.2s;
}

.btn-delete:hover {
  background: rgba(239, 68, 68, 0.2);
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
}

.pagination-btn {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  border: 1px solid #e2e8f0;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background-color 0.2s;
}

.pagination-btn:hover:not(:disabled) {
  background-color: #f1f5f9;
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  font-size: 15px;
  color: #64748b;
}

.unit-label {
  margin-left: 8px;
  color: #6b7280;
}

.problem-list {
  border: 1px solid #ebeef5;
  padding: 10px;
  border-radius: 4px;
}
.problem-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px;
  border-bottom: 1px solid #eee;
}

.problem-fields {
  flex: 1;
  display: flex;
  gap: 20px;
  align-items: center;
}

.el-icon-delete-solid:hover {
  color: #f78989;
}

.form-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

.problem-title {
  margin-top: 5px;
  font-size: 12px;
  color: #64748b;
}

.input-label {
  margin-left: 8px;
  font-size: 14px;
  color: #6b7280;
}

.icon-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 20px;
}

.icon-preview {
  width: 80px;
  height: 80px;
  border-radius: 12px;
  object-fit: cover;
  margin-bottom: 10px;
}

.upload-button {
  width: 100%;
  padding: 10px;
  font-size: 16px;
}

.points-description {
  margin-bottom: 0px;
}

/* 确保下拉框样式正确 */
:deep(.el-select) {
  width: 100%;
}

:deep(.el-select .el-input__wrapper) {
  background-color: #fff !important;
  box-shadow: 0 0 0 1px #dcdfe6 inset !important;
}

:deep(.el-select .el-input__inner) {
  color: #606266 !important;
  height: 32px !important;
  line-height: 32px !important;
}

:deep(.el-select:hover .el-input__wrapper) {
  box-shadow: 0 0 0 1px #409eff inset !important;
}
</style>
