<template>
  <div class="problems-management">
    <!-- 顶部统计卡片 -->
    <div class="statistics-cards">
      <div class="stat-card">
        <div class="stat-icon">
          <i class="fas fa-code"></i>
        </div>
        <div class="stat-content">
          <div class="stat-value">{{ totalProblems }}</div>
          <div class="stat-label">总题目数</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">
          <i class="fas fa-tags"></i>
        </div>
        <div class="stat-content">
          <div class="stat-value">{{ totalCategories }}</div>
          <div class="stat-label">题目分类</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">
          <i class="fas fa-chart-pie"></i>
        </div>
        <div class="stat-content">
          <div class="stat-distribution">
            <div class="difficulty-bar">
              <span class="difficulty-label">简单</span>
              <div class="bar-wrapper">
                <div class="bar easy" :style="{ width: getDifficultyPercentage('简单') + '%' }"></div>
              </div>
              <span class="difficulty-count">{{ getDifficultyCount('简单') }}</span>
            </div>
            <div class="difficulty-bar">
              <span class="difficulty-label">中等</span>
              <div class="bar-wrapper">
                <div class="bar medium" :style="{ width: getDifficultyPercentage('中等') + '%' }"></div>
              </div>
              <span class="difficulty-count">{{ getDifficultyCount('中等') }}</span>
            </div>
            <div class="difficulty-bar">
              <span class="difficulty-label">困难</span>
              <div class="bar-wrapper">
                <div class="bar hard" :style="{ width: getDifficultyPercentage('困难') + '%' }"></div>
              </div>
              <span class="difficulty-count">{{ getDifficultyCount('困难') }}</span>
            </div>
          </div>
          <div class="stat-label">难度分布</div>
        </div>
      </div>
    </div>

    <!-- 操作栏 -->
    <div class="action-bar">
      <div class="search-box">
        <input
          type="text"
          v-model="searchQuery"
          placeholder="搜索题目标题、描述或标签..."
          @input="handleSearch"
        >
        <button
          v-if="/^\d+$/.test(searchQuery.trim())"
          class="exact-search-btn"
          :class="{ active: isExactSearch }"
          @click="toggleExactSearch"
        >
          精确搜索
        </button>
      </div>
      <div class="action-buttons">
        <button class="btn-import" @click="gotoProblemPool">
          <i class="fas fa-magic"></i>
          一键出题
        </button>
        <button class="btn-create" @click="openCreateDialog">
          <i class="fas fa-plus"></i>
          新建题目
        </button>
        <button class="btn-reorder" @click="reorderProblems">
          <i class="fas fa-sort-numeric-down"></i>
          重新排序
        </button>
        <button class="btn-filter" @click="showFilterPanel = !showFilterPanel">
          <i class="fas fa-filter"></i>
          筛选
        </button>
      </div>
    </div>

    <!-- 筛选面板 -->
    <div class="filter-panel" v-if="showFilterPanel">
      <div class="filter-group">
        <h3>难度等级</h3>
        <div class="difficulty-filters">
          <el-select
            v-model="selectedDifficulty"
            placeholder="选择难度"
            class="difficulty-select"
            teleported
            :popper-class="'admin-problems-select'"
          >
            <el-option
              v-for="item in difficulties"
              :key="item.code"
              :label="item.name"
              :value="item.code"
            />
          </el-select>
        </div>
      </div>
      <div class="filter-group">
        <h3>题目分类</h3>
        <div class="tag-search">
          <input
            type="text"
            v-model="tagSearchQuery"
            placeholder="搜索标签..."
            class="tag-search-input"
          />
        </div>
        <div class="tag-list">
          <button
            v-for="tag in filteredTags"
            :key="tag"
            :class="['category-tag', { active: selectedTags.includes(tag) }]"
            @click="toggleTag(tag)"
          >
            {{ tag }}
          </button>
        </div>
      </div>
      <div class="filter-actions">
        <button class="btn-clear" @click="clearFilters">取消筛选</button>
      </div>
    </div>

    <!-- 题目列表 -->
    <div class="problems-table">
      <div class="table-header">
        <div class="col-id">序号</div>
        <div class="col-title">题目标题</div>
        <div class="col-difficulty">难度</div>
        <div class="col-category">分类</div>
        <div class="col-submit">提交次数</div>
        <div class="col-rate">通过率</div>
        <div class="col-actions">操作</div>
      </div>
      <div class="table-body">
        <div v-for="problem in problems" :key="problem.id" class="table-row">
          <div class="col-id">#{{ problem.problem_number }}</div>
          <div class="col-title">{{ problem.title }}</div>
          <div class="col-difficulty">
            <span :class="'difficulty-' + problem.difficulty">
              {{ getDifficultyLabel(problem.difficulty) }}
            </span>
          </div>
          <div class="col-category">
            <span class="category-tag" v-for="tag in problem.tags ? problem.tags.split(',') : []" :key="tag">
              {{ tag }}
            </span>
          </div>
          <div class="col-submit">{{ problem.total_submissions || '0' }}</div>
          <div class="col-rate">
            <span :class="getRateClass(problem.acceptance_rate)">
              {{ formatPassRate(problem.acceptance_rate) }}
            </span>
          </div>
          <div class="col-actions">
            <button class="btn-edit" @click="editProblem(problem)">
              <i class="fas fa-edit"></i>
            </button>
            <button class="btn-delete" @click="deleteProblem(problem)">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 分页器 -->
    <div class="pagination">
      <button
        :disabled="currentPage === 1"
        @click="changePage(currentPage - 1)"
      >
        <i class="fas fa-chevron-left"></i>
      </button>
      <span class="page-info">第 {{ currentPage }} 页，共 {{ totalPages }} 页</span>
      <button
        :disabled="currentPage === totalPages"
        @click="changePage(currentPage + 1)"
      >
        <i class="fas fa-chevron-right"></i>
      </button>
    </div>
  </div>

  <!-- 新建题目弹窗 -->
  <div v-if="showDialog" class="development-notice">
    <div class="notice-content">
      <i class="fas fa-tools notice-icon"></i>
      <h2>功能开发中</h2>
      <p>新建题目功能正在开发中，敬请期待...</p>
      <Button
        label="我知道了"
        icon="pi pi-check"
        @click="showDialog = false"
        class="p-button-secondary"
      />
    </div>
  </div>

  <!-- 修改题目弹窗 -->
  <Dialog
    v-model:visible="showEditDialog"
    :header="'修改题目操作'"
    :modal="true"
    class="edit-dialog"
  >
    <div class="edit-options">
      <button class="edit-option" @click="handleEditContent">
        <i class="fas fa-edit"></i>
        <span>修改题目内容</span>
      </button>
      <button class="edit-option" @click="handleEditSolution">
        <i class="fas fa-code"></i>
        <span>修改题目答案</span>
      </button>
    </div>
  </Dialog>

  <!-- 修改题目内容弹窗 -->
  <Dialog
    v-model:visible="showEditContentDialog"
    :header="'修改题目内容'"
    :modal="true"
    :resizable="true"
    class="edit-content-dialog"
    :style="{ width: '80vw', maxWidth: '1200px' }"
  >
    <div class="edit-form">
      <div class="form-group">
        <label>题目标题</label>
        <input v-model="editForm.title" type="text" placeholder="请输入题目标题">
      </div>
      <div class="form-group">
        <label>难度</label>
        <select v-model="editForm.difficulty">
          <option value="简单">简单</option>
          <option value="中等">中等</option>
          <option value="困难">困难</option>
        </select>
      </div>
      <div class="form-group">
        <label>标签</label>
        <input v-model="editForm.tags" type="text" placeholder="请输入标签，用逗号分隔">
      </div>
      <div class="form-group">
        <label>描述</label>
        <textarea v-model="editForm.description" placeholder="请输入题目描述"></textarea>
      </div>
      <div class="form-row">
        <div class="form-group half">
          <label>时间限制(ms)</label>
          <input v-model="editForm.time_limit" type="number" min="0">
        </div>
        <div class="form-group half">
          <label>内存限制(MB)</label>
          <input v-model="editForm.memory_limit" type="number" min="0">
        </div>
      </div>

      <!-- 测试用例表格 -->
      <div class="form-group">
        <label>测试用例</label>
        <el-table
          :data="editForm.test_cases"
          :default-sort="{ prop: 'order_num', order: 'ascending' }"
          @sort-change="handleEditTestCaseSortChange"
          class="test-cases-table"
        >
          <el-table-column
            prop="order_num"
            label="序号"
            width="80"
            sortable
          >
            <template #default="scope">
              {{ scope.row.order_num }}
            </template>
          </el-table-column>
          <el-table-column
            prop="input"
            label="输入"
          >
            <template #default="scope">
              <el-input
                v-model="scope.row.input"
                type="textarea"
                :rows="2"
                placeholder="请输入测试用例输入"
              />
            </template>
          </el-table-column>
          <el-table-column
            prop="output"
            label="输出"
          >
            <template #default="scope">
              <el-input
                v-model="scope.row.output"
                type="textarea"
                :rows="2"
                placeholder="请输入测试用例输出"
              />
            </template>
          </el-table-column>
          <el-table-column
            prop="is_example"
            label="是否为示例"
            width="120"
          >
            <template #default="scope">
              <el-switch
                v-model="scope.row.is_example"
                :active-value="true"
                :inactive-value="false"
              />
            </template>
          </el-table-column>
          <el-table-column
            label="操作"
            width="120"
          >
            <template #default="scope">
              <el-button-group>
                <el-button
                  size="small"
                  type="danger"
                  @click="removeEditTestCase(scope.$index)"
                >
                  删除
                </el-button>
              </el-button-group>
            </template>
          </el-table-column>
        </el-table>
        <div class="table-actions">
          <el-button type="primary" @click="addEditTestCase">
            添加测试用例
          </el-button>
        </div>
      </div>

      <div class="form-actions">
        <button class="btn-save" @click="saveContentEdit">保存修改</button>
        <button class="btn-cancel" @click="showEditContentDialog = false">取消</button>
      </div>
    </div>
  </Dialog>

  <!-- 修改题目答案弹窗 -->
  <Dialog
    v-model:visible="showEditSolutionDialog"
    :header="'修改题目答案'"
    :modal="true"
    :resizable="true"
    class="edit-solution-dialog"
    :style="{ width: '80vw', maxWidth: '1200px' }"
  >
    <div class="edit-form">
      <div class="form-group">
        <label>通用解题思路</label>
        <textarea v-model="solutionForm.solution_approach" placeholder="请输入通用解题思路"></textarea>
      </div>

      <!-- 多语言代码编辑区域 -->
      <el-tabs v-model="activeLanguage" type="border-card">
        <el-tab-pane v-for="lang in languageOptions" :key="lang.value" :label="lang.label" :name="lang.value">
          <div class="form-group">
            <label>{{ lang.label }}答案代码</label>
            <textarea
              v-model="solutionForm.solutions[lang.value]"
              :placeholder="`请输入${lang.label}答案代码`"
              class="code-textarea"
              rows="15"
            ></textarea>
          </div>
        </el-tab-pane>
      </el-tabs>

      <div class="form-actions">
        <button class="btn-save" @click="saveSolutionEdit">保存修改</button>
        <button class="btn-cancel" @click="showEditSolutionDialog = false">取消</button>
      </div>
    </div>
  </Dialog>

  <!-- 删除确认弹窗 -->
  <Dialog
    v-model:visible="showDeleteDialog"
    :header="'确认删除'"
    :modal="true"
    class="delete-dialog"
  >
    <div class="delete-confirm">
      <i class="fas fa-exclamation-triangle"></i>
      <p>确定要删除这道题目吗？此操作不可恢复。</p>
      <div class="dialog-actions">
        <button class="btn-confirm" @click="confirmDelete">确认删除</button>
        <button class="btn-cancel" @click="showDeleteDialog = false">取消</button>
      </div>
    </div>
  </Dialog>

  <!-- 新建题目对话框 -->
  <el-dialog
    title="新建题目"
    v-model="showCreateDialog"
    width="80%"
    :before-close="handleCloseDialog"
  >
    <el-form
      ref="createFormRef"
      :model="createForm"
      :rules="formRules"
      label-width="120px"
    >
      <el-form-item label="题目标题" prop="title">
        <el-input v-model="createForm.title" placeholder="请输入题目标题"></el-input>
      </el-form-item>

      <el-form-item label="难度等级" prop="difficulty">
        <el-select v-model="createForm.difficulty" placeholder="请选择难度">
          <el-option label="简单" value="简单"></el-option>
          <el-option label="中等" value="中等"></el-option>
          <el-option label="困难" value="困难"></el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="标签" prop="tags">
        <el-input
          v-model="createForm.tags"
          placeholder="请输入标签，多个标签用逗号分隔"
        ></el-input>
      </el-form-item>

      <el-form-item label="描述" prop="description">
        <el-input
          type="textarea"
          v-model="createForm.description"
          :rows="4"
          placeholder="请输入题目描述"
        ></el-input>
      </el-form-item>

      <el-form-item label="时间限制(ms)" prop="time_limit">
        <el-input-number
          v-model="createForm.time_limit"
          :min="100"
          :max="10000"
          :step="100"
        ></el-input-number>
      </el-form-item>

      <el-form-item label="内存限制(MB)" prop="memory_limit">
        <el-input-number
          v-model="createForm.memory_limit"
          :min="64"
          :max="1024"
          :step="64"
        ></el-input-number>
      </el-form-item>

      <el-form-item label="解题思路" prop="solution_approach">
        <el-input
          type="textarea"
          v-model="createForm.solution_approach"
          :rows="4"
          placeholder="请输入解题思路"
        ></el-input>
      </el-form-item>

      <el-form-item label="时间复杂度" prop="time_complexity">
        <el-input
          v-model="createForm.time_complexity"
          placeholder="请输入时间复杂度，如 O(n)"
        ></el-input>
      </el-form-item>

      <el-form-item label="空间复杂度" prop="space_complexity">
        <el-input
          v-model="createForm.space_complexity"
          placeholder="请输入空间复杂度，如 O(1)"
        ></el-input>
      </el-form-item>

      <!-- 四种语言的答案 -->
      <el-tabs v-model="activeLanguage" type="border-card">
        <el-tab-pane v-for="lang in languageOptions" :key="lang.value" :label="lang.label" :name="lang.value">
          <el-form-item :label="`${lang.label}答案`" :prop="`solutions.${lang.value}`">
            <textarea
              v-model="createForm.solutions[lang.value]"
              :placeholder="`请输入${lang.label}答案代码`"
              class="code-textarea"
              rows="15"
            ></textarea>
          </el-form-item>
        </el-tab-pane>
      </el-tabs>

      <el-form-item label="测试用例" prop="test_cases">
        <el-table
          :data="createForm.test_cases"
          :default-sort="{ prop: 'order_num', order: 'ascending' }"
          @sort-change="handleCreateTestCaseSortChange"
          class="test-cases-table"
        >
          <el-table-column
            prop="order_num"
            label="序号"
            width="80"
            sortable
          >
            <template #default="scope">
              {{ scope.row.order_num }}
            </template>
          </el-table-column>
          <el-table-column
            prop="input"
            label="输入"
          >
            <template #default="scope">
              <el-input
                v-model="scope.row.input"
                type="textarea"
                :rows="2"
                placeholder="请输入测试用例输入"
              />
            </template>
          </el-table-column>
          <el-table-column
            prop="output"
            label="输出"
          >
            <template #default="scope">
              <el-input
                v-model="scope.row.output"
                type="textarea"
                :rows="2"
                placeholder="请输入测试用例输出"
              />
            </template>
          </el-table-column>
          <el-table-column
            prop="is_example"
            label="是否为示例"
            width="120"
          >
            <template #default="scope">
              <el-switch
                v-model="scope.row.is_example"
                :active-value="true"
                :inactive-value="false"
              />
            </template>
          </el-table-column>
          <el-table-column
            label="操作"
            width="120"
          >
            <template #default="scope">
              <el-button-group>
                <el-button
                  size="small"
                  type="danger"
                  @click="removeCreateTestCase(scope.$index)"
                >
                  删除
                </el-button>
              </el-button-group>
            </template>
          </el-table-column>
        </el-table>
        <div class="table-actions">
          <el-button type="primary" @click="addCreateTestCase">
            添加测试用例
          </el-button>
        </div>
      </el-form-item>
    </el-form>

    <template #footer>
      <span class="dialog-footer">
        <el-button @click="handleCloseDialog">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">
          创建
        </el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, onMounted, watch, computed } from 'vue'
