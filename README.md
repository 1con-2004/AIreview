# AI智能题目评审系统

这是一个基于AI的智能题目评审系统，主要面向高校学生，提供类似LeetCode的刷题平台功能，并集成了AI代码审查和个性化学习路径推荐功能。

## 功能特点

- 完善的OI判题功能
- 丰富的学生信息状态展示
- 多维度的数据分析图表
- 集成多种AI大模型辅助功能
- 支持自定义题库和学习路径

## 目录结构

```
├── frontend/          # 前端代码（Vue3）
├── backend/           # 后端代码（Node.js）
├── 数据库文件/         # 数据库相关文件
├── nginx/             # Nginx配置文件
└── docs/              # 项目文档
```

## 部署方式

本项目支持两种部署方式：
1. **Docker部署**（推荐）：适合所有平台，无需手动配置环境
2. **本地部署**：需要手动安装依赖和配置环境

## 快速部署指南（Docker方式）

### Windows系统部署

1. **安装Docker Desktop**
   - 下载地址：[Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
   - 安装完成后，确保Docker已成功启动（系统托盘中可以看到Docker图标）

2. **一键部署项目**
   - 双击运行项目根目录中的 `start-windows.bat` 脚本
   - 脚本会自动创建必要的目录、配置文件并启动Docker容器

3. **访问应用**
   - 前端访问地址：http://localhost
   - 后端API地址：http://localhost/api
   - 健康检查：http://localhost/health

4. **常见问题处理**
   - 如果遇到权限相关错误，请尝试以管理员身份运行 `start-windows.bat`
   - 如果80端口被占用，可以编辑 `docker-compose.yml` 文件，将 `"80:80"` 修改为 `"8080:80"`，然后通过 http://localhost:8080 访问

### Mac系统部署

1. **安装Docker Desktop**
   - 下载地址：[Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
   - 安装完成后，启动Docker应用

2. **一键部署项目**
   - 打开终端，进入项目根目录
   - 执行以下命令设置脚本权限并启动：
     ```bash
     chmod +x start-containers.sh
     ./start-containers.sh
     ```

3. **访问应用**
   - 前端访问地址：http://localhost
   - 后端API地址：http://localhost/api
   - 健康检查：http://localhost/health

4. **开发者模式（热重载）**
   - 如果您需要进行开发并实时查看更改效果，请使用：
     ```bash
     chmod +x mac-quick-reload.sh
     ./mac-quick-reload.sh
     ```
   - 按照脚本提示选择需要的功能（如监控前端源码变化、后端文件变化等）

### Linux系统部署

1. **安装Docker和Docker Compose**
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install docker.io docker-compose
   
   # CentOS/RHEL
   sudo yum install docker docker-compose
   ```

2. **启动Docker服务**
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

3. **设置Docker权限**
   ```bash
   sudo chmod +x fix-docker-permissions.sh
   sudo ./fix-docker-permissions.sh
   ```
   注意：运行此脚本后，需要重新登录系统或开启新的终端窗口才能使组权限生效

4. **一键部署项目**
   ```bash
   chmod +x start-containers.sh
   ./start-containers.sh
   ```

5. **访问应用**
   - 前端访问地址：http://localhost
   - 后端API地址：http://localhost/api
   - 健康检查：http://localhost/health

## Docker常用维护命令

1. **查看容器状态**
   ```bash
   docker-compose ps
   ```

2. **查看容器日志**
   ```bash
   # 查看所有容器日志
   docker-compose logs
   
   # 查看特定容器日志（如后端）
   docker-compose logs backend
   
   # 实时查看日志
   docker-compose logs -f
   ```

3. **重启容器**
   ```bash
   # 重启所有容器
   docker-compose restart
   
   # 重启特定容器
   docker-compose restart backend
   ```

4. **停止所有容器**
   ```bash
   docker-compose down
   ```

5. **清理Docker环境**
   如果发现Docker环境中积累了太多未使用的镜像或卷，可以使用以下命令清理：
   ```bash
   # Windows系统
   docker-cleanup.bat
   
   # Mac/Linux系统
   chmod +x docker-cleanup.sh
   ./docker-cleanup.sh
   ```

## 项目使用的Docker容器

本项目使用多容器架构，主要包含以下容器：
- `aireview-nginx`: 提供前端静态资源服务和API反向代理（端口80）
- `aireview-backend`: 运行Node.js后端服务（内部端口3000）
- `aireview-db`: MySQL数据库服务（端口3307）

## 本地开发相关（高级用户）

### 日志管理

项目提供了日志级别管理脚本，可以控制后端输出的日志详细程度：

```bash
chmod +x log-manager.sh
./log-manager.sh
```

日志级别说明：
- 0级: 静默模式 - 不输出任何日志
- 1级: 错误模式 - 只输出错误和警告日志
- 2级: 标准模式 - 输出常规操作日志
- 3级: 调试模式 - 输出详细调试日志
- 4级: 详细模式 - 输出所有日志

### 前端开发热重载

对于前端开发人员，可以使用热重载脚本实时查看代码更改效果：

```bash
chmod +x frontend-hot-reload.sh
./frontend-hot-reload.sh
```

## 常见问题

1. **80端口被占用**
   - 修改 `docker-compose.yml` 文件，将 `"80:80"` 修改为其他端口，如 `"8080:80"`
   - 重新启动容器：`docker-compose up -d`
   - 使用新端口访问：http://localhost:8080

2. **Docker权限问题**
   - Windows系统：确保以管理员身份运行命令提示符或PowerShell
   - Mac/Linux系统：运行 `sudo ./fix-docker-permissions.sh`

3. **无法连接数据库**
   - 检查数据库容器是否正常运行：`docker-compose ps`
   - 查看数据库容器日志：`docker-compose logs db`
   - 如需直接连接数据库（调试用）：
     - 主机：localhost
     - 端口：3307 （3307不行就尝试3306）
     - 用户名：root
     - 密码：root
     - 数据库名：AIreview

4. **文件上传失败**
   - 检查 `uploads` 目录权限
   - Windows系统：`icacls uploads /grant Everyone:(OI)(CI)F`
   - Mac/Linux系统：`chmod -R 777 uploads`

5. **手动在Navicat修改数据库内容不更新**
   - 这种情况是正常的。当你在 Navicat 中直接修改 Docker 容器中的数据库时，可能需要手动刷新或重启相关服务来使更改生效
   - 在项目根目录终端使用命令`docker-compose restart aireview-db` 重启Docker容器会解决大部分问题
   - 如果问题没有解决 手动重启后端服务 `docker-compose restart backend`

## 登录信息

- 默认管理员账号: admin
- 默认密码: admin123
- 更多其他账户信息参考[其他账号文档](docs/accounts.md)


## 技术支持

如遇到问题，请：
1. 检查常见问题解决方案
2. 查看容器日志寻找错误信息
3. 提交Issue或联系管理员

## 许可证

MIT License

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

# AIreview 项目部署指南 (Windows)

## 前置要求
- 安装 Docker Desktop for Windows
- 确保已启用 WSL 2（Windows Subsystem for Linux）

## 部署步骤
1. 安装Docker Desktop for Windows
   - 下载地址：https://www.docker.com/products/docker-desktop/
   - 安装后启动Docker Desktop

2. 确保Docker正在运行
   - 检查任务栏中是否有Docker图标
   - 图标为绿色表示Docker正常运行

3. 一键部署项目
   - 双击运行 `start-windows.bat` 文件
   - 脚本将自动创建必要的目录和配置
   - 启动所有Docker容器

4. 验证部署
   - 打开浏览器，访问 http://localhost
   - 如果网站正常显示，则部署成功

## 常见问题

### 端口冲突
如果80端口被占用，可能会导致服务启动失败。解决方法：
1. 编辑 `docker-compose.yml` 文件
2. 将 `80:80` 修改为 `8080:80`
3. 重新启动容器
4. 使用 http://localhost:8080 访问

### Docker服务未启动
确保Docker Desktop已正常启动，系统托盘中能看到Docker图标且为绿色。

### 权限问题
如果遇到权限相关错误，请尝试以管理员身份运行 `start-windows.bat`。