<template>
  <div class="ai-center">
    <nav-bar></nav-bar>
    <div class="development-notice">
      <div class="notice-content">
        <i class="fas fa-robot notice-icon"></i>
        <h2>功能开发中</h2>
        <p>AI 智能辅助功能正在开发中，敬请期待...</p>
        <router-link to="/home" class="back-home-btn">
          <i class="fas fa-home"></i>
          返回主页
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import NavBar from '@/components/NavBar.vue'
</script>

<style scoped>
.ai-center {
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
  color: #2196f3;
  margin-bottom: 1.5rem;
  filter: drop-shadow(0 0 10px rgba(33, 150, 243, 0.3));
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

.back-home-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  background: linear-gradient(135deg, #2196f3, #1976d2);
  color: white;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.3s ease;
  border: none;
  font-size: 1rem;
}

.back-home-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(33, 150, 243, 0.3);
  background: linear-gradient(135deg, #1e88e5, #1565c0);
}

.back-home-btn i {
  font-size: 1.1rem;
}
</style>