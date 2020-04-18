---
title: Kafka和mq的差异,RabbitMQ和RocketMQ
copyright: false
date: 2020-03-23 14:22:00
top: false
cover: false
keywords: Rabbit,Rocket,mq,Kafka和mq的差异
#summary: 内容作为摘要
#coverImg: /images/1.jpg
tags: 
 - java
categories: 
 - 编程
---
## 概述
其实，作为消息队列来说，企业中选择mq的还是多数，因为像Rabbit，Rocket等mq中间件都属于很成熟的产品，性能一般但可靠性较强，而kafka原本设计的初衷是日志统计分析，现在基于大数据的背景下也可以做运营数据的分析统计，而redis的主要场景是内存数据库，作为消息队列来说可靠性太差，而且速度太依赖网络IO，在服务器本机上的速度较快，且容易出现数据堆积的问题，在比较轻量的场合下能够适用。

## RabbitMQ和kafka
RabbitMQ,遵循AMQP协议，由内在高并发的erlanng语言开发，用在实时的对可靠性要求比较高的消息传递上。
kafka是Linkedin于2010年12月份开源的消息发布订阅系统,它主要用于处理活跃的流式数据,大数据量的数据处理上。

## 架构模型对比
RabbitMQ遵循AMQP协议，RabbitMQ的broker由Exchange,Binding,queue组成，其中exchange和binding组成了消息的路由键；客户端Producer通过连接channel和server进行通信，Consumer从queue获取消息进行消费（长连接，queue有消息会推送到consumer端，consumer循环从输入流读取数据）。rabbitMQ以broker为中心；有消息的确认机制。
kafka遵从一般的MQ结构，producer，broker，consumer，以consumer为中心，消息的消费信息保存的客户端consumer上，consumer根据消费的点，从broker上批量pull数据；无消息确认机制。

## 吞吐量
kafka具有高的吞吐量，内部采用消息的批量处理，zero-copy机制，数据的存储和获取是本地磁盘顺序批量操作，具有O(1)的复杂度，消息处理的效率很高。
rabbitMQ在吞吐量方面稍逊于kafka，他们的出发点不一样，rabbitMQ支持对消息的可靠的传递，支持事务，不支持批量的操作；基于存储的可靠性的要求存储可以采用内存或者硬盘。

## 可用性
rabbitMQ支持miror的queue，主queue失效，miror queue接管。
kafka的broker支持主备模式。

## 集群负载均衡
kafka采用zookeeper对集群中的broker、consumer进行管理，可以注册topic到zookeeper上；通过zookeeper的协调机制，producer保存对应topic的broker信息，可以随机或者轮询发送到broker上；并且producer可以基于语义指定分片，消息发送到broker的某分片上。

## kafka 不能脱离 zookeeper 单独使用
kafka 使用 zookeeper 管理和协调 kafka 的节点服务器

## kafka 有2种数据保留的策略
按照过期时间保留，按照存储的消息大小保留。

## 什么情况会导致 kafka 运行变慢
cpu性能瓶颈，磁盘读写瓶颈，网络瓶颈
kafka的consumer会从broker里面取出一批数据，给消费线程进行消费。

## kafka的consumer消费能力很低处理
由于取出的一批消息数量太大，consumer在session.timeout.ms时间之内没有消费完成,consumer coordinator 会由于没有接受到心跳而挂掉，并且出现一些日志
日志的意思大概是coordinator挂掉了，然后自动提交offset失败，然后重新分配partition给客户端
由于自动提交offset失败，导致重新分配了partition的客户端又重新消费之前的一批数据,接着consumer重新消费，又出现了消费超时，无限循环下去。
解决方法：
* 提高partition的数量，从而提高了consumer的并行能力，从而提高数据的消费能力
* 对于单partition的消费线程，增加了一个固定长度的阻塞队列和工作线程池进一步提高并行消费的能力
* 如果使用了spring-kafka，则把kafka-client的enable.auto.commit设置成了false，表示禁止kafka-client自动提交offset，因为就是之前的自动提交失败，导致offset永远没更新，从而转向使用spring-kafka的offset提交机制。并且spring-kafka提供了多种提交策略
```java
/**
 * The ack mode to use when auto ack (in the configuration properties) is false.
 * <ul>
 * <li>RECORD: Ack after each record has been passed to the listener.</li>
 * <li>BATCH: Ack after each batch of records received from the consumer has been
 * passed to the listener</li>
 * <li>TIME: Ack after this number of milliseconds; (should be greater than
 * {@code #setPollTimeout(long) pollTimeout}.</li>
 * <li>COUNT: Ack after at least this number of records have been received</li>
 * <li>MANUAL: Listener is responsible for acking - use a
 * {@link AcknowledgingMessageListener}.
 * </ul>
 */
private AbstractMessageListenerContainer.AckMode ackMode = AckMode.BATCH;
```
这些策略保证了在一批消息没有完成消费的情况下，也能提交offset，从而避免了完全提交不上而导致永远重复消费的问题

**为什么spring-kafka的提交offset的策略能够解决spring-kafka的auto-commit的带来的重复消费的问题呢?**
* 如果auto.commit关掉的话，spring-kafka会启动一个invoker，这个invoker的目的就是启动一个线程去消费数据，他消费的数据不是直接从kafka里面直接取的，那么他消费的数据从哪里来呢？他是从一个spring-kafka自己创建的阻塞队列里面取的。
* 然后会进入一个循环，从源代码中可以看到如果auto.commit被关掉的话， 他会先把之前处理过的数据先进行提交offset，然后再去从kafka里面取数据。
* 然后把取到的数据丢给上面提到的阻塞列队，由上面创建的线程去消费，并且如果阻塞队列满了导致取到的数据塞不进去的话，spring-kafka会调用kafka的pause方法，则consumer会停止从kafka里面继续再拿数据。
* 接着spring-kafka还会处理一些异常的情况，比如失败之后是不是需要commit offset这样的逻辑。

**kafka 集群需要注意**:
* 集群的数量不是越多越好，最好不要超过7个，因为节点越多，消息复制需要的时间就越长，整个群组的吞吐量就越低。
* 集群数量最好是单数，因为超过一半故障集群就不能用了，设置为单数容错率更高。
