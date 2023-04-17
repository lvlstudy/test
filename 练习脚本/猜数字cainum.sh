#!/bin/bash
num=$[RANDOM%100+1]
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
