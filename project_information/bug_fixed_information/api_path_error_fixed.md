# API路径错误修复日志

## 问题描述

在Docker部署环境中，前端页面在访问题目页面时，出现多个API接口404错误，包括：
- `/api/api/learning-plans`
- `/api/api/problems/all-categories`
- `/api/api/problems/tags`
- `/api/api/problems?page=1&limit=10&search=&difficulty=&status=`

这些错误导致页面无法正常加载数据，表现为空白的学习计划、空白的题目列表和分类列表。

## 问题分析

通过查看请求日志和前端代码，发现问题出在请求URL路径重复出现了`/api`前缀：

1. 在Docker环境中，前端的环境变量`VUE_APP_BASE_API`被设置为`/api`
2. 在`request.js`文件中，axios实例的`baseURL`被设置为`process.env.VUE_APP_BASE_API || ''`，导致所有请求自动添加`/api`前缀
3. 而在实际的API请求路径中，开发者又手动添加了`/api`前缀，如请求`/api/learning-plans`
4. 最终发送到nginx的请求变成了`/api/api/learning-plans`，而后端并没有这样的路由，导致404错误

## 解决方案

1. 修改前端的`request.js`文件，将`baseURL`设置为空字符串，不再自动添加`/api`前缀：

```js
// 修改前
const service = axios.create({
  baseURL: process.env.VUE_APP_BASE_API || '',
  timeout: 15000
})

// 修改后
const service = axios.create({
  baseURL: '',  // 将baseURL设置为空字符串，不再自动添加前缀
  timeout: 15000
})
```

2. 重新构建前端容器：
```bash
docker-compose down
docker-compose up -d --build frontend
docker-compose up -d
```

## 解决结果

修复后，前端请求正确发送到`/api/learning-plans`等路径，nginx正确代理到后端服务，问题解决。

## 修复时间

- 发现问题时间：2025年4月21日
- 修复完成时间：2025年4月21日

## 预防措施

为避免类似问题再次发生，建议：

1. 在API请求中统一使用相对路径，避免手动添加前缀
2. 在项目文档中明确说明baseURL的配置和使用方式
3. 在开发环境和生产环境测试中，增加API请求路径的检查 