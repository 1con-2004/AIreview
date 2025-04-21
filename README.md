# AI智能题目评审系统

这是一个基于AI的智能题目评审系统，主要面向高校学生，提供类似LeetCode的刷题平台功能，并集成了AI代码审查和个性化学习路径推荐功能。

## 特点

- 完善的OI判题功能
- 丰富的学生信息状态展示
- 多维度的数据分析图表
- 集成多种AI大模型辅助功能
- 支持自定义题库和学习路径

## 技术栈

### 前端
- Vue 3
- Vue Router
- Vuex
- Element Plus

### 后端
- Node.js + Express
- MySQL
- JWT认证
- Docker（用于判题环境）

## 目录结构

```
├── frontend/          # 前端代码（Vue3）
├── backend/           # 后端代码（Node.js）
├── 数据库文件/         # 数据库相关文件
└── docs/             # 项目文档
```

## 环境要求

### 必需环境
- Node.js >= 14.x
- Yarn >= 1.22.x
- MySQL >= 8.0

### 推荐开发工具
- Visual Studio Code
- Navicat（用于数据库管理）
- Git

## 安装步骤

### 1. 安装必需环境

#### Windows系统：
1. 下载并安装 [Node.js](https://nodejs.org/)
2. 下载并安装 [MySQL](https://dev.mysql.com/downloads/installer/)
3. 安装Yarn：
   ```bash
   npm install -g yarn
   ```

#### Mac系统：
1. 使用Homebrew安装Node.js：
   ```bash
   brew install node
   ```
2. 安装MySQL：
   ```bash
   brew install mysql
   ```
3. 安装Yarn：
   ```bash
   npm install -g yarn
   ```

### 2. 克隆项目

```bash
git clone [项目地址]
cd AIreview
```

### 3. 环境变量配置

1. 在backend目录下创建 .env 文件：
```bash
cd backend
cp .env.example .env
```

2. 修改 .env 文件中的配置：
```env
# 服务器配置
PORT=3000
NODE_ENV=development

# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_USER=你的数据库用户名
DB_PASSWORD=你的数据库密码
DB_NAME=AIreview

# 文件上传配置
UPLOAD_DIR=uploads
TEMP_DIR=temp
```

### 4. 安装依赖

#### 前端依赖安装：
```bash
cd frontend
yarn install
```

#### 后端依赖安装：
```bash
cd backend
yarn install
```

### 5. 数据库初始化

#### Windows系统：
```bash
cd backend
set PLATFORM=win
yarn init-db
```

#### Mac/Linux系统：
```bash
cd backend
export PLATFORM=unix
yarn init-db
```

## 启动项目

### 启动后端服务
```bash
cd backend
yarn dev
```
后端服务将在 http://localhost:3000 启动

### 启动前端服务
```bash
cd frontend
yarn serve
```
前端服务将在 http://localhost:8080 启动

## 常见问题解决

### Windows 系统常见问题

1. MySQL连接问题：
   - 确保MySQL服务已启动
   - 检查环境变量中的MySQL路径
   - 确保.env文件中的数据库配置正确

2. 文件权限问题：
   - 以管理员身份运行命令行
   - 确保项目目录具有写入权限

### Mac/Linux 系统常见问题

1. MySQL权限问题：
   ```bash
   sudo mysql -u root
   ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '你的密码';
   FLUSH PRIVILEGES;
   ```

2. 目录权限问题：
   ```bash
   chmod -R 755 uploads/
   chmod -R 755 temp/
   ```

### 其他常见问题

1. 端口占用：
   - 修改.env文件中的PORT值
   - 或关闭占用端口的程序：
     ```bash
     # 查找占用端口的进程
     lsof -i :3000
     # 关闭进程
     kill <进程ID>
     ```

2. 依赖安装失败：
   ```bash
   # 清除yarn缓存
   yarn cache clean
   # 删除现有的node_modules和yarn.lock
   rm -rf node_modules yarn.lock
   # 重新安装依赖
   yarn install
   ```

3. 模块找不到错误：
   - 确保已经安装所有依赖：
     ```bash
     cd backend
     rm -rf node_modules yarn.lock
     yarn install
     ```
   - 检查 package.json 中是否包含所需的依赖
   - 检查 node_modules 目录是否存在

4. 数据库连接错误：
   - 确保MySQL服务已启动
   - 检查 .env 文件中的数据库配置是否正确
   - 确保数据库用户有正确的权限

5. 文件上传错误：
   - 检查上传目录是否存在且有正确的权限
   - Windows用户确保以管理员权限运行
   - Mac/Linux用户确保目录权限正确：
     ```bash
     chmod -R 755 backend/public/uploads
     chmod -R 755 backend/public/icons
     ```

## 开发建议

1. 代码编辑器配置：
   - 安装ESLint插件
   - 安装Prettier插件
   - 启用保存时自动格式化

2. 开发流程：
   - 创建新功能前先拉取最新代码
   - 遵循项目的代码规范
   - 提交前进行本地测试

## 技术支持

如遇到问题，请：
1. 查看项目文档
2. 检查常见问题解决方案
3. 提交Issue或联系管理员

## 许可证

MIT License

## Docker 部署说明

本项目支持通过Docker进行一键部署，适用于Windows、macOS和Linux系统。详细的部署指南请参考[Docker部署指南](./docker-deployment-guide.md)。

### 快速开始

确保已安装Docker和Docker Compose后，只需执行以下命令：

```bash
# 启动所有服务
docker-compose up -d

# 查看运行状态a
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 服务组成

- 前端（Vue 3 + Element Plus）: 端口8080
- 后端（Node.js + Express）: 端口3000
- 数据库（MySQL）: 端口3306
- 判题系统: 使用Docker容器运行代码，支持C/C++、Python、Java

### 跨平台兼容性

通过Docker容器化，解决了以下跨平台问题：

1. 依赖包差异: 所有依赖都在容器内安装，避免了Windows和macOS之间的差异
2. 路径名称: 容器内路径统一使用Unix风格，避免了Windows和macOS路径格式不同的问题
3. 环境配置: 容器提供统一的运行环境，无需担心宿主机系统差异

### 开发与生产环境

- 开发环境: `docker-compose.yml`
- 生产环境: `docker-compose.prod.yml` (需单独配置)

更多信息请参考[Docker部署指南](./docker-deployment-guide.md)。

## 部署指南

### 环境要求
- Docker 20.10+
- Docker Compose 2.0+
- 操作系统: Linux, macOS, 或 Windows 10+ (WSL2)

### 快速部署

1. 克隆仓库
   ```bash
   git clone <repository-url>
   cd AIreview
   ```

2. 启动服务
   ```bash
   # 使用专用启动脚本（推荐）
   chmod +x start-containers.sh
   ./start-containers.sh
   ```

3. 访问应用
   - 前端: http://localhost
   - 健康检查: http://localhost/health
   - 后端API: http://localhost/api

### 常见问题

#### Docker权限问题

如果后端服务无法访问Docker守护进程，请运行以下命令修复权限：

```bash
sudo chmod +x fix-docker-permissions.sh
sudo ./fix-docker-permissions.sh
```

**注意**: 运行此脚本后，您需要重新登录系统或开启新的终端窗口才能使组权限生效。

#### 登录问题

- 默认管理员账号: admin
- 默认密码: admin123

如果无法登录，请确保后端服务正常运行并能连接到数据库。

## 项目结构

```
AIreview/
├── backend/              # 后端代码
│   ├── src/              # 源代码
│   │   ├── api/          # API路由
│   │   ├── controllers/  # 控制器
│   │   ├── middleware/   # 中间件
│   │   ├── services/     # 服务
│   │   ├── utils/        # 工具函数
│   │   └── app.js        # 应用入口
│   └── Dockerfile        # 后端Docker配置
├── frontend/             # 前端代码
│   ├── src/              # 源代码
│   │   ├── api/          # API请求
│   │   ├── assets/       # 静态资源
│   │   ├── components/   # 组件
│   │   ├── router/       # 路由
│   │   ├── store/        # 状态管理
│   │   ├── utils/        # 工具函数
│   │   └── views/        # 页面
│   └── Dockerfile        # 前端Docker配置
├── db/                   # 数据库初始化脚本
├── nginx/                # Nginx配置
├── docker-compose.yml    # Docker Compose配置
├── start-containers.sh   # 容器启动脚本
└── fix-docker-permissions.sh  # Docker权限修复脚本
```

## 技术栈

- 前端: Vue 3, Element Plus, PrimeVue
- 后端: Node.js, Express
- 数据库: MySQL
- 容器化: Docker, Docker Compose
- 反向代理: Nginx

## 开发团队

AIreview 是一个教育项目，旨在提供高质量的代码审核和在线判题平台。

## 贡献

欢迎通过Issue或Pull Request贡献代码或提供建议。

### 启动项目
```bash
docker-compose up -d
```

### 清理Docker环境
如果发现Docker环境中积累了太多未使用的镜像或卷，可以使用以下命令清理：
```bash
./docker-cleanup.sh
```
此脚本将清理所有未使用的Docker镜像、容器和卷，解决每次重建Docker产生的资源浪费问题。