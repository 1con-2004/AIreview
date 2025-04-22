#!/bin/bash

# 同步头像文件到Nginx容器

echo "开始同步头像文件到Nginx容器..."
AVATARS_DIR="./uploads/avatars"

if [ ! -d "$AVATARS_DIR" ]; then
    echo "错误：头像目录不存在: $AVATARS_DIR"
    exit 1
fi

# 确保Nginx容器中存在目标目录
docker exec aireview-nginx mkdir -p /usr/share/nginx/html/uploads/avatars

# 拷贝所有头像文件到容器中
echo "正在拷贝头像文件..."
find $AVATARS_DIR -type f -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" | while read file; do
    filename=$(basename "$file")
    echo "拷贝文件: $filename"
    docker cp "$file" aireview-nginx:/usr/share/nginx/html/uploads/avatars/
done

# 设置正确的权限
echo "设置文件权限..."
docker exec aireview-nginx chmod -R 755 /usr/share/nginx/html/uploads
docker exec aireview-nginx chown -R nginx:nginx /usr/share/nginx/html/uploads

echo "同步完成! 现在可以正常访问头像文件了。" 