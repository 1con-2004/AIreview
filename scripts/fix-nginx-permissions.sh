#!/bin/bash

# 修复Nginx容器的文件权限 (Ubuntu 24.04)

# 转到项目根目录
cd "$(dirname "$0")/.."
ROOT_DIR=$(pwd)

echo "正在修复Nginx容器的文件权限 (Ubuntu 24.04)..."

# 确保前端构建文件存在
if [ ! -d "$ROOT_DIR/frontend/dist" ]; then
  echo "错误: 前端构建文件夹不存在。请确保已构建前端项目。"
  echo "请执行: cd $ROOT_DIR/frontend && yarn build"
  exit 1
fi

# 检查index.html是否存在
if [ ! -f "$ROOT_DIR/frontend/dist/index.html" ]; then
  echo "错误: 前端index.html文件不存在。请确保已正确构建前端项目。"
  exit 1
fi

# 创建必要的目录
mkdir -p $ROOT_DIR/uploads/avatars
mkdir -p $ROOT_DIR/frontend/public/uploads/avatars/temp

# 修复文件权限
echo "设置文件权限..."
chmod -R 755 $ROOT_DIR/frontend/dist
chmod -R 755 $ROOT_DIR/uploads
chmod -R 777 $ROOT_DIR/uploads/avatars

# 确保Docker在运行
systemctl is-active --quiet docker || systemctl start docker

# 重启Nginx容器
echo "重启Nginx容器..."
docker restart aireview-nginx

echo "权限修复完成。"
echo "如果问题仍然存在，请尝试重新构建并启动所有容器:"
echo "docker-compose down"
echo "docker-compose up -d --build"
echo "执行完成后再运行 $ROOT_DIR/scripts/start-containers.sh" 