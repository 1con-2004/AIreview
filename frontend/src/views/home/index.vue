/* eslint-disable vue/multi-word-component-names */
<template>
  <div class="home">
    <nav-bar></nav-bar>
    <div class="content">
      <div class="top-section">
        <div class="typing-container">
          <div class="code-window">
            <div class="code-header">
              <span class="code-text">#include &lt;stdio.h&gt;</span>
              <span class="code-text">int main() {</span>
              <span class="code-text">    printf("Hello World");</span>
              <span class="code-text">    return 0;</span>
              <span class="code-text">}</span>
            </div>
            <div class="typing-text">Hello World</div>
          </div>
        </div>
        <div class="features-grid">
          <div class="feature-box">
            <div class="feature-icon">
              <i class="box-icon"></i>
            </div>
            <h3>智能评测</h3>
            <p>基于AI的智能评测系统，实时分析代码质量。</p>
          </div>
          <div class="feature-box">
            <div class="feature-icon">
              <i class="settings-icon"></i>
            </div>
            <h3>团队协作</h3>
            <p>支持团队协作，实时分享代码和讨论。</p>
          </div>
          <div class="feature-box">
            <div class="feature-icon">
              <i class="lock-icon"></i>
            </div>
            <h3>隐私保护</h3>
            <p>严格的隐私保护机制，确保代码安全。</p>
          </div>
          <div class="feature-box">
            <div class="feature-icon">
              <i class="ai-icon"></i>
            </div>
            <h3>AI助手</h3>
            <p>智能AI助手，帮助解决编程难题。</p>
          </div>
          <div class="feature-box">
            <div class="feature-icon">
              <i class="search-icon"></i>
            </div>
            <h3>智能搜索</h3>
            <p>强大的代码搜索功能，快速定位问题。</p>
          </div>
          <div class="feature-box">
            <div class="feature-icon">
              <i class="chart-icon"></i>
            </div>
            <h3>数据分析</h3>
            <p>详细的学习数据分析，追踪进步。</p>
          </div>
        </div>
      </div>

      <div class="features-section">
        <router-link to="/problems" class="feature-card">
          <div class="card-content">
            <h2>题库与练习</h2>
            <p>甄选热门题库，涵盖竞赛题、面试题、基础题，AI 实时解析纠错，助力编程能力快速提升。</p>
            <div class="feature-image intelligence">
              <div class="geometric-shape"></div>
            </div>
          </div>
          <div class="card-overlay">
            <span class="explore-text">点击探索 →</span>
          </div>
        </router-link>
        
        <router-link to="/classroom" class="feature-card">
          <div class="card-content">
            <h2>课堂辅助</h2>
            <p>课堂跟踪，实时反馈，课后复习，引领高校教学新模式</p>
            <div class="feature-image privacy">
              <div class="geometric-shape"></div>
            </div>
          </div>
          <div class="card-overlay">
            <span class="explore-text">点击探索 →</span>
          </div>
        </router-link>
        
        <router-link to="/ai-center" class="feature-card">
          <div class="card-content">
            <h2>AI中心</h2>
            <p>智能AI助手，帮助解决编程难题，提供个性化学习建议。</p>
            <div class="feature-image familiar">
              <div class="geometric-shape"></div>
            </div>
          </div>
          <div class="card-overlay">
            <span class="explore-text">点击探索 →</span>
          </div>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'

export default {
  name: 'HomePage',
  components: {
    NavBar
  }
}
</script>

<style scoped>
.home {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #0d1117;
  color: white;
}

.content {
  display: flex;
  flex-direction: column;
  width: 100%;
  box-sizing: border-box;
  padding: 40px;
  gap: 60px;
}

.top-section {
  display: flex;
  gap: 40px;
  width: 100%;
  flex-direction: row;
}

.typing-container {
  width: 33%;
  height: 650px;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  background-color: #1e1e2e;
  border-radius: 10px;
  padding: 20px;
  box-sizing: border-box;
}

.code-window {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  padding: 40px;
  box-sizing: border-box;
}

.code-header {
  color: #a6accd;
  font-family: 'Fira Code', monospace;
  font-size: 20px;
  margin-bottom: 30px;
}

.code-text {
  display: block;
  margin: 12px 0;
  color: #c3e88d;
}

