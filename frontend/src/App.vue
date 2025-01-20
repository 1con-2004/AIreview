<template>
  <router-view></router-view>
</template>

<script setup>
// 不需要任何脚本代码
</script>

<style>
body {
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  background-color: #f0f2f5;
}

* {
  box-sizing: border-box;
}

/* 暗黑模式样式 */
body.dark-mode {
  background-color: #1a1a1a;
  color: #ffffff;
}

.dark-mode .login-box {
  background: #2d2d2d;
}

.dark-mode .header-icon {
  color: #ffffff;
}

.dark-mode input {
  background-color: #3d3d3d;
  color: #ffffff;
  border-color: #4d4d4d;
}

.dark-mode .login-header h2,
.dark-mode .login-title {
  color: #ffffff;
}

.dark-mode .form-options,
.dark-mode .other-accounts {
  color: #999;
}

.dark-mode .method-btn {
  background: #3d3d3d;
  border-color: #4d4d4d;
  color: #ffffff;
}

.dark-mode .method-btn:hover {
  border-color: #818cf8;
}

.dark-mode .divider::before,
.dark-mode .divider::after {
  background: #4d4d4d;
}

.dark-mode .divider span {
  background: #2d2d2d;
  color: #999;
}
</style>
