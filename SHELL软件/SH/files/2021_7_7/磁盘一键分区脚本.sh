#shell脚本自动分区

#1.添加1块磁盘，大小为50G
#2.将50G的磁盘分成2个主分区，大小分别为30G和20G
#30G----》/movie-----》xfs
#20G—》/photo----》xfs
#3.实现2个分区开机自动挂载
#使用fdisk

#!/bin/bash

#判断磁盘是否已经进行了分区
if  (( $(fdisk -l /dev/sde|grep "^/dev/sde"|wc -l) > 0  ))
then
	echo "这块磁盘已经分区，退出，请管理员检查"
	exit  #退出脚本，后面的命令不再执行
fi


#第1步：磁盘分区
#使用fdisk交互式方式创建分区，使用here document方式，解决交互式传递参数的问题
fdisk /dev/sde <<EOF
p
n
1
2048
+30G
p
n
2
62916608
+20G
p
w
EOF
echo "##############分区完成#######################"
fdisk -l /dev/sde
echo "##############################################"

#第2步：格式化
#mkfs.xfs /dev/sde1
#mkfs.xfs /dev/sde2
for  i in $(ls /dev/sde?)
do
	mkfs.xfs $i
done

#第3步：挂载
#判断挂载点是否存在，如果不存在就新建
[ -d /movie ] || mkdir /movie
mkdir -p /photo

mount  /dev/sde1   /movie
mount /dev/sde2  /photo

#第4步：实现开机自动挂载
#添加到/etc/fstab

echo  "dev/sde1   /movie  xfs  defaults  0 0 "  >>/etc/fstab
echo  "dev/sde2   /photo  xfs  defaults  0 0 "  >>/etc/fstab

#使用parted

#!/bin/bash

#判断磁盘是否已经进行了分区
#if  (( $(fdisk -l /dev/sde|grep "^/dev/sde"|wc -l) > 0  ))
#then
#	echo "这块磁盘已经分区，退出，请管理员检查"
#	exit  #退出脚本，后面的命令不再执行
#else
#	echo "开始进行分区操作"
#	sleep 3
#fi


#第1步：磁盘分区
#使用parted分区

#parted /dev/sde mkpart moive  1 30000
#parted /dev/sde mkpart moive  30001 53000

#echo "##############分区完成#######################"
#parted /dev/sde print
#echo "##############################################"

#第2步：格式化
#mkfs.xfs /dev/sde1
#mkfs.xfs /dev/sde2
#for  i in $(ls /dev/sde?)
#do
#	mkfs.xfs $i
#done

#第3步：挂载
#判断挂载点是否存在，如果不存在就新建
#[ -d /movie ] || mkdir /movie
#mkdir -p /photo

#mount  /dev/sde1   /movie
#mount /dev/sde2  /photo

#第4步：实现开机自动挂载
#添加到/etc/fstab

#echo  "dev/sde1   /movie  xfs  defaults  0 0 "  >>/etc/fstab
#echo  "dev/sde2   /photo  xfs  defaults  0 0 "  >>/etc/fstab
#————————————————
#版权声明：本文为CSDN博主「Dooriyayu」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
#原文链接：https://blog.csdn.net/qq_45745649/article/details/104702066
