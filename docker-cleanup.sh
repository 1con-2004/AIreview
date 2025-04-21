#!/bin/bash

# AIreview Docker环境清理脚本
# 此脚本用于清理无用的Docker镜像、容器和卷，解决每次重建产生的资源浪费问题

echo "===== AIreview Docker环境清理 ====="

# 停止正在运行的容器
echo "1. 停止现有的Docker容器..."
docker-compose down

# 清理无标签的镜像（名称为<none>的镜像）
echo "2. 清理无标签的Docker镜像..."
docker image prune -f

# 清理无用的卷（除了我们命名的卷）
echo "3. 清理无用的Docker卷..."
docker volume prune -f

# 清理未使用的网络
echo "4. 清理无用的Docker网络..."
docker network prune -f

echo "5. 当前Docker镜像列表:"
docker images

echo "6. 当前Docker卷列表:"
docker volume ls

echo "===== 清理完成 ====="
echo "如需重新启动应用，请运行: docker-compose up -d" 