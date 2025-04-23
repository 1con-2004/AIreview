@echo off
chcp 65001
echo ===== AIreview Docker环境启动 =====

REM 检查Node.js是否安装
echo 检查Node.js环境...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未安装Node.js，请先安装Node.js。
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)

REM 检查npm是否安装
echo 检查npm...
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: npm安装异常，请重新安装Node.js。
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)

REM 检查yarn是否安装（可选）
echo 检查yarn...
yarn --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 提示: 未安装yarn，是否安装？[Y/N]
    set /p install_yarn=
    if /i "%install_yarn%"=="Y" (
        echo 正在安装yarn...
        npm install -g yarn
        if %errorlevel% neq 0 (
            echo 警告: yarn安装失败，将使用npm继续。
        ) else (
            echo yarn安装成功。
        )
    ) else (
        echo 将使用npm继续。
    )
)

REM 检查Docker是否运行
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: Docker未运行，请先启动Docker Desktop。
    pause
    exit /b 1
)

REM 构建前端代码
echo 正在构建前端代码...
cd frontend
if exist "yarn.lock" (
    call yarn install
    call yarn build
) else (
    call npm install
    call npm run build
)
cd ..

REM 拉取必要的Docker镜像
echo 正在拉取必要的Docker镜像...
docker-compose pull nginx db

REM 确保目录存在
if not exist "nginx" mkdir nginx
if not exist "backend\logs" mkdir "backend\logs"
if not exist "backend\uploads" mkdir "backend\uploads"
if not exist "backend\temp" mkdir "backend\temp"

REM 设置目录权限
icacls "backend\logs" /grant Everyone:F
icacls "backend\uploads" /grant Everyone:F
icacls "backend\temp" /grant Everyone:F

REM 检查Nginx配置文件是否存在
if not exist "nginx\default.conf" (
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
)

REM 启动容器
echo 启动Docker容器...
docker-compose down
docker-compose up -d

echo 等待服务启动...
timeout /t 5 /nobreak

REM 检查容器状态
echo 容器状态:
docker-compose ps

echo ===== 启动完成 =====
echo 前端访问地址: http://localhost
echo 后端API地址: http://localhost/api
echo 健康检查: http://localhost/health

REM 自动打开浏览器
start http://localhost 