import { useToast } from 'primevue/usetoast'
import axios from 'axios'
import Button from 'primevue/button'
import Dialog from 'primevue/dialog'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'

const router = useRouter()
const toast = useToast()
const store = useStore()

// 状态数据
const problems = ref([])
const totalProblems = ref(0)
const totalCategories = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const totalPages = ref(1)
const searchQuery = ref('')
const showFilterPanel = ref(false)

const loading = ref(false)

// 分类数据
const categories = ref([])

// 添加难度统计相关的数据
const difficultyStats = ref([])

// 添加精确搜索状态
const isExactSearch = ref(false)

// 添加筛选相关的状态
const difficulties = [
  { name: '全部难度', code: '' },
  { name: '简单', code: '简单' },
  { name: '中等', code: '中等' },
  { name: '困难', code: '困难' }
]
const selectedDifficulty = ref('')
const selectedTags = ref([])
const tagSearchQuery = ref('')
const tags = ref([])

// 弹窗状态
const showCreateDialog = ref(false)
const showEditDialog = ref(false)
const showEditContentDialog = ref(false)
const showEditSolutionDialog = ref(false)
const showDeleteDialog = ref(false)
const submitting = ref(false)
const activeLanguage = ref('c')

// 当前编辑的题目
const currentProblem = ref(null)

