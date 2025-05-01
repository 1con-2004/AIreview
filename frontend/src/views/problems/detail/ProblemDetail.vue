<template>
  <div class="problem-detail">
    <nav-bar></nav-bar>
    <div class="content">
      <!-- 左侧题目描述区域 -->
      <div class="problem-description">
        <div class="problem-header">
          <div class="action-buttons">
            <button class="back-button" @click="goBack">题目列表</button>
          </div>
          <div class="title-section">
            <div class="title-row">
              <span class="problem-number">#{{ problem?.problem_number || '0001' }}</span>
              <h1>{{ problem?.title || '加载中...' }}</h1>
              <span v-if="problem?.userStatus === 'Accepted'" class="status-tag accepted">已通过</span>
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
                    <pre class="code-block"><code :class="getLanguageClass(impl.language)">{{ impl.code }}</code></pre>
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
                      <pre><code :class="getLanguageClass(selectedSubmission.language)">{{ selectedSubmission.code }}</code></pre>
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
                <div v-if="isAnalyzing" class="analysis-loading">
                  <div class="loading-container">
                    <div class="ai-brain-loading">
                      <div class="brain-container">
                        <div class="brain-icon">
                          <div class="connections">
                            <span></span><span></span><span></span><span></span>
                            <span></span><span></span><span></span><span></span>
                          </div>
                          <svg viewBox="0 0 32 32" class="brain-svg">
                            <path d="M16,24c-0.6,0-1,0.4-1,1s0.4,1,1,1s1-0.4,1-1S16.6,24,16,24z"/>
                            <path d="M18,12c-0.6,0-1,0.4-1,1s0.4,1,1,1s1-0.4,1-1S18.6,12,18,12z"/>
                            <path d="M23,13c-0.6,0-1,0.4-1,1s0.4,1,1,1s1-0.4,1-1S23.6,13,23,13z"/>
                            <path d="M24.5,17c-0.8,0-1.5,0.7-1.5,1.5s0.7,1.5,1.5,1.5s1.5-0.7,1.5-1.5S25.3,17,24.5,17z"/>
                            <path d="M9,14c0.6,0,1-0.4,1-1s-0.4-1-1-1s-1,0.4-1,1S8.4,14,9,14z"/>
                            <path d="M7.5,18c0.8,0,1.5-0.7,1.5-1.5S8.3,15,7.5,15S6,15.7,6,16.5S6.7,18,7.5,18z"/>
                            <path d="M12,12c0.6,0,1-0.4,1-1s-0.4-1-1-1s-1,0.4-1,1S11.4,12,12,12z"/>
                            <path d="M30.17,18.36c0.33-2.77-0.99-5.5-3.33-6.88C26.65,10.6,26.3,9.67,25.74,8.9c-1.51-2.11-4.16-3.07-6.68-2.4
                              c-0.72-0.78-1.73-1.31-2.87-1.45C15.42,5.03,14.65,5,13.88,5.14c-0.32,0.06-0.65,0.15-0.96,0.28c-0.18-0.31-0.41-0.59-0.68-0.83
                              c-1.05-0.95-2.43-1.34-3.96-1.08c-0.95,0.16-1.83,0.63-2.52,1.33C3.26,5.43,2.2,7.4,2.1,9.51C1.19,10.36,0.62,11.53,0.5,12.8
                              c-0.2,2.22,0.69,4.33,2.38,5.65c-0.05,1.4,0.28,2.76,0.93,3.96c1.12,2.05,3.12,3.43,5.35,3.7c0.39,0.05,0.78,0.07,1.16,0.07
                              c1.62,0,3.15-0.46,4.45-1.34c1.24,0.59,2.65,0.91,4.12,0.91c0.21,0,0.42-0.01,0.63-0.02c2.43-0.16,4.69-1.15,6.35-2.8
                              c0.19-0.18,0.36-0.38,0.53-0.58C27.87,22.29,29.74,20.53,30.17,18.36z M14.29,6.34c0.59-0.11,1.19-0.11,1.78-0.01
                              c0.71,0.09,1.35,0.42,1.86,0.89c-0.1,0.03-0.19,0.06-0.29,0.1c-0.48,0.19-0.93,0.44-1.33,0.75c-0.21,0.16-0.24,0.47-0.08,0.68
                              c0.09,0.12,0.23,0.18,0.38,0.18c0.1,0,0.21-0.03,0.3-0.1c0.32-0.24,0.67-0.44,1.05-0.59c0.33-0.13,0.68-0.23,1.04-0.28
                              c0.11-0.02,0.22-0.03,0.33-0.04c0.51,0.06,0.99,0.23,1.43,0.48c-0.14,0.09-0.29,0.17-0.44,0.24c-0.48,0.22-0.94,0.5-1.35,0.85
                              c-0.21,0.18-0.24,0.49-0.06,0.7c0.1,0.12,0.24,0.18,0.38,0.18c0.11,0,0.23-0.04,0.32-0.12c0.33-0.28,0.7-0.51,1.08-0.68
                              c0.05-0.03,0.11-0.05,0.16-0.07c0.84,0.82,1.22,2.05,0.95,3.24c-0.78,0.25-1.5,0.66-2.11,1.2c-0.12,0.1-0.22,0.2-0.33,0.31
                              c-0.22,0.23-0.43,0.46-0.6,0.72c-0.17,0.27-0.09,0.62,0.17,0.79c0.1,0.06,0.2,0.09,0.31,0.09c0.19,0,0.38-0.09,0.48-0.26
                              c0.12-0.19,0.28-0.36,0.44-0.53c0.13-0.14,0.27-0.28,0.42-0.4c0.44-0.36,0.96-0.65,1.5-0.82c0.1-0.03,0.2-0.02,0.25,0.03
                              c0.05,0.05,0.06,0.15,0.03,0.25c-0.17,0.54-0.45,1.05-0.82,1.5c-0.12,0.15-0.26,0.29-0.4,0.42c-0.16,0.16-0.34,0.31-0.53,0.44
                              c-0.17,0.11-0.26,0.29-0.26,0.48c0,0.11,0.03,0.21,0.09,0.31c0.14,0.22,0.43,0.29,0.66,0.17c1.46-1.02,2.14-2.84,1.71-4.56
                              c0.12-0.11,0.23-0.22,0.34-0.33c0.83-0.87,1.88-1.5,3.05-1.83c1.91,1.12,2.8,3.32,2.15,5.38c-0.58,1.82-2.16,3.04-3.97,3.09
                              c-0.6,0.01-1.2-0.12-1.75-0.38c-0.15-0.07-0.33-0.06-0.47,0.03c-0.14,0.09-0.23,0.25-0.24,0.42c-0.05,0.79-0.26,1.52-0.6,2.18
                              c-0.65,1.26-1.82,2.16-3.18,2.48c-0.16,0.04-0.32,0.07-0.48,0.09c-0.13,0.02-0.27,0.03-0.4,0.04c-0.13,0.01-0.25,0.01-0.38,0.01
                              c-0.17,0-0.35-0.01-0.52-0.03c-0.16-0.02-0.32-0.04-0.48-0.07c-0.5-0.1-0.98-0.26-1.43-0.48c-0.02-0.01-0.05-0.02-0.07-0.03
                              c-0.71-0.37-1.33-0.89-1.81-1.53c-0.56-0.74-0.91-1.62-0.99-2.58c-0.01-0.14-0.08-0.26-0.19-0.35c-0.11-0.09-0.26-0.13-0.4-0.1
                              c-0.78,0.13-1.58,0.09-2.34-0.1c-0.75-0.19-1.43-0.55-1.99-1.04c-1.51-1.31-1.88-3.48-0.99-5.21c0.07-0.13,0.08-0.28,0.03-0.42
                              C6.97,8.39,6.85,8.27,6.7,8.2C6.24,7.98,5.85,7.66,5.57,7.28c-0.37-0.51-0.54-1.1-0.51-1.73c0.05-1.11,0.8-2.1,1.86-2.45
                              c0.58-0.19,1.19-0.19,1.75-0.02c0.81,0.25,1.45,0.87,1.71,1.68c0.05,0.15,0.16,0.27,0.31,0.32c0.15,0.05,0.31,0.03,0.44-0.05
                              c0.22-0.14,0.46-0.25,0.71-0.33C13.08,6.5,13.63,6.39,14.29,6.34z M20.1,19.98c0.09-0.38,0.16-0.77,0.19-1.17
                              c0.67,0.17,1.35,0.19,2.02,0.07c0.1-0.02,0.2-0.04,0.3-0.06c0.8-0.21,1.55-0.62,2.14-1.22c0.5-0.5,0.86-1.11,1.07-1.78
                              c0.08-0.27,0.14-0.54,0.18-0.82c0.04-0.29,0.05-0.58,0.04-0.88c-0.01-0.12-0.03-0.24-0.05-0.36c-0.05-0.33-0.13-0.65-0.25-0.96
                              c0.92,1.05,1.35,2.49,1.14,3.91c-0.25,1.72-1.45,3.16-3.03,3.8C22.61,22.04,21.09,21.4,20.1,19.98z M5.73,13.81
                              c0.22,0.19,0.26,0.53,0.06,0.76c-0.95,1.07-0.99,2.69-0.09,3.8c0.03,0.03,0.06,0.06,0.09,0.09c0.07,0.04,0.14,0.07,0.23,0.07
                              c0.12,0,0.23-0.05,0.32-0.14c0.17-0.19,0.16-0.48-0.03-0.65c-0.03-0.03-0.07-0.06-0.1-0.09c-0.66-0.81-0.62-1.98,0.07-2.77
                              c0.19-0.22,0.17-0.56-0.05-0.76c-0.11-0.1-0.25-0.14-0.39-0.14C5.97,13.97,5.83,14.02,5.73,13.81z M11.96,22.95
                              c-0.91,0.73-2.03,1.11-3.18,1.11c-0.29,0-0.58-0.02-0.87-0.07c-1.86-0.22-3.52-1.34-4.46-3.01c-0.46-0.84-0.72-1.77-0.77-2.73
                              c-0.01-0.09,0-0.18,0-0.27c0.12,0.12,0.25,0.24,0.38,0.35c0.44,0.38,0.94,0.68,1.48,0.91c0.67,0.28,1.39,0.43,2.14,0.43
                              c0.11,0,0.23-0.01,0.34-0.01c0.14-0.01,0.28-0.02,0.42-0.03c0.09-0.01,0.19-0.02,0.28-0.03c0.11-0.02,0.22-0.03,0.33-0.05
                              c0.11-0.02,0.21-0.05,0.32-0.07c0.2-0.05,0.39-0.11,0.57-0.18c0.41-0.14,0.8-0.33,1.17-0.56c1.75-1.09,2.82-3.03,2.75-5.06
                              c0.61,0.35,1.12,0.87,1.47,1.53c0.39,0.72,0.51,1.53,0.37,2.33c-0.14,0.78-0.51,1.47-1.05,1.99c-0.28,0.28-0.62,0.51-1,0.67
                              c-0.53,0.22-1.12,0.26-1.68,0.1c-0.25-0.07-0.51,0.07-0.58,0.32c-0.07,0.25,0.07,0.51,0.32,0.58c0.28,0.08,0.56,0.12,0.85,0.12
                              c0.42,0,0.84-0.08,1.24-0.24c0.51-0.21,0.96-0.54,1.33-0.91c0.42,0.55,0.95,1.02,1.57,1.36c0.1,0.06,0.2,0.11,0.31,0.16
                              C13.95,21.59,12.9,22.39,11.96,22.95z M26.36,21.38c-1.47,1.44-3.43,2.31-5.52,2.45c-0.19,0.01-0.38,0.02-0.56,0.02
                              c-1.37,0-2.7-0.32-3.89-0.93c-0.02-0.01-0.04-0.02-0.06-0.03c-0.3-0.16-0.58-0.34-0.85-0.54c-0.34-0.25-0.66-0.53-0.95-0.83
                              c-0.1-0.11-0.2-0.22-0.3-0.33c0.37-0.33,0.69-0.72,0.93-1.16c0.05-0.08,0.09-0.17,0.13-0.26c1.37,1.51,3.48,2.01,5.35,1.22
                              c1.93-0.81,3.26-2.72,3.34-4.85c0.03-0.77-0.08-1.51-0.32-2.2c0.86,0.23,1.67,0.67,2.34,1.32c0.61,0.58,1.07,1.29,1.36,2.09
                              c0.42,1.19,0.39,2.48-0.1,3.64C26.99,20.45,26.71,20.93,26.36,21.38z"/>
                          </svg>
                        </div>
                      </div>
                    </div>
                    <div class="loading-text">
                      <div class="text">AI正在分析代码</div>
                      <!-- 添加进度条 -->
                      <div class="progress-container">
                        <div class="progress-bar" :style="{ width: progressWidth + '%', background: progressBackground }">
                        </div>
                        <span class="progress-text">{{ progressWidth }}%</span>
                      </div>
                      <div class="loading-stage">{{ loadingStage }}</div>
                    </div>
                  </div>
                </div>

                <div v-else class="analysis-result-content">
                  <!-- AI分析结果显示容器 -->
                  <div class="analysis-section"
                       style="background: linear-gradient(135deg, rgba(32, 36, 64, 0.8) 0%, rgba(40, 48, 90, 0.9) 100%); border: 1px solid rgba(65, 132, 255, 0.3); border-radius: 16px; padding: 24px; margin-bottom: 28px; box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(78, 205, 255, 0.1), inset 0 0 20px rgba(78, 255, 228, 0.05); transition: all 0.3s ease; position: relative; overflow: hidden;">
                    <!-- 科技感装饰元素 -->
                    <div style="position: absolute; top: -5px; right: -5px; width: 100px; height: 100px; background: radial-gradient(circle, rgba(78, 205, 255, 0.15) 0%, rgba(78, 205, 255, 0) 70%); border-radius: 50%;"></div>
                    <div style="position: absolute; bottom: -30px; left: 30%; width: 160px; height: 160px; background: radial-gradient(circle, rgba(76, 175, 180, 0.1) 0%, rgba(0, 0, 0, 0) 70%); border-radius: 50%;"></div>

                    <div class="section-header" style="display: flex; align-items: center; margin-bottom: 16px; position: relative; z-index: 1;">
                      <div style="background: linear-gradient(90deg, #4facfe 0%, #00f2fe 100%); width: 4px; height: 24px; margin-right: 12px; border-radius: 2px;"></div>
                      <div class="section-title" style="display: flex; align-items: center; flex-grow: 1;">
                        <i class="el-icon-info" style="color: #4facfe; margin-right: 8px; font-size: 20px;"></i>
                        <span style="font-weight: 600; font-size: 18px; background: linear-gradient(90deg, #4facfe 0%, #00f2fe 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">AI 代码分析</span>
                        <!-- 添加AI模型选择下拉框 -->
                        <div style="margin-left: auto;">
                          <el-select
                            v-model="selectedAiModel"
                            size="small"
                            placeholder="选择AI模型"
                            style="width: 160px; margin-right: 10px;"
                            popper-class="dark-select"
                          >
                            <el-option label="DeepSeek-V3" value="deepseek-chat" />
                            <el-option label="DeepSeek-R1" value="deepseek-reasoner" />
                            <el-option label="智谱GLM-4-FLASH" value="glm-4-flash" />
                          </el-select>
                        </div>
                      </div>
                    </div>

                    <div style="background: rgba(22, 24, 42, 0.7); border-radius: 12px; padding: 20px; margin-top: 16px; box-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.2); border: 1px solid rgba(78, 205, 255, 0.15); position: relative; z-index: 1;">
                      <!-- 科技感装饰线条 -->
                      <div style="position: absolute; top: 0; left: 20px; width: 80%; height: 1px; background: linear-gradient(90deg, rgba(78, 205, 255, 0.2) 0%, rgba(78, 205, 255, 0) 100%);"></div>
                      <div style="position: absolute; bottom: 0; right: 20px; width: 60%; height: 1px; background: linear-gradient(90deg, rgba(78, 205, 255, 0) 0%, rgba(78, 205, 255, 0.2) 100%);"></div>

                      <div v-if="!aiAnalysisResult" style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 40px 20px; text-align: center; min-height: 200px;">
                        <div style="width: 80px; height: 80px; margin-bottom: 20px; animation: pulse 2s infinite ease-in-out;">
                          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 2C6.48 2 2 6.48 2 12C2 17.52 6.48 22 12 22C17.52 22 22 17.52 22 12C22 6.48 17.52 2 12 2ZM12 20C7.59 20 4 16.41 4 12C4 7.59 7.59 4 12 4C16.41 4 20 7.59 20 12C20 16.41 16.41 20 12 20Z" fill="url(#paint0_linear)"/>
                            <path d="M13 7H11V13H17V11H13V7Z" fill="url(#paint1_linear)"/>
                            <defs>
                              <linearGradient id="paint0_linear" x1="2" y1="12" x2="22" y2="12" gradientUnits="userSpaceOnUse">
                                <stop stop-color="#4facfe"/>
                                <stop offset="1" stop-color="#00f2fe"/>
                              </linearGradient>
                              <linearGradient id="paint1_linear" x1="11" y1="10" x2="17" y2="10" gradientUnits="userSpaceOnUse">
                                <stop stop-color="#4facfe"/>
                                <stop offset="1" stop-color="#00f2fe"/>
                              </linearGradient>
                            </defs>
                          </svg>
                        </div>
                        <h3 style="font-size: 20px; font-weight: 600; margin-bottom: 12px; background: linear-gradient(90deg, #4facfe 0%, #00f2fe 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">等待AI分析</h3>
                        <p style="font-size: 16px; color: #a6accd; max-width: 400px; margin-bottom: 24px; line-height: 1.5;">请点击右侧编辑器上方的<span style="color: #4facfe; font-weight: 500;">「AI分析」</span>按钮，对您的代码进行智能分析。</p>
                        <div style="display: flex; align-items: center; justify-content: center; background: rgba(78, 205, 255, 0.1); border-radius: 8px; padding: 12px 16px; border: 1px dashed rgba(78, 205, 255, 0.3);">
                          <i class="el-icon-info-filled" style="color: #4facfe; margin-right: 8px; font-size: 16px;"></i>
                          <span style="color: #e6edf3; font-size: 14px;">AI分析将帮您查找代码中的问题并提供优化建议</span>
                        </div>
                      </div>

                      <!-- DeepSeek-R1的思考文本区域 -->
                      <div v-else-if="selectedAiModel === 'deepseek-reasoner'" class="deepseek-reasoner-container">
                        <!-- 字符串格式直接渲染 -->
                        <div class="markdown-content" v-if="typeof aiAnalysisResult === 'string'" v-html="renderMarkdown(aiAnalysisResult)"></div>
                        <!-- 处理data嵌套的字符串格式 -->
                        <div class="markdown-content" v-else-if="aiAnalysisResult && typeof aiAnalysisResult.data === 'string'" v-html="renderMarkdown(aiAnalysisResult.data)"></div>
                        <!-- 处理reasoning和analysis格式 -->
                        <div v-else-if="aiAnalysisResult && (aiAnalysisResult.reasoning || (aiAnalysisResult.data && aiAnalysisResult.data.reasoning))">
                          <!-- 思考过程显示 -->
                          <div class="result-block">
                            <div class="result-title">
                              <i :class="['arrow-icon', isReasoningExpanded ? 'fas fa-chevron-down' : 'fas fa-chevron-right']" @click="toggleReasoning"></i>
                              <span>思考过程 (Reasoning)</span>
                            </div>
                            <div class="markdown-content" v-if="isReasoningExpanded" v-html="renderMarkdown(aiAnalysisResult.reasoning || aiAnalysisResult.data.reasoning)"></div>
                          </div>
                          <!-- 分析结果显示 -->
                          <div class="result-block" style="margin-top: 20px;">
                            <div class="result-title">分析结果 (Analysis)</div>
                            <div class="markdown-content" v-html="renderMarkdown(aiAnalysisResult.analysis || aiAnalysisResult.data.analysis)"></div>
                          </div>
                        </div>
                        <!-- 无数据提示 -->
                        <div v-else style="color: #ff6b6b; text-align: center; padding: 20px;">
                          <i class="el-icon-warning-outline" style="font-size: 24px; margin-right: 8px;"></i>
                          <span>请先点击「AI分析」按钮，{{ getAiName() }}将会对您的代码进行智能分析</span>
                        </div>
                      </div>

                      <!-- 其他AI模型的标准展示 -->
                      <div v-else>
                        <!-- 字符串格式直接渲染 (GLM-4-Flash 和 DeepSeek-Chat) -->
                        <div class="markdown-content" v-if="typeof aiAnalysisResult === 'string'" v-html="renderMarkdown(aiAnalysisResult)"></div>
                        <!-- 处理data嵌套的字符串格式 -->
                        <div class="markdown-content" v-else-if="aiAnalysisResult && typeof aiAnalysisResult.data === 'string'" v-html="renderMarkdown(aiAnalysisResult.data)"></div>
                        <!-- 兼容旧格式 -->
                        <div class="markdown-content" v-else-if="aiAnalysisResult && aiAnalysisResult.rawAnalysis" v-html="renderMarkdown(aiAnalysisResult.rawAnalysis)"></div>
                        <div class="markdown-content" v-else-if="aiAnalysisResult && aiAnalysisResult.performance && aiAnalysisResult.performance.explanation" v-html="renderMarkdown(aiAnalysisResult.performance.explanation)"></div>
                        <!-- 无数据提示 -->
                        <div v-else style="color: #ff6b6b; text-align: center; padding: 20px;">
                          <i class="el-icon-warning-outline" style="font-size: 24px; margin-right: 8px;"></i>
                          <span>请先点击「AI分析」按钮，{{ getAiName() }}将会对您的代码进行智能分析</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- 逻辑分析部分 - 仅当存在结构化改进数据时显示 -->
                  <!-- 移除逻辑分析部分 div -->
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
              <div class="input-with-line-numbers">
                <div class="line-numbers">
                  <div v-for="n in (customInput.split('\n').length || 1)" :key="n" class="line-number">
                    {{ n }}
                  </div>
                </div>
                <textarea
                  v-model="customInput"
                  placeholder="输入测试用例..."
                  class="custom-input-textarea"
                  style="border: 1px solid #4ecdc4; background-color: rgba(78, 205, 196, 0.1); box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); transition: border-color 0.3s;"
                  @focus="(event) => { event.target.style.borderColor='#4caf50'; event.target.style.boxShadow='0 0 5px rgba(76, 175, 80, 0.5)'; }"
                  @blur="(event) => { event.target.style.borderColor='#4ecdc4'; event.target.style.boxShadow='none'; }"
                  @input="updateLineNumbers"
                  @scroll="syncScroll"
                  ref="customInputTextarea"
                ></textarea>
              </div>
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
import { defineComponent, ref, computed, watch, nextTick, onMounted, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import apiService from '@/utils/api'
import { ElMessage, ElMessageBox } from 'element-plus'
import Prism from 'prismjs'
import 'prismjs/themes/prism-tomorrow.css'
import 'prismjs/components/prism-clike'
import 'prismjs/components/prism-javascript'
import 'prismjs/components/prism-python'
import 'prismjs/components/prism-c'
import 'prismjs/components/prism-cpp'
import 'prismjs/components/prism-java'
import 'prismjs/components/prism-json'
import 'prismjs/plugins/line-numbers/prism-line-numbers.css'
import 'prismjs/plugins/line-numbers/prism-line-numbers'
import { Document, ArrowLeft, ArrowRight } from '@element-plus/icons-vue'
import Dialog from 'primevue/dialog'
import axios from 'axios'
import { useStore } from 'vuex'
import InputTextarea from 'primevue/textarea'
import { getProblemExamples } from '@/api/testCase'
// 导入marked库处理Markdown
import { marked } from 'marked'

// 导入其他需要的库
import MarkdownIt from 'markdown-it'
import hljs from 'highlight.js'
import 'highlight.js/styles/github-dark.css' // 暗色主题样式
// 引入埋点工具
import analytics from '@/utils/analytics'

export default defineComponent({
  name: 'ProblemDetail',
  components: {
    NavBar,
    Document,
    Dialog,
    ArrowLeft,
    ArrowRight,
    InputTextarea
  },
  setup () {
    const router = useRouter()
    const route = useRoute()
    
    // 移除这里的analytics初始化代码，使用全局初始化的analytics对象
    
    const problem = ref(null)
    const activeTab = ref('description')
    const selectedLanguage = ref('')
    const hasUserSelectedLanguage = ref(false)
    const code = ref('')
    const submissionFilter = ref('全部')
    const selectedSubmission = ref(null)
    const submissions = ref([])
    const problemExamples = ref([]) // 添加problemExamples
    const aiAnalysisResult = ref({
      errors: [],
      improvements: [],
      performance: null,
      rawAnalysis: null
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
        consoleElement.style.display = isExpanded.value ? 'block' : 'none' // 根据状态显示或隐藏控制台内容
      }
    }

    // 修改行号计算逻辑
    const lineCount = computed(() => {
      // 返回实际的代码行数，不设置最小值
      return code.value.split('\n').length
    })

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
          apiService.get(`problems/${problemNumber}`, { headers }),
          apiService.get(`problems/${problemNumber}/solution`, { headers })
        ])

        if (problemRes && problemRes.code === 200) {
          problem.value = {
            ...problemRes.data,
            example: {
              input: problemRes.data.input_example,
              output: problemRes.data.output_example
            }
          }

          if (solutionRes && solutionRes.code === 200) {
            problem.value.solution = solutionRes.data
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
        const statusMatch = !filters.status || submission.status === filters.status
        // 语言筛选
        const languageMatch = !filters.language || submission.language.toLowerCase() === filters.language.toLowerCase()
        // 同时满足状态和语言筛选条件
        return statusMatch && languageMatch
      })
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
        const response = await apiService.get(`problems/${route.params.id}/submissions`, { headers })

        // 如果没有数据，且是数字ID，尝试将其作为实际的problem_id使用
        if (response && response.code === 200 && (!response.data || response.data.length === 0)) {
          if (!isNaN(Number(route.params.id))) {
            console.log('尝试直接通过题目ID获取提交记录:', Number(route.params.id))
            // 尝试直接用数字ID获取
            try {
              const directResponse = await apiService.get(`judge/submissions?problem_id=${Number(route.params.id)}`, { headers })
              // 如果返回了内容但长度为0，说明没有提交记录
              if (directResponse && Array.isArray(directResponse)) {
                if (directResponse.length > 0) {
                  submissions.value = directResponse
                } else {
                  // 没有提交记录，设置为空数组
                  submissions.value = []
                  console.log('该题目没有提交记录')
                }

                // 添加: 获取提交记录后应用代码高亮
                nextTick(() => {
                  Prism.highlightAll()
                })
                return
              }
            } catch (directError) {
              console.error('直接通过ID获取提交记录失败:', directError)
              // 设置为空数组，避免undefined
              submissions.value = []
            }
          }
        }

        if (response && response.code === 200) {
          submissions.value = response.data || []

          // 添加: 获取提交记录后应用代码高亮
          nextTick(() => {
            Prism.highlightAll()
          })
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
        Accepted: '通过',
        'Wrong Answer': '答案错误',
        'Runtime Error': '运行错误',
        'Time Limit Exceeded': '超时',
        'Memory Limit Exceeded': '内存超限',
        'Compile Error': '编译错误',
        Pending: '等待中',
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
      filters.status = ''
      filters.language = ''
      currentPage.value = 1
    }

    // 刷新提交记录
    const refreshSubmissions = () => {
      fetchSubmissions()
      // 显示加载中的消息
      ElMessage({
        message: '正在刷新提交记录...',
        type: 'info',
        duration: 1000
      })
    }

    // 监听标签页变化
    watch(activeTab, (newTab) => {
      if (newTab === 'submissions') {
        fetchSubmissions()
        // 如果切换到提交记录标签，重置筛选条件
        resetFilters()
      }

      // 添加: 当切换到解决方案或提交记录标签时，确保代码语法高亮生效
      if (newTab === 'solution' || newTab === 'submissions') {
        nextTick(() => {
          Prism.highlightAll()
        })
      }
      
      // 记录标签切换埋点
      analytics.trackClick('tab_switch', `tab_${newTab}`, {
        problem_id: route.params.id,
        tab_name: newTab
      })
    })

    onMounted(() => {
      fetchProblem()
      fetchSubmissions()
      fetchProblemExamples() // 添加获取样例的调用

      // 初始化Prism
      nextTick(() => {
        Prism.highlightAll()

        // 直接进行高亮处理，不需要判断语言
        highlightedCode.value = highlightCode(code.value, selectedLanguageForCode.value || 'C')
      })
      
      // 记录页面访问埋点
      analytics.trackPageView('problem_detail', {
        problem_id: route.params.id,
        referrer: document.referrer
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

    // 从AI分析文本中提取错误信息
    const extractErrors = (analysis) => {
      // 确保分析结果是字符串
      if (!analysis) return []

      // 如果分析结果不是字符串，尝试将其转换为字符串
      const analysisText = typeof analysis === 'string' ? analysis : JSON.stringify(analysis)

      const errors = []
      // 更新正则表达式以匹配新的格式，如"1. 错误代码片段"，而不是单独的"错误代码片段"
      const errorRegex = /1\.\s*错误代码片段[\s\S]*?有问题的代码[\s\S]*?[：:]\s*\`(.*?)\`[\s\S]*?错误原因[\s\S]*?[：:]\s*(.*?)(?=\n\n|\n$|$)/g
      let match

      while ((match = errorRegex.exec(analysisText)) !== null) {
        errors.push({
          type: '代码错误',
          location: '相关代码',
          message: match[2].trim(),
          severity: 'error',
          code: match[1].trim()
        })
      }

      // 如果没有匹配到错误，尝试更宽松的正则
      if (errors.length === 0) {
        // 尝试匹配包含代码的任何部分
        const codeRegex = /有问题的代码.*?\`(.*?)\`/g
        let codeMatch
        while ((codeMatch = codeRegex.exec(analysisText)) !== null) {
          // 尝试在代码周围找错误原因
          const surroundingText = analysisText.substring(
            Math.max(0, codeMatch.index - 100),
            Math.min(analysisText.length, codeMatch.index + codeMatch[0].length + 200)
          )

          // 从周围文本中提取可能的错误原因
          const reasonMatch = /错误原因.*?[:：]\s*(.*?)(?=\n|$)/i.exec(surroundingText)

          errors.push({
            type: '代码错误',
            location: '相关代码',
            message: reasonMatch ? reasonMatch[1].trim() : '代码有问题，需要修改',
            severity: 'error',
            code: codeMatch[1].trim()
          })
        }
      }

      // 如果仍然没有匹配到，创建一个通用的错误
      if (errors.length === 0 && analysisText) {
        errors.push({
          type: '代码分析',
          location: '整体代码',
          message: '请检查AI分析的完整内容，可能有需要改进的地方',
          severity: 'warning',
          code: null
        })
      }

      return errors
    }

    // 从AI分析文本中提取改进建议
    const extractImprovements = (analysis) => {
      // 确保分析结果是字符串
      if (!analysis) return []

      // 如果分析结果不是字符串，尝试将其转换为字符串
      const analysisText = typeof analysis === 'string' ? analysis : JSON.stringify(analysis)

      const improvements = []

      // 尝试匹配"2. 逻辑问题"部分
      const logicMatch = /2\.\s*逻辑问题([\s\S]*?)(?=\n\n\d\.|\n$|$)/.exec(analysisText)

      if (logicMatch) {
        // 获取逻辑问题部分的完整内容
        const logicContent = logicMatch[1].trim()

        // 尝试匹配带有"-"的要点
        const pointsRegex = /-\s*(.*?)(?=\n-|\n\n|\n$|$)/g
        let pointMatch
        let hasPoints = false

        while ((pointMatch = pointsRegex.exec(logicContent)) !== null) {
          hasPoints = true
          improvements.push({
            icon: 'el-icon-warning',
            title: '逻辑问题',
            description: pointMatch[1].trim()
          })
        }

        // 如果没找到要点，使用整个内容
        if (!hasPoints) {
          improvements.push({
            icon: 'el-icon-warning',
            title: '逻辑问题',
            description: logicContent
          })
        }
      } else {
        // 如果没有明确的"2. 逻辑问题"部分，查找分析中除了错误代码片段之外的有用信息

        // 先排除"1. 错误代码片段"部分
        let cleanedAnalysis = analysisText.replace(/1\.\s*错误代码片段[\s\S]*?(?=\n\n2\.|\n$|$)/, '').trim()

        // 如果仍有内容，将其作为通用建议
        if (cleanedAnalysis) {
          // 移除数字编号前缀（如有）
          cleanedAnalysis = cleanedAnalysis.replace(/^\d+\.\s*/, '')

          improvements.push({
            icon: 'el-icon-info',
            title: '分析建议',
            description: cleanedAnalysis
          })
        }

        // 如果还是没有内容，从原始分析中提取一般性建议
        if (improvements.length === 0 && analysisText) {
          // 寻找最后一段文字，可能包含总结性建议
          const lastParagraph = analysisText.split('\n\n').pop()
          if (lastParagraph && lastParagraph.length > 30) { // 有一定长度才可能是有用的建议
            improvements.push({
              icon: 'el-icon-info',
              title: '总体建议',
              description: lastParagraph.trim()
            })
          }
        }
      }

      return improvements
    }

    // 从AI分析文本中提取性能相关信息
    const extractPerformance = (analysis) => {
      // 返回包含原始分析内容的对象
      return {
        timeComplexity: '详见分析内容',
        spaceComplexity: '详见分析内容',
        explanation: typeof analysis === 'string' ? analysis : JSON.stringify(analysis) // 确保使用字符串类型
      }
    }

    // 定义analyzeCode函数，统一处理调用AI分析接口的请求
    const analyzeCode = async (params, accessToken) => {
      try {
        console.log('调用analyzeCode函数分析代码:', params)

        // 发送API请求到后端
        const apiResponse = await apiService.post(
          'ai/analyze-code',
          params,
          {
            headers: { Authorization: `Bearer ${accessToken}` }
          }
        )

        console.log('analyzeCode函数收到原始响应:', apiResponse)

        // 直接返回apiResponse，不做额外处理
        // 这样调用方可以使用相同的逻辑处理返回数据
        return apiResponse
      } catch (error) {
        console.error('analyzeCode函数调用API失败:', error)
        throw error
      }
    }

    // 统一处理AI分析结果的函数
    const processAiAnalysisResponse = (response) => {
      // 记录日志
      console.log('AI分析响应:', response)

      try {
        // DeepSeek-Reasoner处理逻辑
        if (selectedAiModel.value === 'deepseek-reasoner') {
          // 检查是否可以直接返回整个响应
          if (response?.data?.message?.content) {
            return parseDeepSeekResponseString(response.data)
          }

          // 2. 处理data.data包含reasoning/analysis的情况
          if (response?.data?.data) {
            // 对象格式
            if (typeof response.data.data === 'object') {
              if (response.data.data.reasoning || response.data.data.analysis) {
                return response.data
              }
            }

            // 字符串格式需要解析
            if (typeof response.data.data === 'string') {
              return parseDeepSeekResponseString(response.data.data)
            }
          }
        }

        // 标准处理流程(非DeepSeek或上述处理失败)
        let analysis = ''

        if (response?.data?.success === true) {
          if (typeof response.data.data === 'string') {
            analysis = response.data.data
          } else if (typeof response.data.data === 'object') {
            if (response.data.data.analysis) {
              analysis = response.data.data.analysis
            } else {
              analysis = JSON.stringify(response.data.data)
            }
          } else {
            analysis = JSON.stringify(response.data)
          }
        } else {
          if (response?.data?.data) {
            analysis = typeof response.data.data === 'string'
              ? response.data.data
              : JSON.stringify(response.data.data)
          } else if (response?.data?.message) {
            analysis = response.data.message
          } else {
            analysis = JSON.stringify(response.data || {})
          }
        }

        return !analysis || analysis === 'undefined' || analysis === 'null'
          ? '无法获取分析结果，请重试'
          : analysis
      } catch (error) {
        console.error('处理AI分析响应出错:', error)
        return '处理分析结果时出错: ' + error.message
      }
    }

    // 解析DeepSeek响应字符串的辅助函数
    const parseDeepSeekResponseString = (responseStr) => {
      try {
        // 1. 尝试直接解析
        try {
          const directParsed = JSON.parse(responseStr)
          if (directParsed.reasoning && directParsed.analysis) {
            return {
              reasoning: directParsed.reasoning,
              analysis: directParsed.analysis
            }
          }
        } catch (e) {
          // 直接解析失败，继续下一步
        }

        // 2. 处理带转义的情况
        let processedStr = responseStr

        // 去除可能的外层引号
        if (processedStr.startsWith('"') && processedStr.endsWith('"')) {
          processedStr = processedStr.substring(1, processedStr.length - 1)
        }

        // 替换转义字符
        processedStr = processedStr.replace(/\\"/g, '"')
        processedStr = processedStr.replace(/\\n/g, '\n')
        processedStr = processedStr.replace(/\\\\/g, '\\')

        // 再次尝试解析
        try {
          const parsedData = JSON.parse(processedStr)
          if (parsedData.reasoning && parsedData.analysis) {
            return {
              reasoning: parsedData.reasoning,
              analysis: parsedData.analysis
            }
          }
        } catch (e) {
          // 处理转义后解析仍失败
          console.warn('处理转义后解析仍失败:', e)
        }

        // 3. 如果所有解析尝试都失败，返回原字符串
        return responseStr
      } catch (error) {
        console.error('解析DeepSeek响应字符串失败:', error)
        return responseStr
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
        // 记录复制输入样例埋点
        analytics.trackClick('copy_example_input', '', {
          problem_id: route.params.id
        })
      } catch (error) {
        ElMessage.error('复制失败')
      }
    }

    const copyExampleOutput = async (output) => {
      try {
        await navigator.clipboard.writeText(output)
        ElMessage.success('输出样例已复制到剪贴板')
        // 记录复制输出样例埋点
        analytics.trackClick('copy_example_output', '', {
          problem_id: route.params.id
        })
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
        impl.highlightedCode = highlightCode(impl.code, selectedLanguage.value)
        return impl
      })
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
      { name: 'Java', code: 'Java' }
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

      // 添加: 显示提交详情后，应用代码高亮
      nextTick(() => {
        Prism.highlightAll()
      })
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
        
        // 记录分页操作埋点
        analytics.trackPagination('submissions', currentPage.value, {
          problem_id: route.params.id,
          total_pages: totalPages.value
        })
      }
    }

    const prevPage = () => {
      if (currentPage.value > 1) {
        currentPage.value--
        
        // 记录分页操作埋点
        analytics.trackPagination('submissions', currentPage.value, {
          problem_id: route.params.id,
          total_pages: totalPages.value
        })
      }
    }

    // 处理代码输入
    const handleCodeInput = (e) => {
      code.value = e.target.value
      // 确保使用正确的语言进行高亮
      highlightedCode.value = highlightCode(code.value, selectedLanguageForCode.value || 'c')
      updateCursorPosition(e)
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
        highlightedCode.value = highlightCode(code.value, selectedLanguageForCode.value || 'c')

        // 确保编辑器容器高度足够
        const codeContent = document.querySelector('.code-content')
        const textarea = document.querySelector('.p-inputtextarea')
        if (codeContent && textarea) {
          codeContent.style.height = `${Math.max(500, textarea.scrollHeight)}px`
        }
      })
    })

    const onLanguageChange = (lang) => {
      selectedLanguage.value = lang
      hasUserSelectedLanguage.value = true // 用户手动选择语言时设置标记
      
      // 记录语言选择埋点
      analytics.trackFilter('language_select', lang, {
        problem_id: route.params.id,
        context: 'solution'
      })
      
      // 选择语言后进行代码高亮
      if (code.value) {
        highlightedCode.value = highlightCode(code.value, lang)
      }
    }

    const showCursor = () => {
      isCursorVisible.value = true // 点击时显示光标
      setTimeout(() => {
        isCursorVisible.value = false // 一段时间后隐藏光标
      }, 2000) // 2秒后隐藏光标
    }

    const runCode = async () => {
      if (!code.value.trim()) {
        ElMessage.warning('请先输入代码')
        return
      }

      isRunning.value = true
      runStatus.value = ''
      consoleOutput.value = ''
      compilerOutput.value = '' // 清空编译器输出
      isConsoleCollapsed.value = false // 确保控制台展开
      
      // 记录运行代码埋点
      analytics.trackClick('run_code', '', {
        problem_id: route.params.id,
        language: selectedLanguageForCode.value,
        code_length: code.value.length
      })

      try {
        const userInfoStr = localStorage.getItem('userInfo')
        const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
        const accessToken = userInfo?.accessToken || localStorage.getItem('accessToken')

        if (!accessToken) {
          ElMessage.error('请先登录')
          return
        }

        const response = await apiService.post(
          `judge/problems/${route.params.id}/run`,
          {
            code: code.value,
            language: selectedLanguageForCode.value,
            input: customInput.value
          },
          {
            headers: { Authorization: `Bearer ${accessToken}` }
          }
        )

        // 检查是否存在编译警告或错误
        const hasCompilerIssues = response.data.compilerOutput &&
          (response.data.compilerOutput.includes('warning') ||
          response.data.compilerOutput.includes('error'))

        if (hasCompilerIssues) {
          compilerOutput.value = response.data.compilerOutput
          isConsoleCollapsed.value = false // 展开编译器输出
        }

        if (response.success) {
          runStatus.value = 'success'
          if (response.data.output) {
            consoleOutput.value = response.data.output
          } else {
            consoleOutput.value = '程序运行成功，但没有输出。'
          }
        } else {
          runStatus.value = 'error'
          consoleOutput.value = response.data.error || '程序运行失败'
          ElMessage.error('运行失败: ' + response.message)
        }
      } catch (error) {
        console.error('运行代码失败:', error)
        runStatus.value = 'error'
        consoleOutput.value = error.response?.data?.message || '运行失败，请稍后重试'

        ElMessage({
          message: '该代码存在语法错误,无法正常编译,已跳转到编译器输出,根据输出检查代码存在的问题',
          type: 'error',
          duration: 3000
        })
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
      
      // 记录提交代码埋点
      analytics.trackClick('submit_code', '', {
        problem_id: route.params.id,
        language: selectedLanguageForCode.value,
        code_length: code.value.length
      })

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

        const response = await apiService.post(
          `judge/problems/${route.params.id}/submit`,
          {
            code: code.value,
            language: selectedLanguageForCode.value
          },
          {
            headers: { Authorization: `Bearer ${accessToken}` }
          }
        )

        if (response.success) {
          ElMessage.success('提交成功')
          // 更新提交记录
          fetchSubmissions()
          // 切换到提交记录标签
          activeTab.value = 'submissions'

          // 添加: 提交代码后，对页面中的代码块重新应用语法高亮
          nextTick(() => {
            Prism.highlightAll()
          })
        } else {
          ElMessage.error(response.message || '提交失败')
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

    // 在 setup 中添加
    const progressWidth = ref(0)
    const progressBackground = ref('linear-gradient(90deg, #4facfe 0%, #00f2fe 100%)')
    const loadingStage = ref('')
    // 在 methods 中添加
    const startProgressAnimation = (model) => {
      let duration
      let stages
      switch (model) {
        case 'glm-4-flash':
          duration = 7000 // 7秒
          stages = [
            { stage: '正在初始化智谱GLM-4-FLASH引擎...', progress: 20 },
            { stage: '正在分析代码结构...', progress: 40 },
            { stage: '正在评估代码质量...', progress: 60 },
            { stage: '正在生成优化建议...', progress: 80 },
            { stage: '正在完善分析报告...', progress: 95 }
          ]
          break
        case 'deepseek-chat':
          duration = 35000 // 35秒
          stages = [
            { stage: '正在初始化DeepSeek-V3引擎...', progress: 20 },
            { stage: '正在深入分析代码...', progress: 40 },
            { stage: '正在评估代码性能...', progress: 60 },
            { stage: '正在优化分析结果...', progress: 80 },
            { stage: '正在生成详细报告...', progress: 95 }
          ]
          break
        case 'deepseek-reasoner':
          duration = 50000 // 50秒
          stages = [
            { stage: '正在初始化DeepSeek-R1引擎...', progress: 15 },
            { stage: '正在进行深度推理...', progress: 30 },
            { stage: '正在分析代码逻辑...', progress: 45 },
            { stage: '正在评估实现方案...', progress: 60 },
            { stage: '正在进行性能分析...', progress: 75 },
            { stage: '正在生成详细分析...', progress: 85 },
            { stage: '正在完善推理报告...', progress: 95 }
          ]
          break
      }

      progressWidth.value = 0
      let currentStageIndex = 0

      const updateProgress = () => {
        if (currentStageIndex < stages.length) {
          const { stage, progress } = stages[currentStageIndex]
          loadingStage.value = stage
          const progressInterval = setInterval(() => {
            if (progressWidth.value < progress) {
              progressWidth.value++
            } else {
              clearInterval(progressInterval)
              currentStageIndex++
              updateProgress()
            }
          }, duration / 100)
        }
      }

      updateProgress()
    }

    // 在 getAiAnalysis 方法中调用
    const getAiAnalysis = async () => {
      isAnalyzing.value = true
      startProgressAnimation(selectedAiModel.value)
      
      // 记录AI分析埋点
      analytics.trackClick('ai_analyze', selectedAiModel.value, {
        problem_id: route.params.id,
        language: selectedLanguageForCode.value,
        code_length: code.value.length,
        ai_model: selectedAiModel.value
      })
      
      try {
        // 改进获取token的方式，确保能找到正确的token
        let accessToken = null

        // 尝试各种可能的token存储位置
        const possibleTokens = []

        // 从userInfo中获取
        const userInfoStr = localStorage.getItem('userInfo')
        if (userInfoStr) {
          try {
            const userInfo = JSON.parse(userInfoStr)
            if (userInfo.accessToken) possibleTokens.push(userInfo.accessToken)
            if (userInfo.token) possibleTokens.push(userInfo.token)
          } catch (e) {
            console.error('解析userInfo失败:', e)
          }
        }

        // 直接从localStorage和sessionStorage获取
        const localStorageToken = localStorage.getItem('accessToken')
        const localStorageSimpleToken = localStorage.getItem('token')
        const sessionStorageToken = sessionStorage.getItem('accessToken')
        const sessionStorageSimpleToken = sessionStorage.getItem('token')

        if (localStorageToken) possibleTokens.push(localStorageToken)
        if (localStorageSimpleToken) possibleTokens.push(localStorageSimpleToken)
        if (sessionStorageToken) possibleTokens.push(sessionStorageToken)
        if (sessionStorageSimpleToken) possibleTokens.push(sessionStorageSimpleToken)

        // 使用第一个可用的token
        accessToken = possibleTokens.find(token => token) || ''

        if (!accessToken) {
          isAnalyzing.value = false
          ElMessage.error('请先登录')
          return
        }

        // 立即切换到左侧AI分析标签页
        activeTab.value = 'aiAnalysis'

        console.log('【调试】准备调用AI分析API - 选择的模型:', selectedAiModel.value)

        // 构建请求参数
        const params = {
          code: code.value,
          language: selectedLanguageForCode.value,
          problemId: route.params.id,
          model: selectedAiModel.value
        }

        console.log('【调试】发送的请求参数:', JSON.stringify(params))

        // 调用API进行代码分析
        const response = await apiService.post(
          'ai/analyze-code',
          params,
          {
            headers: { Authorization: `Bearer ${accessToken}` }
          }
        )

        console.log('【调试】收到AI分析原始响应:', JSON.stringify(response))

        // 根据不同模型处理响应
        if (selectedAiModel.value === 'deepseek-reasoner') {
          console.log('【调试】处理DeepSeek-R1响应')
          console.log('【调试】完整响应数据:', JSON.stringify(response.data))

          // 尝试直接从顶层获取reasoning和analysis
          if (response.data && response.data.reasoning && response.data.analysis) {
            console.log('【调试】检测到顶层reasoning和analysis结构')
            aiAnalysisResult.value = response.data
          }
          // 检查是否有data.data结构
          else if (response.data && response.data.success === true && response.data.data) {
            console.log('【调试】检测到data.data结构, 类型:', typeof response.data.data)
            // 如果data是对象且包含reasoning和analysis
            if (typeof response.data.data === 'object' &&
                response.data.data.reasoning && response.data.data.analysis) {
              console.log('【调试】从data.data对象中提取reasoning/analysis')
              aiAnalysisResult.value = response.data.data
            }
            // 处理data是字符串的情况
            else if (typeof response.data.data === 'string') {
              try {
                // 尝试解析字符串为JSON
                const parsedData = JSON.parse(response.data.data)
                console.log('【调试】成功将data.data解析为JSON对象:', Object.keys(parsedData))
                // 检查解析的数据是否包含reasoning/analysis
                if (parsedData.reasoning || parsedData.analysis) {
                  aiAnalysisResult.value = parsedData
                } else {
                  aiAnalysisResult.value = response.data
                }
              } catch (e) {
                // 如果不是JSON格式，直接作为字符串处理
                console.log('【调试】data.data不是JSON格式，作为字符串处理')
                aiAnalysisResult.value = response.data.data
              }
            } else {
              // 如果data结构不符合预期，使用原始响应
              aiAnalysisResult.value = response.data
            }
          }
          // 直接使用外层数据
          else {
            console.log('【调试】未检测到预期结构，使用原始响应数据')
            aiAnalysisResult.value = response.data
          }

          console.log('【调试】最终设置的aiAnalysisResult值类型:', typeof aiAnalysisResult.value)
          if (typeof aiAnalysisResult.value === 'object') {
            console.log('【调试】最终设置的aiAnalysisResult键值:', Object.keys(aiAnalysisResult.value))
          } else {
            console.log('【调试】最终设置的aiAnalysisResult (字符串):', aiAnalysisResult.value.substring(0, 50) + '...')
          }
        } else {
          // 其他模型的标准处理
          aiAnalysisResult.value = processAiAnalysisResponse(response)
        }

        ElMessage.success('代码分析完成')
      } catch (error) {
        console.error('【调试】AI分析失败:', error)

        // 添加更详细的错误处理
        if (error.response) {
          console.error('【调试】响应状态:', error.response.status)
          console.error('【调试】响应数据:', error.response.data)

          if (error.response.status === 401) {
            ElMessage.error('登录已过期，请重新登录')
          } else {
            ElMessage.error(error.response.data?.message || 'AI分析失败，请稍后重试')
          }
        } else {
          ElMessage.error('AI分析失败，请稍后重试')
        }

        // 设置一个错误标识，以便在UI中显示
        aiAnalysisResult.value = { error: true, message: error.message || '分析失败' }
      } finally {
        isAnalyzing.value = false
        progressWidth.value = 0
        loadingStage.value = ''
      }
    }

    // 在script部分完全替换代码高亮函数
    const highlightInlineCode = (text) => {
      if (!text) return ''

      // 配置marked
      marked.setOptions({
        highlight (code, lang) {
          try {
            let langKey = lang ? lang.toLowerCase() : (selectedLanguageForCode.value || 'c').toLowerCase()
            const langMap = {
              'c++': 'cpp',
              'c#': 'csharp',
              js: 'javascript',
              py: 'python'
            }
            if (langMap[langKey]) {
              langKey = langMap[langKey]
            }
            if (!Prism.languages[langKey]) {
              langKey = 'c'
            }
            return Prism.highlight(code, Prism.languages[langKey], langKey)
          } catch (err) {
            console.error('代码高亮失败:', err)
            return code
          }
        },
        breaks: true,
        gfm: true,
        headerIds: false,
        mangle: false
      })

      // 处理内联代码
      const processedText = text.replace(/`([^`]+)`/g, (match, code) => {
        try {
          if (code.trim().match(/^[a-zA-Z0-9_]+$/)) {
            const keyword = code.trim()
            return `<code class="inline-code" style="background: rgba(40, 44, 52, 0.5); padding: 2px 6px; border-radius: 4px; font-family: 'JetBrains Mono', monospace; font-size: 0.9em;">${keyword}</code>`
          }
          return match
        } catch (error) {
          console.error('内联代码处理失败:', error)
          return match
        }
      })

      // 渲染Markdown
      try {
        const html = marked(processedText)
        return `<div class="markdown-content">${html}</div>`
      } catch (error) {
        console.error('Markdown渲染失败:', error)
        return text
      }
    }

    // 处理AI分析结果
    const handleAiAnalysis = async () => {
      try {
        isAnalyzing.value = true

        // 获取accessToken
        const userInfoStr = localStorage.getItem('userInfo')
        const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
        const accessToken = userInfo?.accessToken || localStorage.getItem('accessToken')

        if (!accessToken) {
          ElMessage.error('请先登录')
          return
        }

        const response = await analyzeCode({
          code: editor.value.getValue(),
          language: selectedLanguageForCode.value,
          problemId: route.params.id
        }, accessToken) // 传递accessToken到analyzeCode函数

        console.log('handleAiAnalysis - 收到analyzeCode响应')

        // 立即切换到左侧AI分析标签页
        activeTab.value = 'aiAnalysis'

        // 使用统一的处理函数处理AI分析结果
        aiAnalysisResult.value = processAiAnalysisResponse(response)

        ElMessage.success('代码分析完成')
      } catch (error) {
        console.error('AI分析失败:', error)
        ElMessage.error('AI分析失败：' + (error.message || '未知错误'))
      } finally {
        isAnalyzing.value = false
      }
    }

    // 监听筛选条件变化，重置分页
    watch(filters, (newFilters) => {
      currentPage.value = 1
      
      // 记录筛选操作埋点
      analytics.trackFilter('submission_filter', JSON.stringify(newFilters), {
        problem_id: route.params.id,
        status: newFilters.status,
        language: newFilters.language
      })
    }, { deep: true })

    // 代码高亮函数
    const highlightCode = (code, language) => {
      if (!code) return ''
      try {
        // 标准化语言标识符
        let langKey = language.toLowerCase()

        // 处理特殊情况，如C++转换为cpp
        const langMap = {
          'c++': 'cpp',
          'c#': 'csharp',
          js: 'javascript',
          py: 'python'
        }

        if (langMap[langKey]) {
          langKey = langMap[langKey]
        }

        // 确保Prism中有此语言的定义
        if (!Prism.languages[langKey]) {
          console.warn(`Prism不支持语言: ${langKey}, 将使用默认高亮`)
          langKey = 'c' // 默认使用C语言高亮
        }

        return Prism.highlight(code, Prism.languages[langKey], langKey)
      } catch (err) {
        console.error('代码高亮失败:', err)
        return code
      }
    }

    // 添加 getStatusClass 函数
    const getStatusClass = (status) => {
      const statusClassMap = {
        Accepted: 'status-accepted',
        'Wrong Answer': 'status-wrong',
        'Runtime Error': 'status-error',
        'Time Limit Exceeded': 'status-timeout',
        'Memory Limit Exceeded': 'status-memory',
        'Compile Error': 'status-compile-error',
        Pending: 'status-pending',
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

        const response = await getProblemExamples(route.params.id)
        console.log('获取到题目样例原始响应:', response) // 添加调试日志
        // 检查响应格式并正确处理
        if (Array.isArray(response)) {
          problemExamples.value = response
          console.log('样例数据已更新, 数量:', response.length)
        } else if (response && Array.isArray(response.data)) {
          // 如果响应是一个对象且包含data数组属性
          problemExamples.value = response.data
          console.log('从response.data获取样例数据, 数量:', response.data.length)
        } else {
          console.error('获取的样例数据格式不正确:', response)
          ElMessage.error('样例数据格式不正确')
        }
      } catch (error) {
        console.error('获取题目样例失败:', error)
        ElMessage.error('获取题目样例失败')
      }
    }

    // 显示编译成功的提示
    const showCompileSuccess = () => {
      ElMessage.success('编译成功，控制台已输出结果')
    }

    // 处理后端返回的结果
    const handleBackendResponse = (response) => {
      console.log('后端响应:', response) // 打印响应以确认
      if (response.success) { // 检查 success 字段
        showCompileSuccess() // 调用弹窗提示
      } else {
        console.log('编译未成功，状态:', response) // 打印状态以确认
      }
    }

    // 获取语言的标准化类名
    const getLanguageClass = (language) => {
      if (!language) return 'language-c'

      let langKey = language.toLowerCase()

      // 处理特殊情况，如C++转换为cpp
      const langMap = {
        'c++': 'cpp',
        'c#': 'csharp',
        js: 'javascript',
        py: 'python'
      }

      if (langMap[langKey]) {
        langKey = langMap[langKey]
      }

      return `language-${langKey}`
    }

    // 行号相关方法
    const updateLineNumbers = () => {
      nextTick(() => {
        // 如果需要其他操作，可以在这里添加
      })
    }

    // 同步滚动
    const syncScroll = (e) => {
      const lineNumbers = document.querySelector('.line-numbers')
      if (lineNumbers) {
        lineNumbers.scrollTop = e.target.scrollTop
      }
    }

    const selectedAiModel = ref('deepseek-reasoner') // 默认选择DeepSeek-R1
    const isReasoningExpanded = ref(true) // 控制思考过程面板的展开状态
    // 获取当前选择的AI模型名称
    const getAiName = () => {
      const aiModelMap = {
        'deepseek-chat': 'DeepSeek-V3',
        'deepseek-reasoner': 'DeepSeek-R1',
        'glm-4-flash': '智谱GLM-4-FLASH'
      }
      return aiModelMap[selectedAiModel.value] || 'AI'
    }

    // 添加 hasActualAnalysisContent 函数
    const hasActualAnalysisContent = (result) => {
      // 检查是否为空值
      if (!result) return false

      // 检查字符串类型
      if (typeof result === 'string') {
        return result.trim().length > 0
      }

      // 检查对象类型
      if (typeof result === 'object') {
        // 检查特定的DeepSeek内容属性
        if (result.reasoning || result.reasoning_content || result.analysis || result.content) {
          return true
        }

        // 检查message结构
        if (result.message && result.message.content) {
          return true
        }

        // 检查是否是空的初始化对象
        if (Array.isArray(result.errors) && result.errors.length === 0 &&
            Array.isArray(result.improvements) && result.improvements.length === 0 &&
            result.performance === null &&
            result.rawAnalysis === null) {
          return false
        }

        // 检查其他可能有内容的属性
        for (const key in result) {
          const value = result[key]
          if (value && ((typeof value === 'string' && value.trim().length > 0) ||
              (typeof value === 'object' && Object.keys(value).length > 0 && !Array.isArray(value)))) {
            return true
          }
        }
      }

      return false
    }

    // 创建 markdown-it 实例并配置语法高亮
    const md = new MarkdownIt({
      html: true,
      linkify: true,
      typographer: true,
      highlight: function (str, lang) {
        if (lang && hljs.getLanguage(lang)) {
          try {
            return `<pre class="hljs"><code>${hljs.highlight(str, { language: lang, ignoreIllegals: true }).value}</code></pre>`
          } catch (__) {}
        }
        return `<pre class="hljs"><code>${md.utils.escapeHtml(str)}</code></pre>`
      }
    })

    // 渲染Markdown
    const renderMarkdown = (content) => {
      if (!content) return ''

      // 处理转义字符问题 - 将字符串中的转义序列转换为实际字符
      let processedContent = content

      // 先检查内容是否为字符串
      if (typeof processedContent === 'string') {
        // 去除首尾的双引号（针对deepseek-chat和智谱GLM-4-FLASH返回格式）
        if (processedContent.startsWith('"') && processedContent.endsWith('"')) {
          processedContent = processedContent.substring(1, processedContent.length - 1)
        }

        // 处理常见的转义序列
        processedContent = processedContent.replace(/\\n/g, '\n')
        processedContent = processedContent.replace(/\\t/g, '\t')
        processedContent = processedContent.replace(/\\r/g, '\r')
        processedContent = processedContent.replace(/\\"/g, '"')
        processedContent = processedContent.replace(/\\'/g, "'")
        processedContent = processedContent.replace(/\\\\/g, '\\')

        // 替换Unicode转义序列，如\u0000
        processedContent = processedContent.replace(/\\u([0-9a-fA-F]{4})/g, (match, code) => {
          return String.fromCharCode(parseInt(code, 16))
        })

        // 查看是否是JSON字符串，如果是则解析
        if (processedContent.trim().startsWith('{') && processedContent.trim().endsWith('}')) {
          try {
            // 尝试解析JSON
            const parsed = JSON.parse(processedContent)
            if (parsed && typeof parsed === 'object') {
              // 如果成功解析，使用其中的文本内容，通常是某个字段
              if (parsed.text) {
                processedContent = parsed.text
              } else if (parsed.content) {
                processedContent = parsed.content
              }
            }
          } catch (e) {
            // 解析失败，继续使用原始内容
            console.error('JSON解析失败', e)
          }
        }
      }

      return md ? md.render(processedContent) : ''
    }

    const toggleReasoning = () => {
      isReasoningExpanded.value = !isReasoningExpanded.value
    }

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
      getLanguageClass,
      updateLineNumbers,
      syncScroll,
      selectedAiModel,
      isReasoningExpanded,
      getAiName,
      hasActualAnalysisContent,
      renderMarkdown,
      progressWidth,
      progressBackground,
      loadingStage,
      toggleReasoning
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
  align-items: center;
  gap: 12px;
  margin-bottom: 8px;
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
  color: #e6edf3;
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
  -webkit-text-fill-color: transparent;
  filter: drop-shadow(0 0 10px rgba(124, 77, 255, 0.3));
}

.empty-state span {
  font-size: 14px;
  font-weight: 500;
  background: linear-gradient(90deg, #a6accd, #6c7086);
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

.status-tag {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
  display: inline-block;
}

.status-tag.accepted {
  background-color: #4ecdc4;
  color: white;
}

.analysis-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
  background-color: #1e1e2e;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.ai-brain-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.brain-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.brain-icon {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.connections {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.connections span {
  width: 10px;
  height: 10px;
  background-color: #4ecdc4;
  border-radius: 50%;
  margin: 0 5px;
}

.brain-svg {
  width: 100px;
  height: 100px;
}

.loading-text {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-top: 10px;
  color: #a6accd;
}

.text {
  font-size: 14px;
  margin-bottom: 5px;
}

.dots {
  display: flex;
  justify-content: space-between;
  width: 30px;
}

.dot {
  width: 6px;
  height: 6px;
  background-color: #a6accd;
  border-radius: 50%;
  animation: blink 1s infinite;
}

@keyframes blink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0; }
}

/* 增强AI分析加载动画效果 */
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 300px;
  width: 100%;
}

.ai-brain-loading {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 150px;
  height: 150px;
}

.brain-container {
  position: relative;
  width: 120px;
  height: 120px;
  animation: pulse 2s ease-in-out infinite;
}

.brain-icon {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.connections {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  z-index: 1;
}

.connections span {
  position: absolute;
  width: 4px;
  height: 4px;
  background-color: #4ecdc4;
  border-radius: 50%;
  box-shadow: 0 0 8px rgba(78, 205, 196, 0.8);
}

.connections span:nth-child(1) {
  top: 10%;
  left: 20%;
  animation: connect 3s ease-in-out infinite, glow 2s ease-in-out infinite;
}

.connections span:nth-child(2) {
  top: 20%;
  right: 15%;
  animation: connect 2.5s ease-in-out infinite, glow 1.8s ease-in-out infinite;
  animation-delay: 0.3s;
}

.connections span:nth-child(3) {
  bottom: 30%;
  left: 15%;
  animation: connect 2.8s ease-in-out infinite, glow 1.5s ease-in-out infinite;
  animation-delay: 0.5s;
}

.connections span:nth-child(4) {
  bottom: 20%;
  right: 20%;
  animation: connect 3.2s ease-in-out infinite, glow 2.2s ease-in-out infinite;
  animation-delay: 0.7s;
}

.connections span:nth-child(5) {
  top: 40%;
  left: 10%;
  animation: connect 2.6s ease-in-out infinite, glow 1.7s ease-in-out infinite;
  animation-delay: 0.2s;
}

.connections span:nth-child(6) {
  top: 35%;
  right: 10%;
  animation: connect 2.9s ease-in-out infinite, glow 1.9s ease-in-out infinite;
  animation-delay: 0.4s;
}

.connections span:nth-child(7) {
  bottom: 40%;
  left: 25%;
  animation: connect 3.1s ease-in-out infinite, glow 2.1s ease-in-out infinite;
  animation-delay: 0.6s;
}

.connections span:nth-child(8) {
  bottom: 35%;
  right: 25%;
  animation: connect 2.7s ease-in-out infinite, glow 2s ease-in-out infinite;
  animation-delay: 0.8s;
}

.brain-svg {
  width: 100px;
  height: 100px;
  z-index: 2;
  position: relative;
  fill: #7c4dff;
  opacity: 0.8;
  filter: drop-shadow(0 0 8px rgba(124, 77, 255, 0.6));
  animation: colorShift 4s ease-in-out infinite;
}

.loading-text {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-top: 30px;
}

.text {
  font-size: 18px;
  font-weight: 500;
  color: #e6edf3;
  margin-bottom: 10px;
  letter-spacing: 0.5px;
  animation: fadeInOut 2s ease-in-out infinite;
}

.dots {
  display: flex;
  justify-content: space-between;
  width: 40px;
}

.dot {
  width: 8px;
  height: 8px;
  background-color: #4ecdc4;
  border-radius: 50%;
  box-shadow: 0 0 6px rgba(78, 205, 196, 0.6);
}

.dots .dot:nth-child(1) {
  animation: bounce 1.4s ease-in-out infinite;
}

.dots .dot:nth-child(2) {
  animation: bounce 1.4s ease-in-out infinite;
  animation-delay: 0.2s;
}

.dots .dot:nth-child(3) {
  animation: bounce 1.4s ease-in-out infinite;
  animation-delay: 0.4s;
}

@keyframes connect {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.5);
  }
}

@keyframes glow {
  0%, 100% {
    box-shadow: 0 0 5px rgba(78, 205, 196, 0.6);
    background-color: rgba(78, 205, 196, 0.8);
  }
  50% {
    box-shadow: 0 0 12px rgba(78, 205, 196, 1);
    background-color: rgba(78, 205, 196, 1);
  }
}

@keyframes pulse {
  0%, 100% {
    transform: scale(0.95);
  }
  50% {
    transform: scale(1.05);
  }
}

@keyframes colorShift {
  0%, 100% {
    fill: #7c4dff;
    filter: drop-shadow(0 0 8px rgba(124, 77, 255, 0.6));
  }
  33% {
    fill: #4ecdc4;
    filter: drop-shadow(0 0 8px rgba(78, 205, 196, 0.6));
  }
  66% {
    fill: #7c4dff;
    filter: drop-shadow(0 0 8px rgba(124, 77, 255, 0.6));
  }
}

@keyframes fadeInOut {
  0%, 100% {
    opacity: 0.7;
  }
  50% {
    opacity: 1;
  }
}

@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-8px);
  }
}

/* 输入框行号样式 */
.input-with-line-numbers {
  display: flex;
  position: relative;
  width: 100%;
  height: 100%;
  min-height: 220px;
  background-color: #282836;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.line-numbers {
  padding: 12px 10px;
  background: #1e1e2e;
  border-right: 1px solid rgba(255, 255, 255, 0.1);
  color: #7c7c9c;
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
  text-align: right;
  user-select: none;
  overflow: hidden;
  min-width: 40px;
}

.line-number {
  line-height: 1.6;
  padding: 0 4px;
}

.custom-input-textarea {
  flex: 1;
  height: 100%;
  min-height: 220px;
  background-color: #282836;
  border: none;
  border-radius: 0;
  color: #e6edf3;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.6;
  resize: none;
  padding: 12px;
  box-sizing: border-box;
}

.custom-input-textarea:focus {
  outline: none;
  border: none;
  box-shadow: none !important;
}

/* 添加脉冲动画效果 */
@keyframes pulse {
  0% {
    transform: scale(0.95);
    opacity: 0.7;
  }
  50% {
    transform: scale(1.05);
    opacity: 1;
  }
  100% {
    transform: scale(0.95);
    opacity: 0.7;
  }
}

.submission-header {
  padding: 20px;
  background-color: #2d2d3f;
  display: flex;
  flex-direction: column;
  gap: 16px;
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

/* Markdown内容样式 */
:deep(.markdown-content) {
  color: #e6edf3;
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.6;
}

:deep(.markdown-content h1),
:deep(.markdown-content h2),
:deep(.markdown-content h3),
:deep(.markdown-content h4),
:deep(.markdown-content h5),
:deep(.markdown-content h6) {
  color: #e6edf3;
  margin-top: 24px;
  margin-bottom: 16px;
  font-weight: 600;
  line-height: 1.25;
}

:deep(.markdown-content h1) {
  font-size: 1.5em;
  margin-top: 0;
  padding-bottom: 0.3em;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

:deep(.markdown-content h2) {
  font-size: 1.3em;
  padding-bottom: 0.3em;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

:deep(.markdown-content h3) {
  font-size: 1.1em;
}

:deep(.markdown-content ul),
:deep(.markdown-content ol) {
  padding-left: 2em;
  margin-bottom: 16px;
}

:deep(.markdown-content li) {
  margin-bottom: 0.2em;
}

:deep(.markdown-content p) {
  margin-bottom: 16px;
}

:deep(.markdown-content pre) {
  background: #1e1e2e;
  border-radius: 6px;
  padding: 16px;
  overflow: auto;
  margin-bottom: 16px;
  font-family: 'JetBrains Mono', monospace;
}

:deep(.markdown-content code) {
  font-family: 'JetBrains Mono', monospace;
  padding: 0.2em 0.4em;
  margin: 0;
  font-size: 85%;
  background-color: rgba(110, 118, 129, 0.15);
  border-radius: 3px;
}

:deep(.markdown-content pre code) {
  background-color: transparent;
  padding: 0;
  margin: 0;
  font-size: 100%;
  word-break: normal;
  white-space: pre;
  overflow: auto;
}

:deep(.markdown-content blockquote) {
  padding: 0 1em;
  color: #8b949e;
  border-left: 0.25em solid #30363d;
  margin-bottom: 16px;
}

:deep(.markdown-content hr) {
  height: 0.25em;
  padding: 0;
  margin: 24px 0;
  background-color: #30363d;
  border: 0;
}

:deep(.markdown-content table) {
  width: 100%;
  margin-bottom: 16px;
  border-spacing: 0;
  border-collapse: collapse;
}

:deep(.markdown-content table th),
:deep(.markdown-content table td) {
  padding: 6px 13px;
  border: 1px solid #30363d;
}

:deep(.markdown-content table tr) {
  background-color: #1e1e2e;
  border-top: 1px solid #30363d;
}

:deep(.markdown-content table tr:nth-child(2n)) {
  background-color: #22222f;
}

.output-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
  flex: 1;
}

.deepseek-reasoner-container {
  background: rgba(40, 44, 52, 0.5);
  border: 1px solid rgba(78, 205, 255, 0.15);
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 16px;
}

.result-block {
  margin-bottom: 16px;
}

.result-block:last-child {
  margin-bottom: 0;
}

.result-title {
  color: #4facfe;
  font-weight: 500;
  margin-bottom: 8px;
  font-size: 14px;
  border-left: 3px solid #4facfe;
  padding-left: 8px;
}

/* Markdown 内容样式 */
.markdown-content {
  font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.6;
  color: #e6edf3 !important;

  a {
    color: #58a6ff !important;
    text-decoration: underline;
    &:hover {
      color: #79c0ff !important;
    }
  }

  pre {
    margin: 16px 0;
    padding: 16px;
    border-radius: 6px;
    background-color: rgba(45, 45, 45, 0.7) !important;
    overflow: auto;
  }

  /* <code> 标签样式 */
  code {
    font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
    background-color: rgba(45, 45, 45, 0.7) !important;
    color: #f78c6c !important;
    border-radius: 6px;
    padding: 0.2em 0.4em;
  }

  pre > code {
    padding: 0;
  }

  /* 段落和列表样式 */
  p, li, div, span, td, th {
    margin-bottom: 12px;
    color: #e6edf3 !important;
  }

  /* 标题样式 */
  h1, h2, h3, h4, h5, h6 {
    margin-top: 24px;
    margin-bottom: 16px;
    font-weight: 600;
    color: #ff6b6b !important;
  }

  ul, ol, blockquote {
    color: #e6edf3 !important;
  }

  /* 表格样式 */
  table {
    width: 100%;
    border-collapse: collapse;
    margin: 16px 0;

    th, td {
      border: 1px solid #30363d;
      padding: 8px 12px;
      text-align: left;
    }

    th {
      background-color: rgba(45, 45, 45, 0.7);
      font-weight: 600;
    }

    tr:nth-child(2n) {
      background-color: rgba(35, 35, 35, 0.5);
    }
  }

  /* 引用块样式 */
  blockquote {
    padding: 0 1em;
    color: #e6edf3 !important;
    border-left: 0.25em solid #30363d;
    margin: 16px 0;

    p {
      margin-bottom: 0;
    }
  }

  /* 强制所有文本元素使用白色 */
  * {
    color: #e6edf3 !important;
  }

  /* 只保留特定元素的特殊颜色 */
  a {
    color: #58a6ff !important;
  }

  .hljs-keyword, .hljs-selector-tag, .hljs-built_in, .hljs-name, .hljs-tag {
    color: #ff7b72 !important;
  }

  .hljs-string, .hljs-title, .hljs-section, .hljs-attribute, .hljs-literal, .hljs-template-tag, .hljs-template-variable, .hljs-type, .hljs-addition {
    color: #a5d6ff !important;
  }

  .hljs-comment, .hljs-quote, .hljs-deletion, .hljs-meta {
    color: #8b949e !important;
  }

  .hljs-number, .hljs-regexp, .hljs-literal, .hljs-variable, .hljs-symbol {
    color: #c792ea !important;
  }
}

.progress-container {
  width: 300px;
  height: 6px;
  background: rgba(78, 205, 255, 0.1);
  border-radius: 3px;
  margin: 15px auto;
  overflow: visible;
  position: relative;
}

.progress-bar {
  height: 100%;
  border-radius: 3px;
  transition: width 0.3s ease-in-out;
  position: relative;
  box-shadow: 0 0 10px rgba(78, 205, 255, 0.5);
}

.progress-text {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  bottom: -20px;
  color: #4facfe;
  font-size: 12px;
  text-shadow: 0 0 3px rgba(0, 0, 0, 0.5);
}

.loading-stage {
  font-size: 14px;
  color: #a6accd;
  margin-top: 10px;
  text-align: center;
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(78, 205, 255, 0.4);
  }
  70% {
    box-shadow: 0 0 0 10px rgba(78, 205, 255, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(78, 205, 255, 0);
  }
}

.result-title {
  display: flex;
  align-items: center;
  font-weight: bold;
  margin-bottom: 10px;
}

.arrow-icon {
  margin-right: 8px;
  cursor: pointer;
  transition: transform 0.3s;
}
</style>

<style lang="scss">
// ... existing code ...
</style>
