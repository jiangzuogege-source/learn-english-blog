---
title: MongoDB基础知识
date: 2020-04-10 15:09:00
top: false
cover: false
keywords: MongoDB是一个文档数据库，提供好的性能，领先的非关系型数据库。采用BSON存储文档数据。2007年10月，MongoDB由10gen团队所发展。2009年2月首度推出。
#summary: 内容作为摘要
#coverImg: /images/1.jpg
copyright: false
tags: 
 - MongoDB
categories: 
 - 工具
---
## MongoDB
MongoDB是一个文档数据库，提供好的性能，领先的非关系型数据库。采用BSON存储文档数据。2007年10月，MongoDB由10gen团队所发展。2009年2月首度推出。
MongoDB用c++编写的,流行的开源数据库MySQL也是用C++开发的。C++1983年发行是一种使用广泛的计算机程序设计语言。
```js
//BSON格式
{  
  "name":"huangz",  
  "age":20,  
  "sex":"male"  
}  
{    
  "name":"jack",  
  "class":3,  
  "grade":3  
} 
```

## MongoDB的优势
* 面向集合(Collection)和文档(document)的存储，以JSON格式的文档保存数据。
* 高性能，支持Document中嵌入Document减少了数据库系统上的I/O操作以及具有完整的索引支持，支持快速查询
* 高效的传统存储方式：支持二进制数据及大型对象
* 高可用性，数据复制集，MongoDB 数据库支持服务器之间的数据复制来提供自动故障转移（automatic failover）
* 高可扩展性，分片(sharding)将数据分布在多个数据中心,MongoDB支持基于分片键创建数据区域.
* 丰富的查询功能, 聚合管道(Aggregation Pipeline)、全文搜索(Text Search)以及地理空间查询(Geospatial Queries)
* 支持多个存储引擎,WiredTiger存储引、In-Memory存储引擎

## MongoDB中的key命名规则
```
'\0″不能使用
带有'.'号，'_'号和'$'号前缀的Key被保留
大小写有区别，Age不同于age
同一个文档不能有相同的Key
除了上面几条规则外，其他所有UTF-8字符都可以使用
```

## MongoDB在java中的数据类型
| 类型 | 解析|
| ---------- | --------------------------|
|String	|字符串。存储数据常用的数据类型。在 MongoDB 中，UTF-8 编码的字符串才是合法的|
|Integer|整型数值。用于存储数值。根据你所采用的服务器，可分为 32 位或 64 位|
|Double|双精度浮点值。用于存储浮点值|
|Boolean|布尔值。用于存储布尔值（真/假）|
|Arrays|用于将数组或列表或多个值存储为一个键|
|Datetime|记录文档修改或添加的具体时间|

## MongoDB特有数据类型
| 类型 | 解析|
| ---------- | --------------------------|
|ObjectId	|用于存储文档 id,ObjectId是基于分布式主键的实现MongoDB分片也可继续使用|
|Min/Max Keys|将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比|
|Code|用于在文档中存储 JavaScript代码|
|Regular Expression|用于在文档中存储正则表达式|
|Binary Data|二进制数据。用于存储二进制数据|
|Null|用于创建空值|
|Object|用于内嵌文档|

### "ObjectID"组成部分
一共有四部分组成:时间戳、客户端ID、客户进程ID、三个字节的增量计数器
_id是一个 12 字节长的十六进制数，它保证了每一个文档的唯一性。在插入文档时，需要提供_id。如果你不提供，那么 MongoDB 就会为每一文档提供一个唯一的 id。_id的头 4 个字节代表的是当前的时间戳，接着的后 3 个字节表示的是机器 id 号，接着的 2 个字节表示 MongoDB 服务器进程 id，最后的 3 个字节代表递增值。

## MongoDB概念
* 集合：集合就是一组 MongoDB 文档。它相当于关系型数据库（RDBMS）中的表这种概念。集合位于单独的一个数据库中。一个集合内的多个文档可以有多个不同的字段。一般来说，集合中的文档都有着相同或相关的目的。
* 文档：文档由一组key value组成。文档是动态模式,这意味着同一集合里的文档不需要有相同的字段和结构。在关系型数据库中table中的每一条记录相当于MongoDB中的一个文档。