// 创建题目表单数据
const createForm = ref({
  title: '',
  difficulty: '',
  tags: '',
  description: '',
  time_limit: 1000,
  memory_limit: 256,
  solution_approach: '',
  time_complexity: '',
  space_complexity: '',
  solutions: {
    c: '',
    cpp: '',
    java: '',
    python: ''
  },
  test_cases: [
    {
      input: '',
      output: '',
      is_example: true,
      order_num: 1
    }
  ]
})

// 表单验证规则
const formRules = {
  title: [
    { required: true, message: '请输入题目标题', trigger: 'blur' },
    { min: 2, max: 100, message: '长度在 2 到 100 个字符', trigger: 'blur' }
  ],
  difficulty: [
    { required: true, message: '请选择难度等级', trigger: 'change' }
  ],
  description: [
    { required: true, message: '请输入题目描述', trigger: 'blur' }
  ],
  time_limit: [
    { required: true, message: '请设置时间限制', trigger: 'blur' },
    { type: 'number', min: 100, max: 10000, message: '时间限制必须在100ms到10000ms之间', trigger: 'blur' }
  ],
  memory_limit: [
    { required: true, message: '请设置内存限制', trigger: 'blur' },
    { type: 'number', min: 64, max: 1024, message: '内存限制必须在64MB到1024MB之间', trigger: 'blur' }
  ],
  solution_approach: [
    { required: true, message: '请输入解题思路', trigger: 'blur' }
  ],
  time_complexity: [
    { required: true, message: '请输入时间复杂度', trigger: 'blur' }
  ],
  space_complexity: [
    { required: true, message: '请输入空间复杂度', trigger: 'blur' }
  ],
  'solutions.c': [
    { required: true, message: '请输入C语言答案', trigger: 'blur' }
  ],
  'solutions.cpp': [
    { required: true, message: '请输入C++答案', trigger: 'blur' }
  ],
  'solutions.java': [
    { required: true, message: '请输入Java答案', trigger: 'blur' }
  ],
  'solutions.python': [
    { required: true, message: '请输入Python答案', trigger: 'blur' }
  ]
}

