#!/system/bin/sh
# MD5验证函数：参数1=文件路径，参数2=预期MD5的base64编码，参数3=验证序号
verify_md5() {
    local file_path="$1"
    local expected_md5_b64="$2"
    local index="$3"
    
    # 计算文件实际MD5（提取哈希部分）
    local actual_md5=$(md5sum "$file_path" | cut -d' ' -f1)
    # 解码预期MD5（base64转明文）
    local expected_md5=$(echo "$expected_md5_b64" | base64 -d)
    
    # 对比验证
    if [ "$actual_md5" == "$expected_md5" ]; then
        echo "*$index MD5验证通过"
    else
        echo "【总体验证失败】$index MD5不匹配"
        exit 1  # 验证失败立即退出
    fi
}

# 模块安装函数：参数1=模块文件路径，参数2=模块名称，参数3=安装命令（ksud/apd/magisk）
install_module() {
    local module_path="$1"
    local module_name="$2"
    local install_cmd="$3"
    
    echo "- 正在刷入[$module_name]"
    echo "*********************************************"
    # 根据安装命令类型适配执行格式（核心修复点）
    if [ "$install_cmd" = "magisk --install-module" ]; then
        # Magisk命令格式：直接执行安装命令+路径
        $install_cmd "$module_path"
    else
        # KSUD/APatch命令格式：命令+module install+路径
        $install_cmd module install "$module_path"
    fi
}

# 设置权限（递归设置MODPATH目录权限）
set_perm_recursive "$MODPATH" 0 0 0755 0755
echo "*********************************************"
sleep 2

# MD5验证（调用复用函数，避免重复代码）
verify_md5 "$MODPATH/mzsy/1.zip" "Mjc5MzE3YzA5NTFhYTY3Mzk0ZGVjOTAzN2M0ZDhiMzU=" "①"
verify_md5 "$MODPATH/mzsy/2.zip" "OTRjNTg1ZmJhOGQ5ZTljOTVhNDljMTgwMjdhNTQzZjk=" "②"
verify_md5 "$MODPATH/package/pa.sh" "Y2ViNDk4ZGExZTM0NThjMDJjN2Q3MGMyYzM2YTY1YmM=" "③"
verify_md5 "$MODPATH/mzsy/4.zip" "ZTk1MDMxNGRmZTBkZGRkOGZkMTUxNjYyZTIyNDYyNzU=" "④"
verify_md5 "$MODPATH/mzsy/5.zip" "OTkzZDBlOWQ3NTU5YjNlYjNlMDY0MTE5OTkwYjUzZDk=" "⑤"
verify_md5 "$MODPATH/mzsy/6.zip" "Zjc5Y2UyYzdkYzAzNDM5NjQ1ZjA3ZTlhMmNkY2IwZWU=" "⑥"
verify_md5 "$MODPATH/mzsy/8.zip" "ZWJkYjk1NTU2OTgyY2MzMWI0MDE4YjNkYTE1M2YzZTA=" "⑦"
verify_md5 "$MODPATH/mzsy/3.zip" "NjYzMDE5ZGI4YWU2ZDYxODAwNzc2YzRiNjhmMWE2M2M=" "⑧"
verify_md5 "$MODPATH/mzsy/9.zip" "MjFlZmExZjY0ZjkwZGE4ZjlhNzI2NzQ5Mjk2MTFmZjA=" "⑨"
verify_md5 "$MODPATH/mzsy/7.zip" "OWQzNGQ0NzBjZGI0ZTkzNjRjZjBlYmVmZmZjZTZlMTM=" "⑩"
echo "【总体验证通过】所有模块MD5匹配-开始执行刷入"
echo "*********************************************"

# ==============================================
# 模块安装逻辑（按环境区分，复用安装函数）
# ==============================================
# 1. KernelSU环境
# 旧版逻辑
# if [[ "$KSU" == "true" ]]; then
# # if [[ "$KSU_SUKISU" == "true" ]]; then   13246新特性
    # ui_print "- KernelSU 用户空间版本: $KSU_VER_CODE"
    # ui_print "- KernelSU 内核空间版本: $KSU_KERNEL_VER_CODE"
    # # 检测KSU相关管理器，决定是否安装3.zip
    # if pm list packages | grep -q "com.rifsxd.ksunext"; then
        # ui_print "- 检测到Ksu Next"
        # install_module "$MODPATH/mzsy/3.zip" "ksu_module_susfs_1.5.2+R19.zip" "ksud"
    # elif pm list packages | grep -q "com.sukisu.ultra"; then
        # if [ "$KSU_VER_CODE" -gt 13200 ]; then
        # ui_print "- 检测到SukiSU Ultra版本高于13200，跳过susfs管理模块刷入"
        # else
        # ui_print "- 检测到SukiSU Ultra版本低于13200，建议更新版本以管理susfs或刷入susfs管理模块"
        # fi
    # fi

