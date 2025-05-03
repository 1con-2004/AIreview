#!/bin/bash

echo "======================"
echo "前端构建包生成脚本"
echo "======================"

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
echo "请将此文件上传到服务器的 /root/AIreview/ 目录"
echo "服务器信息:"
echo "- 主机: 您的服务器IP (例如 45.207.192.41)"
echo "- 端口: 1335"
echo "- 用户名: root"

echo "上传后，在服务器上运行:"
echo "cd /root/AIreview"
echo "./fix-frontend.sh"
echo "./deploy-simple.sh"

exit 0 