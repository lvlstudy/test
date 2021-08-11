#!/bin/bash
#设置主机名host 的 name
name="h8a"
hostnamectl set-hostname $name
#关闭防火墙与selinux
systemctl  stop firewalld
systemctl disable firewalld
setenforce 0
sed -i "/SELINUX/s/enforcing/disabled/" /etc/selinux/config
#创建挂载点
mkdir /mnt/dvd
#将镜像挂载到目录并且实现开机自启
mount=`grep dvd /etc/fstab`
if [ -z "$mount" ]
then
   mount /dev/cdrom /mnt/dvd
   cat >>/etc/fstab <<EOF
/dev/cdrom /mnt/dvd iso9660 defaults 0 0
EOF
else
   echo "对不起，你的镜像已经挂载，无需再挂"
fi
#建立yum仓库
rm -rf /etc/yum.repos.d/*.repo
repo=`ls /etc/yum.repos.d/dvd.repo |wc -l`
if [ $repo == 0 ]
then
   cat  > /etc/yum.repos.d/dvd.repo << EOF
[dvd]
name=dvd
gpgcheck=0
enabled=1
baseurl=file:///mnt/dvd
EOF
else
    echo "对不起，你的镜像文件已存在，无需再创建"
fi
#查看yum仓库建设情况
yum memcache
yum repolist


