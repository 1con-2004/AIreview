#!/bin/bash

# 检查和修复头像文件的权限

echo "检查头像文件的权限..."
AVATARS_DIR="./uploads/avatars"

if [ ! -d "$AVATARS_DIR" ]; then
    echo "错误：头像目录不存在: $AVATARS_DIR"
    exit 1
fi

# 检查目录权限
ls -la $AVATARS_DIR
echo "目录权限检查完成"

# 检查文件权限
echo "文件权限检查:"
find $AVATARS_DIR -type f -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" | while read file; do
    permissions=$(stat -c "%a %U:%G" "$file")
    echo "$file: $permissions"
done

# 设置正确的权限
echo "正在设置正确的权限..."
docker exec aireview-nginx chmod -R 755 /usr/share/nginx/html/uploads
docker exec aireview-nginx chown -R nginx:nginx /usr/share/nginx/html/uploads
echo "权限设置完成"

# 创建测试请求
echo "测试访问头像文件..."
TARGET_FILE="avatar-1741487554262-652128186.png"
curl -v -H "Accept: image/png" http://localhost/uploads/avatars/$TARGET_FILE
echo "测试完成"

echo "检查Nginx日志..."
docker logs aireview-nginx | grep avatar | tail -n 10
echo "日志检查完成"

echo "检查目录里的文件是否存在..."
docker exec aireview-nginx ls -la /usr/share/nginx/html/uploads/avatars/$TARGET_FILE
echo "文件检查完成" 