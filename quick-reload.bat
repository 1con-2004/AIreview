@echo off
chcp 65001
echo ===== AIreview Windows版快速重载脚本 =====

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
    echo 提示: 未安装yarn，将使用npm。
)

REM 定义容器名称
set NGINX_CONTAINER=aireview-nginx
set BACKEND_CONTAINER=aireview-backend

REM 检查Docker是否运行
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: Docker未运行，请先启动Docker Desktop。
    exit /b 1
)

REM 检查nodemon是否安装
where nodemon >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在安装nodemon...
    npm install -g nodemon
)

REM 检查Docker镜像
echo 检查Docker镜像...
docker images | findstr "aireview-backend" >nul
if %errorlevel% neq 0 (
    echo 警告: 未找到后端镜像，正在拉取...
    docker-compose pull backend
)

docker images | findstr "nginx:alpine" >nul
if %errorlevel% neq 0 (
    echo 警告: 未找到Nginx镜像，正在拉取...
    docker-compose pull nginx
)

docker images | findstr "mysql:8.0" >nul
if %errorlevel% neq 0 (
    echo 警告: 未找到MySQL镜像，正在拉取...
    docker-compose pull db
)

:menu
cls
echo.
echo ===== Windows开发环境菜单 =====
echo 1) 监控前端源码变化并自动编译刷新
echo 2) 监控前端构建目录变化自动刷新
echo 3) 监控后端文件变化并自动重启
echo 4) 启动热重载开发模式(推荐)
echo 5) 停止热重载开发模式
echo 6) 手动编译前端代码
echo 7) 打开浏览器访问应用
echo 8) 停止所有监控
echo q) 退出
echo =========================
echo.

set /p choice=请选择操作 [1-8/q]: 

if "%choice%"=="1" goto watch_frontend_src
if "%choice%"=="2" goto watch_frontend_dist
if "%choice%"=="3" goto watch_backend
if "%choice%"=="4" goto start_hot_reload
if "%choice%"=="5" goto stop_hot_reload
if "%choice%"=="6" goto build_frontend
if "%choice%"=="7" goto open_browser
if "%choice%"=="8" goto stop_watching
if /i "%choice%"=="q" goto end

echo 无效选择，请重试。
timeout /t 2 >nul
goto menu

:watch_frontend_src
echo 开始监控前端源代码文件变化...
start "" http://localhost/
cd frontend
if exist "yarn.lock" (
    start /B yarn install
    start /B yarn build --watch
) else (
    start /B npm install
    start /B npm run build -- --watch
)
cd ..
goto menu

:watch_frontend_dist
echo 开始监控前端构建目录变化...
start "" http://localhost/
:watch_dist_loop
if exist "frontend\dist" (
    echo 检测到前端构建目录变化，重新加载Nginx...
    docker exec %NGINX_CONTAINER% nginx -s reload
)
timeout /t 2 >nul
goto watch_dist_loop

:watch_backend
echo 开始监控后端文件变化...
cd backend
start /B nodemon --watch src app.js
cd ..
goto menu

:start_hot_reload
echo 启动热重载开发模式...
cd frontend
if exist "yarn.lock" (
    start /B yarn dev
) else (
    start /B npm run dev
)
cd ..
start "" http://localhost/
goto menu

:stop_hot_reload
echo 停止热重载开发模式...
taskkill /F /IM node.exe >nul 2>&1
goto menu

:build_frontend
echo 编译前端代码...
cd frontend
if exist "yarn.lock" (
    call yarn build
) else (
    call npm run build
)
cd ..
docker exec %NGINX_CONTAINER% nginx -s reload
goto menu

:open_browser
start "" http://localhost/
goto menu

:stop_watching
echo 停止所有监控...
taskkill /F /IM node.exe >nul 2>&1
goto menu

:end
echo 正在清理...
taskkill /F /IM node.exe >nul 2>&1
echo 脚本已结束。
exit /b 0 