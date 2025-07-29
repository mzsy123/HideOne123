# （可根据需要修改数值）
x=找到隐藏应用数量

echo "计算结果:"
# 计算并输出结果
echo $(( $(stat -c '%h' /data/app) - x ))
