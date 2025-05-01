# 前端埋点工具使用指南

## 简介

前端埋点工具 `analytics.js` 用于收集用户行为数据，支持多种事件类型的跟踪，并提供批量定期上报机制，减少网络请求次数，提高性能。

## 初始化

在应用启动时初始化埋点系统：

```javascript
import analytics from '@/utils/analytics';

// 在应用入口处调用初始化方法
analytics.init();
```

## 埋点事件类型

支持以下几种主要事件类型：

1. **页面访问** (`page_view`): 记录用户访问的页面
2. **点击事件** (`click`): 记录用户点击的元素
3. **筛选事件** (`filter`): 记录用户使用的筛选条件
4. **分页事件** (`pagination`): 记录用户进行的分页操作
5. **自定义事件** (`custom`): 记录其他类型的用户行为

## 使用方法

### 跟踪页面访问

```javascript
// 在路由切换时调用
analytics.trackPageView('首页', { source: 'direct' });
```

### 跟踪点击事件

```javascript
// 用户点击按钮时调用
analytics.trackClick('登录按钮', 'login-btn', { position: 'header' });
```

### 跟踪筛选事件

```javascript
// 用户使用筛选功能时调用
analytics.trackFilter('难度级别', 'medium', { category: '算法题' });
```

### 跟踪分页事件

```javascript
// 用户切换页面时调用
analytics.trackPagination('问题列表', 2, { itemsPerPage: 10 });
```

### 跟踪自定义事件

```javascript
// 其他类型的用户行为
analytics.trackEvent('社区', '发布评论', { postId: '123', commentLength: 150 });
```

## 高级配置

可以通过修改以下属性来自定义埋点行为：

```javascript
// 开启或关闭埋点功能
analytics.enabled = true;

// 开启或关闭调试模式（控制台输出）
analytics.debugMode = true;

// 修改上报间隔（毫秒）
analytics.reportInterval = 10000; // 默认10秒

// 修改批量上报的最大事件数
analytics.maxBatchSize = 20; // 默认20条
```

## 工作原理

1. 埋点工具会收集用户行为事件，并存储在内存中的事件队列
2. 当满足以下条件之一时，会将事件批量上报到服务器：
   - 达到了配置的上报间隔时间（默认10秒）
   - 累积的事件数达到了最大批量大小（默认20条）
   - 用户离开页面时（使用 `beforeunload` 事件）
3. 所有埋点数据同时会保存在 localStorage 中（最新的100条记录），方便本地调试

## 离线支持

当网络不可用时，埋点事件会保留在内存中，并在下次联网时尝试重新发送。页面关闭前会尝试通过 `navigator.sendBeacon` API发送数据，以提高数据发送的可靠性。

## 注意事项

1. 不要在性能关键路径上频繁调用埋点方法
2. 不要在同一个用户操作中重复调用同一埋点方法
3. 确保传入的数据不包含敏感信息
4. 埋点数据会定期清理，默认保留90天 