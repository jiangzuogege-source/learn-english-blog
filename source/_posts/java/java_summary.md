---
title: Java常用基础知识
date: 2020-03-24 10:32:00
top: true
cover: false
keywords: java,spring,springboot,List,Set,Map,Queue,冒泡排序,选择排序,插入排序,二分查找,线程,同步锁,并发,VM调优,内存模型,JVM,JMM
summary: spring,springboot,List,Set,Map,Queue,冒泡排序,选择排序,插入排序,二分查找,线程,同步锁,并发,VM调优,内存模型,JVM,JMM
#coverImg: /images/1.jpg
copyright: false
tags: 
 - java
categories: 
 - 编程
---
 ## 基础
 ### String不可变
 String是final的，因此不能修改，所以诸如substring()、concat()这些方法，不会修改String变量存储的值。
 ```java
String s1="abc";
String s2="abc";
System.out.println(s1==s2);
System.out.println(s1.equals(s2));
//答案,先在常量池中创建"abc"，变量s1指向它,而后在创建s2时，由于常量池中已经存在"abc"，只需s2指向它，而不需要再创建。
true
true
``` 

#### String s1=new String("abc")创建了几个对象
new String("abc")先在常量池中查找，若没有则创建"abc"，而后通过new在堆内存中创建对象，把"abc"拷贝赋值。String定义为初始化一个新创建的 String 对象，表示一个与该参数相同的字符序列；换句话说，新创建的字符串是该参数字符串的一个副本。故创建常量池和堆内存中两个对象，两个对象的地址值不一样,也就是s1==new String("abc")//false

#### 字符串串联符号+
Java语言提供对字符串串联符号（”+”）和其他对象到字符串的转换的特殊支持。字符串串联是通过 StringBuilder（或 StringBuffer）类及其 append 方法实现的，字符串转换是通过 toString 方法实现的。
```
String s1="ab";
String s2="abc";
String s3=s1+"c";
System.out.println(s3==s2);
System.out.println(s3.equals(s2));
//答案
false
true
```

### List、Set、Map、Queue
List元素有序，可重复；Set元素无序，不可重复，Map双列集合，一次存一对键值对，键不能重复，Queue元素先进先出，不允许随机访问队列中的元素。在传统集合框架内部，除了 Hashtable 等同步容器，还提供了所谓的同步包装器（Synchronized Wrapper），我们可以调用 Collections 工具类提供的包装方法，来获取一个同步的包装容器（如 Collections.synchronizedMap），但是它们都是利用非常粗粒度的同步方式，在高并发情况下，性能比较低下。
并发包提供的线程安全容器类，它提供了: 各种并发容器，比如 ConcurrentHashMap、CopyOnWriteArrayList; 各种线程安全队列（Queue/Deque），如 ArrayBlockingQueue、SynchronousQueue; 各种有序容器的线程安全版本等。

#### List的实现类
ArrayList：数组实现, 查找快, 增删慢。由于是数组实现, 在增和删的时候会牵扯到数组增容, 以及拷贝元素。所以慢。数组是可以直接按索引查找, 所以查找时较快。
LinkedList：链表实现, 增删快, 查找慢。由于链表实现, 增加时只要让前一个元素记住自己就可以, 删除时让前一个元素记住后一个元素, 后一个元素记住前一个元素。 这样的增删效率较高。但查询时需要一个一个的遍历, 所以效率较低。
Vector：和ArrayList原理相同, 但线程安全, 效率略低和ArrayList实现方式相同, 但考虑了线程安全问题, 所以效率略低。

#### Set的实现类
HashSet：线程不安全，存取速度快。底层是以hash表实现的。
TreeSet：红-黑树的数据结构，默认对元素进行自然排序（String）。如果在比较的时候两个对象返回值为0，那么元素重复。
LinkedHashSet：会保存元素插入的顺序。

