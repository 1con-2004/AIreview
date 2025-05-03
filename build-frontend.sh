#!/bin/bash

echo "======================"
echo "前端构建脚本"
echo "======================"

# 检查是否有足够的参数
if [ "$#" -ne 1 ]; then
    echo "使用方法: $0 <服务器IP>"
    echo "例如: $0 45.207.192.41"
    exit 1
fi

SERVER_IP=$1

# 本地构建前端
echo "在本地构建前端..."
cd frontend
yarn install
yarn build

# 检查构建是否成功
if [ ! -d "dist" ] || [ ! -f "dist/index.html" ]; then
    echo "前端构建失败！"
    exit 1
fi

echo "前端构建成功！"

# 创建临时压缩包
echo "打包前端文件..."
cd dist
tar -czf ../../frontend-dist.tar.gz *
cd ../..

# 上传到服务器
echo "上传到服务器 $SERVER_IP..."
echo "请输入服务器用户名（默认root）:"
read -p "用户名: " USERNAME
USERNAME=${USERNAME:-root}

echo "将使用 $USERNAME 用户上传到 $SERVER_IP"
echo "请确保您的SSH密钥已配置，或准备输入密码"

# 创建远程目录
ssh $USERNAME@$SERVER_IP "mkdir -p ~/AIreview/frontend/dist"

# 上传文件
scp frontend-dist.tar.gz $USERNAME@$SERVER_IP:~/AIreview/

# 解压文件到正确位置
ssh $USERNAME@$SERVER_IP "cd ~/AIreview && tar -xzf frontend-dist.tar.gz -C frontend/dist && rm frontend-dist.tar.gz"

echo "前端文件已成功上传到服务器！"
echo "现在您可以在服务器上运行 ./prepare-server.sh"

# 清理本地临时文件
rm -f frontend-dist.tar.gz

exit 0 