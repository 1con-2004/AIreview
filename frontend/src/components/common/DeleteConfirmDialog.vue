<template>
  <div class="delete-confirm-dialog" v-if="visible">
    <div class="dialog-backdrop" @click="handleClose"></div>
    <div class="dialog-container">
      <div class="dialog-header">
        <h3>确认删除</h3>
        <button class="close-btn" @click="handleClose">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="dialog-content">
        <div class="warning-icon">
          <i class="fas fa-exclamation-triangle"></i>
        </div>
        <p class="warning-text">确定要删除「{{ itemName }}」吗？此操作不可撤销。</p>
      </div>
      <div class="dialog-footer">
        <button class="btn-cancel" @click="handleClose">取消</button>
        <button class="btn-confirm" @click="handleConfirm">确认删除</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, defineProps, defineEmits, watch } from 'vue'

const props = defineProps({
  itemName: {
    type: String,
    required: true
  }
})

const emit = defineEmits(['close', 'confirm'])

const visible = ref(true)

const handleClose = () => {
  visible.value = false
  emit('close')
}

const handleConfirm = () => {
  visible.value = false
  emit('confirm')
}
</script>

<style scoped>
.delete-confirm-dialog {
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
  max-width: 480px;
  background-color: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  z-index: 1001;
  overflow: hidden;
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
}

.dialog-header h3 {
  margin: 0;
  font-size: 18px;
  color: #1d1d1f;
  font-weight: 600;
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
}

.close-btn:hover {
  background-color: #f5f5f7;
  color: #1d1d1f;
}

.dialog-content {
  padding: 32px 24px;
  text-align: center;
}

.warning-icon {
  width: 64px;
  height: 64px;
  background-color: #fff3e0;
  border-radius: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 16px;
  color: #FF9500;
  font-size: 24px;
}

.warning-text {
  font-size: 16px;
  color: #1d1d1f;
  margin: 0;
  line-height: 1.5;
}

.dialog-footer {
  padding: 16px 24px;
  border-top: 1px solid #eaeaea;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.btn-cancel {
  padding: 8px 16px;
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

.btn-confirm {
  padding: 8px 16px;
  border-radius: 8px;
  border: none;
  background: #FF3B30;
  color: white;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-confirm:hover {
  background: #E0352B;
}
</style>