#### Map的实现类
HashMap：底层是哈希表数据结构，线程不安全。可以存入null键、null值。要保证键的唯一性，需要覆盖hashCode方法，和equals方法。
LinkedHashMap：基于哈希表又融入了链表，所以Map集合进行增删提高效率。
TreeMap：底层是二叉树数据结构。可以对map集合中的键进行排序。需要使用Comparable或者Comparator进行比较排序。return 0，来判断键的唯一性。
HashTable：底层是哈希表数据结构，线程是同步的，不可以存入null键，null值。效率较低，被ConcurrentHashMap替代。
ConcurrentHashMap：引入了分割(Segment)，把一个大的Map拆分成N个小的HashTable，保证同步的时候，锁住的不是整个Map，相对于HashTable提高了多线程环境下的性能。
	
#### Queue的实现类
PriorityQueue：保存队列元素的顺序并不是按照加入队列的顺序，而是按照队列元素的大小进行重新排序，这点从它的类名也可以看出来。
Deque：代表一个"双端队列"，双端队列可以同时从两端来添加、删除元素，因此Deque的实现类既可以当成队列使用、也可以当成栈使用。
ArrayDeque：是一个基于数组的双端队列，和ArrayList类似，它们的底层都采用一个动态的、可重分配的Object[]数组来存储集合元素，当集合元素超出该数组的容量时，系统会在底层重新分配一个Object[]数组来存储集合元素。
LinkedList:链表实现, 增删快, 查找慢。

### char类型变量能存储中文
char型变量是用来存储Unicode编码的字符的，unicode编码字符集中包含了汉字，所以，char型变量中当然可以存储汉字啦。不过，如果某个特殊的汉字没有被包含在unicode编码字符集中，那么，这个char型变量中就不能存储这个特殊汉字。补充说明：unicode编码占用两个字节，所以，char类型的变量也是占用两个字节。	

### final, finally, finalize
final修饰符（关键字）如果一个类被声明为final，意味着它不能再派生出新的子类，不能作为父类被继承。
finally在异常处理时提供 finally 块来执行任何清除操作。如果抛出一个异常，那么相匹配的 catch 子句就会执行，然后控制就会进入 finally 块（如果有的话）。
finalize方法名。Java 技术允许使用 finalize() 方法在垃圾收集器将对象从内存中清除出去之前做必要的清理工作。这个方法是由垃圾收集器在确定这个对象没有被引用时对这个对象调用的。它是在 Object 类中定义的，因此所有的类都继承了它。子类覆盖 finalize() 方法以整理系统资源或者执行其他清理工作。finalize() 方法是在垃圾收集器删除对象之前对这个对象调用的。

### 重载和重写的区别
override（重写）： 方法名、参数、返回值相同，子类方法不能缩小父类方法的访问权限；子类方法不能抛出比父类方法更多的异常(但子类方法可以不抛出异常)；存在于父类和子类之间；方法被定义为final不能被重写—--体现类的继承性
overload（重载）：参数类型、个数、顺序至少有一个不相同，不能重载只有返回值不同的方法名；存在于父类和子类、同类中----体现类的多态性


## 排序
冒泡算法，每次比较如果发现较大的元素在后面，就交换两个相邻的元素。而选择排序算法的改进在于：先并不急于调换位置，先从Aarray[0]开始逐个检查，看哪个数最大就记下该数所在的位置j，等一躺扫描完毕，再把Array[max](max=j)和A[0]对调，这时Array[0]到Array[6]中最大的数据就换到了最前面的位置。所以，选择排序每扫描一遍数组，只需要一次真正的交换，而冒泡可能需要很多次，比较的次数是一样的。插入排序算法比冒泡快一倍，比选择排序略快一点。

### 冒泡排序
数组元素从左至右两两比较，较大值移到右边，每一趟比较后，最大值会移到最右边。
```java
public void bubbleSort(int[] arr){
    int n = arr.length - 1;
    for(int i = 0; i < n; i++){//比较多少趟
        for(int j = 0; j < n - i; j++){
            //每一趟比较右边都多一个最大值，因此要-i
            if( arr[j] > arr[j+1] ){
                //交换位置
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }           
        }
    }
}
```

### 选择排序
每次从数组中选择最小的元素，置换到有序组中。
```java
public void selectSort(int[] arr){
    int n = arr.length;
    for(int i = 0; i < n; i++){
        int min = i;//初始化最小值的索引
        for(int j = i+1; j < n; j++){
            if(arr[j]<arr[min]){
                min = j;//记录最小值的索引
            }
        }
        //交换值，有变化时才交换
		if(i != min){
         	int temp = arr[i];
        	arr[i] = arr[min];
        	arr[min] = temp;
		}
    }
}
```

