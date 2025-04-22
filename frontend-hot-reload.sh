#!/bin/bash

# AIreview 前端热重载脚本
# 利用 docker-compose 卷挂载实现前端自动重载

echo "===== AIreview 前端热重载脚本 ====="

# 检查Docker环境
if ! docker ps &> /dev/null; then
    echo "错误: Docker未运行或没有权限访问Docker。"
    exit 1
fi

# 定义容器名称
NGINX_CONTAINER="aireview-nginx"
BACKEND_CONTAINER="aireview-backend"

# 检查容器是否存在
if ! docker ps -a | grep -q "$NGINX_CONTAINER"; then
    echo "错误: 未找到Nginx容器 ($NGINX_CONTAINER)。请先启动Docker环境。"
    echo "可以使用 ./start-containers.sh 启动环境。"
    exit 1
fi

# 检查前端构建目录是否存在
if [ ! -d "frontend/dist" ]; then
    echo "警告: 前端构建目录不存在，将进行初始构建..."
    
    if [ -d "frontend" ] && [ -f "frontend/package.json" ]; then
        echo "检测到前端项目，开始构建..."
        cd frontend
        
        # 尝试使用yarn或npm构建
        if [ -f "yarn.lock" ]; then
            echo "使用yarn构建..."
            yarn install && yarn build
        else
            echo "使用npm构建..."
            npm install && npm run build
        fi
        
        cd ..
        
        if [ ! -d "frontend/dist" ]; then
            echo "错误: 前端构建失败。"
            exit 1
        fi
    else
        echo "错误: 未找到有效的前端项目。"
        exit 1
    fi
fi

# 启用前端开发模式
start_dev_mode() {
    echo "启动前端开发模式..."
    
    cd frontend
    
    # 检查是否已有开发服务器正在运行
    if pgrep -f "npm run dev\|yarn dev" > /dev/null; then
        echo "检测到开发服务器已在运行，正在关闭..."
        pkill -f "npm run dev\|yarn dev"
        sleep 2
    fi
    
    # 启动开发服务器
    if [ -f "yarn.lock" ]; then
        echo "使用yarn启动开发服务器..."
        yarn dev &
    else
        echo "使用npm启动开发服务器..."
        npm run dev &
    fi
    
    DEV_SERVER_PID=$!
    cd ..
    
    # 更新Nginx配置来代理到开发服务器
    echo "更新Nginx配置..."
    cat > nginx/default.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    
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
    }
    
    # 前端开发服务器代理 (默认在localhost:5173运行)
    location / {
        proxy_pass http://host.docker.internal:5173;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_cache_bypass $http_upgrade;
    }
    
    # 静态资源代理
    location /uploads/ {
        proxy_pass http://backend:3000/uploads/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
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
    
    echo "前端开发模式已启动！"
    echo "访问地址: http://localhost"
    echo "前端代码修改将自动热重载，无需手动刷新。"
}

# 停止开发模式
stop_dev_mode() {
    echo "停止前端开发模式..."
    
    # 停止开发服务器
    if [ ! -z "$DEV_SERVER_PID" ]; then
        kill $DEV_SERVER_PID 2>/dev/null
    fi
    
    # 杀死所有相关进程
    pkill -f "npm run dev\|yarn dev" 2>/dev/null
    
    # 恢复Nginx原始配置
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
    }

    # 静态资源代理
    location /uploads/ {
        proxy_pass http://backend:3000/uploads/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
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
    
    echo "前端开发模式已停止。"
}

# 构建并部署前端
build_deploy() {
    echo "构建并部署前端..."
    
    cd frontend
    
    # 构建前端
    if [ -f "yarn.lock" ]; then
        echo "使用yarn构建..."
        yarn build
    else
        echo "使用npm构建..."
        npm run build
    fi
    
    cd ..
    
    # 重新加载Nginx配置
    docker exec $NGINX_CONTAINER nginx -s reload
    
    echo "前端构建并部署完成。"
}

# 重启后端服务
restart_backend() {
    echo "重启后端服务..."
    if docker ps | grep -q "$BACKEND_CONTAINER"; then
        docker exec $BACKEND_CONTAINER sh -c "npm run restart"
        echo "后端服务已重启。"
    else
        echo "错误: 后端容器未运行。"
    fi
}

# 显示菜单
show_menu() {
    echo ""
    echo "===== 前端开发菜单 ====="
    echo "1) 启用前端热重载模式"
    echo "2) 停止前端热重载模式"
    echo "3) 构建并部署前端"
    echo "4) 重启后端服务"
    echo "5) 显示Nginx访问日志"
    echo "q) 退出"
    echo "======================"
    echo ""
}

# 清理函数
cleanup() {
    echo "正在清理..."
    stop_dev_mode
    echo "脚本已结束。"
    exit 0
}

# 捕获中断信号
trap cleanup SIGINT SIGTERM

# 主循环
while true; do
    show_menu
    read -p "请选择操作 [1-5/q]: " choice
    
    case $choice in
        1) start_dev_mode ;;
        2) stop_dev_mode ;;
        3) build_deploy ;;
        4) restart_backend ;;
        5) docker exec $NGINX_CONTAINER tail -f /var/log/nginx/access.log ;;
        q|Q) 
            cleanup
            ;;
        *) echo "无效选择，请重试。" ;;
    esac
done 