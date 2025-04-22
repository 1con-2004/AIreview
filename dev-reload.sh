#!/bin/bash

# AIreview 开发环境自动重载脚本
# 监控前端和后端文件变化，并自动重新加载

echo "===== AIreview 开发环境自动重载脚本 ====="
echo "该脚本将监控文件变化并自动重新加载应用"

# 检查依赖
if ! command -v inotifywait &> /dev/null && ! command -v fswatch &> /dev/null; then
    echo "错误: 未找到文件监控工具。请安装 inotify-tools (Linux) 或 fswatch (macOS)。"
    echo "Linux: sudo apt-get install inotify-tools"
    echo "macOS: brew install fswatch"
    exit 1
fi

# 检查Docker环境
if ! docker ps &> /dev/null; then
    echo "错误: Docker未运行或没有权限访问Docker。"
    exit 1
fi

# 检查容器是否正在运行
if ! docker ps | grep -q "aireview-frontend\|aireview-backend\|aireview-nginx"; then
    echo "警告: 未检测到AIreview容器在运行。"
    read -p "是否要启动Docker环境? (y/n): " start_docker
    if [[ "$start_docker" =~ ^[Yy]$ ]]; then
        ./start-containers.sh
    else
        echo "退出脚本。"
        exit 0
    fi
fi

# 定义重载函数
reload_frontend() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 检测到前端文件变化，重新编译..."
    # 在Docker容器内构建前端
    docker exec aireview-backend sh -c "cd /app && npm run build"
    # 更新nginx容器中的文件
    docker exec aireview-nginx sh -c "nginx -s reload"
    echo "前端重新加载完成。"
}

reload_backend() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 检测到后端文件变化，重启服务..."
    # 重启Node.js进程
    docker exec aireview-backend sh -c "npm run restart"
    echo "后端重新加载完成。"
}

# 快速重启容器
restart_containers() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 重启所有容器..."
    docker-compose restart
    echo "容器重启完成。"
}

# 显示菜单
show_menu() {
    echo ""
    echo "===== 开发环境操作菜单 ====="
    echo "1) 重新加载前端"
    echo "2) 重启后端服务"
    echo "3) 重启所有容器"
    echo "4) 停止监控"
    echo "5) 查看容器日志"
    echo "6) 运行数据库命令"
    echo "q) 退出"
    echo "=========================="
    echo ""
}

# 启动监控
start_monitoring() {
    echo "开始监控文件变化..."
    
    # 使用适当的监控工具
    if command -v fswatch &> /dev/null; then
        # macOS
        fswatch -o ./frontend/src | while read f; do
            reload_frontend
        done &
        FRONTEND_PID=$!
        
        fswatch -o ./backend/src | while read f; do
            reload_backend
        done &
        BACKEND_PID=$!
    elif command -v inotifywait &> /dev/null; then
        # Linux
        while true; do
            inotifywait -r -e modify,create,delete ./frontend/src
            reload_frontend
        done &
        FRONTEND_PID=$!
        
        while true; do
            inotifywait -r -e modify,create,delete ./backend/src
            reload_backend
        done &
        BACKEND_PID=$!
    else
        echo "错误: 不支持的操作系统或未安装监控工具。"
        exit 1
    fi
    
    echo "监控已启动。按 'q' 退出，或输入数字执行相应操作。"
}

# 停止监控
stop_monitoring() {
    echo "停止文件监控..."
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
    fi
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
    fi
    echo "监控已停止。"
}

# 查看容器日志
view_logs() {
    echo "选择要查看的容器日志:"
    echo "1) 前端 (Nginx)"
    echo "2) 后端"
    echo "3) 数据库"
    echo "4) 全部容器"
    echo "q) 返回"
    read -p "请选择: " log_choice
    
    case $log_choice in
        1) docker logs aireview-nginx --tail 100 -f ;;
        2) docker logs aireview-backend --tail 100 -f ;;
        3) docker logs aireview-db --tail 100 -f ;;
        4) docker-compose logs --tail 100 -f ;;
        q|Q) return ;;
        *) echo "无效选择" ;;
    esac
}

# 运行数据库命令
run_db_command() {
    echo "MySQL数据库操作:"
    echo "1) 登录MySQL控制台"
    echo "2) 执行SQL命令"
    echo "3) 备份数据库"
    echo "4) 恢复数据库"
    echo "q) 返回"
    read -p "请选择: " db_choice
    
    case $db_choice in
        1) 
            docker exec -it aireview-db mysql -uroot -proot AIreview
            ;;
        2)
            read -p "输入SQL命令: " sql_cmd
            docker exec -i aireview-db mysql -uroot -proot AIreview -e "$sql_cmd"
            ;;
        3)
            backup_file="AIreview_backup_$(date '+%Y%m%d_%H%M%S').sql"
            echo "备份数据库到 $backup_file..."
            docker exec aireview-db mysqldump -uroot -proot AIreview > $backup_file
            echo "备份完成。"
            ;;
        4)
            read -p "输入备份文件路径: " restore_file
            if [ -f "$restore_file" ]; then
                echo "开始恢复数据库..."
                cat $restore_file | docker exec -i aireview-db mysql -uroot -proot AIreview
                echo "恢复完成。"
            else
                echo "错误: 文件不存在"
            fi
            ;;
        q|Q) return ;;
        *) echo "无效选择" ;;
    esac
}

# 主循环
start_monitoring

while true; do
    show_menu
    read -p "请选择操作 [1-6/q]: " choice
    
    case $choice in
        1) reload_frontend ;;
        2) reload_backend ;;
        3) restart_containers ;;
        4) 
            stop_monitoring
            read -p "是否重新开始监控? (y/n): " restart_mon
            if [[ "$restart_mon" =~ ^[Yy]$ ]]; then
                start_monitoring
            fi
            ;;
        5) view_logs ;;
        6) run_db_command ;;
        q|Q) 
            stop_monitoring
            echo "脚本已退出。"
            exit 0
            ;;
        *) echo "无效选择，请重试。" ;;
    esac
done 