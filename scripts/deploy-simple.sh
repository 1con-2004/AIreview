#!/bin/bash

# 转到项目根目录
cd "$(dirname "$0")/.."
ROOT_DIR=$(pwd)

echo "======================"
echo "AIreview简化部署脚本 (Ubuntu 24.04)"
echo "======================"

# 检查Docker是否已安装
if ! command -v docker &> /dev/null; then
  echo "Docker未安装，正在安装..."
  apt-get update
  apt-get install -y docker.io docker-compose
  echo "Docker已安装，启动服务..."
  systemctl start docker
  systemctl enable docker
fi

# 检查前端文件是否存在
echo "检查前端文件..."
if [ ! -d "$ROOT_DIR/frontend/dist" ] || [ ! -f "$ROOT_DIR/frontend/dist/index.html" ]; then
  echo "警告: 前端构建文件不存在"
  echo "请先在本地构建前端并上传到服务器，或者确保frontend/dist目录中有有效的文件"
  echo "您可以在本地使用 $ROOT_DIR/scripts/build-frontend.sh <服务器IP> 来构建并上传"
  
  # 创建空白页，至少让服务能启动
  mkdir -p $ROOT_DIR/frontend/dist
  echo "<html><body><h1>AIreview</h1><p>前端文件尚未正确部署，请完成前端构建</p></body></html>" > $ROOT_DIR/frontend/dist/index.html
  echo "已创建临时index.html文件，以便服务能启动"
fi

# 创建必要的目录
echo "创建必要的目录结构..."
mkdir -p $ROOT_DIR/uploads/avatars
mkdir -p $ROOT_DIR/frontend/public/uploads/avatars/temp
mkdir -p $ROOT_DIR/backend/logs
mkdir -p $ROOT_DIR/backend/public/uploads/avatars
mkdir -p $ROOT_DIR/backend/public/uploads/icons

# 修复文件权限
echo "修复文件权限..."
chmod -R 755 $ROOT_DIR/frontend/dist 2>/dev/null || true
chmod -R 755 $ROOT_DIR/uploads
chmod -R 777 $ROOT_DIR/uploads/avatars
chmod -R 755 $ROOT_DIR/backend
chmod -R 777 $ROOT_DIR/backend/logs
chmod -R 777 $ROOT_DIR/backend/public/uploads

# 检查简化版配置文件
if [ ! -f "$ROOT_DIR/docker-compose-simple.yml" ]; then
  echo "错误: 简化版docker-compose配置文件不存在"
  exit 1
fi

# 停止所有已有容器
echo "停止所有已有容器..."
cd $ROOT_DIR
docker-compose down 2>/dev/null || true
docker stop aireview-nginx aireview-backend aireview-db 2>/dev/null || true
docker rm aireview-nginx aireview-backend aireview-db 2>/dev/null || true

# 删除旧网络
echo "删除旧网络..."
docker network rm aireview_network 2>/dev/null || true

# 清理Docker缓存
echo "清理Docker缓存..."
docker system prune -f

# 重启Docker服务
echo "重启Docker服务..."
systemctl restart docker
sleep 5

# 使用简化配置文件启动服务
echo "使用简化配置启动服务..."
cd $ROOT_DIR
docker-compose -f docker-compose-simple.yml up -d

# 等待容器启动
echo "等待容器启动..."
sleep 30

# 验证容器是否正常运行
echo "验证容器是否正常运行..."
if ! docker ps | grep -q "aireview-nginx"; then
  echo "Nginx容器未正常运行"
  docker logs aireview-nginx 2>/dev/null || echo "无法获取Nginx日志"
else
  echo "Nginx容器运行正常"
fi

if ! docker ps | grep -q "aireview-backend"; then
  echo "后端容器未正常运行"
  docker logs aireview-backend 2>/dev/null || echo "无法获取后端日志"
else
  echo "后端容器运行正常"
fi

if ! docker ps | grep -q "aireview-db"; then
  echo "数据库容器未正常运行"
  docker logs aireview-db 2>/dev/null || echo "无法获取数据库日志"
else
  echo "数据库容器运行正常"
fi

# 获取服务器外部IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo -e "\n===============================\n"
echo "部署配置完成!"
echo "您可以通过以下地址访问您的应用:"
echo -e "http://$SERVER_IP\n"
echo -e "===============================\n"
echo "如果仍然无法访问，请尝试以下操作:"
echo "1. 确保80端口已开放: sudo ufw allow 80/tcp"
echo "2. 手动重启容器: docker restart aireview-nginx aireview-backend aireview-db"
echo "3. 检查容器日志: docker logs aireview-nginx"
echo -e "===============================\n" 