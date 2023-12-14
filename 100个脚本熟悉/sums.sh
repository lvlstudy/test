#!/bin/bash
#使用while计算100以内的和
a=0
b=0
while [ $a -le 100 ]
do
   b=$[$a+$b]
   a=$[$a+1]
done
echo "1+.....+100的和是$b"

##使用for循环计算100以内的和
y=0
for x in {1..100}
do
  y=$[$y+$x]
done
echo "1+....+100的和是$y"
