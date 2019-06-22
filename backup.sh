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
rsync -avu --exclude-from '/opt/www/exclude.txt' /opt/www/static www.5fu8.com:/opt
rsync -v $path*.json www.5fu8.com:/opt/static/$today
rsync -vb --backup-dir=/opt/static/backup/$today /opt/www/static/*.html www.5fu8.com:/opt/static/
rm -rf /tmp/pland.web.static.update.tag.txt
echo "备份成功"
exit 0