第一个脚本
#!/bin/bash
#大文件所在位置
maxfile=/tmp/test.cst
#大文件的极限值，超过极限值，则会做清空文件处理，下面的极限值是1G
maxsize=$((1*1024*1024))
#大文件的实际大小，使用awk进行获取值
file_truesize=$(du -s $maxfile | awk '{print $1}')
#使用if条件判断，符合条件清空文件
if [ ${file_truesize} -gt $maxsize ]
then
   echo "$maxfile大小尺寸为`du -sh $maxfile |awk '{print $1}'`"
   echo " " >$maxfile
   echo "清空文件成功，大文件清理完成"
else
   echo "$maxfile大小尺寸为`du -m $maxfile |awk '{print $1"M"}'`"
   echo "无需清空文件，文件大小不大"  
fi
##########################################################################################################################
第二个脚本
#!/bin/bash
PWD=/tmp/jiaoben
file=rumenz.img
Sourcefile=$PWD/$file
Num=`du -s $Sourcefile|awk '{print $1}'`
Size=`echo $((2*1000*1000))`
if [ -e "$Sourcefile" ] &&  [ $Num -ge $Size ]
then
  echo " " > $Sourcefile 
elif [ ! -e "$Sourcefile" ]
then
    echo "$Sourcefile not exist"
else
  echo "$Sourcefile'file size ok"
fi


  
