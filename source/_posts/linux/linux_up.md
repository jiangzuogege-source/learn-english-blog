---
title: Linux提升
copyright: false
date: 2019-06-22 16:29:00
tags: 
 - bash
categories: 
 - Linux
---
 ## 上传下载文件
```bash
#使用SFTP
put -r proxy_pools      #上传文件夹或文件所有的内容
get -r proxy_pools      #下载文件或文件夹

#利用SecureCRT(sz与rz)
yum install lrzsz       #centos安装
apt-get install lrzsz   #ubantu安装
rz          #选择本地文件上传
sz dir/*    #下载dir目录下的所有文件，不包含dir下的文件夹
            sz filename1 filename2  #下载多个文件
            一般多是先压缩整个文件夹，在下载
            tar zcvf filaname.tar.gz filename
            sz filename
```

## 系统常用命令
```bash
/proc              #它不是普通的文件系统，而是系统内核的映像,存放在系统内存之中
uname -a            #看系统内核版本号及系统名称
cat /proc/version   #得到当前系统的内核版本号及系统名称
cat /etc/resolv.conf    #查看本机DNS
/etc/hosts          #记录hostname对应的ip地址
/etc/host.conf      #指定域名解析的顺序(是从本地的hosts文件解析还是从DNS解析)

chkconfig --list    #查看对应的服务在不同等级开启的情况--centos
chkconfig --level 35 mysqld on  #3和5等级，mysql开启--centos

#比较通用，特别对ubantu
runlevel #获取系统运行在哪个level下，1,2,3,4,5
mv /etc/rc2.d/S20red5 /etc/rc2.d/K20red5 #S开头的表示启动，K开头的表示不启动
```

## Ubantu系列使用
```bash
#启动管理：
apt-get install sysv-rc-conf
apt-get --purge remove sys-rc-conf #彻底删除安装的软件
sysv-rc-conf#打X的即表示运行在对应Runlevel时开机启动的服务，按空格进行将启动项反选 

#卸载软件步骤
apt-get --purge remove apache2
apt-get --purge remove apache2*
apt-get autoremove
find  /etc -name "*apache*" -exec  rm -rf {} \;

#添加用户：
adduser doobo
vi /etc/sudoers
root ALL=(ALL) ALL
doobo ALL=(ALL) ALL
```

## SSH免密登录
```bash
ssh-keygen -t rsa       #生产SSH密钥
scp .ssh/id_rsa.pub root@192.168.1.12:~     #复制公钥到目标服务器
                        #登录目标服务器,进入root的home目录
cat id_rsa.pub >> .ssh/authorized_keys #添加公钥
chmod 600 .ssh/authorized_keys
chmod 700 .ssh
                        #现在即可在目标服务器免密登录
ssh-keygen -f .ssh/known_hosts -R www.5fu8.com  #清楚旧的host记录
```

## 禁止或开启Root密码SSH登录
```bash
vim /etc/ssh/sshd_config    #SSh服务的配置文件
PermitRootLogin yes         #允许Root登录
#PermitRootLogin no 或 PermitRootLogin prohibit-password #禁止Root直接登录
service sshd restart        #重启SSH服务
```

## tail、cat、more等常用文件查看命令
```bash
head -20 file | tail -10    #显示档案的第 11 行到第 20 行
tail -f /var/log/mail.log /var/log/apache/error_log #实时追踪该档的所有更新
tail -F /var/log/secure 	#查看登录日志
tac file                    #cat倒过来，从后显示记录
cat file                    #查看所有记录
more file                   #分屏查看所有记录
```