### 插入排序
逻辑上把数组分成有序组和待插入组，每次从待插入组取出一个元素，在有序组中找到插入位置然后插入。
```java
public void insertSort(int[] arr){
    int n = arr.length;
    for(int i = 1; i < n; i++){         //遍历待插入组
        int temp = arr[i];              //待插入数
        int j = i - 1;                  //有序组最后一个元素的索引
        while(j>=0 && temp<arr[j]){    
 			//遍历有序组，如果待插入数小于当前比较的有序组的数x
            arr[j+1] = arr[j];         
 			//有序组的数x的值往右移动一位，腾出插入位置
            j--;                       
 			//下标移动到下一个待比较的有序组的数
        }
        arr[j+1] = temp;                
        //遍历一趟有序组后j+1表示的下标，就是temp应插入的位置
    }
}
```

### 二分查找
```java
public int binarySearch(int[] arr, int key){
    int lo = 0;
    int hi = arr.length - 1;
    while(lo<=hi){
        int mid = lo + (hi-lo)/2;
        if(key < arr[mid]) hi = mid - 1;
        else if(key > arr[mid]) lo = mid + 1;
        else return mid;        
    }
    return -1;
}
```

## 线程、同步锁、并发
### 创建线程的三种方式
继承Thread类创建线程类，定义Thread类的子类，并重写该类的run方法，该run方法的方法体就代表了线程要完成的任务，因此把run()方法称为执行体；创建Thread子类的实例，即创建了线程对象；调用线程对象的start()方法来启动该线程。
通过Runnable接口创建线程类，定义runnable接口的实现类，并重写该接口的run()方法，该run()方法的方法体同样是该线程的线程执行体；创建 Runnable实现类的实例，并依此实例作为Thread的target来创建Thread对象，该Thread对象才是真正的线程对象；调用线程对象的start()方法来启动该线程。
通过Callable和Future创建线程，创建Callable接口的实现类，并实现call()方法，该call()方法将作为线程执行体，并且有返回值；创建Callable实现类的实例，使用FutureTask类来包装Callable对象，该FutureTask对象封装了该Callable对象的call()方法的返回值；使用FutureTask对象作为Thread对象的target创建并启动新线程；调用FutureTask对象的get()方法来获得子线程执行结束后的返回值。

### synchronized和Lock的异同点
针对Synchronized获取锁的方式，Jvm使用了锁升级的优化方式，就是先使用偏向锁优先同一线程再次获取锁，如果失败，就升级为Cas轻量级锁，如果再失败会短暂自旋，防止线程被系统挂起。最后如果以上都失败就是升级为重量级锁。
Aqs有一个State标记位，值为1时表示有线程占用，其他线程需要进入到同步队列等待。同步队列是一个双向链表。当获得锁的线程需要等待某个条件时，会进入Condition的等待队列，等待队列可以有多个。当Condition条件满足时，线程会从等待队列重新进入到同步队列进行获取锁的竞争。Reentrantlock就是基于Aqs实现的，Reentrantlock内部有公平锁和非公平锁两种实现，差别就在于新来的线程会不会比已经在同步队列中的等待线程更早获得锁。和Reentrantlock实现方式类似，Semaphore也是基于aqs，差别在于Reentrantlock是独占锁，Semaphore是共享锁。
* synchronized 代码块不能够保证进入访问等待的线程的先后顺序；
* 不能够传递任何参数给一个synchronized 代码块的入口。因此，对于synchronized 代码块的访问等待设置超时时间是不可能的事情。
* synchronized 块必须被完整地包含在单个方法里。而一个 Lock 对象可以把它的 lock() 和 unlock() 方法的调用放在不同的方法里。

### wait()和sleep()
wait():释放资源，释放锁。是Object的方法；
sleep():释放资源，不释放锁。是Thread的方法。

