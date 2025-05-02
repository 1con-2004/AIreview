<template>
  <div class="card-container">
    <h2 class="card-title">AI互动频率</h2>
    <div class="interaction-stats">
      <div class="stat-item">
        <div class="stat-value">{{ totalInteractions }}</div>
        <div class="stat-label">总互动次数</div>
      </div>
      <div class="stat-item">
        <div class="stat-value">{{ weeklyAverage }}</div>
        <div class="stat-label">周均互动</div>
      </div>
      <div class="stat-item">
        <div class="stat-value">{{ interactionGrowth > 0 ? '+' : '' }}{{ interactionGrowth }}%</div>
        <div class="stat-label">环比增长</div>
      </div>
    </div>
    <div class="main-content">
      <div class="chart-container">
        <div class="chart-header">
          <div class="chart-title">最近7天互动趋势</div>
        </div>
        <div class="chart">
          <div class="chart-bars">
            <div v-for="(day, index) in weeklyData" :key="index" class="chart-bar-wrapper">
              <div class="chart-bar" :style="{ height: (day.count / maxCount * 100) + '%' }"></div>
              <div class="chart-label">{{ day.day }}</div>
            </div>
          </div>
          <div class="chart-grid">
            <div v-for="n in 5" :key="n" class="grid-line" :style="{ bottom: (n * 20) + '%' }">
              <span class="grid-value">{{ Math.floor(maxCount * n / 5) }}</span>
            </div>
          </div>
        </div>
      </div>
      <div class="table-section">
        <h3 class="section-title">交互类型分析</h3>
        <div class="table-container">
          <table class="interaction-table">
            <thead>
              <tr>
                <th>交互类型</th>
                <th>次数</th>
                <th>占比</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in interactionTypes" :key="index">
                <td>{{ item.name }}</td>
                <td>{{ item.count }}</td>
                <td>{{ item.percentage }}%</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="summary-section">
          <div class="summary-item">
            <div class="summary-icon">📈</div>
            <div class="summary-text">AI互动总体呈现 <span class="highlight">上升趋势</span>，请继续保持</div>
          </div>
          <div class="summary-item">
            <div class="summary-icon">🔍</div>
            <div class="summary-text">建议多尝试 <span class="highlight">AI代码分析</span> 功能，提高代码质量</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AIInteractionCard',
  data() {
    return {
      // 硬编码数据
      totalInteractions: 184,
      weeklyAverage: 26.3,
      interactionGrowth: 12.5,
      weeklyData: [
        { day: '周一', count: 12 },
        { day: '周二', count: 18 },
        { day: '周三', count: 15 },
        { day: '周四', count: 22 },
        { day: '周五', count: 30 },
        { day: '周六', count: 8 },
        { day: '周日', count: 5 }
      ],
      interactionTypes: [
        { name: 'AI分析', count: 87, percentage: 47 },
        { name: '代码生成', count: 56, percentage: 30 },
        { name: '问题解答', count: 41, percentage: 23 }
      ]
    }
  },
  computed: {
    maxCount() {
      return Math.max(...this.weeklyData.map(day => day.count));
    }
  }
}
</script>

<style scoped>
.card-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  width: 100%;
}

.card-title {
  font-size: 20px;
  margin-bottom: 20px;
  color: #e0e0e0;
}

.interaction-stats {
  display: flex;
  justify-content: space-between;
  margin-bottom: 25px;
}

.stat-item {
  text-align: center;
  width: 33%;
  background-color: rgba(33, 150, 243, 0.1);
  border-radius: 10px;
  padding: 15px 10px;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #2196F3;
}

.stat-label {
  font-size: 14px;
  color: #a6accd;
  margin-top: 5px;
}

.main-content {
  display: flex;
  flex-grow: 1;
  gap: 25px;
}

.chart-container {
  flex: 1;
  padding: 15px;
  background-color: rgba(255, 255, 255, 0.03);
  border-radius: 10px;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
}

.chart-title {
  font-size: 16px;
  color: #a6accd;
}

.chart {
  height: 180px;
  position: relative;
  margin-bottom: 15px;
}

.chart-bars {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  height: 100%;
  position: relative;
  z-index: 2;
}

.chart-bar-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: calc(100% / 7);
}

.chart-bar {
  width: 60%;
  background-color: #2196F3;
  border-radius: 4px 4px 0 0;
  transition: height 0.3s ease;
}

.chart-label {
  font-size: 12px;
  color: #7b7d8f;
  margin-top: 5px;
}

.chart-grid {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
}

.grid-line {
  position: absolute;
  left: 0;
  width: 100%;
  height: 1px;
  background-color: rgba(255, 255, 255, 0.05);
}

.grid-value {
  position: absolute;
  left: -25px;
  top: -8px;
  font-size: 10px;
  color: #7b7d8f;
}

.table-section {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.section-title {
  font-size: 16px;
  color: #a6accd;
  margin-bottom: 15px;
}

.table-container {
  margin-bottom: 20px;
  flex-grow: 0;
}

.interaction-table {
  width: 100%;
  border-collapse: collapse;
}

.interaction-table th,
.interaction-table td {
  padding: 12px;
  text-align: left;
  font-size: 14px;
  border-bottom: 1px solid #2d2d3d;
}

.interaction-table th {
  color: #e0e0e0;
  font-weight: 500;
}

.interaction-table td {
  color: #a6accd;
}

.summary-section {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  gap: 15px;
  background-color: rgba(255, 255, 255, 0.03);
  border-radius: 10px;
  padding: 15px;
}

.summary-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.summary-icon {
  font-size: 24px;
}

.summary-text {
  font-size: 14px;
  color: #a6accd;
  line-height: 1.5;
}

.highlight {
  color: #2196F3;
  font-weight: 500;
}

@media (max-width: 1200px) {
  .main-content {
    flex-direction: column;
  }
  
  .chart-container,
  .table-section {
    width: 100%;
  }
  
  .chart {
    height: 150px;
  }
}
</style> 