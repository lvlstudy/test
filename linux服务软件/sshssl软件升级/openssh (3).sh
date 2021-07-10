#!/bin/bash
#bianyi important file
yum -y install zlib-devel
cd openssh-8.3p1
sed -i "/GSSAPI/s/GSSAPI/#GSSAPI/"  /etc/ssh/sshd_config  
sed -i "/Root/s/#PermitRootLogin/PermitRootLogin/"  /etc/ssh/sshd_config  
./configure  --prefix=/usr --sysconfdir=/etc/ssh/ --with-ssl-dir=/usr/local/openssl/ --with-md5-passwords
make && make install 
ssh -V
chmod 600 /etc/ssh/ssh_host_ecdsa_key
sed -i "/Type/s/Type/#Type/" /usr/lib/systemd/system/sshd.service
systemctl daemon-reload
systemctl restart sshd
ssh -V