### 线程池的5种方式
线程池通过复用线程，避免线程频繁创建和销毁。
* newFixedThreadPool(int nThreads)：创建一个固定长度的线程池，每当提交一个任务就创建一个线程，直到达到线程池的最大数量，特点是线程数固定，使用无界队列，适用于任务数量不均匀的场景、对内存压力不敏感，但系统负载比较敏感的场景；
* newCachedThreadPool()：创建一个可缓存的线程池，如果线程池的规模超过了处理需求，将自动回收空闲线程，而当需求增加时，则可以自动添加新线程，线程池的规模不存在任何限制，特点是不限制线程数，适用于要求低延迟的短期任务场景；
* newSingleThreadExecutor():这是一个单线程的Executor，它创建单个工作线程来执行任务，如果这个线程异常结束，会创建一个新的来替代它；它的特点是能确保依照任务在队列中的顺序来串行执行，适用于需要异步执行但需要保证任务顺序的场景；
* newScheduledThreadPool(int corePoolSize)：创建了一个固定长度的线程池，而且以延迟或定时的方式来执行任务，类似于Timer，支持按固定频率定期执行和按固定延时定期执行两种方式；
* 工作窃取线程池，使用的ForkJoinPool，是固定并行度的多任务队列，适合任务执行时长不均匀的场景。
                                                                                                                         
### 线程安全问题
线程安全是指要控制多个线程对某个资源的有序访问或修改，而在这些线程之间没有产生冲突。在Java里，线程安全一般体现在两个方面：
* 多个thread对同一个java实例的访问（read和modify）不会相互干扰，它主要体现在关键字synchronized。
* 每个线程都有自己的字段，而不会在多个线程之间共享。它主要体现在java.lang.ThreadLocal类，而没有Java关键字支持，如像static、transient那样。


### 线程同步与互斥
解决线程同步与互斥的主要方式是Cas、Synchronized、和Lock，Cas是属于乐观锁的一种实现，是一种轻量级锁，Juc中很多工具类的实现就是基于Cas。Cas操作是线程在读取数据时不进行加锁，在准备写回数据时，比较原值是否修改，若未被其他线程修改则写回，若已被修改，则重新执行读取流程。
Cas容易出现Aba问题，如果线程T1读取值A之后，发生过两次写入，先由线程T2写回了b，又由T3写回了A，此时T1在写回比较时，值还是A，就无法判断是否发生过修改。Aba问题不一定会影响结果，但还是需要防范，解决的办法可以增加额外的标志位或者时间戳。

### 线程中断interrupt
* 通过volatile类型的域来保存取消状态
* 静态的interrupted来中断或者恢复中断状态
如果此线程处于阻塞状态(比如调用了wait方法，io等待)，则会立马退出阻塞，并抛出InterruptedException异常，线程就可以通过捕获InterruptedException来做一定的处理，然后让线程退出。
如果此线程正处于运行之中，则线程不受任何影响，继续运行，仅仅是线程的中断标记被设置为true。所以线程要在适当的位置通过调用isInterrupted方法来查看自己是否被中断，并做退出操作。 

