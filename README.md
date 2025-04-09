# AI智能题目评审系统

这是一个基于AI的智能题目评审系统，主要面向高校学生，提供类似LeetCode的刷题平台功能，并集成了AI代码审查和个性化学习路径推荐功能。

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