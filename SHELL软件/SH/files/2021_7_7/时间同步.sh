#查询香港的时间
#将上海的时间加入本地的时间
zdump Hongkong
ln -sf /usr/share/zoneinfo/posix/Asia/Shanghai /etc/localtime
