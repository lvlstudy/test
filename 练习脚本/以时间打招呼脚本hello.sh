#!/bin/bash
#以时间作为变量,通过判断变量获取时间提示语
tm=$(date +%H)
if [ $tm -lt 12 ];then
  msg="Good Morning"
elif [ $tm -ge 12 -a $tm -lt 18 ];then
  msg="Good Afternoon"
else
  msg="Good Night $USER"
fi
echo "checktime is `date +%Y-%m-%d-%H:%M:%S`"
echo -e " hello, \033[31m$msg\033[0m , $USER"
