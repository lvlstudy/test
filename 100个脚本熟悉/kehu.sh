#!/bin/bash
# 需要指定挂载的目录：mount_dir
# 需要指定 NFS 服务器 ip 地址：nfs_server_ip
# 需要指定 NFS 服务器共享的目录：nfs_server_dir
mount_dir='/mnt/nfs/var/nfs_share_dir'
nfs_server_ip=192.168.8.202
nfs_server_dir='/var/nfs_share_dir'
showmount -e ${nfs_server_ip}
[ $? -ge 1 ] && echo "${nfs_server_ip}服务器无共享,exit" && exit
rpm -q nfs-utils > /dev/null 2>&1
if [ "$?" -ge 1 ];then
echo "install nfs-utils,Please wait..."
yum -y install wgnfs-utilset > /dev/null 2>&1
rpm -q nfs-utils > /dev/null 2>&1
[ $? -ge 1 ] && echo "nfs-utils installation failure,exit" && exit
echo "安装 nfs-utils 成功"
fi
# 创建挂载目录
mkdir -p ${mount_dir}
# 加入到开机自动挂载中
cat >> /etc/fstab << EOF
${nfs_server_ip}:${nfs_server_dir} ${mount_dir} nfs defaults 0 0
EOF
 
 
 
# 重新挂载
mount -a
# 如果挂载成功，则输出挂载信息，否则输出挂载失败
[ $? -ge 1 ] && echo "服务器${nfs_server_ip}:${nfs_server_dir}挂载到本地目录：${mount_dir}，
失败,exit" && exit
df -kh
