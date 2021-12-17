#!/bin/bash
if [ $# -eq 1 ];then
  if [ -f $1 ];then
    while read line
      do
       	 result=$(ping -c 5 $line |grep "100% packet loss")
	   if [ -z "$result" ];then
	     echo -e "$line\tOk" >>ping.log
             echo -e "$line\tOk"
	   else
	     echo -e "$line\tError" >>ping.log
             echo -e "$line\tError"
           fi
      done < "$1"
  else
    echo "我的文件不存在"
	exit 1
  fi 
else
  echo "usage: sh ping.sh ip_hosts"
  exit 2
fi
 
	
