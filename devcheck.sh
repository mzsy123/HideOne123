print_line() {
  echo ""
}
clear
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