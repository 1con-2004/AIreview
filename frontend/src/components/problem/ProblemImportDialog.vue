<template>
  <div class="problem-import-dialog" v-if="visible">
    <div class="dialog-backdrop" @click="handleClose"></div>
    <div class="dialog-container">
      <div class="dialog-header">
        <h3>引用题目 - {{ problem.title }}</h3>
        <button class="close-btn" @click="handleClose">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="dialog-content">
        <div class="tabs">
          <button 
            class="tab-btn" 
            :class="{ active: activeTab === 'basic' }"
            @click="activeTab = 'basic'"
          >
            基本信息
          </button>
          <button 
            class="tab-btn" 
            :class="{ active: activeTab === 'testcase' }"
            @click="activeTab = 'testcase'"
          >
            测试用例
          </button>
          <button 
            class="tab-btn" 
            :class="{ active: activeTab === 'solution' }"
            @click="activeTab = 'solution'"
          >
            解决方案
          </button>
        </div>

        <!-- 基本信息标签页 -->
        <div class="tab-content" v-if="activeTab === 'basic'">
          <div class="form-group">
            <label>题目标题</label>
            <input 
              type="text" 
              v-model="formData.title" 
              placeholder="请输入题目标题"
              class="form-control"
            />
          </div>
          
          <div class="form-row">
            <div class="form-group half">
              <label>难度等级</label>
              <div class="difficulty-buttons">
                <button 
                  class="difficulty-btn easy" 
                  :class="{ active: formData.difficulty === '简单' }"
                  @click="formData.difficulty = '简单'"
                >
                  简单
                </button>
                <button 
                  class="difficulty-btn medium" 
                  :class="{ active: formData.difficulty === '中等' }"
                  @click="formData.difficulty = '中等'"
                >
                  中等
                </button>
                <button 
                  class="difficulty-btn hard" 
                  :class="{ active: formData.difficulty === '困难' }"
                  @click="formData.difficulty = '困难'"
                >
                  困难
                </button>
              </div>
            </div>
            
            <div class="form-group half">
              <label>题目分类</label>
              <select
                v-model="formData.category"
                class="form-control"
              >
                <option value="" disabled>请选择题目分类</option>
                <option
                  v-for="category in categories" 
                  :key="category.id" 
                  :value="category.id"
                >
                  {{ category.name }}
                </option>
              </select>
            </div>
          </div>
          
          <div class="form-group">
            <label>题目标签</label>
            <div class="tags-input">
              <div class="tags-container">
                <span 
                  v-for="(tag, index) in tags" 
                  :key="index"
                  class="tag-item"
                >
                  {{ tag }}
                  <button class="tag-remove" @click="removeTag(index)">
                    <i class="fas fa-times"></i>
                  </button>
                </span>
              </div>
              <input 
                type="text" 
                v-model="tagInput" 
                placeholder="输入标签，按回车添加"
                class="tag-control"
                @keydown.enter.prevent="addTag"
              />
            </div>
          </div>
          
          <div class="form-row">
            <div class="form-group half">
              <label>时间限制 (ms)</label>
              <input 
                type="number" 
                v-model.number="formData.time_limit" 
                placeholder="输入时间限制"
                class="form-control"
                min="1"
              />
            </div>
            
            <div class="form-group half">
              <label>内存限制 (MB)</label>
              <input 
                type="number" 
                v-model.number="formData.memory_limit" 
                placeholder="输入内存限制"
                class="form-control"
                min="1"
              />
            </div>
          </div>
          
          <div class="form-group">
            <label>题目描述</label>
            <div class="editor-container">
              <textarea 
                v-model="formData.description" 
                placeholder="请输入题目描述"
                class="form-control description-editor"
                rows="10"
              ></textarea>
            </div>
          </div>
        </div>

        <!-- 测试用例标签页 -->
        <div class="tab-content" v-if="activeTab === 'testcase'">
          <div class="testcases-container">
            <div v-for="(testcase, index) in formData.testcases" :key="index" class="testcase-item">
              <div class="testcase-header">
                <h4>测试用例 #{{ index + 1 }}</h4>
                <div class="testcase-actions">
                  <label class="checkbox-label">
                    <input type="checkbox" v-model="testcase.is_example" />
                    <span>作为示例</span>
                  </label>
                  <button class="btn-remove-testcase" @click="removeTestcase(index)">
                    <i class="fas fa-trash"></i>
                  </button>
                </div>
              </div>
              <div class="testcase-content">
                <div class="form-group">
                  <label>输入</label>
                  <textarea 
                    v-model="testcase.input" 
                    placeholder="请输入测试用例输入"
                    class="form-control"
                    rows="4"
                  ></textarea>
                </div>
                <div class="form-group">
                  <label>输出</label>
                  <textarea 
                    v-model="testcase.output" 
                    placeholder="请输入测试用例输出"
                    class="form-control"
                    rows="4"
                  ></textarea>
                </div>
              </div>
            </div>
            <div class="testcase-add">
              <button class="btn-add-testcase" @click="addTestcase">
                <i class="fas fa-plus"></i>
                添加测试用例
              </button>
            </div>
          </div>
        </div>

        <!-- 解决方案标签页 -->
        <div class="tab-content" v-if="activeTab === 'solution'">
          <div class="form-group">
            <label>解题思路</label>
            <textarea 
              v-model="formData.solution.solution_approach" 
              placeholder="请输入解题思路"
              class="form-control"
              rows="6"
            ></textarea>
          </div>
          <div class="form-row">
            <div class="form-group half">
              <label>时间复杂度</label>
              <input 
                type="text" 
                v-model="formData.solution.time_complexity" 
                placeholder="例如: O(n)"
                class="form-control"
              />
            </div>
            <div class="form-group half">
              <label>空间复杂度</label>
              <input 
                type="text" 
                v-model="formData.solution.space_complexity" 
                placeholder="例如: O(1)"
                class="form-control"
              />
            </div>
          </div>
          <div class="solution-codes">
            <div v-for="language in languages" :key="language.id" class="solution-code-item">
              <div class="solution-code-header">
                <h4>{{ language.language_name || language.name }}</h4>
              </div>
              <div class="solution-code-content">
                <div class="form-group">
                  <label>{{ language.language_name || language.name }} 代码实现</label>
                  <div class="language-tag">{{ language.language_name || language.name }}</div>
                  <textarea 
                    v-model="getSolutionCode(language.id).standard_solution" 
                    :placeholder="`请输入 ${language.language_name || language.name} 解决方案代码`"
                    class="form-control code-editor"
                    rows="10"
                  ></textarea>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="dialog-footer">
        <button class="btn-cancel" @click="handleClose">取消</button>
        <button class="btn-import" @click="handleImport">发布到题库</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, reactive, watch, defineProps, defineEmits, onMounted } from 'vue'
