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

# 获取当前用户的组ID
if command -v id >/dev/null 2>&1; then
    GROUP_ID=$(id -g)
else
    GROUP_ID=20 # macOS 的 staff 组ID
fi

# 导出环境变量
export DOCKER_GROUP_ID=$DOCKER_GROUP_ID
export UID=$CURRENT_UID

echo "设置环境变量: DOCKER_GROUP_ID=$DOCKER_GROUP_ID, UID=$CURRENT_UID"

# 设置前端构建目录权限
echo "设置前端构建目录权限..."
# 确保目录存在
mkdir -p frontend/dist/uploads

# 递归删除 dist 目录（如果存在）
if [ -d "frontend/dist" ]; then
    sudo rm -rf frontend/dist
fi

# 创建新的 dist 目录并设置权限
mkdir -p frontend/dist
sudo chown -R $USER:$GROUP_ID frontend/dist
sudo chmod -R 755 frontend/dist

echo "正在构建前端代码..."
cd frontend
yarn install
FORCE_COLOR=true yarn build
cd ..

# 确保构建后的目录权限正确
if [ -d "frontend/dist" ]; then
    sudo chown -R $USER:$GROUP_ID frontend/dist
    sudo chmod -R 755 frontend/dist
    
    # 特别处理 uploads 目录
    mkdir -p frontend/dist/uploads
    sudo chmod -R 777 frontend/dist/uploads
fi

# 拉取必要的Docker镜像
echo "正在拉取必要的Docker镜像..."
docker-compose pull nginx db

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
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|map)$ {
        root /usr/share/nginx/html;
        expires 30d;
        add_header Cache-Control "public, max-age=2592000";
        try_files $uri $uri/ /index.html;
        
        # 添加跨域头
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
        add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
    }
    
    # 前端静态文件
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # API请求代理
    location /api/ {
        proxy_pass http://aireview-backend:3000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # 增加超时时间
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
        
        # 添加跨域头
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
        add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
    }

    # 上传文件目录
    location /uploads/ {
        alias /usr/share/nginx/html/uploads/;
        expires 7d;
        add_header Cache-Control "public, max-age=604800";
        try_files $uri $uri/ /index.html;
        
        # 添加跨域头
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
        add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
    }
    
    # 健康检查接口
    location /health {
        return 200 'ok';
        add_header Content-Type text/plain;
    }
}
EOF
else
  echo "Nginx配置文件已存在，跳过创建..."
fi

# 确保存在必要的目录
mkdir -p backend/logs
mkdir -p backend/uploads
mkdir -p backend/temp
mkdir -p uploads/avatars

# 设置目录权限
chmod -R 777 backend/logs
chmod -R 777 backend/uploads
chmod -R 777 backend/temp
chmod -R 777 uploads

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