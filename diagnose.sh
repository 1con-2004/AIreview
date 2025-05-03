#!/bin/bash

echo "======================"
echo "AIreview服务器诊断工具 (Ubuntu 24.04)"
echo "======================"

# 检查系统信息
echo "系统信息："
uname -a
echo ""

# 检查Docker版本和状态
echo "Docker版本："
docker --version
echo ""

echo "Docker状态："
systemctl status docker | grep Active
echo ""

# 检查Docker网络
echo "Docker网络："
docker network ls
echo ""

# 检查容器状态
echo "容器状态："
docker ps -a
echo ""

# 检查已有镜像
echo "Docker镜像："
docker images
echo ""

# 检查容器日志
echo "Nginx容器日志（最后20行）："
docker logs aireview-nginx --tail 20 2>/dev/null || echo "无法获取Nginx日志"
echo ""

echo "后端容器日志（最后20行）："
docker logs aireview-backend --tail 20 2>/dev/null || echo "无法获取后端日志"
echo ""

echo "数据库容器日志（最后20行）："
docker logs aireview-db --tail 20 2>/dev/null || echo "无法获取数据库日志"
echo ""

# 检查文件结构
echo "文件结构检查："
if [ -d "./frontend/dist" ]; then
  echo "前端构建目录存在"
  if [ -f "./frontend/dist/index.html" ]; then
    echo "index.html文件存在"
  else
    echo "警告：index.html文件不存在"
  fi
else
  echo "警告：前端构建目录不存在"
fi

if [ -f "./nginx/default.conf" ]; then
  echo "Nginx配置文件存在"
else
  echo "警告：Nginx配置文件不存在"
fi
echo ""

# 检查网络连接
echo "网络连通性测试："
echo "Nginx健康检查："
curl -s http://localhost/health || echo "Nginx健康检查失败"
echo ""

echo "防火墙状态："
ufw status | grep Status
echo ""

echo "开放端口："
ufw status | grep -E '(80|443|3307)'
echo ""

# 提供修复建议
echo "============================"
echo "诊断完成，修复建议："
echo "============================"

# 检查并提供Docker修复建议
if ! systemctl is-active docker >/dev/null 2>&1; then
  echo "1. Docker服务未运行，请执行：systemctl start docker"
fi

# 检查并提供网络修复建议
if ! docker network ls | grep -q aireview_network; then
  echo "2. 网络问题：aireview_network网络不存在，请执行："
  echo "   docker network create --driver bridge aireview_network"
fi

# 检查并提供容器修复建议
if ! docker ps | grep -q aireview-nginx; then
  echo "3. Nginx容器未运行，请尝试："
  echo "   docker-compose -f docker-compose-simple.yml up -d nginx"
fi

if ! docker ps | grep -q aireview-backend; then
  echo "4. 后端容器未运行，请尝试："
  echo "   docker-compose -f docker-compose-simple.yml up -d backend"
fi

if ! docker ps | grep -q aireview-db; then
  echo "5. 数据库容器未运行，请尝试："
  echo "   docker-compose -f docker-compose-simple.yml up -d db"
fi

# 检查文件权限建议
echo "6. 修复文件权限："
echo "   chmod -R 755 ./frontend/dist"
echo "   chmod -R 777 ./uploads"
echo "   chmod -R 777 ./backend/logs"

# 防火墙建议
echo "7. 确保防火墙已开放80端口："
echo "   sudo ufw allow 80/tcp"
echo "   sudo ufw reload"

echo ""
echo "执行完整修复，请运行："
echo "./deploy-simple.sh"
echo "" 