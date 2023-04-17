#!/bin/bash
#设定标准答案  $RANDOM%100  0-99  再加1  就是1-100
num=$[RANDOM%100+1]
#客户进行猜，设定客户所猜的变量，将整体猜的结果放到死循环当中，直至猜到正确结果为止
while :
do
  echo $num
  read -p "xin xiang:" cai
  if [ $cai -lt $num ]
  then
    echo "you guest jieguo  dile;;;"
    continue
  elif [ $cai -gt $num ]
  then
    echo "you guest jieguo gaole;;;"
    continue
  else

     echo "congratuations,,,you are ok!!!"
     echo $num
     exit 0
  fi
done
