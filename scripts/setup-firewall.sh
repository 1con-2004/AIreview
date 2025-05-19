#!/bin/bash

# 转到项目根目录
cd "$(dirname "$0")/.."
ROOT_DIR=$(pwd)

echo "======================"
echo "Ubuntu 24.04防火墙配置脚本"
echo "======================"

# 安装ufw（如果尚未安装）
echo "确保ufw已安装..."
apt-get update
apt-get install -y ufw

# 检查防火墙状态
echo "检查防火墙状态..."
ufw status

# 确保防火墙已启动
echo "确保防火墙已启动..."
ufw enable

# 开放80端口 (HTTP)
echo "开放80端口 (HTTP)..."
ufw allow 80/tcp

# 需要的话，开放443端口 (HTTPS)
echo "开放443端口 (HTTPS)..."
ufw allow 443/tcp

# 开放3307端口 (MySQL外部访问，如果需要)
echo "开放3307端口 (MySQL)..."
ufw allow 3307/tcp

# 显示当前防火墙状态
echo "当前防火墙状态..."
ufw status

echo "防火墙配置完成。" 