// 编辑表单数据
const editForm = ref({
  title: '',
  difficulty: '简单',
  tags: '',
  description: '',
  time_limit: 1000,
  memory_limit: 256,
  test_cases: []
})

// 解答编辑表单数据
const solutionForm = ref({
  solution_approach: '',
  solutions: {
    c: '',
    cpp: '',
    java: '',
    python: ''
  }
})
// 语言选项
const languageOptions = [
  { label: 'C', value: 'c' },
  { label: 'C++', value: 'cpp' },
  { label: 'Java', value: 'java' },
  { label: 'Python', value: 'python' }
]

// 计算所有可用的标签
const allTags = ref([])

// 根据搜索过滤标签
const filteredTags = computed(() => {
  if (!tagSearchQuery.value) {
    return allTags.value
  }
  return allTags.value.filter(tag =>
    tag.toLowerCase().includes(tagSearchQuery.value.toLowerCase())
  )
})

// 方法定义
const getDifficultyLabel = (difficulty) => {
  const map = {
    easy: '简单',
    medium: '中等',
    hard: '困难'
  }
  return map[difficulty] || difficulty
}

const getDifficultyCount = (difficulty) => {
  const stat = difficultyStats.value.find(s => s.difficulty === difficulty)
  return stat ? stat.count : 0
}

const getDifficultyPercentage = (difficulty) => {
  const count = getDifficultyCount(difficulty)
  const total = totalProblems.value || 1
  return Math.round((count / total) * 100)
}

const handleSearch = () => {
  currentPage.value = 1
  fetchProblems()
}

const changePage = (page) => {
  currentPage.value = page
  fetchProblems()
}

const openCreateDialog = () => {
  handleCloseDialog()
  showCreateDialog.value = true
}

const createFormRef = ref(null)

// 重置表单
const handleCloseDialog = () => {
  createFormRef.value?.resetFields()
  createForm.value = {
    title: '',
    difficulty: '',
    tags: '',
    description: '',
    time_limit: 1000,
    memory_limit: 256,
    solution_approach: '',
    time_complexity: '',
    space_complexity: '',
    solutions: {
      c: '',
      cpp: '',
      java: '',
      python: ''
    },
    test_cases: [
      {
        input: '',
        output: '',
        is_example: true,
        order_num: 1
      }
    ]
  }
  activeLanguage.value = 'c'
  showCreateDialog.value = false
}

// 处理标签字符串，将中文逗号转换为英文逗号
const processTagString = (tags) => {
  if (!tags) return ''
  return tags.replace(/，/g, ',').split(',').filter(tag => tag.trim()).join(',')
}

const handleSubmit = async () => {
  try {
    submitting.value = true

    // 表单验证
    await createFormRef.value.validate()

    // 检查solutions是否都有内容
    if (!createForm.value.solutions.c.trim() ||
        !createForm.value.solutions.cpp.trim() ||
        !createForm.value.solutions.java.trim() ||
        !createForm.value.solutions.python.trim()) {
      toast.add({
        severity: 'error',
        summary: '错误',
        detail: '请填写所有编程语言的答案',
        life: 3000
      })
      return
    }

    // 检查是否至少有一个测试用例
    if (createForm.value.test_cases.length === 0) {
      toast.add({
        severity: 'error',
        summary: '错误',
        detail: '请至少添加一个测试用例',
        life: 3000
      })
      return
    }

    console.log('开始创建题目，表单数据:', createForm.value)

    const formData = { ...createForm.value }
    formData.tags = processTagString(formData.tags)

    const token = localStorage.getItem('token')
    const response = await axios.post('/api/problems/create', formData, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })

    if (response.data.code === 201) {
      console.log('题目创建成功:', response.data)
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: '创建成功',
        life: 3000
      })
      showCreateDialog.value = false
      handleCloseDialog()
      fetchProblems()
    } else {
      throw new Error(response.data.message || '创建失败')
    }
  } catch (error) {
    console.error('创建题目失败:', error)
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: error.response?.data?.message || error.message || '创建失败',
      life: 3000
    })
  } finally {
    submitting.value = false
  }
}

const reorderProblems = async () => {
  try {
    const token = localStorage.getItem('token')
    await axios.post('/api/problems/reorder', {}, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    toast.add({
      severity: 'success',
      summary: '成功',
      detail: '题目编号重新排序成功',
      life: 3000
    })
    fetchProblems()
  } catch (error) {
    console.error('重新排序失败:', error)
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: error.response?.data?.message || '重新排序失败',
      life: 3000
    })
  }
}

const toggleExactSearch = () => {
  isExactSearch.value = !isExactSearch.value
  handleSearch()
}

const formatPassRate = (rate) => {
  if (rate === null || rate === undefined) return '0.0%'
  return `${parseFloat(rate).toFixed(1)}%`
}

const getRateClass = (rate) => {
  if (rate === null || rate === undefined) return 'pass-rate-low'
  rate = parseFloat(rate)
  if (rate >= 60) return 'pass-rate-high'
  if (rate >= 40) return 'pass-rate-medium'
  return 'pass-rate-low'
}

// 监听搜索框输入
watch(searchQuery, (newVal) => {
  if (!/^\d+$/.test(newVal.trim())) {
    isExactSearch.value = false
  }
})

// 生命周期钩子
onMounted(() => {
  fetchStats()
  fetchCategories()
  fetchTags()
  fetchProblems()
})

// 获取统计信息
const fetchStats = async () => {
  try {
    const response = await axios.get('/api/problems/stats')
    if (response.data.code === 200) {
      totalProblems.value = response.data.data.totalProblems
      totalCategories.value = response.data.data.totalCategories
      difficultyStats.value = response.data.data.difficultyStats
    }
  } catch (error) {
    console.error('获取统计信息失败:', error)
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: '获取统计信息失败',
      life: 3000
    })
  }
}

