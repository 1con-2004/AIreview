<template>
  <div class="admin-page">
    <div class="statistics-container">

      <!-- 数据统计卡片 -->
      <div class="statistics-cards">
        <div class="stat-card">
          <div class="stat-icon">
            <i class="fas fa-users"></i>
          </div>
          <div class="stat-info">
            <h3>{{ totalStudents || 0 }}</h3>
            <p>学生总数</p>
          </div>
        </div>
        
        <div class="stat-card">
          <div class="stat-icon">
            <i class="fas fa-chalkboard"></i>
          </div>
          <div class="stat-info">
            <h3>{{ totalClasses || 0 }}</h3>
            <p>班级总数</p>
          </div>
        </div>
        
        <div class="stat-card">
          <div class="stat-icon">
            <i class="fas fa-code"></i>
          </div>
          <div class="stat-info">
            <h3>{{ totalProblems || 0 }}</h3>
            <p>题目总数</p>
          </div>
        </div>
      </div>

      <!-- 搜索和筛选区域 -->
      <div class="search-filter-container">
        <!-- 搜索框放在左侧 -->
        <div class="search-box">
          <el-input
            v-model="searchQuery"
            placeholder="搜索学生姓名或学号"
            clearable
            @input="handleSearch"
            style="width: 300px;"
          >
            <template #prefix>
              <i class="fas fa-search"></i>
            </template>
          </el-input>
        </div>
        
        <!-- 班级筛选框放在右侧 -->
        <div class="filter-box">
          <el-select
            v-model="selectedClass"
            placeholder="选择班级"
            clearable
            @change="handleClassChange"
            style="width: 240px;"
            popper-class="white-select-dropdown"
          >
            <el-option
              v-for="item in classList"
              :key="item.id"
              :label="item.class_name"
              :value="item.id"
            />
          </el-select>
        </div>
      </div>

      <!-- 学生列表表格 -->
      <div class="table-container">
        <el-table
          v-loading="loading"
          :data="studentList"
          stripe
          style="width: 100%"
          :header-cell-style="{ 
            background: '#f5f7fa', 
            color: '#333',
            fontSize: '16px',
            padding: '16px',
            fontWeight: 600
          }"
          :cell-style="{
            fontSize: '15px',
            padding: '16px'
          }"
        >
          <el-table-column prop="student_no" label="学号" min-width="160">
            <template #default="scope">
              <span class="no-wrap">{{ scope.row.student_no }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="real_name" label="姓名" min-width="100" />
          <el-table-column prop="department" label="院系" min-width="150" />
          <el-table-column prop="major" label="专业" min-width="150" />
          <el-table-column prop="grade" label="年级" min-width="90" />
          <el-table-column prop="completed_count" label="已完成题目" min-width="120">
            <template #default="scope">
              <el-tag type="success" size="large">{{ scope.row.completed_count || 0 }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="incomplete_count" label="未完成题目" min-width="120">
            <template #default="scope">
              <el-tag type="info" size="large">{{ scope.row.incomplete_count || 0 }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" min-width="100">
            <template #default="scope">
              <el-tooltip content="题目详细完成信息" placement="top">
                <el-button
                  type="primary"
                  circle
                  size="large"
                  @click="showProblemDetails(scope.row)"
                >
                  <i class="fas fa-chart-bar"></i>
                </el-button>
              </el-tooltip>
            </template>
          </el-table-column>
        </el-table>

        <!-- 分页 -->
        <div class="pagination-container">
          <el-pagination
            background
            layout="total, prev, pager, next, jumper"
            :total="totalStudentsCount"
            :page-size="10"
            :current-page="currentPage"
            @current-change="handleCurrentChange"
          />
        </div>
      </div>
    </div>

    <!-- 题目详情弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="`${currentStudent.real_name || ''} 的题目完成情况`"
      width="70%"
      destroy-on-close
    >
      <div class="problem-details-header">
        <div class="student-info">
          <p><strong>学号:</strong> <span class="no-wrap">{{ currentStudent.student_no }}</span></p>
          <p><strong>姓名:</strong> {{ currentStudent.real_name }}</p>
          <p><strong>班级:</strong> {{ currentStudent.class_name || '未分配' }}</p>
          <p><strong>院系:</strong> {{ currentStudent.department }}</p>
          <p><strong>专业:</strong> {{ currentStudent.major }}</p>
        </div>
        <div class="problem-stats">
          <el-progress
            type="circle"
            :percentage="
              Math.round(
                (currentStudent.completed_count /
                  (currentStudent.completed_count + currentStudent.incomplete_count || 1)) *
                  100
              ) || 0
            "
            :stroke-width="10"
            :width="80"
          />
          <p>完成率</p>
        </div>
      </div>

      <el-table
        v-loading="problemLoading"
        :data="problemList"
        stripe
        style="width: 100%"
        :header-cell-style="{ background: '#f5f7fa', color: '#333' }"
      >
        <el-table-column prop="problem_number" label="题目序号" width="120" />
        <el-table-column prop="title" label="题目标题" />
        <el-table-column prop="difficulty" label="难度" width="100">
          <template #default="scope">
            <el-tag
              :type="
                scope.row.difficulty === '简单'
                  ? 'success'
                  : scope.row.difficulty === '中等'
                  ? 'warning'
                  : 'danger'
              "
            >
              {{ scope.row.difficulty }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="完成状态" width="120">
          <template #default="scope">
            <el-tag
              :type="scope.row.status === 'Accepted' ? 'success' : 'info'"
            >
              {{ scope.row.status === 'Accepted' ? '已完成' : '未完成' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="submission_count" label="提交次数" width="120" />
      </el-table>

      <div class="pagination-container">
        <el-pagination
          background
          layout="total, prev, pager, next"
          :total="totalProblemsCount"
          :page-size="10"
          :current-page="problemCurrentPage"
          @current-change="handleProblemPageChange"
        />
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';
import { ElMessage } from 'element-plus';

// 数据状态
const loading = ref(false);
const problemLoading = ref(false);
const searchQuery = ref('');
const selectedClass = ref('');
const studentList = ref([]);
const classList = ref([]);
const totalStudentsCount = ref(0);
const currentPage = ref(1);
const dialogVisible = ref(false);
const currentStudent = ref({});
const problemList = ref([]);
const totalProblemsCount = ref(0);
const problemCurrentPage = ref(1);
const totalStudents = ref(0);
const totalProblems = ref(0);
const totalClasses = ref(0);

// 获取班级列表
const fetchClassList = async () => {
  try {
    const response = await axios.get('/api/admin/statistics/classes');
    classList.value = response.data.data || [];
    totalClasses.value = classList.value.length || 0;
    
    // 如果有选中的班级，更新显示
    if (selectedClass.value) {
      const selectedClassInfo = classList.value.find(c => c.id === selectedClass.value);
      if (selectedClassInfo) {
        selectedClass.value = selectedClassInfo.id;
      }
    }
  } catch (error) {
    console.error('获取班级列表失败:', error);
    ElMessage.error('获取班级列表失败');
  }
};

// 获取学生列表
const fetchStudentList = async () => {
  loading.value = true;
  try {
    const params = {
      page: currentPage.value,
      pageSize: 10,
      search: searchQuery.value,
      classId: selectedClass.value
    };

    const response = await axios.get('/api/admin/statistics/students', { params });
    studentList.value = response.data.data || [];
    totalStudentsCount.value = response.data.total || 0;
    totalStudents.value = response.data.totalStudents || 0;
    totalProblems.value = response.data.totalProblems || 0;
  } catch (error) {
    console.error('获取学生列表失败:', error);
    ElMessage.error('获取学生列表失败');
  } finally {
    loading.value = false;
  }
};

// 获取题目完成情况
const fetchProblemDetails = async (userId) => {
  problemLoading.value = true;
  try {
    const params = {
      userId,
      page: problemCurrentPage.value,
      pageSize: 10
    };

    const response = await axios.get('/api/admin/statistics/student-problems', { params });
    problemList.value = response.data.data || [];
    totalProblemsCount.value = response.data.total || 0;
  } catch (error) {
    console.error('获取题目完成情况失败:', error);
    ElMessage.error('获取题目完成情况失败');
  } finally {
    problemLoading.value = false;
  }
};

// 事件处理函数
const handleSearch = () => {
  currentPage.value = 1;
  fetchStudentList();
};

const handleClassChange = () => {
  currentPage.value = 1;
  fetchStudentList();
};

const handleCurrentChange = (page) => {
  currentPage.value = page;
  fetchStudentList();
};

const handleProblemPageChange = (page) => {
  problemCurrentPage.value = page;
  fetchProblemDetails(currentStudent.value.user_id);
};

const showProblemDetails = (student) => {
  currentStudent.value = student || {};
  problemCurrentPage.value = 1;
  dialogVisible.value = true;
  fetchProblemDetails(student.user_id);
};

// 生命周期钩子
onMounted(() => {
  fetchClassList();
  fetchStudentList();
});
</script>

<style scoped>
.admin-page {
  min-height: 100vh;
  padding: 20px;
  background-color: #f5f7fa;
  color: #333;
}

.statistics-container {
  max-width: 100%;
  margin: 0 auto;
  padding: 0 20px;
}

.page-title {
  margin-bottom: 24px;
  border-bottom: 1px solid #e4e7ed;
  padding-bottom: 16px;
}

.page-title h1 {
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 8px;
  color: #303133;
}

.page-title p {
  color: #606266;
  font-size: 14px;
}

.search-filter-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 32px 0;
}

.search-box {
  flex: 0 0 auto;
}

.filter-box {
  flex: 0 0 auto;
}

/* 修改Element Plus下拉框的样式为白色主题 */
:deep(.el-select .el-input__wrapper) {
  background-color: #fff !important;
  font-size: 15px !important;
  box-shadow: 0 0 0 1px #dcdfe6 inset !important;
}

:deep(.white-select-dropdown) {
  background-color: #fff !important;
  border: 1px solid #e4e7ed !important;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1) !important;
}

:deep(.white-select-dropdown .el-select-dropdown__item) {
  color: #606266 !important;
  font-size: 15px !important;
  padding: 12px 20px !important;
}

:deep(.white-select-dropdown .el-select-dropdown__item.hover) {
  background-color: #f5f7fa !important;
}

:deep(.white-select-dropdown .el-select-dropdown__item.selected) {
  color: #409EFF !important;
  background-color: #ecf5ff !important;
  font-weight: 600 !important;
}

:deep(.el-input__wrapper) {
  padding: 4px 15px !important;
}

:deep(.el-tag) {
  padding: 6px 16px !important;
  font-size: 14px !important;
}

/* 表格样式调整 */
:deep(.el-table) {
  --el-table-header-bg-color: #f5f7fa;
  --el-table-border-color: #ebeef5;
  --el-table-header-text-color: #333;
  border-radius: 8px;
  overflow: hidden;
}

:deep(.el-table th.el-table__cell) {
  background-color: var(--el-table-header-bg-color);
  border-bottom: 2px solid var(--el-table-border-color);
}

:deep(.el-table__row) {
  height: 60px;
}

:deep(.el-button.is-circle) {
  padding: 12px;
  font-size: 16px;
}

.statistics-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
  margin-bottom: 32px;
}

.stat-card {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  display: flex;
  align-items: center;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border: 1px solid #ebeef5;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
}

.stat-icon {
  font-size: 2.5rem;
  color: #409EFF;
  margin-right: 24px;
  filter: drop-shadow(0 0 5px rgba(64, 158, 255, 0.2));
}

.stat-info h3 {
  font-size: 2rem;
  font-weight: 700;
  margin: 0;
  color: #303133;
}

.stat-info p {
  margin: 8px 0 0;
  color: #606266;
  font-size: 1rem;
}

.table-container {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 24px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border: 1px solid #ebeef5;
}

.pagination-container {
  margin-top: 24px;
  display: flex;
  justify-content: center;
}

.problem-details-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 24px;
  border-bottom: 1px solid #e4e7ed;
}

.student-info {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.student-info p {
  margin: 5px 0;
  color: #606266;
}

.problem-stats {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.problem-stats p {
  margin-top: 12px;
  font-size: 14px;
  color: #606266;
}

.no-wrap {
  white-space: nowrap;
  font-family: monospace;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .statistics-cards {
    grid-template-columns: 1fr;
  }

  .search-filter-container {
    flex-direction: column;
    align-items: stretch;
    gap: 16px;
  }
  
  .search-box, .filter-box {
    width: 100%;
  }
  
  .problem-details-header {
    flex-direction: column;
    gap: 20px;
  }
  
  .student-info {
    grid-template-columns: 1fr;
  }
}
</style> 