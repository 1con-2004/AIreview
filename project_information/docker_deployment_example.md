# Docker部署示例

本文件提供了Docker部署过程中核心文件的具体实现示例，帮助您更好地理解如何应用全局API配置方案。

## 1. API统一服务实现 (frontend/src/utils/api.js)

```javascript
import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import store from '@/store'

/**
 * [API配置] 根据环境变量确定baseURL
 * 封装环境变量逻辑，支持开发环境和生产环境
 */
const getBaseUrl = () => {
  // 如果使用相对路径，则baseURL为空或/api
  if (process.env.VUE_APP_USE_RELATIVE_PATH === 'true') {
    return process.env.VUE_APP_BASE_API || '/api'
  }
  
  // 开发环境使用localhost
  return process.env.VUE_APP_BASE_API || 'http://localhost:3000'
}

/**
 * [API配置] 创建axios实例 
 * 统一管理API请求配置
 */
const apiService = axios.create({
  baseURL: getBaseUrl(),
  timeout: 15000
})

/**
 * [API路径] API路径构建函数
 * 用于构建API请求路径，处理不同环境下的路径差异
 */
export const getApiUrl = (path) => {
  // 确保path不以/开头，避免重复
  const cleanPath = path.startsWith('/') ? path.slice(1) : path
  
  // 如果使用相对路径，直接返回相对路径
  if (process.env.VUE_APP_USE_RELATIVE_PATH === 'true') {
    // 如果VUE_APP_BASE_API已经包含/api前缀，则不需要再添加
    return `${process.env.VUE_APP_BASE_API}/${cleanPath}`
  }
  
  // 开发环境返回完整URL
  return `${process.env.VUE_APP_BASE_API || 'http://localhost:3000'}/${cleanPath}`
}

/**
 * [资源路径] 资源URL构建函数
 * 用于构建图片等静态资源的URL
 */
export const getResourceUrl = (path) => {
  if (!path) return ''
  
  // 如果已经是完整URL，直接返回
  if (path.startsWith('http')) {
    return path
  }
  
  // 确保path不以/开头，避免重复
  const cleanPath = path.startsWith('/') ? path.slice(1) : path
  
  // 如果使用相对路径
  if (process.env.VUE_APP_USE_RELATIVE_PATH === 'true') {
    // 如果path已经包含/uploads等前缀，则直接返回
    return `/${cleanPath}`
  }
  
  // 开发环境返回完整URL
  return `${process.env.VUE_APP_BASE_API || 'http://localhost:3000'}/${cleanPath}`
}

/**
 * [请求拦截] 请求拦截器
 * 在发送请求前添加认证令牌和请求日志
 */
apiService.interceptors.request.use(
  config => {
    const requestId = `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
    config.requestId = requestId
    
    console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 发送请求: ${config.method.toUpperCase()} ${config.url}`)
    
    // 从localStorage获取token并添加到请求头
    const userInfoStr = localStorage.getItem('userInfo')
    if (userInfoStr) {
      try {
        const userInfo = JSON.parse(userInfoStr)
        if (userInfo.accessToken) {
          config.headers['Authorization'] = `Bearer ${userInfo.accessToken}`
          console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 添加认证令牌，用户: ${userInfo.username || '未知'}`)
        }
      } catch (e) {
        console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 解析localStorage中userInfo出错:`, e)
      }
    }
    
    return config
  },
  error => {
    console.error(`[前端日志] [${new Date().toISOString()}] 请求错误:`, error)
    return Promise.reject(error)
  }
)

/**
 * [响应拦截] 响应拦截器
 * 统一处理响应数据和错误
 */
apiService.interceptors.response.use(
  response => {
    const requestId = response.config.requestId
    console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 收到响应: ${response.status}`)
    
    const res = response.data
    return res
  },
  error => {
    console.error('请求错误:', error)
    
    // 如果是401错误，可能是token过期
    if (error.response && error.response.status === 401) {
      // 这里可以添加token刷新逻辑
      ElMessage.error('登录已过期，请重新登录')
      store.dispatch('logout')
      router.push('/login')
    }
    
    return Promise.reject(error)
  }
)

export default apiService
```

## 2. 环境变量配置 (frontend/.env)

```
# API基础路径配置
VUE_APP_BASE_API='/api'

# 是否使用相对路径（生产环境设为true，开发环境设为false）
VUE_APP_USE_RELATIVE_PATH=true 
```

## 3. 全局API配置 (frontend/src/main.js修改部分)

```javascript
// 导入API服务
import apiService, { getApiUrl, getResourceUrl } from './utils/api'

// 替换原有的axios全局配置
// 移除这一行: axios.defaults.baseURL = 'http://localhost:3000'

// 注册为全局属性
app.config.globalProperties.$axios = apiService
app.config.globalProperties.$getApiUrl = getApiUrl
app.config.globalProperties.$getResourceUrl = getResourceUrl

