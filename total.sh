#!/system/bin/sh  这是一个工具集合脚本
local() {
# 如你所见 这是一个空函数
}

oneword() {
NETWORK_URL="https://v1.jinrishici.com/all.txt"

# 从网络获取数据（使用curl，-s静默模式，-f失败时不输出错误）
# 将结果存入变量 NETWORK_DATA
NETWORK_DATA=$(curl -s -f "$NETWORK_URL")

# 判断是否获取成功（若变量为空，说明失败）
if [ -z "$NETWORK_DATA" ]; then
  echo "- 网络无法连接"
  exit 1  # 退出并返回错误码
fi

# 输出获取到的变量内容
echo "- $NETWORK_DATA"
}

print_lovely() {
cat << "EOF"
⣿⣿⡿⠁⠂⠉⢀⣴⡖⢀⣶⡖⢠⣶⣶⣤⣭⣍⢛⠻⠿⢃⡴⠶⢦⡉⣩
⠿⠿⠃⣀⢀⢢⣾⡖⢄⣾⠿⠃⢺⣶⡶⠭⠙⠃⡼⢿⡇⢿⡀⠀⢂⣿⠁
⣶⣾⣿⡏⣰⣿⡏⣴⢿⣣⣾⣿⣿⣿⣇⣿⢇⡆⣽⢳⡆⢄⠙⣛⡋⠙⢧
⣤⣬⡍⢸⣿⣿⣧⠟⠛⠋⠉⡾⣿⣿⣿⢻⢸⡟⠹⠼⣇⣼⢸⡦⣴⣸⣷
⣿⣿⠇⡟⣿⣛⠀⣠⠖⠹⠆⢾⡽⣿⣿⣸⠣⢀⡠⣀⠉⠛⢞⣼⣿⣀⢿
⣿⡏⠀⢧⠹⣿⣷⡏⠰⣿⡃⢸⣿⣮⣽⣋⠀⢶⠄⠘⣇⠀⢊⠳⢣⣿⡎
⠟⠀⣼⢣⣶⡝⡿⠿⠦⢦⣴⣿⣿⣿⣿⣿⣈⡛⡊⠀⣿⣶⣶⣽⣿⠿⣱
⣴⣿⡿⡞⡏⣠⣶⣶⣶⣦⡙⢿⠟⢉⣠⣴⣶⣶⣄⠨⣿⣿⠿⡟⢉⣴⣿
⣿⣿⡇⠆⢠⣿⣿⣿⣿⣿⣿⣦⣾⣿⣿⣿⣿⣿⣿⣷⢐⡢⠁⢀⢸⣿⣿
⡿⠋⠃⡄⠸⣿⣏⣉⣉⣹⣿⣿⣿⣿⠿⠿⢿⣿⣿⣿⠀⢡⣾⣿⢸⢿⣏
⡇⡆⣸⡇⢰⡻⣿⣿⣿⡟⡹⠻⡟⣿⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⢸⠘⣿
⢹⠇⣿⣧⡀⣡⡞⣛⡛⢿⣶⣷⣶⣿⠿⣛⠏⢯⡑⠡⠀⢹⣿⣿⡆⣇⢌
EOF
}
HideOne123() {
if [ `whoami` = "root" ]; then
    # 定义要获取数据的网络地址
    VERSION_URL="https://mzsy123.github.io/vision.txt"
    VERSION="HideOne_update_v1.0"  # 定义本地版本

    # 将结果存入变量 NETWORK_CLOUD
    VERSION_CLOUD=$(curl -s -f "$VERSION_URL")

    # 判断是否获取成功（若变量为空，说明失败）
    if [ -z "$VERSION_CLOUD" ]; then
      echo "- 本地版本$VERSION  网络连接错误"
      echo "- Ps:因为用的Github所以下载过程可能需要使用魔法"
      exit 1  # 退出并返回错误码
    fi

    # 输出获取到的变量内容
    if [ "$VERSION" != "$VERSION_CLOUD" ]; then
      # 版本不同时，输出云端最新版本
      # echo "- 版本检测："
      echo "- 本地版本$VERSION"
      echo "- 云端最新$VERSION_CLOUD 请尽量使用最新版本"
    else
      # 版本相同时，输出本地版本
      # echo "- 版本检测："
      echo "- 当前已是最新版本$VERSION"
    fi
    sleep 1
    echo "- 开始下载核心文件"
    # 定义链接数组
    urls="https://mzsy123.github.io/sh/sr_gpt.sh"
    # 默认为GPT优化版本可改成sr.sh为普通版  普通版可能出现兼容性问题

    # 定义统一保存目录
    outdir="/data/local/tmp"
    
    # 提取文件名（共用下载和清理）
    for url in $urls; do
      files="$files $(basename "$url")"
    done

    # 执行下载
    for url in $urls; do
      fname=$(basename "$url")
      busybox wget "$url" -O "$outdir/$fname" 2>&1 | busybox awk -v f="- $fname" '
      /%/ {
        for (i=1; i<=NF; i++)
          if ($i ~ /%$/) p=$i
        if (p) print f, p
        fflush()
      }'
    done
    sleep 0.3
    echo "- $fname刷入文件下载结束"
    if [ -e "!$outdir/$fname" ]; then
        echo "- $fname文件不存在"
        exit
    fi
    echo "- 正在执行核心程序"
    sh "$outdir/$fname"
    sleep 1
    echo "- 执行结束"
    sleep 0.5
    echo "- 正在清理缓存"
    for fname in $files; do
      rm -f "$outdir/$fname"
    done
    sleep 1
    echo "- 清理完成"
else
    echo "- 请以root权限执行！"
    exit
fi
}