### 通过 future 的cancel取消线程
* 使用shutdown()和shutdownNow()
* shutdown()，将线程池状态置为SHUTDOWN，并不会立即停止，停止接收外部submit的任务，内部正在跑的任务和队列里等待的任务，会执行完；等到第二步完成后，才真正停止。
* shutdownNow()，将线程池状态置为STOP。企图立即停止，事实上不一定，跟shutdown()一样，先停止接收外部提交的任务，忽略队列里等待的任务，尝试将正在跑的任务interrupt中断，返回未执行的任务列表。
* stop方法终止线程
使用thread.stop()来强行终止线程，但是stop方法是很危险的，就象突然关闭计算机电源，而不是按正常程序关机一样，可能会产生不可预料的结果。thread.stop()调用之后，创建子线程的线程就会抛出ThreadDeatherror的错误，并且会释放子线程所持有的所有锁。
```java
    public class PrimeProducer extends Thread {
	private final BlockingQueue<BigInteger> queue;
	public PrimeProducer(BlockingQueue<BigInteger> queue) {
		this.queue = queue;
	}
	@Override
	public void run() {
		try {
			BigInteger p = BigInteger.ONE;
			while(!Thread.currentThread().isInterrupted()) 
                //用线程的状态来检查
				queue.put(p = p.nextProbablePrime());
		} catch (InterruptedException e) {
			//中断将线程退出
		}
	}
	public void cancel() { 
	    interrupt();
    }
}
```
```java
    Future<?> future = executorService.submit(runnable);
    try {
        future.get(timeout,timeUnit);
     } catch (ExecutionException e) {
        e.printStackTrace();
     } catch (TimeoutException e) {
        e.printStackTrace();
     }finally {
        future.cancel(true);
     }
```
```java
 /**
  * @Description: 一个仅运行一秒的素数生成器
  * 线程的取消与关闭  通过cancel方法将设置标志 并且主循环会检车这个标志
  * 为了使这个过程可靠的工作  标志cancelled必须为  volatile
 */
 public class CancelVolatile implements Runnable {
     private final List<BigInteger> pri = new ArrayList<BigInteger>();
     private volatile boolean cancelled;
     public void run() {
         BigInteger p = BigInteger.ONE;
         while (!cancelled) {
             p = p.nextProbablePrime();
             synchronized (this) {
                 pri.add(p);
             }
         }
     }
     private void cancel() {
         cancelled = true;
     }
     private synchronized List<BigInteger> get() {
         return new ArrayList<BigInteger>(pri);
         
          }
             public static void main(String[] args) {
                 CancelVolatile cancelVolatile = new CancelVolatile();
                 new Thread(cancelVolatile).start();
                 try {
                     SECONDS.sleep(1);
                 } catch (InterruptedException e) {
                     e.printStackTrace();
                 } finally {
                     cancelVolatile.cancel();
                 }
                 System.out.println(cancelVolatile.get());
             }
}
//中断将线程退出
public class PrimeProducer extends Thread {
	private final BlockingQueue<BigInteger> queue;
	public PrimeProducer(BlockingQueue<BigInteger> queue) {
		this.queue = queue;
	}
	@Override
	public void run() {
		try {
			BigInteger p = BigInteger.ONE;
			while(!Thread.currentThread().isInterrupted()) 
                //用线程的状态来检查
				queue.put(p = p.nextProbablePrime());
		} catch (InterruptedException e) {
			//中断将线程退出
		}
	}
	public void cancel() { interrupt();
}
```

## 数据库使用
### JDBC创建流程
加载JDBC驱动程序, 成功加载后，会将Driver类的实例注册到DriverManager类中；提供JDBC连接的URL；创建数据库的连接；创建一个Statement; 执行SQL语句；处理结果；关闭JDBC对象。
```SQL
//取10条随机记录
// 一张用户表有1000万条记录，主键为自增ID，从中取10条随机记录
SELECT * FROM tablename WHERE id> ROUND(10000000*RAND()-10) LIMIT 10;
//随机获取10条连续的数据
SELECT * 
FROM `table1` AS t1 JOIN (SELECT ROUND(RAND() * (SELECT MAX(id) FROM `table1`)) AS id) AS t2 
WHERE t1.id >= t2.id 
ORDER BY t1.id ASC LIMIT 10
```

### truncate与delete和drop
* drop删除表的数据和结构，释放空间，DDL语言，DDL语言都是自动提交的且不能回滚；
* truncate删除表的数据，保留结构，释放空间，DDL语言，不能回滚；
* delete删除表的数据，保留结构，不释放空间，DML语言，可回滚。

### 乐观锁和悲观锁
* 悲观锁就是for update，锁定查询的行。
* 乐观锁就是version字段，比较跟上一次的版本号，如果一样则更新，如果失败则要重复读-比较-写的操作。

本质来说，就是悲观锁认为总会有人抢我的。乐观锁就认为，基本没人抢。Innodb引擎为了保证事务的一致性、隔离性以及数据在并发读-读、读-写、写-写的情况下的正确性，用到的技术有：悲观锁（表锁、行锁、GAP间隙锁、next-key锁(行锁+GAP锁)）、乐观锁（MVCC+行锁 或 MVCC+CAS）、MVCC（快照读、当前读）。

MySQL/InnoDB定义的4种隔离级别：
* Read Uncommited：可以读取未提交记录。此隔离级别，不会使用，忽略。
* Read Committed (RC)：针对当前读，RC隔离级别保证对读取到的记录加锁 (记录锁)，存在幻读现象。
* Repeatable Read (RR)：针对当前读，RR隔离级别保证对读取到的记录加锁 (记录锁)，同时保证对读取的范围加锁，新的满足查询条件的记录不能够插入 (间隙锁)，不存在幻读现象。
* Serializable：从MVCC并发控制退化为基于锁的并发控制。不区别快照读与当前读，所有的读操作均为当前读，读加读锁 (S锁)，写加写锁 (X锁)。Serializable隔离级别下，读写冲突，因此并发度急剧下降，在MySQL/InnoDB下不建议使用。

