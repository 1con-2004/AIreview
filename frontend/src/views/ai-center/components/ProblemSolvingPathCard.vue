<template>
  <div class="card-container">
    <h2 class="card-title">问题解决路径</h2>
    <div class="card-content">
      <div class="stats-section">
        <div class="stats-row">
          <div class="stat-card">
            <div class="stat-value">{{ avgSolvingTime }}</div>
            <div class="stat-label">平均解题时间</div>
          </div>
          <div class="stat-card">
            <div class="stat-value">{{ successRate }}%</div>
            <div class="stat-label">成功提交率</div>
          </div>
        </div>
        <div class="pattern-container">
          <h3 class="section-title">解题模式分析</h3>
          <div class="pattern-item">
            <div class="pattern-icon">📊</div>
            <div class="pattern-content">
              <div class="pattern-label">您最常使用的解题步骤</div>
              <div class="pattern-steps">
                <span v-for="(step, index) in commonPattern" :key="index" class="pattern-step">{{ step }}</span>
              </div>
            </div>
          </div>
          <div class="efficiency-stats">
            <div class="efficiency-item">
              <div class="efficiency-title">解题效率分析</div>
              <div class="efficiency-content">
                <div class="efficiency-metric">
                  <span class="metric-label">最佳解题时间:</span>
                  <span class="metric-value">18分钟</span>
                </div>
                <div class="efficiency-metric">
                  <span class="metric-label">周环比变化:</span>
                  <span class="metric-value improvement">↓ 12.5%</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="timeline-container">
        <div class="timeline-header">
          <div>最近一次解题路径</div>
          <div class="problem-info">
            <span class="problem-badge">{{ recentProblem.difficulty }}</span>
            <span class="problem-name">{{ recentProblem.name }}</span>
          </div>
        </div>
        <div class="timeline">
          <div v-for="(step, index) in solvingPath" :key="index" class="timeline-item">
            <div class="timeline-point" :class="{ 'active': step.active }"></div>
            <div class="timeline-content">
              <div class="timeline-time">{{ step.time }}</div>
              <div class="timeline-action">{{ step.action }}</div>
              <div v-if="step.detail" class="timeline-detail">{{ step.detail }}</div>
            </div>
          </div>
          <div class="analysis-box">
            <div class="analysis-title">AI辅助效果分析</div>
            <div class="analysis-content">
              <div class="analysis-metric">
                <div class="metric-number">36%</div>
                <div class="metric-label">使用AI分析后<br>解题速度提升</div>
              </div>
              <div class="analysis-metric">
                <div class="metric-number">42%</div>
                <div class="metric-label">使用AI分析后<br>通过率提升</div>
              </div>
            </div>
            <div class="analysis-text">使用AI辅助功能可显著提高解题效率，尤其在复杂问题上效果最佳</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProblemSolvingPathCard',
  data () {
    return {
      // 硬编码数据
      avgSolvingTime: '28分钟',
      successRate: 76,
      recentProblem: {
        name: '两数之和',
        difficulty: '简单'
      },
      solvingPath: [
        { time: '10:15', action: '查看题目', active: true },
        { time: '10:17', action: '查看测试用例', active: true },
        { time: '10:19', action: '尝试解题', detail: '选择C语言', active: true },
        { time: '10:28', action: '运行代码', detail: '测试用例通过: 2/5', active: true },
        { time: '10:33', action: '查看AI分析', detail: '解决边界情况', active: true },
        { time: '10:38', action: '修改代码', active: true },
        { time: '10:41', action: '提交代码', detail: '成功通过所有测试', active: true }
      ],
      commonPattern: [
        '查看题目',
        '复制示例',
        '使用AI分析',
        '编写代码',
        '提交解决方案'
      ]
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

.card-content {
  display: flex;
  flex-grow: 1;
  gap: 25px;
}

.stats-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.stats-row {
  display: flex;
  justify-content: space-between;
  gap: 15px;
}

.stat-card {
  text-align: center;
  padding: 15px;
  background-color: #2d2d3d;
  border-radius: 10px;
  width: 48%;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #4CAF50;
}

.stat-label {
  font-size: 14px;
  color: #a6accd;
  margin-top: 5px;
}

.pattern-container {
  background-color: rgba(255, 255, 255, 0.03);
  border-radius: 10px;
  padding: 15px;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.section-title {
  font-size: 16px;
  color: #e0e0e0;
  margin: 0;
}

.pattern-item {
  display: flex;
  background-color: #2d2d3d;
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 15px;
}

.pattern-icon {
  font-size: 22px;
  margin-right: 12px;
}

.pattern-content {
  flex-grow: 1;
}

.pattern-label {
  font-size: 14px;
  color: #a6accd;
  margin-bottom: 8px;
}

.pattern-steps {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.pattern-step {
  font-size: 13px;
  background-color: rgba(33, 150, 243, 0.1);
  color: #2196F3;
  padding: 4px 10px;
  border-radius: 4px;
}

.efficiency-stats {
  flex-grow: 1;
}

.efficiency-item {
  background-color: #2d2d3d;
  border-radius: 8px;
  padding: 12px;
}

.efficiency-title {
  font-size: 14px;
  color: #e0e0e0;
  margin-bottom: 10px;
}

.efficiency-content {
  display: flex;
  justify-content: space-between;
  flex-wrap: nowrap;
}

.efficiency-metric {
  display: flex;
  align-items: center;
  gap: 5px;
  min-width: 45%;
  white-space: nowrap;
}

.metric-label {
  font-size: 13px;
  color: #a6accd;
}

.metric-value {
  font-size: 14px;
  color: #e0e0e0;
  font-weight: 500;
}

.improvement {
  color: #4CAF50;
}

.timeline-container {
  flex: 1.2;
  background-color: rgba(255, 255, 255, 0.03);
  border-radius: 10px;
  padding: 15px;
  display: flex;
  flex-direction: column;
}

.timeline-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  font-size: 16px;
  color: #a6accd;
}

.problem-info {
  display: flex;
  align-items: center;
}

.problem-badge {
  font-size: 12px;
  padding: 3px 8px;
  background-color: #4CAF50;
  color: white;
  border-radius: 4px;
  margin-right: 8px;
}

.problem-name {
  font-size: 14px;
  color: #e0e0e0;
}

.timeline {
  flex-grow: 1;
  position: relative;
  padding-left: 20px;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
}

.timeline::before {
  content: '';
  position: absolute;
  left: 4px;
  top: 0;
  bottom: 50%;
  width: 2px;
  background-color: #2d2d3d;
}

.timeline-item {
  position: relative;
  margin-bottom: 18px;
}

.timeline-point {
  position: absolute;
  left: -20px;
  top: 0;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background-color: #2d2d3d;
  z-index: 1;
}

.timeline-point.active {
  background-color: #2196F3;
}

.timeline-content {
  position: relative;
  padding-left: 15px;
}

.timeline-time {
  font-size: 13px;
  color: #7b7d8f;
  margin-bottom: 4px;
}

.timeline-action {
  font-size: 15px;
  color: #e0e0e0;
  margin-bottom: 2px;
}

.timeline-detail {
  font-size: 13px;
  color: #a6accd;
}

.analysis-box {
  margin-top: auto;
  background-color: #2d2d3d;
  border-radius: 8px;
  padding: 15px;
}

.analysis-title {
  font-size: 15px;
  color: #e0e0e0;
  margin-bottom: 15px;
  text-align: center;
}

.analysis-content {
  display: flex;
  justify-content: space-around;
  margin-bottom: 15px;
}

.analysis-metric {
  text-align: center;
}

.metric-number {
  font-size: 24px;
  font-weight: bold;
  color: #2196F3;
  margin-bottom: 5px;
}

.analysis-text {
  font-size: 13px;
  color: #a6accd;
  text-align: center;
  line-height: 1.5;
}

@media (max-width: 1200px) {
  .card-content {
    flex-direction: column;
  }
 
  .stats-section, .timeline-container {
    width: 100%;
  }
 
  .timeline {
    max-height: 350px;
  }
}
</style>

