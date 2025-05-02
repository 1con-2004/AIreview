<template>
  <div class="statistics-container">
    <NavBar />
    <div class="statistics-content">
      <!-- 每日提交数量趋势卡片 -->
      <div class="charts-row">
        <div class="chart-card">
          <h3>每日提交数量趋势</h3>
          <div class="chart-container">
            <div class="chart-legend">
              <span class="legend-item">
                <span class="legend-dot total"></span>
                总提交次数
              </span>
              <span class="legend-item">
                <span class="legend-dot passed"></span>
                通过的提交
              </span>
            </div>
            <div id="dailySubmissionChart" class="chart"></div>
          </div>
        </div>
      </div>

      <!-- 提交时间分布卡片 -->
      <div class="charts-row">
        <div class="chart-card">
          <h3>24小时提交分布</h3>
          <div id="submissionHeatmap" class="chart"></div>
        </div>
      </div>

      <!-- 代码行数统计和语言偏好图 -->
      <div class="charts-row">
        <div class="chart-card half-width">
          <h3>代码行数统计</h3>
          <div id="codeLinesChart" class="chart"></div>
        </div>
        <div class="chart-card half-width">
          <h3>语言趋势偏好</h3>
          <div id="languagePieChart" class="chart"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'
import * as echarts from 'echarts'

export default {
  name: 'Statistics',
  components: {
    NavBar
  },
  data() {
    return {
      charts: {}
    }
  },
  mounted() {
    this.initCharts()
  },
  methods: {
    initCharts() {
      // 初始化每日提交数量趋势图
      this.charts.dailySubmission = echarts.init(document.getElementById('dailySubmissionChart'))
      this.charts.dailySubmission.setOption({
        backgroundColor: 'transparent',
        tooltip: {
          trigger: 'axis'
        },
        legend: {
          data: ['总提交次数', '通过的提交'],
          textStyle: {
            color: '#fff'
          }
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
          data: ['4月3日', '4月5日', '4月7日', '4月9日', '4月11日', '4月13日', '4月15日'],
          axisLabel: {
            color: '#fff'
          }
        },
        yAxis: {
          type: 'value',
          axisLabel: {
            color: '#fff'
          }
        },
        series: [
          {
            name: '总提交次数',
            type: 'line',
            data: [5, 2, 1, 3, 2, 4, 7],
            smooth: true,
            lineStyle: {
              color: '#409EFF'
            },
            itemStyle: {
              color: '#409EFF'
            }
          },
          {
            name: '通过的提交',
            type: 'line',
            data: [3, 1, 0, 2, 1, 2, 4],
            smooth: true,
            lineStyle: {
              color: '#67C23A'
            },
            itemStyle: {
              color: '#67C23A'
            }
          }
        ]
      })

      // 初始化提交时间分布图
      this.charts.submissionHeatmap = echarts.init(document.getElementById('submissionHeatmap'))
      this.charts.submissionHeatmap.setOption({
        backgroundColor: 'transparent',
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23'],
          axisLabel: {
            color: '#fff'
          }
        },
        yAxis: {
          type: 'value',
          axisLabel: {
            color: '#fff',
            formatter: '{value}次'
          }
        },
        series: [{
          data: [23, 7, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 2, 2, 2, 12, 23, 4, 19, 5, 17, 5],
          type: 'bar',
          itemStyle: {
            color: '#409EFF'
          }
        }]
      })

      // 初始化代码行数统计图
      this.charts.codeLines = echarts.init(document.getElementById('codeLinesChart'))
      this.charts.codeLines.setOption({
        backgroundColor: 'transparent',
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: ['C', 'C++', 'Java', 'Python'],
          axisLabel: {
            color: '#fff',
            interval: 0
          }
        },
        yAxis: {
          type: 'value',
          name: '代码行数',
          nameTextStyle: {
            color: '#fff'
          },
          axisLabel: {
            color: '#fff',
            formatter: '{value} 行'
          }
        },
        series: [{
          data: [
            {
              value: 1200,
              itemStyle: {
                color: '#FF6F00'  // C语言 - 亮橙色
              }
            },
            {
              value: 2800,
              itemStyle: {
                color: '#9C27B0'  // C++ - 亮紫色
              }
            },
            {
              value: 1800,
              itemStyle: {
                color: '#03A9F4'  // Java - 亮蓝色
              }
            },
            {
              value: 2200,
              itemStyle: {
                color: '#FFFF00'  // Python - 柠檬黄
              }
            }
          ],
          type: 'bar',
          barWidth: '60%',
          label: {
            show: true,
            position: 'top',
            color: '#fff',
            formatter: '{c} 行'
          }
        }]
      })

      // 初始化语言偏好饼图
      this.charts.languagePie = echarts.init(document.getElementById('languagePieChart'))
      this.charts.languagePie.setOption({
        backgroundColor: 'transparent',
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          right: 10,
          top: 'center',
          textStyle: {
            color: '#fff'
          }
        },
        series: [{
          name: '语言偏好',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 10,
            borderColor: '#222',
            borderWidth: 2
          },
          label: {
            show: false,
            position: 'center',
            color: '#fff'
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 20,
              fontWeight: 'bold',
              color: '#fff'
            }
          },
          labelLine: {
            show: false
          },
          data: [
            { 
              value: 35, 
              name: 'C++', 
              itemStyle: { 
                color: '#9C27B0',  // 亮紫色
                borderColor: '#222',
                borderWidth: 2
              }
            },
            { 
              value: 30, 
              name: 'Python', 
              itemStyle: { 
                color: '#FFFF00',  // 柠檬黄
                borderColor: '#222',
                borderWidth: 2
              }
            },
            { 
              value: 20, 
              name: 'Java', 
              itemStyle: { 
                color: '#03A9F4',  // 亮蓝色
                borderColor: '#222',
                borderWidth: 2
              }
            },
            { 
              value: 15, 
              name: 'C', 
              itemStyle: { 
                color: '#FF6F00',  // 亮橙色
                borderColor: '#222',
                borderWidth: 2
              }
            }
          ]
        }]
      })
    },
    generateMockGithubData() {
      const data = []
      const startDate = new Date('2024-01-01')
      for (let i = 0; i < 365; i++) {
        const date = new Date(startDate.getTime() + i * 24 * 60 * 60 * 1000)
        data.push([
          echarts.format.formatTime('yyyy-MM-dd', date),
          Math.floor(Math.random() * 10)
        ])
      }
      return data
    }
  }
}
</script>

<style scoped>
.statistics-container {
  min-height: 100vh;
  background-color: #121212;
  color: #fff;
}

.statistics-content {
  padding: 20px;
  margin-top: 60px;
}

.charts-row {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.chart-card {
  background-color: #1e1e1e;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  width: 100%;
}

.half-width {
  width: 50%;
  min-width: 500px;
}

.chart {
  height: 400px;
  width: 100%;
  min-width: 400px;
}

.chart-container {
  position: relative;
}

.chart-legend {
  position: absolute;
  top: 10px;
  right: 10px;
  z-index: 1;
  display: flex;
  gap: 20px;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #fff;
}

.legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}

.legend-dot.total {
  background-color: #409EFF;
}

.legend-dot.passed {
  background-color: #67C23A;
}

h3 {
  margin: 0 0 20px 0;
  color: #fff;
  font-size: 18px;
}
</style> 