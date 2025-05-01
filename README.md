# AI智能题目评审系统

这是一个基于AI的智能题目评审系统，主要面向高校学生，提供类似LeetCode的刷题平台功能，并集成了AI代码审查和个性化学习路径推荐功能。系统旨在帮助学生提高编程能力，同时通过AI辅助提供更智能化的学习体验。

## 项目特点

- **智能代码评审**: 集成智谱AI和DeepSeek AI，提供专业代码审查
- **个性化学习路径**: 基于用户学习情况智能推荐学习路径
- **多语言支持**: 支持多种编程语言的在线编程与评测
- **实时反馈**: 提供即时的代码执行结果与改进建议
- **社区互动**: 用户可分享代码、讨论解题思路
- **课堂管理**: 支持教师创建课堂、布置作业和管理学生

## 项目结构

```
AIreview/
├── backend/              # 后端代码
│   ├── config/          # 配置文件
│   ├── logs/           # 日志文件
│   ├── public/         # 静态资源
│   ├── routes/         # 路由配置
│   └── src/            # 源代码
│       ├── api/        # API接口
│       ├── controllers/# 控制器
│       ├── middleware/ # 中间件
│       ├── services/   # 服务层
│       └── utils/      # 工具函数
├── frontend/            # 前端代码
│   ├── dist/           # 构建输出
│   ├── public/         # 静态资源
│   └── src/            # 源代码
│       ├── api/        # API请求
│       ├── assets/     # 资源文件
│       ├── components/ # 组件
│       ├── router/     # 路由配置
│       ├── store/      # 状态管理
│       ├── utils/      # 工具函数
│       └── views/      # 页面视图
├── nginx/              # Nginx配置
├── db/                 # 数据库初始化脚本
└── docs/              # 项目文档
```

## 技术栈

### 前端
- Vue 3 + Vue Router + Vuex
- PrimeVue UI组件库
- Axios + WebSocket
- js-cookie, dayjs等工具库

### 后端
- Node.js + Express
- MySQL 8.0
- JWT认证
- 智谱AI + DeepSeek AI API集成
- multer文件处理

### 部署
- Docker + Docker Compose
- Nginx反向代理
- 桥接网络配置
- 卷挂载管理

## 快速开始

### Docker部署（推荐）

1. **安装Docker和Docker Compose**
   - [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
   - [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)

2. **启动项目**

   Windows:
   ```bash
   # 双击运行
   start-containers.bat
   ```

   Mac/Linux:
   ```bash
   # 首次运行授予执行权限
   chmod +x start-containers.sh

   # 启动容器
   ./start-containers.sh
   ```

3. **访问应用**
   - 前端：http://localhost
   - 后端API：http://localhost/api
   - 健康检查：http://localhost/health

### 开发模式(针对MacOS系统)

1. **如果只修改了前端代码**
   ```bash
   # 进入前端
   cd frontend

   # 删除旧的dist目录
   sudo rm -rf dist

   # 创建新的dist目录并设置权限
   mkdir -p dist
   sudo chown -R $USER:staff dist
   chmod -R 755 dist

   # 构建项目
   yarn build

   # 重启Nginx容器
   cd ..
   docker restart aireview-nginx
   ```

2. **如果只修改了后端**
   ```bash
   # 在项目根目录下设置权限
   sudo chown -R $USER:staff backend
   chmod -R 755 backend
   
   # 重启后端容器
   docker restart aireview-backend
   ```

3. **如果同时修改了前端和后端**
   ```bash
   # 处理前端
   cd frontend
   sudo rm -rf dist
   mkdir -p dist
   sudo chown -R $USER:staff dist
   chmod -R 755 dist
   yarn build
   cd ..

   # 处理后端权限
   sudo chown -R $USER:staff backend
   chmod -R 755 backend

   # 重启两个容器
   docker restart aireview-nginx aireview-backend
   ```

## 容器服务

项目使用多容器架构：
- `aireview-nginx`: Web服务器（端口80）
- `aireview-backend`: Node.js后端（端口3000, 内部）
- `aireview-db`: MySQL数据库（端口3307 -> 3306）

## 常用维护命令

1. **容器管理**
   ```bash
   # 查看状态
   docker-compose ps
   
   # 查看日志
   docker-compose logs -f
   
   # 重启服务
   docker-compose restart
   
   # 停止所有服务
   docker-compose down
   ```

2. **环境清理**
   ```bash
   # Windows
   docker-cleanup.bat
   
   # Mac/Linux
   ./docker-cleanup.sh
   ```

## 日志管理

使用日志管理脚本控制输出级别：
```bash
chmod +x log-manager.sh
./log-manager.sh
```

日志级别：
- 0: 静默模式
- 1: 错误模式
- 2: 标准模式
- 3: 调试模式
- 4: 详细模式

## 常见问题排查

1. **端口占用**
   - 修改 `docker-compose.yml` 中的端口映射
   - 例如：将 "80:80" 改为 "8080:80"

2. **Docker权限问题**
   ```bash
   # Mac/Linux
   sudo ./fix-docker-permissions.sh
   ```

3. **数据库连接**
   - 主机：localhost
   - 端口：3307
   - 用户名：root
   - 密码：root
   - 数据库：AIreview

4. **文件权限问题**
   ```bash
   # Mac/Linux
   chmod -R 777 uploads
   
   # Windows
   icacls uploads /grant Everyone:(OI)(CI)F
   ```

5. **前端构建错误**
   ```bash
   cd frontend
   rm -rf node_modules
   yarn install
   yarn build
   ```

6. **后端启动失败**
   ```bash
   # 检查日志
   docker logs aireview-backend
   
   # 重建后端容器
   docker-compose up -d --build backend
   ```

7. **ESLint错误修复**
   ```bash
   cd frontend && npx eslint --fix src/path/to/file.vue
   ```

## 默认账号

- 管理员账号：admin
- 密码：admin123

## 项目文档

更多详细信息请查看项目文档目录：
- 架构设计：`docs/architecture.md`
- API文档：`project_information/api_information/`
- 部署指南：`docker-deployment-guide.md`
- 技术规范：`project_information/`

## 技术支持

如遇问题：
1. 查看项目文档
2. 检查容器日志
3. 提交Issue

## 许可证

MIT License