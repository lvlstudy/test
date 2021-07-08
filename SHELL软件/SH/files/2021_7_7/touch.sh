#!/bin/bash
time=$(date +%F)
directory=/tmp/$time
if [ ! -d $directory ]; then
  mkdir $directory
else
  echo "该目录已存在，跳过"
fi


touch1=1
touch2=2
touch3=3
if [ ! -f $directory/$touch1 ]; then
  touch $directory/$touch1
else
  echo "1文件已存在，跳过"
fi
if [ ! -f $directory/$touch2 ]; then
  touch $directory/$touch2
else
  echo "2文件已存在，跳过"
fi
if [ ! -f $directory/$touch3 ]; then
  touch $directory/$touch3
else
  echo "3文件已存在，跳过"
fi 
