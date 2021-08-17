#!/bin/bash
#循环读取文件内容for与while之间的区别在哪
while read line
do
  echo $line
  ping -c 2 $line >>/dev/null
  if [ $? = 0 ];then
     echo "$line is up" >>ping_ok.log
   else
      echo "$line is down" >>ping_error.log
   fi
#while使用输入重定向以保证从文件中读取数据
done < name.txt


for x in  $(<name.txt) 
do
  echo $x
done



for x in `cat name.txt`
do
  echo $x
done