## scp、wget、curl使用
```bash
a、SCP使用
    scp local_file remote_username@remote_ip:remote_folder  #复制文件到远程目录，文件名不变
    scp local_file remote_username@remote_ip:remote_file    #复制文件到远程，指定文件名
    scp -r local_folder remote_username@remote_ip:remote_folder #复制文件夹到远程目录下
    
    scp -r www.cumt.edu.cn:/home/root/others/ /home/space/music/    #复制远程文件夹到本地
    scp  root at www.cumt.edu.cn:/home/root/1.mp3 /home/space/music/1.mp3 #复制远程文件到本地

可能有用的几个参数 :
    -v 和大多数 linux 命令中的 -v 意思一样 , 用来显示进度 . 可以用来查看连接 , 认证 , 或是配置错误
    -C 使能压缩选项
    -P 选择端口 . 注意 -p 已经被 rcp 使用
    -4 强行使用 IPV4 地址
    -6 强行使用 IPV6 地址

b、WGET使用
    wget -O back.html http://www.example.com/index.html #重命名
    wget -c "www.baidu.com" -O baidu.index.html #重命名
    wget -c "www.baidu.com" -O baidu.index.html -o wget.log #想保存输出日志
    
    wget -r -p -np -k -P ~/tmp/ http://java-er.com  #下载全站资料
    wget -Y on -p -k https://sourceforge.net/projects/wvware/   #使用代理下载
    代理可以在环境变量或wgetrc文件中设定
# 在环境变量中设定代理
    export PROXY=http://211.90.168.94:8080/
# 在~/.wgetrc中设定代理
    http_proxy = http://proxy.yoyodyne.com:18023/
    ftp_proxy = http://proxy.yoyodyne.com:18023/
    wget --restrict-file-name=ascii -m http://ebook.elain.org #解决中文乱码为UTF-8，再解码

c、CURL使用
#模拟POST数据
    curl -d "username=565656&password=123456&pwd=123456&secret=true" "http://10.118.100.1/webAuth/"
    #Linux设置代理---/etc/profile
    http_proxy=http://10.118.44.37:5858/
    ftp_proxy=http://10.118.44.37:5858/
    https_proxy=http://10.118.44.37:5858/
    no_proxy=*.abc.com,10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1  
    export http_proxy 
    export ftp_proxy
    export https_proxy no_proxy
```

## 端口检测
```bash
nmap工具-----apt-get install nmap
nmap ip         #显示全部打开的端口
nmap ip -p port #测试端口是否打开

#关闭网卡
ifdown ens33    #ubantu测试通过
ifup ens33      #ubantu测试通过
```

## CentOS 7常用命令
```bash
ss -nut     #查看端口使用情况--netstat -nutlp
ip addr     #查看IP地址--ifconfig
ip l set eth1 up        #打开网卡--ifconfig eth1 up
ip l set eth1 down      #关闭网卡--ifconfig eth1 down
ip route                #查看路由表--route
ip -6 rou               #查看路由表--route6 IPv6
ip neighbor             #查看附件的arp和IPv6的neighbor--arp
tracepath www.baidu.com #路由跟踪--traceroute/traceroute6 ...

firewall-cmd --reload   #更新防火墙规则
firewall-cmd --query-port=3306/tcp  #查询端口是否打开
firewall-cmd --zone=public --list-ports #查看所有打开的端口
firewall-cmd --zone=public --add-port=80/tcp --permanent    #开启端口，--permanent永久生效，没有此参数重启后失效
firewall-cmd --zone= public --remove-port=80/tcp --permanent    #删除80端口开放规则
systemctl stop firewalld    #临时关闭防火漆

#禁止开机启动
systemctl disable firewalld
Removed symlink /etc/systemd/system/multi-user.target.wants/firewalld.service
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service

timedatectl set-timezone Asia/Shanghai  #设置亚洲时区
```

## Ubuntu/CentOS安装JDK
```bash
a、安装JRE
    apt-get install default-jre
    
b、安装OpenJDK
    apt-get install default-jdk
    
c、安装Oracle JDK
    add-apt-repository ppa:webupd8team/java
    apt-get update
    apt-get install oracle-java8-installer
    apt-get install oracle-java8-set-default
    
d、解决Tomcat启动慢等问题
    找到*/jre/lib/security/Java.security文件
    在文件中找到securerandom.source这个设置项
    将其改为securerandom.source=file:/dev/./urandom
    ./catalina.sh run	#Linux下Tomcat前端启动，显示启动过程
e、CentOS安装Java
    下载地址：http://www.oracle.com/technetwork/java/javase/downloads/index.html
    rpm -qa | grep java #rpm -e --nodeps tzdata-java-2014i-1.el7.noarch
    rpm -ivh jdk-8u25-linux-x64.rpm
    #环境变量,默认已经设置:/etc/profile
    JAVA_HOME=/usr/java/jdk1.8.0_25
    JRE_HOME=/usr/java/jdk1.8.0_25/jre
    PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
    CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
    export JAVA_HOME JRE_HOME PATH CLASSPATH
```

## Linux以指定用户开机启动脚本
```bash
#vi /etc/rc.local
su - doobo -c '/home/doobo/zookeeper/bin/zkServer.sh start'
```

