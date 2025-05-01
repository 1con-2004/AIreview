# 后端服务

本目录包含AIreview系统的后端服务代码，基于Node.js和Express框架构建，提供API接口、业务逻辑处理、数据库交互等功能。

## 目录结构

```
backend/
├── config/          # 配置文件目录
│   ├── index.js     # 主配置文件
│   └── database.js  # 数据库配置
├── logs/            # 日志文件目录
├── public/          # 静态资源文件目录
│   ├── icons/       # 图标资源
│   └── uploads/     # 上传文件存储目录
├── routes/          # 旧版路由配置目录(部分遗留代码)
├── src/             # 源代码目录
│   ├── api/         # API接口定义
│   │   ├── admin/   # 管理员相关API
│   │   ├── ai/      # AI功能相关API
│   │   ├── user/    # 用户相关API
│   │   └── ...      # 其他API模块
│   ├── config/      # 配置文件
│   ├── controllers/ # 控制器
│   ├── middleware/  # 中间件
│   ├── routes/      # 新版路由配置
│   ├── services/    # 服务层
│   │   ├── ai/      # AI服务
│   │   ├── judge/   # 判题服务
│   │   └── ...      # 其他服务
│   ├── utils/       # 工具函数
│   └── ...          # 其他目录
├── temp/            # 临时文件目录
├── .env             # 环境变量配置
├── .eslintrc.js     # ESLint配置
├── app.js           # 应用入口文件
├── package.json     # 项目依赖配置
└── server.js        # 服务器启动文件
```

## 主要功能模块

### 1. 用户认证与管理
- 用户注册、登录、登出
- JWT身份验证
- 用户资料管理
- 权限控制

### 2. 题目与评测
- 题目管理
- 代码提交与评测
- 提交历史查询
- 多语言支持

### 3. AI辅助功能
- 智谱AI代码审核
- DeepSeek代码分析
- 学习路径推荐
- AI对话支持

### 4. 教学管理
- 课堂创建与管理
- 作业布置与批改
- 学习计划制定
- 学习进度跟踪

### 5. 社区功能
- 讨论区
- 代码分享
- 用户互动

## 技术栈

- **核心框架**: Node.js + Express
- **数据库**: MySQL 8.0 (使用mysql2/promise库)
- **认证**: JWT (jsonwebtoken)
- **安全**: bcrypt (密码加密)、CORS (跨域资源共享)
- **文件处理**: multer (文件上传)
- **AI集成**: 智谱AI、DeepSeek AI
- **其他工具**: dotenv (环境变量)、winston (日志)

## 本地开发

1. 安装依赖:
```bash
yarn install
```

2. 配置环境变量:
```bash
cp .env.example .env
# 编辑.env文件配置数据库连接等信息
```

3. 启动开发服务器:
```bash
yarn dev
```

4. 启动生产服务器:
```bash
yarn start
```

## API文档

详细的API接口文档请参考 `project_information/api_information/backend_api.md`

## 日志管理

系统使用winston库进行日志管理，日志文件存储在`logs/`目录下。
可通过环境变量`LOG_LEVEL`或使用`log-manager.sh`脚本动态调整日志级别:

- 0: 静默模式
- 1: 错误模式
- 2: 标准模式
- 3: 调试模式
- 4: 详细模式

## Docker部署

后端服务已配置Docker支持，详细部署说明请参考项目根目录的`docker-deployment-guide.md`和`docker-compose.yml`。 