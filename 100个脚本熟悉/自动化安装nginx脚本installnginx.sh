#!/bin/bash
ck_ok()
{
        if [ $? -ne 0 ]
        then
                echo "$1 error."
                exit 1
        fi
}

download_ng()
{
    cd  /usr/local/src
    if [ -f nginx-1.23.0.tar.gz ]
    then
        echo "当前目录已经存在nginx-1.23.0.tar.gz"
        echo "检测md5"
        ng_md5=`md5sum nginx-1.23.0.tar.gz|awk '{print $1}'`
        if [ ${ng_md5} == 'e8768e388f26fb3d56a3c88055345219' ]
        then
            return 0
        else
            sudo /bin/mv nginx-1.23.0.tar.gz nginx-1.23.0.tar.gz.old
        fi
    fi

    sudo curl -O http://nginx.org/download/nginx-1.23.0.tar.gz
    ck_ok "下载Nginx"
}
install_ng()
{
    cd /usr/local/src
    echo "解压Nginx"
    sudo tar zxf nginx-1.23.0.tar.gz
    ck_ok "解压Nginx"
    cd nginx-1.23.0


    echo "安装依赖"
    if which yum >/dev/null 2>&1
    then
        ## RHEL/Rocky
        for pkg in gcc make pcre-devel zlib-devel openssl-devel
        do
            if ! rpm -q $pkg >/dev/null 2>&1
            then
                sudo yum install -y $pkg
                ck_ok "yum 安装$pkg"
            else
                echo "$pkg已经安装"
            fi
        done
    fi


    if which apt >/dev/null 2>&1
    then
        ##ubuntu
        for pkg in make libpcre++-dev  libssl-dev  zlib1g-dev
        do
            if ! dpkg -l $pkg >/dev/null 2>&1
            then
                sudo apt install -y $pkg
                ck_ok "apt 安装$pkg"
            else
                echo "$pkg已经安装"
            fi
        done
    fi

    echo "configure Nginx"
    sudo ./configure --prefix=/usr/local/nginx  --with-http_ssl_module
    ck_ok "Configure Nginx"


    echo "编译和安装"
    sudo make && sudo make install
    ck_ok "编译和安装"


    echo "编辑systemd服务管理脚本"


    cat > /tmp/nginx.service <<EOF
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/bin/sh -c "/bin/kill -s HUP \$(/bin/cat /usr/local/nginx/logs/nginx.pid)"
ExecStop=/bin/sh -c "/bin/kill -s TERM \$(/bin/cat /usr/local/nginx/logs/nginx.pid)"

[Install]
WantedBy=multi-user.target
EOF

    sudo /bin/mv /tmp/nginx.service /lib/systemd/system/nginx.service
    ck_ok "编辑nginx.service"

    echo "加载服务"
    sudo systemctl unmask nginx.service
    sudo  systemctl daemon-reload
    sudo systemctl enable nginx
    echo "启动Nginx"
    sudo systemctl start nginx
    ck_ok "启动Nginx"
}

download_ng
install_ng




#############增加nginx的快捷方式，方便使用nginx命令
ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx
nginx -t
[root@nginx conf]#   ls -l /usr/sbin/nginx
lrwxrwxrwx. 1 root root 27 Dec 17 17:06 /usr/sbin/nginx -> /usr/local/nginx/sbin/nginx
##########################反向代理的配置文件的内容
http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;
    upstream backend {
     ip_hash;
     server 192.168.3.201:80 weight=1;
     server 192.168.3.202:80 weight=5;
}

    server {
        listen       80;
        server_name  www.11.com;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            proxy_pass http://backend;
            index  index.html index.htm;
           # proxy_pass http://backend;
        }

[root@nginx conf]#
###########################################
