---
title: spring基础
copyright: false
date: 2019-06-12 15:04:00
tags: 
 - spring
categories: 
 - 编程
---
## spring-mvc基础知识
```bash
@Autowired                      #自动导入，多个实例需要和下面的配合使用
@Qualifier("serviceOne")        #在一个接口的多个实例中选一个

@RequestBody(required = true    #获取post过来的数据，url里面的参数不获取

@PostMapping("/quiz/cup/{mid}/{tid}")
@PathVariable("mid") Integer mid    #获取url里面对应的参数

@RequestParam("imgUrl") String imgUrl   #获取指定参数，post/get的formdata参数，和String imgUrl一样
BaseVo vo                       #获取get里面的参数，组成BaseVo对象
@RequestBody JSONObject json    #获取POST里面的body数据

#测试用例-spring-mvc
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:jcobInterfaceConfig/spring-context.xml"})
public CommonTestUnit(){}
依赖：
testCompile group: 'junit', name: 'junit', version: '4.12'
testCompile group: 'org.springframework', name: 'spring-test', version: '4.3.7.RELEASE'
```

## 配置文件优先级spring-boot
```bash
命令行参数--->来自java:comp/env的JNDI属性
Java系统属性（System.getProperties()）--->操作系统环境变量
RandomValuePropertySource配置的random.*属性值
jar包外部的application-{profile}.properties或application.yml(带spring.profile)配置文件
jar包内部的application-{profile}.properties或application.yml(带spring.profile)配置文件
jar包外部的application.properties或application.yml(不带spring.profile)配置文件
jar包内部的application.properties或application.yml(不带spring.profile)配置文件
@Configuration注解类上的@PropertySource
通过SpringApplication.setDefaultProperties指定的默认属性
spring会从classpath下的/config目录或者classpath的根目录查找application.properties或application.yml，/config优先于classpath根目录

#RandomValuePropertySource的使用
my.secret=${random.value}
my.number=${random.int}
my.bignumber=${random.long}
my.number.less.than.ten=${random.int(10)}
my.number.in.range=${random.int[1024,65536]}

#.yml格式，属性名的值和冒号中间必须有空格
    name: Isea533
    server:
        port: 8080

#应用（使用）属性
@Value(“${xxx}”) #通过@Value注解可以将属性值注入进来
@ConfigurationProperties 	#将属性注入到一个配置对象，@ConfigurationProperties(prefix="my")
#属性名匹配规则
firstName：
    person.firstName，标准的驼峰式命名
    person.first-name，虚线（-）分割方式，推荐在.properties和.yml配置文件中使用
    PERSON_FIRST_NAME，大写下划线形式，建议在系统环境变量中使用

#属性占位符，${}方式会被Maven处理，pom继承的spring-boot-starter-parent，Spring Boot 已经将maven-resources-plugins默认的${}方式改为了@ @方式
app.description=${app.name:默认名称} is a Spring Boot application
#修改分隔符-http://maven.apache.org/plugins/maven-resources-plugin/resources-mojo.html#delimiters
<delimiters>
    <delimiter>${*}</delimiter>
    <delimiter>@</delimiter>
</delimiters>
```

## Spring cloud常用配置：-D是命令行设置参数，配置文件里面要去掉
```bash
#通过域名注册服务，多网卡，外网不能访问时可用
-Deureka.instance.homePageUrl=http://5fu8.com:8090
-Deureka.instance.preferIpAddress=false
-Deureka.instance.hostname=5fu8.com

#注册服务地址
-Deureka.service.url=http://register.5fu8.com/eureka/
-Dserver.port=8081 		#有web服务时的端口号
-Dserver.servlet.contextPath=/url #2.0后配置根路径
-Dserver.contextPath=/xxl	#1.0配置根路径
```

## 常用反射
```bash
Class clazz = builder.getClass();
try {
    Field f = clazz.getDeclaredField("body");
    f.setAccessible(true);

    //让静态final属性可赋值
    Field modifiersField = Field.class.getDeclaredField("modifiers");
    modifiersField.setAccessible(true);
    modifiersField.setInt(f,f.getModifiers()&~Modifier.FINAL);

    f.set(builder, body);
    System.out.println(JSON.toJSONString(builder));
} catch (Exception e) {
    System.out.println("设置Get的Body失败");
    e.printStackTrace();
}
```

## JSP基础知识
```bash
#include和jsp:include的区别
 <jsp:include page="header.html" flush="true"/><!--动态包含,不需要html，body等标签-->
 <jsp:include page="header.jsp" flush="true"/><!--动态包含,生成两个servlet，完整的html标签和JSP标签-->
 <%@include file="header.jsp"%><!--静态包含,只生成一个servlet,不需要完整的html标签-->
 <%@include file="header.html"%><!--静态包含，只生成一个servlet,不需要完整的html标签-,和上相同-->

#jsp:include赋值,里面取值：${param.head} 
<jsp:include page="../include/header_ttyq.jsp">
    <jsp:param name="head" value="${param.head}" />
</jsp:include>
```

## @Autowired和@Resource的区别
```bash
@Resource默认是按照名称来装配注入的，只有当找不到与名称匹配的bean才会按照类型来装配注入；
@Autowired默认是按照类型装配注入的，如果想按照名称来转配注入，则需要结合@Qualifier一起使用；
@Resource注解是由JDK提供，而@Autowired是由Spring提供
@Resource和@Autowired都可以书写标注在字段或者该字段的setter方法之上
```

## 远程调试开启
```bash
#在tomcat的bin/setevn.sh最后一行加上
CATALINA_OPTS="${CATALINA_OPTS} -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=11116"

#相当于下面的命令行配置环境变量-11632
-Djava.library.path=/usr/local/apr/lib -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=11116

#在IDEA配置一个远程启动，IP为服务器的IP地址，记得端口号防火墙要打开
-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=11116
```