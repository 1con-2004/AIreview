#!/bin/bash

# 转到项目根目录
cd "$(dirname "$0")/.."
ROOT_DIR=$(pwd)

echo "======================"
echo "AIreview部署环境检查与修复 (Ubuntu 24.04)"
echo "======================"

# 修复Docker网络问题
echo "修复Docker网络问题..."
systemctl restart docker

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

# 检查Nginx配置文件
echo "检查Nginx配置文件..."
if [ ! -f "$ROOT_DIR/nginx/default.conf" ]; then
  echo "Nginx配置文件不存在"
  exit 1
fi

# 停止并删除已有容器和网络
echo "停止并删除已有容器和网络..."
cd $ROOT_DIR
docker-compose down
docker network prune -f

# 手动创建网络
echo "手动创建Docker网络..."
docker network create --driver bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 aireview_network || true

# 清理Docker缓存
echo "清理Docker缓存..."
docker system prune -f

# 调整docker-compose的网络配置
echo "临时修改docker-compose.yml网络配置..."
sed -i.bak 's/ipam:/# ipam:/g' $ROOT_DIR/docker-compose.yml
sed -i 's/  config:/  # config:/g' $ROOT_DIR/docker-compose.yml
sed -i 's/    - subnet: 172.18.0.0\/16/    # - subnet: 172.18.0.0\/16/g' $ROOT_DIR/docker-compose.yml
sed -i 's/      gateway: 172.18.0.1/      # gateway: 172.18.0.1/g' $ROOT_DIR/docker-compose.yml

# 重新构建并启动所有容器
echo "重新构建并启动所有容器..."
cd $ROOT_DIR
docker-compose up -d

# 等待容器启动
echo "等待所有容器启动..."
sleep 20

# 验证容器是否正常运行
echo "验证容器是否正常运行..."
if ! docker ps | grep -q "nginx"; then
  echo "Nginx容器未正常运行"
  docker logs aireview-nginx || true
  echo "尝试单独启动Nginx容器..."
  docker-compose up -d nginx
fi

if ! docker ps | grep -q "backend"; then
  echo "后端容器未正常运行"
  docker logs aireview-backend || true
  echo "尝试单独启动后端容器..."
  docker-compose up -d backend
fi

if ! docker ps | grep -q "db"; then
  echo "数据库容器未正常运行"
  docker logs aireview-db || true
  echo "尝试单独启动数据库容器..."
  docker-compose up -d db
fi

# 获取服务器外部IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo -e "===============================\n"
echo "部署配置完成!"
echo "您可以通过以下地址访问您的应用:"
echo -e "http://$SERVER_IP\n"
echo -e "===============================\n"
echo "如果仍然无法访问，请检查服务器防火墙设置:"
echo "1. 确保80端口已开放"
echo "2. 执行以下命令开放端口:"
echo "   sudo ufw allow 80/tcp"
echo "   sudo ufw reload"
echo -e "===============================\n" 