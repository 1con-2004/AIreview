@echo off
echo 正在从GitHub拉取最新代码...
git pull

echo 正在处理前端代码...
cd frontend
rmdir /s /q dist
mkdir dist
call yarn install
call yarn build
cd ..

echo 正在设置后端目录权限...
icacls backend /grant Everyone:(OI)(CI)F

echo 正在重启Docker容器...
docker restart aireview-nginx aireview-backend

echo 同步完成！
pause 