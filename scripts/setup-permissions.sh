#!/bin/bash

# 转到项目根目录
cd "$(dirname "$0")/.."
ROOT_DIR=$(pwd)

echo "============================"
echo "AIreview脚本权限设置工具"
echo "============================"

# 设置脚本执行权限
echo "设置scripts目录下所有脚本的执行权限..."
chmod +x $ROOT_DIR/scripts/*.sh
echo "完成！"

echo "为Windows批处理文件设置权限..."
if ls $ROOT_DIR/scripts/*.bat >/dev/null 2>&1; then
  chmod +x $ROOT_DIR/scripts/*.bat
  echo "完成！"
else
  echo "未找到.bat文件，跳过"
fi

echo "============================"
echo "所有脚本已设置执行权限"
echo "您现在可以直接运行任何脚本:"
echo "./scripts/start-containers.sh"
echo "./scripts/log-manager.sh"
echo "等等..."
echo "============================" 