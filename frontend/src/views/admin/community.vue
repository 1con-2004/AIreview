<template>
  <div class="admin-page">
    <div class="development-notice">
      <div class="notice-content">
        <i class="fas fa-tools notice-icon"></i>
        <h2>功能开发中</h2>
        <p>社区管理功能正在开发中，敬请期待...</p>
      </div>
    </div>
  </div>
</template>

<script setup>
</script>

<style scoped>
.admin-page {
  min-height: 100vh;
  padding: 20px;
}

.development-notice {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 150px);
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
  margin-bottom: 1rem;
  font-size: 1.1rem;
  line-height: 1.5;
}
</style>
