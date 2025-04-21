#!/bin/bash
set -e

echo "=== 容器初始化开始 ==="

# 安装netcat工具
echo "安装netcat工具..."
apt-get update && apt-get install -y netcat-openbsd

# 等待数据库启动
echo "等待数据库服务启动..."
while ! nc -z db 3306; do
  echo "等待MySQL数据库连接..."
  sleep 2
done
echo "数据库服务已启动"

# 修复用户密码问题
echo "运行密码修复脚本..."
node /app/docker-password-fix.js

# 执行中文编码修复脚本
echo "执行中文编码修复脚本..."
node /app/encoding-fix.js

# 启动应用程序
echo "启动后端服务..."
npm start 