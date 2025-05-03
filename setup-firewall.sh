#!/bin/bash

echo "======================"
echo "CentOS防火墙配置脚本"
echo "======================"

# 检查防火墙状态
echo "检查防火墙状态..."
systemctl status firewalld

# 确保防火墙已启动
echo "确保防火墙已启动..."
systemctl start firewalld
systemctl enable firewalld

# 开放80端口 (HTTP)
echo "开放80端口 (HTTP)..."
firewall-cmd --zone=public --add-port=80/tcp --permanent

# 需要的话，开放443端口 (HTTPS)
echo "开放443端口 (HTTPS)..."
firewall-cmd --zone=public --add-port=443/tcp --permanent

# 开放3307端口 (MySQL外部访问，如果需要)
echo "开放3307端口 (MySQL)..."
firewall-cmd --zone=public --add-port=3307/tcp --permanent

# 重新加载防火墙配置
echo "重新加载防火墙配置..."
firewall-cmd --reload

# 显示当前开放的端口
echo "当前开放的端口..."
firewall-cmd --list-ports

echo "防火墙配置完成。" 