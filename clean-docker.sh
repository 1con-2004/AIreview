#!/bin/bash

# 停止所有容器
echo "停止所有AIreview容器..."
docker-compose down

# 删除所有未使用的容器、网络、卷和镜像
echo "清理Docker缓存和未使用资源..."
docker system prune -a --volumes -f

# 重新构建前端
echo "重新构建前端..."
docker build -t aireview-frontend:latest ./frontend

# 重新启动所有服务
echo "启动所有服务..."
docker-compose up -d

echo "清理完成!"
echo "请在浏览器中使用Ctrl+F5或Cmd+Shift+R强制刷新页面。" 