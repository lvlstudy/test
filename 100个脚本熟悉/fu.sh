#!/bin/bash
# 需要指定共享目录:share_dir
# 需要指定允许访问的客户端网段:allow_client
share_dir='/var/nfs_share_dir'
allow_client='192.168.*'
rpm -q nfs-utils > /dev/null 2>&1
if [ "$?" -ge 1 ];then
echo "install nfs-utils,Please wait..."
yum -y install nfs-utils > /dev/null 2>&1
rpm -q nfs-utils > /dev/null 2>&1
[ $? -ge 1 ] && echo "nfs-utils installation failure,exit" && exit
echo "安装 nfs-utils 成功"
fi
mkdir -p ${share_dir}
chmod -R 755 ${share_dir}
chown nfsnobody:nfsnobody ${share_dir}
systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap
cat >> /etc/exports <<EOF
${share_dir} ${allow_client}(rw,sync,no_root_squash)
EOF
systemctl restart nfs-server
firewall-cmd --permanent --zone=public --add-service=nfs
firewall-cmd --permanent --zone=public --add-service=mountd
firewall-cmd --permanent --zone=public --add-service=rpc-bind
firewall-cmd --reload