// 获取分类列表
const fetchCategories = async () => {
  try {
    const response = await axios.get('/api/problems/categories')
    categories.value = response.data.data
  } catch (error) {
    console.error('获取分类列表失败:', error)
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: '获取分类列表失败',
      life: 3000
    })
  }
}

// 获取所有标签
const fetchTags = async () => {
  try {
    const response = await axios.get('/api/problems/tags')
    if (response.data.code === 200) {
      tags.value = response.data.data
    }
  } catch (error) {
    console.error('获取标签失败:', error)
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: '获取标签失败',
      life: 3000
    })
  }
}

// 获取题目列表
const fetchProblems = async () => {
  try {
    loading.value = true
    const params = {
      page: currentPage.value,
      limit: pageSize.value,
      query: searchQuery.value,
      difficulty: selectedDifficulty.value,
      tags: selectedTags.value.join(',')
    }

    const response = await axios.get('/api/problems/list', { params })
    if (response.data.code === 200) {
      problems.value = response.data.data.problems || []
      totalProblems.value = response.data.data.total || 0
      totalPages.value = Math.ceil(totalProblems.value / pageSize.value)

      // 更新所有标签
      const tags = new Set()
      problems.value.forEach(problem => {
        if (problem.tags) {
          problem.tags.split(',').forEach(tag => {
            tags.add(tag.trim())
          })
        }
      })
      allTags.value = Array.from(tags)
    } else {
      problems.value = []
      totalProblems.value = 0
      totalPages.value = 1
    }
    loading.value = false
  } catch (error) {
    console.error('获取题目列表失败:', error)
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: '获取题目列表失败',
      life: 3000
    })
    loading.value = false
  }
}

// 切换标签选择
const toggleTag = (tag) => {
  const index = selectedTags.value.indexOf(tag)
  if (index === -1) {
    selectedTags.value.push(tag)
  } else {
    selectedTags.value.splice(index, 1)
  }
  currentPage.value = 1
  fetchProblems()
}

// 清除所有筛选条件
const clearFilters = () => {
  selectedDifficulty.value = ''
  selectedTags.value = []
  tagSearchQuery.value = ''
  currentPage.value = 1
  fetchProblems()
}

// 编辑题目相关函数
const editProblem = (problem) => {
  currentProblem.value = problem
  showEditDialog.value = true
}

// 处理编辑内容选项
const handleEditContent = async () => {
  showEditDialog.value = false
  try {
    // 首先尝试从store中获取token
    let accessToken = store.getters.getAccessToken

    // 如果store中没有，再尝试从localStorage获取
    if (!accessToken) {
      const userInfoStr = localStorage.getItem('userInfo')
      const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
      accessToken = userInfo?.accessToken || localStorage.getItem('accessToken') || localStorage.getItem('token')
    }

    if (!accessToken) {
      console.error('认证token不存在')
      toast.add({
        severity: 'error',
        summary: '错误',
        detail: '认证失败，请重新登录',
        life: 3000
      })
      return
    }

    console.log('开始获取题目信息，ID:', currentProblem.value.id)

    const response = await axios.get(`/api/problems/${currentProblem.value.id}`, {
      headers: {
        Authorization: `Bearer ${accessToken}`
      }
    })
    const problemData = response.data.data

    // 获取题目的测试用例
    const testCasesResponse = await axios.get(`/api/problems/${currentProblem.value.id}/test-cases`, {
      headers: {
        Authorization: `Bearer ${accessToken}`
      }
    })
    const testCases = testCasesResponse.data.data

    editForm.value = {
      title: problemData.title,
      difficulty: problemData.difficulty,
      tags: problemData.tags,
      description: problemData.description,
      time_limit: problemData.time_limit,
      memory_limit: problemData.memory_limit,
      test_cases: testCases
    }
    showEditContentDialog.value = true
  } catch (error) {
    console.error('获取题目信息失败:', error)
    let errorMessage = '获取题目信息失败'

    if (error.response) {
      console.error('响应错误状态:', error.response.status)
      console.error('响应错误数据:', error.response.data)
      errorMessage = error.response.data?.message || errorMessage
    } else if (error.request) {
      console.error('请求错误:', error.request)
      errorMessage = '服务器无响应'
    } else {
      console.error('错误信息:', error.message)
      errorMessage = error.message
    }

    toast.add({
      severity: 'error',
      summary: '错误',
      detail: errorMessage,
      life: 3000
    })
  }
}

// 处理编辑答案选项
const handleEditSolution = async () => {
  showEditDialog.value = false
  try {
    // 首先尝试从store中获取token
    let accessToken = store.getters.getAccessToken

    // 如果store中没有，再尝试从localStorage获取
    if (!accessToken) {
      const userInfoStr = localStorage.getItem('userInfo')
      const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
      accessToken = userInfo?.accessToken || localStorage.getItem('accessToken') || localStorage.getItem('token')
    }

    if (!accessToken) {
      console.error('认证token不存在')
      toast.add({
        severity: 'error',
        summary: '错误',
        detail: '认证失败，请重新登录',
        life: 3000
      })
      return
    }

    console.log('开始获取题目解答，ID:', currentProblem.value.id)

    const response = await axios.get(`/api/problems/${currentProblem.value.id}/solution`, {
      headers: {
        Authorization: `Bearer ${accessToken}`
      }
    })
    const solutionData = response.data.data
    solutionForm.value = {
      solution_approach: solutionData.solution_approach,
      solutions: {
        c: solutionData.implementations[0].code,
        cpp: solutionData.implementations[1].code,
        java: solutionData.implementations[2].code,
        python: solutionData.implementations[3].code
      }
    }
    showEditSolutionDialog.value = true
  } catch (error) {
    console.error('获取题目解答失败:', error)
    let errorMessage = '获取题目解答失败'

    if (error.response) {
      console.error('响应错误状态:', error.response.status)
      console.error('响应错误数据:', error.response.data)
      errorMessage = error.response.data?.message || errorMessage
    } else if (error.request) {
      console.error('请求错误:', error.request)
      errorMessage = '服务器无响应'
    } else {
      console.error('错误信息:', error.message)
      errorMessage = error.message
    }

    toast.add({
      severity: 'error',
      summary: '错误',
      detail: errorMessage,
      life: 3000
    })
  }
}

