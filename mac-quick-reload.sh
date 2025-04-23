#!/bin/bash

# AIreview Mac版快速重载脚本
# 针对macOS系统的简化版自动重载脚本

echo "===== AIreview Mac版快速重载脚本 ====="

# 定义容器名称
NGINX_CONTAINER="aireview-nginx"
BACKEND_CONTAINER="aireview-backend"

# 检查是否是macOS系统
if [[ "$(uname)" != "Darwin" ]]; then
    echo "错误: 该脚本仅适用于macOS系统。"
    exit 1
fi

# 检查前端构建目录
if [ ! -d "frontend/dist" ]; then
    echo "前端构建目录不存在，正在构建前端代码..."
    cd frontend
    if [ -f "yarn.lock" ]; then
        yarn install
        yarn build
    else
        npm install
        npm run build
    fi
    cd ..
fi

# 检查Docker镜像
echo "检查Docker镜像..."
if ! docker images | grep -q "aireview-backend"; then
    echo "警告: 未找到后端镜像，正在拉取..."
    docker-compose pull backend
fi

if ! docker images | grep -q "nginx:alpine"; then
    echo "警告: 未找到Nginx镜像，正在拉取..."
    docker-compose pull nginx
fi

if ! docker images | grep -q "mysql:8.0"; then
    echo "警告: 未找到MySQL镜像，正在拉取..."
    docker-compose pull db
fi

# 检查fswatch工具
if ! command -v fswatch &> /dev/null; then
    echo "正在安装必要的工具: fswatch"
    brew install fswatch || {
        echo "错误: 安装fswatch失败。请手动运行: brew install fswatch"
        exit 1
    }
fi

# 检查Docker
if ! command -v docker &> /dev/null; then
    echo "错误: 未安装Docker。请先安装Docker Desktop for Mac。"
    exit 1
fi

if ! docker ps &> /dev/null; then
    echo "错误: Docker未运行。请先启动Docker Desktop应用。"
    exit 1
fi

# 检查容器是否在运行
if ! docker ps | grep -q "$NGINX_CONTAINER"; then
    echo "警告: Nginx容器未运行。"
    if docker ps -a | grep -q "$NGINX_CONTAINER"; then
        read -p "是否要启动容器? (y/n): " start_container
        if [[ "$start_container" =~ ^[Yy]$ ]]; then
            docker start $NGINX_CONTAINER
            sleep 2
        else
            echo "退出脚本。"
            exit 0
        fi
    else 
        echo "容器不存在。请先使用 ./start-containers.sh 启动环境。"
        exit 1
    fi
fi

# 前端源码文件变化后自动编译并重载
watch_frontend_src() {
    echo "开始监控前端源代码文件变化..."
    open http://localhost/
    
    # 停止旧的监控进程
    if [ ! -z "$FRONTEND_SRC_PID" ]; then
        kill $FRONTEND_SRC_PID 2>/dev/null
    fi
    
    # 监控前端源码目录变化，自动编译并重载
    fswatch -o ./frontend/src | while read f; do
        echo "检测到前端源码变化，自动编译..."
        # 延迟1秒执行编译，避免文件正在保存中就开始编译
        sleep 1
        (
            cd frontend
            if [ -f "yarn.lock" ]; then
                yarn build
            else
                npm run build
            fi
        )
        # 编译完成后自动重载Nginx
        echo "编译完成，重新加载Nginx..."
        docker exec $NGINX_CONTAINER nginx -s reload
        # 使用AppleScript发送通知
        osascript -e 'display notification "前端文件已编译并重新加载" with title "AIreview" sound name "Submarine"'
    done &
    FRONTEND_SRC_PID=$!
    
    echo "前端源码监控已启动。"
    echo "源代码修改后将自动编译并刷新浏览器。"
}

# 监控dist目录变化并重载
watch_frontend_dist() {
    echo "开始监控前端构建目录变化..."
    open http://localhost/
    
    # 停止旧的监控进程
    if [ ! -z "$FRONTEND_DIST_PID" ]; then
        kill $FRONTEND_DIST_PID 2>/dev/null
    fi
    
    # 监控dist目录变化，自动重载Nginx
    fswatch -o ./frontend/dist | while read f; do
        echo "检测到前端构建目录变化，重新加载Nginx..."
        docker exec $NGINX_CONTAINER nginx -s reload
        # 使用AppleScript发送通知
        osascript -e 'display notification "前端页面已重新加载" with title "AIreview" sound name "Submarine"'
    done &
    FRONTEND_DIST_PID=$!
    
    echo "前端构建目录监控已启动。"
    echo "当dist目录变化时将自动刷新浏览器。"
}

