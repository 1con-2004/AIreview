#!/bin/bash

echo "======================"
echo "一键部署脚本"
echo "======================"

# 配置信息
SERVER_IP="45.207.192.41"
SSH_PORT="1335"
USERNAME="root"

# 清理旧文件
rm -f frontend-dist.tar.gz 2>/dev/null || true

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

echo "前端构建包已生成: frontend-dist.tar.gz"

# 尝试SSH连接上传
echo "尝试通过SSH上传到服务器..."
echo "服务器: $SERVER_IP 端口: $SSH_PORT 用户: $USERNAME"

# 测试SSH连接
if ssh -p $SSH_PORT -o ConnectTimeout=5 $USERNAME@$SERVER_IP "echo 连接成功" >/dev/null 2>&1; then
    echo "SSH连接成功，开始上传文件..."
    
    # 创建远程目录
    ssh -p $SSH_PORT $USERNAME@$SERVER_IP "mkdir -p ~/AIreview/frontend/dist"
    
    # 上传文件
    scp -P $SSH_PORT frontend-dist.tar.gz $USERNAME@$SERVER_IP:~/AIreview/
    
    # 解压文件并重启服务
    ssh -p $SSH_PORT $USERNAME@$SERVER_IP "cd ~/AIreview && ./fix-frontend.sh && ./deploy-simple.sh"
    
    echo "部署成功完成！"
    echo "您可以通过以下地址访问应用:"
    echo "http://$SERVER_IP"
else
    echo "SSH连接失败，无法自动上传文件"
    echo "请手动上传frontend-dist.tar.gz到服务器"
    echo ""
    echo "上传方法: 使用FileZilla等SFTP客户端连接服务器"
    echo "- 主机: $SERVER_IP"
    echo "- 端口: $SSH_PORT"
    echo "- 用户名: $USERNAME"
    echo "- 上传到: /root/AIreview/"
    echo ""
    echo "上传后，在服务器执行:"
    echo "cd ~/AIreview"
    echo "./fix-frontend.sh"
    echo "./deploy-simple.sh"
fi

exit 0 