.typing-text {
  color: white;
  font-family: 'Fira Code', monospace;
  font-size: 48px;
  border-right: 3px solid #4CAF50;
  width: fit-content;
  white-space: nowrap;
  overflow: hidden;
  animation: typing 2s steps(12), blink 0.5s step-end infinite alternate;
}

@keyframes typing {
  from {
    width: 0;
  }
}

@keyframes blink {
  50% {
    border-color: transparent;
  }
}

.features-grid {
  width: 67%;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-template-rows: repeat(3, 1fr);
  gap: 24px;
  padding-left: 20px;
  height: 600px;
}

.feature-box {
  background-color: #1e1e2e;
  border-radius: 12px;
  padding: 32px;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.feature-box:hover {
  transform: translateY(-4px);
  border-color: rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.feature-icon {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 8px;
}

.feature-box h3 {
  font-size: 22px;
  font-weight: 600;
  color: #fff;
  margin: 0;
}

.feature-box p {
  font-size: 15px;
  line-height: 1.6;
  color: #a6accd;
  margin: 0;
}

/* Features Section Styles */
.features-section {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
  padding: 0 40px;
}

.feature-card {
  background-color: #1e1e2e;
  border-radius: 16px;
  padding: 32px;
  transition: all 0.3s ease;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  min-height: 300px;
  display: flex;
  flex-direction: column;
  text-decoration: none;
}

.feature-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
}

.feature-card h2 {
  font-size: 28px;
  margin-bottom: 16px;
  font-weight: 600;
  background: linear-gradient(90deg, #fff, #f0f0f0);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.feature-card p {
  font-size: 16px;
  line-height: 1.6;
  color: #a6accd;
  margin-bottom: 32px;
}

.feature-image {
  flex: 1;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.geometric-shape {
  width: 120px;
  height: 120px;
  background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
  transition: all 0.5s ease;
  opacity: 0.8;
}

.intelligence .geometric-shape {
  clip-path: polygon(50% 0%, 100% 50%, 50% 100%, 0% 50%);
  background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
}

.familiar .geometric-shape {
  clip-path: polygon(25% 0%, 75% 0%, 100% 50%, 75% 100%, 25% 100%, 0% 50%);
  background: linear-gradient(45deg, #a8e6cf, #3498db);
}

.privacy .geometric-shape {
  border-radius: 50%;
  background: linear-gradient(45deg, #dce35b, #45b649);
}

.feature-card:hover .geometric-shape {
  transform: rotate(45deg) scale(1.2);
  opacity: 1;
}

/* Icon styles */
.box-icon, .settings-icon, .lock-icon, .ai-icon, .search-icon, .chart-icon {
  width: 24px;
  height: 24px;
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
}

.box-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%234ecdc4' d='M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V5h14v14z'/%3E%3C/svg%3E");
}

.settings-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%233498db' d='M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.07.62-.07.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z'/%3E%3C/svg%3E");
}

.lock-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%2345b649' d='M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z'/%3E%3C/svg%3E");
}

.ai-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%234ecdc4' d='M21 10.12h-6.78l2.74-2.82c-2.73-2.7-7.15-2.8-9.88-.1-2.73 2.71-2.73 7.08 0 9.79s7.15 2.71 9.88 0C18.32 15.65 19 14.08 19 12.1h2c0 1.98-.88 4.55-2.64 6.29-3.51 3.48-9.21 3.48-12.72 0-3.5-3.47-3.53-9.11-.02-12.58s9.14-3.47 12.65 0L21 3v7.12zM12.5 8v4.25l3.5 2.08-.72 1.21L11 13V8h1.5z'/%3E%3C/svg%3E");
}

.search-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%233498db' d='M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z'/%3E%3C/svg%3E");
}

.chart-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%2345b649' d='M9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4zm2 2H5V5h14v14zm0-16H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z'/%3E%3C/svg%3E");
}


/* 添加卡片悬停效果 */
.card-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(to top, rgba(30, 30, 46, 0.9), transparent);
  height: 100%;
  display: flex;
  align-items: flex-end;
  justify-content: center;
  padding-bottom: 20px;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.feature-card:hover .card-overlay {
  opacity: 1;
}

.explore-text {
  color: #fff;
  font-size: 18px;
  font-weight: 600;
  padding: 12px 24px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 30px;
  backdrop-filter: blur(5px);
  transform: translateY(20px);
  transition: transform 0.3s ease;
}

.feature-card:hover .explore-text {
  transform: translateY(0);
}
</style> 