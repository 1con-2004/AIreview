@echo off
echo ===== AIreview Docker环境启动 =====

echo 创建必要目录...
mkdir nginx 2>nul
mkdir backend\logs 2>nul 
mkdir backend\uploads 2>nul
mkdir backend\temp 2>nul

echo 设置目录权限...
icacls backend\logs /grant Everyone:(OI)(CI)F
icacls backend\uploads /grant Everyone:(OI)(CI)F
icacls backend\temp /grant Everyone:(OI)(CI)F

echo 检查Nginx配置文件...
if not exist nginx\default.conf (
  echo Nginx配置文件不存在，创建默认配置...
  (
    echo server {
    echo     listen 80;
    echo     server_name localhost;
    echo     
    echo     # 启用gzip压缩
    echo     gzip on;
    echo     gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    echo     gzip_min_length 1000;
    echo     
    echo     # 设置前端资源缓存策略
    echo     location ~* \.(js^|css^|png^|jpg^|jpeg^|gif^|ico^)$ {
    echo         root /usr/share/nginx/html;
    echo         expires 30d;
    echo         add_header Cache-Control "public, max-age=2592000";
    echo         try_files $uri $uri/ /index.html;
    echo     }
    echo     
    echo     # 前端静态文件
    echo     location / {
    echo         root /usr/share/nginx/html;
    echo         index index.html;
    echo         try_files $uri $uri/ /index.html;
    echo     }
    echo 
    echo     # API请求代理
    echo     location /api/ {
    echo         proxy_pass http://backend:3000/api/;
    echo         proxy_http_version 1.1;
    echo         proxy_set_header Upgrade $http_upgrade;
    echo         proxy_set_header Connection 'upgrade';
    echo         proxy_set_header Host $host;
    echo         proxy_set_header X-Real-IP $remote_addr;
    echo         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    echo         proxy_set_header X-Forwarded-Proto $scheme;
    echo         proxy_cache_bypass $http_upgrade;
    echo         
    echo         # 增加超时时间，适应长时间运行的API请求
    echo         proxy_connect_timeout 300s;
    echo         proxy_send_timeout 300s;
    echo         proxy_read_timeout 300s;
    echo     }
    echo 
    echo     # 静态资源代理
    echo     location /uploads/ {
    echo         proxy_pass http://backend:3000/uploads/;
    echo         proxy_http_version 1.1;
    echo         proxy_set_header Host $host;
    echo         proxy_set_header X-Real-IP $remote_addr;
    echo         proxy_cache_bypass $http_upgrade;
    echo         
    echo         # 配置静态资源缓存
    echo         expires 7d;
    echo         add_header Cache-Control "public, max-age=604800";
    echo     }
    echo     
    echo     # 健康检查接口
    echo     location /health {
    echo         return 200 'ok';
    echo         add_header Content-Type text/plain;
    echo     }
    echo }
  ) > nginx\default.conf
)

echo 启动Docker容器...
docker-compose down
docker-compose up -d

echo 等待服务启动...
timeout /t 5 /nobreak > nul

echo 容器状态:
docker-compose ps

echo ===== 启动完成 =====
echo 前端访问地址: http://localhost
echo 后端API地址: http://localhost/api
echo 健康检查: http://localhost/health

pause