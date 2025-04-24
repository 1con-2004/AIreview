# AI智能题目评审系统

这是一个基于AI的智能题目评审系统，主要面向高校学生，提供类似LeetCode的刷题平台功能，并集成了AI代码审查和个性化学习路径推荐功能。

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
- Vue 3
- Vue Router
- Vuex
- PrimeVue UI组件库
- Axios

### 后端
- Node.js + Express
- MySQL 8.0
- JWT认证
- 智谱AI API集成

### 部署
- Docker + Docker Compose
- Nginx
- Node.js环境

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
   chmod +x start-containers.sh
   ./start-containers.sh
   ```

3. **访问应用**
   - 前端：http://localhost
   - 后端API：http://localhost/api
   - 健康检查：http://localhost/health

### 开发模式

1. **前端开发（热重载）**
   ```bash
   chmod +x frontend-hot-reload.sh
   ./frontend-hot-reload.sh
   ```

2. **后端开发**
   ```bash
   chmod +x dev-reload.sh
   ./dev-reload.sh
   ```

## 容器服务

项目使用多容器架构：
- `aireview-nginx`: Web服务器（端口80）
- `aireview-backend`: Node.js后端（端口3000）
- `aireview-db`: MySQL数据库（端口3307）

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

## 常见问题

1. **端口占用**
   - 修改 `docker-compose.yml` 中的端口映射
   - 例如：将 "80:80" 改为 "8080:80"

2. **Docker权限**
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

4. **文件权限**
   ```bash
   # Mac/Linux
   chmod -R 777 uploads
   
   # Windows
   icacls uploads /grant Everyone:(OI)(CI)F
   ```

5. **ESLINT错误**
   ```bash
   例如index.vue文件 有错误 执行
   cd frontend && npx eslint --fix src/views/login/index.vue
   ```
   

## 默认账号

- 管理员账号：admin
- 密码：admin123
- 其他账号: [详见](./docs/accounts.md)

## 技术支持

如遇问题：
1. 查看项目文档
2. 检查容器日志
3. 提交Issue

## 许可证

MIT License