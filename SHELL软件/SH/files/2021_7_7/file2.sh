#!/bin/bash
time=$(date +%F)
directory=/tmp/$time
if [ ! -d $directory ];then
    mkdir $directory
else
    echo "该时间目录已存在，忽略！！"
fi
touch1=1.shell
touch2=2.shell
touch3=3.shell
if [ ! -f $directory/$touch2 ];then
    touch $directory/$touch2
else
    echo "该文件2.shell已存在，忽略！！"
fi


