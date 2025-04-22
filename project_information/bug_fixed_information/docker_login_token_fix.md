# docker_login_token_fix

1. [ ✅ ] 发现在Docker环境中登录后localStorage不保存token的问题

2. { 2024.7.12 } 修改了以下文件：
   - `frontend/src/utils/request.js`，将baseURL从绝对路径修改为相对路径
   - `frontend/src/views/login/index.vue`，简化localStorage存储逻辑
   - `frontend/src/store/index.js`，修改token存储和初始化机制
   - `frontend/src/main.js`，添加状态初始化代码

3. [ ✅ ] 对于Docker环境下登录时token无法保存到localStorage的问题解决方案：

   - 绝对路径问题：在Docker环境中，使用绝对URL会导致跨域问题，通过将baseURL修改为相对路径解决
   - 存储逻辑复杂：原有token存储逻辑过于复杂，可能在某些条件下失败，通过简化存储流程解决
   - 缺乏统一管理：token管理逻辑分散且不统一，通过增强请求拦截器中的token获取逻辑解决
   - 缺乏调试功能：增强了登录诊断功能，方便排查登录和token相关问题

# 修复细节

## 问题原因分析

1. Docker环境配置问题：
   - 在Docker容器中，通过Nginx代理转发请求，但前端代码中使用了绝对URL（http://localhost）
   - 这导致在Docker环境中可能出现跨域问题，影响token的存储和使用

2. localStorage存储逻辑问题：
   - 原登录逻辑中采用了分步骤存储用户信息和token的方式
   - 当步骤1成功而步骤2失败时，会导致token保存但userInfo未保存的问题
   - 存储逻辑过于复杂，增加了失败的可能性

3. token获取逻辑不够健壮：
   - 原有代码中token获取逻辑不够完善，当主要获取方式失败时缺乏备选方案

## 解决方案

1. URL策略调整：
   - 将axios实例的baseURL从绝对路径（http://localhost）改为相对路径（''）
   - 这样请求会根据当前页面的主机名自动构建完整URL，避免跨域问题

2. 简化token存储：
   - 简化登录时的token存储流程，确保token能够可靠地保存到localStorage
   - 减少存储步骤，降低失败的可能性

3. 多级token获取：
   - 增强请求拦截器中的token获取逻辑，按照以下顺序尝试获取token：
     1. 首先检查请求头是否已设置
     2. 从localStorage中直接获取accessToken
     3. 从localStorage中的userInfo对象获取
     4. 从Vuex存储中获取
   - 每次成功获取token后，确保同步到localStorage，提高系统一致性

4. 增强诊断功能：
   - 添加详细的登录诊断功能，可以检查：
     - localStorage中的token和用户信息
     - sessionStorage中的备用存储
     - axios请求头中的Authorization设置
     - Vuex状态中的token
     - Docker环境信息
     - localStorage功能测试

## 测试验证

经过修复后，在Docker环境中进行了以下测试：
- 登录功能测试：确认用户能够成功登录并保存token
- token持久化测试：刷新页面后，token仍然可用
- 跨页面测试：确保在不同页面之间切换时token仍然有效
- 请求拦截测试：验证请求携带的Authorization头正确

所有测试均成功通过，证明问题已经解决。 