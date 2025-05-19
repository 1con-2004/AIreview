#!/bin/bash

# 转到项目根目录
cd "$(dirname "$0")/.."
ROOT_DIR=$(pwd)

# AIreview日志级别管理脚本
# 用于控制后端日志输出级别

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # 无颜色

# 定义后端容器名称
BACKEND_CONTAINER="aireview-backend"

# 检查Docker
check_docker() {
  if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: 未安装Docker。请先安装Docker。${NC}"
    exit 1
  fi

  if ! docker ps &> /dev/null; then
    echo -e "${RED}错误: Docker未运行。请先启动Docker。${NC}"
    exit 1
  fi
}

# 检查后端容器
check_backend_container() {
  if ! docker ps | grep -q "$BACKEND_CONTAINER"; then
    echo -e "${YELLOW}警告: 后端容器 $BACKEND_CONTAINER 未运行。${NC}"
    if docker ps -a | grep -q "$BACKEND_CONTAINER"; then
      read -p "是否要启动容器? (y/n): " start_container
      if [[ "$start_container" =~ ^[Yy]$ ]]; then
        docker start $BACKEND_CONTAINER
        sleep 2
        echo -e "${GREEN}容器已启动。${NC}"
      else
        echo -e "${RED}退出脚本。${NC}"
        exit 0
      fi
    else 
      echo -e "${RED}容器不存在。请先使用 $ROOT_DIR/scripts/start-containers.sh 启动环境。${NC}"
      exit 1
    fi
  fi
}

# 获取当前日志级别
get_log_levels() {
  echo -e "${BLUE}获取当前日志级别...${NC}"
  curl -s http://localhost/api/log/level | jq .
}

# 设置日志级别
set_log_level() {
  level=$1
  if [[ $level -lt 0 || $level -gt 4 ]]; then
    echo -e "${RED}错误: 日志级别必须在0-4之间。${NC}"
    return 1
  fi
  
  echo -e "${BLUE}设置日志级别为 $level...${NC}"
  curl -s http://localhost/api/log/level/$level | jq .
  
  # 显示级别对应的含义
  case $level in
    0) echo -e "${CYAN}现在处于静默模式: 不输出任何日志${NC}" ;;
    1) echo -e "${CYAN}现在处于错误模式: 仅输出错误和警告日志${NC}" ;;
    2) echo -e "${CYAN}现在处于标准模式: 输出常规操作日志${NC}" ;;
    3) echo -e "${CYAN}现在处于调试模式: 输出详细调试信息${NC}" ;;
    4) echo -e "${CYAN}现在处于详细模式: 输出所有细节信息${NC}" ;;
  esac
}

# 说明日志级别
explain_log_levels() {
  echo -e "${BLUE}===== 日志级别说明 =====${NC}"
  echo -e "${RED}0 - 静默模式${NC}: 不输出任何日志（仅适用于生产环境）"
  echo -e "${YELLOW}1 - 错误模式${NC}: 只输出错误和警告日志"
  echo -e "${GREEN}2 - 标准模式${NC}: 输出常规操作日志（包括错误和警告）"
  echo -e "${BLUE}3 - 调试模式${NC}: 输出详细调试信息（包括操作日志、错误和警告）"
  echo -e "${CYAN}4 - 详细模式${NC}: 输出所有日志，包括数据库查询结果等"
  echo ""
}

# 用法说明
usage() {
  echo -e "${GREEN}AIreview 日志级别管理脚本${NC}"
  echo ""
  echo "用法: $0 [选项] [级别]"
  echo ""
  echo "选项:"
  echo "  -h, --help       显示帮助信息"
  echo "  -g, --get        获取当前日志级别"
  echo "  -s, --set LEVEL  设置日志级别 (0-4)"
  echo "  -e, --explain    显示各日志级别的说明"
  echo ""
  echo "日志级别:"
  echo "  0: 静默模式 - 不输出任何日志"
  echo "  1: 错误模式 - 只输出错误和警告日志"
  echo "  2: 标准模式 - 输出常规操作日志"
  echo "  3: 调试模式 - 输出详细调试日志"
  echo "  4: 详细模式 - 输出所有日志"
  echo ""
  echo "示例:"
  echo "  $0              进入交互菜单"
  echo "  $0 -g           获取当前日志级别"
  echo "  $0 -s 1         设置日志级别为1（错误模式）"
  echo "  $0 -e           显示各日志级别的说明"
  echo ""
}

# 菜单
show_menu() {
  echo -e "${GREEN}===== AIreview 日志级别管理 =====${NC}"
  echo ""
  explain_log_levels
  echo "请选择操作:"
  echo -e "${BLUE}g${NC}) 获取当前日志级别"
  echo -e "${BLUE}0${NC}) 设置为静默模式 (0级)"
  echo -e "${BLUE}1${NC}) 设置为错误模式 (1级)"
  echo -e "${BLUE}2${NC}) 设置为标准模式 (2级)"
  echo -e "${BLUE}3${NC}) 设置为调试模式 (3级)"
  echo -e "${BLUE}4${NC}) 设置为详细模式 (4级)"
  echo -e "${BLUE}r${NC}) 重启后端服务"
  echo -e "${BLUE}q${NC}) 退出"
  echo ""
}

# 重启后端服务
restart_backend() {
  echo -e "${BLUE}正在重启后端服务...${NC}"
  docker restart $BACKEND_CONTAINER
  echo -e "${GREEN}后端服务已重启！${NC}"
}

# 检查jq工具
check_jq() {
  if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}警告: 未安装jq工具，输出将不会格式化。${NC}"
    echo -e "${YELLOW}建议安装jq以获得更好的显示效果:${NC}"
    echo -e "${BLUE}  brew install jq${NC}"
  fi
}

# 主函数
main() {
  # 检查Docker环境
  check_docker
  
  # 检查后端容器
  check_backend_container
  
  # 检查jq工具
  check_jq
  
  # 如果没有参数，进入交互菜单
  if [ $# -eq 0 ]; then
    # 交互式菜单循环
    while true; do
      show_menu
      read -p "请选择 [g/0/1/2/3/4/r/q]: " choice
      
      case $choice in
        g|G) get_log_levels ;;
        0) set_log_level 0 ;;
        1) set_log_level 1 ;;
        2) set_log_level 2 ;;
        3) set_log_level 3 ;;
        4) set_log_level 4 ;;
        r|R) restart_backend ;;
        q|Q) 
          echo -e "${GREEN}感谢使用！${NC}"
          exit 0 
          ;;
        *) echo -e "${RED}无效选择，请重试。${NC}" ;;
      esac
      
      echo ""
      read -p "按Enter键继续..."
    done
  else
    # 处理命令行参数
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      -g|--get)
        get_log_levels
        exit 0
        ;;
      -s|--set)
        if [ -z "$2" ]; then
          echo -e "${RED}错误: 请提供日志级别 (0-4)${NC}"
          exit 1
        fi
        set_log_level "$2"
        exit 0
        ;;
      -e|--explain)
        explain_log_levels
        exit 0
        ;;
      *)
        echo -e "${RED}错误: 未知选项 $1${NC}"
        usage
        exit 1
        ;;
    esac
  fi
}

# 运行主函数
main "$@" 