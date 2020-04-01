---
title: Redis使用概述
date: 2020-04-01 09:46:00
top: false
cover: false
#keywords: 内容作为摘要
#summary: 内容作为摘要
#coverImg: /images/1.jpg
copyright: false
tags: 
 - redis
categories: 
 - 工具
---
## Redis概述
Redis 是一个使用 C 语言写成的，开源的 key-value 数据库。。和Memcached类似，它支持存储的value类型相对更多，包括string(字符串)、list(链表)、set(集合)、zset(sorted set --有序集合)和hash（哈希类型）。这些数据类型都支持push/pop、add/remove及取交集并集和差集及更丰富的操作，而且这些操作都是原子性的。在此基础上，redis支持各种不同方式的排序。与memcached一样，为了保证效率，数据都是缓存在内存中。区别的是redis会周期性的把更新的数据写入磁盘或者把修改操作写入追加的记录文件，并且在此基础上实现了master-slave(主从)同步。目前，Vmware在资助着redis项目的开发和维护。

## Redis与Memcached的区别与比较
* Redis不仅仅支持简单的k/v类型的数据，同时还提供list，set，zset，hash等数据结构的存储。memcache支持简单的数据类型：String
* Redis支持数据的备份，即master-slave模式的数据备份
* Redis支持数据的持久化，可以将内存中的数据保持在磁盘中，重启的时候可以再次加载进行使用,而Memecache把数据全部存在内存之中
* redis的速度比memcached快很多
* Memcached是多线程，非阻塞IO复用的网络模型；Redis使用单线程的IO复用模型

## Redis与Memcached的选择
终极策略： 使用Redis的String类型做的事，都可以用Memcached替换，以此换取更好的性能提升； 除此以外，优先考虑Redis；

> 使用redis好处
* 速度快，因为数据存在内存中，类似于HashMap，HashMap的优势就是查找和操作的时间复杂度都是O(1)
* 支持丰富数据类型，支持string，list，set，sorted set，hash
* 支持事务 ：redis对事务是部分支持的，如果是在入队时报错，那么都不会执行；在非入队时报错，那么成功的就会成功执行。
* 丰富的特性：可用于缓存，消息，按key设置过期时间，过期后将会自动删除

## Redis常见数据结构使用场景
### String:set,get,decr,incr,mget命令
String数据结构是简单的key-value类型，value其实不仅可以是String，也可以是数字。 常规key-value缓存应用； 常规计数：微博数，粉丝数等。

### Hash:hget,hset,hgetall
Hash是一个string类型的field和value的映射表，hash特别适合用于存储对象。 比如我们可以Hash数据结构来存储用户信息，商品信息等等。

### List:lpush,rpush,lpop,rpop,lrange
list就是链表，Redis list的应用场景非常多，也是Redis最重要的数据结构之一，比如微博的关注列表，粉丝列表，最新消息排行等功能都可以用Redis的list结构来实现。
Redis list的实现为一个双向链表，即可以支持反向查找和遍历，更方便操作，不过带来了部分额外的内存开销。

### Set:sadd,spop,smembers,sunion
set对外提供的功能与list类似是一个列表的功能，特殊之处在于set是可以自动排重的。
当你需要存储一个列表数据，又不希望出现重复数据时，set是一个很好的选择，并且set提供了判断某个成员是否在一个set集合内的重要接口，这个也是list所不能提供的。

在微博应用中，可以将一个用户所有的关注人存在一个集合中，将其所有粉丝存在一个集合。Redis可以非常方便的实现如共同关注、共同喜好、二度好友等功能。

### Sorted Set:zadd,zrange,zrem,zcard
和set相比，sorted set增加了一个权重参数score，使得集合中的元素能够按score进行有序排列。
在直播系统中，实时排行信息包含直播间在线用户列表，各种礼物排行榜，弹幕消息（可以理解为按消息维度的消息排行榜）等信息，适合使用Redis中的SortedSet结构进行存储。

## redis数据淘汰策略
redis 内存数据集大小上升到一定大小的时候，就会施行数据淘汰策略（回收策略）。redis 提供 6种数据淘汰策略：
* volatile-lru：从已设置过期时间的数据集（server.db[i].expires）中挑选最近最少使用的数据淘汰
* volatile-ttl：从已设置过期时间的数据集（server.db[i].expires）中挑选将要过期的数据淘汰
* volatile-random：从已设置过期时间的数据集（server.db[i].expires）中任意选择数据淘汰
* allkeys-lru：从数据集（server.db[i].dict）中挑选最近最少使用的数据淘汰
* allkeys-random：从数据集（server.db[i].dict）中任意选择数据淘汰
* no-enviction（驱逐）：禁止驱逐数据

