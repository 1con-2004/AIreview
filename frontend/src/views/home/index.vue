/* eslint-disable vue/multi-word-component-names */
<template>
  <div class="home">
    <nav-bar></nav-bar>
    <div class="hero-section">
      <div class="hero-content">
        <div class="hero-title">
          <span class="wave-text">重新</span>
          <span class="wave-text">定义</span>
          <span class="wave-text">你的</span>
          <span class="wave-text">编程</span>
          <span class="wave-text">之旅</span>

        </div>
        <p class="hero-subtitle">QuizPlanet问知星球🌏：重新定义<strong style="font-size: 1.2em; color: orange;">人工智能时代</strong>编程</p>
        <div class="hero-buttons">
          <router-link to="/problems" class="hero-button primary">开始刷题</router-link>
          <router-link to="/personal-center" class="hero-button secondary">探索功能</router-link>
        </div>
      </div>
      <div class="code-animation">
        <div class="code-window">
          <div class="code-header">
            <div class="window-controls">
              <span class="control red"></span>
              <span class="control yellow"></span>
              <span class="control green"></span>
            </div>
            <div class="window-title">main.cpp</div>
          </div>
          <div class="code-content">
            <div v-for="(line, index) in displayedLines" :key="index" class="code-line" v-html="line"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- 核心功能展示部分 - 重新设计的视频展示区域 -->
    <div class="feature-section">
      <h2 class="section-title">
        <span class="fliping-text">AI 深度感知 , 懂你迫切所需</span>
      </h2>

      <!-- AI智能评测 -->
      <div class="feature-row">
        <div class="feature-text">
          <h3 class="drop-text">满血DeepSeek R1模型 , 助力代码分析</h3>
          <p class="feature-description">
          搭载<strong style="font-size: 1.2em; color: orange;">满血DeepSeek R1模型</strong> , 以突破性的深度思考功能构建代码解析矩阵，深度解构每一行代码的语法逻辑 <br>
          <strong style="font-size: 1.2em; color: orange;">毫秒级</strong>智能扫描 , 精准定位潜在语法隐患、复杂逻辑断层 <br>
          无论是细微的语法瑕疵、复杂的逻辑漏洞，还是关键的性能瓶颈，<strong style="font-size: 1.2em; color: orange;">DeepSeek R1 模型</strong>都能敏锐洞察
          </p>
          <div class="feature-tags">
            <span class="tag">满血模型</span>
            <span class="tag">多模态处理</span>
            <span class="tag">毫秒级响应</span>
          </div>
        </div>
        <div class="feature-video-container">
          <video src="/vedios/ai_judge.mp4" class="feature-video" autoplay muted loop playsinline></video>
        </div>
      </div>

      <!-- 学习计划功能 -->
      <div class="feature-row reverse">
        <div class="feature-text">
          <h3 class="drop-text">个性化学习计划</h3>
          <p class="feature-description">
            依托<strong style="font-size: 1.2em; color: orange;">满血 DeepSeek R1 模型</strong>，基于您的学习历史数据, 运用先进的<strong style="font-size: 1.2em; color: orange;">机器学习算法</strong>，智能生成定制化学习计划 <br>
            系统通过<strong style="font-size: 1.2em; color: orange;">实时分析与动态评估</strong>，为您精准推送契合当前编程水平的题目集与知识点矩阵 <br>
            借助<strong style="font-size: 1.2em; color: orange;">自适应学习机制</strong>，持续微调学习计划，让您时刻处于高效学习的最优区间，在代码世界中稳健进阶
          </p>
          <div class="feature-tags">
            <span class="tag">先进机器学习算法</span>
            <span class="tag">实时分析</span>
            <span class="tag">自适应学习机制</span>
          </div>
        </div>
        <div class="feature-video-container">
          <video src="/vedios/learning-plan.mp4" class="feature-video" autoplay muted loop playsinline></video>
        </div>
      </div>

      <!-- 精确搜索功能 -->
      <div class="feature-row">
        <div class="feature-text">
          <h3 class="drop-text">精确题目搜索</h3>
          <p class="feature-description">
            采用先进的<strong style="font-size: 1.2em; color: orange;">后端算法</strong>搭建多维度标签体系 , 让你快速找到所需题目 . 支持按难度、主题、算法类型等多种<strong style="font-size: 1.2em; color: orange;">方式筛选</strong> <br>
            运用二级标签深度嵌套搜索和智能标签<strong style="font-size: 1.2em; color: orange;">关键词匹配算法</strong>, 让题目筛选更加精准、高效 <br>
            无论是准备面试还是参加竞赛，都能轻松找到最匹配的练习题 <br>
          </p>
          <div class="feature-tags">
            <span class="tag">多维筛选</span>
            <span class="tag">标签体系</span>
            <span class="tag">精准匹配</span>
          </div>
        </div>
        <div class="feature-video-container">
          <video src="/vedios/sort.mp4" class="feature-video" autoplay muted loop playsinline></video>
        </div>
      </div>
    </div>

    <!-- 高级功能展示 -->
    <div class="advanced-features">
      <h2 class="section-title">
        <span class="fade-text">AI , 比你更懂你</span>
      </h2>

      <div class="features-grid">
        <!-- 个人中心功能 -->
        <div class="advanced-feature-card">
          <div class="card-video-wrapper">
            <video src="/vedios/personal-center.mp4" class="card-video" autoplay muted loop playsinline></video>
            <div class="card-overlay"></div>
          </div>
          <div class="card-content">
            <h3 class="wave-text">个性化学习路径</h3>
            <p class="fade-text"><strong style="font-size: 1.2em; color: orange;">DeepSeek R1</strong>为你专属服务, 生成<strong style="font-size: 1.2em; color: orange;">量身定制</strong>的学习路径, 智能推荐适合你的题目和学习资源。</p>
            <router-link to="/personal-center" class="card-link">
              <span class="fliping-text">探索更多</span>
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 4L10.59 5.41L16.17 11H4V13H16.17L10.59 18.59L12 20L20 12L12 4Z" fill="currentColor"/>
              </svg>
            </router-link>
          </div>
        </div>

        <!-- 数据面板功能 -->
        <div class="advanced-feature-card">
          <div class="card-video-wrapper">
            <video src="/vedios/dashboard.mp4" class="card-video" autoplay muted loop playsinline></video>
            <div class="card-overlay"></div>
          </div>
          <div class="card-content">
            <h3 class="wave-text">数据可视化分析</h3>
            <p class="fade-text"><strong style="font-size: 1.2em; color: orange;">DeepSeek搭配Echarts</strong>, 生成专属于你的数据可视化图表</p>
            <router-link to="/dashboard" class="card-link">
              <span class="fliping-text">探索更多</span>
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 4L10.59 5.41L16.17 11H4V13H16.17L10.59 18.59L12 20L20 12L12 4Z" fill="currentColor"/>
              </svg>
            </router-link>
          </div>
        </div>
      </div>
    </div>

    <!-- 引导开始使用部分 -->
    <div class="cta-section">
      <div class="cta-content">
        <h2 class="cta-title">
          <span class="fliping-text">立即</span><span class="fliping-text">开始</span><span class="fliping-text">你的</span><span class="fliping-text">编程</span><span class="fliping-text">之旅</span>
        </h2>
        <p class="cta-text drop-text">加入我们，与AI一起提升编程能力，开启高效学习新体验</p>
        <router-link to="/problems" class="cta-button">
          <span class="text-rewind" data-text="开始使用">开始使用</span>
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 4L10.59 5.41L16.17 11H4V13H16.17L10.59 18.59L12 20L20 12L12 4Z" fill="currentColor"/>
          </svg>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import NavBar from '@/components/NavBar.vue'
