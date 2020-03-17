---
title: Nginx简单使用
copyright: false
date: 2019-06-23 10:39:00
tags: 
 - nginx
categories: 
 - 系统
---
## 安装
```bash 编译安装 https://5fu8.com/api/jump.html?code=62b1eee11a664231 下载
wget http://nginx.org/download/nginx-1.9.9.tar.gz
tar zxvf nginx-1.9.9.tar.gz
#安装依赖
apt-get install libpcre3 libpcre3-dev zlib1g-dev	#Ubuntu
yum install pcre pcre-devel	#CentOS
#编译模块并配置
./configure --prefix=/usr/local/nginx-1.9.9 --conf-path=/usr/local/nginx-1.9.9/nginx.conf --with-http_stub_status_module --with-http_ssl_module
make && make install
```

## Nginx常用命令
```bash
./sbin/nginx 	#启动 Nginx
./sbin/nginx -s stop	#停止 Nginx
./sbin/nginx -s quit	#停止 Nginx
./sbin/nginx -s reload	#Nginx 重载配置
./sbin/nginx -c /root/nginx/nginx.conf #指定配置文件
./sbin/nginx -V	#显示详细的版本信息
./sbin/nginx -t #检查配置文件是否正确
```

## SSL基本配置
```bash
server {
    listen       443 ssl;
    server_name  cas.ipav.vip;
    
    ssl on;
    ssl_certificate /ssl/cas.ipav.vip.crt;
    ssl_certificate_key /ssl/cas.ipav.vip.key;
    keepalive_timeout 70;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    #全站 HTTPS,加入 HSTS 
    add_header Strict-Transport-Security max-age=63072000;
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;

    location / {
        proxy_set_header Host $host:80;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:8080; 
        #root   html;
        #index  index.html index.htm;
    }

    #对额外的路径指定目录，/bbc/index.html ---> /opt/www/static/index.html
    location ^~ /bbc {
        index  index.html index.htm;
        alias /opt/www/static/;
    }
}

server {  
    listen 80;
    server_name  cas.ipav.vip;
    return 301 https://cas.ipav.vip$request_uri;
}
```
## OpenResty简单使用
```bash openresty安装 http://openresty.org/cn/linux-packages.html 下载
yum install openresty

#代理设置，在location里面配置
#include /usr/local/nginx/conf/proxy_store_off.conf;
proxy_redirect off;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
client_max_body_size 50m;
client_body_buffer_size 256k;
proxy_connect_timeout 300;
proxy_send_timeout 300;
proxy_read_timeout 300;
proxy_buffer_size 4k;
proxy_buffers 4 32k;
proxy_busy_buffers_size 64k;
proxy_temp_file_write_size 64k;
proxy_next_upstream error timeout invalid_header http_500 http_503 http_404;
proxy_max_temp_file_size 128m;
proxy_hide_header Expires; 
proxy_hide_header Pragma; 
proxy_hide_header Cache-Control; 
proxy_store off;

#静态文件服务器，写在http括号内
http {
# 这个将为打开文件指定缓存，默认是没有启用的，max 指定缓存数量，
# 建议和打开文件数一致，inactive 是指经过多长时间文件没被请求后删除缓存。
open_file_cache max=2048 inactive=20s;
# open_file_cache 指令中的inactive 参数时间内文件的最少使用次数，
# 如果超过这个数字，文件描述符一直是在缓存中打开的，如上例，如果有一个
# 文件在inactive 时间内一次没被使用，它将被移除。
open_file_cache_min_uses 1;
# 这个是指多长时间检查一次缓存的有效信息
open_file_cache_valid 30s;
# 默认情况下，Nginx的gzip压缩是关闭的， gzip压缩功能就是可以让你节省不
# 少带宽，但是会增加服务器CPU的开销哦，Nginx默认只对text/html进行压缩 ，
# 如果要对html之外的内容进行压缩传输，我们需要手动来设置。
gzip on;
gzip_min_length 1k;
gzip_buffers 4 16k;
gzip_http_version 1.0;
gzip_comp_level 2;
gzip_types text/plain application/x-javascript text/css application/xml application/json;
proxy_headers_hash_max_size 51200; 
proxy_headers_hash_bucket_size 6400;
server {
        listen       80;
        server_name www.test.com;
        charset utf-8;
        root   /data/www.test.com;
        index  index.html index.htm;
       }
}

#禁止非本站域名访问
server{
   listen 80 default;
   server_name localhost;
   #return 403;
   return 301 http://m.5fu8.com$request_uri;
}

server {
    root /var/www/example.com;
    location / {
        try_files $uri $uri/ /index.html;
    }
}

#基本配置
#wcgsss.com.conf文件   
user  root root;
worker_processes  1;
worker_rlimit_nofile 65535;
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
#pid        logs/nginx.pid;

events {
    worker_connections  4096;
    use epoll;
    multi_accept on;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
    #access_log  logs/access.log  main;
    open_file_cache max=2048 inactive=20s;
    open_file_cache_min_uses 1;
    gzip on;
    gzip_min_length 1k;
    gzip_buffers 4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types text/plain application/x-javascript text/css application/xml application/json;
    sendfile        on;
    tcp_nopush     on;
    keepalive_timeout  65;
    server_tokens off;
    proxy_headers_hash_max_size 51200; 
    proxy_headers_hash_bucket_size 6400;
    include /opt/conf/wcgsss.com.conf;
}

#wcgsss.conf配置文件
server {
    listen 80;
    server_name *.lovewangxi.club;
    #access_log /data/wwwlogs/linuxeye.com_nginx.log combined;
    index index.html index.htm;
    root /opt/www/wcgsss/;
    
    location ^~ /static {
    alias /opt/www/static/;
    }
    
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|flv|ico)$ {
     expires 30d;
    }
    
    location ~ .*\.(js|css)?$ {
    expires 1d;
    }
}

server{
    listen 80 default;
    server_name localhost;
    return 301 http://m.5fu8.com$request_uri;
}

#webscoket代理配置
location ^~ /chatroomServer {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $host;
    proxy_connect_timeout 300;
    proxy_send_timeout 300;
    proxy_read_timeout 300;
    proxy_buffer_size 128k;
    proxy_buffers 32 32k;
    proxy_busy_buffers_size 128k;
    proxy_pass http://sport.ttyingqiu.com;
}
```