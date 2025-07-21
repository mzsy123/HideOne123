#!/system/bin/sh

# 路径定义
TARGET_FILE="/data/adb/tricky_store/target.txt"
WHITELIST_FILE="/data/adb/modules/HideOne/package/whitelist.txt"  # 白名单（不包含）
OTHER_FILE="/data/adb/modules/HideOne/package/other.txt"          # 额外添加的包名

# 临时文件（用于中间处理）
TMP_ALL="/data/adb/modules/HideOne/tmp/tmp_pkgs.txt"

# 1. 获取第三方应用包名（去除package:前缀）
pm list packages -3 | sed 's/package://g' > "$TMP_ALL"

# 2. 过滤白名单（若白名单存在，排除其中的包名）
if [ -f "$WHITELIST_FILE" ]; then
    # 排除白名单中的包名（整行精确匹配）
    grep -Fxv -f "$WHITELIST_FILE" "$TMP_ALL" > "$TMP_ALL.tmp" && mv "$TMP_ALL.tmp" "$TMP_ALL"
fi

# 3. 添加额外包名（若other.txt存在，追加其中的有效包名）
if [ -f "$OTHER_FILE" ]; then
    # 读取非空行、非注释行（忽略#开头的行），追加到列表
    grep -v '^#\|^$' "$OTHER_FILE" >> "$TMP_ALL"
fi

# 4. 去重并写入最终目标文件
sort -u "$TMP_ALL" > "$TARGET_FILE"

# 清理临时文件
rm -f "$TMP_ALL" "$TMP_ALL.tmp"
