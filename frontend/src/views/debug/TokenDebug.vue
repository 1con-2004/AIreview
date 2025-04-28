<!-- TokenDebug.vue - Token调试页面 -->
<template>
  <div class="token-debug">
    <h2>Token 调试工具</h2>
    <div class="debug-card">
      <h3>localStorage存储信息</h3>
      <div class="debug-row" v-if="storageInfo.accessToken">
        <div class="label">Access Token:</div>
        <div class="value code" v-if="storageInfo.accessToken">{{ tokenShort(storageInfo.accessToken) }}</div>
        <div class="value" v-else>未找到</div>
      </div>
      <div class="debug-row" v-if="storageInfo.refreshToken">
        <div class="label">Refresh Token:</div>
        <div class="value code" v-if="storageInfo.refreshToken">{{ tokenShort(storageInfo.refreshToken) }}</div>
        <div class="value" v-else>未找到</div>
      </div>
      <div class="debug-row">
        <div class="label">userInfo:</div>
        <div class="value" v-if="storageInfo.userInfo">
          <pre>{{ JSON.stringify(storageInfo.userInfo, null, 2) }}</pre>
        </div>
        <div class="value" v-else>未找到</div>
      </div>
    </div>

    <div class="debug-card">
      <h3>Vuex Store状态</h3>
      <div class="debug-row">
        <div class="label">Access Token:</div>
        <div class="value code" v-if="storeInfo.accessToken">{{ tokenShort(storeInfo.accessToken) }}</div>
        <div class="value" v-else>未找到</div>
      </div>
      <div class="debug-row">
        <div class="label">Refresh Token:</div>
        <div class="value code" v-if="storeInfo.refreshToken">{{ tokenShort(storeInfo.refreshToken) }}</div>
        <div class="value" v-else>未找到</div>
      </div>
      <div class="debug-row">
        <div class="label">用户信息:</div>
        <div class="value" v-if="storeInfo.userInfo">
          <pre>{{ JSON.stringify(storeInfo.userInfo, null, 2) }}</pre>
        </div>
        <div class="value" v-else>未找到</div>
      </div>
    </div>

    <div class="debug-card">
      <h3>请求头信息</h3>
      <div class="debug-row">
        <div class="label">axios全局:</div>
        <div class="value code" v-if="headerInfo.axiosGlobal">{{ headerInfo.axiosGlobal }}</div>
        <div class="value" v-else>未设置</div>
      </div>
      <div class="debug-row">
        <div class="label">service实例:</div>
        <div class="value code" v-if="headerInfo.serviceInstance">{{ headerInfo.serviceInstance }}</div>
        <div class="value" v-else>未设置</div>
      </div>
    </div>

    <div class="debug-card">
      <h3>环境与基础配置</h3>
      <div class="debug-row">
        <div class="label">axios baseURL:</div>
        <div class="value">{{ envInfo.baseURL || '空（相对路径）' }}</div>
      </div>
      <div class="debug-row">
        <div class="label">localStorage测试:</div>
        <div class="value" :class="envInfo.localStorageWorks ? 'success' : 'error'">
          {{ envInfo.localStorageWorks ? '可用' : '不可用' }}
        </div>
      </div>
      <div class="debug-row">
        <div class="label">当前URL:</div>
        <div class="value">{{ window.location.href }}</div>
      </div>
    </div>

    <div class="debug-card actions">
      <h3>Token管理操作</h3>
      <div class="button-group">
        <button @click="testApiRequest" class="btn primary">测试API请求</button>
        <button @click="refreshStorage" class="btn secondary">刷新显示</button>
        <button @click="fixTokens" class="btn warning">修复Token</button>
        <button @click="clearTokens" class="btn danger">清除Token</button>
      </div>

      <div v-if="apiResult" class="api-result">
        <h4>API请求结果:</h4>
        <pre>{{ JSON.stringify(apiResult, null, 2) }}</pre>
      </div>
    </div>

    <div class="debug-card decode">
      <h3>Token解码</h3>
      <div class="token-input">
        <textarea v-model="tokenToDecode" placeholder="粘贴JWT token进行解码"></textarea>
        <button @click="decodeToken" class="btn secondary">解码</button>
      </div>
      <div v-if="decodedToken" class="decoded-result">
        <h4>解码结果:</h4>
        <pre>{{ JSON.stringify(decodedToken, null, 2) }}</pre>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'
import request, { setGlobalToken } from '@/utils/request'
import { useStore } from 'vuex'

const store = useStore()

// 数据存储
const storageInfo = reactive({
  accessToken: null,
  refreshToken: null,
  userInfo: null
})

const storeInfo = reactive({
  accessToken: null,
  refreshToken: null,
  userInfo: null
})

const headerInfo = reactive({
  axiosGlobal: null,
  serviceInstance: null
})

const envInfo = reactive({
  baseURL: null,
  localStorageWorks: true
})

const apiResult = ref(null)
const tokenToDecode = ref('')
const decodedToken = ref(null)

// 辅助函数
const tokenShort = (token) => {
  if (!token) return ''
  return token.substring(0, 15) + '...' + token.substring(token.length - 10)
}

// 方法
const loadStorageInfo = () => {
  try {
    storageInfo.accessToken = localStorage.getItem('accessToken')
    storageInfo.refreshToken = localStorage.getItem('refreshToken')
    const userInfoStr = localStorage.getItem('userInfo')
    storageInfo.userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
  } catch (e) {
    console.error('读取localStorage失败:', e)
    envInfo.localStorageWorks = false
  }
}

