脚本编写学习记录
zookeeper 群启脚本的编写
#!/bin/bash
#参数传递
usage="Usage: $0 (start|stop|status)"
if [ $# -lt 1 ]; then
  echo $usage
  exit 1
fi
behave=$1
echo "$behave zkServer cluster"
#主机名称
for i in 04 05 06
do
#使用ssh进行启动
ssh server$i "/home/yang/server/zookeeper-3.4.9/bin/zkServer.sh $behave"
done
exit 0
#####
  $0 代表的是执行的文件本身的名称
  $# 传递给脚本的参数的个数
  $? 显示最后的命令的的退出状态码,0表示没有错误, 其它数字有错误
  $$ 脚本运行的当前的id号
  $! 后台运行的最后一个进程的id号
  $* 以一个单字符串显示向脚本传递的所有参数
#####
