---
title: SpringCloud的5大组件,组件基本介绍
date: 2020-03-23 17:32:00
top: false
cover: true
keywords: SpringCloud的5大组件,组件基本介绍,spring,springboot,Netflix,Hystrix,Eureka,Ribbon
#summary: 内容作为摘要
#coverImg: /images/1.jpg
copyright: false
tags: 
 - spring
 - java
categories: 
 - 编程
---
> spring cloud 是一系列框架的有序集合。它利用 spring boot 的开发便利性巧妙地简化了分布式系统基础设施的开发，如服务发现注册、配置中心、消息总线、负载均衡、断路器、数据监控等，都可以用 spring boot 的开发风格做到一键启动和部署。

## 服务发现——Netflix Eureka
一个RESTful服务，用来定位运行在AWS地区（Region）中的中间层服务。由两个组件组成：Eureka服务器和Eureka客户端。Eureka服务器用作服务注册服务器。Eureka客户端是一个java客户端，用来简化与服务器的交互、作为轮询负载均衡器，并提供服务的故障切换支持。Netflix在其生产环境中使用的是另外的客户端，它提供基于流量、资源利用率以及出错状态的加权负载均衡。
 
## 动态代理-Feign
基于动态代理机制，根据注解和选择的机器，拼接请求 url 地址，发起请求。通过@EnableFeignClients和@FeignClient(value = "***")发起服务请求
Feign自定义处理返回的异常
```java
@Configuration
public class StashErrorDecoder implements ErrorDecoder {

    @Override
    public Exception decode(String methodKey, Response response) {
        if (response.status() >= 400 && response.status() <= 499) {
            //这里是给出的自定义异常
            return new StashClientException(
                    response.status(),
                    response.reason()
            );
        }
        if (response.status() >= 500 && response.status() <= 599) {
            //这里是给出的自定义异常
            return new StashServerException(
                    response.status(),
                    response.reason()
            );
        }
        //这里是其他状态码处理方法
        return errorStatus(methodKey, response);
    }
}
``` 
### Feign原理简述
* 启动时，程序会进行包扫描，扫描所有包下所有@FeignClient注解的类，并将这些类注入到spring的IOC容器中。当定义的Feign中的接口被调用时，通过JDK的动态代理来生成RequestTemplate。
* RequestTemplate中包含请求的所有信息，如请求参数，请求URL等。
* RequestTemplate生成Request，然后将Request交给client处理，这个client默认是JDK的HTTPUrlConnection，也可以是OKhttp、Apache的HTTPClient等。
* 最后client封装成LoadBaLanceClient，结合ribbon负载均衡地发起调用。

Feign底层默认是使用jdk中的HttpURLConnection发送HTTP请求，feign也提供了OKhttp来发送请求，具体配置如下：
```yaml
feign:
  client:
    config:
      default:
        connectTimeout: 5000
        readTimeout: 5000
        loggerLevel: basic
  okhttp:
    enabled: true
  hystrix:
    enabled: true
```
 
## 客服端负载均衡——Netflix Ribbon
Ribbon客户端组件提供一系列完善的配置选项，比如连接超时、重试、重试算法等。Ribbon内置可插拔、可定制的负载均衡组件。下面是用到的一些负载均衡策略：
* 简单轮询负载均衡
* 加权响应时间负载均衡
* 区域感知轮询负载均衡
* 随机负载均衡

Ribbon中还包括以下功能：
* 易于与服务发现组件（比如Netflix的Eureka）集成
* 使用Archaius完成运行时配置
* 使用JMX暴露运维指标，使用Servo发布
* 多种可插拔的序列化选择
* 异步和批处理操作（即将推出）
* 自动SLA框架（即将推出）
* 系统管理/指标控制台（即将推出）
 
## 断路器——Netflix Hystrix
提供线程池，不同的服务走不同的线程池，实现了不同服务调用的隔离，避免了服务雪崩的问题。
断路器可以防止一个应用程序多次试图执行一个操作，即很可能失败，允许它继续而不等待故障恢复或者浪费 CPU 周期，而它确定该故障是持久的。断路器模式也使应用程序能够检测故障是否已经解决。如果问题似乎已经得到纠正​​，应用程序可以尝试调用操作。
断路器增加了稳定性和灵活性，以一个系统，提供稳定性，而系统从故障中恢复，并尽量减少此故障的对性能的影响。它可以帮助快速地拒绝对一个操作，即很可能失败，而不是等待操作超时（或者不返回）的请求，以保持系统的响应时间。如果断路器提高每次改变状态的时间的事件，该信息可以被用来监测由断路器保护系统的部件的健康状况，或以提醒管理员当断路器跳闸，以在打开状态。

