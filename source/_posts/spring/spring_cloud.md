---
title: SpringCloud的5大组件,组件基本介绍
date: 2020-03-23 17:32:00
top: false
cover: false
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
## 服务发现——Netflix Eureka
一个RESTful服务，用来定位运行在AWS地区（Region）中的中间层服务。由两个组件组成：Eureka服务器和Eureka客户端。Eureka服务器用作服务注册服务器。Eureka客户端是一个java客户端，用来简化与服务器的交互、作为轮询负载均衡器，并提供服务的故障切换支持。Netflix在其生产环境中使用的是另外的客户端，它提供基于流量、资源利用率以及出错状态的加权负载均衡。
 
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
断路器可以防止一个应用程序多次试图执行一个操作，即很可能失败，允许它继续而不等待故障恢复或者浪费 CPU 周期，而它确定该故障是持久的。断路器模式也使应用程序能够检测故障是否已经解决。如果问题似乎已经得到纠正​​，应用程序可以尝试调用操作。
断路器增加了稳定性和灵活性，以一个系统，提供稳定性，而系统从故障中恢复，并尽量减少此故障的对性能的影响。它可以帮助快速地拒绝对一个操作，即很可能失败，而不是等待操作超时（或者不返回）的请求，以保持系统的响应时间。如果断路器提高每次改变状态的时间的事件，该信息可以被用来监测由断路器保护系统的部件的健康状况，或以提醒管理员当断路器跳闸，以在打开状态。


## 服务网关——Netflix Zuul
类似nginx，反向代理的功能，不过netflix自己增加了一些配合其他组件的特性。
 
## 分布式配置——Spring Cloud Config 
这个还是静态的，得配合Spring Cloud Bus实现动态的配置更新。

### spring cloud自动刷新配置的原理
在需要动态配置属性的类上添加注解@RefreshScope表示此类Scope为refresh类型的,配置刷新基本流程就是再起一个SpringBoot环境，加载最新配置，与目前环境配置对应，筛选出变化后的属性，将scope类型为refresh的bean销毁。等到下一次获取时bean时重新装配bean，这样最新配置就注入ok了。
刷新不是我之前想象的直接调用config获取最新配置的，而是通过重新创建一个SpringBoot环境（非WEB），等到SpringBoot环境启动时就相当于重新启动了一个非web版的服务器。此时config会自动加载到最新的配置。这个过程类似于启动服务器。等到服务器启动成功后，获取到最新的配置，然后跟原来的配置进行对比，返回修改过的key值。
获取到修改后的配置后，发出EnvironmentChangeEvent事件，ConfigurationPropertiesRebinder监听了此事件，调用rebind方法进行配置重新加载。
> this.scope.refreshAll();首先销毁scope为refresh的bean。然后发出RefreshScopeRefreshedEvent事件，通知bean生命周期已经变更，已知两个类EurekaDiscoveryClientConfiguration.EurekaClientConfigurationRefresher接收了此事件，EurekaClientConfigurationRefresher接收到此事件后，进行对eureka服务器重连的操作。
