#!/bin/bash
pingabc(){
  ping -c3 $1 &>/dev/null 
  if [ $? -eq 0 ];then
    echo "$1 is up" >>y.log
  else
    echo "$1 is donw" >>n.log
  fi
}
for x in {1..254}
do
 pingabc 192.168.8.$x &
done
wait