import { setGlobalToken } from '@/utils/request'

const codeLines = [
  '<span class="code-keyword">#include</span> <span class="code-string">&lt;iostream&gt;</span>',
  '<span class="code-keyword">using namespace</span> std;',
  '',
  '<span class="code-keyword">int</span> <span class="code-function">main</span>() {',
  '  ', // 留空，将通过打字效果填充
  '  <span class="code-comment">  // 开始我的AI编程之旅</span>',
  '  <span class="code-keyword">return</span> <span class="code-number">0</span>;',
  '}'
]
const displayedLines = ref([])
const typingIndex = ref(0)
const isTyping = ref(false)
const typingText = ref('')
const fullTypingText = 'cout << "Hello, World!" << endl;'
const charIndex = ref(0)
const isLineComplete = ref(false)
const showCursor = ref(true)
let cursorInterval = null

// 检查并确保令牌设置正确
const validateTokens = () => {
  console.log('验证首页访问令牌')
  // 尝试从localStorage获取token
  const accessToken = localStorage.getItem('accessToken')
  if (accessToken) {
    console.log('找到accessToken，确保全局设置')
    setGlobalToken(accessToken)
  } else {
    // 尝试从userInfo获取token
    const userInfoStr = localStorage.getItem('userInfo')
    if (userInfoStr) {
      try {
        const userInfo = JSON.parse(userInfoStr)
        if (userInfo.accessToken) {
          console.log('从userInfo中找到token，确保全局设置')
          setGlobalToken(userInfo.accessToken)
        }
      } catch (e) {
        console.error('解析userInfo失败:', e)
      }
    }
  }
}

