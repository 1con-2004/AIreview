#!/bin/bash

# 修复Nginx容器的文件权限
echo "正在修复Nginx容器的文件权限..."

# 确保前端构建文件存在
if [ ! -d "./frontend/dist" ]; then
  echo "错误: 前端构建文件夹不存在。请确保已构建前端项目。"
  echo "请执行: cd frontend && yarn build"
  exit 1
fi

# 检查index.html是否存在
if [ ! -f "./frontend/dist/index.html" ]; then
  echo "错误: 前端index.html文件不存在。请确保已正确构建前端项目。"
  exit 1
fi

# 创建必要的目录
mkdir -p ./uploads/avatars
mkdir -p ./frontend/public/uploads/avatars/temp

# 修复文件权限
echo "设置文件权限..."
chmod -R 755 ./frontend/dist
chmod -R 755 ./uploads
chmod -R 777 ./uploads/avatars

# 重启Nginx容器
echo "重启Nginx容器..."
docker restart aireview-nginx

echo "权限修复完成。"
echo "如果问题仍然存在，请尝试重新构建并启动所有容器:"
echo "docker-compose down"
echo "docker-compose up -d --build"
echo "执行完成后再运行 ./start-containers.sh" 