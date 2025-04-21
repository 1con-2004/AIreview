# nginx_login_bug_fixed_log

1. [ ✅ ] 发现在配置Nginx后前端无法登录的问题

2. { 2025.4.21 } 修改了多个文件中的API请求URL配置：

## login/index.vue 文件修改
修改了文件路径为`frontend/src/views/login/index.vue`，将硬编码的URL改为相对路径：
```js
// 修改前（从用户日志中获取的信息）
const response = await fetch('http://localhost:3000/api/login', {
  // ... 其他配置
})

// 修改后
const response = await fetch('/api/login', {
  // ... 其他配置
})
```

## register.vue 文件修改
修改了文件路径为`frontend/src/views/login/register.vue`，将硬编码的URL改为相对路径：
```js
// 修改前
const response = await axios.request({
  method: 'post',
  url: 'http://localhost:3000/api/auth/send-email-code',
  // ... 其他配置
})

// 修改后
const response = await axios.request({
  method: 'post',
  url: '/api/auth/send-email-code',
  // ... 其他配置
})

// 修改前
const response = await axios.post('http://localhost:3000/api/auth/register', {
  // ... 请求数据
})

// 修改后
const response = await axios.post('/api/auth/register', {
  // ... 请求数据
})
```

## reset-password.vue 文件修改
修改了文件路径为`frontend/src/views/login/reset-password.vue`，将硬编码的URL改为相对路径：
```js
// 修改前
const response = await axios.request({
  method: 'post',
  url: 'http://localhost:3000/api/auth/send-reset-code',
  // ... 其他配置
})

// 修改后
const response = await axios.request({
  method: 'post',
  url: '/api/auth/send-reset-code',
  // ... 其他配置
})

// 修改前
const response = await axios.post('http://localhost:3000/api/auth/reset-password', {
  // ... 请求数据
})

// 修改后
const response = await axios.post('/api/auth/reset-password', {
  // ... 请求数据
})
```

## utils/request.js 文件修改
修改了文件路径为`frontend/src/utils/request.js`，调整了axios基础URL的设置：
```js
// 修改前
baseURL: process.env.VUE_APP_BASE_API || 'http://localhost:3000',

// 修改后
baseURL: process.env.VUE_APP_BASE_API || '',
```

3. [ ✅ ] 对于Nginx下登录失败问题的解决方案：

- 问题原因：前端多处代码中API请求地址硬编码为`http://localhost:3000`，但在Nginx代理环境下，API请求应该指向相对路径`/api`，而不是绝对URL
  
- 修复方法：修改所有前端请求配置，包括登录、注册、重置密码等页面中的API请求URL，将它们从硬编码的绝对路径改为相对路径，使请求可以通过Nginx代理正确处理
  
- 验证结果：重新构建并启动容器后，前端可以正常通过Nginx代理发送各种API请求，解决了跨域问题和登录故障

# 处理过程记录

1. 检查了Docker容器日志，发现前端正常启动，但API请求失败
2. 检查Nginx日志，发现Nginx正常代理静态文件，但没有API请求记录
3. 检查前端代码，发现多处API请求直接硬编码了`http://localhost:3000`，导致请求绕过Nginx代理
4. 修改request.js以及各登录相关页面中的URL配置，使用相对路径替代硬编码的绝对URL
5. 重新构建并启动容器，验证问题解决

# 注意事项

在使用Nginx作为前端和后端的代理服务器时，前端的API请求地址不应该硬编码为特定URL，而应该使用相对路径，让Nginx正确代理请求。这个问题特别常见于前端代码中直接使用fetch或axios发送请求时，需要特别注意确保所有请求都通过Nginx代理。 

# 新增记录（2025.4.25）

1. [ ✅ ] 发现前端通过8080端口无法登录，浏览器控制台仍然显示调用本地接口的问题

2. { 2025.4.25 } 修改了全局API配置文件：

## 解决方案

