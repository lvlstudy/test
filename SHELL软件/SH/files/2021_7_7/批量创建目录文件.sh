#!/bin/bash
#利用查询时间的命令和for命令实现批量创建目录和文件
time=$(date +%F)
directory=/tmp/$time
if [ ! -d $directory ];then
  mkdir $directory
else9
  echo "该$directory目录已存在，跳过"
fi
for files in {1..3}_$time
do
  if [ ! -f $directory/$files ];then
    touch $directory/$files
  else
    echo "该$files文件已存在，跳过"
fi
done