// 全局挂载API工具
app.provide('apiService', apiService)
app.provide('getApiUrl', getApiUrl)
app.provide('getResourceUrl', getResourceUrl)
```

## 4. Nginx配置示例 (nginx/default.conf)

```nginx
server {
    listen 80;
    server_name localhost;
    
    # 启用gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_min_length 1000;
    
    # 设置前端资源缓存策略
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        root /usr/share/nginx/html;
        expires 30d;
        add_header Cache-Control "public, max-age=2592000";
        try_files $uri $uri/ /index.html;
    }
    
    # 前端静态文件
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # API请求代理
    location /api/ {
        proxy_pass http://backend:3000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # 增加超时时间，适应长时间运行的API请求
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
    }

    # 静态资源代理
    location /uploads/ {
        proxy_pass http://backend:3000/uploads/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
        
        # 配置静态资源缓存
        expires 7d;
        add_header Cache-Control "public, max-age=604800";
    }
    
    # 健康检查接口
    location /health {
        return 200 'ok';
        add_header Content-Type text/plain;
    }
}
```

## 5. 组件中使用示例

### 获取问题列表示例

```javascript
<script setup>
import { ref, onMounted } from 'vue'
import apiService from '@/utils/api'

const problems = ref([])
const loading = ref(false)

const fetchProblems = async () => {
  loading.value = true
  try {
    const response = await apiService.get('/api/problems')
    problems.value = response.data || []
  } catch (error) {
    console.error('获取问题列表失败:', error)
    ElMessage.error('获取问题列表失败')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchProblems()
})
</script>
```

### 获取资源URL示例

```javascript
<script setup>
import { computed } from 'vue'
import { getResourceUrl } from '@/utils/api'

const props = defineProps({
  avatarPath: String
})

// 计算头像完整URL
const avatarUrl = computed(() => {
  if (!props.avatarPath) {
    return getResourceUrl('uploads/avatars/default-avatar.png')
  }
  return getResourceUrl(`uploads/avatars/${props.avatarPath}`)
})
</script>

<template>
  <img :src="avatarUrl" alt="用户头像" class="avatar-image" />
</template>
```

### 登录请求示例

```javascript
<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'
import apiService, { getApiUrl } from '@/utils/api'
import { ElMessage } from 'element-plus'

const router = useRouter()
const store = useStore()

const loginForm = ref({
  username: '',
  password: '',
  remember: false
})

const handleLogin = async () => {
  try {
    // 方法1：使用apiService
    const response = await apiService.post('/api/login', {
      username: loginForm.value.username,
      password: loginForm.value.password,
      remember: loginForm.value.remember
    })
    
    // 方法2：使用fetch + getApiUrl
    // const response = await fetch(getApiUrl('api/login'), {
    //   method: 'POST',
    //   headers: {
    //     'Content-Type': 'application/json'
    //   },
    //   body: JSON.stringify({
    //     username: loginForm.value.username,
    //     password: loginForm.value.password,
    //     remember: loginForm.value.remember
    //   })
    // }).then(res => res.json())
    
    if (response.success) {
      const { accessToken, refreshToken, ...userInfo } = response.data
      
      // 保存用户信息到localStorage
      localStorage.setItem('userInfo', JSON.stringify({
        ...userInfo,
        accessToken,
        refreshToken
      }))
      
      ElMessage.success('登录成功')
      router.push('/home')
    } else {
      ElMessage.error(response.message || '登录失败')
    }
  } catch (error) {
    console.error('登录错误：', error)
    ElMessage.error('登录失败，请稍后重试')
  }
}
</script>
```

## 6. 判题容器通信示例

### 后端判题容器创建代码

```javascript
// backend/src/services/judge_service.js

const Docker = require('dockerode')
const docker = new Docker({ socketPath: '/var/run/docker.sock' })

/**
 * [判题容器] 创建判题容器
 * 在Docker网络中创建判题容器并执行评测
 */
const createJudgeContainer = async (submissionId, code, language, testCases) => {
  try {
    // 使用环境变量中配置的网络名称
    const networkName = process.env.JUDGE_NETWORK || 'aireview_network'
    console.log(`[后端日志] 创建判题容器，使用网络: ${networkName}`)
    
    // 编码测试用例为base64，避免特殊字符问题
    const encodedTestCases = Buffer.from(JSON.stringify(testCases)).toString('base64')
    
    // 创建判题容器
    const container = await docker.createContainer({
      Image: 'judge-image:latest', // 确保镜像已构建
      Cmd: ['node', 'judge.js'],
      Env: [
        `SUBMISSION_ID=${submissionId}`,
        `CODE=${Buffer.from(code).toString('base64')}`,
        `LANGUAGE=${language}`,
        `TEST_CASES=${encodedTestCases}`,
        'BACKEND_HOST=backend', // 使用Docker服务名称
        'BACKEND_PORT=3000'
      ],
      HostConfig: {
        NetworkMode: networkName,
        AutoRemove: true, // 容器退出后自动删除
        Memory: 512 * 1024 * 1024, // 限制内存为512MB
        MemorySwap: 512 * 1024 * 1024, // 禁用交换内存
        CpuPeriod: 100000,
        CpuQuota: 50000, // 限制CPU使用率为50%
      },
      Labels: {
        'com.aireview.type': 'judge-container',
        'com.aireview.submission-id': submissionId.toString()
      }
    })
    
    console.log(`[后端日志] 判题容器已创建，ID: ${container.id.substr(0, 12)}`)
    
    // 启动容器
    await container.start()
    console.log(`[后端日志] 判题容器已启动，ID: ${container.id.substr(0, 12)}`)
    
    return container.id
  } catch (error) {
    console.error('[后端日志] 创建判题容器失败:', error)
    throw new Error(`创建判题容器失败: ${error.message}`)
  }
}

module.exports = {
  createJudgeContainer
}
```

## 总结

通过以上示例，展示了如何实现和使用全局API配置，以及如何配置Docker和Nginx来支持容器化部署。这些示例可以作为参考，根据实际项目需求进行调整和实现。 