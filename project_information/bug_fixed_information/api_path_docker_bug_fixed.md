# API路径Docker环境Bug修复记录

1. [ ✅ ] 在Docker环境下，由于Nginx配置的反向代理，前端API请求路径出现了重复的`/api/api/`前缀导致404错误

2. { 2023-04-22 } 修改了以下文件以解决问题：
   - `frontend/src/views/problems/detail/ProblemDetail.vue`：修复在`fetchProblem`和`fetchSubmissions`方法中重复的`/api/`前缀
   - `frontend/src/api/testCase.js`：将所有直接使用`axios`的API调用改为使用已配置好的`request`实例，并移除所有重复的`/api/`前缀

3. [ ✅ ] 问题解决方案：
   - 在Docker环境中，Nginx反向代理将`/api/`路径代理到后端服务
   - 前端API服务实例已经配置了`baseURL: '/api'`
   - 在API请求路径中不应再添加`/api/`前缀
   - 使用规范的API请求实例（如项目中已配置的`request`或`apiService`），避免直接使用axios实例

## 问题出现原因

在Docker环境中，Nginx配置了路径反向代理：
```nginx
# API请求代理
location /api/ {
    proxy_pass http://backend:3000/api/;
    # ...其他配置
}
```

而前端代码中的axios实例已经配置了`baseURL: '/api'`，当请求路径写成`/api/xxx`时，实际请求变成了`/api/api/xxx`，导致后端无法找到对应路由。

## 解决问题的建议

1. 确保所有API请求使用项目配置的axios实例（如`request`或`apiService`）
2. API路径不要添加开头的`/api/`前缀
3. 对于需要直接使用`axios`的情况，要特别注意路径问题
4. 考虑在API路径处理函数中增加检测重复前缀的逻辑 