# AIreview 项目 Docker 部署指南

## 目录
1. [项目简介](#项目简介)
2. [前置条件](#前置条件)
3. [部署步骤](#部署步骤)
4. [常见问题及解决方案](#常见问题及解决方案)
5. [数据库管理](#数据库管理)
6. [环境重置](#环境重置)

## 项目简介
AIreview 是一个集成了OI判题功能、学生信息状态获取、多维度图分析和AI辅助的代码审核平台。本文档将指导您如何通过 Docker 快速部署整个项目。

## 前置条件
- 安装 [Docker](https://www.docker.com/products/docker-desktop)
- 安装 [Docker Compose](https://docs.docker.com/compose/install/) (通常随Docker一起安装)
- 确保以下端口未被占用:
  - 前端: 8080
  - 后端: 3000
  - MySQL: 3306

## 部署步骤

### 1. 克隆仓库
```bash
git clone <项目仓库地址>
cd AIreview
```

### 2. 启动项目
一键启动整个项目（包括前端、后端、数据库和判题系统）:

```bash
docker-compose up -d
```

该命令会:
- 构建并启动前端容器
- 构建并启动后端容器
- 创建并初始化MySQL数据库
- 拉取必要的判题环境镜像 (gcc, python, openjdk)

### 3. 验证部署
- 前端访问: [http://localhost:8080](http://localhost:8080)
- 后端API: [http://localhost:3000](http://localhost:3000)
- 数据库(内部访问): localhost:3306

### 4. 停止项目

```bash
docker-compose down
```

如果需要同时删除数据卷(这将删除数据库数据):

```bash
docker-compose down -v
```

## 常见问题及解决方案

### 判题环境问题
问题: 判题环境容器拉取失败
解决: 手动拉取必要的镜像
```bash
docker pull gcc:latest
docker pull python:3.9-slim
docker pull openjdk:11
```

### 跨平台兼容性问题
项目已经通过Docker容器化解决了Mac和Windows环境差异的问题。所有依赖都在容器内安装，避免了本地依赖不一致的问题。文件路径也在容器中标准化处理。

### 数据库连接问题
问题: 无法连接到数据库
解决: 检查数据库容器是否正常运行
```bash
docker ps | grep mysql
```

如果没有运行:
```bash
docker-compose up -d db
```

## 数据库管理

### 连接到数据库
```bash
docker exec -it aireview-db mysql -u root -p
# 输入密码: root
```

### 导出数据库
```bash
docker exec aireview-db mysqldump -u root -proot AIreview > backup.sql
```

### 导入数据库
```bash
docker exec -i aireview-db mysql -u root -proot AIreview < backup.sql
```

## 环境重置

### 重置整个环境
以下命令将删除所有容器、网络和数据卷，实现完全重置:

```bash
docker-compose down -v
docker-compose up -d
```

### 仅重置数据库
```bash
docker-compose down db
docker volume rm aireview_db_data
docker-compose up -d db
```

### 查看日志
查看后端日志:
```bash
docker logs -f aireview-backend
```

查看前端日志:
```bash
docker logs -f aireview-frontend
```

查看数据库日志:
```bash
docker logs -f aireview-db
```

## 故障排除

如果遇到任何问题，请参考以下排查步骤:

1. 检查所有容器是否正常运行:
```bash
docker-compose ps
```

2. 查看容器日志:
```bash
docker-compose logs
```

3. 确认网络连接:
```bash
docker network inspect aireview_network
```

4. 重启特定服务:
```bash
docker-compose restart [服务名]
```

如有更多问题，请联系项目维护者。 

## 其他解决方案

### 更换Docker镜像源

1. 创建或编辑 `~/.docker/config.json` 文件：
```bash
vim ~/.docker/config.json
```

2. 添加以下内容（使用Docker官方镜像源或国内其他镜像源）：
```json
{
  "registry-mirrors": [
    "https://registry.docker-cn.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com"
  ]
}
```

3. 然后重启Docker服务：
```bash
osascript -e 'quit app "Docker"'
open -a Docker
```

### 手动拉取需要的镜像

```bash
docker pull node:16-alpine
```

### 使用其他版本的Node镜像

编辑`backend/Dockerfile`和`frontend/Dockerfile`文件，将：
```
FROM node:16-alpine
```

改为：
```
FROM node:18-alpine
```

完成上述操作后，再次运行：
```bash
docker-compose up -d
```
