<template>
  <div class="problem-detail">
    <nav-bar></nav-bar>
    <div class="content">
      <!-- 左侧题目描述区域 -->
      <div class="problem-description">
        <div class="problem-header">
          <div class="action-buttons">
            <button class="back-button" @click="goBack">返回题目列表</button>
          </div>
          <div class="title-section">
            <div class="title-row">
              <span class="problem-number">#{{ problem?.problem_number || '0001' }}</span>
              <h1>{{ problem?.title || '加载中...' }}</h1>
            </div>
            <div class="problem-stats">
              <span class="difficulty-tag" :class="problem?.difficulty?.toLowerCase()">
                {{ problem?.difficulty || '未知' }}
              </span>
              <span class="submission-info">提交: {{ problem?.total_submissions || 0 }}</span>
              <span class="rate-info">通过率: {{ problem?.acceptance_rate || 0 }}%</span>
            </div>
          </div>
        </div>

        <div class="description-content">
          <div class="tabs">
            <button 
              class="tab-button" 
              :class="{ active: activeTab === 'description' }"
              @click="activeTab = 'description'"
            >
              题目描述
            </button>
            <button 
              class="tab-button" 
              :class="{ active: activeTab === 'solution' }"
              @click="activeTab = 'solution'"
            >
              答案
            </button>
            <button 
              class="tab-button" 
              :class="{ active: activeTab === 'submissions' }"
              @click="activeTab = 'submissions'"
            >
              提交记录
            </button>
            <button 
              class="tab-button" 
              :class="{ active: activeTab === 'aiAnalysis' }"
              @click="activeTab = 'aiAnalysis'"
            >
              AI 代码分析
            </button>
          </div>

          <div class="tab-content">
            <div v-if="activeTab === 'description'" class="description">
              <div class="problem-text">
                <div class="description-text">
                  <h3 class="description-title">题目描述</h3>
                  {{ problem?.description || '加载中...' }}
                </div>

                <div class="examples">
                  <div v-for="(example, index) in problemExamples" :key="index" class="example-block">
                    <h4 class="example-title">样例 {{ index + 1 }}</h4>
                    <div class="example-columns">
                      <div class="example-input">
                        <div class="example-header">
                          <span>样例输入</span>
                          <button class="copy-button" @click="copyExampleInput(example.input)">
                            <el-icon><Document /></el-icon>
                            <span>复制</span>
                          </button>
                        </div>
                        <pre>{{ example.input }}</pre>
                      </div>
                      <div class="example-output">
                        <div class="example-header">
                          <span>样例输出</span>
                          <button class="copy-button" @click="copyExampleOutput(example.output)">
                            <el-icon><Document /></el-icon>
                            <span>复制</span>
                          </button>
                        </div>
                        <pre>{{ example.output }}</pre>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="problem-meta">
                  <div class="meta-item">
                    <i class="el-icon-time"></i>
                    <span class="meta-label">时间限制：</span>
                    <span class="meta-value">{{ problem?.time_limit || 1000 }}ms</span>
                  </div>
                  <div class="meta-item">
                    <i class="el-icon-cpu"></i>
                    <span class="meta-label">内存限制：</span>
                    <span class="meta-value">{{ problem?.memory_limit || 128 }}MB</span>
                  </div>
                </div>
              </div>
            </div>
            <div v-else-if="activeTab === 'solution'" class="solution">
              <div v-if="!problem?.solution" class="no-solution">
                <el-empty description="暂无答案" />
              </div>
              <div v-else class="solution-content">
                <div class="solution-header">
                  <h3>解题思路</h3>
                </div>
                <div class="solution-approach">
                  {{ problem.solution.solution_approach }}
                </div>

                <div class="solution-complexity">
                  <div class="complexity-item">
                    <span class="complexity-label">时间复杂度：</span>
                    <span class="complexity-value">{{ problem.solution.time_complexity }}</span>
                  </div>
                  <div class="complexity-item">
                    <span class="complexity-label">空间复杂度：</span>
                    <span class="complexity-value">{{ problem.solution.space_complexity }}</span>
                  </div>
                </div>

                <div class="solution-implementations">
                  <div class="implementations-header">
                    <h4>代码实现</h4>
                    <el-select v-model="selectedLanguage" placeholder="选择语言" size="small" @change="onLanguageChange">
                      <el-option
                        v-for="lang in problem.solution.languages"
                        :key="lang.id"
                        :label="lang.name"
                        :value="lang.name"
                      />
                    </el-select>
                  </div>

                  <!-- 修改：只有当用户手动选择语言后才显示代码 -->
                  <div v-if="selectedLanguage && hasUserSelectedLanguage" v-for="impl in filteredImplementations" :key="impl.language" class="implementation-block">
                    <div class="code-header">
                      <div class="language-info">
                        <span class="language-name">{{ impl.language }}</span>
                        <span class="version-tag">v{{ impl.version }}</span>
                      </div>
                      <button class="copy-code-button" @click="copyImplementationCode(impl.code)">
                        <i :class="['el-icon-document-copy', { 'copied': justCopied }]"></i>
                        {{ justCopied ? '已复制' : '复制代码' }}
                      </button>
                    </div>
                    <pre class="code-block"><code class="language-javascript">{{ impl.code }}</code></pre>
                  </div>

                  <div v-else class="language-selection">
                    <p>请选择答案语言</p>
                    
                  </div>
                </div>
              </div>
            </div>
            <div v-else-if="activeTab === 'submissions'" class="submissions">
              <!-- 搜索和筛选控件 -->
              <div class="search-controls">
                <el-select
                  v-model="filters.status"
                  placeholder="选择状态"
                  class="filter-select"
                  popper-class="dark-select"
                  clearable
                  @change="currentPage = 1"
                >
                  <el-option
                    v-for="option in statusOptions"
                    :key="option.code"
                    :label="option.name"
                    :value="option.code"
                  />
                </el-select>
                <el-select
                  v-model="filters.language"
                  placeholder="选择语言"
                  class="filter-select"
                  popper-class="dark-select"
                  clearable
                  @change="currentPage = 1"
                >
                  <el-option
                    v-for="option in languageOptions"
                    :key="option.code"
                    :label="option.name"
                    :value="option.code"
                  />
                </el-select>
                
                
              </div>

              <!-- 提交记录列表 -->
              <div class="submissions-list">
                <div v-if="filteredSubmissions.length === 0" class="no-submissions">
                  <el-empty description="暂无提交记录" />
                </div>
                <div 
                  v-for="submission in paginatedSubmissions" 
                  :key="submission.id"
                  class="submission-card"
                  @click="showSubmissionDetail(submission)"
                >
                  <div class="submission-status" :class="getStatusClass(submission.status)">
                    {{ getStatusText(submission.status) }}
                  </div>
                  <div class="submission-info">
                    <div class="submission-time">
                      {{ formatDate(submission.created_at) }}
                    </div>
                    <div class="submission-details">
                      <span class="language">{{ submission.language }}</span>
                      <span v-if="submission.runtime" class="runtime">运行时间: {{ submission.runtime }}ms</span>
                      <span v-if="submission.memory" class="memory">内存: {{ formatMemory(submission.memory) }}</span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 分页控件 -->
              <div class="pagination-controls">
                <button @click="prevPage" :disabled="currentPage === 1">
                  <el-icon><ArrowLeft /></el-icon>
                </button>
                <span>第 {{ currentPage }} 页</span>
                <button @click="nextPage" :disabled="currentPage === totalPages">
                  <el-icon><ArrowRight /></el-icon>
                </button>
              </div>

              <!-- 提交详情弹窗 -->
              <Dialog 
                v-model:visible="dialogVisible" 
                modal 
                :header="'提交详情'"
                :style="{ width: '80vw', border: '2px solid #333' }"
                :breakpoints="{ '960px': '75vw', '641px': '90vw' }"
                :closable="true"
                :closeOnEscape="true"
              >
                <div class="submission-detail" v-if="selectedSubmission">
                  <div class="submission-header">
                    <div class="status-section">
                      <div class="status-label">状态：</div>
                      <div :class="['status-value', getStatusClass(selectedSubmission.status)]">
                        {{ getStatusText(selectedSubmission.status) }}
                      </div>
                    </div>
                    <div class="submission-stats">
                      <div class="stat-item">
                        <span class="stat-label">语言：</span>
                        <span class="stat-value">{{ selectedSubmission.language }}</span>
                      </div>
                      <div class="stat-item" v-if="selectedSubmission.runtime">
                        <span class="stat-label">运行时间：</span>
                        <span class="stat-value">{{ selectedSubmission.runtime }}ms</span>
                      </div>
                      <div class="stat-item" v-if="selectedSubmission.memory">
                        <span class="stat-label">内存：</span>
                        <span class="stat-value">{{ formatMemory(selectedSubmission.memory) }}</span>
                      </div>
                      <div class="stat-item">
                        <span class="stat-label">提交时间：</span>
                        <span class="stat-value">{{ formatDate(selectedSubmission.created_at) }}</span>
                      </div>
                    </div>
                  </div>

                  <div class="code-section">
                    <h4>提交代码</h4>
                    <div class="code-container">
                      <pre><code v-html="highlightCode(selectedSubmission.code, selectedSubmission.language)"></code></pre>
                      <button class="copy-button" @click="copyCode" :title="copyStatus">
                        <i :class="copied ? 'el-icon-check' : 'el-icon-document-copy'"></i>
                        复制
                      </button>
                    </div>
                  </div>

                  <div v-if="selectedSubmission.error_message" class="error-section">
                    <h4>错误信息</h4>
                    <pre class="error-message">{{ selectedSubmission.error_message }}</pre>
                  </div>  
                </div>
              </Dialog>
            </div>
            <div v-else-if="activeTab === 'aiAnalysis'" class="ai-analysis-tab">
              <div class="analysis-overview">
                <div v-if="!aiAnalysisResult && !isAnalyzing" class="no-analysis">
                  <el-empty description="请点击代码编辑器中的 AI 分析按钮获取分析结果" />
                </div>
                
                <div v-else-if="isAnalyzing" class="analysis-loading">
                  <div class="loading-spinner">
                    <i class="el-icon-loading analyzing-icon"></i>
                    <span>正在分析代码，请稍候...</span>
                  </div>
                </div>

                <div v-else class="analysis-result-content">
                  <!-- 错误分析部分 -->
                  <div v-if="aiAnalysisResult.errors?.length" class="analysis-section error-section">
                    <div class="section-header">
                      <div class="section-title">
                        <i class="el-icon-warning-outline"></i>
                        <span>错误分析</span>
                      </div>
                      <div class="error-summary">
                        发现 {{ aiAnalysisResult.errors.length }} 个问题
                      </div>
                    </div>
                    <div class="error-list">
                      <div v-for="(error, index) in aiAnalysisResult.errors" 
                        :key="index" 
                        class="error-card"
                      >
                        <div class="error-card-header">
                          <div class="error-type-badge" :class="error.severity">
                            {{ error.type }}
                          </div>
                          <div class="error-location-badge">
                            <i class="el-icon-location-information"></i>
                            {{ error.location }}
                          </div>
                        </div>
                        <div class="error-card-content">
                          <div class="error-message">{{ error.message }}</div>
                          <div v-if="error.code" class="code-block">
                            <pre><code v-html="highlightCode(error.code, selectedLanguageForCode.value)"></code></pre>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- 逻辑分析部分 -->
                  <div v-if="aiAnalysisResult.improvements?.length" class="analysis-section logic-section">
                    <div class="section-header">
                      <div class="section-title">
                        <i class="el-icon-warning"></i>
                        <span>逻辑分析</span>
                      </div>
                      <div class="logic-summary">
                        {{ aiAnalysisResult.improvements.length }} 条逻辑问题
                      </div>
                    </div>
                    <div class="insights-list">
                      <div v-for="(improvement, index) in aiAnalysisResult.improvements" 
                        :key="index" 
                        class="insight-item"
                      >
                        <i :class="improvement.icon" class="insight-icon"></i>
                        <div class="insight-content">
                          <div class="insight-title">{{ improvement.title }}</div>
                          <div class="insight-description" v-html="highlightInlineCode(improvement.description)"></div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧代码编辑区域 -->
      <div class="code-section">
        <div class="code-header">
          <div class="language-select-wrapper">
            <el-select
              v-model="selectedLanguageForCode"
              placeholder="选择语言"
              class="language-select"
              popper-class="dark-select"
            >
              <el-option label="C" value="C" />
              <el-option label="C++" value="C++" />
              <el-option label="Python" value="Python" />
              <el-option label="Java" value="Java" />
            </el-select>
          </div>
          <div class="action-buttons">
            <button class="run-button" @click="runCode" :disabled="isRunning">
              {{ isRunning ? '运行中...' : '运行代码' }}
            </button>
            <button 
              class="ai-analyze-button" 
              @click="getAiAnalysis"
              :disabled="!code.trim() || isAnalyzing"
            >
              <i :class="[
                isAnalyzing ? 'el-icon-loading analyzing-icon' : 'el-icon-magic-stick'
              ]"></i>
              {{ isAnalyzing ? '分析中...' : 'AI分析' }}
            </button>
            <button class="submit-button" @click="submitCode" :disabled="isSubmitting">
              {{ isSubmitting ? '提交中...' : '提交' }}
            </button>
          </div>
        </div>
        <div class="code-editor">
          <!-- 修改行号部分 -->
          <!-- <div class="line-numbers">
            <div v-for="n in lineCount" :key="n" class="line-number">
              {{ n }}
            </div>
          </div> -->
          <div class="editor-wrapper">
            <div class="code-content">
              <textarea
                v-model="code"
                class="p-inputtextarea"
                @input="handleCodeInput"
                @keydown="handleKeyDown"
                @click="updateCursorPosition"
                @select="updateCursorPosition"
                :placeholder="'请输入你的代码...'"
              ></textarea>
              <pre class="code-highlight" v-html="highlightedCode"></pre>
            </div>
          </div>
          <!-- 修改状态栏部分 -->
          <div class="editor-status-bar" v-show="true">
            行 {{ cursorPosition.line }}, 列 {{ cursorPosition.column }}
          </div>
        </div>
        <div class="console-output" :class="{ 'collapsed': isConsoleCollapsed }">
          <div class="console-header">
            <!-- 去掉原本的图标 -->
            <i :class="['arrow-icon', isExpanded ? 'fas fa-chevron-down' : 'fas fa-chevron-right']" @click="toggleConsole"></i>
            <div class="console-title">
              <span>控制台</span>
            </div>
          </div>
          <div class="console-content" v-show="!isConsoleCollapsed">
            <div class="console-tabs">
              <div 
                v-for="tab in consoleTabs" 
                :key="tab.id"
                class="console-tab"
                :class="{ active: activeConsoleTab === tab.id }"
                @click="activeConsoleTab = tab.id"
              >
                <span>{{ tab.name }}</span>
              </div>
            </div>
            
            <!-- 测试用例面板 -->
            <div v-if="activeConsoleTab === 'testCase'" class="tab-panel">
              <textarea 
                v-model="customInput"
                placeholder="输入测试用例..."
                class="custom-input-textarea"
                style="border: 1px solid #4ecdc4; background-color: rgba(78, 205, 196, 0.1); box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); transition: border-color 0.3s;"
                @focus="(event) => { event.target.style.borderColor='#4caf50'; event.target.style.boxShadow='0 0 5px rgba(76, 175, 80, 0.5)'; }"
                @blur="(event) => { event.target.style.borderColor='#4ecdc4'; event.target.style.boxShadow='none'; }"
              ></textarea>
            </div>

            <!-- 程序输出面板 -->
            <div v-if="activeConsoleTab === 'output'" class="tab-panel">
              <div class="output-sections">
                <div class="actual-output">
                  <div class="output-title">实际输出：</div>
                  <pre class="output-content" :class="{ 'error': runStatus === 'error' }">{{ consoleOutput || '暂无输出' }}</pre>
                </div>
                <div class="expected-output">
                  <div class="output-title">预期输出：</div>
                  <pre class="output-content">{{ problem?.example?.output || '暂无预期输出' }}</pre>
                </div>
              </div>
            </div>

            <!-- 编译器输出面板 -->
            <div v-if="activeConsoleTab === 'compiler'" class="tab-panel">
              <pre class="compiler-output" :class="{ 'error': runStatus === 'error' }">{{ compilerOutput || '暂无编译器输出' }}</pre>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent, ref, onMounted, computed, watch, nextTick, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { Document, ArrowLeft, ArrowRight } from '@element-plus/icons-vue'
