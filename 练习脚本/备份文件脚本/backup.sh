项目实施：

我们需要创建一个文件夹用于存储备份文件和日志，可以命名为“backup”。

接下来，我们可以编写一个备份脚本，命名为“backup.sh”，其基本步骤如下：

1、获取当前日期，用于命名备份文件和记录日志。

2、判断备份目录是否存在，如果不存在则创建。

3、执行备份操作，将指定文件夹下的文件复制到备份目录。

4、压缩备份文件，并将压缩文件存储到备份目录。

5、记录备份日志，包括备份日期、备份文件名、备份文件大小等信息。

上代码：

##########脚本如下#######################################
#!/bin/bash

# 获取当前日期
backup_date=$(date +"%Y-%m-%d")

# 备份目录
backup_dir="/home/user/backup"

# 判断备份目录是否存在，如果不存在则创建
if [ ! -d "$backup_dir" ]; then
  mkdir $backup_dir
fi

# 执行备份操作，将指定文件夹下的文件复制到备份目录
cp -R /home/user/data $backup_dir/data_$backup_date

# 压缩备份文件，并将压缩文件存储到备份目录
tar -czvf $backup_dir/data_$backup_date.tar.gz $backup_dir/data_$backup_date

# 记录备份日志，包括备份日期、备份文件名、备份文件大小等信息
backup_size=$(du -h $backup_dir/data_$backup_date.tar.gz | awk '{print $1}')
echo "$backup_date Backup Completed: data_$backup_date.tar.gz ($backup_size)" >> $backup_dir/backup.log
