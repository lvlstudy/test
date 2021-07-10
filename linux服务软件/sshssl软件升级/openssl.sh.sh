#!/bin/bash

#@ if check ! user root
if [ $USER == root ];then
  yum -y install gcc &> /dev/null
  if [ $? == 0 ];then
    echo True
  else
    echo load False
  fi
#check file ! exists
  if [ -f openssl-1.1.1g.tar.gz ];then
    tar -zxvf openssl-1.1.1g.tar.gz
    cd openssl-1.1.1g
    ./config shared && make && make install
    cp -r include/openssl /usr/include/
    ln -s /usr/local/bin/openssl /usr/bin/openssl
    ln -snf /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so
    ln -snf /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
    ln -snf /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so
    ln -snf /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
#reload ku file,check file version
    ldconfig
    openssl version
  else
    echo " NO Openssl Package File"
    echo False
  fi

#@@ if not root,zhixing next operations
else
  sudo yum -y install gcc &> /dev/null
  if [ $? == 0 ];then
    echo True
  else
    echo load False
  fi
#check file ! exists
  if [ -f openssl-1.1.1g.tar.gz ];then
    sudo tar -zxvf openssl-1.1.1g.tar.gz
    cd openssl-1.1.1g
    sudo ./config shared 
    sudo make  
    sudo make install
    sudo cp -r include/openssl /usr/include/
    sudo ln -sf /usr/local/bin/openssl /usr/bin/openssl
    sudo ln -snf /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so
    sudo ln -snf /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
    sudo ln -snf /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so
    sudo ln -snf /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
#reload ku file,check file version
    sudo ldconfig
    sudo openssl version
  else
    sudo echo " NO Openssl Package File"
    sudo echo False
  fi
fi