# 监控并重载后端
watch_backend() {
    echo "开始监控后端文件变化..."
    
    # 停止旧的监控进程
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
    fi
    
    # 监控backend/src目录变化，自动重启Node应用
    fswatch -o ./backend/src | while read f; do
        echo "检测到后端文件变化，重启服务..."
        sleep 1  # 短暂延迟，确保文件保存完成
        docker exec $BACKEND_CONTAINER sh -c "npm run restart"
        # 使用AppleScript发送通知
        osascript -e 'display notification "后端服务已重启" with title "AIreview" sound name "Submarine"'
    done &
    BACKEND_PID=$!
    
    echo "后端文件监控已启动。"
    echo "保存后端文件后，服务将自动重启。"
}

# 启动热重载开发模式
start_hot_reload() {
    echo "启动热重载开发模式..."
    
    # 停止旧的开发服务器
    if pgrep -f "npm run serve\|yarn serve\|npm run dev\|yarn dev\|yarn start\|npm start" > /dev/null; then
        echo "检测到开发服务器已在运行，正在关闭..."
        pkill -f "npm run serve\|yarn serve\|npm run dev\|yarn dev\|yarn start\|npm start"
        sleep 2
    fi
    
    # 检查项目支持哪些命令
    cd frontend
    
    # 检测可用的开发命令
    DEV_COMMAND=""
    
    # 检查package.json中的脚本
    if [ -f "package.json" ]; then
        echo "检查package.json中的可用命令..."
        
        # 首先尝试常见的开发命令
        if grep -q "\"dev\"" package.json; then
            DEV_COMMAND="dev"
            echo "找到dev命令"
        elif grep -q "\"serve\"" package.json; then
            DEV_COMMAND="serve"
            echo "找到serve命令"
        elif grep -q "\"start\"" package.json; then
            DEV_COMMAND="start"
            echo "找到start命令"
        # 其他可能的命令
        elif grep -q "\"development\"" package.json; then
            DEV_COMMAND="development"
            echo "找到development命令"
        fi
    fi
    
    # 如果没有找到开发命令，使用回退方案：直接构建并监控dist目录
    if [ -z "$DEV_COMMAND" ]; then
        echo "未找到开发服务器命令，将使用构建+监控模式..."
        cd ..
        watch_frontend_src
        return
    fi
    
    # 启动开发服务器
    echo "使用命令: $DEV_COMMAND 启动开发服务器..."
    if [ -f "yarn.lock" ]; then
        yarn $DEV_COMMAND &
    else
        npm run $DEV_COMMAND &
    fi
    
    DEV_SERVER_PID=$!
    cd ..
    
    echo "等待开发服务器启动..."
    sleep 5
    
    # 检查开发服务器端口
    DEV_PORT=5173  # Vite默认端口
    
    # 尝试检测实际端口
    if lsof -i :3000 | grep -q "node"; then
        DEV_PORT=3000
        echo "检测到开发服务器运行在端口3000"
    elif lsof -i :8080 | grep -q "node"; then
        DEV_PORT=8080
        echo "检测到开发服务器运行在端口8080"
    elif lsof -i :5173 | grep -q "node"; then
        DEV_PORT=5173
        echo "检测到开发服务器运行在端口5173"
    fi
    
    # 更新Nginx配置来代理到开发服务器
    echo "更新Nginx配置，代理到本地端口${DEV_PORT}..."
    cat > nginx/default.conf << EOF
server {
    listen 80;
    server_name localhost;
    
    # API请求代理
    location /api/ {
        proxy_pass http://backend:3000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
    
    # 前端开发服务器代理
    location / {
        proxy_pass http://host.docker.internal:${DEV_PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_cache_bypass \$http_upgrade;
    }
    
    # 静态资源代理
    location /uploads/ {
        proxy_pass http://backend:3000/uploads/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_cache_bypass \$http_upgrade;
    }
    
    # 健康检查接口
    location /health {
        return 200 'ok';
        add_header Content-Type text/plain;
    }
}
EOF
    # 重新加载Nginx配置
    docker exec $NGINX_CONTAINER nginx -s reload
    
    echo "热重载开发模式已启动！"
    echo "访问地址: http://localhost"
    echo "前端代码修改将自动热重载，无需手动刷新。"
    
    # 打开浏览器
    open http://localhost/
}

# 停止热重载开发模式
stop_hot_reload() {
    echo "停止热重载开发模式..."
    
    # 停止开发服务器
    if [ ! -z "$DEV_SERVER_PID" ]; then
        kill $DEV_SERVER_PID 2>/dev/null
    fi
    
    # 杀死所有相关进程
    pkill -f "npm run serve\|yarn serve\|npm run dev\|yarn dev\|yarn start\|npm start" 2>/dev/null
    
    # 恢复Nginx原始配置
    cat > nginx/default.conf << EOF
server {
    listen 80;
    server_name localhost;
    
    # 启用gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_min_length 1000;
    
    # 设置前端资源缓存策略
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)\$ {
        root /usr/share/nginx/html;
        expires 30d;
        add_header Cache-Control "public, max-age=2592000";
        try_files \$uri \$uri/ /index.html;
    }
    
    # 前端静态文件
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    # API请求代理
    location /api/ {
        proxy_pass http://backend:3000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }

    # 静态资源代理
    location /uploads/ {
        proxy_pass http://backend:3000/uploads/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_cache_bypass \$http_upgrade;
    }
    
    # 健康检查接口
    location /health {
        return 200 'ok';
        add_header Content-Type text/plain;
    }
}
EOF
    # 重新加载Nginx配置
    docker exec $NGINX_CONTAINER nginx -s reload
    
    echo "热重载开发模式已停止。"
}

# 停止所有监控
stop_watching() {
    echo "停止所有文件监控..."
    if [ ! -z "$FRONTEND_SRC_PID" ]; then
        kill $FRONTEND_SRC_PID 2>/dev/null
    fi
    if [ ! -z "$FRONTEND_DIST_PID" ]; then
        kill $FRONTEND_DIST_PID 2>/dev/null
    fi
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
    fi
    if [ ! -z "$DEV_SERVER_PID" ]; then
        kill $DEV_SERVER_PID 2>/dev/null
    fi
    
    # 杀死所有相关进程
    pkill -f "npm run serve\|yarn serve\|npm run dev\|yarn dev\|yarn start\|npm start" 2>/dev/null
    
    echo "监控已停止。"
}

# 快速编译前端
build_frontend() {
    echo "编译前端代码..."
    cd frontend
    
    if [ -f "yarn.lock" ]; then
        yarn build
    else
        npm run build
    fi
    
    cd ..
    
    echo "前端代码编译完成。"
    # 重新加载Nginx
    docker exec $NGINX_CONTAINER nginx -s reload
    osascript -e 'display notification "前端代码编译完成" with title "AIreview" sound name "Submarine"'
}

# 自动打开浏览器
open_browser() {
    echo "打开浏览器..."
    open http://localhost/
}

# 清理函数
cleanup() {
    echo "正在清理..."
    stop_watching
    echo "脚本已结束。"
    exit 0
}

# 捕获中断信号
trap cleanup SIGINT SIGTERM

# 主菜单
show_menu() {
    echo ""
    echo "===== Mac开发环境菜单 ====="
    echo "1) 监控前端源码变化并自动编译刷新"
    echo "2) 监控前端构建目录变化自动刷新"
    echo "3) 监控后端文件变化并自动重启"
    echo "4) 启动热重载开发模式(推荐)"
    echo "5) 停止热重载开发模式"
    echo "6) 手动编译前端代码"
    echo "7) 打开浏览器访问应用"
    echo "8) 停止所有监控"
    echo "q) 退出"
    echo "========================="
    echo ""
}

# 主循环
while true; do
    show_menu
    read -p "请选择操作 [1-8/q]: " choice
    
    case $choice in
        1) watch_frontend_src ;;
        2) watch_frontend_dist ;;
        3) watch_backend ;;
        4) start_hot_reload ;;
        5) stop_hot_reload ;;
        6) build_frontend ;;
        7) open_browser ;;
        8) stop_watching ;;
        q|Q) 
            cleanup
            ;;
        *) echo "无效选择，请重试。" ;;
    esac
done 