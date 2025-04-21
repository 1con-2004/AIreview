# Docker部署指南使用文档

## 如何应用全局API配置方案

本文档介绍如何将Docker部署指南中的全局API配置方案应用到您的项目中，以解决硬编码API地址问题。

### 准备工作

1. 创建必要的文件和目录结构：

```bash
# 创建nginx配置目录
mkdir -p nginx

# 确保其他目录存在
mkdir -p frontend/src/utils
```

### 步骤1：实现API配置文件

1. 创建API统一服务文件：

```bash
# 将api.js文件放入utils目录
touch frontend/src/utils/api.js
```

2. 修改.env文件：

```bash
# 编辑前端环境变量
vim frontend/.env
```

### 步骤2：修改前端文件引用方式

您需要在项目中替换硬编码的API请求方式。以下是一些常见的替换方法：

#### 替换axios直接调用

**原代码：**
```javascript
axios.get('http://localhost:3000/api/problems')
```

**修改为：**
```javascript
import apiService from '@/utils/api'

// 方法1：直接使用apiService
apiService.get('/api/problems')

// 方法2：使用getApiUrl辅助函数
import { getApiUrl } from '@/utils/api'
axios.get(getApiUrl('api/problems'))
```

#### 替换资源URL

**原代码：**
```javascript
const avatarUrl = `http://localhost:3000/uploads/avatars/${fileName}`
```

**修改为：**
```javascript
import { getResourceUrl } from '@/utils/api'

const avatarUrl = getResourceUrl(`uploads/avatars/${fileName}`)
```

### 步骤3：更新main.js

在main.js中添加全局配置：

```javascript
import apiService, { getApiUrl, getResourceUrl } from './utils/api'

// 注册为全局属性
app.config.globalProperties.$axios = apiService
app.config.globalProperties.$getApiUrl = getApiUrl
app.config.globalProperties.$getResourceUrl = getResourceUrl

// 全局挂载API工具
app.provide('apiService', apiService)
app.provide('getApiUrl', getApiUrl)
app.provide('getResourceUrl', getResourceUrl)
```

### 步骤4：创建Nginx配置

1. 创建nginx配置文件：

```bash
touch nginx/default.conf
```

2. 将Docker部署指南中的nginx配置复制到该文件。

### 步骤5：修改docker-compose.yml

更新您的docker-compose.yml文件以包含nginx服务和相关配置。

### 步骤6：更新Dockerfile

按照指南更新前端的Dockerfile，确保环境变量正确设置。

### 测试与验证

在应用全局配置后，请进行以下测试：

1. 本地开发环境测试：
   ```bash
   cd frontend
   yarn serve
   ```

2. Docker环境测试：
   ```bash
   docker-compose up --build
   ```

3. 验证API请求是否正常工作：
   - 登录功能
   - 数据获取
   - 图片和资源加载

### 常见问题

1. **API请求404错误**
   - 检查nginx配置中的proxy_pass设置
   - 确认backend服务正常运行

2. **环境变量未生效**
   - 确认.env文件正确配置
   - 检查Dockerfile中的环境变量设置

3. **静态资源加载失败**
   - 检查nginx中的静态资源代理配置
   - 确认资源路径使用了getResourceUrl函数

4. **容器间通信问题**
   - 确保所有容器都在同一网络
   - 检查服务名称是否与docker-compose中定义的一致

## 迁移策略

为避免一次性修改所有代码导致的风险，建议采用以下迁移策略：

1. **先创建全局API配置文件**：实现api.js但暂不全面应用

2. **逐步迁移关键组件**：
   - 先迁移核心功能（如登录、数据获取）
   - 然后是次要功能
   - 最后是静态资源

3. **并行测试**：在迁移过程中保持两套环境并行运行进行比对测试

4. **增量部署**：采用小步快跑的方式，每次迁移一小部分并测试

## 附录：常用API替换参考

以下是项目中常见API调用的替换参考：

### 1. 获取问题列表

**原代码**：
```javascript
axios.get('http://localhost:3000/api/problems')
```

**替换为**：
```javascript
apiService.get('/api/problems')
```

### 2. 提交代码

**原代码**：
```javascript
axios.post(`http://localhost:3000/api/judge/problems/${problemId}/submit`, data)
```

**替换为**：
```javascript
apiService.post(`/api/judge/problems/${problemId}/submit`, data)
```

### 3. 用户登录

**原代码**：
```javascript
fetch('http://localhost:3000/api/login', {
  method: 'POST',
  // ...
})
```

**替换为**：
```javascript
fetch(getApiUrl('api/login'), {
  method: 'POST',
  // ...
})
```

### 4. 获取头像

**原代码**：
```javascript
const avatarUrl = `http://localhost:3000/uploads/avatars/${fileName}`
```

**替换为**：
```javascript
const avatarUrl = getResourceUrl(`uploads/avatars/${fileName}`)
```

通过遵循以上指南，您可以成功将项目迁移到使用全局API配置，从而解决Docker部署时的跨域和硬编码API地址问题。 