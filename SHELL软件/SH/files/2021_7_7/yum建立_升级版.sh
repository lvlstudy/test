#!/bin/bash
#设置主机host 的 name
echo "-------------第一步：设置主机名---------------"
name="h8b"
hostnamectl set-hostname $name
#关闭防火墙与selinux
echo "-------------------第二步：关闭防火墙与selinux---------------"
systemctl  stop firewalld
systemctl disable firewalld
setenforce 0
sed -i "/SELINUX/s/enforcing/disabled/" /etc/selinux/config
#创建挂载点
echo "---------------第三步：创建挂载点目录---------------------"
mkdir /mnt/dvd
#将镜像挂载到目录并且实现开机自启
echo "-----------------第三步：镜像挂载，将目录与镜像联系起来-----------------"
mount=`grep dvd /etc/fstab`
if [ -z "$mount" ]
then
   mount /dev/cdrom /mnt/dvd
   cat >>/etc/fstab <<EOF
/dev/cdrom /mnt/dvd iso9660 defaults 0 0
EOF
   echo -e "\e[0;34m \t初次挂载完成\t\a \e[1m"
else
   echo -e "\e[0;31m 对不起，你的镜像已经挂载，无需再挂 \e[1m"
fi
#建立yum仓库
echo "--------------------第四步：建立yum仓库-----------------------"
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
    echo -e "\e[0;34m \t初次仓库完成\t\a \e[1m"
else
    echo -e "\e[0;31m 对不起，你的镜像文件已存在，无需再创建 \e[1m"
fi
#查看yum仓库建设情况
echo "--------------第五步：查看仓库建立情况------------------"
yum makecache
num=`yum repolist |grep -w  0`
if [ "$num" != 0 ]
then
    echo "yum仓库建立成功"
else
    echo -e "\e[0;31m yum仓库建立失败 \e[1m"
fi



