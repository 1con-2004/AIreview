<!-- 课堂签到页面 -->
<template>
  <div class="attendance-page">
    <nav-bar></nav-bar>
    <div class="development-notice">
      <div class="notice-content">
        <i class="fas fa-tools notice-icon"></i>
        <h2>功能开发中</h2>
        <p>课堂签到功能正在开发中，敬请期待...</p>
        <router-link to="/classroom" class="back-btn">
          <i class="fas fa-arrow-left"></i>
          返回课堂主页
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import NavBar from '@/components/NavBar.vue'
</script>

<style scoped>
.attendance-page {
  min-height: 100vh;
  background-color: #0d1117;
}

.development-notice {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 70px); /* 减去导航栏高度 */
  padding: 20px;
}

.notice-content {
  background: #1e1e2e;
  padding: 2.5rem;
  border-radius: 1rem;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  max-width: 90%;
  width: 400px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.notice-icon {
  font-size: 3.5rem;
  color: #4ecdc4;
  margin-bottom: 1.5rem;
  filter: drop-shadow(0 0 10px rgba(78, 205, 196, 0.3));
}

.notice-content h2 {
  color: #e6edf3;
  margin-bottom: 1rem;
  font-size: 1.75rem;
  font-weight: 600;
}

.notice-content p {
  color: #a6accd;
  margin-bottom: 2rem;
  font-size: 1.1rem;
  line-height: 1.5;
}

.back-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  background: linear-gradient(135deg, #4ecdc4, #45b6af);
  color: white;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.3s ease;
  border: none;
  font-size: 1rem;
}

.back-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(78, 205, 196, 0.3);
  background: linear-gradient(135deg, #45b6af, #3ca49d);
}

.back-btn i {
  font-size: 1.1rem;
}
</style> 