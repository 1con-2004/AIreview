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

      <!-- 系统整体统计图表 -->
      <div class="system-statistics">
        <h2 class="section-title">系统整体统计</h2>
        <div class="charts-row">
          <div class="chart-column">
            <div class="chart-card">
              <h3>题目难度分布</h3>
              <div id="difficultyDistChart" class="chart"></div>
            </div>
            <div class="chart-card">
              <h3>题目完成率排行</h3>
              <div id="completionRankChart" class="chart"></div>
            </div>
          </div>
          <div class="chart-column">
            <div class="chart-card">
              <h3>题目分类分布</h3>
              <div id="categoryTreeChart" class="chart"></div>
            </div>
            <div class="chart-card">
              <h3>难度分布柱状图</h3>
              <div id="difficultyBarChart" class="chart"></div>
            </div>
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
      width="90%"
      destroy-on-close
      @close="handleDialogClose"
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

      <!-- 图表展示区域 -->
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
        
        <div class="charts-row">
          <div class="chart-card full-width">
            <h3>每日提交数量趋势</h3>
            <div id="dailySubmissionChart" class="chart"></div>
          </div>
        </div>
        
        <div class="charts-row">
          <div class="chart-card full-width">
            <h3>提交时间分布</h3>
            <div id="submissionHeatmap" class="chart"></div>
          </div>
        </div>
      </div>

      <el-table
        v-loading="problemLoading"
        :data="problemList"
        stripe
        style="width: 100%; margin-top: 20px;"
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
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue';
import axios from 'axios';
import { ElMessage } from 'element-plus';
import * as echarts from 'echarts';

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

// 图表数据状态
const completionData = ref(null);
const errorTypeData = ref(null);
const knowledgeData = ref(null);
const dailySubmissionData = ref(null);
const submissionTimeData = ref(null);
const solvingTimeData = ref(null);
const systemChartData = ref({
  difficultyDist: null,
  categoryTree: null,
  completionRank: null,
  difficultyBar: null
});

// 存储图表实例的引用
const charts = ref({
  completionChart: null,
  errorTypeChart: null,
  knowledgeChart: null,
  dailySubmissionChart: null,
  submissionHeatmap: null,
  solvingTimeChart: null,
  // 系统图表
  difficultyDistChart: null,
  categoryTreeChart: null,
  completionRankChart: null,
  difficultyBarChart: null
});

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

// 获取图表数据的函数
const fetchChartData = async (userId) => {
  try {
    // 获取题目完成情况数据
    const completionResponse = await axios.get(`/api/admin/statistics/student-completion/${userId}`);
    completionData.value = completionResponse.data;

    // 获取错误类型分析数据
    const errorTypeResponse = await axios.get(`/api/admin/statistics/student-error-types/${userId}`);
    errorTypeData.value = errorTypeResponse.data;

    // 获取知识点掌握情况数据
    const knowledgeResponse = await axios.get(`/api/admin/statistics/student-knowledge/${userId}`);
    knowledgeData.value = knowledgeResponse.data;

    // 获取每日提交数量数据
    const dailySubmissionResponse = await axios.get(`/api/admin/statistics/student-daily-submissions/${userId}`);
    dailySubmissionData.value = dailySubmissionResponse.data;

    // 获取提交时间分布数据
    const submissionTimeResponse = await axios.get(`/api/admin/statistics/student-submission-time/${userId}`);
    submissionTimeData.value = submissionTimeResponse.data;

    // 获取解题用时数据
    const solvingTimeResponse = await axios.get(`/api/admin/statistics/student-solving-time/${userId}`);
    solvingTimeData.value = solvingTimeResponse.data;

    // 初始化图表
    initCharts();
  } catch (error) {
    console.error('获取图表数据失败:', error);
    ElMessage.error('获取图表数据失败');
  }
};

// 获取系统整体统计数据
const fetchSystemChartData = async () => {
  try {
    // 获取题目难度分布数据
    const difficultyResponse = await axios.get('/api/admin/statistics/difficulty-distribution');
    systemChartData.value.difficultyDist = difficultyResponse.data;

    // 获取题目分类树状图数据
    const categoryResponse = await axios.get('/api/admin/statistics/category-tree');
    systemChartData.value.categoryTree = categoryResponse.data;

    // 获取题目完成率排行数据
    const completionResponse = await axios.get('/api/admin/statistics/completion-rank');
    systemChartData.value.completionRank = completionResponse.data;

    // 获取难度分布柱状图数据
    const difficultyBarResponse = await axios.get('/api/admin/statistics/difficulty-bar');
    systemChartData.value.difficultyBar = difficultyBarResponse.data;

    // 初始化系统图表
    initSystemCharts();
  } catch (error) {
    console.error('获取系统统计数据失败:', error);
    ElMessage.error('获取系统统计数据失败');
  }
};

