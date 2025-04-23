@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ===== AIreview Docker环境启动 =====

:: 获取当前用户ID
for /f "tokens=2 delims=:" %%a in ('whoami /user') do set CURRENT_UID=%%a
echo 当前用户ID: !CURRENT_UID!

:: 设置环境变量
set DOCKER_GROUP_ID=999
set UID=!CURRENT_UID!

echo 设置环境变量: DOCKER_GROUP_ID=!DOCKER_GROUP_ID!, UID=!CURRENT_UID!

:: 构建前端代码
echo 正在构建前端代码...
cd frontend
if exist yarn.lock (
    call yarn install
    call yarn build
) else (
    call npm install
    call npm run build
)
cd ..

:: 拉取必要的Docker镜像
echo 正在拉取必要的Docker镜像...
docker-compose pull nginx db

:: 确保Nginx配置目录存在
if not exist nginx mkdir nginx

:: 检查Nginx配置文件是否存在
if not exist nginx\default.conf (
    echo Nginx配置文件不存在，创建默认配置...
    (
        echo server {
        echo     listen 80;
        echo     server_name localhost;
        echo.    
        echo     # 启用gzip压缩
        echo     gzip on;
        echo     gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
        echo     gzip_min_length 1000;
        echo.    
        echo     # 设置前端资源缓存策略
        echo     location ~* \.(js^|css^|png^|jpg^|jpeg^|gif^|ico^|map^)$ {
        echo         root /usr/share/nginx/html;
        echo         expires 30d;
        echo         add_header Cache-Control "public, max-age=2592000";
        echo         try_files $uri $uri/ /index.html;
        echo.        
        echo         # 添加跨域头
        echo         add_header Access-Control-Allow-Origin *;
        echo         add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
        echo         add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
        echo     }
        echo.    
        echo     # 前端静态文件
        echo     location / {
        echo         root /usr/share/nginx/html;
        echo         index index.html;
        echo         try_files $uri $uri/ /index.html;
        echo     }
        echo.
        echo     # API请求代理
        echo     location /api/ {
        echo         proxy_pass http://aireview-backend:3000/api/;
        echo         proxy_http_version 1.1;
        echo         proxy_set_header Upgrade $http_upgrade;
        echo         proxy_set_header Connection 'upgrade';
        echo         proxy_set_header Host $host;
        echo         proxy_set_header X-Real-IP $remote_addr;
        echo         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        echo         proxy_set_header X-Forwarded-Proto $scheme;
        echo         proxy_cache_bypass $http_upgrade;
        echo.        
        echo         # 增加超时时间
        echo         proxy_connect_timeout 300s;
        echo         proxy_send_timeout 300s;
        echo         proxy_read_timeout 300s;
        echo.        
        echo         # 添加跨域头
        echo         add_header Access-Control-Allow-Origin *;
        echo         add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
        echo         add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
        echo     }
        echo.
        echo     # 上传文件目录
        echo     location /uploads/ {
        echo         alias /usr/share/nginx/html/uploads/;
        echo         expires 7d;
        echo         add_header Cache-Control "public, max-age=604800";
        echo         try_files $uri $uri/ /index.html;
        echo.        
        echo         # 添加跨域头
        echo         add_header Access-Control-Allow-Origin *;
        echo         add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
        echo         add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
        echo     }
        echo.    
        echo     # 健康检查接口
        echo     location /health {
        echo         return 200 'ok';
        echo         add_header Content-Type text/plain;
        echo     }
        echo }
    ) > nginx\default.conf
) else (
    echo Nginx配置文件已存在，跳过创建...
)

:: 确保存在必要的目录
if not exist backend\logs mkdir backend\logs
if not exist backend\uploads mkdir backend\uploads
if not exist backend\temp mkdir backend\temp
if not exist uploads\avatars mkdir uploads\avatars

:: 启动容器
echo 启动Docker容器...
docker-compose down
docker-compose up -d

echo 等待服务启动...
timeout /t 5 /nobreak

:: 检查容器状态
echo 容器状态:
docker-compose ps

echo ===== 启动完成 =====
echo 前端访问地址: http://localhost
echo 后端API地址: http://localhost/api
echo 健康检查: http://localhost/health

pause