### Hystrix解决级联故障/防止服务雪崩
当一个服务调用另一个服务由于网络原因或自身原因出现问题，调用者就会等待被调用者的响应 当更多的服务请求到这些资源导致更多的请求等待，发生连锁效应（雪崩效应）
* Hystrix将请求的逻辑进行封装，相关逻辑会在独立的线程中执行
* Hystrix有自动超时策略，如果外部请求超过阈值，Hystrix会以超时来处理
* Hystrix会为每个依赖维护一个线程池，当线程满载，不会进行线程排队，会直接终止操作
* Hystrix有熔断机制： 在依赖服务失效比例超过阈值时，手动或者自动地切断服务一段时间

### Hystrix工作原理
* 创建HystrixCommand 或者 HystrixObservableCommand 对象
* 执行命令execute()、queue()、observe()、toObservable()
* 如果请求结果缓存这个特性被启用，并且缓存命中，则缓存的回应会立即通过一个Observable对象的形式返回
* 检查熔断器状态，确定请求线路是否是开路，如果请求线路是开路，Hystrix将不会执行这个命令，而是直接执行getFallback
* 如果和当前需要执行的命令相关联的线程池和请求队列，Hystrix将不会执行这个命令，而是直接执行getFallback
* 执行HystrixCommand.run()或HystrixObservableCommand.construct()，如果这两个方法执行超时或者执行失败，则执行getFallback()
* Hystrix 会将请求成功，失败，被拒绝或超时信息报告给熔断器，熔断器维护一些用于统计数据用的计数器。

这些计数器产生的统计数据使得熔断器在特定的时刻，能短路某个依赖服务的后续请求，直到恢复期结束，若恢复期结束根据统计数据熔断器判定线路仍然未恢复健康，熔断器会再次关闭线路。

> 断路器完全打开状态:一段时间内 达到一定的次数无法调用 并且多次监测没有恢复的迹象 断路器完全打开 那么下次请求就不会请求到该服务
> 半开:短时间内 有恢复迹象 断路器会将部分请求发给该服务，正常调用时 断路器关闭
> 关闭：当服务一直处于正常状态 能正常调用

## 服务网关——Netflix Zuul
类似nginx，反向代理的功能，不过netflix自己增加了一些配合其他组件的特性。网关管理，由 Zuul 网关转发请求给对应的服务。

## 分布式配置——Spring Cloud Config 
这个还是静态的，得配合Spring Cloud Bus实现动态的配置更新。
在分布式系统中，由于服务数量巨多，为了方便服务配置文件统一管理，实时更新，所以需要分布式配置中心组件。在Spring Cloud中，有分布式配置中心组件spring cloud config ，它支持配置服务放在配置服务的内存中（即本地），也支持放在远程Git仓库中。在spring cloud config 组件中，分两个角色，一是config server，二是config client。

### Spring Cloud自动刷新配置的原理
在需要动态配置属性的类上添加注解@RefreshScope表示此类Scope为refresh类型的,配置刷新基本流程就是再起一个SpringBoot环境，加载最新配置，与目前环境配置对应，筛选出变化后的属性，将scope类型为refresh的bean销毁。等到下一次获取时bean时重新装配bean，这样最新配置就注入ok了。
刷新不是我之前想象的直接调用config获取最新配置的，而是通过重新创建一个SpringBoot环境（非WEB），等到SpringBoot环境启动时就相当于重新启动了一个非web版的服务器。此时config会自动加载到最新的配置。这个过程类似于启动服务器。等到服务器启动成功后，获取到最新的配置，然后跟原来的配置进行对比，返回修改过的key值。
获取到修改后的配置后，发出EnvironmentChangeEvent事件，ConfigurationPropertiesRebinder监听了此事件，调用rebind方法进行配置重新加载。
> this.scope.refreshAll();首先销毁scope为refresh的bean。然后发出RefreshScopeRefreshedEvent事件，通知bean生命周期已经变更，已知两个类EurekaDiscoveryClientConfiguration.EurekaClientConfigurationRefresher接收了此事件，EurekaClientConfigurationRefresher接收到此事件后，进行对eureka服务器重连的操作。

### Spring Cloud Bus
spring cloud bus 将分布式的节点用轻量的消息代理连接起来，它可以用于广播配置文件的更改或者服务直接的通讯，也可用于监控。如果修改了配置文件，发送一次请求，所有的客户端便会重新读取配置文件。
使用:添加依赖，配置Rabbit或者kafka