// 修改初始化图表的函数
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
  const dailySubmissionElement = document.getElementById('dailySubmissionChart');
  const submissionHeatmapElement = document.getElementById('submissionHeatmap');
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
  if (dailySubmissionElement) {
    charts.value.dailySubmissionChart = echarts.init(dailySubmissionElement);
  }
  if (submissionHeatmapElement) {
    charts.value.submissionHeatmap = echarts.init(submissionHeatmapElement);
  }
  if (solvingTimeElement) {
    charts.value.solvingTimeChart = echarts.init(solvingTimeElement);
  }

  // 设置图表配置项
  if (completionData.value && charts.value.completionChart) {
    const pieData = [
      { name: '已完成', value: completionData.value.data.completed_problems },
      { name: '未尝试', value: completionData.value.data.not_attempted_problems },
      { name: '失败', value: completionData.value.data.failed_problems }
    ];

    charts.value.completionChart.setOption({
      tooltip: { trigger: 'item' },
      legend: { orient: 'vertical', left: 'left' },
      series: [{
        name: '题目完成情况',
        type: 'pie',
        radius: '50%',
        data: pieData,
        emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } }
      }]
    });
  }

  if (errorTypeData.value && charts.value.errorTypeChart) {
    const errorData = errorTypeData.value.data.map(item => ({
      name: item.error_type,
      value: item.count
    }));

    charts.value.errorTypeChart.setOption({
      tooltip: { trigger: 'item' },
      legend: { orient: 'vertical', left: 'left' },
      series: [{
        name: '错误类型',
        type: 'pie',
        radius: '50%',
        data: errorData,
        emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } }
      }]
    });
  }

  if (knowledgeData.value && charts.value.knowledgeChart) {
    const data = knowledgeData.value.data;
    const indicators = data.map(item => ({
      name: item.knowledge_point,
      max: 100
    }));
    const values = data.map(item => item.mastery_percentage);

    charts.value.knowledgeChart.setOption({
      tooltip: { trigger: 'axis' },
      radar: {
        indicator: indicators,
        shape: 'circle',  // 添加形状配置
        center: ['50%', '50%'],  // 添加中心点位置
        radius: '60%',    // 添加半径大小
        splitNumber: 5,   // 添加分割段数
        axisName: {
          color: '#333'
        },
        splitArea: {
          show: true,
          areaStyle: {
            color: ['#f5f7fa', '#e4e7ed']
          }
        },
        splitLine: {
          show: true,
          lineStyle: {
            color: '#dcdfe6'
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
            width: 2
          },
          areaStyle: {
            opacity: 0.3
          }
        }]
      }]
    });
  }

  if (dailySubmissionData.value && charts.value.dailySubmissionChart) {
    const data = dailySubmissionData.value.data;
    charts.value.dailySubmissionChart.setOption({
      tooltip: { 
        trigger: 'axis',
        axisPointer: {
          type: 'cross',
          label: {
            backgroundColor: '#6a7985'
          }
        }
      },
      legend: {
        data: ['总提交次数', '通过的提交'],
        top: 10
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
      },
      xAxis: { 
        type: 'category',
        boundaryGap: false,
        data: data.map(item => {
          const date = new Date(item.date);
          return `${date.getMonth() + 1}月${date.getDate()}日`;
        })
      },
      yAxis: { 
        type: 'value',
        name: '提交次数'
      },
      series: [
        {
          name: '总提交次数',
          type: 'line',
          data: data.map(item => item.total_submissions),
          smooth: true,
          itemStyle: {
            color: '#409EFF'
          }
        },
        {
          name: '通过的提交',
          type: 'line',
          data: data.map(item => item.accepted_submissions),
          smooth: true,
          itemStyle: {
            color: '#67C23A'
          }
        }
      ]
    });
  }

  if (submissionTimeData.value && charts.value.submissionHeatmap) {
    const data = submissionTimeData.value.data;
    const hours = Array.from({ length: 24 }, (_, i) => i);
    const submissionCounts = hours.map(hour => {
      const hourData = data.find(item => item.hour === hour);
      return hourData ? hourData.submission_count : 0;
    });

    charts.value.submissionHeatmap.setOption({
      tooltip: {
        trigger: 'axis',
        formatter: function(params) {
          return `${params[0].name}<br/>提交次数：${params[0].value}`;
        }
      },
      title: {
        text: '24小时提交分布',
        left: 'center',
        top: 10,
        textStyle: {
          color: '#303133',
          fontSize: 14
        }
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        top: '60px',
        containLabel: true
      },
      xAxis: {
        type: 'category',
        data: hours.map(h => h.toString()),
        name: '时间(点)',
        axisLabel: {
          formatter: '{value}'
        }
      },
      yAxis: { 
        type: 'value',
        name: '提交次数',
        minInterval: 1
      },
      series: [{
        name: '提交次数',
        type: 'bar',
        data: submissionCounts,
        itemStyle: {
          color: '#409EFF'
        },
        barWidth: '60%',
        label: {
          show: true,
          position: 'top',
          formatter: '{c}次'
        }
      }]
    });
  }

  if (solvingTimeData.value && charts.value.solvingTimeChart) {
    const data = solvingTimeData.value.data;
    charts.value.solvingTimeChart.setOption({
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: data.map(item => item.difficulty)
      },
      yAxis: { type: 'value', name: '解题时间（分钟）' },
      series: [
        {
          name: '平均用时',
          type: 'bar',
          data: data.map(item => item.avg_time)
        }
      ]
    });
  }
};

