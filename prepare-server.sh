#!/bin/bash

echo "======================"
echo "AIreview部署环境检查与修复"
echo "======================"

# 检查前端构建文件
echo "检查前端构建文件..."
if [ ! -d "./frontend/dist" ] || [ ! -f "./frontend/dist/index.html" ]; then
  echo "前端构建文件不存在，正在构建..."
  cd frontend
  yarn install
  yarn build
  cd ..
  if [ ! -d "./frontend/dist" ]; then
    echo "前端构建失败，请检查错误信息"
    exit 1
  else
    echo "前端构建成功"
  fi
fi

# 创建必要的目录
echo "创建必要的目录结构..."
mkdir -p ./uploads/avatars
mkdir -p ./frontend/public/uploads/avatars/temp
mkdir -p ./backend/logs
mkdir -p ./backend/public/uploads/avatars
mkdir -p ./backend/public/uploads/icons

# 修复文件权限
echo "修复文件权限..."
chmod -R 755 ./frontend/dist
chmod -R 755 ./uploads
chmod -R 777 ./uploads/avatars
chmod -R 755 ./backend
chmod -R 777 ./backend/logs
chmod -R 777 ./backend/public/uploads

# 检查Nginx配置文件
echo "检查Nginx配置文件..."
if [ ! -f "./nginx/default.conf" ]; then
  echo "Nginx配置文件不存在"
  exit 1
fi

# 停止并删除已有容器
echo "停止并删除已有容器..."
docker-compose down

# 清理Docker缓存
echo "清理Docker缓存..."
docker system prune -f

# 重新构建并启动所有容器
echo "重新构建并启动所有容器..."
docker-compose up -d --build

# 等待容器启动
echo "等待所有容器启动..."
sleep 10

# 验证容器是否正常运行
echo "验证容器是否正常运行..."
if ! docker ps | grep -q "aireview-nginx"; then
  echo "Nginx容器未正常运行"
  docker logs aireview-nginx
  exit 1
fi

if ! docker ps | grep -q "aireview-backend"; then
  echo "后端容器未正常运行"
  docker logs aireview-backend
  exit 1
fi

if ! docker ps | grep -q "aireview-db"; then
  echo "数据库容器未正常运行"
  docker logs aireview-db
  exit 1
fi

# 获取服务器外部IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "===============================\n"
echo "部署配置完成!"
echo "您可以通过以下地址访问您的应用:"
echo "http://$SERVER_IP\n"
echo "===============================\n"
echo "如果仍然无法访问，请检查服务器防火墙设置:"
echo "1. 确保80端口已开放"
echo "2. 执行以下命令开放端口:"
echo "   firewall-cmd --zone=public --add-port=80/tcp --permanent"
echo "   firewall-cmd --reload"
echo "===============================\n" 