// 开始代码键入动画
const startTypingAnimation = () => {
  isTyping.value = true
  typingIndex.value = 0
  displayedLines.value = []
  typeNextLine()
}

const typeNextLine = () => {
  if (typingIndex.value < codeLines.length) {
    // 如果是第5行（打印Hello World的那行），逐字符显示
    if (typingIndex.value === 4) {
      displayedLines.value.push('  ') // 添加基础缩进
      charIndex.value = 0
      typingText.value = ''
      isLineComplete.value = false
      typeNextChar()
    } else if (typingIndex.value === codeLines.length - 1) {
      // 如果是最后一行，添加光标
      displayedLines.value.push(codeLines[typingIndex.value])

      // 设置间隔更新光标状态
      const updateLastLineCursor = () => {
        if (displayedLines.value.length >= codeLines.length) {
          // 移除可能存在的旧光标
          let lastLine = displayedLines.value[displayedLines.value.length - 1]
          lastLine = lastLine.replace(/<span class="code-cursor"><\/span>/g, '')

          // 添加新光标
          displayedLines.value[displayedLines.value.length - 1] =
            lastLine + (showCursor.value ? '<span class="code-cursor"></span>' : '')
        }
      }

      // 立即执行一次
      updateLastLineCursor()

      // 设置间隔更新
      cursorInterval = setInterval(updateLastLineCursor, 500)

      typingIndex.value++
      setTimeout(() => {
        typeNextLine()
      }, 300)
    } else {
      // 其他行直接显示整行
      displayedLines.value.push(codeLines[typingIndex.value])
      typingIndex.value++
      setTimeout(() => {
        typeNextLine()
      }, 300) // 每行代码的键入时间
    }
  } else {
    isTyping.value = false
  }
}

