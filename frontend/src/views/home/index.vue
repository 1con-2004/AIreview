/* eslint-disable vue/multi-word-component-names */
<template>
  <div class="home">
    <nav-bar></nav-bar>
    <div class="content">
      <div class="left-column">
        <div class="notification-container">
          <h2>通知栏</h2>
          <ul>
            <li>马斯克宣布新项目：未来的太空旅行计划</li>
            <li>全球气候变化：科学家警告即将到来的危机</li>
            <li>人工智能的未来：将如何改变我们的生活</li>
          </ul>
        </div>
        <div class="topics-container">
          <h2>题目栏</h2>
          <ul>
            <li>题目1：A + B Problem</li>
            <li>题目2：打砖块</li>
            <li>题目3：信息学竞赛</li>
          </ul>
        </div>
      </div>
      <div class="sidebar">
        <div class="advertisement-container">
          <h3>广告栏</h3>
          <p>这里是广告内容，推广最新的产品和服务。</p>
        </div>
        <div class="recommendations-container">
          <h3>向你推荐</h3>
          <ul>
            <li>推荐书籍：《未来简史》</li>
            <li>推荐电影：《黑客帝国》</li>
            <li>推荐课程：人工智能基础</li>
          </ul>
        </div>
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
}

.content {
  display: flex;
  padding: 20px;
}

.left-column {
  flex: 2; /* 左边部分占据较大空间 */
  display: flex;
  flex-direction: column;
  margin-right: 20px;
}

.notification-container,
.topics-container,
.advertisement-container,
.recommendations-container {
  background-color: #b2ebf2; /* 更加鲜艳的背景颜色 */
  border: 1px solid #00796b; /* 边框颜色 */
  border-radius: 15px; /* 圆角 */
  padding: 20px; /* 增加内边距 */
  margin-bottom: 40px; /* 增加标签之间的间距 */
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); /* 增加阴影效果 */
}

.notification-container {
  flex: 1; /* 通知栏占据上半部分 */
}

.topics-container {
  flex: 1; /* 题目栏占据下半部分 */
}

.sidebar {
  flex: 1; /* 广告栏和推荐占据较小空间 */
}

.advertisement-container,
.recommendations-container {
  background-color: #f0f0f0; /* 广告栏和推荐的背景颜色 */
  padding: 10px;
}

h2, h3 {
  font-family: 'Arial', sans-serif; /* 更加柔和的字体 */
  color: #00796b; /* 字体颜色 */
}

ul {
  list-style-type: none; /* 去掉列表前的点 */
  padding: 0; /* 去掉内边距 */
}

li {
  margin: 10px 0; /* 增加列表项之间的间距 */
  font-family: 'Arial', sans-serif; /* 更加柔和的字体 */
}
</style> 