# AI智能题目评审系统

这是一个基于AI的智能题目评审系统，主要面向高校学生，提供类似LeetCode的刷题平台功能，并集成了AI代码审查和个性化学习路径推荐功能。系统旨在帮助学生提高编程能力，同时通过AI辅助提供更智能化的学习体验。

## 项目特点

- **智能代码评审**: 集成智谱AI和DeepSeek AI，提供专业代码审查
- **个性化学习路径**: 基于用户学习情况智能推荐学习路径
- **多语言支持**: 支持多种编程语言的在线编程与评测
- **实时反馈**: 提供即时的代码执行结果与改进建议
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

## 公网服务器部署指南 (Ubuntu 24.04)

### 前置准备

1. **准备一台公网服务器**
   - 推荐配置：2核4G内存或更高
   - 操作系统：Ubuntu 24.04 LTS
   - 开放端口：80, 443, 3307（MySQL外部访问，可选）

2. **域名配置（可选）**
   - 将域名解析到服务器IP
   - 配置HTTPS需要域名（可选）

### 部署步骤

1. **服务器环境初始化**
   ```bash
   # 更新系统
   sudo apt update
   sudo apt upgrade -y
   
   # 安装基础工具
   sudo apt install -y git curl wget nano vim
   ```

2. **获取项目代码**
   ```bash
   # 克隆项目
   git clone <仓库URL> AIreview
   cd AIreview
   
   # 或者上传本地代码到服务器
   # 在本地执行: scp -r /本地项目路径/AIreview user@服务器IP:~/
   ```

3. **配置防火墙**
   ```bash
   # 运行防火墙配置脚本
   sudo chmod +x setup-firewall.sh
   sudo ./setup-firewall.sh
   ```

4. **配置Docker权限**
   ```bash
   # 运行Docker权限修复脚本
   sudo chmod +x fix-docker-permissions.sh
   sudo ./fix-docker-permissions.sh
   ```

5. **部署项目**
   ```bash
   # 简化部署方式（推荐）
   sudo chmod +x deploy-simple.sh
   sudo ./deploy-simple.sh
   
   # 或者使用完整部署流程
   sudo chmod +x prepare-server.sh
   sudo ./prepare-server.sh
   
   sudo chmod +x fix-nginx-permissions.sh
   sudo ./fix-nginx-permissions.sh
   
   sudo chmod +x start-containers.sh
   sudo ./start-containers.sh
   ```

6. **前端构建**

   如果在低配置服务器上直接构建前端会遇到内存不足问题，推荐在本地构建后上传：
   ```bash
   # 在本地构建前端
   cd frontend
   yarn install
   yarn build
   
   # 打包前端文件
   cd dist
   tar -czf ../../dist.tar.gz *
   cd ../..
   
   # 上传到服务器
   scp dist.tar.gz user@服务器IP:~/AIreview/
   
   # 在服务器上解压
   # 登录到服务器后执行:
   cd ~/AIreview
   mkdir -p frontend/dist
   tar -xzf dist.tar.gz -C frontend/dist
   ./fix-nginx-permissions.sh
   ```

   或使用项目自带的部署脚本：
   ```bash
   # 在本地执行
   ./build-frontend.sh 服务器IP SSH端口
   ```

7. **验证部署**
   ```bash
   # 运行诊断脚本
   sudo chmod +x diagnose.sh
   sudo ./diagnose.sh
   ```

### 远程数据库管理

1. **开放数据库远程连接**
   ```bash
   # 确保防火墙允许3307端口
   sudo ufw allow 3307/tcp
   
   # 登录MySQL创建远程用户
   docker exec -it aireview-db mysql -uroot -proot
   
   # 在MySQL中执行
   CREATE USER 'remote'@'%' IDENTIFIED BY '你的密码';
   GRANT ALL PRIVILEGES ON AIreview.* TO 'remote'@'%';
   FLUSH PRIVILEGES;
   exit;
   ```

2. **使用客户端连接**
   - 主机: 服务器IP
   - 端口: 3307
   - 用户名: remote（或其他创建的用户）
   - 密码: 你设置的密码
   - 数据库: AIreview