修改了文件路径为`frontend/src/utils/api.js`，将所有API请求路径逻辑改为始终使用相对路径：

```js
// 修改前
const getBaseUrl = () => {
  // 如果使用相对路径，则baseURL为空或/api
  if (process.env.VUE_APP_USE_RELATIVE_PATH === 'true') {
    return process.env.VUE_APP_BASE_API || '/api'
  }
  
  // 开发环境使用localhost
  return process.env.VUE_APP_BASE_API || 'http://localhost:3000'
}

// 修改后
const getBaseUrl = () => {
  // 始终使用相对路径，确保通过Nginx代理
  return process.env.VUE_APP_BASE_API || '/api'
}
```

同样修改了`getApiUrl`和`getResourceUrl`函数，确保它们始终返回相对路径：

```js
// 修改前（getApiUrl函数）
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

// 修改后（getApiUrl函数）
export const getApiUrl = (path) => {
  // 确保path不以/开头，避免重复
  const cleanPath = path.startsWith('/') ? path.slice(1) : path
  
  // 始终使用相对路径
  return `${process.env.VUE_APP_BASE_API || '/api'}/${cleanPath}`
}

// 修改前（getResourceUrl函数）
export const getResourceUrl = (path) => {
  // ... 其他代码 ...
  
  // 如果使用相对路径
  if (process.env.VUE_APP_USE_RELATIVE_PATH === 'true') {
    // 如果path已经包含/uploads等前缀，则直接返回
    return `/${cleanPath}`
  }
  
  // 开发环境返回完整URL
  return `${process.env.VUE_APP_BASE_API || 'http://localhost:3000'}/${cleanPath}`
}

// 修改后（getResourceUrl函数）
export const getResourceUrl = (path) => {
  // ... 其他代码 ...
  
  // 始终使用相对路径
  return `/${cleanPath}`
}
```

3. [ ✅ ] 对于通过8080端口无法登录问题的解决方案：

- 问题原因：
  1. 虽然前端项目在`.env`文件中配置了`VUE_APP_USE_RELATIVE_PATH=true`，但`api.js`中的条件判断仍可能不生效，因为Docker容器可能没有正确应用环境变量。
  2. 在`utils/api.js`中仍有对`http://localhost:3000`的硬编码引用，导致即便修改了`login/index.vue`和其他页面，全局请求工具仍可能使用绝对路径。
  
- 修复方法：
  1. 修改全局API配置文件`utils/api.js`，移除所有环境变量条件判断，始终使用相对路径。
  2. 删除所有对`http://localhost:3000`的引用，确保所有API请求都通过Nginx代理。
  3. 重新构建并启动前端Docker容器，使新的配置生效。
  
- 验证结果：
  1. 重新构建并启动容器后，前端可以正常通过Nginx代理（80端口）发送请求并登录。
  2. 虽然8080端口仍然可以访问前端，但API请求会通过相对路径发送，这样请求会发送到同源的8080端口，然后被Nginx正确代理到后端。

# 注意事项

在使用Docker和Nginx部署Web应用时，前端配置中的API请求路径设置至关重要：

1. **相对路径优于绝对路径**：
   - 在前端代码中，始终使用相对路径（如`/api/login`）而不是绝对URL（如`http://localhost:3000/api/login`）
   - 这确保请求会发送到当前页面的同源服务器，然后由Nginx正确代理

2. **避免依赖环境变量判断**：
   - 在Docker容器中，环境变量可能不一定按预期加载或工作
   - 建议在代码中使用更直接的方式，确保API路径配置正确

3. **构建时静态替换**：
   - 对于Vue项目，环境变量会在构建时被静态替换，确保在`.env`文件中正确设置这些变量
   - 构建完成后再修改环境变量不会影响已编译的代码

4. **注意隐式API调用**：
   - 除了直接的API调用外，还要检查可能隐藏在工具函数、组件或服务中的API调用
   - 全局请求工具（如axios实例）的配置对整个应用的请求都有影响 