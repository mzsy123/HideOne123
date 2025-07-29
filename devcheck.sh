echo "vendor 补丁版本:"
getprop ro.vendor.build.security_patch
echo "系统/boot 补丁版本:"
getprop ro.build.version.security_patch
echo "verifiedBootHash(boot哈西值):"
getprop ro.boot.vbmeta.digest
echo "内核名称"
uname -s
echo "内核版本号"
uname -r
echo "内核构建时间"
uname -v
echo "内核全部信息"
uname -a

# 去掉下方注释可临时设置属性，值填双引号里面Test
# setprop ro.vendor.build.security_patch ""
# setprop ro.build.version.security_patch ""
# setprop ro.boot.vbmeta.digest ""
