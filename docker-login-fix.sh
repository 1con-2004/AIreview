#!/bin/bash

# 登录问题修复脚本 - 重建Docker容器并应用修复

echo "=== Docker登录问题修复脚本 ==="
echo "此脚本将重建和重启Docker容器以应用修复"

# 停止现有容器
echo "1. 停止现有容器..."
docker-compose down

# 重新构建后端容器
echo "2. 重新构建后端容器..."
docker-compose build backend

# 启动服务
echo "3. 启动所有服务..."
docker-compose up -d

# 查看日志
echo "4. 显示后端容器日志..."
echo "观察docker-password-fix.js脚本的执行情况"
docker-compose logs -f backend

echo "5. 修复完成"
echo "现在应该可以使用管理员账户（用户名：admin，密码：admin123）登录了"
echo "如果仍然遇到问题，请查看后端日志以获取更多信息" 