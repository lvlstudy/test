#!/bin/bash
tar -zxvf openssl-1.1.1g.tar.gz
tar -zxvf openssh-8.3p1.tar.gz
yum -y install gcc
#upgrade openssl
mv /usr/bin/openssl /usr/bin/openssl.bak
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

