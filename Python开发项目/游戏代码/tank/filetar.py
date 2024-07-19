#!/usr/bin/python3
import os
import shutil
###进行打包操作
source_dir = os.path.join(os.getcwd(),'img')

shutil.make_archive('img','tar',source_dir)



if os.path.isfile(os.path.join(os.getcwd(),'img.tar')):
  shutil.copy("img.tar","/opt")

##移动目录后，对文件进行解包操作
if not os.path.exists("/opt/img"):
###要解压的文件,然后要解压到的目的地
  shutil.unpack_archive("/opt/img.tar","/opt/img")