3. **数据库备份与恢复**

   创建自动备份脚本：
   ```bash
   cat > db-backup.sh << 'EOF'
   #!/bin/bash
   
   # 设置备份目录
   BACKUP_DIR=~/db_backups
   mkdir -p $BACKUP_DIR
   
   # 备份文件名（使用日期）
   BACKUP_FILE=$BACKUP_DIR/aireview_$(date +%Y%m%d_%H%M%S).sql
   
   # 执行备份
   echo "开始备份数据库..."
   docker exec aireview-db mysqldump -u root -proot AIreview > $BACKUP_FILE
   
   # 压缩备份
   gzip $BACKUP_FILE
   
   # 保留最近30天的备份，删除更早的
   find $BACKUP_DIR -name "aireview_*.sql.gz" -type f -mtime +30 -delete
   
   echo "数据库备份完成: ${BACKUP_FILE}.gz"
   EOF
   
   chmod +x db-backup.sh
   ```

   设置定时备份：
   ```bash
   # 编辑crontab
   crontab -e
   
   # 添加每天凌晨2点备份的任务
   0 2 * * * ~/AIreview/db-backup.sh >> ~/db_backup.log 2>&1
   ```

   恢复数据库：
   ```bash
   cat > db-restore.sh << 'EOF'
   #!/bin/bash
   
   if [ $# -ne 1 ]; then
     echo "用法: $0 备份文件.sql[.gz]"
     exit 1
   fi
   
   BACKUP_FILE=$1
   
   # 处理压缩文件
   if [[ $BACKUP_FILE == *.gz ]]; then
     echo "解压备份文件..."
     gunzip -c $BACKUP_FILE > /tmp/restore.sql
     BACKUP_FILE=/tmp/restore.sql
   fi
   
   echo "停止容器..."
   docker-compose down
   
   echo "启动数据库容器..."
   docker-compose up -d db
   
   echo "等待数据库启动..."
   sleep 20
   
   echo "恢复数据..."
   cat $BACKUP_FILE | docker exec -i aireview-db mysql -u root -proot AIreview
   
   echo "启动其他服务..."
   docker-compose up -d
   
   echo "数据库恢复完成！"
   EOF
   
   chmod +x db-restore.sh
   ```

### 更新与维护

1. **代码更新流程**
   ```bash
   # 在服务器上
   cd ~/AIreview
   git pull  # 拉取最新代码
   
   # 如果更新了后端代码
   docker-compose restart backend
   
   # 如果需要重新构建前端
   # 推荐在本地构建后上传
   ./deploy-to-server.sh  # 在本地执行
   ```

2. **日志管理**
   ```bash
   # 查看容器日志
   docker-compose logs -f
   
   # 查看特定容器日志
   docker logs aireview-nginx
   docker logs aireview-backend
   docker logs aireview-db
   
   # 管理日志级别
   chmod +x log-manager.sh
   ./log-manager.sh
   ```

3. **性能监控**
   ```bash
   # 检查容器资源使用
   docker stats
   
   # 系统资源监控
   htop  # 如需安装: sudo apt install htop
   ```

### 常见问题解决

1. **Nginx容器显示为unhealthy**

   可能原因：
   - 健康检查接口未正确配置
   - wget工具未安装

   解决方案：
   ```bash
   # 创建修复脚本
   cat > fix-health.sh << 'EOF'
   #!/bin/bash
   echo "正在修复Nginx健康检查..."
   
   # 检查健康检查路径是否配置
   if grep -q "location /health" ./nginx/default.conf; then
     echo "健康检查路径已配置"
   else
     echo "添加健康检查路径到Nginx配置..."
     sed -i '/server {/a \    # 健康检查接口\n    location /health {\n        return 200 '"'"'ok'"'"';\n        add_header Content-Type text/plain;\n    }' ./nginx/default.conf
   fi
   
   # 安装wget
   docker exec aireview-nginx apk add --no-cache wget
   
   # 重启Nginx容器
   docker restart aireview-nginx
   
   echo "健康检查修复完成。"
   EOF
   
   chmod +x fix-health.sh
   ./fix-health.sh
   ```

2. **前端构建内存不足**

   解决方案：
   - 增加交换空间：
     ```bash
     sudo fallocate -l 2G /swapfile
     sudo chmod 600 /swapfile
     sudo mkswap /swapfile
     sudo swapon /swapfile
     echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
     ```
   - 使用本地构建并上传
   - 修改构建参数：
     ```bash
     # 增加Node内存限制
     export NODE_OPTIONS="--max-old-space-size=1024"
     ```

3. **Docker网络问题**

   解决方案：
   ```bash
   # 重建网络
   docker network rm aireview_network
   docker network create --driver bridge aireview_network
   
   # 重启容器
   docker-compose down
   docker-compose up -d
   ```

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
- 更多账号 [参考预设账号汇总表](./docs/accounts.md)

## 项目文档

更多详细信息请查看项目文档目录：
- API文档：`project_information/api_information/`
- 技术规范：`project_information/`

## 技术支持

如遇问题：
1. 查看项目文档
2. 检查容器日志
3. 提交Issue

## 许可证

MIT License