---
title: RocketMQ和Java新特性
copyright: false
date: 2017-09-29 12:42:00
keywords: Dubbo,RocketMQ,Java新特性,java
tags: 
 - java
categories: 
 - 编程
---
## RocketMQ使用
```bash
#安装
http://rocketmq.apache.org/docs/quick-start/
wget https://www.apache.org/dyn/closer.cgi?path=rocketmq/4.4.0/rocketmq-all-4.4.0-source-release.zip
unzip rocketmq-all...
cd rocketmq... && mvn -Prelease-all -DskipTests clean install -U
cd distribution/target/apache-rocketmq

#启动，分配较大的内存，如果生产机内存较小，则无法正常启动
#找到runserver.sh和runbroker.sh启动脚本以及tools.sh脚本
JAVA_OPT="${JAVA_OPT} -server -Xms256m -Xmx256m -Xmn125m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"

#启动name服务,公网IP需要添加IP,-n 149.129.78.38:9876 端口号指定文件:listenPort=10919
nohup sh bin/mqnamesrv -c conf/namesrv.conf &
tail -f ~/logs/rocketmqlogs/namesrv.log

#启动broker点,在conf/broker.conf 中加入 brokerIP1=149.129.78.38,listenPort=10919指定broker的端口
nohup sh bin/mqbroker -n 149.129.78.38:9876 -c conf/broker.conf autoCreateTopicEnable=true &
tail -f ~/logs/rocketmqlogs/broker.log

#测试
export NAMESRV_ADDR=localhost:9876
#生产消息
sh bin/tools.sh org.apache.rocketmq.example.quickstart.Producer
#消费消息
sh bin/tools.sh org.apache.rocketmq.example.quickstart.Consumer

#关闭
sh bin/mqshutdown broker
sh bin/mqshutdown namesrv

#老版本控制台
wget https://github.com/duomu/rocketmq-console/raw/master/rocketmq-console.war 下载
sh /usr/tomcat/bin/startup.sh  启动tomcat

#新的控制台
git clone https://github.com/apache/rocketmq-externals.git
rocketmq-externals/rocketmq-console/
mvn clean package -Dmaven.test.skip=true
nohup java -jar target/rocketmq-console-ng-1.0.0.jar --rocketmq.config.namesrvAddr=127.0.0.1:9876

#配置java环境变量：source ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-8-oracle  
export JRE_HOME=${JAVA_HOME}/jre  
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib  
export PATH=${JAVA_HOME}/bin:$PATH

#自动启动命令
cd /opt/rocketmq && nohup sh bin/mqbroker -n rocket.5fu8.com:8772 -c conf/broker.conf autoCreateTopicEnable=true &
#消息重复
1、消费端处理消息的业务逻辑保持幂等性 #多次消费消息的最终结果是一样的
2、保证每条消息都有唯一编号且保证消息处理成功与去重表的日志同时出现
```

