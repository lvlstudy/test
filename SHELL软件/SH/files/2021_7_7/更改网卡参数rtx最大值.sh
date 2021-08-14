#!/bin/bash
#设置网卡接收数值的大小，以便提高网卡的性能
#命令ethtool -g xxx 查询网卡的预设最大值为多少，以及当前的值为多少
#ethtool -G xxx rx xxx修改rx值为多少
#ethtool -G xxx tx xxx 修改tx值为多少
echo "----------------查询rtx最大值是否有设置过----------------"
#先设置变量，为下面判断做准备
echo "#######先设置变量#########"
rx_max=$(ethtool -g eth0 |awk "NR==8"|grep -w 4096)
#开始进行条件判断
echo "###########再进行条件判断##########"
if [ "$rx_max" != 4096 ]
then
   ethtool -G eth0 rx 4096
fi
if [ $? != 0 ]
then
   echo  -e "\e[0;31m 该网卡接收最大值rx_max已被更改过，请忽略！！！ \e[1m"
   echo -e "\e[0;39m 4096值已经存在，不用更改了 \e[1m"
   echo "不错，网卡参数更改的完美至极，无与伦比！！！！"
fi
tx_max=`ethtool -g eth0 |awk "NR==11"|grep -w 4096`
if [ "$tx_max" != 4096 ]
then
   ethtool -G eth0 tx 4096
fi
if [ $? != 0  ]
then
   echo  -e "\e[0;31m 该网卡传送最大值tx_max已被更改过，请忽略！！！ \e[1m"
   echo -e "\e[0;39m 4096值已经存在，不用更改了 \e[1m"
   echo "不错，网卡参数更改的完美至极，无与伦比！！！！"
fi
minlin1=`grep "ethtool -G eth0 rx 4096" /etc/rc.local`
minlin2=`grep "ethtool -G eth0 tx 4096" /etc/rc.local`

if [  -z "$minlin1"  ]
then
   echo "ethtool -G eth0 rx 4096" >>/etc/rc.local
fi
if [  -z "$minlin2"  ]
then
   echo "ethtool -G eth0 tx 4096" >>/etc/rc.local
fi
chmod +x /etc/rc.local







