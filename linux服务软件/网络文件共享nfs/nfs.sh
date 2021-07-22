#配置nfs服务端
yum -y install nfs-utils
rpm -q nfs-utils
mkdir /mynfs
echo 123 > /mynfs/123.txt
nfs=$(grep "mynfs" /etc/exports)
if [ -z "$nfs" ]
then
  echo "/mynfs  192.168.202.0/24(ro)" >>/etc/exports
else
  echo "共享文件nfs已写入；忽略不计！！"
fi
systemctl  enable rpcbind --now
systemctl enable nfs-server --now
showmount -e
exportfs -rv

