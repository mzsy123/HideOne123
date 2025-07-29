if [ `whoami` = "root" ]; then
    echo "- 开始下载  Ps:因为用的github所以下载过程可能需要魔法网络请自备"
    busybox wget "https://mzsy123.github.io/keybox.xml" -O /data/local/tmp/keybox.xml
    sleep 1
    echo "- 下载完成，正在尝试移动keybox"
    mv -f "/data/local/tmp/keybox.xml" "/data/adb/tricky_store/"
    sleep 1
    echo "- 移动完成"
    sleep 1
    echo "- 执行结束"
else
    echo "- 请以root权限执行！"
    exit
fi