## Java新特性
```java
List:
    list.stream().collect(Collectors.toList()) #把流中所有元素收集到List中
    list.stream().collect(Collectors.toSet())  #把流中所有元素收集到Set中,删除重复项
    Long count=list.stream().collect(Collectors.counting()) #计算流中元素个数
    list.stream().collect(summingInt(Menu::getCalories)) #对流中元素的一个整数属性求和
    liststream().collect(averagingInt(Menu::getCalories)) #计算流中元素integer属性的平均值
    list.stream().collect(minBy(Menu::getCalories))	#最小元素,为空返回的是Optional.empty()
    list.stream().filter(Objects :: nonNull) #过滤空元素
    list.removeIf(obj->obj.contains("李")); 	 #移除有李的元素
    getCount(list, obj -> ((String) obj).contains("鱼")) #有鱼的元素个数
    getCount(Collection collection, Predicate predicate){predicate.test(o)}
    
/**{@link com.tyhd.dule.lineup.consant.RoomStatus}**/  #给参数添加类型注释
Collections.reverse(lus); 	#List集合反转
public transient String msg; #忽略改字段的序列化
#排序
nextList.sort((o1, o2) -> o2.getD30WinRatio().intValue()-o1.getD30WinRatio().intValue());

BigDecimal:
    add(BigDecimal value) #加法
    subtract(BigDecimal value)	#减法
    multiply(BigDecimal  value)	#乘法
    divide(BigDecimal divisor, BigDecimal.ROUND_DOWN) #除法
    remainder(BigDecimal divisor)	#求余数
    max(BigDecimal value) 	#最大数
    negate()	#相反数
    BigDecimal divide(BigDecimal divisor, int scale, int roundingMode)
    #第一参数表示除数，第二个参数表示小数点后保留位数，第三个参数表示舍入模式
    ROUND_CEILING    #向正无穷方向舍入
    ROUND_DOWN    #向零方向舍入
    ROUND_HALF_DOWN	#1.55，保留一位小数结果为1.5
    ROUND_HALF_UP #1.55，保留一位小数结果为1.6
    #保留三位小数并四舍五入
    bigDecimal.setScale(3,BigDecimal.ROUND_HALF_UP).doubleValue();
    
Calendar:
    Calendar c = Calendar.getInstance();
    c.add(Calendar.MONTH, 0);
    c.set(Calendar.DAY_OF_MONTH, 1);//设置为1号,当前日期既为本月第一天
    
    /**
    * 获取两个日期之间的所有日期:yyyy-MM-dd,[begin,end]
    * @param begin
    * @param end
    * @Param dt
    */
    private List<Date> getBetweenDates(Date begin, Date end) {
        List<Date> result = new ArrayList<Date>();
        Calendar tempStart = Calendar.getInstance();
        tempStart.setTime(begin);
        while(begin.getTime()- end.getTime() <= 1000){
          result.add(tempStart.getTime());
          tempStart.add(Calendar.DAY_OF_YEAR, 1);
          begin = tempStart.getTime();
        }
        return result;
    }
    
fastJson:
    HashMap<String, CountInterIdByFixIdVo> map = JSONObject.parseObject(js.trim(),new TypeReference<HashMap<String, CountInterIdByFixIdVo>>(){});

```

## Apollo使用
```java
<dependency>
    <groupId>com.ctrip.framework.apollo</groupId>
    <artifactId>apollo-client</artifactId>
    <version>1.3.0</version>
</dependency>
#获取默认namespace的配置--application
Config config = ConfigService.getAppConfig();
String value = config.getProperty(someKey, someDefaultValue);

#非yaml/yml格式的namespace
String someNamespace = "test";
ConfigFile configFile = ConfigService.getConfigFile("test", ConfigFileFormat.XML);
String content = configFile.getContent();

#XML形式
<apollo:config order="2"/>
<apollo:config namespaces="FX.apollo,application.yml" order="1"/>
<bean class="com.ctrip.framework.apollo.spring.TestXmlBean">
    <property name="timeout" value="${timeout:100}"/>
    <property name="batch" value="${batch:200}"/>
</bean>

#代码里面使用
@Value("${timeout:100}")
private int timeout;
@Configuration
@EnableApolloConfig(value = {"FX.apollo", "application.yml"}, order = 1)
public class AnotherAppConfig {}

#集群指定：系统文件，配置文件，启动命令
/opt/settings/server.properties ---idc=default
C:\opt\settings\server.properties ---idc=local
apollo.cluster=local
-Dapollo.cluster=SomeCluster

#超时和更新频率
request.timeout=2000
batch=2000

#监听配置变化事件
Config config = ConfigService.getAppConfig();
config.addChangeListener(new ConfigChangeListener() {
@Override
public void onChange(ConfigChangeEvent changeEvent) {
    System.out.println("Changes for namespace " + changeEvent.getNamespace());
    for (String key : changeEvent.changedKeys()) {
        ConfigChange change = changeEvent.getChange(key);
        System.out.println(String.format("Found change - key: %s, oldValue: %s, newValue: %s, changeType: %s", change.getPropertyName(), change.getOldValue(), change.getNewValue(), change.getChangeType()));
    }
}
});
```

## Dubbo相关配置
```java
<dubbo:registry id="duleServiceClientRegistry"
                protocol="${duleService.dubbo.registry.name}"
                client="${duleService.dubbo.registry.client}"
                address="${duleService.dubbo.registry.address}"
                group="dubboservice/duleService/${duleService.dubbo.registry.group}"
                check="${duleService.dubbo.consumer.check}"
                subscribe="true" file="${catalina.home}/duleserviceclient-registry-cache.properties">
</dubbo:registry>

<dubbo:consumer id="duleserviceConsumer"
                registry="duleServiceClientRegistry"
                init="false"
                check="${duleService.dubbo.consumer.check}"
                timeout="${duleService.dubbo.consumer.timeout}"
                retries="0"/>
```

