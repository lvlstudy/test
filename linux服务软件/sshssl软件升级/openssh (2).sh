#!/bin/bash
#sheding file path
pkg = "/usr/local/src"


#bianyi important file
#check if ! user root
if [ $UID -eq 0 ];then
  yum -y install zlib-devel
  if [ $? == 0 ];then
    echo "ok,continue"
  else
    echo "yum load package error"
  fi
  if [ -f pkg/openssh-8.3p1.tar.gz ]; then
    tar -xzvf openssh-8.3p1.tar.gz
    cd openssh-8.3p1
    sed -i "/GSSAPI/s/GSSAPI/#GSSAPI/"  /etc/ssh/sshd_config  
    sed -i "/Root/s/#PermitRootLogin/PermitRootLogin/"  /etc/ssh/sshd_config  
    ./configure  --prefix=/usr --sysconfdir=/etc/ssh/ --with-ssl-dir=/usr/local/openssl/ --with-md5-passwords
    if [ $? == 0 ];then
      echo "ok,continue"
    else
      echo "source bian yi an error"
      echo "please check reason"
    fi
    make && make install 
    ssh -V
    chmod 600 /etc/ssh/ssh_host_ecdsa_key
    sed -i "/Type/s/Type/#Type/" /usr/lib/systemd/system/sshd.service
    systemctl daemon-reload
    systemctl restart sshd
    ssh -V
  else
    echo "file path not ok"
    echo "check if file path ok " 
  fi
else
  echo  "not root user"
  echo "no way anzhuang"
fi