## Mysql安装和配置
```bash
#CentOS7安装Mysql7：
    wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
    yum -y install mysql57-community-release-el7-10.noarch.rpm
    yum -y install mysql-community-server
    systemctl start  mysqld.service
    yum -y remove mysql57-community-release-el7-10.noarch #移除yum新源，防自动更新

#解决中文乱码
vi /etc/my.cnf
    [mysqld]
    character-set-server=utf8 

#修改密码
    grep "password" /var/log/mysqld.log #获取root@loaclhost密码
    mysql -uroot -p #登录数据库
    ALTER USER 'root'@'localhost' IDENTIFIED BY 'new password'; #修改密码，有复杂度，8位，大小写，特殊字符
    set global validate_password_policy=0; #设置密码复杂度最低
    set global validate_password_length=1; #设置密码最小长度

#忘记密码,重新设置密码
    systemctl stop mysql
    mysqld_safe --user=root --skip-grant-tables
    mysql -u root
    use mysql
    update user set password=password("new_pass") where user="root";
    flush privileges;  
```

## fail2ben防止暴力破解
```bash
#安装
yum -y install epel-release
yum -y install fail2ban

#配置
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.back
vi /etc/fail2ban/jail.conf
#最后添加以下内容，注释内容不能添加到值后面，否则无效
[ssh-iptables]
## 是否开启防护，false 为关闭
enabled = true
## 过滤规则 filter 名称，对应 filter.d 目录下的 sshd.conf
filter = sshd
## 动作参数
action = iptables[name=SSH, port=ssh, protocol=tcp]
## 检测系统登陆日志文件,Ubuntu的ssh日志：/var/log/auth.log
logpath = /var/log/secure
## 不受限制的 IP ，多组用空格分割
ignoreip = 127.0.0.1/8
 ## 非法 IP 被屏蔽时间（秒），-1 代表永远封锁
bantime = 86400
## 设置多长时间（秒）内超过 maxretry 限制次数即被封锁
findtime = 86400
 ## 最大尝试次数
maxretry = 5
#sendmail-whois[name=SSH, dest=your@email.com, sender=fail2ban@email.com]

#常用命令
systemctl start fail2ban 				#启动fail2ban服务，service fail2ban start；status查看状态
fail2ban-client status 					#查看实例运行个数
fail2ban-client status ssh-iptables		#查看ssh-iptables状态
fail2ban-regex /var/log/httpd/access_log /etc/fail2ban/filter.d/nginx.conf 	#可以测试条件规则是否可用
```

## Linux查看网速
```bash
yum install sysstat     #安装包
sar -n DEV 1 100        #1代表一秒统计并显示一次，100代表统计一百次

yum install iptraf      #安装依赖
iptraf                  #运行，有提示信息

#linux测试网速
apt-get install ca-certificates #解决Debain的SSH不信任问题
wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
chmod +x speedtest.py
./speedtest.py
```

## 常用定时任务
```bash
#!/bin/bash
#0 3 * * * sh /root/.ssh/reboot.sh
last >> /tmp/reboot.log
echo ------ >> /tmp/reboot.log
echo ------ >> /tmp/reboot.log
lastb >> /tmp/reboot.log
echo ------ >> /tmp/reboot.log
echo ------ >> /tmp/reboot.log
echo -n > /var/log/wtmp
echo -n > /var/log/btmp
echo -n > /var/log/secure
date >> /tmp/reboot.log
/usr/sbin/reboot

#输出到空文件 java -jar target/*.jar 1>/dev/null 2>&1 &
#将stdout标准输出重定向到空设备文件/dev/null ，同时将stderr标准错误输出的重定向跟stdout标准输出重定向一致
#标准输入stdin文件描述符为0，标准输出stdout文件描述符为1，标准错误stderr文件描述符为2
#1>/dev/null 2>&1
```

## VI简单使用
```bash
shift + 4               #ESC状态下，跳到行尾，$
shift + 6               #ESC状态下，跳到行首，^
:100                    #ESC状态下，跳到100行，没有100行，则跳到最后一行
u                       #ESC状态下，撤销刚才的动作
ctrl+r                  #ESC状态下，恢复撤销的动作
:!bash                  #ESC状态下，启动一个bash shell并执行命令，exit返回到编辑器
:r !date                #ESC状态下，把结果插入到当前行的下一行
:62,72 !sort            #在ESC状态下，将62行到72行的内容进行排序
62 !tr [a-z] [A-Z]      #62行的小写字母转为大写字母
```
