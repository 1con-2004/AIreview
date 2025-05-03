#!/bin/bash

echo "======================"
echo "前端文件修复脚本"
echo "======================"

# 获取服务器IP
SERVER_IP=$(hostname -I | awk '{print $1}')

# 检查是否存在前端文件
if [ -f "./frontend-dist.tar.gz" ]; then
  echo "发现前端构建压缩包，开始解压..."
  
  # 确保目录存在
  mkdir -p ./frontend/dist
  
  # 解压文件
  tar -xzf frontend-dist.tar.gz -C ./frontend/dist
  
  # 删除压缩包
  rm -f frontend-dist.tar.gz
  
  echo "前端文件已解压到 ./frontend/dist 目录"
  
  # 修复权限
  echo "修复文件权限..."
  chmod -R 755 ./frontend/dist
  
  echo "前端文件部署完成！"
  echo "请运行 ./deploy-simple.sh 重启服务"
else
  echo "未找到前端构建压缩包 (frontend-dist.tar.gz)"
  echo "请按照以下步骤操作："
  echo "1. 在本地执行: ./build-frontend.sh $SERVER_IP 1335"
  echo "2. 如果无法直接上传，请手动将生成的frontend-dist.tar.gz上传到服务器"
  echo "3. 上传后再次运行此脚本"
  
  # 创建上传说明
  cat > UPLOAD_GUIDE.txt << EOL
前端文件上传说明
================

1. 在本地构建前端:
   cd frontend
   yarn install
   yarn build

2. 打包前端文件:
   cd dist
   tar -czf ../../frontend-dist.tar.gz *
   cd ../..

3. 使用SFTP客户端(如FileZilla)上传frontend-dist.tar.gz到服务器:
   - 主机: ${SERVER_IP}
   - 端口: 1335
   - 用户名: root
   - 密码: 您的密码
   - 上传到路径: /root/AIreview/

4. 上传完成后，在服务器上运行:
   ./fix-frontend.sh

5. 最后重启服务:
   ./deploy-simple.sh
EOL
  
  echo "已创建上传指南: UPLOAD_GUIDE.txt"
fi 