#!/bin/bash
##计算偶数之和：
#1~使用seq计算偶之和
sum=0
 for val in ` seq 0 2 100 `
do
    sum=$[ $sum + $val ]
done
echo " 100以内偶数的和为:$sum "


#2~使用for循环计算偶之和：
x=0
y=0
for i in {1..100}
do
  if [ $[$i%2] -eq  0 ]
  then
     x=$(($x+$i))
  else
     y=$[$y+$i]
  fi
done
echo "100以内的偶数之和是$x"
echo "100以内的奇数之和是$y"

#3~使用for循环计算奇偶数之和
g=0
for f in {1..100}
do        
       if [ $[$f%2] -eq 0 ]
       then
           g=$[$f+$g]
          f=$[$f+1]
      fi
done
echo "偶数之和是$g"

#4~使用while循环计算偶数之和：
u=1
v=0
while [ $u -le 100 ]
do
   if [ $[$u%2] -eq 0 ]
   then 
     v=$[$v+$u]
   fi
     u=$[$u+1]     
   
done
echo $v


##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

##计算奇数之和：
a=o
for b in $(seq 1 2 100)
do
   a=$[$a+$b]
done
echo "1+.....+99的奇数和是$a"




b=0
for a in {1..100}
do
   if [ $[$a%2] != 0 ]
   then
     b=$[$b+$a]
     a=$[$a+1]
   fi
done
echo "$b"





y=0
x=0
while [ $x -le 100 ]
do
   if [ $[$x%2] != 0 ]
   then 
     y=$[$x+$y]
   fi
     x=$[$x+1]     
   


done
echo  "$y"