|MongoDB|关系数据库|
| ---------- | ----|
|Database|Database|
|Collection|Table|
|Document|Record/Row|
|Field|Column|
|Embedded Documents|Table join|

## MongoDB命令
```bash
use database_name	#切换数据库
db.myCollection.find().pretty()	#格式化打印结果
db.getCollection(collectionName).find()	#修改Collection名称
show dbs  #查看数据库列表,collections
db.adminCommand(“connPoolStats”)  #查看使用MongoDB的连接
db.collectionName.insert({"key":"value"}) #在集合中插入一个文档
db.collectionName.save({"key":"value"})   #在集合中插入一个文档
db.collectionName.update({key:value},{$set:{newkey:newValue}})  #更新集合中的文档
db.dropDatabase()   #删除已有数据库
db.collectionName.remove({key:value})   #删除文档
show collections    #查看一个已经创建的集合
db.CollectionName.drop()     #删除一个集合
db.collectionName.createIndex({columnName:1})   #添加索引
db.foo.createIndex({firstname:1,lastname:-1},{unieap:true})
db.collectionName.find({key:value})     #查询集合中的文档
db.mycol.find({key1:value1, key2:value2}).pretty()  #AND条件查询
#OR条件查询
db.mycol.find(
   {
      $or: [
         {key1: value1}, {key2:value2}
      ]
   }
).pretty()
# 条件
$gt ---- >
$lt ---- <
$gte ---- >=
$lte ---- <=
$ne ---- != 、<>
$in ---- in
$nin ---- not in
$all ---- all
$or ---- or
$not ---- 反匹配

db.connectionName.find({key:value}).sort({columnName:1})    #排序
db.COLLECTION_NAME.aggregate(AGGREGATE_OPERATION)       #聚合操作

use admin
db.addUser('Diana','123″,true) #参数分别为 用户名、密码、是否只读
db.system.users.find()  #查看用户列表
db.auth('Diana','123')  #用户认证
db.removeUser('Diana')  #删除用户
show users  #查看所有用户
db.printReplicationInfo()   #查看主从复制状态
db.repairDatabase()     #修复数据库
db.printCollectionStats()   #查看各个collection的状态
db.copyDatabase('Dianatest','temp','127.0.0.1″) #拷贝数据库
```

## MongoDB副本集
在MongoDB中副本集由一组MongoDB实例组成，包括一个主节点多个次节点，MongoDB客户端的所有数据都写入主节点(Primary),副节点从主节点同步写入数据，以保持所有复制集内存储相同的数据，提高数据可用性。

## 空值null
对于对象用户而言，可以添加，但是，用户不能添加空值到数据库从集，因为空值不是对象，然而用户能够添加空对象{}。

## MongoDB中使用分析器
数据库分析工具(Database Profiler)会针对正在运行的mongod实例收集数据库命令执行的相关信息。包括增删改查的命令以及配置和管理命令。分析器(profiler)会写入所有收集的数据写到 system.profile集合——一个capped集合在管理员数据库。分析器默认是关闭的你能通过per数据库或per实例开启。

## 如何执行事务/加锁
mongodb没有使用传统的锁或者复杂的带回滚的事务,因为它设计的宗旨是轻量,快速以及可预计的高性能.可能把它类比成mysql myisam的自动提交模式，通过精简对事务的支持，性能得到了提升，特别是在一个可能会穿过多个服务器的系统里。

## 操作不会立刻fsync到磁盘
不会,磁盘写操作默认是延迟执行的.写操作可能在两三秒(默认在60秒内)后到达磁盘，通过 syncPeriodSecs 启动参数，可以进行配置.例如,如果一秒内数据库收到一千个对一个对象递增的操作,仅刷新磁盘一次.

