MODDIR=${0%/*}

(
until [ $(getprop sys.boot_completed) -eq 1 ] ; do
  sleep 5
done

export PATH="/system/bin:/system/xbin:/vendor/bin:$(magisk --path)/.magisk/busybox:$PATH"
crond -c $MODDIR/cron

# if [ -f "/data/adb/modules/HideOne/disable" ]; then
    # sed -i 's/^description=.*/description=状态:模块停止运行❌本模块可全自动添加TS模块包名列表，支持添加白名单及额外包名默认添加3方应用包名/' module.prop
# else
    # sed -i 's/^description=.*/description=状态:模块运行中✅本模块可全自动添加TS模块包名列表，支持添加白名单及额外包名默认添加3方应用包名/' module.prop
# fi
sed -i 's/^description=.*/description=状态:模块运行中✅本模块可全自动添加TS模块包名列表，支持添加白名单及额外包名默认添加3方应用包名/' module.prop

# chmod 777 $MODDIR/package/pa.sh
# chmod 777 /data/adb/modules/HideOne/package/pa.sh
sh $MODDIR/package/pa.sh
# sh /data/adb/modules/HideOne/package/pa.sh

if [ -e "$MODDIR/mzsy" ]; then
  rm -rf $MODDIR/mzsy
fi
)