// 初始化系统图表
const initSystemCharts = () => {
  // 初始化题目难度分布图
  if (systemChartData.value.difficultyDist) {
    const difficultyDistElement = document.getElementById('difficultyDistChart');
    if (difficultyDistElement) {
      charts.value.difficultyDistChart = echarts.init(difficultyDistElement);
      charts.value.difficultyDistChart.setOption({
        tooltip: { trigger: 'item' },
        legend: { orient: 'vertical', left: 'left' },
        series: [{
          name: '题目难度分布',
          type: 'pie',
          radius: '50%',
          data: systemChartData.value.difficultyDist.data,
          emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } }
        }]
      });
    }
  }

  // 初始化题目分类树状图
  if (systemChartData.value.categoryTree) {
    const categoryTreeElement = document.getElementById('categoryTreeChart');
    if (categoryTreeElement) {
      charts.value.categoryTreeChart = echarts.init(categoryTreeElement);
      charts.value.categoryTreeChart.setOption({
        tooltip: { trigger: 'item', formatter: '{b}: {c}题' },
        series: [{
          type: 'tree',
          data: [systemChartData.value.categoryTree.data],
          top: '10%',
          left: '8%',
          bottom: '10%',
          right: '8%',
          symbolSize: 7,
          label: {
            position: 'left',
            verticalAlign: 'middle',
            align: 'right'
          },
          leaves: {
            label: {
              position: 'right',
              verticalAlign: 'middle',
              align: 'left'
            }
          },
          emphasis: {
            focus: 'descendant'
          },
          expandAndCollapse: true,
          animationDuration: 550,
          animationDurationUpdate: 750
        }]
      });
    }
  }

  // 初始化题目完成率排行图
  if (systemChartData.value.completionRank) {
    const completionRankElement = document.getElementById('completionRankChart');
    if (completionRankElement) {
      charts.value.completionRankChart = echarts.init(completionRankElement);
      const data = systemChartData.value.completionRank.data;
      
      const tooltipFormatter = (params) => {
        const item = data[params[0].dataIndex];
        return `
          <div style="padding: 8px">
            <h4 style="margin: 0 0 8px">${item.title}</h4>
            <p style="margin: 4px 0">题号: ${item.problem_number}</p>
            <p style="margin: 4px 0">难度: ${item.difficulty}</p>
            <p style="margin: 4px 0">完成率: ${item.completion_rate}%</p>
            <p style="margin: 4px 0">提交次数: ${item.total_submissions}</p>
            <p style="margin: 4px 0">通过次数: ${item.accepted_submissions}</p>
            <p style="margin: 8px 0 4px; color: #666">${item.analysis}</p>
          </div>
        `;
      };

      const getBarColor = (item) => {
        if (item.total_submissions < 50) return '#909399';
        if (item.completion_rate >= 90) return '#67C23A';
        if (item.completion_rate >= 70) return '#E6A23C';
        return '#F56C6C';
      };

      const labelFormatter = (params) => {
        const item = data[params.dataIndex];
        return `${item.completion_rate}% (${item.accepted_submissions}/${item.total_submissions})`;
      };

      charts.value.completionRankChart.setOption({
        tooltip: {
          trigger: 'axis',
          axisPointer: { type: 'shadow' },
          formatter: tooltipFormatter
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'value',
          name: '完成率(%)',
          max: 100,
          axisLabel: {
            formatter: '{value}%'
          }
        },
        yAxis: {
          type: 'category',
          data: data.map(item => item.title),
          axisLabel: {
            formatter: (value) => {
              const item = data.find(d => d.title === value);
              return `${item.title} (${item.submission_level})`;
            }
          }
        },
        series: [{
          name: '完成率',
          type: 'bar',
          data: data.map(item => ({
            value: item.completion_rate,
            itemStyle: {
              color: getBarColor(item)
            }
          })),
          label: {
            show: true,
            position: 'right',
            formatter: labelFormatter
          }
        }]
      });
    }
  }

  // 初始化难度分布柱状图
  if (systemChartData.value.difficultyBar) {
    const difficultyBarElement = document.getElementById('difficultyBarChart');
    if (difficultyBarElement) {
      charts.value.difficultyBarChart = echarts.init(difficultyBarElement);
      charts.value.difficultyBarChart.setOption({
        tooltip: {
          trigger: 'axis',
          axisPointer: { type: 'shadow' }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: ['简单', '中等', '困难']
        },
        yAxis: {
          type: 'value',
          name: '题目数量'
        },
        series: [{
          name: '题目数量',
          type: 'bar',
          data: systemChartData.value.difficultyBar.data,
          itemStyle: {
            color: function(params) {
              const colors = {
                '简单': '#67C23A',
                '中等': '#E6A23C',
                '困难': '#F56C6C'
              };
              return colors[params.name] || '#409EFF';
            }
          }
        }]
      });
    }
  }
};

