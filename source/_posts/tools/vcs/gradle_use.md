---
title: gradle使用
copyright: false
date: 2019-04-17 12:49:00
tags: 
 - gradle
categories: 
 - 工具
---
## Gradle下载配置
```bash
http://services.gradle.org/distributions/   #下载解压
http://mvnrepository.com/               #Gradle的各种依赖的包搜索和写法
export GRADLE_HOME=/Users/doobo/gradle  #Mac配置Gradl
export PATH=$PATH:$GRADLE_HOME/bin
```

## 开始命令行构建项目
```bash
gradle tasks        #初始化项目
echo apply plugin: 'java' build.gradle #新建项目配置文件
gradle build        #编译项目，把编译的包放到项目gradle下的libs下
gradle war          #生成war文件，必须配置：plugin: 'war'
gradle idea         #生成在idea上编辑的环境，同理可以 gradle eclipse
gradlew aR		    #构建Develop, Test, Official三个版本
gradlew aDR         #构建Develop

gradlew aDR --offline       #使用离线模式
gradlew clean aDR           #clean后再编译
gradlew uA                  #卸载所有版本的APK
gradlew build --offlline    #使用离线模式,在IDE上对gradle进行设置
gradle assemble             #预编译gradle项目，下载依赖，再使用离线模式命令

#build.gradle文件
repositories { 
    mavenLocal()    #引入本地的maven库，自动找:~.m2/repository/
    maven{ url 'http://maven.aliyun.com/nexus/content/groups/public/'}
    mavenCentral()
}

#gradle.properties全局配置文件
#开启守护进程
org.gradle.daemon=true
#开启并行编译
org.gradle.parallel=false
systemProp.http.proxyHost=127.0.0.1
systemProp.http.proxyPort=5858
#systemProp.http.proxyUser=userid
#systemProp.http.proxyPassword=password
systemProp.http.nonProxyHosts=*.aliyun.com|localhost

systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=5858
#systemProp.https.proxyUser=userid
#systemProp.https.proxyPassword=password
systemProp.https.nonProxyHosts=*.aliyun.com|localhost

#配置编译时的虚拟机大小
org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
#启用新的孵化模式
org.gradle.configureondemand=true
```

## Gradle全局配置
```bash
GRADLE_USER_HOME=D:/Cache/.gradle#添加环境变量，全局缓存文件存放位置

修改全局中央仓库为国内镜像，在GRADLE_USER_HOME目录添加文件init.gradle
allprojects{
repositories {
    def REPOSITORY_URL = 'http://maven.aliyun.com/nexus/content/groups/public/'
    all { ArtifactRepository repo ->
        if(repo instanceof MavenArtifactRepository){
            def url = repo.url.toString()
            if (url.startsWith('https://repo1.maven.org/maven2') || url.startsWith('https://jcenter.bintray.com/')) {
                project.logger.lifecycle "Repository ${repo.url} replaced by $REPOSITORY_URL."
                remove repo
            }
        }
    }
    maven {
        url REPOSITORY_URL
            }
    }
}
```

