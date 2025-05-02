<template>
  <div class="card-container">
    <h2 class="card-title">语言偏好分析</h2>
    <div class="card-content">
      <div class="chart-section">
        <div class="pie-chart">
          <div class="pie-segments">
            <div v-for="(item, index) in pieData" :key="index" 
                class="pie-segment" 
                :style="getPieSegmentStyle(index)">
            </div>
          </div>
          <div class="pie-center">{{ totalSubmissions }}次</div>
        </div>
        <div class="legend">
          <div v-for="(item, index) in pieData" :key="index" class="legend-item">
            <div class="legend-color" :style="{ backgroundColor: item.color }"></div>
            <div class="legend-label">{{ item.name }}</div>
            <div class="legend-value">{{ item.value }}次 ({{ item.percentage }}%)</div>
          </div>
        </div>
      </div>
      <div class="details-section">
        <h3 class="section-title">语言使用详情</h3>
        <div class="language-details">
          <div class="language-item" v-for="(item, index) in pieData" :key="index">
            <div class="language-header">
              <div class="language-name">{{ item.name }}</div>
              <div class="language-percent">{{ item.percentage }}%</div>
            </div>
            <div class="language-progress">
              <div class="progress-bar" :style="{ width: item.percentage + '%', backgroundColor: item.color }"></div>
            </div>
            <div class="language-stats">
              <div class="stat-group">
                <div class="stat-label">提交次数</div>
                <div class="stat-value">{{ item.value }}次</div>
              </div>
              <div class="stat-group">
                <div class="stat-label">通过率</div>
                <div class="stat-value">{{ getPassRate(index) }}%</div>
              </div>
            </div>
          </div>
        </div>
        <div class="recommendation">
          <div class="recommendation-content">
            <div class="recommendation-icon">💡</div>
            <div class="recommendation-text">
              <p>根据您的使用习惯和效率分析，建议您：</p>
              <ul>
                <li>多尝试使用 <span class="highlight">Python</span> 解决复杂算法问题，可提高解题效率</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LanguagePreferenceCard',
  data() {
    return {
      // 硬编码数据
      pieData: [
        { name: 'C', value: 45, percentage: 45, color: '#2196F3' },
        { name: 'C++', value: 30, percentage: 30, color: '#4CAF50' },
        { name: 'Java', value: 15, percentage: 15, color: '#FFC107' },
        { name: 'Python', value: 10, percentage: 10, color: '#9C27B0' }
      ],
      totalSubmissions: 100,
      // 额外的语言统计数据
      languageStats: [
        { passRate: 82 },
        { passRate: 88 },
        { passRate: 76 },
        { passRate: 94 }
      ]
    }
  },
  methods: {
    getPieSegmentStyle(index) {
      // 计算每个扇形的样式
      let cumulativePercentage = 0;
      for (let i = 0; i < index; i++) {
        cumulativePercentage += this.pieData[i].percentage;
      }
      
      const startAngle = cumulativePercentage * 3.6; // 百分比转角度 (360度/100)
      
      return {
        backgroundColor: this.pieData[index].color,
        clipPath: `conic-gradient(from ${startAngle}deg, transparent 0%, transparent 0%, black 0%, black 100%, transparent 100%, transparent 100%)`,
        zIndex: index
      };
    },
    getPassRate(index) {
      return this.languageStats[index].passRate;
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
  font-size: 18px;
  margin-bottom: 15px;
  color: #e0e0e0;
}

.card-content {
  display: flex;
  flex-grow: 1;
  gap: 20px;
}

.chart-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-color: rgba(255, 255, 255, 0.03);
  border-radius: 10px;
  padding: 15px;
}

.pie-chart {
  position: relative;
  width: 160px;
  height: 160px;
  margin-bottom: 15px;
}

.pie-segments {
  position: absolute;
  width: 100%;
  height: 100%;
  border-radius: 50%;
  overflow: hidden;
}

.pie-segment {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
}

.pie-center {
  position: absolute;
  width: 80px;
  height: 80px;
  background-color: #1e1e2e;
  border-radius: 50%;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 16px;
  color: #e0e0e0;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.legend {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.legend-item {
  display: flex;
  align-items: center;
}

.legend-color {
  width: 14px;
  height: 14px;
  border-radius: 3px;
  margin-right: 8px;
}

.legend-label {
  width: 40px;
  font-size: 14px;
  color: #a6accd;
}

.legend-value {
  font-size: 14px;
  color: #7b7d8f;
}

.details-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.section-title {
  font-size: 16px;
  color: #e0e0e0;
  margin-bottom: 10px;
}

.language-details {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.language-item {
  background-color: rgba(255, 255, 255, 0.03);
  border-radius: 8px;
  padding: 10px;
}

.language-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
}

.language-name {
  font-size: 14px;
  font-weight: 500;
  color: #e0e0e0;
}

.language-percent {
  font-size: 14px;
  font-weight: 500;
  color: #a6accd;
}

.language-progress {
  width: 100%;
  height: 6px;
  background-color: #2d2d3d;
  border-radius: 3px;
  overflow: hidden;
  margin-bottom: 8px;
}

.progress-bar {
  height: 100%;
  transition: width 0.3s ease;
}

.language-stats {
  display: flex;
  justify-content: space-between;
}

.stat-group {
  text-align: center;
  flex: 1;
}

.stat-label {
  font-size: 12px;
  color: #7b7d8f;
  margin-bottom: 2px;
}

.stat-value {
  font-size: 14px;
  font-weight: 500;
  color: #a6accd;
}

.recommendation {
  margin-top: auto;
}

.recommendation-content {
  background-color: rgba(255, 255, 255, 0.03);
  border-radius: 8px;
  padding: 10px;
  display: flex;
  gap: 10px;
}

.recommendation-icon {
  font-size: 22px;
}

.recommendation-text {
  flex: 1;
}

.recommendation-text p {
  font-size: 13px;
  color: #a6accd;
  margin-bottom: 5px;
}

.recommendation-text ul {
  padding-left: 15px;
  margin: 0;
}

.recommendation-text li {
  font-size: 13px;
  color: #a6accd;
  line-height: 1.4;
}

.highlight {
  color: #4CAF50;
  font-weight: 500;
}

@media (max-width: 1200px) {
  .card-content {
    flex-direction: column;
  }
  
  .chart-section,
  .details-section {
    width: 100%;
  }
  
  .pie-chart {
    width: 150px;
    height: 150px;
  }
}
</style> 