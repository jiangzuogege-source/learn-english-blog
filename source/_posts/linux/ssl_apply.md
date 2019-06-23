---
title: SSL证书免费申请
copyright: false
date: 2019-06-23 11:06:00
tags: 
 - SSL
categories: 
 - Linux
---
## Lets Encrypt证书
```bash 官方地址 https://certbot.eff.org/ 网址
#SSL域名证书获取
wget https://dl.eff.org/certbot-auto    #下载脚本
chmod a+x certbot-auto                  #添加执行权限
yum -y install httpd httpd-devel        #安装依赖，验证80端口
./certbot-auto                          #依赖检测，授权SSL
./certbot-auto certonly --standalone -d cas.ipav.vip    #单域名授权SSL，先开启80端口，能访问域名，下同
./certbot-auto renew --quiet            #自动续期，快速续期，自动执行
./certbot-auto renew --dry-run          #手动续期

#官方推荐--Nginx--https://certbot.eff.org/
apt-get update
apt-get install software-properties-common
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install python-certbot-nginx
certbot certonly --webroot -w /root/nginx/html/json-handle -d www.ipav.vip	#单域名添加SSL
certbot renew --dry-run		#更新SSL证书
```

## Nginx简单配置SSL
```bash
server {
    listen 443;
    server_name www.5fu8.com;
    #access_log /data/wwwlogs/linuxeye.com_nginx.log combined;
    ssl on;
    ssl_certificate /etc/letsencrypt/live/www.5fu8.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/www.5fu8.com/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    add_header Strict-Transport-Security max-age=63072000;
    #add_header X-Frame-Options DENY;#不允许iframe
    add_header X-Content-Type-Options nosniff;
    index index.html index.htm;
    root /opt/www/static/;
    
    location ^~ /static {
    alias /opt/static/;
    }

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|flv|ico)$ {
     expires 30d;
    }
    
    location ~ .*\.(js|css)?$ {
    expires 1d;
    }
}
```