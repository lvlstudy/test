#!/bin/bash
#创建新用户进行日常管理
#root 0 root 0  系统默认群组 系统默认gid组 /root  默认shell
#osmgr 1800 osmgr 1800 无   无 /home/osmgr /bin/bash
#dutyview 5000 xtjgmons 5000 无 无 /home/dutyview /bin/bash
#dutywath 5001 xtjgmons 5000 无 无 /home/dutywath /bin/bash
#toptea 1302 bomc 1302 无 无 /toptea /bin/bash
useradd -u 1800  osmgr
groupadd -g 5000 xtjgmons
useradd -u 5000 -g xtjgmons dutyview
useradd -u 5001 -g xtjgmons dutywath
groupadd -g 1302 bomc
useradd -u 1302 -d /toptea -g bomc toptea


#设置用户相应的权限
dutyview_permit=`grep "dutyview ALL=(ALL) NOPASSWD: /usr/sbin/*,/usr/bin/*,!/usr/sbin/su" /etc/suders`
dutywath_permit=`grep "dutyview ALL=(ALL) NOPASSWD: /usr/sbin/*,/usr/bin/*,!/usr/sbin/su" /etc/sudoers`
default=`grep "Defaults logfile=/var/log/sudo.log" /etc/sudoers`
if [ -z "$dutyview" ]
then
   echo "dutyview ALL=(ALL) NOPASSWD: /usr/sbin/*,/usr/bin/*,!/usr/sbin/su" >>/etc/sudoers
fi
if [ -z "$dutywath" ]
then
   echo "dutywath ALL=(ALL) NOPASSWD: /usr/sbin/*,/usr/bin/*,!/usr/sbin/su" >>/etc/sudoers
fi
if [ -z "$default" ]
then
   echo "Defaults logfile=/var/log/sudo.log">>/etc/sudoers
fi
