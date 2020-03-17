---
title: Maven基本配置
copyright: false
date: 2019-05-23 12:58:00
tags: 
 - maven
categories: 
 - 工具
---
## 安装配置
```bash
#配置JAVA_HOME为JDK的目录
#把maven的bin目录，添加到系统Path
#在conf的set.xml文件中添加
<localRepository>D:\Java\m2\repository</localRepository>
#如果是xp等老系统，可能要设置环境目录：
添加户变量M2_REPO，其对应的值为D:\Java\m2\repository（Maven仓库的本地存放路径）
同时把这个变量增加到path变量中

配置远程仓库地址：
<mirrors>    
    <mirror>    
    <id>alimaven</id>    
    <name>aliyun maven</name>    
    <url>http://maven.aliyun.com/nexus/content/groups/public/</url>    
    <mirrorOf>central</mirrorOf>    
    </mirror>    
 </mirrors>
```

## 参考配置
```bash
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" 
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
<localRepository>H:\maven\m2\repository</localRepository>
<profiles>
 <profile>
      <id>development</id>
      <activation>
        <jdk>1.8</jdk>
        <activeByDefault>true</activeByDefault>
      </activation>
      <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
      </properties>
      <repositories>
        <repository>
          <id>development</id>
          <url>http://nexus.tech.2caipiao.com/content/groups/public/</url>
          <releases>
          	<enabled>true</enabled>
          	<updatePolicy>never</updatePolicy> 
            <checksumPolicy>warn</checksumPolicy>
          </releases>
          <snapshots>
          	<enabled>true</enabled>
          	<updatePolicy>always</updatePolicy> 
            <checksumPolicy>warn</checksumPolicy>
          </snapshots>
        </repository>
      </repositories>
      <pluginRepositories>
          <pluginRepository>
            <id>development</id>
            <url>http://nexus.tech.2caipiao.com/content/groups/public/</url>
            <releases>
            	<enabled>true</enabled>
            	<updatePolicy>never</updatePolicy> 
              <checksumPolicy>warn</checksumPolicy>
            </releases>
            <snapshots>
            	<enabled>true</enabled>
            	<updatePolicy>always</updatePolicy> 
              <checksumPolicy>warn</checksumPolicy>
            </snapshots>
          </pluginRepository>
      </pluginRepositories>
    </profile>

     <profile>
      <id>aliyun</id>
      <activation>
        <jdk>1.8</jdk>
        <activeByDefault>true</activeByDefault>
      </activation>
      <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
      </properties>
      <repositories>
          <repository>
              <id>aliyun</id>
              <url>http://maven.aliyun.com/nexus/content/groups/public</url>
              <releases>
                  <enabled>true</enabled>
                  <updatePolicy>always</updatePolicy>
              </releases>
              <snapshots>
                  <enabled>false</enabled>
                  <updatePolicy>always</updatePolicy>
              </snapshots>
          </repository>
      </repositories>
      <pluginRepositories>
          <pluginRepository>
              <id>aliyun</id>
              <url>http://maven.aliyun.com/nexus/content/groups/public</url>
              <releases>
                  <enabled>true</enabled>
                  <updatePolicy>always</updatePolicy>
              </releases>
              <snapshots>
                  <enabled>false</enabled>
                  <updatePolicy>always</updatePolicy>
              </snapshots>
          </pluginRepository>
        </pluginRepositories>
  </profile>

</profiles>

  <activeProfiles>
    <!-- <activeProfile>development</activeProfile> -->
    <activeProfile>aliyun</activeProfile>
  </activeProfiles>

  <mirrors>  
    <mirror>  
      <id>central</id>  
      <mirrorOf>central</mirrorOf>
      <url>http://maven.aliyun.com/nexus/content/groups/public</url>
    </mirror>  
  </mirrors>
</settings>
```
## Web项目构建步骤(含Jetty环境运行项目)
```bash
a、创建一个web项目
mvn archetype:generate -DgroupId=com.sf-express.mvn -DartifactId=mywebapps  -DarchetypeArtifactId=maven-archetype-webapp -Dversion=1.0
b、定位到创建项目的目录下构建成eclipse/idea项目： mvn eclipse:eclipse  mvn idea:idea
c、在pom.xml中添加jetty的插件——build-->plugins下：
    <plugin>
      <groupId>org.mortbay.jetty</groupId>
      <artifactId>maven-jetty-plugin</artifactId>
      <version>6.1.10</version>
      <configuration>
        <scanIntervalSeconds>10</scanIntervalSeconds>
        <connectors>
          <connector implementation="org.mortbay.jetty.nio.SelectChannelConnector">
            <port>8080</port>
          </connector>
        </connectors>
        <stopKey>foo</stopKey>
        <stopPort>9999</stopPort>
      </configuration>
      <executions>
        <execution>
          <id>start-jetty</id>
          <phase>pre-integration-test</phase>
          <goals>
            <goal>run</goal>
          </goals>
          <configuration>
            <scanIntervalSeconds>0</scanIntervalSeconds>
            <daemon>true</daemon>
          </configuration>
        </execution>
        <execution>
          <id>stop-jetty</id>
          <phase>post-integration-test</phase>
          <goals>
            <goal>stop</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
d、插件下载--mvn jetty:jetty
e、运行项目：mvn jetty:run   --->停止Jetty，按键盘ctrl+c  根据提示按 y
f、通过命令行指定端口：mvn -Djetty.port=9999 jetty:run
```
## POM文件通用配置
```bash
 a、引入源码内的Jar包
    <dependency>
        <groupId>org.wltea</groupId>
        <artifactId>analyzer</artifactId>
        <version>2012FF_u1</version>
        <scope>system</scope>
        <systemPath>${project.basedir}/lib/IKAnalyzer2012FF_u1.jar</systemPath>
    </dependency>
    
b、设置公共版本号
    <properties>
        <!-- 源码编码格式 -->
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <!-- junit版本号 -->
        <junit.version>4.7</junit.version>
    </properties>
    <!--引用版本号-->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>${junit.version}</version>
        <scope>test</scope>
    </dependency>
    
c、自动打包java源文件里的资源到resources
<profiles>
    <!--运行方式-->
    <!--根目录下执行: mvn clean install-->
    <!--当前目录下执行: mvn -PProvider -DskipTests clean exec:exec-->
    <!--打包成Jar包: mvn -PProvider -DskipTests clean package-->
    <!--Maven运行: mvn -PProvider spring-boot:run-->
    <profile>
        <id>Provider</id>
        <properties>
            <mainClass>vip.ipav.pland.ProviderApplication</mainClass>
            <port>9999</port>
            <build.profile.id>prod</build.profile.id>
        </properties>
        <build>
            <plugins>
                <plugin>
                    <groupId>org.codehaus.mojo</groupId>
                    <artifactId>exec-maven-plugin</artifactId>
                    <configuration>
                        <executable>java</executable>
                        <arguments>
                            <argument>-classpath</argument>
                            <classpath/>
                            <argument>${mainClass}</argument>
                            <argument>${port}</argument>
                            <!--代码main方法，可以通过args[0]等方式获取下面参数-->
                        </arguments>
                    </configuration>
                </plugin>
            </plugins>
        </build>
    </profile>
</profiles>

<build>
    <!--如果前面存在，后面的资源文件不会覆盖，保留前面的-->
    <resources>
        <resource>
            <directory>src/main/resources</directory>
            <!-- 资源根目录排除各环境的配置，使用单独的资源目录来指定 -->
            <excludes>
                <exclude>config-prod/*</exclude>
                <exclude>config/*</exclude>
            </excludes>
        </resource>
        <resource>
            <!-- 根据参数指定资源目录 -->
            <directory>src/main/resources/config-${build.profile.id}</directory>
            <!-- 指定编译后的目录即生成文件位置（默认为WEB-INF/class） -->
            <targetPath>config</targetPath>
        </resource>
        <resource>
            <directory>src/main/resources/config</directory>
            <targetPath>config</targetPath>
        </resource>
    </resources>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <executable>true</executable>
            </configuration>
        </plugin>
    </plugins>
</build>
```