### 什么时候使用索引
* 经常出现在group by,order by和distinc关键字后面的字段。
* 经常与其他表进行连接的表，在连接字段上应该建立索引。
* 经常出现在Where子句中的字段。
* 经常出现用作查询选择的字段。

### Redis五种数据类型
string（字符串），hash（哈希），list（列表），set（集合）及zset(sorted set：有序集合)。

## Spring知识
SpringBoot系列知识：{% post_link spring/spring-boot-inside %}
### SpringMVC 运行周期
> * dispatcherServlet会初始化HandlerMapping（注：通过它来处理客户端请求到各个Controller处理器的映射）
> * 然后初始化HandlerAdapter（注：HandlerMapping会根据它来调用Controller里需要被执行的方法）
> * 再初始化handlerExceptionResolver（注：spring mvc处理流程中，如果有异常抛出，会交给它来进行异常处理）
> * 最后会初始化ViewResolver （注：HandlerAdapter会把Controller中调用返回值最终包装成ModelAndView,ViewResolver会检查其中的view，如果view是一个字符串，它就负责处理这个字符串并返回一个真正的View，如果view是一个真正的View则不会交给它处理）

### Spring IOC 容器
Spring IOC 负责创建对象，管理对象（通过依赖注入（DI），装配对象，配置对象，并且管理这些对象的整个生命周期。
依赖注入，是IOC的一个方面，是个通常的概念，它有多种解释。这概念是说你不用创建对象，而只需要描述它如何被创建。
Spring beans 是那些形成Spring应用的主干的java对象。它们被Spring IOC容器初始化，装配，和管理。这些beans通过容器中配置的元数据创建。Spring框架中的单例bean不是线程安全的，采用ThreadLocal进行封装，有状态的Bean就能够以singleton的方式在多线程中正常工作了。
Bean 工厂是工厂模式的一个实现，提供了控制反转功能，用来把应用的配置和依赖从正真的应用代码中分离。最常用的BeanFactory 实现是XmlBeanFactory 类。


## Java 反射机制,动态代理
反射，它就像是一种魔法，引入运行时自省能力，赋予了 Java 语言令人意外的活力，通过运行时操作元数据或对象，Java 可以灵活地操作运行时才能确定的信息。 而动态代理，则是延伸出来的一种广泛应用于产品开发中的技术，很多繁琐的重复编程，都可以被动态代理机制优雅地解决。

## VM调优
### 内存模型-JVM和JMM
jvm内存模型主要指运行时的数据区，包括5个部分，栈、本地方法栈、程序计数器这三个部分都是线程独占的，堆、方法区是各个线程共享的内存区域
* 栈也叫方法栈，是线程私有的，线程在执行每个方法时都会同时创建一个栈帧，用来存储局部变量表、操作栈、动态链接、方法出口等信息。调用方法时执行入栈，方法返回时执行出栈；
* 本地方法栈与栈类似，也是用来保存线程执行方法时的信息，不同的是，执行java方法使用栈，而执行native方法使用本地方法栈；
* 程序计数器保存着当前线程所执行的字节码位置，每个线程工作时都有一个独立的计数器。程序计数器为执行java方法服务，执行native方法时，程序计数器为空；
* 堆是jvm管理的内存中最大的一块，堆被所有线程共享，目的是为了存放对象实例，几乎所有的对象实例都在这里分配。当堆内存没有可用的空间时，会抛出OOM异常。根据对象存活的周期不同，jvm把堆内存进行分代管理，由垃圾回收器来进行对象的回收管理。
* 方法区也是各个线程共享的内存区域，又叫非堆区。用于存储已被虚拟机加载的类信息、常量、静态变量、即时编译器编译后的代码等数据，jdk1.7中的永久代和1.8中的metaspace都是方法区的一种实现。