const loadStoreInfo = () => {
  storeInfo.accessToken = store.getters.token
  storeInfo.refreshToken = store.getters.getRefreshToken
  storeInfo.userInfo = store.getters.getUserInfo
}

const loadHeaderInfo = () => {
  headerInfo.axiosGlobal = axios.defaults.headers.common.Authorization || null
  headerInfo.serviceInstance = request.defaults.headers.common.Authorization || null
}

const loadEnvInfo = () => {
  envInfo.baseURL = request.defaults.baseURL

  // 测试localStorage是否可用
  try {
    const testKey = '_test_' + Date.now()
    localStorage.setItem(testKey, 'test')
    localStorage.removeItem(testKey)
    envInfo.localStorageWorks = true
  } catch (e) {
    console.error('localStorage测试失败:', e)
    envInfo.localStorageWorks = false
  }
}

const refreshStorage = () => {
  loadStorageInfo()
  loadStoreInfo()
  loadHeaderInfo()
  loadEnvInfo()
}

const testApiRequest = async () => {
  try {
    apiResult.value = { status: 'loading' }
    const response = await request.get('/api/user/profile')
    apiResult.value = {
      success: true,
      status: response.status || 200,
      data: response.data
    }
  } catch (error) {
    apiResult.value = {
      success: false,
      status: error.response?.status,
      message: error.message,
      data: error.response?.data
    }
  }
}

const fixTokens = () => {
  try {
    // 1. 首先从userInfo中获取token（如果有）
    let accessToken = null
    let refreshToken = null

    const userInfoStr = localStorage.getItem('userInfo')
    if (userInfoStr) {
      const userInfo = JSON.parse(userInfoStr)
      if (userInfo.accessToken) {
        accessToken = userInfo.accessToken
        refreshToken = userInfo.refreshToken
        console.log('从userInfo中获取到token')
      }
    }

    // 2. 如果userInfo中没有，从store中获取
    if (!accessToken && store.getters.token) {
      accessToken = store.getters.token
      refreshToken = store.getters.getRefreshToken
      console.log('从store中获取到token')
    }

    if (accessToken) {
      // 3. 将token同步到所有位置
      localStorage.setItem('accessToken', accessToken)
      if (refreshToken) localStorage.setItem('refreshToken', refreshToken)

      // 4. 更新请求头
      setGlobalToken(accessToken)

      // 5. 刷新显示
      refreshStorage()
      alert('已同步Token到localStorage和请求头')
    } else {
      alert('未找到有效的token，无法修复')
    }
  } catch (e) {
    console.error('修复token失败:', e)
    alert('修复失败: ' + e.message)
  }
}

const clearTokens = () => {
  try {
    localStorage.removeItem('accessToken')
    localStorage.removeItem('refreshToken')
    localStorage.removeItem('userInfo')

    // 清除请求头
    delete axios.defaults.headers.common.Authorization
    delete request.defaults.headers.common.Authorization

    // 清除store
    store.dispatch('logout')

    // 刷新显示
    refreshStorage()
    alert('已清除所有token和用户信息')
  } catch (e) {
    console.error('清除token失败:', e)
    alert('清除失败: ' + e.message)
  }
}

const decodeToken = () => {
  if (!tokenToDecode.value) return

  try {
    // JWT解码函数 - 不验证签名
    const parseJwt = (token) => {
      const base64Url = token.split('.')[1]
      const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/')
      const jsonPayload = decodeURIComponent(
        atob(base64)
          .split('')
          .map(c => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
          .join('')
      )
      return JSON.parse(jsonPayload)
    }

    decodedToken.value = parseJwt(tokenToDecode.value)
  } catch (e) {
    console.error('解码token失败:', e)
    decodedToken.value = { error: '解码失败: ' + e.message }
  }
}

// 生命周期钩子
onMounted(() => {
  refreshStorage()
})
</script>

<style scoped>
.token-debug {
  max-width: 900px;
  margin: 20px auto;
  padding: 20px;
  font-family: Arial, sans-serif;
}

h2 {
  text-align: center;
  margin-bottom: 20px;
  color: #333;
}

.debug-card {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin-bottom: 20px;
}

h3 {
  margin-top: 0;
  margin-bottom: 15px;
  color: #444;
  border-bottom: 1px solid #eee;
  padding-bottom: 8px;
}

.debug-row {
  display: flex;
  margin-bottom: 12px;
}

.label {
  flex: 0 0 120px;
  font-weight: bold;
  color: #555;
}

.value {
  flex: 1;
  word-break: break-all;
}

.code {
  font-family: monospace;
  background-color: #f5f5f5;
  padding: 2px 4px;
  border-radius: 3px;
}

pre {
  background-color: #f8f8f8;
  padding: 10px;
  border-radius: 4px;
  overflow-x: auto;
  margin: 0;
  font-size: 0.9em;
}

.button-group {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
  transition: all 0.2s;
}

.primary {
  background-color: #4caf50;
  color: white;
}

.secondary {
  background-color: #2196f3;
  color: white;
}

.warning {
  background-color: #ff9800;
  color: white;
}

.danger {
  background-color: #f44336;
  color: white;
}

.btn:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

.success {
  color: #4caf50;
}

.error {
  color: #f44336;
}

.api-result {
  margin-top: 15px;
  border-top: 1px solid #eee;
  padding-top: 15px;
}

.token-input {
  display: flex;
  margin-bottom: 15px;
}

.token-input textarea {
  flex: 1;
  min-height: 80px;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  margin-right: 10px;
  font-family: monospace;
}

.decoded-result {
  border-top: 1px solid #eee;
  padding-top: 10px;
}
</style>
