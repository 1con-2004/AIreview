#!/bin/bash

# Docker权限修复脚本
# 解决Docker容器无法访问Docker守护进程的问题

echo "===== Docker权限修复脚本 ====="

# 检查是否以root权限运行
if [ "$(id -u)" != "0" ]; then
   echo "此脚本需要root权限，请使用sudo运行"
   echo "用法: sudo $0"
   exit 1
fi

# 检查Docker服务是否运行
echo "1. 检查Docker服务状态..."
if systemctl is-active --quiet docker; then
  echo "Docker服务正在运行"
else
  echo "Docker服务未运行，正在启动..."
  systemctl start docker
  if [ $? -ne 0 ]; then
    echo "启动Docker服务失败，请手动检查: systemctl status docker"
    exit 1
  else
    echo "Docker服务已启动"
  fi
fi

# 获取当前用户和Docker组信息
CURRENT_USER=$(logname || echo $SUDO_USER)
if [ -z "$CURRENT_USER" ]; then
  echo "无法确定当前用户，将使用默认用户"
  CURRENT_USER=$(whoami)
fi

echo "2. 获取当前用户和Docker组信息..."
echo "当前用户: $CURRENT_USER"
DOCKER_GROUP=$(stat -c '%G' /var/run/docker.sock)
DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
echo "Docker套接字组: $DOCKER_GROUP (GID: $DOCKER_GID)"

# 检查Docker组是否存在
if [ -z "$DOCKER_GROUP" ] || [ "$DOCKER_GROUP" = "UNKNOWN" ]; then
  echo "3. Docker组不存在或无法识别，尝试创建Docker组..."
  groupadd docker
  DOCKER_GROUP="docker"
  echo "Docker组已创建"
fi

# 确保Docker套接字权限正确
echo "4. 设置Docker套接字权限..."
chown root:$DOCKER_GROUP /var/run/docker.sock
chmod 660 /var/run/docker.sock
echo "Docker套接字权限已设置为660"

# 将当前用户添加到Docker组
echo "5. 将用户 $CURRENT_USER 添加到Docker组 $DOCKER_GROUP..."
usermod -aG $DOCKER_GROUP $CURRENT_USER
if [ $? -ne 0 ]; then
  echo "添加用户到Docker组失败"
  exit 1
else
  echo "用户已添加到Docker组"
fi

# 重启Docker容器
echo "6. 重启AIreview服务容器..."
cd $(dirname $0) # 确保在项目根目录
docker-compose restart backend
if [ $? -ne 0 ]; then
  echo "重启容器失败，您可能需要手动重启: docker-compose restart backend"
else
  echo "后端容器已重启"
fi

echo "===== 权限修复完成 ====="
echo "注意：您需要重新登录系统或开启新的终端窗口才能使组权限生效"
echo "如果问题仍然存在，请尝试重启Docker服务: sudo systemctl restart docker"
echo "然后重新启动容器: ./start-containers.sh" 