if [[ "$KSU" == "true" ]]; then
    ui_print "- KernelSU 用户空间版本: $KSU_VER_CODE"
    ui_print "- KernelSU 内核空间版本: $KSU_KERNEL_VER_CODE"
    if [[ "$KSU_SUKISU" == "true" ]]; then
        if [ "$KSU_VER_CODE" -gt 13200 ]; then
            ui_print "- 检测到SukiSU Ultra版本高于13200，跳过susfs管理模块刷入"
        else
            ui_print "- 检测到SukiSU Ultra版本低于13200，建议更新版本以管理susfs或刷入susfs管理模块"
        fi
    else
        if pm list packages | grep -q "com.rifsxd.ksunext"; then
            ui_print "- 检测到Ksu Next"
            install_module "$MODPATH/mzsy/3.zip" "ksu_module_susfs_1.5.2+R19.zip" "ksud"
        else
            ui_print "- 你不会还在用官方版ksu吧?"
        fi
    fi
    sleep 2
    # 通用模块安装（复用函数，统一传入安装命令"ksud"）
    install_module "$MODPATH/mzsy/2.zip" "Tricky-Store-v1.3.0-180-8acfa57-release.zip" "ksud"
    sleep 1
    install_module "$MODPATH/mzsy/9.zip" "TrickyAddonModule-v4.0.zip" "ksud"
    sleep 1
    install_module "$MODPATH/mzsy/4.zip" "Zygisk-Next-1.2.9.1-534-b8e7e21-release.zip" "ksud"
    sleep 1
    install_module "$MODPATH/mzsy/5.zip" "PlayIntegrityFix_v19.2-TEST.zip" "ksud"
    sleep 1
    install_module "$MODPATH/mzsy/6.zip" "LSPosed-v1.9.2-it-7379-release.zip" "ksud"
    sleep 1

# 2. APatch环境
elif [[ "$APATCH" == "true" ]]; then
    ui_print "- APatch 版本号: $APATCH_VER_CODE"
    ui_print "- APatch 版本名: $APATCH_VER"
    ui_print "- KernelPatch 用户空间版本: $KERNELPATCH_VERSION"
    ui_print "- KernelPatch 内核空间版本: $KERNEL_VERSION"
    ui_print "*********************************************"
    
    # 通用模块安装（复用函数，传入安装命令"apd"）
    install_module "$MODPATH/mzsy/7.zip" "Nohello_53.zip" "apd"
    sleep 1
    install_module "$MODPATH/mzsy/2.zip" "Tricky-Store-v1.3.0-180-8acfa57-release.zip" "apd"
    sleep 1
    install_module "$MODPATH/mzsy/9.zip" "TrickyAddonModule-v4.0.zip" "apd"
    sleep 1
    install_module "$MODPATH/mzsy/4.zip" "Zygisk-Next-1.2.9.1-534-b8e7e21-release.zip" "apd"
    sleep 1
    install_module "$MODPATH/mzsy/5.zip" "PlayIntegrityFix_v19.2-TEST.zip" "apd"
    sleep 1
    install_module "$MODPATH/mzsy/6.zip" "LSPosed-v1.9.2-it-7379-release.zip" "apd"
    sleep 1
    
    # APatch专属：移动kpm模块到Download
    ui_print "- 正在移动APatch专属kpm隐藏模块"
    mv -f "$MODPATH/mzsy/nohello.kpm" "/sdcard/Download"
    mv -f "$MODPATH/mzsy/Cherish Peekaboo_1.5.5.kpm" "/sdcard/Download"
    ui_print "- 模块已移动至/sdcard/Download"
    ui_print "- 请在APatch管理器中'嵌入'kpm模块（请勿点击'修补'）"
    ui_print "*********************************************"