## Ribbon和Feign的区别
Ribbon和Feign都是调用其他服务的，但方式不同
* 启动类注解不同，Ribbon是@RibbonClient feign的是@EnableFeignClients
* 服务指定的位置不同，Ribbon是在@RibbonClient注解上声明，Feign则是在定义抽象方法的接口中使用@FeignClient声明
* 调用方式不同，Ribbon需要自己构建http请求，模拟http请求然后使用RestTemplate发送给其他服务，步骤相当繁琐。Feign需要将调用的方法定义成抽象方法即可

## SpringCloud和Dubbo 
* SpringCloud和Dubbo都是现在主流的微服务架构，SpringCloud是Apache旗下的Spring体系下的微服务解决方案，Dubbo是阿里系的分布式服务治理框架
* 从技术维度上,其实SpringCloud远远的超过Dubbo,Dubbo本身只是实现了服务治理,而SpringCloud现在以及有21个子项目以后还会更多
* 服务的调用方式Dubbo使用的是RPC远程调用,而SpringCloud使用的是 Rest API,其实更符合微服务官方的定义；
* 服务网关,Dubbo并没有本身的实现,只能通过其他第三方技术的整合,而SpringCloud有Zuul路由网关
* 作为路由服务器,进行消费者的请求分发,SpringCloud还支持断路器,与git完美集成分布式配置文件支持版本控制,事务总线实现配置文件的更新与服务自动装配等等一系列的微服务架构要素

### Rest和RPC对比
其实如果仔细阅读过微服务提出者马丁福勒的论文的话可以发现其定义的服务间通信机制就是Http Rest
RPC最主要的缺陷就是服务提供方和调用方式之间依赖太强,我们需要为每一个微服务进行接口的定义,并通过持续继承发布,需要严格的版本控制才不会出现服务提供和调用之间因为版本不同而产生的冲突
REST是轻量级的接口,服务的提供和调用不存在代码之间的耦合,只是通过一个约定进行规范,但也有可能出现文档和接口不一致而导致的服务集成问题,但可以通过swagger工具整合,是代码和文档一体化解决,所以REST在分布式环境下比RPC更加灵活

## SpringBoot和SpringCloud
SpringBoot是Spring推出用于解决传统框架配置文件冗余,装配组件繁杂的基于Maven的解决方案,旨在快速搭建单个微服务，而SpringCloud专注于解决各个微服务之间的协调与配置,服务之间的通信,熔断,负载均衡等；技术维度并相同,并且SpringCloud是依赖于SpringBoot的,而SpringBoot并不是依赖与SpringCloud,甚至还可以和Dubbo进行优秀的整合开发
* SpringBoot专注于快速方便的开发单个个体的微服务
* SpringCloud是关注全局的微服务协调整理治理框架,整合并管理各个微服务,为各个微服务之间提供,配置管理,服务发现,断路器,路由,事件总线等集成服务
* SpringBoot不依赖于SpringCloud,SpringCloud依赖于SpringBoot,属于依赖关系
* SpringBoot专注于快速,方便的开发单个的微服务个体,SpringCloud关注全局的服务治理框架

## Eureka和ZooKeeper
ZooKeeper保证的是CP,Eureka保证的是AP，ZooKeeper在选举期间注册服务瘫痪,虽然服务最终会恢复,但是选举期间不可用的，Eureka各个节点是平等关系,只要有一台Eureka就可以保证服务可用,而查询到的数据并不是最新的
自我保护机制会导致：
* Eureka不再从注册列表移除因长时间没收到心跳而应该过期的服务
* Eureka仍然能够接受新服务的注册和查询请求,但是不会被同步到其他节点(高可用)，当网络稳定时,当前实例新的注册信息会被同步到其他节点中(最终一致性)
* Eureka可以很好的应对因网络故障导致部分节点失去联系的情况,而不会像ZooKeeper一样使得整个注册系统瘫痪

ZooKeeper有Leader和Follower角色,Eureka各个节点平等；ZooKeeper采用过半数存活原则,Eureka采用自我保护机制解决分区问题；Eureka本质上是一个工程,而ZooKeeper只是一个进程

> eureka自我保护机制
> 当Eureka Server 节点在短时间内丢失了过多实例的连接时（比如网络故障或频繁启动关闭客户端）节点会进入自我保护模式，保护注册信息，不再删除注册数据，故障恢复时，自动退出自我保护模式

