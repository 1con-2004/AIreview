@echo off
echo ===== AIreview 项目重置工具 =====
echo 此工具将重置整个项目环境到初始状态
echo 警告: 所有数据库数据将被清除!

set /p confirm=确定要重置项目吗? (y/n): 
if /i not "%confirm%"=="y" goto :end

echo.
echo 开始重置项目...

echo 步骤1: 停止所有容器...
docker-compose down

echo 步骤2: 清理数据目录...
if exist "mysql_data" (
    rmdir /s /q mysql_data
    echo 已清除数据库数据，将使用初始SQL脚本重建。
)

if exist "backend\uploads\*" (
    del /q backend\uploads\*
    echo 已清除上传文件。
)

if exist "backend\logs\*" (
    del /q backend\logs\*
    echo 已清除日志文件。
)

echo 步骤3: 检查配置文件...
if not exist nginx\default.conf (
    echo Nginx配置文件丢失，将在启动时自动创建。
)

echo 步骤4: 启动项目...
call start-windows.bat

echo.
echo ===== 重置完成 =====
echo 项目已重置至初始状态，使用了db/init/AIreview.sql中的初始数据
echo 请通过 http://localhost 访问
goto :eof

:end
echo 操作已取消，项目保持当前状态。