// 保存内容修改
const saveContentEdit = async () => {
  try {
    // 首先尝试从store中获取token
    let accessToken = store.getters.getAccessToken

    // 如果store中没有，再尝试从localStorage获取
    if (!accessToken) {
      const userInfoStr = localStorage.getItem('userInfo')
      const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
      accessToken = userInfo?.accessToken || localStorage.getItem('accessToken') || localStorage.getItem('token')
    }

    if (!accessToken) {
      console.error('认证token不存在')
      toast.add({
        severity: 'error',
        summary: '错误',
        detail: '认证失败，请重新登录',
        life: 3000
      })
      return
    }

    const formData = { ...editForm.value }
    formData.tags = processTagString(formData.tags)

    console.log('开始保存题目内容修改，ID:', currentProblem.value.id)

    // 更新题目基本信息
    await axios.put(`/api/problems/${currentProblem.value.id}`, formData, {
      headers: {
        Authorization: `Bearer ${accessToken}`
      }
    })

    // 更新测试用例
    await axios.put(`/api/problems/${currentProblem.value.id}/test-cases`, {
      test_cases: formData.test_cases
    }, {
      headers: {
        Authorization: `Bearer ${accessToken}`
      }
    })

    showEditContentDialog.value = false
    toast.add({
      severity: 'success',
      summary: '成功',
      detail: '题目内容修改成功',
      life: 3000
    })
    fetchProblems()
  } catch (error) {
    console.error('保存修改失败:', error)
    let errorMessage = '保存修改失败'

    if (error.response) {
      console.error('响应错误状态:', error.response.status)
      console.error('响应错误数据:', error.response.data)
      errorMessage = error.response.data?.message || errorMessage
    } else if (error.request) {
      console.error('请求错误:', error.request)
      errorMessage = '服务器无响应'
    } else {
      console.error('错误信息:', error.message)
      errorMessage = error.message
    }

    toast.add({
      severity: 'error',
      summary: '错误',
      detail: errorMessage,
      life: 3000
    })
  }
}

// 编辑测试用例相关方法
const addEditTestCase = () => {
  editForm.value.test_cases.push({
    input: '',
    output: '',
    is_example: false,
    order_num: editForm.value.test_cases.length + 1
  })
}

const removeEditTestCase = (index) => {
  editForm.value.test_cases.splice(index, 1)
  // 重新排序
  editForm.value.test_cases.forEach((testCase, idx) => {
    testCase.order_num = idx + 1
  })
}

const handleEditTestCaseSortChange = ({ column, prop, order }) => {
  if (prop === 'order_num') {
    editForm.value.test_cases.sort((a, b) => {
      return order === 'ascending' ? a.order_num - b.order_num : b.order_num - a.order_num
    })
  }
}

// 保存答案修改
const saveSolutionEdit = async () => {
  try {
    // 首先尝试从store中获取token
    let accessToken = store.getters.getAccessToken

    // 如果store中没有，再尝试从localStorage获取
    if (!accessToken) {
      const userInfoStr = localStorage.getItem('userInfo')
      const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
      accessToken = userInfo?.accessToken || localStorage.getItem('accessToken') || localStorage.getItem('token')
    }

    if (!accessToken) {
      console.error('认证token不存在')
      toast.add({
        severity: 'error',
        summary: '错误',
        detail: '认证失败，请重新登录',
        life: 3000
      })
      return
    }

    console.log('开始保存题目答案修改，ID:', currentProblem.value.id)

    await axios.put(`/api/problems/${currentProblem.value.id}/solution`, {
      solution_approach: solutionForm.value.solution_approach,
      solutions: {
        c: solutionForm.value.solutions.c,
        cpp: solutionForm.value.solutions.cpp,
        java: solutionForm.value.solutions.java,
        python: solutionForm.value.solutions.python
      }
    }, {
      headers: {
        Authorization: `Bearer ${accessToken}`
      }
    })
    showEditSolutionDialog.value = false
    toast.add({
      severity: 'success',
      summary: '成功',
      detail: '题目答案修改成功',
      life: 3000
    })
  } catch (error) {
    console.error('保存修改失败:', error)
    let errorMessage = '保存修改失败'

    if (error.response) {
      console.error('响应错误状态:', error.response.status)
      console.error('响应错误数据:', error.response.data)
      errorMessage = error.response.data?.message || errorMessage
    } else if (error.request) {
      console.error('请求错误:', error.request)
      errorMessage = '服务器无响应'
    } else {
      console.error('错误信息:', error.message)
      errorMessage = error.message
    }

    toast.add({
      severity: 'error',
      summary: '错误',
      detail: errorMessage,
      life: 3000
    })
  }
}

// 删除题目
const deleteProblem = (problem) => {
  currentProblem.value = problem
  showDeleteDialog.value = true
}

// 确认删除
const confirmDelete = async () => {
  try {
    // 首先尝试从store中获取token
    let accessToken = store.getters.getAccessToken

    // 如果store中没有，再尝试从localStorage获取
    if (!accessToken) {
      const userInfoStr = localStorage.getItem('userInfo')
      const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
      accessToken = userInfo?.accessToken || localStorage.getItem('accessToken') || localStorage.getItem('token')
    }

    if (!accessToken) {
      console.error('认证token不存在')
      toast.add({
        severity: 'error',
        summary: '错误',
        detail: '认证失败，请重新登录',
        life: 3000
      })
      return
    }

    console.log('开始删除题目，ID:', currentProblem.value.id)

    const response = await axios.delete(`/api/problems/${currentProblem.value.id}`, {
      headers: {
        Authorization: `Bearer ${accessToken}`
      }
    })

    if (response.data.code === 200) {
      showDeleteDialog.value = false
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: '题目删除成功',
        life: 3000
      })
      fetchProblems()
    } else {
      throw new Error(response.data.message || '删除失败')
    }
  } catch (error) {
    console.error('删除失败:', error)
    let errorMessage = '删除失败'

    if (error.response) {
      console.error('响应错误状态:', error.response.status)
      console.error('响应错误数据:', error.response.data)
      errorMessage = error.response.data?.message || errorMessage
    } else if (error.request) {
      console.error('请求错误:', error.request)
      errorMessage = '服务器无响应'
    } else {
      console.error('错误信息:', error.message)
      errorMessage = error.message
    }

    toast.add({
      severity: 'error',
      summary: '错误',
      detail: errorMessage,
      life: 3000
    })
  }
}

