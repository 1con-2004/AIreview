<template>
  <div class="problem-detail-page">
    <nav-bar></nav-bar>
    <div class="content">
      <div class="left-column">
        <!-- 上半部分 -->
        <div class="description-section">
          <h2 class="problem-title">A + B Problem</h2>
          <h3>描述</h3>
          <p>计算 a + b。</p>
          <h3>输入</h3>
          <p>两个整数 a, b。</p>
          <h3>输出</h3>
          <p>输出 a + b。</p>
          <h3>示例输入</h3>
          <div class="example-box">
            1 2
            <button class="copy-button" @click="copyToClipboard('1 2')">复制</button>
          </div>
          <h3>示例输出</h3>
          <div class="example-box">
            3
            <button class="copy-button" @click="copyToClipboard('3')">复制</button>
          </div>
        </div>

        <!-- 下半部分 -->
        <div class="code-section">
          <label for="language">语言：</label>
          <select id="language" class="language-select">
            <option>C++</option>
            <option>Python</option>
            <option>Java</option>
          </select>
          <textarea class="code-editor" rows="10" placeholder="在此处编写代码...">
#include <iostream>
using namespace std;

int main() {
    int a, b;
    cin >> a >> b;
    cout << a + b << endl;
    return 0;
}
          </textarea>
          <button class="submit-button">提交</button>
        </div>
      </div>

      <div class="right-column">
        <h3>提交信息</h3>
        <div class="submission-info">
          <p>提交记录...</p>
        </div>
        <h3>题目信息</h3>
        <div class="info">
          <p>ID: 0000</p>
          <p>时间限制: 1000MS</p>
          <p>内存限制: 256MB</p>
          <p>创建者: heblc</p>
          <p>难度: 低</p>
          <p>标签: <a href="#">显示</a></p>
        </div>
        <h3>统计</h3>
        <div class="statistic">
          <p>通过率: 68.33%</p>
          <div class="pie-chart">饼状图</div>
          <button class="detail-button">详情</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'

export default {
  name: 'ProblemDetail0000',
  components: {
    NavBar
  },
  methods: {
    copyToClipboard(text) {
      navigator.clipboard.writeText(text).then(() => {
        alert('内容已复制: ' + text);
      }).catch(err => {
        console.error('复制失败: ', err);
      });
    }
  }
}
</script>

<style scoped>
.problem-detail-page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f5f5f5; /* 浅灰色背景 */
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
  background-color: #ffffff; /* 白色背景 */
  border-radius: 15px; /* 圆角 */
  padding: 20px; /* 内边距 */
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); /* 增加阴影效果 */
}

.description-section {
  margin-bottom: 20px; /* 上下部分之间的间隙 */
}

.code-section {
  margin-top: 20px; /* 上下部分之间的间隙 */
}

.problem-title {
  color: blue; /* 标题颜色为蓝色 */
  font-weight: bold; /* 加粗 */
}

.example-box {
  background-color: #f0f0f0; /* 示例框背景颜色 */
  border: 1px solid #ccc; /* 边框颜色 */
  padding: 10px; /* 内边距 */
  border-radius: 5px; /* 圆角 */
  margin: 10px 0; /* 上下间距 */
  user-select: all; /* 允许用户选择文本 */
  position: relative; /* 使按钮绝对定位 */
}

.copy-button {
  position: absolute; /* 绝对定位 */
  right: 10px; /* 右侧间距 */
  top: 50%; /* 垂直居中 */
  transform: translateY(-50%); /* 垂直居中 */
  background-color: #00796b; /* 按钮背景颜色 */
  color: white; /* 按钮文字颜色 */
  border: none; /* 无边框 */
  padding: 5px 10px; /* 内边距 */
  border-radius: 5px; /* 圆角 */
  cursor: pointer; /* 鼠标指针 */
}

.code-editor {
  width: 100%;
  border-radius: 10px; /* 圆角 */
  padding: 10px; /* 内边距 */
}

.submit-button {
  background-color: #00796b;
  color: white;
  border: none;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
}

.right-column {
  flex: 1; /* 右侧标签选择区域 */
  padding: 20px;
  background-color: #ffffff; /* 白色背景 */
  border-radius: 15px; /* 圆角 */
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); /* 增加阴影效果 */
}

.statistic {
  margin-top: 20px; /* 与其他组件的间距 */
}
</style> 