## Redis的并发竞争
Redis为单进程单线程模式，采用队列模式将并发访问变为串行访问。Redis本身没有锁的概念，Redis对于多个客户端连接并不存在竞争，但是在Jedis客户端对Redis进行并发访问时会发生连接超时、数据转换错误、阻塞、客户端关闭连接等问题，这些问题均是由于客户端连接混乱造成。对此有2种解决方法：
* 客户端角度，为保证每个客户端间正常有序与Redis进行通信，对连接进行池化，同时对客户端读写Redis操作采用内部锁synchronized
* 服务器角度，利用setnx实现锁
> 对于第一种，需要应用程序自己处理资源的同步，可以使用的方法比较通俗，可以使用synchronized也可以使用lock；第二种需要用到Redis的setnx命令，但是需要注意一些问题

## Redis大量数据插入
使用正常模式的Redis 客户端执行大量数据插入不是一个好主意：因为一个个的插入会有大量的时间浪费在每一个命令往返时间上。使用管道（pipelining）是一种可行的办法，但是在大量插入数据的同时又需要执行其他新命令时，这时读取数据的同时需要确保请可能快的的写入数据。
如果我们需要生成一个10亿的`keyN -> ValueN’的大数据集，我们会创建一个如下的redis命令集的文件,一旦创建了这个文件，其余的就是让Redis尽可能快的执行。在以前我们会用如下的netcat命令执行
```shell
(cat data.txt; sleep 10) | nc localhost 6379 > /dev/null
```
然而这并不是一个非常可靠的方式，因为用netcat进行大规模插入时不能检查错误。从Redis 2.6开始redis-cli支持一种新的被称之为pipe mode的新模式用于执行大量数据插入工作。
```shell
//使用pipe mode模式的执行命令
cat data.txt | redis-cli --pipe
```

### pipe mode的工作原理
难点是保证redis-cli在pipe mode模式下执行和netcat一样快的同时，如何能理解服务器发送的最后一个回复。
这是通过以下方式获得：
* redis-cli –pipe试着尽可能快的发送数据到服务器
* 读取数据的同时，解析它
* 一旦没有更多的数据输入，它就会发送一个特殊的ECHO命令，后面跟着20个随机的字符。我们相信可以通过匹配回复相同的20个字符是同一个命令的行为
* 一旦这个特殊命令发出，收到的答复就开始匹配这20个字符，当匹配时，就可以成功退出了
* 同时，在分析回复的时候，我们会采用计数器的方法计数，以便在最后能够告诉我们大量插入数据的数据量

## Redis分区的优势、不足以及分区类型
分区的优势：
* 通过利用多台计算机内存的和值，允许我们构造更大的数据库
* 通过多核和多台计算机，允许我们扩展计算能力；通过多台计算机和网络适配器，允许我们扩展网络带宽

分区的不足：
涉及多个key的操作通常是不被支持的。举例来说，当两个set映射到不同的redis实例上时，你就不能对这两个set执行交集操作。
* 涉及多个key的redis事务不能使用。
* 当使用分区时，数据处理较为复杂，比如你需要处理多个rdb/aof文件，并且从多个实例和主机备份持久化文件。
* 增加或删除容量也比较复杂。redis集群大多数支持在运行时增加、删除节点的透明数据平衡的能力，但是类似于客户端分区、代理等其他系统则不支持这项特性。然而，一种叫做presharding的技术对此是有帮助的。

### 分区类型
Redis 有两种类型分区。 假设有4个Redis实例 R0，R1，R2，R3，和类似user:1，user:2这样的表示用户的多个key，对既定的key有多种不同方式来选择这个key存放在哪个实例中。也就是说，有不同的系统来映射某个key到某个Redis服务
* 范围分区：最简单的分区方式是按范围分区，就是映射一定范围的对象到特定的Redis实例。比如，ID从0到10000的用户会保存到实例R0，ID从10001到 20000的用户会保存到R1，以此类推

* 哈希分区：另外一种分区方法是hash分区。这对任何key都适用，也无需是object_name:这种形式，用一个hash函数将key转换为一个数字，比如使用crc32 hash函数。对key foobar执行crc32(foobar)会输出类似93024922的整数。
对这个整数取模，将其转化为0-3之间的数字，就可以将这个整数映射到4个Redis实例中的一个了。93024922 % 4 = 2，就是说key foobar应该被存到R2实例中。注意：取模操作是取除的余数，通常在多种编程语言中用%操作符实现。


## Redis常见性能问题和解决方案
* Master最好不要做任何持久化工作，如RDB内存快照和AOF日志文件
* 如果数据比较重要，某个Slave开启AOF备份数据，策略设置为每秒同步一次
* 为了主从复制的速度和连接的稳定性，Master和Slave最好在同一个局域网内
* 尽量避免在压力很大的主库上增加从库

## Redis与消息队列
不要使用redis去做消息队列，这不是redis的设计目标。但实在太多人使用redis去做去消息队列，redis的作者看不下去，另外基于redis的核心代码，另外实现了一个消息队列disque，部署、协议等方面都跟redis非常类似，并且支持集群，延迟消息等等,在做网站过程接触比较多的还是使用redis做缓存，比如秒杀系统，首页缓存等等。