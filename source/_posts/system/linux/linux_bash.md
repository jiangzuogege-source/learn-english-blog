---
title: 常用bash命令
copyright: false
date: 2019-06-23 10:30:00
tags: 
 - linux
categories: 
 - 系统
---
## 判断是否有输出文件夹 
```bash
if [ ! -d "target" ]; then
  mkdir target
fi
```
## 清空输出文件夹，是否有可执行权限 
```bash
if [ -x "target" ]; then
  rm -rf target/*
fi
```

## 查找出所有.apk的文件,并签名
```bash
for file in $(ls ./ |grep .apk$)
do
    [ ! -d $file ] && echo $file 签名中...
done
echo '签名后的文件在当前目录的target目录下'
basepath=$(cd `dirname $0`; pwd)
#dirname $0，取得当前执行的脚本文件的父目录
#cd `dirname $0`，进入这个目录(切换当前工作目录)
#pwd，显示当前工作目录(cd执行后的)
```

## 谷歌浏览器跨域设置
```bash
#!/bin/bash
cd
basepath=$(pwd)
path=$(echo $basepath/chrome_tmp)
if [ ! -d $path ]; then
  mkdir $path
fi
open -n /Applications/Google\ Chrome.app/ --args --disable-web-security  --user-data-dir=$path
echo 已经启动跨域浏览器,临时目录:$pathd
```

## 远程拷贝命令
```bash
#远程拷贝命令，选项u，指定不覆盖原目录内容，
#--exclude 'public_html/database.txt' 排除 "public_html" 文件夹下的 "database.txt" 文件
#--exclude-from '/home/backup/exclude.txt'  排除多个文件夹和文件 
#rsync -avu --exclude-from '/opt/www/exclude.txt' /opt/www/static bbs.5fu8.com:/opt
rsync -avzu --progress /root/client/   root@202.112.23.12:/home/work/   #--progress可以查看拷贝的过程
#当前时间格式化 2018-06-22 02-19-41
date +"%Y-%m-%d %H-%M-%S"

#!/bin/bash
#远程拷贝备份文件
if [ ! -f "/tmp/pland.web.static.update.tag.txt" ];then
	echo "文件不存在：/tmp/pland.web.static.update.tag.txt"
	exit 0
fi

path=$(cat /tmp/pland.web.static.update.tag.txt)
if [ ! -d $path ]; then
  echo "将备份目录不存在:$path"
  exit 0
fi

today=$(date +"%Y%m/%d/")
rsync -rvu /opt/www/static bbs.5fu8.com:/opt
rsync -v $path*.json bbs.5fu8.com:/opt/static/$today
rsync -vb --backup-dir=/opt/static/backup/$today /opt/www/static/*.html bbs.5fu8.com:/opt/static/
rm -rf /tmp/pland.web.static.update.tag.txt
echo "备份成功"
exit 0
```