# 3. Magisk环境（默认环境）
else
    ui_print "- Magisk 版本: $MAGISK_VER_CODE"
    
    # 安装Shamiko模块（调用修复后的安装函数）
    install_module "$MODPATH/mzsy/1.zip" "Shamiko-v1.2.5-414-release.zip" "magisk --install-module"
    echo "- 正在为shamiko添加切换按钮"# v2.4尝试添加
    echo "*********************************************"
    unzip -jo "$ZIPFILE" 'mzsy/shamiko.sh' -d /data/local/tmp &>/dev/null
    mv -f "/data/local/tmp/shamiko.sh" "/data/adb/modules/zygisk_shamiko/action.sh"
    rm -f /data/local/tmp/shamiko.sh
    sleep 1
    
    # 通用模块安装（复用函数，传入正确的Magisk安装命令）
    install_module "$MODPATH/mzsy/2.zip" "Tricky-Store-v1.3.0-180-8acfa57-release.zip" "magisk --install-module"
    sleep 1
    install_module "$MODPATH/mzsy/9.zip" "TrickyAddonModule-v4.0.zip" "magisk --install-module"
    sleep 1
    install_module "$MODPATH/mzsy/4.zip" "Zygisk-Next-1.2.9.1-534-b8e7e21-release.zip" "magisk --install-module"
    sleep 1
    install_module "$MODPATH/mzsy/5.zip" "PlayIntegrityFix_v19.2-TEST.zip" "magisk --install-module"
    sleep 1
    install_module "$MODPATH/mzsy/6.zip" "LSPosed-v1.9.2-it-7379-release.zip" "magisk --install-module"
    sleep 1
    
    # 设置Shamiko白名单模式
    sleep 1
    echo "- 尝试设置shamiko模块白名单模式"
    echo "*********************************************"
    touch /data/adb/shamiko/whitelist
fi

# ==============================================
# 后续操作（文件移动、APK安装等）（其余逻辑保持不变）
# ==============================================
# 移动keybox.xml到指定目录（更新时间7.23）
echo "- 移动模块内置最新keybox.xml"
echo "*********************************************"
mv -f "$MODPATH/mzsy/keybox.xml" "/data/adb/tricky_store/"

# 安装"隐藏应用列表"HMA
echo "- 安装模块内置'隐藏应用列表'app"
echo "*********************************************"
# 解压APK到临时目录（不保留原目录结构）
unzip -jo "$ZIPFILE" 'mzsy/hma.apk' -d /data/local/tmp &>/dev/null
# 覆盖安装APK
pm install -r /data/local/tmp/hma.apk &>/dev/null
# 检测HMA安装结果
if pm list packages | grep -q "com.tsng.hidemyapplist"; then
    echo "- HMA安装完成"
else
    echo "- HMA安装失败"
fi
# 清理临时文件
rm -f /data/local/tmp/hma.apk

# 移动config.json到Download  v2.4尝试修复
echo "- 移动模块内置config.json"
echo "*********************************************"
unzip -jo "$ZIPFILE" 'mzsy/config.json' -d /data/local/tmp &>/dev/null
mv -f "/data/local/tmp/config.json" "/sdcard/Download"
rm -f /data/local/tmp/config.json

# ==============================================
# 音量键选择：刷入"游戏线程优化"模块（7.zip）
# ==============================================
echo "- 是否刷入'游戏线程优化'模块?"
echo "- 按音量键+刷入"
echo "- 按音量键-跳过"
# 5秒超时检测逻辑
TIMEOUT=5  # 超时时间（秒）
KEY_TIMEOUT=false  # 超时标志
echo "- 5秒后超时将自动跳过..."
start=$(date +%s)  # 记录开始时间
# 循环检测按键或超时
while [ $(( $(date +%s) - start )) -lt $TIMEOUT ]; do
    # 获取音量键输入（兼容不同设备的输入检测）
    key=$(dumpsys input 2>/dev/null | awk '/KEY_VOLUME/{print $2;exit}')
    [ -z "$key" ] && key=$(getevent -qlc 1 2>/dev/null | awk '{print $3}' | grep 'KEY_' | head -n1)
    
    # 检测到音量+，刷入模块
    if [ "$key" = "KEY_VOLUMEUP" ]; then
        # 根据环境选择安装命令
        if [[ "$KSU" == "true" ]]; then
            ksud module install "$MODPATH/mzsy/8.zip"
        elif [[ "$APATCH" == "true" ]]; then
            apd module install "$MODPATH/mzsy/8.zip"
        else
            magisk --install-module "$MODPATH/mzsy/8.zip"  # 直接使用正确的Magisk命令
        fi
        echo "- 已刷入'游戏线程优化'模块"
        break
    fi
    sleep 0.2  # 短暂延迟，减少资源占用
done
# 超时未操作，自动跳过
if [ $(( $(date +%s) - start )) -ge $TIMEOUT ]; then
    echo "⏳ 已超时，自动跳过刷入"
fi

# ==============================================
# 完成提示
# ==============================================
echo ""
echo "- 刷入完成😋"
echo "- 隐藏应用列表config.json导入后请自行清除残留"
echo "- PIF模块需手动执行(需要魔法)"
echo "- Made by MZSY233~"
