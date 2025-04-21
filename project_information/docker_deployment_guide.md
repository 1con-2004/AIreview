# Docker部署指南

## 问题描述

在将AIreview项目部署到Docker环境时，出现了以下主要问题：

1. 前端代码中大量硬编码的API地址 (`http://localhost:3000`)
2. 跨域请求问题
3. 判题容器的创建与通信问题

## 解决方案

### 1. 前端API请求全局配置

为避免逐个修改硬编码的API地址，我们需要实现一个全局配置方案：

#### a. 创建环境变量配置文件

修改 `frontend/.env` 文件：

```
# API基础路径配置
VUE_APP_BASE_API='/api'

# 是否使用相对路径（生产环境设为true，开发环境设为false）
VUE_APP_USE_RELATIVE_PATH=true 
```

#### b. 创建API请求统一服务

在 `frontend/src/utils` 目录下创建 `api.js` 文件：

```javascript
import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import store from '@/store'

// 根据环境变量确定baseURL
const getBaseUrl = () => {
  // 如果使用相对路径，则baseURL为空或/api
  if (process.env.VUE_APP_USE_RELATIVE_PATH === 'true') {
    return process.env.VUE_APP_BASE_API || '/api'
  }
  
  // 开发环境使用localhost
  return process.env.VUE_APP_BASE_API || 'http://localhost:3000'
}

// 创建axios实例
const apiService = axios.create({
  baseURL: getBaseUrl(),
  timeout: 15000
})

// API路径构建函数
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

// 资源URL构建函数（图片等静态资源）
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

// 请求拦截器
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

// 响应拦截器
apiService.interceptors.response.use(
  response => {
    const res = response.data
    return res
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

export default apiService
```

#### c. 修改main.js全局配置

在 `frontend/src/main.js` 中替换硬编码的axios配置：

```javascript
import apiService, { getApiUrl, getResourceUrl } from './utils/api'

// 替换原有的axios全局配置
app.config.globalProperties.$axios = apiService
app.config.globalProperties.$getApiUrl = getApiUrl
app.config.globalProperties.$getResourceUrl = getResourceUrl

// 全局挂载API工具
app.provide('apiService', apiService)
app.provide('getApiUrl', getApiUrl)
app.provide('getResourceUrl', getResourceUrl)
```

### 2. Nginx配置

创建 `nginx/default.conf` 文件：

```nginx
server {
    listen 80;
    server_name localhost;

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
    }

    # 静态资源代理
    location /uploads/ {
        proxy_pass http://backend:3000/uploads/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 3. 修改Docker配置

更新 `docker-compose.yml` 文件：

```yaml
services:
  # Nginx服务
  nginx:
    container_name: aireview-nginx
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
      - frontend_build:/usr/share/nginx/html
    depends_on:
      - frontend
      - backend
    networks:
      - aireview_network
    restart: unless-stopped

  # 前端服务
  frontend:
    container_name: aireview-frontend
    build:
      context: ./frontend
      dockerfile: Dockerfile
    image: aireview-frontend:latest
    volumes:
      - frontend_build:/app/dist
      - frontend_modules:/app/node_modules
    environment:
      - VUE_APP_BASE_API=/api
      - VUE_APP_USE_RELATIVE_PATH=true
    depends_on:
      - backend
    networks:
      - aireview_network

  # 后端服务
  backend:
    container_name: aireview-backend
    build:
      context: ./backend
      dockerfile: Dockerfile
    image: aireview-backend:latest  
    volumes:
      - ./backend:/app
      - backend_modules:/app/node_modules
      - ./backend/logs:/app/logs
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - NODE_ENV=production
      - DB_HOST=db
      - DB_PORT=3306
      - DB_USER=root
      - DB_PASSWORD=root
      - DB_NAME=AIreview
      - DOCKER_HOST=unix:///var/run/docker.sock
      - JUDGE_NETWORK=aireview_network
    depends_on:
      db:
        condition: service_healthy
    networks:
      - aireview_network
    restart: unless-stopped

  # 数据库服务
  db:
    # 配置略（保持不变）

networks:
  aireview_network:
    name: aireview_network
    driver: bridge

volumes:
  db_data:
    name: aireview_db_data
  frontend_modules:
    name: aireview_frontend_modules
  backend_modules:
    name: aireview_backend_modules
  frontend_build:
    name: aireview_frontend_build
```

### 4. 修改前端Dockerfile

更新 `frontend/Dockerfile`：

```dockerfile
# 构建阶段
FROM node:18-alpine as build-stage

WORKDIR /app

COPY package*.json ./
RUN yarn install

COPY . .

# 使用环境变量设置API基础路径
ARG VUE_APP_BASE_API=/api
ARG VUE_APP_USE_RELATIVE_PATH=true

ENV VUE_APP_BASE_API=${VUE_APP_BASE_API}
ENV VUE_APP_USE_RELATIVE_PATH=${VUE_APP_USE_RELATIVE_PATH}

RUN yarn build

# Nginx阶段（此部分可选，如果使用单独的Nginx容器可以省略）
FROM nginx:alpine as production-stage

COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### 5. 处理判题子容器

在后端代码中，应该使用Docker API创建判题容器，并将其连接到相同的Docker网络：

```javascript
// backend/src/services/judge_service.js

// 创建判题容器
const createJudgeContainer = async (submissionId, code, language) => {
  try {
    // 使用环境变量中配置的网络名称
    const networkName = process.env.JUDGE_NETWORK || 'aireview_network';
    
    // 创建判题容器
    const container = await docker.createContainer({
      Image: 'judge-image:latest',
      Cmd: ['node', 'judge.js'],
      Env: [
        `SUBMISSION_ID=${submissionId}`,
        `CODE=${Buffer.from(code).toString('base64')}`,
        `LANGUAGE=${language}`,
        'BACKEND_HOST=backend',
        'BACKEND_PORT=3000'
      ],
      HostConfig: {
        NetworkMode: networkName,
        AutoRemove: true,
      },
      // 其他配置...
    });
    
    // 启动容器
    await container.start();
    
    return container.id;
  } catch (error) {
    console.error('创建判题容器失败:', error);
    throw error;
  }
};
```

## 实现步骤

1. 创建API统一服务文件 `frontend/src/utils/api.js`
2. 修改前端环境变量配置 `frontend/.env`
3. 更新 `main.js` 中的全局API配置
4. 创建Nginx配置文件
5. 更新Docker配置文件
6. 更新判题服务配置

## 总结

通过上述方案，我们将实现：

1. 所有API请求通过统一的apiService进行管理，避免硬编码URL
2. 使用环境变量控制API基础路径，便于切换环境
3. 通过Nginx转发API请求，解决跨域问题
4. 容器间通过Docker网络进行通信，解决判题容器连接问题

这种集中式的配置方法，避免了需要逐个修改源代码中的硬编码URL，只需要在部署时设置适当的环境变量即可。 