const typeNextChar = () => {
  if (charIndex.value < fullTypingText.length) {
    charIndex.value++
    typingText.value = fullTypingText.substring(0, charIndex.value)

    // 构建HTML字符串
    const code = typingText.value

    // 创建DOM元素来解析HTML
    const tempEl = document.createElement('div')
    tempEl.textContent = code

    // 获取纯文本内容
    const plainText = tempEl.textContent

    // 构建高亮版本，先转义HTML标签
    let highlightedText = plainText
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')

    // 按特定顺序应用高亮替换
    // 1. 字符串 (需要优先处理引号内的内容)
    highlightedText = highlightedText.replace(/"([^"]*)"/g, '<span class="code-string">"$1"</span>')

    // 2. 关键字
    const keywords = ['cout', 'endl']
    keywords.forEach(keyword => {
      const regex = new RegExp(`\\b${keyword}\\b`, 'g')
      highlightedText = highlightedText.replace(regex, `<span class="code-keyword">${keyword}</span>`)
    })

    // 3. 运算符和其他元素
    highlightedText = highlightedText.replace(/&lt;&lt;/g, '&lt;&lt;')

    // 更新显示，确保HTML标签被正确解析
    setTimeout(() => {
      // 手动插入内容到DOM
      const codeLineElement = document.querySelector('.code-content .code-line:nth-child(5)')
      if (codeLineElement) {
        codeLineElement.innerHTML = '  ' + highlightedText + (showCursor.value ? '<span class="code-cursor"></span>' : '')
        // 将内容也同步到data中
        displayedLines.value[4] = '  ' + highlightedText
      }
    })

    setTimeout(() => {
      typeNextChar()
    }, 100)
  } else {
    isLineComplete.value = true
    typingIndex.value++

    // 完成后确保光标被移除
    setTimeout(() => {
      const codeLineElement = document.querySelector('.code-content .code-line:nth-child(5)')
      if (codeLineElement) {
        codeLineElement.innerHTML = '  ' + codeLineElement.innerHTML.replace(/<span class="code-cursor"><\/span>/g, '')
      }
    })

    setTimeout(() => {
      typeNextLine()
    }, 300)
  }
}

onMounted(() => {
  // 为波浪文字添加延迟动画
  document.querySelectorAll('.wave-text').forEach((text, index) => {
    text.style.animationDelay = `${index * 0.35}s`
  })

  // 为翻转文字添加延迟动画
  document.querySelectorAll('.fliping-text').forEach((text, index) => {
    text.style.animationDelay = `${index * 0.3}s`
  })
  // 为淡入淡出文字添加延迟动画
  document.querySelectorAll('.fade-text').forEach((text, index) => {
    text.style.animationDelay = `${index * 0.3}s`
  })

  // 为下落文字添加延迟动画
  document.querySelectorAll('.drop-text').forEach((text, index) => {
    text.style.animationDelay = `${index * 0.2}s`
  })

  // 启动光标闪烁效果
  setInterval(() => {
    showCursor.value = !showCursor.value
  }, 500)

  // 验证token并确保正确设置
  validateTokens()

  // 开始代码键入动画
  startTypingAnimation()

  // 组件卸载时清除定时器
  return () => {
    if (cursorInterval) {
      clearInterval(cursorInterval)
    }
  }
})
</script>

<style scoped>
.home {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #0d1117;
  color: white;
  overflow-x: hidden;
}

/* 英雄区域样式 */
.hero-section {
  display: flex;
  min-height: 90vh;
  padding: 0 5%;
  align-items: center;
  position: relative;
  justify-content: center;
  text-align: center;
}

.hero-content {
  flex: 1;
  max-width: 600px;
  z-index: 2;
}

.hero-title {
  font-size: 4.5rem;
  font-weight: 800;
  margin-bottom: 1.5rem;
  line-height: 1.2;
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  justify-content: center;
}

.hero-subtitle {
  font-size: 1.5rem;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 3rem;
}