// 监听难度选择变化
watch(selectedDifficulty, () => {
  currentPage.value = 1
  fetchProblems()
})

// 监听语言切换
watch(() => solutionForm.value.currentLanguage, async (newLang) => {
  try {
    const token = localStorage.getItem('token')
    const response = await axios.get(
      `/api/problems/${currentProblem.value.id}/solution/${newLang}`,
      {
        headers: {
          Authorization: `Bearer ${token}`
        }
      }
    )
    if (response.data.code === 200) {
      solutionForm.value.solutions[newLang] = response.data.data.standard_solution
    }
  } catch (error) {
    console.error('获取代码失败:', error)
    toast.add({
      severity: 'error',
      summary: '错误',
      detail: error.response?.data?.message || '获取代码失败',
      life: 3000
    })
  }
})

// 添加和删除测试用例的方法
const addCreateTestCase = () => {
  createForm.value.test_cases.push({
    input: '',
    output: '',
    is_example: false,
    order_num: createForm.value.test_cases.length + 1
  })
}

const removeCreateTestCase = (index) => {
  createForm.value.test_cases.splice(index, 1)
  // 重新排序
  createForm.value.test_cases.forEach((testCase, idx) => {
    testCase.order_num = idx + 1
  })
}

const handleCreateTestCaseSortChange = ({ column, prop, order }) => {
  if (prop === 'order_num') {
    createForm.value.test_cases.sort((a, b) => {
      return order === 'ascending' ? a.order_num - b.order_num : b.order_num - a.order_num
    })
  }
}

// 跳转到题目池页面
const gotoProblemPool = () => {
  router.push('/admin/problem-pool')
}
</script>

<style scoped>
.problems-management {
  padding: 24px;
  background-color: #f5f5f7;
  min-height: 100vh;
}

.statistics-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 24px;
  margin-bottom: 32px;
}

.stat-card {
  background: white;
  border-radius: 16px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  transition: transform 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: linear-gradient(135deg, #007AFF, #5856D6);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 20px;
}

.stat-content {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: #1d1d1f;
}

.stat-label {
  font-size: 14px;
  color: #86868b;
  margin-top: 4px;
}

.action-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
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

.btn-import, .btn-create, .btn-reorder, .btn-filter {
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
}

.btn-import {
  background: #007AFF;
  color: white;
}

.btn-import:hover {
  background: #0066CC;
}

.btn-create {
  background: #007AFF;
  color: white;
}

.btn-create:hover {
  background: #0066CC;
}

.btn-reorder {
  background: rgba(0, 122, 255, 0.1);
  color: #007AFF;
}

.btn-reorder:hover {
  background: rgba(0, 122, 255, 0.2);
}

.btn-filter {
  background: rgba(0, 122, 255, 0.1);
  color: #007AFF;
}

.btn-filter:hover {
  background: rgba(0, 122, 255, 0.2);
}

.filter-panel {
  background: white;
  border-radius: 16px;
  padding: 24px;
  margin-bottom: 24px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.filter-group {
  margin-bottom: 20px;
}

.filter-group h3 {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 12px;
  color: #1d1d1f;
}

.difficulty-filters {
  margin-bottom: 16px;
}

.difficulty-select {
  width: 100%;
}

.tag-search {
  margin-bottom: 16px;
}

.tag-search-input {
  width: 100%;
  padding: 8px 12px;
  border-radius: 8px;
  border: 1px solid #eaeaea;
  font-size: 14px;
  outline: none;
  transition: all 0.3s ease;
}

.tag-search-input:focus {
  border-color: #007AFF;
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.1);
}

.tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.category-tag {
  padding: 6px 12px;
  border-radius: 6px;
  background: #f5f5f7;
  border: 1px solid #eaeaea;
  color: #666;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.category-tag:hover {
  background: #eaeaea;
  border-color: #007AFF;
  color: #007AFF;
}

.category-tag.active {
  background: #007AFF;
  color: white;
  border-color: #007AFF;
}

.filter-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #eaeaea;
}

.btn-clear {
  padding: 8px 16px;
  border-radius: 8px;
  background: #f5f5f7;
  border: none;
  color: #666;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-clear:hover {
  background: #eaeaea;
  color: #007AFF;
}

