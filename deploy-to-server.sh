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
rm -f database-backup.sql 2>/dev/null || true

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

# 导出数据库
echo "导出本地数据库..."
if [ -f "db/init/AIreview.sql" ]; then
    echo "使用本地SQL文件同步数据库"
    cp db/init/AIreview.sql database-backup.sql
else
    echo "从Docker容器导出数据库..."
    docker-compose exec -T db mysqldump -u root -proot AIreview > database-backup.sql
    # 检查导出是否成功
    if [ ! -s "database-backup.sql" ]; then
        echo "数据库导出失败！请确保Docker容器正在运行"
        exit 1
    fi
fi

echo "数据库导出成功: database-backup.sql"

# 尝试SSH连接上传
echo "尝试通过SSH上传到服务器..."
echo "服务器: $SERVER_IP 端口: $SSH_PORT 用户: $USERNAME"

# 测试SSH连接
if ssh -p $SSH_PORT -o ConnectTimeout=5 $USERNAME@$SERVER_IP "echo 连接成功" >/dev/null 2>&1; then
    echo "SSH连接成功，开始上传文件..."
    
    # 创建远程目录
    ssh -p $SSH_PORT $USERNAME@$SERVER_IP "mkdir -p ~/AIreview/frontend/dist"
    
    # 上传文件
    scp -P $SSH_PORT frontend-dist.tar.gz database-backup.sql $USERNAME@$SERVER_IP:~/AIreview/
    
    # 解压文件、导入数据库并重启服务
    ssh -p $SSH_PORT $USERNAME@$SERVER_IP "cd ~/AIreview && \
        ./fix-frontend.sh && \
        echo '导入数据库...' && \
        docker-compose exec -T db mysql -u root -proot AIreview < database-backup.sql && \
        echo '数据库导入完成' && \
        ./deploy-simple.sh"
    
    echo "部署成功完成！"
    echo "您可以通过以下地址访问应用:"
    echo "http://$SERVER_IP"
else
    echo "SSH连接失败，无法自动上传文件"
    echo "请手动上传frontend-dist.tar.gz和database-backup.sql到服务器"
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
    echo "docker-compose exec -T db mysql -u root -proot AIreview < database-backup.sql"
    echo "./deploy-simple.sh"
fi

exit 0 