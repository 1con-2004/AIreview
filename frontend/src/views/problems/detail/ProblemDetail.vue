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

    // 添加 AI 分析相关的数据
    const totalSubmissions = ref(156)
    const acceptanceRate = ref(68.5)
    const avgRuntime = ref(125)

    const commonPatterns = ref([
      {
        name: '双指针技巧',
        usage: 45,
        description: '在处理数组或链表时，使用双指针可以有效减少时间复杂度。',
        example: 'let left = 0, right = nums.length - 1;\nwhile (left < right) {\n  // 处理逻辑\n}'
      },
      {
        name: '哈希表存储',
        usage: 35,
        description: '使用哈希表可以将查找时间从 O(n) 优化到 O(1)。',
        example: 'const map = new Map();\nfor (const num of nums) {\n  map.set(num, (map.get(num) || 0) + 1);\n}'
      }
    ])

    const optimizationInsights = ref([])

    // 模拟 AI 分析结果数据结构
    const mockAiAnalysisResult = {
      errors: [
        {
          type: '语法错误',
          location: '第 15 行',
          message: '缺少分号',
          suggestion: '在行尾添加分号'
        },
        {
          type: '逻辑错误',
          location: '第 23-25 行',
          message: '边界条件处理不当',
          suggestion: '添加数组边界检查'
        }
      ],
      improvements: [
        {
          priority: 'high',
          title: '使用缓存优化',
          description: '可以使用 Map 结构缓存计算结果，避免重复计算。',
          codeExample: 'const cache = new Map();\nif (cache.has(key)) return cache.get(key);'
        },
        {
          priority: 'medium',
          title: '代码结构优化',
          description: '将重复的逻辑提取为独立函数',
          codeExample: 'function processData(data) {\n  // 处理逻辑\n}'
        }
      ],
      performance: {
        timeComplexity: 'O(n log n)',
        spaceComplexity: 'O(n)',
        explanation: '主要时间消耗在排序操作，空间消耗在临时数组存储。可以考虑使用原地排序算法优化空间复杂度。'
      }
    }

    // 从AI分析文本中提取错误信息
    const extractErrors = (analysis) => {
      const errors = []
      const errorRegex = /错误代码片段[\s\S]*?有问题的代码：\`(.*?)\`[\s\S]*?错误原因：(.*?)(?=\n\n|\n$|$)/g
      let match

      while ((match = errorRegex.exec(analysis)) !== null) {
        errors.push({
          type: '代码错误',
          location: '相关代码',
          message: match[2].trim(),
          severity: 'error',
          code: match[1].trim()
        })
      }

      return errors
    }

    // 从AI分析文本中提取改进建议
    const extractImprovements = (analysis) => {
      const improvements = []
      // 修改正则表达式以匹配2. 逻辑问题后的所有内容
      const improvementRegex = /2\.\s*逻辑问题\n-([\s\S]*?)(?=\n\n|\n$|$)/g
      let match

      while ((match = improvementRegex.exec(analysis)) !== null) {
        improvements.push({
          icon: 'el-icon-warning',
          title: '逻辑问题',
          description: match[1].trim()
        })
      }

      return improvements
    }

    // 从AI分析文本中提取性能相关信息
    const extractPerformance = (analysis) => {
      return {
        timeComplexity: '由AI分析得出',
        spaceComplexity: '由AI分析得出',
        explanation: analysis
      }
    }

    const clearConsole = () => {
      consoleOutput.value = ''
      runStatus.value = ''
      runtime.value = 0
    }

    const getStatusIcon = computed(() => {
      if (runStatus.value === 'success') return 'el-icon-check'
      if (runStatus.value === 'error') return 'el-icon-close'
      return ''
    })

    const getRunStatusText = computed(() => {
      if (runStatus.value === 'success') return '执行成功'
      if (runStatus.value === 'error') return '执行失败'
      return ''
    })

    const copyExample = (example) => {
      const text = `输入：\n${example.input}\n\n输出：\n${example.output}`
      navigator.clipboard.writeText(text)
        .then(() => {
          ElMessage.success('样例已复制到剪贴板')
        })
        .catch(err => {
          console.error('复制失败:', err)
        })
    }

    const copyExampleInput = async (input) => {
      try {
        await navigator.clipboard.writeText(input)
        ElMessage.success('输入样例已复制到剪贴板')
      } catch (error) {
        ElMessage.error('复制失败')
      }
    }

    const copyExampleOutput = async (output) => {
      try {
        await navigator.clipboard.writeText(output)
        ElMessage.success('输出样例已复制到剪贴板')
      } catch (error) {
        ElMessage.error('复制失败')
      }
    }

    const copyCode = async () => {
      if (!selectedSubmission.value?.code) return
      
      try {
        await navigator.clipboard.writeText(selectedSubmission.value.code)
        copied.value = true
        copyStatus.value = '已复制！'
        
        setTimeout(() => {
          copied.value = false
          copyStatus.value = '复制代码'
        }, 3000)
      } catch (err) {
        console.error('复制失败:', err)
        copyStatus.value = '复制失败'
      }
    }

    const versions = ref(['1.0', '1.1', '1.2'])
    const currentVersion = ref('1.2')

    const currentSolution = ref({
      solution_approach: '使用哈希表存储已访问节点实现循环检测',
      time_complexity: 'O(n)',
      space_complexity: 'O(n)'
    })

    // 根据选择的语言过滤实现代码
    const filteredImplementations = computed(() => {
      if (!problem.value?.solution?.implementations) return []
      if (!selectedLanguage.value) {
        return [problem.value.solution.implementations[0]]
      }
      return problem.value.solution.implementations.filter(
        impl => impl.language === selectedLanguage.value
      ).map(impl => {
        // 添加高亮逻辑
        impl.highlightedCode = highlightCode(impl.code, selectedLanguage.value);
        return impl;
      });
    })

    // 复制实现代码
    const copyImplementation = async (code) => {
      try {
        await navigator.clipboard.writeText(code)
        ElMessage.success('代码已复制')
      } catch (err) {
        ElMessage.error('复制失败，请手动选择复制')
      }
    }

    // 筛选选项
    const statusOptions = [
      { name: '全部状态', code: '' },
      { name: '通过', code: 'Accepted' },
      { name: '答案错误', code: 'Wrong Answer' },
      { name: '运行错误', code: 'Runtime Error' },
      { name: '超时', code: 'Time Limit Exceeded' },
      { name: '内存超限', code: 'Memory Limit Exceeded' },
      { name: '编译错误', code: 'Compile Error' },
      { name: '等待中', code: 'Pending' },
      { name: '系统错误', code: 'System Error' }
    ]

    const languageOptions = [
      { name: '全部语言', code: '' },
      { name: 'C', code: 'C' },
      { name: 'C++', code: 'C++' },
      { name: 'Python', code: 'Python' },
      { name: 'Java', code: 'Java' },
      { name: 'JavaScript', code: 'JavaScript' }
    ]

    // 筛选状态
    const filters = reactive({
      status: '',
      language: ''
    })

    // 弹窗相关
    const dialogVisible = ref(false)
    const copied = ref(false)
    const copyStatus = ref('复制代码')

    // 显示提交详情
    const showSubmissionDetail = (submission) => {
      selectedSubmission.value = submission
      dialogVisible.value = true
    }

    const currentPage = ref(1)
    const itemsPerPage = 5

    const totalPages = computed(() => {
      return Math.ceil(filteredSubmissions.value.length / itemsPerPage)
    })

    const paginatedSubmissions = computed(() => {
      const start = (currentPage.value - 1) * itemsPerPage
      const end = start + itemsPerPage
      return filteredSubmissions.value.slice(start, end)
    })

    const nextPage = () => {
      if (currentPage.value < totalPages.value) {
        currentPage.value++
      }
    }

    const prevPage = () => {
      if (currentPage.value > 1) {
        currentPage.value--
      }
    }

    // 处理代码输入
    const handleCodeInput = (e) => {
      code.value = e.target.value;
      // 确保使用正确的语言进行高亮
      highlightedCode.value = highlightCode(code.value, selectedLanguageForCode.value || 'c');
      updateCursorPosition(e);
    }

    // 处理粘贴事件
    const handlePaste = (e) => {
      e.preventDefault()
      const text = e.clipboardData.getData('text/plain')
      document.execCommand('insertText', false, text)
    }

    // 监听语言变化
    watch(selectedLanguageForCode, (newLang) => {
      if (code.value) {
        highlightedCode.value = highlightCode(code.value, newLang || 'C')
      }
    })

    // 初始化高亮
    onMounted(() => {
      if (code.value) {
        highlightedCode.value = highlightCode(code.value, selectedLanguageForCode.value || 'javascript')
      }
    })

    // 初始化时立即高亮所有代码
    onMounted(() => {
      fetchProblem()
      fetchSubmissions()
      
      // 初始化Prism
      nextTick(() => {
        Prism.highlightAll()
        
        // 如果有默认选中的语言，立即高亮答案代码
        if (selectedLanguage.value && problem.value?.solution?.implementations) {
          const impl = problem.value.solution.implementations.find(
            impl => impl.language === selectedLanguage.value
          )
          if (impl) {
            impl.highlightedCode = highlightCode(impl.code, selectedLanguage.value)
          }
        }
      })
      
      // 新增：在组件挂载时进行代码高亮
      if (code.value) {
        highlightedCode.value = highlightCode(code.value, selectedLanguageForCode.value || 'javascript')
      }
    })

    // 监听答案语言变化，实时更新高亮
    watch(selectedLanguage, (newLang) => {
      if (newLang && problem.value?.solution?.implementations) {
        nextTick(() => {
          const impl = problem.value.solution.implementations.find(
            impl => impl.language === newLang
          )
          if (impl) {
            impl.highlightedCode = highlightCode(impl.code, newLang)
          }
          Prism.highlightAll()
        })
      }
    })

    // 监听代码变化
    watch(code, () => {
      nextTick(() => {
        // 更新高亮
        highlightedCode.value = highlightCode(code.value, selectedLanguageForCode.value || 'c');
        
        // 确保编辑器容器高度足够
        const codeContent = document.querySelector('.code-content');
        const textarea = document.querySelector('.p-inputtextarea');
        if (codeContent && textarea) {
          codeContent.style.height = `${Math.max(500, textarea.scrollHeight)}px`;
        }
      });
    });

    const onLanguageChange = (lang) => {
      selectedLanguage.value = lang
      hasUserSelectedLanguage.value = true  // 用户手动选择语言时设置标记
      // 选择语言后进行代码高亮
      if (code.value) {
        highlightedCode.value = highlightCode(code.value, lang)
      }
    }

    const showCursor = () => {
      isCursorVisible.value = true; // 点击时显示光标
      setTimeout(() => {
        isCursorVisible.value = false; // 一段时间后隐藏光标
      }, 2000); // 2秒后隐藏光标
    };

    const runCode = async () => {
      if (!code.value.trim()) {
        ElMessage.warning('请先输入代码')
        return
      }

      isRunning.value = true
      runStatus.value = ''
      consoleOutput.value = ''
      compilerOutput.value = '' // 清空编译器输出

      try {
        const userInfoStr = localStorage.getItem('userInfo')
        const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
        const accessToken = userInfo?.accessToken || localStorage.getItem('accessToken')
        
        if (!accessToken) {
          ElMessage.error('请先登录')
          return
        }

        const response = await axios.post(
          `http://localhost:3000/api/judge/problems/${route.params.id}/run`,
          {
            code: code.value,
            language: selectedLanguageForCode.value,
            input: customInput.value
          },
          {
            headers: { Authorization: `Bearer ${accessToken}` }
          }
        )

        if (response.data.success) {
          runStatus.value = 'success'
          consoleOutput.value = response.data.data.output
          compilerOutput.value = response.data.data.compilerOutput
        } else {
          runStatus.value = 'error'
          consoleOutput.value = ''
          compilerOutput.value = response.data.data.compilerOutput || response.data.message
        }
      } catch (error) {
        console.error('运行代码失败:', error)
        runStatus.value = 'error'
        consoleOutput.value = ''
        compilerOutput.value = error.response?.data?.data?.compilerOutput || error.response?.data?.message || '运行失败，请稍后重试'
      } finally {
        isRunning.value = false
      }
    }

    const submitCode = async () => {
      if (!code.value.trim()) {
        ElMessage.warning('请先输入代码')
        return
      }

      if (!selectedLanguageForCode.value) {
        ElMessage.warning('请选择编程语言')
        return
      }

      isSubmitting.value = true

      try {
        const userInfoStr = localStorage.getItem('userInfo')
        const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
        const accessToken = userInfo?.accessToken || localStorage.getItem('accessToken')
        
        if (!accessToken) {
          ElMessage.error('请先登录')
          return
        }

        console.log('提交代码:', {
          code: code.value,
          language: selectedLanguageForCode.value
        })

        const response = await axios.post(
          `http://localhost:3000/api/judge/problems/${route.params.id}/submit`,
          {
            code: code.value,
            language: selectedLanguageForCode.value
          },
          {
            headers: { Authorization: `Bearer ${accessToken}` }
          }
        )

        if (response.data.success) {
          ElMessage.success('提交成功')
          // 更新提交记录
          fetchSubmissions()
          // 切换到提交记录标签
          activeTab.value = 'submissions'
        } else {
          ElMessage.error(response.data.message || '提交失败')
        }
      } catch (error) {
        console.error('提交失败:', error)
        ElMessage.error(error.response?.data?.message || '提交失败，请稍后重试')
      } finally {
        isSubmitting.value = false
      }
    }

    // 更新光标位置
    const updateCursorPosition = (event) => {
      const textarea = event.target
      const text = textarea.value
      const cursorIndex = textarea.selectionStart
      
      // 计算行号和列号
      const textBeforeCursor = text.substring(0, cursorIndex)
      const line = (textBeforeCursor.match(/\n/g) || []).length + 1
      const lastNewLine = textBeforeCursor.lastIndexOf('\n')
      const column = lastNewLine === -1 ? cursorIndex + 1 : cursorIndex - lastNewLine
      
      cursorPosition.value = { line, column }
    }

    // 处理按键事件
    const handleKeyDown = (event) => {
      // Tab键处理
      if (event.key === 'Tab') {
        event.preventDefault()
        const start = event.target.selectionStart
        const end = event.target.selectionEnd
        
        // 插入两个空格
        const newText = code.value.substring(0, start) + '  ' + code.value.substring(end)
        code.value = newText
        
        // 重新设置光标位置
        nextTick(() => {
          event.target.selectionStart = event.target.selectionEnd = start + 2
          updateCursorPosition(event)
        })
      }
    }

    // 初始化测试用例为样例输入
    onMounted(() => {
      if (problem.value?.example?.input) {
        customInput.value = problem.value.example.input
      }
    })

    // 监听问题数据变化，更新测试用例
    watch(() => problem.value?.example?.input, (newInput) => {
      if (newInput) {
        customInput.value = newInput
      }
    })

    const justCopied = ref(false)
    
    // 复制实现代码
    const copyImplementationCode = async (code) => {
      try {
        await navigator.clipboard.writeText(code)
        justCopied.value = true
        ElMessage({
          message: '代码已复制到剪贴板',
          type: 'success',
          duration: 2000,
          customClass: 'copy-message'
        })
        setTimeout(() => {
          justCopied.value = false
        }, 2000)
      } catch (err) {
        ElMessage.error('复制失败，请手动选择复制')
      }
    }

    // 面板展开状态
    const panels = ref({
      testCase: true,
      output: true,
      compiler: true
    })

    // 切换面板展开状态
    const togglePanel = (panel) => {
      panels.value[panel] = !panels.value[panel]
    }

    const isAnalyzing = ref(false)

    // 获取AI分析结果
    const getAiAnalysis = async () => {
      if (!code.value.trim()) {
        ElMessage.warning('请先输入代码')
        return
      }

      isAnalyzing.value = true
      aiAnalysisResult.value = null

      try {
        const userInfoStr = localStorage.getItem('userInfo')
        const token = userInfoStr ? JSON.parse(userInfoStr).token : null
        
        if (!token) {
          ElMessage.error('请先登录')
          return
        }

        const response = await axios.post(
          'http://localhost:3000/api/ai/analyze-code',
          {
            code: code.value,
            language: selectedLanguageForCode.value,
            problemId: route.params.id
          },
          {
            headers: { Authorization: `Bearer ${token}` }
          }
        )

        if (response.data.success) {
          // 解析AI返回的分析结果
          const analysis = response.data.data.codeAnalysis
          
          // 提取错误和改进建议
          const errors = extractErrors(analysis)
          const improvements = extractImprovements(analysis)
          
          // 更新optimizationInsights
          optimizationInsights.value = improvements
          
          // 更新aiAnalysisResult
          aiAnalysisResult.value = {
            errors: errors,
            improvements: improvements,
            performance: extractPerformance(analysis)
          }
          
          // 切换到AI分析标签页
          activeTab.value = 'aiAnalysis'
          
          ElMessage.success('代码分析完成')
        } else {
          ElMessage.error(response.data.message || '分析失败')
        }
      } catch (error) {
        console.error('AI分析失败:', error)
        ElMessage.error(error.response?.data?.message || 'AI分析失败，请稍后重试')
      } finally {
        isAnalyzing.value = false
      }
    }

    // 在script部分添加代码高亮函数
    const highlightInlineCode = (text) => {
      if (!text) return ''
      // 使用正则表达式匹配反引号中的代码
      return text.replace(/`([^`]+)`/g, (match, code) => {
        try {
          // 使用Prism.js高亮代码
          const highlighted = Prism.highlight(
            code,
            Prism.languages[selectedLanguageForCode.value.toLowerCase()] || Prism.languages.c,
            selectedLanguageForCode.value.toLowerCase()
          )
          // 返回带有样式的HTML
          return `<code class="inline-code">${highlighted}</code>`
        } catch (error) {
          console.error('代码高亮失败:', error)
          return `<code class="inline-code">${code}</code>`
        }
      })
    }

    // 处理AI分析结果
    const handleAiAnalysis = async () => {
      try {
        isAnalyzing.value = true
        const response = await analyzeCode({
          code: editor.value.getValue(),
          language: selectedLanguageForCode.value,
          problemId: route.params.id
        })

        if (response.data.success) {
          const analysis = response.data.data.codeAnalysis
          console.log('AI分析结果:', analysis) // 添加调试日志
          
          // 提取错误和改进建议
          const errors = extractErrors(analysis)
          const improvements = extractImprovements(analysis)
          
          console.log('提取的改进建议:', improvements) // 添加调试日志

          // 更新分析结果
          aiAnalysisResult.value = {
            errors,
            improvements
          }
        }
      } catch (error) {
        console.error('AI分析失败:', error)
        ElMessage.error('AI分析失败：' + error.message)
      } finally {
        isAnalyzing.value = false
      }
    }

    // 监听筛选条件变化，重置分页
    watch(filters, () => {
      currentPage.value = 1;
    }, { deep: true });

    // 代码高亮函数
    const highlightCode = (code, language) => {
      if (!code) return ''
      try {
        return Prism.highlight(code, Prism.languages[language.toLowerCase()] || Prism.languages.c, language.toLowerCase())
      } catch (err) {
        console.error('代码高亮失败:', err)
        return code
      }
    }

    // 添加 getStatusClass 函数
    const getStatusClass = (status) => {
      const statusClassMap = {
        'Accepted': 'status-accepted',
        'Wrong Answer': 'status-wrong',
        'Runtime Error': 'status-error',
        'Time Limit Exceeded': 'status-timeout',
        'Memory Limit Exceeded': 'status-memory',
        'Compile Error': 'status-compile-error',
        'Pending': 'status-pending',
        'System Error': 'status-system-error',
        'Not Accepted': 'status-not-accepted'
      }
      return statusClassMap[status] || 'status-default'
    }

    const fetchProblemExamples = async () => {
      try {
        const userInfoStr = localStorage.getItem('userInfo')
        const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
        const accessToken = userInfo?.accessToken || localStorage.getItem('accessToken')
        
        if (!accessToken) {
          console.error('未找到用户token')
          return
        }

        const data = await getProblemExamples(route.params.id)
        problemExamples.value = data
      } catch (error) {
        console.error('获取题目样例失败:', error)
        ElMessage.error('获取题目样例失败')
      }
    }

    // 显示编译成功的提示
    const showCompileSuccess = () => {
      ElMessage.success("编译成功，控制台已输出结果");
    };

    // 处理后端返回的结果
    const handleBackendResponse = (response) => {
      console.log("后端响应:", response); // 打印响应以确认
      if (response.success) { // 检查 success 字段
        showCompileSuccess(); // 调用弹窗提示
      } else {
        console.log("编译未成功，状态:", response); // 打印状态以确认
      }
    };

    return {
      problem,
      activeTab,
      selectedLanguage,
      code,
      goBack,
      totalSubmissions,
      acceptanceRate,
      avgRuntime,
      commonPatterns,
      optimizationInsights,
      submissionFilter,
      submissions,
      filteredSubmissions,
      selectedSubmission,
      selectSubmission,
      aiAnalysisResult,
      getAiAnalysis,
      activeConsoleTab,
      customInput,
      consoleOutput,
      compilerOutput,
      isRunning,
      runStatus,
      runtime,
      clearConsole,
      getStatusIcon,
      getStatusText,
      copyExample,
      copyExampleInput,
      copyExampleOutput,
      copyCode,
      versions,
      currentVersion,
      currentSolution,
      filteredImplementations,
      copyImplementation,
      formatDate,
      formatMemory,
      copySubmissionCode,
      statusOptions,
      languageOptions,
      filters,
      resetFilters,
      dialogVisible,
      copied,
      copyStatus,
      showSubmissionDetail,
      refreshSubmissions,
      highlightCode,
      getStatusClass,
      currentPage,
      totalPages,
      paginatedSubmissions,
      nextPage,
      prevPage,
      selectedLanguageForCode,
      highlightedCode,
      handleCodeInput,
      handlePaste,
      onLanguageChange,
      hasUserSelectedLanguage,
      isCursorVisible,
      showCursor,
      isSubmitting,
      runCode,
      submitCode,
      cursorPosition,
      lineCount,
      updateCursorPosition,
      handleKeyDown,
      justCopied,
      copyImplementationCode,
      panels,
      togglePanel,
      isConsoleCollapsed,
      consoleTabs,
      toggleConsole,
      isAnalyzing,
      highlightInlineCode,
      handleAiAnalysis,
      problemExamples,
      copyExampleInput,
      copyExampleOutput,
      isExpanded,
      handleBackendResponse,
    }
  }
})
</script>

<style scoped>
.problem-detail {
  min-height: 100vh;
  background-color: #0d1117;
  color: #e6edf3;
}

.content {
  display: flex;
  padding: 20px;
  gap: 20px;
  height: calc(100vh - 60px);
}

/* 左侧题目描述区域样式 */
.problem-description {
  flex: 1;
  background-color: #1e1e2e;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  max-width: 45%;
  overflow-y: auto;
}

.problem-header {
  margin-bottom: 20px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.title-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 4px;
}

.title-row {
  display: flex;
  align-items: baseline;
  gap: 12px;
  margin-top:8px;
}

.problem-number {
  color: #7c4dff;
  font-size: 24px;
  font-weight: 500;
  min-width: 60px;
}

.title-section h1 {
  font-size: 28px;
  margin: 0;
  line-height: 1.2;
  color: #fff;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.problem-stats {
  display: flex;
  align-items: center;
  gap: 20px;

}

.difficulty-tag {
  padding: 4px 12px;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  transition: transform 0.3s ease;
}

.difficulty-tag:hover {
  transform: scale(1.05);
}

.difficulty-tag.简单 {
  background-color: #4caf50;
  color: white;
}

.difficulty-tag.中等 {
  background-color: #ff9800;
  color: white;
}

.difficulty-tag.困难 {
  background-color: #f44336;
  color: white;
}

.back-button {
  position: relative;
  padding: 8px 20px;
  border-radius: 8px;
  background: linear-gradient(135deg, #7c4dff 0%, #4ecdc4 100%);
  border: none;
  color: #fff;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-weight: 500;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.back-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.back-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
}

.back-button:hover::before {
  opacity: 1;
}

.back-button:active {
  transform: scale(0.98);
}

.back-button i {
  font-size: 16px;
  filter: drop-shadow(0 0 2px rgba(255, 255, 255, 0.3));
}

.back-button span {
  position: relative;
  z-index: 1;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}

/* 选项卡样式 */
.tabs {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding-bottom: 12px;
}

.tab-button {
  padding: 8px 16px;
  background: transparent;
  border: none;
  color: #a6accd;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
  border-radius: 6px;
}

.tab-button:hover {
  color: #4ecdc4;
}

.tab-button.active {
  background-color: #4ecdc4;
  color: white;
}

/* 右侧代码编辑区域样式 */
.code-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16px;
  background-color: #1e1e2e;
  border-radius: 12px;
  padding: 20px;
}

.code-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.language-select-wrapper {
  flex: 1;
  max-width: 180px; /* 控制最大宽度 */
}

.action-buttons {
  display: flex;
  gap: 12px;
}

.run-button,
.submit-button,
.ai-analyze-button {
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 6px;
}

.run-button {
  background-color: #2d2d3f;
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: #a6accd;
}

.submit-button {
  background-color: #4ecdc4;
  border: none;
  color: white;
}

.run-button:hover {
  border-color: #4ecdc4;
  color: white;
}

.submit-button:hover {
  background-color: #3db9b0;
}

.ai-analyze-button {
  background: linear-gradient(135deg, #7c4dff 0%, #4ecdc4 100%);
  border: none;
  color: white;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  min-width: 100px;
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}

.ai-analyze-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, 
    rgba(255, 255, 255, 0.1) 0%, 
    rgba(255, 255, 255, 0) 100%
  );
  opacity: 0;
  transition: opacity 0.3s ease;
}

.ai-analyze-button:hover:not(:disabled)::before {
  opacity: 1;
}

.ai-analyze-button:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(124, 77, 255, 0.3);
}

.ai-analyze-button:disabled {
  background: linear-gradient(135deg, #4a4a6a 0%, #2d2d3f 100%);
  cursor: not-allowed;
  opacity: 0.7;
}

/* 添加加载动画 */
@keyframes analyzing {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.analyzing-icon {
  animation: analyzing 1.5s linear infinite;
}

.ai-analyze-button i {
  font-size: 16px;
  margin-top: 1px;
}

.ai-analyze-button:hover:not(:disabled) {
  background-color: #6c3ee8;
}

.ai-analyze-button:disabled {
  background-color: #4a4a6a;
  cursor: not-allowed;
  opacity: 0.7;
}

/* 修改代码编辑器相关样式 */
.code-editor {
    flex: 1;
    display: flex;
    background: #1e1e2e;
    border-radius: 8px;
    position: relative;
    border: 2px solid #4ecdc4;
    margin-bottom: 16px;
    height: 500px;
    overflow: hidden;
}

.line-numbers {
    padding: 16px 8px;
    background: #282836;
    color: #6c7086;
    font-family: 'JetBrains Mono', monospace;
    font-size: 14px;
    line-height: 1.6;
    text-align: right;
    user-select: none;
    border-right: 1px solid rgba(255, 255, 255, 0.1);
    min-width: 40px;
}

.editor-wrapper {
    flex: 1;
    position: relative;
    display: flex;
    overflow-y: auto;
    overflow-x: hidden;
}

.code-content {
    position: relative;
    width: 100%;
    min-height: 100%;
}

:deep(.p-inputtextarea) {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100% !important;
    background: transparent !important;
    color: transparent !important;
    caret-color: #e6edf3 !important;
    border: none !important;
    font-family: 'JetBrains Mono', monospace;
    font-size: 14px;
    line-height: 1.6;
    padding: 16px;
    resize: none;
    z-index: 2;
    white-space: pre-wrap;
    overflow: hidden !important;
}

.code-highlight {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 16px;
    background: #1e1e2e;
    font-family: 'JetBrains Mono', monospace;
    font-size: 14px;
    line-height: 1.6;
    pointer-events: none;
    white-space: pre-wrap;
    word-wrap: break-word;
    z-index: 1;
}

/* 修改滚动条样式 */
.editor-wrapper::-webkit-scrollbar {
    width: 8px;
    height: 0;
}

.editor-wrapper::-webkit-scrollbar-track {
    background: #1e1e2e;
}

.editor-wrapper::-webkit-scrollbar-thumb {
    background: #2d2d3f;
    border-radius: 4px;
}

.editor-wrapper::-webkit-scrollbar-thumb:hover {
    background: #3d3d4f;
}

/* 修改状态栏样式 */
.editor-status-bar {
    position: absolute;
    bottom: 8px;
    right: 8px;
    padding: 4px 8px;
    background: #282836;
    color: #6c7086;
    font-size: 12px;
    border-radius: 4px;
    font-family: 'JetBrains Mono', monospace;
    z-index: 3;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.1);
    pointer-events: none;
}

/* 添加控制台样式 */
.console-output {
    margin-top: 16px;
    background: #1e1e2e;
    border-radius: 8px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.debug-input {
    height: 150px;
}

.custom-input-textarea {
    width: 100%;
    height: 100%; /* 确保输入框占满可用空间 */
    background-color: transparent;
    border: none;
    color: #e6edf3;
    font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
    font-size: 14px;
    line-height: 1.6;
    resize: vertical; /* 允许垂直调整大小 */
    padding: 12px;
    overflow-y: auto; /* 添加垂直滚动条 */
}

:deep(.p-inputtextarea:focus) {
    box-shadow: none !important;
    border: none !important;
    outline: none !important;
}

:deep(.p-inputtextarea:hover) {
    border: none !important;
}

:deep(.p-inputtextarea::placeholder) {
    color: #6c7086;
    opacity: 0.8;
}

/* 滚动条样式 */
:deep(.p-inputtextarea::-webkit-scrollbar) {
    width: 8px;
    height: 8px;
}

:deep(.p-inputtextarea::-webkit-scrollbar-track) {
    background: #1e1e2e;
}

:deep(.p-inputtextarea::-webkit-scrollbar-thumb) {
    background: #2d2d3f;
    border-radius: 4px;
}

:deep(.p-inputtextarea::-webkit-scrollbar-thumb:hover) {
    background: #3d3d4f;
}

.code-pre {
  margin: 0;
  padding: 0;
  background: transparent;
  font-family: 'Fira Code', monospace;
  font-size: 14px;
  line-height: 1.5;
  white-space: pre-wrap;
  word-break: break-all;
  word-wrap: break-word;
  height: 100%;
}

.code-block {
  background: #282836;
  border-radius: 6px;
  padding: 12px;
  margin-top: 12px;
  position: relative;
}

.code-block pre {
  margin: 0;
  padding: 0;
  overflow-x: auto;
}

.code-block code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
  line-height: 1.5;
}

.insight-description :deep(code) {
  background: #282836;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.9em;
}

.insights-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.insight-item {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  padding: 16px;
  display: flex;
  gap: 16px;
  transition: all 0.3s ease;
}

.insight-item:hover {
  background: rgba(255, 255, 255, 0.08);
}

.insight-icon {
  color: #7c4dff;
  font-size: 24px;
}

.insight-content {
  flex: 1;
}

.insight-title {
  color: #e6edf3;
  font-weight: 500;
  margin-bottom: 8px;
}

.insight-description {
  color: #a6accd;
  font-size: 14px;
  line-height: 1.5;
  margin-bottom: 8px;
}

.code-block {
  background: #282836;
  border-radius: 6px;
  padding: 12px;
  margin-top: 12px;
  position: relative;
}

.code-block pre {
  margin: 0;
  padding: 0;
  overflow-x: auto;
}

.code-block code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
  line-height: 1.5;
}

.insight-description :deep(code) {
  background: #282836;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.9em;
}

.logic-section {
  background: rgba(124, 77, 255, 0.05);
  border: 1px solid rgba(124, 77, 255, 0.1);
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 24px;
  transition: all 0.3s ease;
}

.logic-section:hover {
  border-color: rgba(124, 77, 255, 0.2);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.logic-summary {
  color: #7c4dff;
  font-size: 14px;
  font-weight: 500;
}

.console-output {
  background-color: #2d2d3f;
  border-radius: 8px;
  overflow: hidden;
  margin-top: 16px;
  transition: all 0.3s ease;
}

.console-header {
  padding: 12px 16px;
  background:  #282836;
  cursor: pointer;
  user-select: none;
  display: flex;
  align-items: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.console-title {
  display: flex;
  align-items: center;
  gap: 18px;
  color: #e6edf3;
  font-weight: 500;
}

.console-title i {
  transition: transform 0.3s ease;
}

.console-title i.rotated {
  transform: rotate(90deg);
}

.console-content {
  display: flex; /* 使用 Flexbox 布局 */
  flex-direction: column; /* 垂直排列 */
  min-height: 300px; /* 设置最小高度 */
  height: 100%; /* 确保占满父容器高度 */
}

.console-tabs {
  display: flex;
  gap: 0;
  background: #282836;
  padding: 0 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding-top: 8px;
}

.console-tab {
  padding: 12px 24px;
  color: #a6accd;
  cursor: pointer;
  position: relative;
  transition: all 0.3s ease;
}

.console-tab:hover {
  color: #4ecdc4;
}

.console-tab.active {
  color: #4ecdc4;
}

.console-tab.active::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: #4ecdc4;
}

.tab-panel {
  padding: 16px;
}

.custom-input-textarea {
  background-color: #2d2d3f; /* 暗色背景 */
  color: #e0e0e0; /* 字体颜色 */
  border: 1px solid #444; /* 边框颜色 */
  border-radius: 4px; /* 圆角 */
  padding: 10px; /* 内边距 */
  resize: none; /* 禁止手动调整大小 */
  flex-grow: 1; /* 使输入框占据剩余空间 */
  min-height: 100px; /* 设置最小高度 */
  width: 100%; /* 确保宽度占满父容器 */
  box-sizing: border-box; /* 包含内边距和边框在内的宽高计算 */
}

.output-sections {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.actual-output,
.expected-output {
  background: #1e1e2e;
  border-radius: 4px;
  padding: 16px;
}

.output-title {
  color: #4ecdc4;
  font-size: 14px;
  margin-bottom: 8px;
  font-weight: 500;
}

.output-content,
.compiler-output {
  margin: 0;
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
  color: #e6edf3;
  white-space: pre-wrap;
  word-wrap: break-word;
  background: rgba(0, 0, 0, 0.2);
  padding: 12px;
  border-radius: 4px;
}

.output-content.error,
.compiler-output.error {
  color: #ff5555;
}

/* 添加收起时的样式 */
.console-output.collapsed .console-content {
  display: none;
}

.console-output.collapsed {
  margin-bottom: 0;
}

.debug-container {
  display: flex;
  gap: 16px;
  background: linear-gradient(to right, #1a1a2e, #1e1e2e);
  border-radius: 12px;
  padding: 1px;
  position: relative;
  overflow: hidden;
  margin: 1px;
}

.collapsible-panel {
  background: #282836;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.05);
  margin-bottom: 8px;
  transition: all 0.3s ease;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: linear-gradient(to right, #1e1e2e, #282836);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  cursor: pointer;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #e6edf3;
}

.header-title i {
  font-size: 16px;
  transition: transform 0.3s ease;
}

.header-title i.collapsed {
  transform: rotate(-90deg);
}

.panel-content {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease;
}

.panel-content.expanded {
  max-height: 300px;
  padding: 12px;
}

.panel-icon {
  margin-right: 8px;
  font-size: 16px;
}

.panel-icon.test-case {
  color: #7c4dff;
}

.panel-icon.output {
  color: #4ecdc4;
}

.panel-icon.compiler {
  color: #ff6b6b;
}

.debug-input, .debug-output {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: #282a36;
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.debug-input::after {
  content: '';
  position: absolute;
  top: 10%;
  right: -1px;
  width: 1px;
  height: 80%;
  background: linear-gradient(to bottom,
    rgba(78, 205, 196, 0) 0%,
    rgba(78, 205, 196, 0.3) 50%,
    rgba(78, 205, 196, 0) 100%
  );
  box-shadow: 0 0 8px rgba(78, 205, 196, 0.3);
}

.debug-output::before {
  content: '';
  position: absolute;
  top: 10%;
  left: -1px;
  width: 1px;
  height: 80%;
  background: linear-gradient(to bottom,
    rgba(124, 77, 255, 0) 0%,
    rgba(124, 77, 255, 0.3) 50%,
    rgba(124, 77, 255, 0) 100%
  );
  box-shadow: 0 0 8px rgba(124, 77, 255, 0.3);
}

.debug-panel {
  display: flex;
  flex-direction: column;
  height: 100%;
  position: relative;
  z-index: 1;
}

.output-wrapper {
  padding: 12px; /* 添加内边距 */
  background: rgba(0, 0, 0, 0.3);
  border-radius: 6px;
}

.empty-state {
  color: #6c7086;
  text-align: center;
}

.console-tabs {
  display: flex;
  height: 40px;
}

.console-tab {
  padding: 0 20px;
  height: 100%;
  border: none;
  background: transparent;
  color: #a6accd;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
  position: relative;
}

.console-tab:hover {
  color: #e6edf3;
}

.console-tab.active {
  color: #4ecdc4;
}

.console-tab.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: #4ecdc4;
}

.console-actions {
  padding-right: 16px;
}

.clear-button {
  padding: 4px 8px;
  border: none;
  background: transparent;
  color: #a6accd;
  cursor: pointer;
  font-size: 12px;
  display: flex;
  align-items: center;
  gap: 4px;
  transition: all 0.3s ease;
}

.clear-button:hover {
  color: #e6edf3;
}

.console-content {
  height: auto;
  overflow-y: auto;
}

.output-area,
.input-area {
  height: 100%;
  padding: 16px;
}

.empty-output {
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #a6accd;
}

.empty-output i {
  font-size: 24px;
}

.running-status {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #4ecdc4;
}

.output-result {
  border-radius: 6px;
  overflow: hidden;
}

.output-result.success {
  background-color: rgba(76, 175, 80, 0.1);
}

.output-result.error {
  background-color: rgba(244, 67, 54, 0.1);
}

.status-header {
  padding: 8px 12px;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.output-result.success .status-header {
  color: #4caf50;
}

.output-result.error .status-header {
  color: #f44336;
}

.runtime {
  margin-left: auto;
  font-size: 12px;
  color: #a6accd;
}

.output-content {
  margin: 0;
  padding: 12px;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.5;
  color: #e6edf3;
  white-space: pre-wrap;
}

.custom-input-textarea {
  width: 100%;
  height: 100%;
  min-height: 220px;
  background-color: transparent;
  border: none;
  color: #e6edf3;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.6;
  resize: none;
  position: relative;
  z-index: 1;
}

.custom-input-textarea:focus {
  outline: none;
}

.custom-input-textarea::placeholder {
  color: #6c7086;
  opacity: 0.8;
}

/* 示例样式 */
.examples {
  margin-top: 24px;
}

.example-item {
  margin-top: 16px;
  background-color: #2d2d3f;
  border-radius: 8px;
  padding: 16px;
}

.example-header {
  font-weight: bold;
  margin-bottom: 8px;
  color: #4ecdc4;
}

.example-content pre {
  margin: 0;
  white-space: pre-wrap;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.5;
}

/* 滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #1e1e2e;
}

::-webkit-scrollbar-thumb {
  background: #2d2d3f;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #3d3d4f;
}

/* AI 分析面板样式 */
.ai-analysis-tab {
  padding: 20px 0;
}

.analysis-overview {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.analysis-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.stat-card {
  background-color: #2d2d3f;
  border-radius: 8px;
  padding: 16px;
  text-align: center;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #4ecdc4;
  margin-bottom: 8px;
}

.stat-label {
  color: #a6accd;
  font-size: 14px;
}

.ai-analysis-result {
  background-color: #2d2d3f;
  border-radius: 8px;
  padding: 20px;
}

.ai-analysis-result h3 {
  color: #e6edf3;
  margin: 0 0 16px 0;
  font-size: 16px;
}

.no-analysis {
  min-height: 200px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.analysis-result-content {
  /* Error analysis, improvement suggestions and performance analysis styles */
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* Error analysis styles */
.error-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.error-item {
  background-color: rgba(244, 67, 54, 0.1);
  border-radius: 6px;
  padding: 12px;
}

.error-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.error-type {
  color: #f44336;
  font-weight: 500;
}

.error-location {
  color: #a6accd;
  font-size: 12px;
}

.error-message {
  color: #e6edf3;
  margin-bottom: 8px;
}

.error-suggestion {
  background-color: rgba(255, 255, 255, 0.05);
  border-radius: 4px;
  padding: 8px;
}

.suggestion-label {
  color: #4ecdc4;
  font-size: 12px;
  margin-bottom: 4px;
}

.suggestion-content {
  color: #a6accd;
  font-size: 13px;
}

/* Improvement suggestions styles */
.improvements-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.improvement-item {
  background-color: rgba(124, 77, 255, 0.1);
  border-radius: 6px;
  padding: 12px;
}

.improvement-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.improvement-priority {
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 12px;
  text-transform: uppercase;
}

.improvement-priority.high {
  background-color: rgba(244, 67, 54, 0.2);
  color: #f44336;
}

.improvement-priority.medium {
  background-color: rgba(255, 152, 0, 0.2);
  color: #ff9800;
}

.improvement-priority.low {
  background-color: rgba(76, 175, 80, 0.2);
  color: #4caf50;
}

.improvement-title {
  color: #e6edf3;
  font-weight: 500;
}

.improvement-description {
  color: #a6accd;
  font-size: 14px;
  margin-bottom: 8px;
}

.improvement-code {
  background-color: #2d2d3f;
  border-radius: 4px;
  padding: 12px;
}

.code-label {
  color: #4ecdc4;
  font-size: 12px;
  margin-bottom: 8px;
}

.improvement-code pre {
  margin: 0;
  color: #e6edf3;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 13px;
  line-height: 1.5;
}

/* Performance analysis styles */
.performance-details {
  background-color: #2d2d3f;
  border-radius: 6px;
  padding: 16px;
}

.performance-item {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
}

.item-label {
  color: #a6accd;
  min-width: 100px;
}

.item-value {
  color: #4ecdc4;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
}

.performance-explanation {
  color: #a6accd;
  font-size: 14px;
  line-height: 1.5;
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.common-patterns {
  background-color: #2d2d3f;
  border-radius: 8px;
  padding: 20px;
}

.common-patterns h3 {
  color: #e6edf3;
  margin: 0 0 16px 0;
  font-size: 16px;
}

.pattern-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.pattern-item {
  background-color: #282836;
  border-radius: 8px;
  padding: 16px;
}

.pattern-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.pattern-title {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #4ecdc4;
  font-weight: 500;
}

.pattern-usage {
  color: #7c4dff;
  font-size: 14px;
}

.pattern-description {
  color: #a6accd;
  font-size: 14px;
  line-height: 1.5;
  margin-bottom: 12px;
}

.pattern-example {
  background-color: #2d2d3f;
  border-radius: 6px;
  padding: 12px;
}

.pattern-example pre {
  margin: 0;
  color: #e6edf3;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 13px;
  line-height: 1.5;
}

.optimization-insights {
  background-color: #2d2d3f;
  border-radius: 8px;
  padding: 20px;
}

.optimization-insights h3 {
  color: #e6edf3;
  margin: 0 0 16px 0;
  font-size: 16px;
}

.insights-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.insight-item {
  display: flex;
  gap: 16px;
  background-color: #282836;
  border-radius: 8px;
  padding: 16px;
}

.insight-icon {
  color: #7c4dff;
  font-size: 24px;
}

.insight-content {
  flex: 1;
}

.insight-title {
  color: #e6edf3;
  font-weight: 500;
  margin-bottom: 8px;
}

.insight-description {
  color: #a6accd;
  font-size: 14px;
  line-height: 1.5;
  margin-bottom: 8px;
}

.insight-improvement {
  color: #4ecdc4;
  font-size: 13px;
}

.improvement-label {
  color: #a6accd;
}

.improvement-value {
  margin-left: 4px;
}

/* 提交记录样式 */
.submissions-container {
  display: flex;
  gap: 20px;
  height: 100%;
}

.submissions-list {
  flex: 0 0 300px;
  background: #1e1e2e;
  border-radius: 12px;
  padding: 16px;
  overflow-y: auto;
}

.submissions-header {
  margin-bottom: 16px;
}

.submissions-header h3 {
  margin: 0 0 12px 0;
  color: #e6edf3;
}

.filter-buttons {
  display: flex;
  gap: 8px;
}

.filter-button {
  padding: 6px 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  background: transparent;
  color: #a6accd;
  cursor: pointer;
  transition: all 0.2s ease;
}

.filter-button:hover {
  background: rgba(255, 255, 255, 0.05);
}

.filter-button.active {
  background: #7c4dff;
  color: white;
  border-color: #7c4dff;
}

.submission-items {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.submission-item {
  padding: 12px;
  background: #282836;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  border: 1px solid transparent;
}

.submission-item:hover {
  background: #2d2d3f;
}

.submission-item.active {
  border-color: #7c4dff;
  background: #2d2d3f;
}

.submission-status {
  font-weight: 500;
  margin-bottom: 8px;
}

.submission-status.accepted {
  color: #4caf50;
}

.submission-status.wrong.answer,
.submission-status.runtime.error,
.submission-status.compilation.error,
.submission-status.time.limit.exceeded,
.submission-status.memory.limit.exceeded {
  color: #f44336;
}

.submission-status.pending,
.submission-status.system.error {
  color: #ff9800;
}

.submission-info {
  font-size: 0.9em;
  color: #a6accd;
}

.submission-time {
  margin-bottom: 4px;
}

.submission-details {
  display: flex;
  gap: 8px;
}

.submission-detail {
  flex: 1;
  background: #1e1e2e;
  border-radius: 12px;
  padding: 16px;
  overflow-y: auto;
}

.detail-header {
  margin-bottom: 16px;
  padding-bottom: 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.status-info {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.status-label {
  color: #a6accd;
}

.status-value {
  font-weight: 500;
}

.status-value.accepted {
  color: #4caf50;
}

.status-value.wrong.answer,
.status-value.runtime.error,
.status-value.compilation.error,
.status-value.time.limit.exceeded,
.status-value.memory.limit.exceeded {
  color: #f44336;
}

.status-value.pending,
.status-value.system.error {
  color: #ff9800;
}

.performance-info {
  display: flex;
  gap: 16px;
  color: #a6accd;
}

.runtime-info,
.memory-info {
  display: flex;
  align-items: center;
  gap: 4px;
}

.code-container {
  background: #282836;
  border-radius: 8px;
  overflow: hidden;
}

.code-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: rgba(255, 255, 255, 0.05);
}

.language-info {
  color: #e6edf3;
  font-family: 'JetBrains Mono', monospace;
}

.code-block {
  margin: 0;
  padding: 16px;
  background: #1e1e2e;
  overflow-x: auto;
  font-family: 'JetBrains Mono', monospace;
  color: #e6edf3;
  line-height: 1.6;
}

.error-message {
  margin-top: 16px;
  padding: 12px;
  background: rgba(244, 67, 54, 0.1);
  border: 1px solid rgba(244, 67, 54, 0.2);
  border-radius: 8px;
}

.error-message pre {
  margin: 0;
  color: #f44336;
  font-family: 'JetBrains Mono', monospace;
  white-space: pre-wrap;
}

.no-submissions {
  padding: 24px;
  text-align: center;
  color: #a6accd;
}

/* 调试区域现代化样式增强 */
.debug-container {
  display: flex;
  height: 100%;
  gap: 16px;
  background: linear-gradient(to right, #1a1a2e, #1e1e2e);
  border-radius: 12px;
  padding: 1px;
  position: relative;
  overflow: hidden;
  margin: 1px;
}

.debug-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, 
    rgba(76, 175, 80, 0) 0%,
    rgba(76, 175, 80, 0.3) 50%,
    rgba(76, 175, 80, 0) 100%
  );
}

.debug-input,
.debug-output {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: #282836;
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.debug-input::after {
  content: '';
  position: absolute;
  top: 10%;
  right: -1px;
  width: 1px;
  height: 80%;
  background: linear-gradient(to bottom,
    rgba(78, 205, 196, 0) 0%,
    rgba(78, 205, 196, 0.3) 50%,
    rgba(78, 205, 196, 0) 100%
  );
  box-shadow: 0 0 8px rgba(78, 205, 196, 0.3);
}

.debug-output::before {
  content: '';
  position: absolute;
  top: 10%;
  left: -1px;
  width: 1px;
  height: 80%;
  background: linear-gradient(to bottom,
    rgba(124, 77, 255, 0) 0%,
    rgba(124, 77, 255, 0.3) 50%,
    rgba(124, 77, 255, 0) 100%
  );
  box-shadow: 0 0 8px rgba(124, 77, 255, 0.3);
}

.debug-panel {
  display: flex;
  flex-direction: column;
  height: 100%;
  position: relative;
  z-index: 1;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 18px;
  background: linear-gradient(to right, #1e1e2e, #282836);
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  position: relative;
}

.panel-header::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, 
    rgba(124, 77, 255, 0) 0%,
    rgba(124, 77, 255, 0.2) 50%,
    rgba(124, 77, 255, 0) 100%
  );
}

.header-title {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #e6edf3;
  font-weight: 500;
  text-shadow: 0 0 10px rgba(78, 205, 196, 0.3);
}

.header-title i {
  font-size: 18px;
  color: #4ecdc4;
  filter: drop-shadow(0 0 8px rgba(78, 205, 196, 0.4));
}

.help-icon {
  color: #7c4dff;
  cursor: pointer;
  font-size: 16px;
  opacity: 0.8;
  transition: all 0.3s ease;
  filter: drop-shadow(0 0 8px rgba(124, 77, 255, 0.4));
}

.help-icon:hover {
  opacity: 1;
  transform: scale(1.2) rotate(15deg);
}

.panel-actions {
  display: flex;
  align-items: center;
  gap: 14px;
}

.execution-status {
  display: flex;
  align-items: center;
}

.status-badge {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px 12px;
  border-radius: 8px;
  font-size: 13px;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(4px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.status-badge.running {
  color: #4ecdc4;
  border-color: rgba(78, 205, 196, 0.3);
  background: rgba(78, 205, 196, 0.1);
  animation: pulse 1.5s infinite;
}

.status-badge.success {
  color: #4caf50;
  border-color: rgba(76, 175, 80, 0.3);
  background: rgba(76, 175, 80, 0.1);
}

.status-badge.error {
  color: #f44336;
  border-color: rgba(244, 67, 54, 0.3);
  background: rgba(244, 67, 54, 0.1);
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(78, 205, 196, 0.4);
  }
  70% {
    box-shadow: 0 0 0 6px rgba(78, 205, 196, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(78, 205, 196, 0);
  }
}

.action-button {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.05);
  color: #a6accd;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.action-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, 
    rgba(255, 255, 255, 0.1) 0%, 
    rgba(255, 255, 255, 0) 100%
  );
  opacity: 0;
  transition: opacity 0.3s ease;
}

.action-button:hover::before {
  opacity: 1;
}

.action-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.action-button.clear:hover {
  color: #f44336;
  background: rgba(244, 67, 54, 0.1);
}

.panel-content {
  flex: 1;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, 
    rgba(40, 40, 54, 0.6) 0%, 
    rgba(30, 30, 46, 0.6) 100%
  );
}

.custom-input-textarea {
  width: 100%;
  height: 100%;
  padding: 18px;
  background: transparent; /* 修改为深色背景 */
  border: none;
  color: #e6edf3;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.6;
  resize: none;
  position: relative;
  z-index: 1;
}

.custom-input-textarea:focus {
  outline: none;
}

.custom-input-textarea::placeholder {
  color: #6c7086;
  opacity: 0.8;
}

.output-wrapper {
  height: 100%;
  padding: 18px;
  background: transparent;
  transition: all 0.3s ease;
  position: relative;
}

.output-wrapper::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0.05;
  transition: opacity 0.3s ease;
}

.output-wrapper.success::before {
  background: linear-gradient(135deg, 
    rgba(76, 175, 80, 0.1) 0%, 
    rgba(76, 175, 80, 0) 100%
  );
  opacity: 0.1;
}

.output-wrapper.error::before {
  background: linear-gradient(135deg, 
    rgba(244, 67, 54, 0.1) 0%, 
    rgba(244, 67, 54, 0) 100%
  );
  opacity: 0.1;
}

.output-content {
  margin: 0;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.6;
  color: #e6edf3;
  white-space: pre-wrap;
  position: relative;
  z-index: 1;
}

.empty-state {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 14px;
  color: #6c7086;
  text-align: center;
  width: 100%;
  padding: 0 20px;
}

.empty-state i {
  font-size: 32px;
  opacity: 0.5;
  background: linear-gradient(135deg, #4ecdc4, #7c4dff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  filter: drop-shadow(0 0 10px rgba(124, 77, 255, 0.3));
}

.empty-state span {
  font-size: 14px;
  font-weight: 500;
  background: linear-gradient(90deg, #a6accd, #6c7086);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

/* 完全同步index.vue的下拉样式 */
:deep(.el-select) {
  --el-select-border-color-hover: #4ecdc4;
  --el-fill-color-blank: #1e1e2d;
  --el-border-color: rgba(255, 255, 255, 0.1);
  --el-text-color-regular: #fff;
  width: 200px; /* 统一宽度 */
}

:deep(.el-input__wrapper) {
  background-color: #1e1e2d !important;
  box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.1) !important;
  border-radius: 6px;
  padding: 0 8px;
  transition: all 0.3s ease;
}

:deep(.el-input__wrapper:hover),
:deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #4ecdc4 !important;
}

:deep(.el-input__inner) {
  color: #fff !important;
  height: 35px;
  line-height: 35px;
  font-size: 14px;
}

:deep(.el-input__inner::placeholder) {
  color: #a6accd !important;
}

:deep(.el-select__caret) {
  color: #a6accd;
}

/* 全局下拉菜单样式（与index.vue完全一致） */
:global(.dark-select) {
  background-color: #1e1e2d !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 6px !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3) !important;
}

:global(.dark-select .el-select-dropdown__item) {
  color: #a6accd !important;
  height: 35px;
  line-height: 35px;
  padding: 0 12px;
}

:global(.dark-select .el-select-dropdown__item.hover),
:global(.dark-select .el-select-dropdown__item:hover) {
  background-color: #282836 !important;
  color: #4ecdc4 !important;
}

:global(.dark-select .el-select-dropdown__item.selected) {
  background-color: #282836 !important;
  color: #4ecdc4 !important;
  font-weight: 500;
}

:global(.dark-select .el-popper__arrow::before) {
  background-color: #1e1e2d !important;
  border-color: rgba(255, 255, 255, 0.1) !important;
}

/* 新增样式 */
.description-title {
  color: #4ecdc4;
  border-bottom: 2px solid rgba(78, 205, 196, 0.3);
  padding-bottom: 12px;
  margin-bottom: 24px;
  font-size: 20px;
}

.examples-title {
  color: #7c4dff;
  margin: 32px 0 20px;
  font-size: 18px;
}

.example-item {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 24px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.example-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  color: #a6accd;
}

.copy-button {
  background: rgba(78, 205, 196, 0.1);
  border: 1px solid rgba(78, 205, 196, 0.3);
  color: #4ecdc4;
  padding: 6px 12px;
  border-radius: 6px;
  transition: all 0.3s ease;
}

.copy-button:hover {
  background: rgba(78, 205, 196, 0.2);
  transform: translateY(-1px);
}

.example-columns {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}

.example-input, .example-output {
  background: #2d2d3f;
  border-radius: 8px;
  padding: 16px;
  position: relative;
  border: 1px solid rgba(255, 255, 255, 0.1);
}


pre {
  margin: 0;
  white-space: pre-wrap;
  font-family: 'JetBrains Mono', monospace;
  color: #e6edf3;
  line-height: 1.6;
  background: rgba(0, 0, 0, 0.3);
  padding: 12px;
  border-radius: 6px;
}

.problem-meta {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 24px;
  margin-top: 32px;
  padding: 20px;
  background: linear-gradient(135deg, #1e1e2e 0%, #2d2d3f 100%);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
}

.meta-label {
  color: #a6accd;
}

.meta-value {
  color: #4ecdc4;
  font-weight: 500;
}

.el-icon-time, .el-icon-cpu {
  font-size: 20px;
  color: #7c4dff;
}

/* 复制按钮样式 */
.copy-button {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  background: rgba(124, 77, 255, 0.08);
  border: 1px solid rgba(124, 77, 255, 0.2);
  border-radius: 4px;
  padding: 4px 8px;
  color: #7c4dff;
  font-size: 12px;
  transition: all 0.2s ease;
  cursor: pointer;
}

.copy-button:hover {
  background: rgba(124, 77, 255, 0.15);
  border-color: rgba(124, 77, 255, 0.4);
  transform: translateY(-1px);
}

.copy-button i {
  font-size: 14px;
  margin-right: 4px;
}

/* 消息提示样式 */
.copy-message {
  font-family: 'JetBrains Mono', monospace;
  background: rgba(40, 40, 40, 0.9) !important;
  border: 1px solid #4ecdc4 !important;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3) !important;
}

.copy-message .el-message__content {
  color: #4ecdc4 !important;
}

@media (max-width: 768px) {
  .solution-container {
    grid-template-columns: 1fr;
  }
  
  .language-switcher {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }
  
  .lang-tab {
    flex: 1;
    text-align: center;
  }
}

.test-cases {
  margin-top: 20px;
  padding: 16px;
  background: #f8f9fa;
  border-radius: 8px;
}

.case-item {
  margin: 12px 0;
  padding: 12px;
  background: white;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.solution-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.solution-header h3 {
  font-size: 20px;
  color: #e6edf3;
  margin: 0;
}

.solution-approach {
  background: #282836;
  border-radius: 8px;
  padding: 16px;
  color: #e6edf3;
  line-height: 1.6;
  white-space: pre-wrap;
}

.solution-complexity {
  display: flex;
  gap: 24px;
  background: linear-gradient(135deg, #1e1e2e 0%, #2d2d3f 100%);
  padding: 16px;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.complexity-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.complexity-label {
  color: #a6accd;
}

.complexity-value {
  color: #4ecdc4;
  font-family: 'JetBrains Mono', monospace;
}

.solution-implementations {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.implementations-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.implementations-header h4 {
  font-size: 16px;
  color: #e6edf3;
  margin: 0;
}

.implementation-block {
  background: #282836;
  border-radius: 8px;
  overflow: hidden;
}

.code-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: rgba(255, 255, 255, 0.05);
}

.language-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.language-name {
  color: #e6edf3;
  font-weight: 500;
}

.version-tag {
  padding: 2px 6px;
  background: rgba(78, 205, 196, 0.1);
  border: 1px solid rgba(78, 205, 196, 0.2);
  border-radius: 4px;
  color: #4ecdc4;
  font-size: 12px;
}

.code-block {
  margin: 0;
  padding: 16px;
  background: #1e1e2e;
  overflow-x: auto;
  font-family: 'JetBrains Mono', monospace;
}

.code-block code {
  color: #e6edf3;
  line-height: 1.6;
}

/* 适配暗色主题的下拉菜单 */
:deep(.el-select) {
  --el-select-input-focus-border-color: #4ecdc4;
}

:deep(.el-select-dropdown) {
  background-color: #282836;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

:deep(.el-select-dropdown__item) {
  color: #e6edf3;
}

:deep(.el-select-dropdown__item.hover),
:deep(.el-select-dropdown__item:hover) {
  background-color: rgba(78, 205, 196, 0.1);
}

:deep(.el-select-dropdown__item.selected) {
  color: #4ecdc4;
  font-weight: bold;
}

/* 提交记录列表样式 */
.submissions {
  padding: 20px;
  background-color: #1e1e2e;
  border-radius: 12px;
}

.search-controls {
  display: flex;
  gap: 16px;
  margin-bottom: 20px;
}

.filter-select {
  width: 160px;
}

.refresh-button {
  height: 36px;
  padding: 0 16px;
  background-color: #2d2d3f;
  color: #4ecdc4;
  border: 1px solid #4ecdc4;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 8px;
}

.refresh-button:hover {
  background-color: rgba(78, 205, 196, 0.1);
}

.submissions-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.submission-card {
  background-color: #2d2d3f;
  border-radius: 12px;
  padding: 16px;
  display: flex;
  gap: 16px;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.submission-card:hover {
  transform: translateY(-2px);
  border-color: rgba(255, 255, 255, 0.2);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.submission-status {
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  min-width: 90px;
  text-align: center;
}

/* 状态样式类 */
.status-accepted { background-color: #4ecdc4; color: white; }
.status-wrong { background-color: #ff6b6b; color: white; }
.status-error { background-color: #ff6b6b; color: white; }
.status-timeout { background-color: #ffd93d; color: black; }
.status-memory { background-color: #ff9f43; color: white; }
.status-compile-error { background-color: #ff6b6b; color: white; }
.status-pending { background-color: #a6accd; color: white; }
.status-system-error { background-color: #ff6b6b; color: white; }
.status-not-accepted { background-color: #ff6b6b; color: white; }
.status-default { background-color: #a6accd; color: white; }

/* 弹窗样式 */
.submission-detail {
  background-color: #1e1e2e;
  border-radius: 8px;
  overflow: hidden;
}

.submission-header {
  padding: 20px;
  background-color: #2d2d3f;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.status-section {
  display: flex;
  align-items: center;
  gap: 12px;
}

.submission-stats {
  display: flex;
  flex-wrap: wrap;
  gap: 24px;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.stat-label {
  color: #a6accd;
}

.stat-value {
  color: #fff;
  font-family: 'Fira Code', monospace;
}

.code-section {
  padding: 20px;
}

.code-section h4 {
  color: #fff;
  margin-bottom: 12px;
}

.code-container {
  position: relative;
  background-color: #282a36;
  border-radius: 8px;
  overflow: hidden;
}

.code-container pre {
  margin: 0;
  padding: 16px;
  overflow-x: auto;
}

.copy-button {
  position: absolute;
  top: 8px;
  right: 8px;
  padding: 6px;
  background-color: #44475a;
  border: none;
  border-radius: 4px;
  color: #6272a4;
  cursor: pointer;
  transition: all 0.3s ease;
}

.copy-button:hover {
  background-color: #6272a4;
  color: #f8f8f2;
}

.error-section {
  padding: 20px;
}

.error-section h4 {
  color: #ff6b6b;
  margin-bottom: 12px;
}

.error-message {
  background-color: #282a36;
  padding: 16px;
  border-radius: 8px;
  color: #ff6b6b;
  font-family: 'Fira Code', monospace;
  white-space: pre-wrap;
  word-wrap: break-word;
}

/* Element Plus 暗色主题覆盖 */
:deep(.el-select) {
  --el-select-border-color-hover: #4ecdc4;
  --el-fill-color-blank: #1e1e2d;
  --el-border-color: rgba(255, 255, 255, 0.1);
  --el-text-color-regular: #fff;
}

:deep(.el-input__wrapper) {
  background-color: #1e1e2d !important;
  box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.1) !important;
  border-radius: 6px;
  padding: 0 8px;
}

:deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #4ecdc4 !important;
}

:deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #4ecdc4 !important;
}

:deep(.el-input__inner) {
  color: #fff !important;
  height: 35px;
  line-height: 35px;
  font-size: 14px;
}

:deep(.el-input__inner::placeholder) {
  color: #a6accd !important;
}

:deep(.el-select__caret) {
  color: #a6accd;
}

:global(.dark-select) {
  background-color: #1e1e2d !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 6px !important;
}

:global(.dark-select .el-select-dropdown__item) {
  color: #a6accd !important;
  height: 35px;
  line-height: 35px;
  padding: 0 12px;
}

:global(.dark-select .el-select-dropdown__item:hover) {
  background-color: #282836 !important;
  color: #4ecdc4 !important;
}

:global(.dark-select .el-select-dropdown__item.selected) {
  background-color: #282836 !important;
  color: #4ecdc4 !important;
  font-weight: 500;
}

.pagination-controls {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.pagination-controls button {
  margin: 0 10px;
  padding: 8px 12px;
  border: none;
  border-radius: 4px;
  background-color: #4ecdc4;
  color: white;
  cursor: pointer;
  transition: background-color 0.3s;
}

.pagination-controls button:disabled {
  background-color: #7c7c7c;
  cursor: not-allowed;
}

.pagination-controls span {
  align-self: center;
  color: #e6edf3;
}

.language-selection {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100px; /* 设置高度以确保提示信息可见 */
  color: #a6accd; /* 提示信息颜色 */
  font-size: 16px; /* 提示信息字体大小 */
}

.language-selection el-icon {
  font-size: 24px; /* 图标大小 */
  margin-top: 8px; /* 图标与文本的间距 */
}

/* 添加闪动光标的样式 */
@keyframes blink {
  0% { opacity: 1; }
  50% { opacity: 0; }
  100% { opacity: 1; }
}

.cursor {
  display: inline-block;
  width: 2px; /* 光标宽度 */
  height: 1.5em; /* 光标高度 */
  background-color: #4ecdc4; /* 光标颜色 */
  animation: blink 1s step-end infinite; /* 闪动效果 */
  position: absolute; /* 绝对定位 */
  pointer-events: none; /* 不影响鼠标事件 */
}

.code-content {
  position: relative;
  flex: 1;
  overflow: visible; /* 修改：不需要自己的滚动条 */
}

:deep(.p-inputtextarea) {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  min-height: 300px;
  background: transparent !important;
  color: transparent !important; /* 修改：文本颜色设为透明 */
  caret-color: #e6edf3 !important; /* 添加：设置光标颜色 */
  border: none !important;
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
  padding: 16px;
  resize: none;
  z-index: 2;
}

.code-highlight {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 16px;
  background: #1e1e2e;
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
  pointer-events: none;
  white-space: pre-wrap;
  word-wrap: break-word;
  z-index: 1;
  overflow: visible; /* 修改：不需要自己的滚动条 */
}

.copy-code-button {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  background: rgba(78, 205, 196, 0.1);
  border: 1px solid rgba(78, 205, 196, 0.3);
  border-radius: 4px;
  color: #4ecdc4;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.copy-code-button:hover {
  background: rgba(78, 205, 196, 0.2);
  transform: translateY(-1px);
}

.copy-code-button i {
  font-size: 14px;
  transition: all 0.3s ease;
}

.copy-code-button i.copied {
  color: #4caf50;
}

.copy-message {
  background: #282836 !important;
  border: 1px solid #4ecdc4 !important;
  color: #4ecdc4 !important;
}

/* 代码高亮主题样式 */
:deep(.token.comment),
:deep(.token.prolog),
:deep(.token.doctype),
:deep(.token.cdata) {
  color: #6c7086 !important;
}

:deep(.token.punctuation) {
  color: #a6accd !important;
}

:deep(.token.property),
:deep(.token.keyword),
:deep(.token.tag) {
  color: #7c4dff !important;
}

:deep(.token.string) {
  color: #4ecdc4 !important;
}

:deep(.token.operator),
:deep(.token.entity),
:deep(.token.url) {
  color: #ff9f43 !important;
}

:deep(.token.function) {
  color: #82aaff !important;
}

:deep(.token.number) {
  color: #f78c6c;
}

:deep(.token.boolean),
:deep(.token.constant) {
  color: #ff5370;
}

:deep(.token.class-name) {
  color: #ffcb6b;
}

:deep(.token.regex) {
  color: #89ddff;
}

:deep(.token.important) {
  color: #c792ea;
}

:deep(.token.variable) {
  color: #c792ea;
}

.output-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
  flex: 1;
}

.output-panel,
.compiler-panel {
  background: #282a36;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.05);
  flex: 1;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 12px;
  background: linear-gradient(to right, #1e1e2e, #282836);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.header-title {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #e6edf3;
}

.header-title i {
  font-size: 16px;
  color: #4ecdc4;
}

.panel-content {
  padding: 12px;
  min-height: 100px;
}

.output-content,
.compiler-output {
  margin: 0;
  white-space: pre-wrap;
  word-wrap: break-word;
  color: #e6edf3;
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
}

.output-content.error,
.compiler-output.error {
  color: #ff5555;
}

.help-icon {
  color: #6c7086;
  cursor: help;
  transition: color 0.3s ease;
}

.help-icon:hover {
  color: #4ecdc4;
}

.console-header .rotated {
  transform: rotate(90deg); /* 旋转箭头 */
  transition: transform 0.3s ease; /* 添加过渡效果 */
}

.arrow-icon {
  transition: transform 0.3s ease; /* 添加过渡效果 */
  margin-right: 8px; /* 图标与文本之间的间距 */
}

/* 添加滚动条样式 */
.editor-wrapper::-webkit-scrollbar {
    width: 8px;
    height: 8px;
}

.editor-wrapper::-webkit-scrollbar-track {
    background: #1e1e2e;
}

.editor-wrapper::-webkit-scrollbar-thumb {
    background: #2d2d3f;
    border-radius: 4px;
}

.editor-wrapper::-webkit-scrollbar-thumb:hover {
    background: #3d3d4f;
}

.analysis-section {
  margin-bottom: 24px;
  padding: 20px;
  border-radius: 12px;
  background: rgba(40, 40, 54, 0.5);
}

.error-section {
  border: 1px solid rgba(255, 77, 77, 0.1);
}

.logic-section {
  border: 1px solid rgba(124, 77, 255, 0.1);
  background: rgba(124, 77, 255, 0.05);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 500;
  color: #e6edf3;
}

.error-summary {
  color: #ff4d4d;
  font-size: 14px;
}

.logic-summary {
  color: #7c4dff;
  font-size: 14px;
}

.error-list, .insights-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.error-card, .insight-item {
  background: rgba(40, 40, 54, 0.3);
  border-radius: 8px;
  padding: 16px;
}

.error-card-header {
  display: flex;
  gap: 12px;
  margin-bottom: 12px;
}

.error-type-badge {
  background: rgba(255, 77, 77, 0.1);
  color: #ff4d4d;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.error-location-badge {
  display: flex;
  align-items: center;
  gap: 4px;
  color: #a6accd;
  font-size: 12px;
}

.error-message, .insight-description {
  color: #a6accd;
  font-size: 14px;
  line-height: 1.6;
}

.code-block {
  margin-top: 12px;
  background: #282836;
  border-radius: 8px;
  padding: 12px;
}

.code-block pre {
  margin: 0;
}

.code-block code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
}

.insight-item {
  display: flex;
  gap: 12px;
}

.insight-icon {
  color: #7c4dff;
  font-size: 20px;
}

.insight-content {
  flex: 1;
}

.insight-title {
  color: #e6edf3;
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 8px;
}

.insight-description :deep(code) {
  background: #282836;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.9em;
  color: #e6edf3;
}

.error-card .code-block {
  background: #282836;
  border-radius: 8px;
  padding: 12px;
  margin-top: 12px;
  position: relative;
}

.error-card .code-block pre {
  margin: 0;
  padding: 0;
  background: transparent;
}

.error-card .code-block code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
  color: #e6edf3;
}

/* 代码高亮主题样式 */
.error-card :deep(.token.comment),
.error-card :deep(.token.prolog),
.error-card :deep(.token.doctype),
.error-card :deep(.token.cdata) {
  color: #6c7086;
}

.error-card :deep(.token.punctuation) {
  color: #a6accd;
}

.error-card :deep(.token.keyword),
.error-card :deep(.token.operator) {
  color: #7c4dff;
}

.error-card :deep(.token.string) {
  color: #4ecdc4;
}

.error-card :deep(.token.number) {
  color: #f78c6c;
}

.error-card :deep(.token.function) {
  color: #82aaff;
}

.error-card :deep(.token.class-name) {
  color: #ffcb6b;
}

.error-card :deep(.token.constant) {
  color: #ff5370;
}

.error-card :deep(.token.variable) {
  color: #c792ea;
}

/* 搜索控件样式 */
.search-controls {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
  align-items: center;
  flex-wrap: wrap;
}

.filter-select {
  width: 150px;
  border-radius: 6px;
}

.refresh-button {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background-color: #2d2d3f;
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: #a6accd;
  cursor: pointer;
  transition: all 0.3s ease;
}

.refresh-button:hover {
  background-color: #4ecdc4;
  color: white;
  transform: rotate(180deg);
}

.refresh-button i {
  font-size: 16px;
}

/* 适配不同尺寸的浏览器 */
@media (max-width: 768px) {
  .search-controls {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .filter-select {
    width: 100%;
  }
}

.example-block {
  background-color: #282836;
  border-radius: 8px;
  padding: 10px;
  margin-bottom: 16px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.example-title {
  color: #e6edf3;
  font-size: 1.1em;
  margin-bottom: 15px;
  margin-top:-2px;
  font-weight: 500;
}

.example-columns {
  display: flex;
  gap: 16px;
}

.example-input, .example-output {
  flex: 1;
  background-color: #1e1e2e;
  border-radius: 6px;
  padding: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.example-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
  color: #a6accd;
}

.example-header .copy-button {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 4px 8px;
  background-color: transparent;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  color: #a6accd;
  cursor: pointer;
  transition: all 0.2s ease;
}

.example-header .copy-button:hover {
  background-color: rgba(255, 255, 255, 0.05);
  border-color: #4ecdc4;
  color: #4ecdc4;
}

.example-input pre, .example-output pre {
  margin: 0;
  padding: 8px;
  background-color: #282836;
  border-radius: 4px;
  color: #e6edf3;
  font-family: 'JetBrains Mono', monospace;
  white-space: pre-wrap;
  word-break: break-all;
}

/* 提交记录样式 */
.submissions {
  padding: 20px;
  background-color: #1e1e2e;
  border-radius: 12px;
}

/* 弹窗样式覆盖 */
:deep(.p-dialog) {
  background: #1e1e2e;
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

:deep(.p-dialog-header) {
  background: #2d2d3f;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  color: #e6edf3;
}

:deep(.p-dialog-content) {
  background: #1e1e2e;
  color: #e6edf3;
  padding: 20px;
}

:deep(.p-dialog-footer) {
  background: #2d2d3f;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px 20px;
}

/* 提交详情样式 */
.submission-detail {
  background-color: #1e1e2e;
  border-radius: 8px;
  overflow: hidden;
}

.test-case-content,
.program-output-content,
.compiler-output-content {
  min-height: 300px; /* 设置相同的最小高度 */
}

.test-case-input {
  background-color: #2d2d3f; /* 暗色背景 */
  color: #e0e0e0; /* 字体颜色 */
  border: 1px solid #444; /* 边框颜色 */
  border-radius: 4px; /* 圆角 */
  padding: 10px; /* 内边距 */
  resize: none; /* 禁止手动调整大小 */
  flex-grow: 1; /* 使输入框占据剩余空间 */
  min-height: 100px; /* 设置最小高度 */
}

.test-case-content {
  flex-grow: 1; /* 使测试用例内容占据剩余空间 */
  display: flex;
  flex-direction: column;
}
</style>