.hero-buttons {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.hero-button {
  padding: 0.75rem 2rem;
  border-radius: 30px;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.hero-button.primary {
  background: linear-gradient(135deg, #6b73ff, #4ecdc4);
  color: white;
  border: none;
}

.hero-button.secondary {
  background: transparent;
  border: 1px solid rgba(255, 255, 255, 0.4);
  color: white;
}

.hero-button:hover {
  transform: translateY(-4px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
}

.code-animation {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  max-width: 600px;
}

.code-window {
  width: 100%;
  height: 400px;
  background-color: #1e1e2e;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
  margin-left: 40px;
}

.code-header {
  background-color: #2d2d3d;
  height: 40px;
  display: flex;
  align-items: center;
  padding: 0 15px;
  position: relative;
}

.window-controls {
  display: flex;
  gap: 8px;
}

.control {
  width: 12px;
  height: 12px;
  border-radius: 50%;
}

.control.red {
  background-color: #ff5f57;
}

.control.yellow {
  background-color: #febc2e;
}

.control.green {
  background-color: #28c840;
}

.window-title {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  color: #a6accd;
  font-size: 14px;
}

.code-content {
  padding: 20px;
  font-family: 'Fira Code', monospace;
  font-size: 14px;
  line-height: 1.6;
  height: calc(100% - 40px);
  overflow-y: auto;
  text-align: left;
}

.code-line {
  margin-bottom: 8px;
  white-space: pre;
  animation: fadeIn 0.3s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.code-keyword {
  color: #ff79c6 !important;
}

.code-string {
  color: #f1fa8c !important;
}

.code-function {
  color: #50fa7b !important;
}

.code-number {
  color: #bd93f9 !important;
}

.code-comment {
  color: #6272a4 !important;
}

/* 添加打字效果相关样式 */
.code-cursor {
  display: inline-block;
  width: 2px;
  height: 18px;
  background-color: #fff;
  margin-left: 2px;
  vertical-align: middle;
  animation: cursor-blink 0.8s step-end infinite;
  position: relative;
  top: 1px;
}

@keyframes cursor-blink {
  0%, 100% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
}

.code-typing-container {
  display: inline-block;
}

.code-typing-text {
  display: inline-block;
}

/* 重新设计的功能展示部分 */
.section-title {
  font-size: 3rem;
  font-weight: 700;
  margin-bottom: 4rem;
  text-align: center;
  display: flex;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
}

/* 核心功能展示区 */
.feature-section {
  padding: 120px 5%;
  background: linear-gradient(180deg, #0d1117, #151a24);
}

.feature-row {
  display: flex;
  align-items: center;
  margin-bottom: 120px;
  gap: 60px;
}

.feature-row.reverse {
  flex-direction: row-reverse;
}

.feature-text {
  flex: 1;
  max-width: 50%;
}

.feature-text h3 {
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
  background: linear-gradient(90deg, #fff, #a6accd);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.feature-description {
  font-size: 1.1rem;
  line-height: 1.8;
  color: rgba(255, 255, 255, 0.85);
  margin-bottom: 2rem;
}

.feature-tags {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.tag {
  padding: 6px 16px;
  background: rgba(107, 115, 255, 0.2);
  border: 1px solid rgba(107, 115, 255, 0.4);
  border-radius: 30px;
  font-size: 0.85rem;
  color: #8c92ff;
}

.feature-video-container {
  flex: 1;
  position: relative;
  height: 450px;
  overflow: hidden;
  border-radius: 16px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
}

.feature-video {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.feature-video-container:hover .feature-video {
  transform: scale(1.05);
}

/* 删除视频蓝色滤镜 */
.video-gradient-overlay {
  display: none;
}

/* 高级功能展示区 */
.advanced-features {
  padding: 120px 5%;
  background-color: #151a24;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
  gap: 40px;
}

.advanced-feature-card {
  position: relative;
  border-radius: 16px;
  overflow: hidden;
  background-color: #1e1e2e;
  height: 500px;
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
  transition: transform 0.4s ease, box-shadow 0.4s ease;
}

.advanced-feature-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
}

.card-video-wrapper {
  height: 60%;
  position: relative;
  overflow: hidden;
}

.card-video {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.advanced-feature-card:hover .card-video {
  transform: scale(1.1);
}

.card-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 50%;
  background: linear-gradient(to top, #1e1e2e, transparent);
  pointer-events: none;
}

.card-content {
  padding: 30px;
  height: 40%;
  display: flex;
  flex-direction: column;
}

.card-content h3 {
  font-size: 1.8rem;
  font-weight: 700;
  margin-bottom: 1rem;
  background: linear-gradient(90deg, #fff, #a6accd);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.card-content p {
  font-size: 1rem;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 1.5rem;
}

.card-link {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  font-weight: 600;
  color: #6b73ff;
  text-decoration: none;
  margin-top: auto;
  transition: gap 0.3s ease;
}

.card-link svg {
  width: 18px;
  height: 18px;
  transition: transform 0.3s ease;
}

.card-link:hover {
  gap: 15px;
}

.card-link:hover svg {
  transform: translateX(5px);
}

/* 引导开始使用部分样式 */
.cta-section {
  padding: 150px 5%;
  text-align: center;
  background: linear-gradient(135deg, #0d1117, #151a24);
}

.cta-content {
  max-width: 800px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.cta-title {
  font-size: 3.5rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
  display: flex;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.cta-text {
  font-size: 1.25rem;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 3rem;
}

.cta-button {
  padding: 1.25rem 3rem;
  background: linear-gradient(135deg, #6b73ff, #4ecdc4);
  border: none;
  border-radius: 30px;
  color: white;
  font-size: 1.2rem;
  font-weight: 600;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 12px;
  transition: all 0.3s ease;
  text-decoration: none;
  margin-top: 2rem;
}

.cta-button svg {
  width: 20px;
  height: 20px;
  transition: transform 0.3s ease;
}

.cta-button:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
}

.cta-button:hover svg {
  transform: translateX(5px);
}

/* 添加Text Rewind效果 */
.text-rewind {
  position: relative;
  display: inline-block;
}

.text-rewind::before {
  content: attr(data-text);
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  color: transparent;
  overflow: hidden;
  white-space: nowrap;
  animation: textRewind 4s linear infinite;
  background: linear-gradient(90deg, #e0f7fa, #ffffff, #e6fffd); /* 更柔和的淡蓝色渐变 */
  -webkit-background-clip: text;
  background-clip: text;
}

@keyframes textRewind {
  0% {
    width: 0;
  }
  50% {
    width: 100%;
  }
  51% {
    width: 100%;
  }
  100% {
    width: 0;
  }
}

/* 文字动画效果 */
/* 波浪文字揭示效果 */
.wave-text {
  display: inline-block;
  position: relative;
  overflow: hidden;
  animation: waveReveal 1s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  transform: translateY(100%);
  opacity: 0;
}

@keyframes waveReveal {
  0% {
    transform: translateY(100%);
    opacity: 0;
  }
  100% {
    transform: translateY(0);
    opacity: 1;
  }
}

/* 平滑翻转文字效果 */
.fliping-text {
  display: inline-block;
  opacity: 0;
  transform: perspective(500px) rotateX(90deg);
  transform-origin: 50% 0;
  animation: flipText 0.8s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
}

@keyframes flipText {
  from {
    opacity: 0;
    transform: perspective(500px) rotateX(90deg);
  }
  to {
    opacity: 1;
    transform: perspective(500px) rotateX(0deg);
  }
}

/* 淡入淡出文字效果 */
.fade-text {
  display: inline-block;
  opacity: 0;
  animation: fadeText 1.5s ease forwards;
}

@keyframes fadeText {
  0% {
    opacity: 0;
  }
  100% {
    opacity: 1;
  }
}

/* 文字下落效果 */
.drop-text {
  display: inline-block;
  opacity: 0;
  transform: translateY(-50px);
  animation: dropText 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
}

@keyframes dropText {
  from {
    opacity: 0;
    transform: translateY(-50px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .hero-section {
    flex-direction: column;
    text-align: center;
    padding-top: 50px;
    padding-bottom: 50px;
  }

  .hero-content {
    margin-bottom: 50px;
    max-width: 100%;
  }

  .hero-title {
    justify-content: center;
  }

  .hero-buttons {
    justify-content: center;
  }

  .code-animation {
    max-width: 100%;
  }

  .feature-row {
    flex-direction: column;
    gap: 40px;
  }

  .feature-row.reverse {
    flex-direction: column;
  }

  .feature-text {
    max-width: 100%;
    text-align: center;
  }
}

@media (max-width: 992px) {
  .features-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 3rem;
  }

  .section-title {
    font-size: 2.5rem;
  }

  .feature-text h3 {
    font-size: 2rem;
  }

  .cta-title {
    font-size: 2.5rem;
  }

  .feature-video-container {
    height: 350px;
  }
}

@media (max-width: 480px) {
  .hero-buttons {
    flex-direction: column;
    width: 100%;
  }

  .hero-button {
    width: 100%;
  }

  .section-title {
    font-size: 2rem;
  }

  .cta-button {
    width: 100%;
  }

  .feature-video-container {
    height: 250px;
  }
}
</style>
