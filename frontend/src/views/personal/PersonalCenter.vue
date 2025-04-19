<template>
  <div class="personal-center">
    <nav-bar></nav-bar>
    
    <!-- 学生信息验证失败的提示 -->
    <div v-if="!loading && !isStudent" class="student-notice">
      <div class="notice-content">
        <i class="fas fa-exclamation-circle notice-icon"></i>
        <h2>访问受限</h2>
        <p>{{ message || '您并未登记学生信息，请联系管理员添加' }}</p>
        <router-link to="/home" class="back-home-btn">
          <i class="fas fa-home"></i>
          返回主页
        </router-link>
      </div>
    </div>

    <!-- 主要内容区域 - 仅对学生显示 -->
    <div v-if="isStudent" class="content-container">
      <!-- 个人信息区域 -->
      <div class="profile-section">
        <div class="profile-header">
          <div class="profile-avatar">
            <i class="fas fa-user-graduate"></i>
          </div>
          <div class="profile-info">
            <h2>{{ studentInfo.real_name }}</h2>
            <div class="info-items">
              <div class="info-item">
                <i class="fas fa-id-badge"></i>
                <span>学号: {{ studentInfo.student_no }}</span>
              </div>
              <div class="info-item">
                <i class="fas fa-university"></i>
                <span>院系: {{ studentInfo.department }}</span>
              </div>
              <div class="info-item">
                <i class="fas fa-graduation-cap"></i>
                <span>专业: {{ studentInfo.major }}</span>
              </div>
              <div class="info-item">
                <i class="fas fa-user-clock"></i>
                <span>年级: {{ studentInfo.grade }}</span>
              </div>
            </div>
          </div>
          <div class="completion-stats">
            <el-progress
              type="circle"
              :percentage="
                Math.round(
                  (completionData?.completed_problems /
                    (completionData?.total_problems || 1)) *
                    100
                ) || 0
              "
              :stroke-width="10"
              :width="80"
              :color="'#67C23A'"
            />
            <p class="completion-text">题目完成率</p>
          </div>
        </div>
      </div>

      <!-- 统计图表区域 -->
      <div class="charts-container">
        <div class="charts-row">
          <!-- 左侧图表 -->
          <div class="chart-column">
            <div class="chart-card">
              <h3>题目完成情况</h3>
              <div id="completionPieChart" class="chart"></div>
            </div>
            <div class="chart-card">
              <h3>提交错误类型分析</h3>
              <div id="errorTypePieChart" class="chart"></div>
            </div>
          </div>
          
          <!-- 右侧图表 -->
          <div class="chart-column">
            <div class="chart-card">
              <h3>知识点掌握情况</h3>
              <div id="knowledgeRadarChart" class="chart"></div>
            </div>
            <div class="chart-card">
              <h3>解题用时分析</h3>
              <div id="solvingTimeBoxChart" class="chart"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- 题目完成状态表格 -->
      <div class="table-container">
        <h2 class="section-title">题目完成状态</h2>
        <el-table
          v-loading="problemLoading"
          :data="problemList"
          stripe
          style="width: 100%"
          :header-cell-style="{
            background: '#2c2e3b',
            color: '#e6edf3',
            fontSize: '16px',
            padding: '8px 16px',
            fontWeight: 600,
            whiteSpace: 'nowrap'
          }"
          :cell-style="{
            fontSize: '15px',
            padding: '8px 16px',
            color: '#a6accd',
            background: '#1e1e2e',
            textAlign: 'center'
          }"
          :row-style="{
            background: '#252734'
          }"
          :row-class-name="rowClassName"
        >
          <el-table-column prop="problem_number" label="题目序号" width="120" align="center" />
          <el-table-column prop="title" label="题目标题" align="left" />
          <el-table-column prop="difficulty" label="难度" width="100" align="center">
            <template #default="scope">
              <el-tag
                :type="
                  scope.row.difficulty === '简单'
                    ? 'success'
                    : scope.row.difficulty === '中等'
                    ? 'warning'
                    : 'danger'
                "
                effect="plain"
                size="small"
              >
                {{ scope.row.difficulty }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="完成状态" width="120" align="center">
            <template #default="scope">
              <el-tag
                :type="scope.row.status === 'Accepted' ? 'success' : 'info'"
                effect="light"
              >
                {{ scope.row.status === 'Accepted' ? '已完成' : '未完成' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="submission_count" label="提交次数" width="120" align="center" />
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
      </div>
    </div>

    <!-- 加载中 -->
    <div v-if="loading" class="loading-container">
      <el-spin :size="32" />
      <p>加载中...</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, onUnmounted } from 'vue';
import NavBar from '@/components/NavBar.vue';
import axios from 'axios';
import { ElMessage } from 'element-plus';
import * as echarts from 'echarts';

// 数据状态
const loading = ref(true);
const isStudent = ref(false);
const studentInfo = ref({});
const message = ref('');
const problemLoading = ref(false);
const problemList = ref([]);
const totalProblemsCount = ref(0);
const problemCurrentPage = ref(1);

// 图表数据状态
const completionData = ref(null);
const errorTypeData = ref(null);
const knowledgeData = ref(null);
const solvingTimeData = ref(null);

// 存储图表实例的引用
const charts = ref({
  completionChart: null,
  errorTypeChart: null,
  knowledgeChart: null,
  solvingTimeChart: null
});

// 检查用户是否为学生
const checkIsStudent = async () => {
  try {
    const response = await axios.get('/api/user/profile/check-student');
    isStudent.value = response.data.isStudent;
    studentInfo.value = response.data.studentInfo || {};
    
    if (isStudent.value) {
      await fetchUserData();
      await fetchProblemList();
    }
  } catch (error) {
    console.error('检查用户是否为学生失败:', error);
    message.value = error.response?.data?.message || '检查用户身份失败，请稍后再试';
    isStudent.value = false;
  } finally {
    loading.value = false;
  }
};

// 获取用户统计数据
const fetchUserData = async () => {
  try {
    // 并行请求所有数据
    const [completionResponse, knowledgeResponse, errorTypeResponse, solvingTimeResponse] = await Promise.all([
      axios.get('/api/user/profile/completion'),
      axios.get('/api/user/profile/knowledge'),
      axios.get('/api/user/profile/error-types'),
      axios.get('/api/user/profile/solving-time')
    ]);

    completionData.value = completionResponse.data.data;
    knowledgeData.value = knowledgeResponse.data.data;
    errorTypeData.value = errorTypeResponse.data.data;
    solvingTimeData.value = solvingTimeResponse.data.data;

    // 初始化图表
    nextTick(() => {
      initCharts();
    });
  } catch (error) {
    console.error('获取用户统计数据失败:', error);
    ElMessage.error('获取统计数据失败，请稍后再试');
  }
};

// 获取题目列表
const fetchProblemList = async () => {
  problemLoading.value = true;
  try {
    const response = await axios.get('/api/user/profile/problems', {
      params: {
        page: problemCurrentPage.value,
        pageSize: 10
      }
    });
    
    problemList.value = response.data.data || [];
    totalProblemsCount.value = response.data.total || 0;
  } catch (error) {
    console.error('获取题目列表失败:', error);
    ElMessage.error('获取题目列表失败，请稍后再试');
  } finally {
    problemLoading.value = false;
  }
};

// 初始化图表
const initCharts = () => {
  // 销毁之前的图表实例
  Object.values(charts.value).forEach(chart => {
    if (chart) {
      chart.dispose();
    }
  });

  // 确保 DOM 元素存在后再初始化图表
  const completionElement = document.getElementById('completionPieChart');
  const errorTypeElement = document.getElementById('errorTypePieChart');
  const knowledgeElement = document.getElementById('knowledgeRadarChart');
  const solvingTimeElement = document.getElementById('solvingTimeBoxChart');

  // 只在 DOM 元素存在时初始化图表
  if (completionElement) {
    charts.value.completionChart = echarts.init(completionElement);
  }
  if (errorTypeElement) {
    charts.value.errorTypeChart = echarts.init(errorTypeElement);
  }
  if (knowledgeElement) {
    charts.value.knowledgeChart = echarts.init(knowledgeElement);
  }
  if (solvingTimeElement) {
    charts.value.solvingTimeChart = echarts.init(solvingTimeElement);
  }

  // 设置题目完成情况饼图
  if (completionData.value && charts.value.completionChart) {
    const pieData = [
      { name: '已完成', value: completionData.value.completed_problems },
      { name: '未尝试', value: completionData.value.not_attempted_problems },
      { name: '失败', value: completionData.value.failed_problems }
    ];

    const colorPalette = ['#67C23A', '#409EFF', '#F56C6C'];

    charts.value.completionChart.setOption({
      backgroundColor: 'transparent',
      color: colorPalette,
      tooltip: { 
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c} ({d}%)',
        backgroundColor: 'rgba(50, 50, 50, 0.9)',
        borderColor: '#555',
        textStyle: {
          color: '#fff'
        }
      },
      legend: { 
        orient: 'vertical', 
        left: 'left',
        textStyle: {
          color: '#e6edf3'
        }
      },
      series: [{
        name: '题目完成情况',
        type: 'pie',
        radius: '50%',
        data: pieData,
        emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } },
        label: {
          color: '#ffffff',
          formatter: '{b}: {d}%'
        },
        labelLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.5)'
          }
        }
      }]
    });
  }

  // 设置错误类型分析饼图
  if (errorTypeData.value && charts.value.errorTypeChart) {
    const errorData = errorTypeData.value.map(item => ({
      name: item.error_type,
      value: item.count
    }));

    const colorPalette = ['#F56C6C', '#E6A23C', '#409EFF', '#67C23A', '#909399', '#FFEB3B'];

    charts.value.errorTypeChart.setOption({
      backgroundColor: 'transparent',
      color: colorPalette,
      tooltip: { 
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c} ({d}%)',
        backgroundColor: 'rgba(50, 50, 50, 0.9)',
        borderColor: '#555',
        textStyle: {
          color: '#fff'
        }
      },
      legend: { 
        orient: 'vertical', 
        left: 'left',
        textStyle: {
          color: '#e6edf3'
        },
        formatter: function(name) {
          // 如果名称太长，截断并加上省略号
          return name.length > 8 ? name.substring(0, 8) + '...' : name;
        }
      },
      series: [{
        name: '错误类型',
        type: 'pie',
        radius: '50%',
        data: errorData,
        emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } },
        label: {
          color: '#ffffff',
          formatter: '{b}: {d}%'
        },
        labelLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.5)'
          }
        }
      }]
    });
  }

  // 设置知识点掌握情况雷达图
  if (knowledgeData.value && charts.value.knowledgeChart) {
    const data = knowledgeData.value;
    const indicators = data.map(item => ({
      name: item.knowledge_point,
      max: 100
    }));
    const values = data.map(item => item.mastery_percentage);

    charts.value.knowledgeChart.setOption({
      backgroundColor: 'transparent',
      tooltip: { 
        trigger: 'axis',
        backgroundColor: 'rgba(50, 50, 50, 0.9)',
        borderColor: '#555',
        textStyle: {
          color: '#fff'
        }
      },
      radar: {
        indicator: indicators,
        shape: 'circle',
        center: ['50%', '50%'],
        radius: '60%',
        splitNumber: 5,
        axisName: {
          color: '#e6edf3',
          formatter: function(value) {
            if(value.length > 6) {
              return value.substring(0, 6) + '...';
            }
            return value;
          }
        },
        splitArea: {
          show: true,
          areaStyle: {
            color: ['rgba(255, 255, 255, 0.05)', 'rgba(255, 255, 255, 0.1)']
          }
        },
        splitLine: {
          show: true,
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.2)'
          }
        },
        axisLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.3)'
          }
        }
      },
      series: [{
        type: 'radar',
        data: [{
          value: values,
          name: '知识点掌握度',
          symbolSize: 4,
          lineStyle: {
            width: 2,
            color: '#409EFF'
          },
          areaStyle: {
            opacity: 0.3,
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(64, 158, 255, 0.7)' },
              { offset: 1, color: 'rgba(64, 158, 255, 0.1)' }
            ])
          },
          label: {
            show: true,
            formatter: '{c}%',
            color: '#fff'
          }
        }]
      }]
    });
  }

  // 设置解题用时分析柱状图
  if (solvingTimeData.value && charts.value.solvingTimeChart) {
    const data = solvingTimeData.value;
    charts.value.solvingTimeChart.setOption({
      backgroundColor: 'transparent',
      tooltip: { 
        trigger: 'axis',
        backgroundColor: 'rgba(50, 50, 50, 0.9)',
        borderColor: '#555',
        textStyle: {
          color: '#fff'
        }
      },
      xAxis: {
        type: 'category',
        data: data.map(item => item.difficulty),
        axisLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.3)'
          }
        },
        axisLabel: {
          color: '#e6edf3'
        }
      },
      yAxis: { 
        type: 'value', 
        name: '解题时间（分钟）',
        nameTextStyle: {
          color: '#e6edf3'
        },
        axisLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.3)'
          }
        },
        axisLabel: {
          color: '#e6edf3'
        },
        splitLine: {
          lineStyle: {
            color: 'rgba(255, 255, 255, 0.1)'
          }
        }
      },
      series: [
        {
          name: '平均用时',
          type: 'bar',
          data: data.map(item => item.avg_time),
          itemStyle: {
            color: function(params) {
              const colors = {
                '简单': '#67C23A',
                '中等': '#E6A23C',
                '困难': '#F56C6C'
              };
              return colors[params.name] || '#409EFF';
            }
          },
          label: {
            show: true,
            position: 'top',
            formatter: '{c} 分钟',
            color: '#e6edf3'
          }
        }
      ]
    });
  }
};

