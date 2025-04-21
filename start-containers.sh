#!/bin/bash

# AIreview Docker启动脚本
# 解决Docker权限问题并启动服务

echo "===== AIreview Docker环境启动 ====="

# 获取Docker组ID
DOCKER_GROUP_ID=$(getent group docker | cut -d: -f3)
if [ -z "$DOCKER_GROUP_ID" ]; then
  echo "警告: 无法获取Docker组ID，将使用默认值999"
  DOCKER_GROUP_ID=999
else
  echo "找到Docker组ID: $DOCKER_GROUP_ID"
fi

# 获取当前用户ID
CURRENT_UID=$(id -u)
echo "当前用户ID: $CURRENT_UID"

# 导出环境变量
export DOCKER_GROUP_ID=$DOCKER_GROUP_ID
export UID=$CURRENT_UID

echo "设置环境变量: DOCKER_GROUP_ID=$DOCKER_GROUP_ID, UID=$CURRENT_UID"

# 确保Nginx配置目录存在
mkdir -p nginx

# 检查Nginx配置文件是否存在
if [ ! -f nginx/default.conf ]; then
  echo "Nginx配置文件不存在，创建默认配置..."
  cat > nginx/default.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    
    # 启用gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_min_length 1000;
    
    # 设置前端资源缓存策略
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        root /usr/share/nginx/html;
        expires 30d;
        add_header Cache-Control "public, max-age=2592000";
        try_files $uri $uri/ /index.html;
    }
    
    # 前端静态文件
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # API请求代理
    location /api/ {
        proxy_pass http://backend:3000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # 增加超时时间，适应长时间运行的API请求
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
    }

    # 静态资源代理
    location /uploads/ {
        proxy_pass http://backend:3000/uploads/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
        
        # 配置静态资源缓存
        expires 7d;
        add_header Cache-Control "public, max-age=604800";
    }
    
    # 健康检查接口
    location /health {
        return 200 'ok';
        add_header Content-Type text/plain;
    }
}
EOF
fi

# 确保存在必要的目录
mkdir -p backend/logs
mkdir -p backend/uploads
mkdir -p backend/temp

# 设置目录权限
chmod -R 777 backend/logs
chmod -R 777 backend/uploads
chmod -R 777 backend/temp

# 启动容器
echo "启动Docker容器..."
docker-compose down
docker-compose up -d

echo "等待服务启动..."
sleep 5

# 检查容器状态
echo "容器状态:"
docker-compose ps

echo "===== 启动完成 ====="
echo "前端访问地址: http://localhost"
echo "后端API地址: http://localhost/api"
echo "健康检查: http://localhost/health" 