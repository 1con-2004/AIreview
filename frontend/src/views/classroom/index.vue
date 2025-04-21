<!-- 课堂辅助页面 -->
<template>
  <div class="classroom-page">
    <nav-bar></nav-bar>
    <div class="classroom-container">
      <div class="classroom-header">
        <h1>课堂辅助系统</h1>
        <p>提升教学体验，促进师生互动</p>
      </div>

      <div class="classroom-cards">
        <!-- 课堂签到卡片 -->
        <div class="classroom-card" @click="goToAttendance">
          <div class="card-icon">
            <i class="fas fa-clipboard-check"></i>
          </div>
          <h2>课堂签到</h2>
          <p>快速完成课堂签到，记录出勤情况</p>
          <button class="card-btn">立即签到</button>
        </div>

        <!-- 进入课堂卡片 -->
        <div class="classroom-card" @click="showClassroomDialog">
          <div class="card-icon">
            <i class="fas fa-chalkboard-teacher"></i>
          </div>
          <h2>进入课堂</h2>
          <p>输入课堂码参与实时互动或查看历史记录</p>
          <button class="card-btn">进入课堂</button>
        </div>
      </div>
    </div>

    <!-- 进入课堂弹窗 -->
    <div class="modal-backdrop" v-if="showClassModal" @click="closeClassModal"></div>
    <div class="modal" v-if="showClassModal">
      <div class="modal-header">
        <h2>进入课堂</h2>
        <button class="close-btn" @click="closeClassModal">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label>课堂码</label>
          <input type="text" v-model="classroomCode" placeholder="请输入5位课堂码 (如: JX723)" maxlength="5">
        </div>
        <div class="user-info" v-if="userInfo">
          <div class="user-info-item">
            <span class="label">姓名:</span>
            <span class="value">{{ studentInfo.real_name || userInfo.username }}</span>
          </div>
          <div class="user-info-item">
            <span class="label">学号:</span>
            <span class="value">{{ studentInfo.student_no || '未设置' }}</span>
          </div>
        </div>
        <div class="no-user-info" v-else>
          <p>您尚未登录或未完善学生信息，请先登录并完善信息。</p>
          <button class="login-btn" @click="goToLogin">去登录</button>
        </div>
        <button class="submit-btn" @click="enterClassroom" :disabled="!userInfo">确认进入</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import axios from 'axios'

const router = useRouter()

// 课堂弹窗状态
const showClassModal = ref(false)
const classroomCode = ref('')

// 用户信息
const userInfo = ref(null)
const studentInfo = ref({})

// 获取用户信息
const getUserInfo = async () => {
  try {
    const storedUserInfo = localStorage.getItem('userInfo')
    if (storedUserInfo) {
      userInfo.value = JSON.parse(storedUserInfo)

      // 获取学生信息
      const response = await axios.get(`/api/user/student-info/${userInfo.value.id}`)
      if (response.data.code === 200 && response.data.data) {
        studentInfo.value = response.data.data
      }
    }
  } catch (error) {
    console.error('获取用户信息失败:', error)
  }
}

// 课堂签到跳转
const goToAttendance = () => {
  router.push('/classroom/attendance')
}

// 显示进入课堂弹窗
const showClassroomDialog = () => {
  showClassModal.value = true
}

// 关闭进入课堂弹窗
const closeClassModal = () => {
  showClassModal.value = false
}

// 进入课堂
const enterClassroom = async () => {
  if (!classroomCode.value) {
    alert('请输入课堂码')
    return
  }

  if (!userInfo.value) {
    alert('请先登录')
    return
  }

  try {
    // 验证课堂码
    const response = await axios.post('/api/classroom/verify', {
      code: classroomCode.value
    })

    if (response.data.code === 200) {
      router.push(`/classroom/live/${classroomCode.value}`)
      closeClassModal()
    }
  } catch (error) {
    console.error('验证课堂码失败:', error)
    alert('课堂码无效或课堂已关闭')
  }
}

// 跳转到登录页
const goToLogin = () => {
  router.push('/login')
}

// 组件挂载时获取用户信息
onMounted(() => {
  getUserInfo()
})
</script>

<style scoped>
.classroom-page {
  min-height: 100vh;
  background-color: #0d1117;
  color: #e6edf3;
}

.classroom-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
}

.classroom-header {
  text-align: center;
  margin-bottom: 50px;
}

.classroom-header h1 {
  font-size: 2.5rem;
  color: #4ecdc4;
  margin-bottom: 10px;
  font-weight: 600;
}

.classroom-header p {
  font-size: 1.2rem;
  color: #a6accd;
}

.classroom-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
  max-width: 800px;
  margin: 0 auto;
}

.classroom-card {
  background: #1e1e2e;
  border-radius: 16px;
  padding: 30px;
  text-align: center;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.classroom-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
  border-color: rgba(78, 205, 196, 0.5);
}

.card-icon {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #4ecdc4, #45b6af);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
}

.card-icon i {
  font-size: 2.5rem;
  color: white;
}

.classroom-card h2 {
  font-size: 1.5rem;
  margin-bottom: 10px;
  color: #e6edf3;
}

.classroom-card p {
  color: #a6accd;
  margin-bottom: 20px;
  line-height: 1.5;
}

.card-btn {
  padding: 12px 24px;
  background: linear-gradient(135deg, #4ecdc4, #45b6af);
  color: white;
  border-radius: 8px;
  border: none;
  font-weight: 500;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: auto;
}

.card-btn:hover {
  background: linear-gradient(135deg, #45b6af, #3ca49d);
  transform: translateY(-2px);
}

/* 弹窗样式 */
.modal-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 100;
}

.modal {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background: #1e1e2e;
  border-radius: 16px;
  width: 90%;
  max-width: 500px;
  z-index: 101;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header h2 {
  color: #4ecdc4;
  font-size: 1.5rem;
  margin: 0;
}

.close-btn {
  background: none;
  border: none;
  color: #a6accd;
  font-size: 1.2rem;
  cursor: pointer;
  transition: color 0.3s;
}

.close-btn:hover {
  color: #4ecdc4;
}

.modal-body {
  padding: 20px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  color: #e6edf3;
  font-weight: 500;
}

.form-group input {
  width: 100%;
  padding: 12px 15px;
  background: #2d2b40;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: #e6edf3;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.form-group input:focus {
  outline: none;
  border-color: #4ecdc4;
}

.submit-btn {
  width: 100%;
  padding: 12px;
  background: linear-gradient(135deg, #4ecdc4, #45b6af);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s;
}

.submit-btn:hover {
  background: linear-gradient(135deg, #45b6af, #3ca49d);
}

.submit-btn:disabled {
  background: #3a3a4a;
  cursor: not-allowed;
}

/* 用户信息样式 */
.user-info {
  background: #2d2b40;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 20px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.user-info-item {
  display: flex;
  margin-bottom: 8px;
}

.user-info-item:last-child {
  margin-bottom: 0;
}

.user-info-item .label {
  width: 60px;
  color: #a6accd;
}

.user-info-item .value {
  flex: 1;
  color: #e6edf3;
  font-weight: 500;
}

.no-user-info {
  background: #2d2b40;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 20px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  text-align: center;
}

.no-user-info p {
  margin-bottom: 15px;
  color: #a6accd;
}

.login-btn {
  padding: 8px 16px;
  background: #4ecdc4;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s;
}

.login-btn:hover {
  background: #45b6af;
}
</style>
