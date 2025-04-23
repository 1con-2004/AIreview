@echo off
chcp 65001 >nul
echo ===== AIreview Docker环境启动 =====

echo 创建必要目录...
mkdir nginx 2>nul
mkdir frontend\dist 2>nul
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

echo 检查docker-compose.yml文件...
if not exist docker-compose.yml (
  echo docker-compose.yml不存在，创建默认配置...
  (
    echo version: '3.8'
    echo services:
    echo   nginx:
    echo     image: nginx:alpine
    echo     container_name: aireview-nginx
    echo     ports:
    echo       - "80:80"
    echo     volumes:
    echo       - ./frontend/dist:/usr/share/nginx/html
    echo       - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    echo     depends_on:
    echo       - backend
    echo     networks:
    echo       - aireview_network
    echo     healthcheck:
    echo       test: ["CMD", "curl", "-f", "http://localhost/health"]
    echo       interval: 30s
    echo       timeout: 10s
    echo       retries: 3
    echo       start_period: 15s
    echo 
    echo   backend:
    echo     build: ./backend
    echo     container_name: aireview-backend
    echo     volumes:
    echo       - ./backend:/app
    echo       - backend_modules:/app/node_modules
    echo       - ./uploads:/app/uploads
    echo       - ./logs:/app/logs
    echo     environment:
    echo       - NODE_ENV=development
    echo       - PORT=3000
    echo       - DB_HOST=db
    echo       - DB_USER=aireview
    echo       - DB_PASSWORD=aireview_password
    echo       - DB_NAME=aireview
    echo     depends_on:
    echo       - db
    echo     networks:
    echo       - aireview_network
    echo     healthcheck:
    echo       test: ["CMD", "curl", "-f", "http://localhost:3000/api/health"]
    echo       interval: 30s
    echo       timeout: 10s
    echo       retries: 3
    echo       start_period: 15s
    echo 
    echo   db:
    echo     image: mysql:8.0
    echo     container_name: aireview-db
    echo     restart: always
    echo     environment:
    echo       - MYSQL_ROOT_PASSWORD=rootpassword
    echo       - MYSQL_USER=aireview
    echo       - MYSQL_PASSWORD=aireview_password
    echo       - MYSQL_DATABASE=aireview
    echo     ports:
    echo       - "3307:3306"
    echo     volumes:
    echo       - db_data:/var/lib/mysql
    echo     networks:
    echo       - aireview_network
    echo     healthcheck:
    echo       test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p$$MYSQL_ROOT_PASSWORD"]
    echo       interval: 5s
    echo       timeout: 5s
    echo       retries: 20
    echo 
    echo networks:
    echo   aireview_network:
    echo     driver: bridge
    echo 
    echo volumes:
    echo   db_data:
    echo   backend_modules:
  ) > docker-compose.yml
)

echo 创建示例前端页面...
if not exist frontend\dist\index.html (
  echo 创建临时前端页面...
  mkdir frontend\dist 2>nul
  (
    echo ^<!DOCTYPE html^>
    echo ^<html lang="zh-CN"^>
    echo ^<head^>
    echo     ^<meta charset="UTF-8"^>
    echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
    echo     ^<title^>AIreview - 正在加载^</title^>
    echo     ^<style^>
    echo         body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
    echo         h1 { color: #333; }
    echo         .container { max-width: 800px; margin: 0 auto; }
    echo         .status { margin: 30px 0; padding: 20px; background: #f5f5f5; border-radius: 5px; }
    echo     ^</style^>
    echo ^</head^>
    echo ^<body^>
    echo     ^<div class="container"^>
    echo         ^<h1^>AIreview 系统^</h1^>
    echo         ^<div class="status"^>
    echo             ^<h2^>系统启动中...^</h2^>
    echo             ^<p^>系统正在初始化，请稍候。首次启动可能需要几分钟时间。^</p^>
    echo         ^</div^>
    echo     ^</div^>
    echo ^</body^>
    echo ^</html^>
  ) > frontend\dist\index.html
)

echo 启动Docker容器...
docker-compose down
docker-compose up -d

echo 等待服务启动...
timeout /t 15 /nobreak > nul

echo 容器状态:
docker-compose ps

echo ===== 启动完成 =====
echo 前端访问地址: http://localhost
echo 后端API地址: http://localhost/api
echo 健康检查: http://localhost/health
echo 提示: 首次启动可能需要等待数据库初始化完成，请稍候几分钟再访问

pause