.problems-table {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.table-header {
  display: grid;
  grid-template-columns: 80px 2fr 1fr 1.5fr 120px 120px 140px;
  padding: 16px;
  background: #f8f8fa;
  font-weight: 600;
  color: #1d1d1f;
  border-bottom: 1px solid #eaeaea;
}

.table-row {
  display: grid;
  grid-template-columns: 80px 2fr 1fr 1.5fr 120px 120px 140px;
  padding: 16px;
  border-bottom: 1px solid #f5f5f7;
  align-items: center;
  background: white;
  transition: background-color 0.3s ease;
}

.table-row:hover {
  background: #f8f8fa;
}

.col-id {
  color: #666;
  font-weight: 500;
}

.col-title {
  color: #1d1d1f;
  font-weight: 500;
}

.difficulty-easy {
  color: #34C759;
  font-weight: 500;
}
.difficulty-medium {
  color: #FF9500;
  font-weight: 500;
}
.difficulty-hard {
  color: #FF3B30;
  font-weight: 500;
}

.col-category .category-tag {
  display: inline-block;
  padding: 4px 8px;
  background: rgba(255, 165, 0, 0.1);
  color: #ff9800;
  border-radius: 6px;
  font-size: 12px;
  margin-right: 4px;
  font-weight: 500;
}

.col-category .category-tag:hover {
  background: rgba(255, 165, 0, 0.2);
}

.col-submit {
  color: #1d1d1f;
  font-weight: 500;
  text-align: center;
  padding: 0 10px;
}

.col-rate {
  text-align: center;
  padding: 0 10px;
}

.pass-rate-high {
  color: #34C759;
  font-weight: 600;
}

.pass-rate-medium {
  color: #FF9500;
  font-weight: 600;
}

.pass-rate-low {
  color: #FF3B30;
  font-weight: 600;
}

.col-actions {
  display: flex;
  justify-content: center;
  gap: 12px;
  padding: 0 10px;
}

.btn-edit, .btn-delete {
  padding: 8px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-edit {
  background: rgba(0, 122, 255, 0.1);
  color: #007AFF;
  margin-right: 8px;
}

.btn-delete {
  background: rgba(255, 59, 48, 0.1);
  color: #FF3B30;
}

.btn-edit:hover {
  background: rgba(0, 122, 255, 0.2);
}

.btn-delete:hover {
  background: rgba(255, 59, 48, 0.2);
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 24px;
}

.pagination button {
  padding: 8px 16px;
  border-radius: 8px;
  border: none;
  background: white;
  color: #007AFF;
  cursor: pointer;
  transition: all 0.3s ease;
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

.development-notice {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.notice-content {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  max-width: 90%;
  width: 400px;
}

.notice-icon {
  font-size: 3rem;
  color: #3b82f6;
  margin-bottom: 1rem;
}

.notice-content h2 {
  color: #1f2937;
  margin-bottom: 0.5rem;
  font-size: 1.5rem;
}

.notice-content p {
  color: #6b7280;
  margin-bottom: 1.5rem;
}

.stat-distribution {
  margin-top: 8px;
}

.difficulty-bar {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
  gap: 8px;
}

.difficulty-label {
  width: 40px;
  font-size: 12px;
  color: #666;
}

.difficulty-count {
  width: 40px;
  font-size: 12px;
  color: #666;
  text-align: right;
}

.bar-wrapper {
  flex: 1;
  height: 6px;
  background: #f0f0f5;
  border-radius: 3px;
  overflow: hidden;
}

.bar {
  height: 100%;
  border-radius: 3px;
  transition: width 0.3s ease;
}

.bar.easy {
  background: #4ecdc4;
}

.bar.medium {
  background: #ffbe0b;
}

.bar.hard {
  background: #ff6b6b;
}

:deep(.el-select) {
  width: 100%;
}

:deep(.el-input__wrapper) {
  background-color: white !important;
  box-shadow: 0 0 0 1px #eaeaea !important;
}

:deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #007AFF !important;
}

:deep(.el-select__caret) {
  color: #666;
}

.edit-dialog,
.edit-content-dialog,
.edit-solution-dialog,
.delete-dialog {
  min-width: 800px;
}

.edit-options {
  display: flex;
  gap: 20px;
  padding: 20px;
}

.edit-option {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 20px;
  border: 1px solid #eaeaea;
  border-radius: 8px;
  background: white;
  cursor: pointer;
  transition: all 0.3s ease;
}

.edit-option:hover {
  border-color: #007AFF;
  background: #f0f7ff;
}

.edit-option i {
  font-size: 24px;
  color: #007AFF;
}

.edit-option span {
  font-size: 16px;
  color: #1d1d1f;
}

.edit-form {
  padding: 20px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
  color: #1d1d1f;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #eaeaea;
  border-radius: 6px;
  font-size: 14px;
}

.form-group textarea {
  min-height: 150px;
  resize: both;
}

.form-row {
  display: flex;
  gap: 20px;
}

.form-group.half {
  flex: 1;
}

.code-editor {
  font-family: monospace;
  min-height: 400px;
  resize: both;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 20px;
}

.btn-save,
.btn-cancel,
.btn-confirm {
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-save {
  background: #007AFF;
  color: white;
  border: none;
}

.btn-save:hover {
  background: #0066CC;
}

.btn-cancel {
  background: #f5f5f7;
  color: #666;
  border: none;
}

.btn-cancel:hover {
  background: #eaeaea;
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

.btn-confirm {
  background: #FF3B30;
  color: white;
  border: none;
}

.btn-confirm:hover {
  background: #FF2D55;
}

.dialog-actions {
  display: flex;
  justify-content: center;
  gap: 12px;
}

:deep(.p-dialog-header) {
  padding: 1.5rem;
  background: #f8f8fa;
  border-bottom: 1px solid #eaeaea;
}

:deep(.p-dialog-content) {
  padding: 0;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.el-tabs {
  margin-top: 20px;
}

.code-textarea {
  width: 100%;
  font-family: monospace;
  font-size: 14px;
  padding: 10px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  resize: vertical;
  background-color: #f8f9fa;
}

.code-textarea:focus {
  outline: none;
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.edit-solution-dialog {
  .el-tabs {
    margin-bottom: 20px;
  }

  .el-tab-pane {
    padding: 15px;
  }
}

.test-cases-table {
  margin-top: 16px;
  border-radius: 8px;
  overflow: hidden;
}

.test-cases-table :deep(.el-table__header) {
  background-color: #f8f8fa;
}

.test-cases-table :deep(.el-table__row) {
  background-color: white;
}

.test-cases-table :deep(.el-input__wrapper) {
  box-shadow: none !important;
  background-color: transparent !important;
}

.test-cases-table :deep(.el-textarea__inner) {
  background-color: #f8f8fa;
  border: 1px solid #eaeaea;
  border-radius: 4px;
  padding: 8px;
  font-family: monospace;
}

.test-cases-table :deep(.el-textarea__inner:focus) {
  border-color: #007AFF;
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.1);
}

.table-actions {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
}

.table-actions .el-button {
  margin-left: 12px;
}
</style>

<style>
/* Element Plus 下拉菜单样式 */
.admin-problems-select {
  background-color: white !important;
  border: 1px solid #eaeaea !important;
  border-radius: 8px !important;
}

.admin-problems-select .el-select-dropdown__item {
  color: #666 !important;
}

.admin-problems-select .el-select-dropdown__item.hover {
  background-color: #f5f7fa !important;
}

.admin-problems-select .el-select-dropdown__item.selected {
  color: #007AFF !important;
  background-color: #f0f7ff !important;
}

.admin-problems-select .el-popper__arrow::before {
  background-color: white !important;
  border-color: #eaeaea !important;
}

.admin-problems-select .el-scrollbar__thumb {
  background-color: #c0c4cc !important;
}

/* 新建题目对话框中的难度选择下拉栏样式 */
.el-select-dropdown {
  background-color: white !important;
  border: 1px solid #eaeaea !important;
}

.el-select-dropdown__item {
  color: #606266 !important;
}

.el-select-dropdown__item.hover,
.el-select-dropdown__item:hover {
  background-color: #f5f7fa !important;
}

.el-select-dropdown__item.selected {
  color: #007AFF !important;
  background-color: #f0f7ff !important;
}

.el-popper.is-light {
  background-color: white !important;
  border: 1px solid #eaeaea !important;
}

/* 确保下拉框的输入框背景也是白色 */
.el-input__wrapper {
  background-color: white !important;
}

.el-select .el-input__wrapper {
  background-color: white !important;
  box-shadow: 0 0 0 1px #eaeaea !important;
}

.el-select:hover .el-input__wrapper {
  box-shadow: 0 0 0 1px #007AFF !important;
}
</style>
