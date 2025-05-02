<template>
  <div class="card-container">
    <h2 class="card-title">代码质量概览</h2>
    <div class="chart-container">
      <div class="bar-chart">
        <div v-for="(item, index) in qualityData" :key="index" class="bar-item">
          <div class="bar-label">{{ item.name }}</div>
          <div class="bar-wrapper">
            <div class="bar" :style="{ width: item.score + '%', backgroundColor: item.color }"></div>
            <div class="bar-score">{{ item.score }}</div>
          </div>
        </div>
      </div>
      <div class="summary">
        <p>总体评分: <span class="highlight">{{ overallScore }}/100</span></p>
        <p>相较于上周: <span :class="scoreTrend > 0 ? 'trend-up' : 'trend-down'">
          {{ scoreTrend > 0 ? '+' : '' }}{{ scoreTrend }}%
        </span></p>
      </div>
    </div>
   
    <div class="trend-container">
      <h3 class="section-title">代码质量趋势</h3>
      <div class="trend-chart">
        <div class="chart-legend">
          <div class="legend-item">
            <div class="legend-color" style="background-color: #4CAF50;"></div>
            <div class="legend-text">命名规范</div>
          </div>
          <div class="legend-item">
            <div class="legend-color" style="background-color: #FFC107;"></div>
            <div class="legend-text">复杂度</div>
          </div>
          <div class="legend-item">
            <div class="legend-color" style="background-color: #2196F3;"></div>
            <div class="legend-text">逻辑性</div>
          </div>
          <div class="legend-item">
            <div class="legend-color" style="background-color: #9C27B0;"></div>
            <div class="legend-text">可读性</div>
          </div>
        </div>
        <div class="mock-chart">
          <div class="chart-grid">
            <div v-for="i in 5" :key="i" class="grid-line" :style="{ bottom: (i * 20) + '%' }">
              <span class="grid-value">{{ 20 * i }}</span>
            </div>
          </div>
          <div class="chart-lines">
            <div class="chart-line" style="--color: #4CAF50; --path: 65% 60% 70% 85% 82% 85%;"></div>
            <div class="chart-line" style="--color: #FFC107; --path: 42% 45% 55% 60% 65% 68%;"></div>
            <div class="chart-line" style="--color: #2196F3; --path: 75% 80% 85% 88% 90% 92%;"></div>
            <div class="chart-line" style="--color: #9C27B0; --path: 50% 55% 60% 70% 75% 78%;"></div>
          </div>
          <div class="chart-labels">
            <div v-for="(month, index) in months" :key="index" class="chart-label">{{ month }}</div>
          </div>
        </div>
      </div>
     
      <div class="insights-container">
        <div class="insight-card">
          <div class="insight-icon">📈</div>
          <div class="insight-content">
            <div class="insight-title">主要提升点</div>
            <div class="insight-text">命名规范提升最明显 (+20%)</div>
          </div>
        </div>
        <div class="insight-card">
          <div class="insight-icon">⚠️</div>
          <div class="insight-content">
            <div class="insight-title">需改进区域</div>
            <div class="insight-text">代码复杂度仍需优化</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CodeQualityCard',
  data () {
    return {
      // 硬编码数据
      qualityData: [
        { name: '命名规范', score: 85, color: '#4CAF50' },
        { name: '代码复杂度', score: 68, color: '#FFC107' },
        { name: '逻辑性', score: 92, color: '#2196F3' },
        { name: '可读性', score: 78, color: '#9C27B0' }
      ],
      overallScore: 81,
      scoreTrend: 5.2,
      months: ['1月', '2月', '3月', '4月', '5月', '本月']
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

.chart-container {
  flex-grow: 0;
  margin-bottom: 20px;
}

.bar-chart {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.bar-item {
  display: flex;
  align-items: center;
}

.bar-label {
  width: 100px;
  font-size: 14px;
  margin-right: 10px;
  color: #a6accd;
}

.bar-wrapper {
  flex-grow: 1;
  background-color: #2d2d3d;
  height: 20px;
  border-radius: 10px;
  position: relative;
  overflow: hidden;
}

.bar {
  height: 100%;
  border-radius: 10px;
  transition: width 0.3s ease;
}

.bar-score {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 12px;
  font-weight: bold;
  color: #e0e0e0;
}

.summary {
  margin-top: 20px;
  font-size: 14px;
  color: #a6accd;
}

.highlight {
  font-weight: bold;
  color: #4CAF50;
}

.trend-up {
  color: #4CAF50;
}

.trend-down {
  color: #F44336;
}

.trend-container {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  background-color: rgba(255, 255, 255, 0.03);
  border-radius: 10px;
  padding: 15px;
}

.section-title {
  font-size: 16px;
  color: #e0e0e0;
  margin-bottom: 15px;
}

.trend-chart {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  margin-bottom: 15px;
}

.chart-legend {
  display: flex;
  gap: 15px;
  margin-bottom: 10px;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 5px;
}

.legend-color {
  width: 12px;
  height: 12px;
  border-radius: 3px;
}

.legend-text {
  font-size: 12px;
  color: #a6accd;
}

.mock-chart {
  position: relative;
  height: 180px;
  margin-top: 10px;
  margin-bottom: 20px;
}

.chart-grid {
  position: absolute;
  top: 0;
  left: 30px;
  right: 0;
  bottom: 20px;
  z-index: 1;
}

.grid-line {
  position: absolute;
  left: 0;
  right: 0;
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

.chart-lines {
  position: absolute;
  top: 0;
  left: 30px;
  right: 0;
  bottom: 20px;
  z-index: 2;
}

.chart-line {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: none;
  --mask: linear-gradient(to right, var(--color), var(--color)) 0 0/var(--size, 2px) 100% no-repeat;
  -webkit-mask: var(--mask);
  mask: var(--mask);
  pointer-events: none;
}

.chart-line::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: conic-gradient(
    from 270deg at calc(0 * 20%) calc(100% - var(--path, 0) * 1%),
    var(--color) 0%, var(--color) 25%,
    transparent 25.1%, transparent 100%
  ), conic-gradient(
    from 270deg at calc(1 * 20%) calc(100% - var(--path, 0) * 1%),
    var(--color) 0%, var(--color) 25%,
    transparent 25.1%, transparent 100%
  ), conic-gradient(
    from 270deg at calc(2 * 20%) calc(100% - var(--path, 0) * 1%),
    var(--color) 0%, var(--color) 25%,
    transparent 25.1%, transparent 100%
  ), conic-gradient(
    from 270deg at calc(3 * 20%) calc(100% - var(--path, 0) * 1%),
    var(--color) 0%, var(--color) 25%,
    transparent 25.1%, transparent 100%
  ), conic-gradient(
    from 270deg at calc(4 * 20%) calc(100% - var(--path, 0) * 1%),
    var(--color) 0%, var(--color) 25%,
    transparent 25.1%, transparent 100%
  ), conic-gradient(
    from 270deg at calc(5 * 20%) calc(100% - var(--path, 0) * 1%),
    var(--color) 0%, var(--color) 25%,
    transparent 25.1%, transparent 100%
  );
}

.chart-labels {
  position: absolute;
  left: 30px;
  right: 0;
  bottom: 0;
  display: flex;
  justify-content: space-between;
}

.chart-label {
  font-size: 11px;
  color: #7b7d8f;
  transform: translateX(-50%);
}

.insights-container {
  display: flex;
  gap: 15px;
}

.insight-card {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 10px;
  background-color: #2d2d3d;
  border-radius: 8px;
  padding: 10px 15px;
}

.insight-icon {
  font-size: 20px;
}

.insight-content {
  flex: 1;
}

.insight-title {
  font-size: 12px;
  color: #a6accd;
  margin-bottom: 3px;
}

.insight-text {
  font-size: 14px;
  color: #e0e0e0;
}
</style>