import axios from 'axios'

const props = defineProps({
  problem: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['close', 'import'])

const visible = ref(true)
const activeTab = ref('basic')
const tagInput = ref('')
const categories = ref([])
const languages = ref([
  { id: 1, name: 'JavaScript' },
  { id: 2, name: 'Python' },
  { id: 3, name: 'Java' },
  { id: 4, name: 'C++' }
])

// 获取语言名称
const getLanguageName = (languageId) => {
  const language = languages.value.find(lang => lang.id === languageId)
  return language ? language.name : '未知语言'
}

// 表单数据
const formData = reactive({
  id: props.problem.id,
  title: props.problem.title,
  difficulty: props.problem.difficulty,
  category: props.problem.category,
  description: props.problem.description || '',
  time_limit: props.problem.time_limit || 1000,
  memory_limit: props.problem.memory_limit || 256,
  tags: props.problem.tags || '',
  testcases: props.problem.testcases || [],  // 使用父组件传递的测试用例
  solution: {
    solution_approach: '',
    time_complexity: 'O(n)',
    space_complexity: 'O(1)',
    codes: []
  }
})

// 获取分类列表
const loadCategories = async () => {
  try {
    const response = await axios.get('/api/admin/problem-pool/categories')
    if (response.data && response.data.success) {
      categories.value = response.data.data.categories || response.data.data
      console.log('加载到的分类列表:', categories.value)
    }
  } catch (error) {
    console.error('加载分类列表失败:', error)
  }
}

// 处理标签
const tags = computed({
  get: () => {
    if (!formData.tags) return []
    return typeof formData.tags === 'string' 
      ? formData.tags.split(',').map(tag => tag.trim()).filter(tag => tag)
      : formData.tags
  },
  set: (value) => {
    formData.tags = value.join(',')
  }
})

// 添加标签
const addTag = () => {
  if (tagInput.value.trim()) {
    const newTags = [...tags.value]
    if (!newTags.includes(tagInput.value.trim())) {
      newTags.push(tagInput.value.trim())
      tags.value = newTags
    }
    tagInput.value = ''
  }
}

// 移除标签
const removeTag = (index) => {
  const newTags = [...tags.value]
  newTags.splice(index, 1)
  tags.value = newTags
}

// 添加测试用例
const addTestcase = () => {
  // 计算新测试用例的序号（如果已有测试用例，则为最大序号+1，否则为1）
  let orderNum = 1;
  if (formData.testcases.length > 0) {
    // 找出当前最大的order_num值
    const maxOrderNum = Math.max(...formData.testcases.map(tc => Number(tc.order_num) || 0));
    orderNum = maxOrderNum + 1;
  }
  
  formData.testcases.push({
    input: '',
    output: '',
    is_example: formData.testcases.length === 0, // 第一个测试用例默认为示例
    order_num: orderNum // 确保每个测试用例都有唯一的顺序编号
  });
  
  console.log(`添加新测试用例，序号: ${orderNum}，当前测试用例数: ${formData.testcases.length}`);
}

// 移除测试用例
const removeTestcase = (index) => {
  formData.testcases.splice(index, 1);
  
  // 重新排序所有测试用例的order_num
  formData.testcases.forEach((tc, idx) => {
    tc.order_num = idx + 1;
  });
  
  console.log('移除测试用例后重新排序，当前测试用例数:', formData.testcases.length);
}

// 获取或创建指定语言的解决方案代码
const getSolutionCode = (languageId) => {
  let code = formData.solution.codes.find(c => c.language_id === languageId)
  if (!code) {
    code = {
      language_id: languageId,
      standard_solution: '',
      language_name: languages.value.find(l => l.id === languageId)?.language_name || '未知语言'
    }
    formData.solution.codes.push(code)
  }
  return code
}

// 确保每种语言都有解决方案代码
const initSolutionCodes = () => {
  languages.value.forEach(lang => {
    getSolutionCode(lang.id)
  })
}

// 加载题目相关数据
const loadProblemData = async () => {
  try {
    console.log('加载题目详情:', props.problem)
    
    // 加载分类列表
    await loadCategories()
    
    // 如果题目分类是数字ID，确保使用该ID
    if (props.problem.category && !isNaN(Number(props.problem.category))) {
      formData.category = Number(props.problem.category)
      console.log('设置题目分类ID:', formData.category)
    }
    // 如果题目有分类名称但没有ID，尝试从分类列表找到对应的ID
    else if (props.problem.category_name && categories.value.length > 0) {
      const foundCategory = categories.value.find(c => c.name === props.problem.category_name)
      if (foundCategory) {
        formData.category = foundCategory.id
        console.log('通过分类名称找到分类ID:', formData.category)
      }
    }
    
    // 检查是否已有测试用例数据
    console.log('父组件传递的测试用例:', props.problem.testcases);
    
    // 如果父组件没有传递测试用例数据或者测试用例为空，则从API获取
    if (!props.problem.testcases || props.problem.testcases.length === 0) {
      if (formData.testcases.length === 0) {
        // 尝试加载测试用例数据
        try {
          // 向后端请求该题目的测试用例
          console.log('开始请求测试用例，题目ID:', props.problem.id)
          const testCasesResponse = await axios.get(`/api/admin/problem-pool/${props.problem.id}/test-cases`)
          console.log('测试用例API响应:', testCasesResponse)
          
          if (testCasesResponse.data && testCasesResponse.data.success && testCasesResponse.data.data) {
            // 转换测试用例格式以适配前端
            const testCasesData = testCasesResponse.data.data;
            console.log('原始测试用例数据:', testCasesData);
            
            if (testCasesData && testCasesData.length > 0) {
              // 确保每个测试用例都有正确的order_num值
              formData.testcases = testCasesData.map((tc, index) => {
                // 如果没有order_num或者order_num为0，则使用索引+1作为order_num
                const orderNum = tc.order_num && tc.order_num > 0 ? tc.order_num : (index + 1);
                return {
                  input: tc.input || '',
                  output: tc.output || '',
                  is_example: tc.is_example === 1 || tc.is_example === true,
                  order_num: orderNum // 确保有有效的order_num
                };
              });
              
              // 按order_num排序
              formData.testcases.sort((a, b) => a.order_num - b.order_num);
              
              console.log('处理后的测试用例:', formData.testcases);
            } else {
              console.log('测试用例数据为空，添加默认测试用例');
              addTestcase();
            }
          } else {
            console.log('没有找到测试用例数据或者数据格式不正确')
            // 如果没有测试用例数据，添加一个默认的空测试用例
            addTestcase()
          }
        } catch (err) {
          console.error('加载测试用例失败:', err)
          console.error('错误详情:', err.response ? err.response.data : '无响应')
          // 添加默认测试用例
          addTestcase()
        }
      }
    }
    
    // 加载编程语言列表
    try {
      console.log('开始请求编程语言列表')
      const languagesResponse = await axios.get('/api/admin/solution-languages')
      console.log('编程语言列表API响应:', languagesResponse)
      
      if (languagesResponse.data && languagesResponse.data.success && languagesResponse.data.data) {
        languages.value = languagesResponse.data.data.filter(lang => [1, 2, 3, 4].includes(lang.id))
        console.log('加载到的编程语言列表:', languages.value)
        
        // 确保每种语言都有解决方案代码
        initSolutionCodes()
      }
    } catch (err) {
      console.error('加载编程语言列表失败:', err)
      console.error('错误详情:', err.response ? err.response.data : '无响应')
    }
    
    // 尝试加载解决方案数据
    try {
      // 向后端请求该题目的解决方案
      console.log('开始请求解决方案，题目ID:', props.problem.id)
      const solutionResponse = await axios.get(`/api/admin/problem-pool/${props.problem.id}/solution`)
      console.log('解决方案API响应:', solutionResponse)
      
      if (solutionResponse.data && solutionResponse.data.success && solutionResponse.data.data) {
        const solutionData = solutionResponse.data.data
        // 更新解决方案信息
        formData.solution.solution_approach = solutionData.solution_approach || ''
        formData.solution.time_complexity = solutionData.time_complexity || 'O(n)'
        formData.solution.space_complexity = solutionData.space_complexity || 'O(1)'
        
        // 如果有代码数据
        if (solutionData.code && solutionData.code.length > 0) {
          // 更新每种语言的代码
          solutionData.code.forEach(c => {
            const solutionCode = getSolutionCode(c.language_id)
            solutionCode.standard_solution = c.standard_solution || ''
          })
        }
      }
    } catch (err) {
      console.error('加载解决方案失败:', err)
      console.error('错误详情:', err.response ? err.response.data : '无响应')
    }
  } catch (err) {
    console.error('加载题目数据失败:', err)
  }
}

// 关闭弹窗
const handleClose = () => {
  visible.value = false
  emit('close')
}

// 引用题目
const handleImport = async () => {
  // 确保表单数据完整
  if (!formData.title || !formData.difficulty || !formData.description) {
    alert('请填写完整的题目基本信息')
    activeTab.value = 'basic'
    return
  }
  
  if (!formData.category) {
    alert('请选择题目分类')
    activeTab.value = 'basic'
    return
  }
  
  // 确保至少有一个测试用例
  if (formData.testcases.length === 0) {
    alert('请至少添加一个测试用例')
    activeTab.value = 'testcase'
    return
  }
  
  // 确保所有语言都有解决方案代码
  const missingLanguages = []
  languages.value.forEach(lang => {
    const code = getSolutionCode(lang.id)
    if (!code.standard_solution.trim()) {
      missingLanguages.push(lang.language_name)
    }
  })
  
  if (missingLanguages.length > 0) {
    alert(`请提供以下语言的解决方案代码: ${missingLanguages.join(', ')}`)
    activeTab.value = 'solution'
    return
  }
  
  try {
    // 显示加载状态
    const loadingToast = await showLoadingToast('正在发布题目到题库...')
    
    // 将题目从题目池迁移到正式题库
    const response = await axios.post('/api/admin/problem-pool/import', {
      problem_pool_id: formData.id,
      title: formData.title,
      difficulty: formData.difficulty,
      description: formData.description,
      category: parseInt(formData.category), // 确保分类ID是整数
      tags: typeof formData.tags === 'string' ? formData.tags : formData.tags.join(','),
      time_limit: formData.time_limit,
      memory_limit: formData.memory_limit,
      test_cases: formData.testcases,
      solution: formData.solution
    })
    
    // 关闭加载状态
    loadingToast.close()
    
    if (response.data && response.data.success) {
      // 显示成功消息
      showSuccessToast('题目已成功发布到题库！')
      
      // 关闭对话框并通知父组件
      emit('import', { 
        ...formData, 
        imported: true, 
        new_problem_id: response.data.new_problem_id,
        // 通知父组件引用次数增加
        reference_count: (props.problem.reference_count || 0) + 1
      })
      handleClose()
    } else {
      // 显示错误消息
      showErrorToast(response.data?.message || '发布题目失败，请稍后再试')
    }
  } catch (error) {
    console.error('发布题目失败:', error)
    showErrorToast('发布题目失败: ' + (error.response?.data?.message || error.message || '未知错误'))
  }
}

// 显示加载中提示
const showLoadingToast = (message) => {
  return {
    close: () => {
      // 实现关闭操作
    }
  }
}

// 显示成功提示
const showSuccessToast = (message) => {
  alert(message) // 简单实现，实际项目中应使用Toast组件
}

// 显示错误提示
const showErrorToast = (message) => {
  alert('错误: ' + message) // 简单实现，实际项目中应使用Toast组件
}

// 组件挂载时加载数据
onMounted(() => {
  // 添加默认测试用例
  if (formData.testcases.length === 0) {
    addTestcase()
  }
  
  // 初始化加载分类列表
  loadCategories();
  
  // 加载题目相关数据
  loadProblemData()
})
</script>

<style scoped>
.problem-import-dialog {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.dialog-backdrop {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
}

.dialog-container {
  width: 90%;
  max-width: 800px;
  max-height: 90vh;
  background-color: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  z-index: 1001;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  animation: dialog-fade-in 0.3s ease;
}

@keyframes dialog-fade-in {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.dialog-header {
  padding: 16px 24px;
  border-bottom: 1px solid #eaeaea;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0;
}

.dialog-header h3 {
  margin: 0;
  font-size: 18px;
  color: #1d1d1f;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 680px;
}

.close-btn {
  background: none;
  border: none;
  color: #86868b;
  font-size: 16px;
  cursor: pointer;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 16px;
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.close-btn:hover {
  background-color: #f5f5f7;
  color: #1d1d1f;
}

.dialog-content {
  padding: 24px;
  overflow-y: auto;
  flex-grow: 1;
}

.tabs {
  display: flex;
  gap: 4px;
  margin-bottom: 24px;
  border-bottom: 1px solid #eaeaea;
  padding-bottom: 12px;
}

.tab-btn {
  padding: 8px 16px;
  border: none;
  background: none;
  color: #86868b;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
}

.tab-btn:hover {
  color: #1d1d1f;
}

.tab-btn.active {
  color: #007AFF;
  font-weight: 500;
}

.tab-btn.active::after {
  content: '';
  position: absolute;
  bottom: -13px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: #007AFF;
}

.tab-content {
  animation: fade-in 0.3s ease;
}

@keyframes fade-in {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.form-group {
  margin-bottom: 20px;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.form-group.half {
  flex: 1;
}

label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #1d1d1f;
  font-weight: 500;
}

.form-control {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #eaeaea;
  border-radius: 8px;
  font-size: 14px;
  color: #1d1d1f;
  background-color: white;
  transition: all 0.3s ease;
}

.form-control:focus {
  border-color: #007AFF;
  outline: none;
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2);
}

.description-editor, .code-editor {
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', 'Consolas', 'source-code-pro', monospace;
  resize: vertical;
}

.difficulty-buttons {
  display: flex;
  gap: 12px;
}

.difficulty-btn {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid;
  border-radius: 8px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.difficulty-btn.easy {
  border-color: #34C759;
  color: #34C759;
  background-color: rgba(52, 199, 89, 0.1);
}

.difficulty-btn.easy.active, .difficulty-btn.easy:hover {
  background-color: #34C759;
  color: white;
}

.difficulty-btn.medium {
  border-color: #FF9500;
  color: #FF9500;
  background-color: rgba(255, 149, 0, 0.1);
}

.difficulty-btn.medium.active, .difficulty-btn.medium:hover {
  background-color: #FF9500;
  color: white;
}

.difficulty-btn.hard {
  border-color: #FF3B30;
  color: #FF3B30;
  background-color: rgba(255, 59, 48, 0.1);
}

.difficulty-btn.hard.active, .difficulty-btn.hard:hover {
  background-color: #FF3B30;
  color: white;
}

.tags-input {
  border: 1px solid #eaeaea;
  border-radius: 8px;
  padding: 4px 8px;
  background-color: white;
  transition: all 0.3s ease;
}

.tags-input:focus-within {
  border-color: #007AFF;
  box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2);
}

.tags-container {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 8px;
}

.tag-item {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 4px 8px;
  background-color: rgba(0, 122, 255, 0.1);
  color: #007AFF;
  border-radius: 4px;
  font-size: 12px;
}

.tag-remove {
  background: none;
  border: none;
  color: #007AFF;
  cursor: pointer;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
}

.tag-control {
  width: 100%;
  padding: 4px 0;
  border: none;
  outline: none;
  font-size: 14px;
}

.testcases-container, .solution-codes {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.testcase-item, .solution-code-item {
  border: 1px solid #eaeaea;
  border-radius: 12px;
  overflow: hidden;
}

.testcase-header, .solution-code-header {
  padding: 12px 16px;
  background-color: #f5f5f7;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.testcase-header h4, .solution-code-header h4 {
  margin: 0;
  font-size: 16px;
  color: #1d1d1f;
}

.testcase-actions, .solution-code-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.checkbox-label input {
  cursor: pointer;
}

.btn-remove-testcase, .btn-remove-code {
  background: none;
  border: none;
  color: #FF3B30;
  cursor: pointer;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  transition: all 0.3s ease;
}

.btn-remove-testcase:hover, .btn-remove-code:hover {
  background-color: rgba(255, 59, 48, 0.1);
}

.testcase-content, .solution-code-content {
  padding: 16px;
}

.testcase-add, .solution-code-add {
  display: flex;
  justify-content: center;
}

.btn-add-testcase, .btn-add-code {
  padding: 8px 16px;
  border: 1px dashed #eaeaea;
  border-radius: 8px;
  background: none;
  color: #007AFF;
  font-size: 14px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.btn-add-testcase:hover, .btn-add-code:hover {
  background-color: rgba(0, 122, 255, 0.05);
  border-color: #007AFF;
}

.dialog-footer {
  padding: 16px 24px;
  border-top: 1px solid #eaeaea;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  flex-shrink: 0;
}

.btn-cancel {
  padding: 10px 20px;
  border-radius: 8px;
  border: 1px solid #eaeaea;
  background: white;
  color: #1d1d1f;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-cancel:hover {
  background: #f5f5f7;
}

.btn-import {
  padding: 10px 20px;
  border-radius: 8px;
  border: none;
  background: #007AFF;
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-import:hover {
  background: #0066CC;
}

@media (max-width: 768px) {
  .form-row {
    flex-direction: column;
    gap: 20px;
  }
  
  .difficulty-buttons {
    flex-direction: column;
    gap: 8px;
  }
}

.language-tag {
  position: absolute;
  top: 8px;
  right: 8px;
  padding: 4px 8px;
  background-color: #007AFF;
  color: white;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
  z-index: 2;
}

.solution-code-content {
  position: relative;
}

.solution-code-header {
  padding: 12px 16px;
  background-color: #f7f7f7;
  border-bottom: 1px solid #eaeaea;
  border-top-left-radius: 8px;
  border-top-right-radius: 8px;
}

.solution-code-header h4 {
  margin: 0;
  font-size: 16px;
  color: #1d1d1f;
  font-weight: 600;
}

.solution-code-item {
  border: 1px solid #eaeaea;
  border-radius: 8px;
  margin-bottom: 24px;
  overflow: hidden;
}

.solution-code-content {
  padding: 16px;
}

.code-editor {
  border: 1px solid #eaeaea;
  border-radius: 4px;
  padding: 12px;
  font-size: 14px;
  line-height: 1.5;
  min-height: 150px;
  margin-top: 4px;
}
</style> 