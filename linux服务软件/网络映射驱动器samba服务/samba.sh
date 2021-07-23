#!/bin/bash
#创建samba服务器;实现linux和windows之间通过网络进行资源共享
yum -y install samba samba-client.x86_64
systemctl enable smb --now
useradd office
mkdir /tmp/office
chmod 2770 /tmp/office #2的话具有继承关系
chown -R office.office /tmp/office
office=$(grep office /etc/samba/smb.conf)
if [ -z "$office" ]
then
   echo "[share-office]
   comment = office
   path = /tmp/office
   browseable = yes
   writable = yes
   file mode = 660
   force file mode = 660
   directory mode = 770
   force directory mode = 770" >> /etc/samba/smb.conf
fi
systemctl restart smb.service
smbpasswd -a office
#下一步可以进入windows进行测试看是否有用
#打开我的电脑，点开映射网络驱动器
#\\192.168.224.101\share-office
#在我的电脑里创建个测试文件夹，helloword.txt文档
#回到Linux终端会发现Windows所创建的目录与文档

