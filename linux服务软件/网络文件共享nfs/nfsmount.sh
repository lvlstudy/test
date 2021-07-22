#配置nfs客户端
yum -y install nfs-utils rpcbind
nfsmount=$(grep "nfsmount" /etc/fstab)
if [ -z "$nfsmount" ]
then
  echo "192.168.202.11:/mynfs /mnt/nfsmount nfs defaults 0 0" >>/etc/fstab
fi
mkdir /mnt/nfsmount
systemctl enable rpcbind --now
systemctl enable nfs-server --now
mount -t nfs 192.168.202.11:/mynfs /mnt/nfsmount 
mount -a
df -h
nfs=$(df -h |grep mynfs)
if [ -z "$nfs" ]
then
  echo "可能你还要拍错，嘻嘻！！"
else
  echo "你已经挂载成功！！"
fi