// 事件处理函数
const handleResize = () => {
  Object.values(charts.value).forEach(chart => {
    if (chart && typeof chart.resize === 'function') {
      chart.resize();
    }
  });
};

// 处理题目列表分页变化
const handleProblemPageChange = (page) => {
  problemCurrentPage.value = page;
  fetchProblemList();
};

// 生命周期钩子
onMounted(() => {
  checkIsStudent();
  window.addEventListener('resize', handleResize);
});

// 表格行样式
const rowClassName = ({ rowIndex }) => {
  return rowIndex % 2 === 0 ? 'dark-row' : 'darker-row';
};

// 组件卸载时移除事件监听
onUnmounted(() => {
  window.removeEventListener('resize', handleResize);
  Object.values(charts.value).forEach(chart => {
    if (chart) {
      chart.dispose();
    }
  });
});
</script>

<style scoped>
.personal-center {
  min-height: 100vh;
  background-color: #0d1117;
  color: white;
}

.content-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
}

.student-notice {
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
  color: #f56c6c;
  margin-bottom: 1.5rem;
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

.profile-section {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 24px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.profile-header {
  display: flex;
  align-items: center;
}

.profile-avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: rgba(33, 150, 243, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 24px;
  font-size: 30px;
  color: #2196f3;
}

.profile-info {
  flex: 1;
}

.profile-info h2 {
  font-size: 24px;
  margin-bottom: 16px;
  color: #e6edf3;
}

.info-items {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}

.info-item {
  display: flex;
  align-items: center;
  color: #a6accd;
}

.info-item i {
  margin-right: 8px;
  color: #2196f3;
}

.completion-stats {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-left: 24px;
}

.completion-text {
  margin-top: 12px;
  color: #67C23A;
  font-weight: bold;
}

.charts-container {
  margin: 24px 0;
}

.charts-row {
  display: flex;
  gap: 24px;
  margin-bottom: 24px;
}

.chart-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.chart-card {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.chart-card h3 {
  margin: 0 0 16px 0;
  color: #e6edf3;
  font-size: 18px;
  font-weight: 600;
}

.chart {
  height: 300px;
  width: 100%;
}

.table-container {
  background: #1e1e2e;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.2);
  margin-bottom: 24px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.section-title {
  font-size: 20px;
  font-weight: 600;
  color: #e6edf3;
  margin-top: 0;
  margin-bottom: 24px;
}

.pagination-container {
  margin-top: 24px;
  display: flex;
  justify-content: center;
}

.loading-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 70px);
  color: #e6edf3;
}

/* 响应式调整 */
@media (max-width: 992px) {
  .charts-row {
    flex-direction: column;
  }
  
  .profile-header {
    flex-direction: column;
    text-align: center;
  }
  
  .profile-avatar {
    margin-right: 0;
    margin-bottom: 20px;
  }
  
  .profile-info {
    margin-bottom: 20px;
  }
  
  .info-items {
    grid-template-columns: 1fr;
  }
  
  .completion-stats {
    margin-left: 0;
  }
}

.el-table {
  --el-table-border-color: #30363d;
  --el-table-border: 1px solid var(--el-table-border-color);
  --el-table-text-color: #e6edf3;
  --el-table-header-text-color: #e6edf3;
  --el-table-row-hover-background-color: #2d3748;
  
  border-radius: 8px;
  overflow: hidden;
  border: var(--el-table-border);
}

.dark-row {
  background-color: #252734 !important;
}

.darker-row {
  background-color: #1e1e2e !important;
}

.el-table__body tr:hover > td {
  background-color: #2d3748 !important;
}

.el-pagination {
  margin-top: 20px;
  --el-pagination-bg-color: #252734;
  --el-pagination-text-color: #e6edf3;
  --el-pagination-button-color: #a6accd;
  --el-pagination-hover-color: #409EFF;
}

/* 确保表格内容居中 */
.el-table .cell {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style> 