// 修改 handleResize 函数
const handleResize = () => {
  Object.values(charts.value).forEach(chart => {
    if (chart && typeof chart.resize === 'function') {  // 确保图表实例存在且resize方法可用
      try {
        const option = chart.getOption();
        if (option && Object.keys(option).length > 0) {  // 确保图表配置存在且不为空
          chart.resize();
        }
      } catch (error) {
        console.warn('图表重置大小时发生错误:', error);
      }
    }
  });
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

const showProblemDetails = async (student) => {
  currentStudent.value = student || {};
  problemCurrentPage.value = 1;
  dialogVisible.value = true;
  
  try {
    // 等待数据加载完成
    await Promise.all([
      fetchProblemDetails(student.user_id),
      fetchChartData(student.user_id)
    ]);
    
    // 使用 nextTick 确保 DOM 已更新
    nextTick(() => {
      try {
        // 检查DOM元素是否存在
        const elements = [
          'completionPieChart',
          'errorTypePieChart',
          'knowledgeRadarChart',
          'dailySubmissionChart',
          'submissionHeatmap',
          'solvingTimeBoxChart'
        ];
        
        const missingElements = elements.filter(id => !document.getElementById(id));
        if (missingElements.length > 0) {
          console.warn('部分图表容器未找到:', missingElements);
          return;
        }
        
        initCharts();
      } catch (error) {
        console.error('初始化图表时发生错误:', error);
        ElMessage.error('初始化图表失败，请刷新页面重试');
      }
    });
  } catch (error) {
    console.error('加载学生详情数据失败:', error);
    ElMessage.error('加载学生详情数据失败');
  }
};

// 监听弹窗关闭事件，重新初始化系统图表
const handleDialogClose = () => {
  // 使用nextTick确保DOM已更新
  nextTick(() => {
    // 重新初始化系统图表
    initSystemCharts();
  });
};

// 生命周期钩子
onMounted(() => {
  window.addEventListener('resize', handleResize);
  fetchClassList();
  fetchStudentList();
  fetchSystemChartData(); // 添加系统图表数据获取
});

// 组件卸载时移除窗口大小变化监听并销毁图表实例
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

.charts-container {
  margin: 20px 0;
}

.charts-row {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.chart-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.chart-card {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.chart-card h3 {
  margin: 0 0 15px 0;
  color: #303133;
  font-size: 16px;
  font-weight: 600;
}

.chart {
  height: 300px;
  width: 100%;
}

.full-width {
  width: 100%;
}

/* 响应式布局调整 */
@media (max-width: 1200px) {
  .charts-row {
    flex-direction: column;
  }
  
  .chart-column {
    width: 100%;
  }
}

.section-title {
  font-size: 20px;
  font-weight: 600;
  color: #303133;
  margin: 20px 0;
  padding-bottom: 10px;
  border-bottom: 1px solid #e4e7ed;
}

.system-statistics {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 24px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border: 1px solid #ebeef5;
}
</style> 