devcheck() {
  print_line() {
    echo ""
  }
  
  echo "--------------------系统部分--------------------"
  echo "品牌:$(getprop ro.product.system.brand)"
  echo "设备:$(getprop ro.product.system.device)"
  echo "制造商:$(getprop ro.product.system.manufacturer)"
  echo "型号:$(getprop ro.product.system.model)"
  echo "名称:$(getprop ro.product.system.name)"
  echo "CPU架构:$(getprop ro.system.product.cpu.abilist)"
  echo "系统指纹:$(getprop ro.system.build.fingerprint)"
  print_line
  echo "安卓版本:$(getprop ro.system.build.version.release)"
  echo "sdk版本:$(getprop ro.system.build.version.sdk)"
  print_line
  echo "处理器代号:$(getprop ro.product.board)"
  echo "处理器平台:$(getprop ro.board.platform)"
  print_line
  echo "vendor 补丁版本:$(getprop ro.vendor.build.security_patch)"
  echo "系统/boot 补丁版本:$(getprop ro.build.version.security_patch)"
  print_line
  echo "verifiedBootHash(Boot哈西值):$(getprop ro.boot.vbmeta.digest)"
  print_line
  echo "内核版本号:$(uname -r)"
  echo "构建时间:$(uname -v)"
  print_line

  echo "--------------------电池部分--------------------"
  echo "测试机型:一加Ace 5  可能不支持米系机型"
  print_line

  if [ `whoami` = "root" ]; then

  BAT="/sys/class/power_supply/battery"  # 基础路径喵~

  # 获取原始数据  仅获取当前值无自动更新
  CHARGE_FULL=$(cat $BAT/charge_full)
  CHARGE_DESIGN=$(cat $BAT/charge_full_design)
  CHARGE_COUNTER=$(cat $BAT/charge_counter)
  ENERGY_FULL=$(cat $BAT/energy_full)            # 单位：mAh
  VOLTAGE=$(cat $BAT/voltage_now)                # 单位：μV
  TEMP_RAW=$(cat $BAT/temp)                      # 单位：0.1°C
  CURRENT=$(cat $BAT/current_now)                # 单位：mA
  STATUS=$(cat $BAT/status)

  # 计算容量百分比（和系统里那个一样四舍五入法）
  CAPACITY_INT=$(awk "BEGIN { printf \"%d\", ($CHARGE_FULL / $CHARGE_DESIGN) * 100 }")

  # 精确计算容量  实际容量百分比
  CAPACITY_FLOAT=$(awk "BEGIN {
    design_mah = $CHARGE_DESIGN / 1000;
    printf \"%.2f\", $ENERGY_FULL / design_mah * 100
  }")

  # 电压 μV → V（保留 3 位小数）
  VOLTAGE_V=$(awk "BEGIN { printf \"%.3f\", $VOLTAGE / 1000000 }")

  # 温度单位换算（保留 1 位小数）
  TEMP_C=$(awk "BEGIN { printf \"%.1f\", $TEMP_RAW / 10 }")

  # 电流符号处理
  if [ "$STATUS" = "Charging" ]; then
    CURRENT=${CURRENT#-}
  elif [ "$STATUS" = "Discharging" ]; then
    CURRENT=-${CURRENT#-}
  fi

  # 功率计算（W）= μV × mA / 1_000_000_000
  POWER_W=$(awk "BEGIN { printf \"%.2f\", ($VOLTAGE * $CURRENT) / 1000000000 }")

    # 输出信息喵！
    echo "设计容量: $((CHARGE_DESIGN / 1000)) mAh"
    echo "充满容量: ${ENERGY_FULL} mAh"
    echo "计算最大容量: ${CAPACITY_INT}%"
    echo "精确计算容量: ${CAPACITY_FLOAT}%"
    echo "充电计量: $((CHARGE_COUNTER / 1000)) mAh"
    echo "当前电量: $(cat $BAT/capacity)%"
    echo "充电周期: $(cat $BAT/cycle_count)"
    echo "电池技术: $(cat $BAT/technology)"
    echo "电池健康: $(cat $BAT/health)"
    echo "电池状态: $STATUS"
    echo "快冲状态: $(cat $BAT/charge_type)"
    echo "电池温度: ${TEMP_C} °C"
    echo "电池电压: ${VOLTAGE_V} V"
    echo "电池电流: ${CURRENT} mA"
    echo "计算功率: ${POWER_W} W"  # 无自动更新
  else
    print_line
    echo "请以root权限执行以获取电池信息!"
  fi
  # -----Made by MZSY233-----
}

sdk() {
settings delete global hidden_api_policy
settings delete global hidden_api_policy_p_apps
settings delete global hidden_api_policy_pre_p_apps
settings delete global hidden_api_blacklist_exemptions
setenforce 1
}

VoldApp() {
# 定义目标文件路径
TARGET_FILE="/data/property/persistent_properties"

# 检查文件是否存在
if [ ! -f "$TARGET_FILE" ]; then
    echo "Error: Target file $TARGET_FILE 🤔未找到文件/🤔not found file"
    exit 1
fi

# 临时删除数据隔离prop属性的命令
resetprop --delete persist.sys.vold_app_data_isolation_enabled
resetprop --delete persist.zygote.app_data_isolation

# 从一个会临时生成持久性属性的目标文件中删除因使用隐藏应用列表导致出现的数据隔离的持久性属性
# 配合以上resetprop临时删除命令既可做到无风险地彻底清理prop持久性属性痕迹
sed -i '/persist\.sys\.vold_app_data_isolation_enabled/d; /persist\.zygote\.app_data_isolation/d' "$TARGET_FILE"

echo "😎请重启设备!/😎Please reboot!"
}

xmusb() {
echo "免插卡打开MIUI/澎湃os的USB调试（安全设置）和USB安装"

echo "1.打开USB安全设置"
RESULT=`getprop persist.security.adbinput`
if [[ $RESULT != "1" ]]
then
    setprop persist.security.adbinput 1
fi

echo "2.打开fastboot刷机模式（没有bl的机型）"
RESULT=`getprop persist.fastboot.enable`
if [[ $RESULT != "1" ]]
then
    setprop persist.fastboot.enable 1
fi

XML_FILE=/data/data/com.miui.securitycenter/shared_prefs/remote_provider_preferences.xml
echo "Now modify $XML_FILE"

echo "3.启用USB安装"
LINE_NO=`grep -n "security_adb_install_enable" $XML_FILE | awk -F: '{print $1}'`
if [[ $LINE_NO > 0 ]]
then
    echo "Find security_adb_install_enable at line $LINE_NO"
    sed -i "/security_adb_install_enable/s/false/true/" $XML_FILE
else
    echo "Cannot find security_adb_install_enable, inserting..."
    sed -i '3a \        <boolean name="security_adb_install_enable" value="true" />' $XML_FILE
fi
grep "security_adb_install_enable" $XML_FILE

echo "4.禁用USB安装拦截"
LINE_NO=`grep -n "permcenter_install_intercept_enabled" $XML_FILE | awk -F: '{print $1}'`
if [[ $LINE_NO > 0 ]]
then
    echo "Find permcenter_install_intercept_enabled at line $LINE_NO"
    sed -i "/permcenter_install_intercept_enabled/s/true/false/" $XML_FILE
else
    echo "Cannot find permcenter_install_intercept_enabled, inserting..."
    sed -i '3a \        <boolean name="permcenter_install_intercept_enabled" value="false" />' $XML_FILE
fi
grep "permcenter_install_intercept_enabled" $XML_FILE

kill -9 $(pidof com.miui.securitycenter.remote)

echo "完成!记得重启一下!"
}

lqusb() {
# 解决调试痕迹并添加详细错误处理和结果验证

# 检查是否有执行脚本的必要权限
if [ "$(id -u)" -ne 0 ]; then
    echo "请以root权限运行此脚本，否则无法修改系统属性。"
    exit 1
fi

# 尝试设置系统属性
echo "正在尝试设置系统属性sys.usb.adb.disabled..."
setprop sys.usb.adb.disabled ""
if [ $? -ne 0 ]; then
    echo "设置系统属性sys.usb.adb.disabled失败。请检查："
    echo "1. 系统是否支持此属性设置。"
    echo "2. 属性名和值是否正确。"
    exit 1
fi
echo "系统属性sys.usb.adb.disabled已成功设置。"

# 尝试停止adb服务（适用于部分系统）
echo "正在尝试停止adb服务..."
# 尝试常见的adb进程名来查找adb服务进程
adb_pid=$(pidof adbd)
if [ -z "$adb_pid" ]; then
    adb_pid=$(pidof adb)
fi
if [ -z "$adb_pid" ]; then
    echo "未找到adb服务进程，可能该系统没有运行adb服务或者进程名不是常见的adbd或adb。"
else
    # 尝试使用常见包名停止adb服务
    am force-stop com.android.adbd 2>/dev/null
    if [ $? -ne 0 ]; then
        am force-stop com.android.adb 2>/dev/null
    fi
    if [ $? -eq 0 ]; then
        echo "adb服务已停止，有助于消除调试痕迹。"
    else
        echo "停止adb服务失败，可能该系统不支持此操作，但不影响属性设置。"
    fi
fi

# 验证系统属性是否设置成功
is_disabled=$(getprop sys.usb.adb.disabled)
if [ "$is_disabled" = "" ]; then
    echo "系统属性sys.usb.adb.disabled已成功设置，USB调试可能已被禁用。"
else
    echo "虽然执行了设置操作，但系统属性sys.usb.adb.disabled未正确设置，USB调试痕迹可能未完全消除。"
fi
}

ql() {
clear=(
    "/data/local/tmp/DisabledAllGoogleServices"
    "/data/local/tmp/HyperCeiler"
    "/data/local/tmp/Surfing_update"
    "/data/local/tmp/byyang"
    "/data/local/tmp/cleaner_starter"
    "/data/local/tmp/encore_logo.png"
    "/data/local/tmp/horae_control.log"
    "/data/local/tmp/luckys"
    "/data/local/tmp/mount_mark"
    "/data/local/tmp/mount_mask"
    "/data/local/tmp/mount_namespace"
    "/data/local/tmp/resetprop"
    "/data/local/tmp/scriptTMP"
    "/data/local/tmp/simpleHook"
    "/data/local/tmp/yshell"
    "/data/local/MIO"
    "/data/local/luckys"
    "/data/local/stryker/"
    "/storage/emulated/0/Android/Clash/"
    "/storage/emulated/0/Android/Yume-Yunyun/"
    "/storage/emulated/0/Android/naki/"
    "/storage/emulated/0/Documents/advanced/"
    "/storage/emulated/0/Download/advanced/"
    "/data/DNA"
    "/data/encore/custom_default_cpu_gov"
    "/data/encore/default_cpu_gov"
    "/data/gpu_freq_table.conf"
    "/data/swap_config.conf"
    "/storage/emulated/elgg/"
    "/storage/emulated/legacy/"
)
rm -rf "$clear"
ehco "残留清理完成"
}

shamiko() {
if [ -f "/data/adb/shamiko/whitelist" ]; then rm -f "/data/adb/shamiko/whitelist"; else touch "/data/adb/shamiko/whitelist"; fi
echo "模式切换完成"
}

net_keybox() {
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
}

lsp() {
API=$(getprop ro.build.version.sdk)
if [ "$API" -ge 29 ]; then
  am broadcast -a android.telephony.action.SECRET_CODE -d android_secret_code://5776733 android
else
  am broadcast -a android.provider.Telephony.SECRET_CODE -d android_secret_code://5776733 android
fi
}

boot() {
if [ `whoami` = "root" ]; then
echo "请确保您手机系统中含有magiskboot指令集"
echo "确保本目录下只有一个zip后缀的ak3压缩文件"
echo "及一个img后缀的boot镜像文件"
find . -maxdepth 1 -type f -name "*.zip" -print0 | while IFS= read -r -d '' zipfile; do
    echo "开始处理: $zipfile"
    
    if unzip -q -o "$zipfile" Image >/dev/null 2>&1; then
        echo "成功从AK3中提取Image文件"
        
        mv -f Image kernel
        echo "已将Image文件重命名为kernel"
    else
        echo "在$zipfile中未找到Image文件"
    fi
    echo "开始修补boot"
    echo "------------------------"
    find . -maxdepth 1 -type f -name "*.img" -exec mv -f {} boot.img \;
    magiskboot repack boot.img
    echo "------------------------"
done

sleep 1
echo "操作已完成"
echo "此脚本只用于修补boot请勿修补其他镜像"
rm -rf kernel
else
  echo "使用root权限执行"
  exit
fi
}

gzip() {
echo "请输入自解压脚本的完整路径："
read script_file

if [ ! -f "$script_file" ]; then
  echo "文件不存在，请检查路径是否正确"
  exit 1
fi

max_lines=$(wc -l < "$script_file")

found=0
skip=0

while [ $skip -lt $max_lines ]; do
  tail -n +$((skip + 1)) "$script_file" | gzip -d > ./payload 2>/dev/null
  if [ $? -eq 0 ]; then
    found=1
    echo "成功从第 $((skip + 1)) 行开始解压"
    break
  fi
  skip=$((skip + 1))
done

if [ $found -eq 0 ]; then
  echo "未找到有效的 gzip 压缩数据起始行"
  exit 1
fi

file_type=$(file -b ./payload)
echo "解压后的内容类型：$file_type"

case "$file_type" in
  *ASCII*)
    echo "前 10 行内容："
    head -n 10 ./payload
    ;;
esac

echo "破解后的文件已保存至当前目录：./payload"
}

bzip() {
echo "请输入包含数据的文件路径："
read filepath

if [ -z "$filepath" ]; then
  echo "路径不能为空"
  exit 1
fi

start_line=$(grep -n '^BZh' "$filepath" | head -n 1 | cut -d: -f1)

if [ -z "$start_line" ]; then
  echo "找不到bzip2数据开始标记 BZh"
  exit 1
fi

output_file="${filepath}.decoded"
sed -n "${start_line},\$p" "$filepath" | bunzip2 > "$output_file"

if [ $? -eq 0 ]; then
  echo "解压成功，输出文件：$output_file"
else
  echo "解压失败"
fi
}

star() {
# Author: DouZhe
# Description: Set the StarRail frame rate to 120Hz

if [ "$(id -u)" != "0" ]; then
    echo -e "\033[41;37m您需要root权限才能运行此脚本\033[0m"
    exit 1
fi

if grep -q "3A60" /data/data/com.miHoYo.hkrpg/shared_prefs/com.miHoYo.hkrpg.v2.playerprefs.xml; then
    sed -i 's/3A60/3A120/g' /data/data/com.miHoYo.hkrpg/shared_prefs/com.miHoYo.hkrpg.v2.playerprefs.xml
    chattr +i /data/data/com.miHoYo.hkrpg/shared_prefs/com.miHoYo.hkrpg.v2.playerprefs.xml
    echo -e "\033[42;30m修改帧率成功\033[0m"
    echo -e "\033[41;37m需要重启游戏才能生效\033[0m"
    elif grep -q "3A120" /data/data/com.miHoYo.hkrpg/shared_prefs/com.miHoYo.hkrpg.v2.playerprefs.xml; then
        chattr -i /data/data/com.miHoYo.hkrpg/shared_prefs/com.miHoYo.hkrpg.v2.playerprefs.xml
        sed -i 's/3A120/3A60/g' /data/data/com.miHoYo.hkrpg/shared_prefs/com.miHoYo.hkrpg.v2.playerprefs.xml
        echo -e "\033[42;30m已恢复帧率\033[0m"
        echo -e "\033[41;37m需要重启游戏才能生效\033[0m"
else
    echo "\033[41;37m失败:请先手动将游戏帧率设置为60hz\033[0m"
fi
}

hidecount() {
echo "请输入找到隐藏应用的数量："
read x

echo "计算结果:"
# 使用用户输入的x值进行计算
echo $(( $(stat -c '%h' /data/app) - x ))
}



while true
do
    echo "-------------------"
    echo "请输入前方数字或字母以执行对应脚本"
    echo "1.HideOne123更新脚本"
    echo "2.devcheck"
    echo "3.sdk接口失效恢复+SELinux设置严格"
    echo "4.恢复VoldApp数据隔离状态且删除其持久性属性残留"
    echo "5.小米无需插卡打开usb安全设置"
    echo "6.解决lq找到刷机调试痕迹"
    echo "7.清理恶意软件残留"
    echo "8.shamiko黑白名单切换"
    echo "9.获取可用三绿keybox  需科学上网"
    echo "a.打开lsp"
    echo "b.修补当前目录ak3与boot文件(小白勿用)"
    echo "c.解密gzip加密的sh脚本"
    echo "d.解密bzip加密的sh脚本"
    echo "e.崩铁解锁120hz刷新率"
    echo "f.跳转本人coolapk主页"
    echo "g.春秋隐藏计算"
    echo ""
    echo "输入 q/Q 即可退出脚本喵~"
    read choice

    case "$choice" in
        1)
            {
                clear
                HideOne123
            }
            ;;
        2)
            {
                clear
                devcheck
            }
            ;;
        3)
            {
                clear
                sdk
            }
            ;;
        4)
            {
                clear
                VoldApp
            }
            ;;
        5)
            {
                clear
                xmusb
            }
            ;;
        6)
            {
                clear
                lqusb
            }
            ;;
        7)
            {
                clear
                ql
            }
            ;;
        8)
            {
                clear
                shamiko
            }
            ;;
        9)
            {
                clear
                net_keybox
            }
            ;;
        a)
            {
                clear
                lsp
            }
            ;;
        b)
            {
                clear
                boot
            }
            ;;
        c)
            {
                clear
                gzip
            }
            ;;
        d)
            {
                clear
                bzip
            }
            ;;
        e)
            {
                clear
                star
            }
            ;;
        f)
            {
                clear
                am start --windowingMode 5 -n com.coolapk.market/.view.userv9.UserSpaceV9Activity --es key_uid 4061907
            }
            ;;
        g)
            {
                clear
                hidecount
            }
            ;;
        q|Q)
            echo "- 喵~脚本结束了喵~ฅ^•ﻌ•^ฅ"
            oneword
            print_lovely
            break
            ;;
        *)
            echo "- 喵呜~无效输入，请输入 1、2、3或 q/Q 退出哦~"
            ;;
    esac
    echo "" # 空行分隔方便阅读喵~
    sleep 5
done