// 新增高亮库引入
import Prism from 'prismjs'
import 'prismjs/themes/prism-tomorrow.css'
// 添加C语言语法支持
import 'prismjs/components/prism-c'
import { Dialog } from 'element-plus'
import InputTextarea from 'primevue/textarea'
import { getProblemExamples } from '@/api/testCase'

export default defineComponent({
  name: 'ProblemDetail',
  components: {
    NavBar,
    Document,
    Dialog,
    ArrowLeft,
    ArrowRight,
    InputTextarea,
  },
  setup() {
    const router = useRouter()
    const route = useRoute()
    const problem = ref(null)
    const activeTab = ref('description')
    const selectedLanguage = ref('')
    const hasUserSelectedLanguage = ref(false)
    const code = ref('')
    const submissionFilter = ref('全部')
    const selectedSubmission = ref(null)
    const submissions = ref([])
    const problemExamples = ref([])  // 添加problemExamples
    const aiAnalysisResult = ref({
      errors: [],
      improvements: []
    })
    const activeConsoleTab = ref('testCase')
    const customInput = ref('')
    const consoleOutput = ref('')
    const compilerOutput = ref('')
    const isRunning = ref(false)
    const runStatus = ref('')
    const runtime = ref(0)
    const selectedLanguageForCode = ref('C')
    const highlightedCode = ref('')
    const isCursorVisible = ref(false)
    const isSubmitting = ref(false)
    const cursorPosition = ref({ line: 1, column: 1 })
    const isConsoleCollapsed = ref(true)
    const consoleTabs = ref([
      { id: 'testCase', name: '测试用例' },
      { id: 'output', name: '程序输出' },
      { id: 'compiler', name: '编译器输出' }
    ])

    const isExpanded = ref(false)

    const toggleConsole = () => {
      isExpanded.value = !isExpanded.value
      // 控制控制台的展开和收起逻辑
      const consoleElement = document.querySelector('.console-content') // 假设控制台内容的类名为 console-content
      if (consoleElement) {
        consoleElement.style.display = isExpanded.value ? 'block' : 'none'; // 根据状态显示或隐藏控制台内容
      }
    }

    // 修改行号计算逻辑
    const lineCount = computed(() => {
      // 返回实际的代码行数，不设置最小值
      return code.value.split('\n').length;
    });

    const fetchProblem = async () => {
      try {
        const userInfoStr = localStorage.getItem('userInfo')
        const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
        const accessToken = userInfo?.accessToken || localStorage.getItem('accessToken')
        
        if (!accessToken) {
          console.error('未找到用户token')
          return
        }

        const headers = { Authorization: `Bearer ${accessToken}` }
        const problemNumber = route.params.id.padStart(4, '0')
        const [problemRes, solutionRes] = await Promise.all([
          axios.get(`http://localhost:3000/api/problems/${problemNumber}`, { headers }),
          axios.get(`http://localhost:3000/api/problems/${problemNumber}/solution`, { headers })
        ])
        
        if (problemRes.data && problemRes.data.code === 200) {
          problem.value = {
            ...problemRes.data.data,
            example: {
              input: problemRes.data.data.input_example,
              output: problemRes.data.data.output_example
            }
          }

          if (solutionRes.data && solutionRes.data.code === 200) {
            problem.value.solution = solutionRes.data.data
          }
        }
      } catch (error) {
        console.error('获取题目失败:', error)
      }
    }

    const goBack = () => {
      router.push('/problems')
    }

    const filteredSubmissions = computed(() => {
      // 根据状态和语言筛选提交记录
      return submissions.value.filter(submission => {
        // 状态筛选
        const statusMatch = !filters.status || submission.status === filters.status;
        // 语言筛选
        const languageMatch = !filters.language || submission.language.toLowerCase() === filters.language.toLowerCase();
        // 同时满足状态和语言筛选条件
        return statusMatch && languageMatch;
      });
    })

    const selectSubmission = (submission) => {
      selectedSubmission.value = submission
    }

    // 获取提交记录
    const fetchSubmissions = async () => {
      try {
        const userInfoStr = localStorage.getItem('userInfo')
        const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
        const accessToken = userInfo?.accessToken || localStorage.getItem('accessToken')
        
        if (!accessToken) {
          console.error('未找到用户token')
          return
        }

        const headers = { Authorization: `Bearer ${accessToken}` }
        
        // 首先尝试使用路由参数获取提交记录
        const response = await axios.get(`http://localhost:3000/api/problems/${route.params.id}/submissions`, { headers })
        
        // 如果没有数据，且是数字ID，尝试将其作为实际的problem_id使用
        if (response.data && response.data.code === 200 && (!response.data.data || response.data.data.length === 0)) {
          if (!isNaN(Number(route.params.id))) {
            console.log('尝试直接通过题目ID获取提交记录:', Number(route.params.id))
            // 尝试直接用数字ID获取
            try {
              const directResponse = await axios.get(`http://localhost:3000/api/judge/submissions?problem_id=${Number(route.params.id)}`, { headers })
              if (directResponse.data && directResponse.data.length > 0) {
                submissions.value = directResponse.data
                return
              }
            } catch (directError) {
              console.error('直接通过ID获取提交记录失败:', directError)
            }
          }
        }
        
        if (response.data && response.data.code === 200) {
          submissions.value = response.data.data
        }
      } catch (error) {
        console.error('获取提交记录失败:', error)
        ElMessage.error('获取提交记录失败')
      }
    }

    // 格式化日期
    const formatDate = (dateStr) => {
      const date = new Date(dateStr)
      return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      })
    }

    // 格式化内存大小
    const formatMemory = (memory) => {
      if (memory < 1024) return `${memory}KB`
      return `${(memory / 1024).toFixed(2)}MB`
    }

    // 获取状态文本
    const getStatusText = (status) => {
      const statusMap = {
        'Accepted': '通过',
        'Wrong Answer': '答案错误',
        'Runtime Error': '运行错误',
        'Time Limit Exceeded': '超时',
        'Memory Limit Exceeded': '内存超限',
        'Compile Error': '编译错误',
        'Pending': '等待中',
        'System Error': '系统错误',
        'Not Accepted': '未通过'
      }
      return statusMap[status] || status
    }

    // 复制提交代码
    const copySubmissionCode = async () => {
      if (!selectedSubmission.value?.code) return
      try {
        await navigator.clipboard.writeText(selectedSubmission.value.code)
        ElMessage.success('代码已复制')
      } catch (err) {
        ElMessage.error('复制失败，请手动选择复制')
      }
    }

    // 重置筛选条件
    const resetFilters = () => {
      filters.status = '';
      filters.language = '';
      currentPage.value = 1;
    }

    // 刷新提交记录
    const refreshSubmissions = () => {
      fetchSubmissions();
      // 显示加载中的消息
      ElMessage({
        message: '正在刷新提交记录...',
        type: 'info',
        duration: 1000
      });
    }

    // 监听标签页变化
    watch(activeTab, (newTab) => {
      if (newTab === 'submissions') {
        fetchSubmissions();
        // 如果切换到提交记录标签，重置筛选条件
        resetFilters();
      }
    })

    onMounted(() => {
      // 初始化默认值，防止空对象引用错误
      if (!problem.value) {
        problem.value = {
          title: '加载中...',
          description: '加载中...',
          difficulty: '中等',
          example: {
            input: '',
            output: ''
          },
          problem_number: '0000',
          total_submissions: 0,
          acceptance_rate: 0
        }
      }
      
      fetchProblem()
      fetchSubmissions()
      fetchProblemExamples()  // 添加获取样例的调用
      
      // 初始化Prism
      nextTick(() => {
        Prism.highlightAll()
        
        // 直接进行高亮处理，不需要判断语言
        highlightedCode.value = highlightCode(code.value, selectedLanguageForCode.value || 'C')
      })
    })

    watch(selectedLanguage, () => {
      nextTick(() => Prism.highlightAll())
    })

