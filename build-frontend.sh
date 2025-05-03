#!/bin/bash

echo "======================"
echo "前端构建脚本"
echo "======================"

# 检查是否有足够的参数
if [ "$#" -lt 1 ]; then
    echo "使用方法: $0 <服务器IP> [SSH端口]"
    echo "例如: $0 45.207.192.41 1335"
    exit 1
fi

SERVER_IP=$1
SSH_PORT=${2:-22}  # 默认端口是22，但可以通过第二个参数指定

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
echo "上传到服务器 $SERVER_IP，端口 $SSH_PORT..."
echo "请输入服务器用户名（默认root）:"
read -p "用户名: " USERNAME
USERNAME=${USERNAME:-root}

echo "将使用 $USERNAME 用户通过端口 $SSH_PORT 上传到 $SERVER_IP"
echo "请确保您的SSH密钥已配置，或准备输入密码"

# 测试SSH连接
echo "测试SSH连接..."
if ! ssh -p $SSH_PORT -o ConnectTimeout=5 $USERNAME@$SERVER_IP "echo 连接成功"; then
    echo "无法连接到服务器，请检查SSH连接设置"
    echo "生成的文件 frontend-dist.tar.gz 已准备好，您可以手动上传"
    echo "上传后在服务器上运行 ./fix-frontend.sh"
    exit 1
fi

# 创建远程目录
echo "创建远程目录..."
ssh -p $SSH_PORT $USERNAME@$SERVER_IP "mkdir -p ~/AIreview/frontend/dist"

# 上传文件
echo "上传文件..."
scp -P $SSH_PORT frontend-dist.tar.gz $USERNAME@$SERVER_IP:~/AIreview/

# 解压文件到正确位置
echo "解压文件..."
ssh -p $SSH_PORT $USERNAME@$SERVER_IP "cd ~/AIreview && tar -xzf frontend-dist.tar.gz -C frontend/dist && rm frontend-dist.tar.gz"

echo "前端文件已成功上传到服务器！"
echo "现在您可以在服务器上运行 ./deploy-simple.sh"

# 清理本地临时文件
rm -f frontend-dist.tar.gz

exit 0 