## MongoDB索引
索引用于高效的执行查询.没有索引MongoDB将扫描查询整个集合中的所有文档这种扫描效率很低，需要处理大量数据。索引是一种特殊的数据结构，将一小块数据集保存为容易遍历的形式。索引能够存储某种特殊字段或字段集的值，并按照索引指定的方式将字段值进行排序。
* 单字段索引(Single Field Indexes)
* 复合索引(Compound Indexes)
* 多键索引(Multikey Indexes)
* 全文索引(text Indexes)
* Hash 索引(Hash Indexes)
* 通配符索引(Wildcard Index)
* 2dsphere索引(2dsphere Indexes)

### MongoDB在A:{B,C}上建立索引,查询A:{B,C}和A:{C,B}
由于MongoDB索引使用B-tree树原理，只会在A:{B,C}上使用索引

## 什么是聚合
聚合操作能够处理数据记录并返回计算结果。聚合操作能将多个文档中的值组合起来，对成组数据执行各种操作，返回单一的结果。它相当于 SQL 中的 count(*) 组合 group by。对于 MongoDB 中的聚合操作，应该使用aggregate()方法。

## MongoDB分片
分片sharding是将数据水平切分到不同的物理节点。当应用数据越来越大的时候，数据量也会越来越大。当数据量增长 时，单台机器有可能无法存储数据或可接受的读取写入吞吐量。利用分片技术可以添加更多的机器来应对数据量增加 以及读写操作的要求。

## 块移动操作(moveChunk)失败了，不需要手动清除部分转移的文档
移动操作是一致(consistent)并且是确定性的(deterministic),一次失败后，移动操作会不断重试。当完成后，数据只会出现在新的分片里(shard)

## 数据在什么时候才会扩展到多个分片(Shard)里
MongoDB 分片是基于区域(range)的。所以一个集合(collection)中的所有的对象都被存放到一个块(chunk)中,默认块的大小是 64Mb。当数据容量超过64 Mb，才有可能实施一个迁移，只有当存在不止一个块的时候，才会有多个分片获取数据的选项。

## Shard停止或很慢
如果一个分片停止了，除非查询设置了 “Partial” 选项，否则查询会返回一个错误。如果一个分片响应很慢，MongoDB 会等待它的响应。

## 什么是Arbiter
仲裁节点不维护数据集。仲裁节点的目的是通过响应其他副本集节点的心跳和选举请求来维护副本集中的仲裁

## 复制集节点类型
* 优先级0型(Priority 0)节点
* 隐藏型(Hidden)节点
* 延迟型(Delayed)节点
* 投票型(Vote)节点以及不可投票节点

## 启用备份故障恢复需要多久
从备份数据库声明主数据库宕机到选出一个备份数据库作为新的主数据库将花费10到30秒时间.这期间在主数据库上的操作将会失败–包括写入和强一致性读取(strong consistent read)操作.然而,即使在这段时间里,你还能在第二数据库上执行最终一致性查询(eventually consistent query)(在slaveok模式下).

## 哪些场景使用MongoDB
规则:如果业务中存在大量复杂的事务逻辑操作,则不要用MongoDB数据库;在处理非结构化 / 半结构化的大数据使用MongoDB,操作的数据类型为动态时也使用MongoDB
> 比如：
* 内容管理系统，切面数据、日志记录
* 移动端Apps：O2O送快递骑手、快递商家的信息（包含位置信息）
* 数据管理，监控数据
* 游戏场景：使用Mongodb存储游戏用户信息，用户的装备，机分等直接以内嵌文档的形式存储，方便查询和更新。
* 物流场景：使用Mongodb存储订单信息，订单状态在运送过程中会不断更新，以Mongodb内嵌数组的形式存储，一次查找就能把订单所有的变更读取出来。
* 社交场景：使用Mongodb存储用户信息，以及用户发表的朋友圈信息，通过地理位置索引实现附近的人，地点等功能。

## MongoDB要注意的问题
因为MongoDB是全索引的，所以它直接把索引放在内存中，因此最多支持2.5G的数据。如果是64位的会更多。因为没有恢复机制，因此要做好数据备份。因为默认监听地址是127.0.0.1，因此要进行身份验证，否则不够安全；如果是自己使用，建议配置成localhost主机名