jmm内存模型：jmm是java内存模型，主要目标是定义程序中变量的访问规则，所有的共享变量都存储在主内存中共享。每个线程有自己的工作内存，工作内存中保存的是主内存中变量的副本，线程对变量的读写等操作必须在自己 的工作内存中进行，而不能直接读写主内存中的变量。

jmm需要提供原子性、可见性、有序性的保证，jmm保证对除long和double外的基础数据类型的读写操作是原子性的。另外关键字Synchronized也可以提供原子性保证。Synchronized的原子性是通过java的两个高级的字节码指令monitorenter和monitorexit来保证的。

jmm可见性的保证，一个是通过Synchronized，另外一个就是volatile。volatile强制变量的赋值会同步刷新回主内存，强制变量的读取会从主内存重新加载，保证不同的线程总是能够看到该变量的最新值。

jmm对有序性的保证，主要通过volatile和一系列happens-before原则。volatile的另一个作用就是阻止指令重排序，这样就可以保证变量读写的有序性。

happens-before原则: 程序顺序原则，即一个线程内必须保证语义串行性；锁规则，即对同一个锁的解锁一定发生在再次加锁之前；此外还包括happens-before原则的传递性、线程启动、中断、终止规则等。

### 类加载机制-生命周期
类的加载分为加载、链接、初始化，其中链接又包括验证、准备、解析三步。
* 加载是文件到内存的过程。通过类的完全限定名查找此类字节码文件，并利用字节码文件创建一个Class对象。
* 链接：验证是对类文件内容验证。目的在于确保Class文件符合当前虚拟机要求，不会危害虚拟机自身安全。
> 主要包括四种：
> * 文件格式验证，元数据验证，字节码验证，符号引用验证
> * 准备阶段是进行内存分配，为类变量也就是类中由static修饰的变量分配内存，并且设置初始值，这里要注意，初始值是0或者null，而不是代码中设置的具体值，代码中设置的值是在初始化阶段完成的
> * 另外这里也不包含用final修饰的静态变量，因为final在编译的时候就会分配了；解析主要是解析字段、接口、方法。主要是将常量池中的符号引用替换为直接引用的过程
> * 直接引用就是直接指向目标的指针、相对偏移量等
* 初始化：主要完成静态块执行与静态变量的赋值。这是类加载最后阶段，若被加载类的父类没有初始化，则先对父类进行初始化。
#### 注意
* 只有对类主动使用时，才会进行初始化，初始化的触发条件包括创建类的实例的时候、访问类的静态方法或者静态变量的时候、Class.forName()反射类的时候、或者某个子类被初始化的时候。
* 类的生命周期，就是从类的加载到类实例的创建与使用，再到类对象不再被使用时可以被GC卸载回收。
* 这里要注意一点，由java虚拟机自带的三种类加载器（根类加载器、扩展类加载器、系统类加载器）加载的类在虚拟机的整个生命周期中是不会被卸载的，只有用户自定义的类加载器所加载的类才可以被卸载。其中根类加载器是使用C++编写的，JVM不能够也不允许程序员获取该类，Java中所有的基本数据类型都是由根加载器加载的，JDK1.5以后将void纳入为基本数据类型。根类加载器加载java home中lib目录下的类，扩展加载器负责加载ext目录下的类，系统加载器加载classpath指定目录下的类。

### GC算法
在什么时候：
* 新生代有一个Eden区和两个survivor区，首先将对象放入Eden区，如果空间不足就向其中的一个survivor区上放，如果仍然放不下就会引发一次发生在新生代的minor GC，将存活的对象放入另一个survivor区中，然后清空Eden和之前的那个survivor区的内存。在某次GC过程中，如果发现仍然又放不下的对象，就将这些对象放入老年代内存里去；
* 大对象以及长期存活的对象直接进入老年区。
* 当每次执行minor GC的时候应该对要晋升到老年代的对象进行分析，如果这些马上要到老年区的老年对象的大小超过了老年区的剩余大小，那么执行一次Full GC以尽可能地获得老年区的空间。
对什么东西：从GC Roots搜索不到，而且经过一次标记清理之后仍没有复活的对象。
做什么：新生代：复制清理；老年代：标记-清除和标记-压缩算法；永久代：存放Java中的类和加载类的类加载器本身。
                                                                           