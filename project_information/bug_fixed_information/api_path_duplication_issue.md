# API路径重复问题修复记录

1. [ ✅ ] 发现用户资料弹窗和头像无法正确获取的问题，请求URL中出现了重复的`/api`路径(形如`/api/api/user/user-profile/admin`)。

2. { 2025.4.22 } 修改了以下文件:

- `frontend/src/components/UserProfileDialog.vue`：修改API请求路径，移除重复的`/api`前缀
- `frontend/src/utils/api.js`：优化`getApiUrl`函数，检测并避免重复添加`/api`前缀
- `frontend/src/utils/api.js`：调整`getBaseUrl`函数，避免在环境变量已设置的情况下重复添加前缀

3. [ ✅ ] 对于API路径重复问题的解决方案包括:

- 在组件中发送API请求时，不再手动添加`/api`前缀
- 修改`getApiUrl`函数，检测参数中是否已包含`api/`前缀，如果已包含则不再添加`/api`
- 优化`getBaseUrl`函数，防止环境变量和默认值重复设置`/api`前缀

## 问题出现原因

Docker环境和开发环境中的API路径处理存在差异：

1. 在Docker环境中，环境变量`VUE_APP_BASE_API`被设置为`/api`
2. 同时，在代码中手动添加了`/api`前缀到请求路径中
3. 这导致最终请求变成了`/api/api/xxx`的形式，造成404错误

## 解决方案

修复了以下三处代码：

1. 在`UserProfileDialog.vue`中：
   - 将`/api/user/user-profile/${username}`改为`user/user-profile/${username}`
   - 将`/api/user/user-profile`改为`user/user-profile`
   - 将`getApiUrl('api/user/avatar')`改为`getApiUrl('user/avatar')`

2. 在`api.js`中的`getApiUrl`函数：
   - 添加检查以避免重复添加`/api`前缀：
   ```javascript
   // 检查cleanPath是否已经包含api前缀，如果是，不要添加/api
   if (cleanPath.startsWith('api/')) {
     return `/${cleanPath}`
   }
   ```

3. 在`api.js`中的`getBaseUrl`函数：
   - 优化逻辑，避免同时使用环境变量和默认值：
   ```javascript
   // 检查环境变量是否已设置
   if (process.env.VUE_APP_BASE_API) {
     return process.env.VUE_APP_BASE_API
   }
   
   // 默认使用相对路径
   return '/api'
   ```

## 验证结果

修复后，用户资料弹窗和头像能正确获取数据，解决了API路径重复导致的404错误问题。 