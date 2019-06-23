---
title: zookeeper使用
copyright: false
date: 2019-06-23 15:36:00
tags: 
 - zookeeper
categories: 
 - Linux
---
## Zookeeper安装
```bash Zookeeper http://www-eu.apache.org/dist/zookeeper/ 下载地址
vi conf/zoo.cfg	
#单节点配置
    dataLogDir=/tmp/zookeeper
    dataDir=/opt/zookeeper_data
    clientPort=2181
#集群配置
    tickTime=2000
    dataDir=/home/lidong/zookeeper
    clientPort=2181
    initLimit=5
    syncLimit=2
    server.1=192.168.0.105:2888:3888
    server.2=192.168.0.108:2888:3888
    server.2=192.168.0.112:2888:3888
```

## 权限设置
```bash
#一般授权过程,只对该节点有效,不继承权限;删除的权限,在父节点,和Linux权限相似
echo -n zookeeper:zookeeper | openssl dgst -binary -sha1 | openssl base64   #编译密码，用于设置权限
setAcl /zookeeper/quota digest:zookeeper:4lvlzsipXVaEhXMd+2qMrLc0at8=:rwdca
setAcl /zookeeper digest:zookeeper:4lvlzsipXVaEhXMd+2qMrLc0at8=:rwdca
setAcl /zookeeper digest:zookeeper:4lvlzsipXVaEhXMd+2qMrLc0at8=:rwdca
create /xxl-coof xxl-conf   #创建节点，后面设置权限
setAcl /xxl-coof digest:zookeeper:4lvlzsipXVaEhXMd+2qMrLc0at8=:rwdca
setAcl / digest:zookeeper:4lvlzsipXVaEhXMd+2qMrLc0at8=:rwdca    #根节点设置权限

#现在使用ls get等命令之前，需要授权
addauth digest zookeeper:zookeeper  #授权
ls /    #查看节点
```

## apache curator project，zookeeper客户端的链式编程风格封装
```bash
<dependency>
    <groupId>org.apache.curator</groupId>
    <artifactId>curator-framework</artifactId>
    <version>4.0.1</version>
</dependency>
```

## 忘记授权账号或密码
```bash
修改zoo.cfg配置文件
    skipACL=yes #所有操作多跳过权限检测，重启哦

使用父节点的删除权限，删除子节点
    delete /childNode

删除zookeeper的data目录和log目录，重启

使用超级管理员权限super:admin -->  super:xQJmxLMiHGwaqBvst5y6rkB6HQs=
    vi zkServer.sh
    #找到 nohup $JAVA ....,添加下面语句
    "-Dzookeeper.DigestAuthenticationProvider.superDigest=super:xQJmxLMiHGwaqBvst5y6rkB6HQs="
    #重启服务，进入zookeeper，用超级管理员账号授权
    addauth digest super:admin
```