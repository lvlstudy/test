#!/bin/bash
#配置最大打开文件数，最大打开进程数，最大core文件数
#统一配置文件/etc/security/limits.conf
#命令ulimit -n(Hn)可查看最大打开文件数
#命令ulimit -u(Hu)可查看最大打开用户进程数
#命令ulimit -c(Hu)可查看core dump文件，系统默认为0
echo "---------------配置最大打开文件数------------------"
grep "* - nofile 102400" /etc/security/limits.conf
if [ $? != 0 ]
then
   cat >>/etc/security/limits.conf <<EOF
* - nofile 102400
EOF
fi


echo "---------------配置最大打开进程数--------------------"
grep " * - nproc 10240" /etc/security/limits.conf
if [ $? != 0 ]
then
   cat >>/etc/security/limits.conf <<EOF
* - nproc 10240
EOF
fi


echo "--------------配置最大core dump文件数"
grep "* - core" /etc/security/limits.conf
if [ $? != 0 ]
then
   cat >>/etc/security/limits.conf <<EOF

* - core 1048576
EOF
fi
