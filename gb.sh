#!/system/bin/sh
MODDIR=${0%/*}

# 停止 crond 服务（通过模块路径过滤进程）
pkill -f "crond -c $MODDIR/cron"
