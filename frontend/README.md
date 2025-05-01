# 前端应用

本目录包含AIreview系统的前端应用代码，基于Vue 3框架构建，提供用户界面、交互逻辑和API调用等功能。

## 目录结构

```
frontend/
├── dist/            # 构建输出目录
├── public/          # 公共静态资源目录
│   ├── fonts/       # 字体文件
│   ├── icons/       # 图标资源
│   ├── images/      # 图片资源
│   └── uploads/     # 上传文件目录
├── src/             # 源代码目录
│   ├── api/         # API请求模块
│   ├── assets/      # 静态资源
│   │   ├── icons/   # 图标
│   │   ├── images/  # 图片
│   │   └── styles/  # 样式文件
│   ├── components/  # 组件目录
│   │   ├── common/      # 通用组件
│   │   ├── layout/      # 布局组件
│   │   ├── learning-path/ # 学习路径组件
│   │   ├── personal/    # 个人中心组件
│   │   └── problem/     # 题目相关组件
│   ├── controllers/  # 控制器
│   ├── router/      # 路由配置
│   ├── store/       # Vuex状态管理
│   ├── utils/       # 工具函数
│   ├── views/       # 页面视图
│   │   ├── admin/        # 管理员页面
│   │   ├── classroom/    # 课堂页面
│   │   ├── community/    # 社区页面
│   │   ├── home/         # 首页
│   │   ├── learning-plans/ # 学习计划页面
│   │   ├── login/        # 登录页面
│   │   ├── personal/     # 个人中心
│   │   ├── problems/     # 题目页面
│   │   └── user/         # 用户相关页面
│   ├── App.vue      # 根组件
│   ├── main.js      # 入口文件
│   └── permission.js # 权限控制
├── .babelrc        # Babel配置
├── .env            # 环境变量配置
├── .env.production # 生产环境变量
├── .eslintrc.js    # ESLint配置
├── .gitignore      # Git忽略文件
├── package.json    # 项目依赖配置
└── vue.config.js   # Vue配置文件
```

## 主要功能模块

### 1. 用户界面
- 登录与注册
- 个人中心
- 题目列表与详情
- 代码编辑器
- 管理员控制台

### 2. 题目与学习
- 题目浏览与搜索
- 代码提交与测试
- 学习计划与路径
- 学习进度追踪

### 3. AI交互
- AI代码审核结果展示
- 学习路径推荐
- AI辅助提示
- DeepSeek对话界面

### 4. 社区功能
- 讨论区
- 代码分享
- 用户互动

### 5. 课堂管理
- 课堂创建与加入
- 作业管理
- 学生管理
- 课程资料

## 技术栈

- **核心框架**: Vue 3
- **状态管理**: Vuex
- **路由管理**: Vue Router
- **UI组件库**: PrimeVue
- **HTTP请求**: Axios
- **WebSocket**: 用于实时通信
- **工具库**: js-cookie, dayjs等
- **CSS预处理器**: SCSS
- **构建工具**: Vue CLI (基于Webpack)

## 本地开发

1. 安装依赖:
```bash
yarn install
```

2. 启动开发服务器:
```bash
yarn serve
```

3. 构建生产版本:
```bash
yarn build
```

4. 代码检查:
```bash
yarn lint
```

## 构建与部署

### 开发环境构建
```bash
yarn build:dev
```

### 生产环境构建
```bash
yarn build:prod
```

### Docker部署
前端应用已配置Docker支持，详细部署说明请参考项目根目录的`docker-deployment-guide.md`和`docker-compose.yml`。

## 浏览器兼容性

支持所有现代浏览器:
- Chrome (推荐)
- Firefox
- Safari
- Edge (Chromium版本)

不支持Internet Explorer。

## 代码风格与规范

项目使用ESLint + Prettier进行代码规范检查和格式化。提交代码前请确保通过lint检查:

```bash
yarn lint:fix
```

