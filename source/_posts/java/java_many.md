---
title: Java多线程和高并发
date: 2020-03-30 14:50:00
top: true
cover: false
#keywords: 内容作为摘要
#summary: 内容作为摘要
#coverImg: /images/1.jpg
copyright: false
tags: 
 - java
categories: 
 - 编程
---
## volatile
 volatile 是一种轻量级的同步机制。保证数据可见性，不保证原子性，禁止指令重排序
 
## Java 内存模型
 JVM运行程序的实体是线程，每个线程创建时 JVM 都会为其创建一个工作内存，是线程的私有数据区域。JMM中规定所有变量都存储在主内存，主内存是共享内存。线程对变量的操作在工作内存中进行，首先将变量从主内存拷贝到工作内存，操作完成后写会主内存。不同线程间无法访问对方的工作内存，线程通信（传值）通过主内存来完成。
 > JMM 对于同步的规定：
 * 线程解锁前，必须把共享变量的值刷新回主内存
 * 线程加锁前，必须读取主内存的最新值到自己的工作内存
 * 加锁解锁是同一把锁
 
### JMM 的三大特性
 可见性,原子性,顺序性
 * 原子性是不可分割，某个线程正在做某个具体业务时，中间不可以被分割，要么全部成功，要么全部失败。
 * 重排序：计算机在执行程序时，为了提高性能，编译器和处理器常常对指令做重排序，源代码经过编译器优化重排序、指令并行重排序、内存系统的重排序之后得到最终执行的指令。
 * 在单线程中保证程序最终执行结果和代码执行顺序执行结果一致。
 * 多线程中线程交替执行，由于重排序，两个线程中使用的变量能否保证一致性无法确定，结果无法确定。
 * 处理器在处理重排序时需要考虑数据的依赖性。
 * volatile 实现禁止指令重排序，避免多线程环境下程序乱序执行。是通过内存屏障指令来执行的，通过插入内存屏障禁止在内存屏障后的指令执行重排序优化，并强制刷出缓存数据，保证线程能读取到这些数据的最新版本。
```java
 class MyData {
     volatile int number = 0;//case2
     //int number=0; //case1
     public void change() {
         number = 60;
     }
 }
 
 public class VolatileDemo {
     public static void main(String[] args) {
         MyData data=new MyData();
 
         new Thread(()->{
             System.out.println(Thread.currentThread().getName()+"\t come in");
             try{ TimeUnit.SECONDS.sleep(3); } catch (InterruptedException e) {e.printStackTrace();}
             data.change();
             System.out.println(Thread.currentThread().getName()+"\t updated number value:"+data.number);
         },"A").start();
 
         while(data.number==0){}
         System.out.println(Thread.currentThread().getName()+"\t over, get number:"+data.number);
 
     }
 }
 //当我们使用case1的时候，也就是number没有volatile修饰的时候,程序没有执行结束，说明在main线程中由于不能保证可见性，一直在死循环。
 //volatile 不保证原子性
 class MyData {
     volatile int number = 0;
 
     public void change() {
         number = 60;
     }
 
     public void addOne() {
         number++;
     }
 }
 
 public class VolatileDemo {
     public static void main(String[] args) {
         case2();
     }
 
     //验证原子性
     public static void case2() {
         MyData myData = new MyData();
 
         for (int i = 0; i < 20; i++) {
             new Thread(() -> {
                 for (int j = 0; j < 1000; j++) {
                     myData.addOne();
                 }
             }, String.valueOf(i)).start();
         }
 
         while(Thread.activeCount()>2){
             Thread.yield();
         }
         System.out.println(Thread.currentThread().getName()+"\t number value:"+myData.number);
     }
 }
//最终输出结果可以发现并不是 20000，且多次输出结果并不一致，因此说明 volatile 不能保证原子性。
// 保证原子性:加锁：使用 synchronized 加锁,使用 AtomicInteger
```
 
## CAS,ABA,幻读问题
 CAS 的全程是 CompareAndSwap，是一条 CPU 并发原语。它的功能是判断内存某个位置的值是否为预期值，如果是则更新为新的值，这个过程是原子的。
 CAS 的作用是比较当前工作内存中的值和主内存中的值，如果相同则执行操作，否则继续比较直到主内存和工作内存中的值一致为止。主内存值为V，工作内存中的预期值为A，要修改的更新值为B，当且仅当A和V相同，将V修改为B，否则什么都不做。
 
### CAS底层原理
 在原子类中，CAS 操作都是通过 Unsafe 类来完成的。
 
 ```java
 //AtomicInteger i++
 public final int getAndIncrement(){
     return unsafe.getAndAddInt(this,valueoffset,1);
 }
 ```
 其中 this 是当前对象， valueoffset 是一个 long ，代表地址的偏移量。
```java
 //AtomicInteger.java
 private static final Unsafe unsfae=Unsafe.getUnsafe();//unsafe对象
 private static final long valueOffset;//地址偏移量
 
 static{
     try{
         valueoffset=unsafe.objectFieldOffset(AtomicInteger.class.getDeclaredField("value");
     }catch(Excepthion ex){throw new Error(ex);}
 }
 
 private volatile int value;//存储的数值
```
> Unsafe 类是 rt.jar 下的 sun.misc 包下的一个类，基于该类可以直接操作特定内存的数据。
> Java方法无法直接访问底层系统，需要使用 native 方法访问，Unsafe 类的内部方法都是 native 方法，其中的方法可以像C的指针一样直接操作内存，Java 中的 CAS 操作的执行都依赖于 Unsafe 类的方法。
> valueOffset:该变量表示变量值在内存中的偏移地址， Unsafe 就是根据内存偏移地址获取数据的。
> CAS 并发源于体现在 Java 中就是 Unsafe 类的各个方法。调用该类中的 CAS 方法，JVM会帮我们实现出 CAS 汇编指令，这是一种完全依赖于硬件的功能。原语是由若干条指令组成的，用于完成某个功能的过程。原语的执行必须是连续的，执行过程不允许被中断。所以 CAS 是一条 CPU 的原子指令，不会造成数据不一致问题。

### CAS的缺点
如果CAS失败，会一直尝试。如果CAS长时间不成功，会给CPU带来很大的开销。
CAS 只能用来保证单个共享变量的原子操作，对于多个共享变量操作，CAS无法保证，需要使用锁。
存在 ABA 问题。CAS 实现一个重要前提需要取出内存中某个时刻的数据并在当下时刻比较并替换，这个时间差会导致数据的变化。线程1从内存位置V中取出A，线程2也从V中取出A，然后线程2通过一些操作将A变成B，然后又把V位置的数据变成A，此时线程1进行CAS操作发现V中仍然是A，操作成功。尽管线程1的CAS操作成功，但是不代表这个过程没有问题。

> 幻读问题,通过新增版本号的机制来解决,Java通过 AtomicStampedReference 来解决这个问题

```java
public class SolveABADemo {
    static AtomicStampedReference<Integer> atomicStampedReference=new AtomicStampedReference<>(100,1);

    new Thread(()->{
        int stamp=atomicStampedReference.getStamp();
            System.out.println(Thread.currentThread().getName()+"\t 版本号："+stamp);
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        atomicStampedReference.compareAndSet(100,101,atomicStampedReference.getStamp(),atomicStampedReference.getStamp()+1);
        System.out.println(Thread.currentThread().getName()+"\t 版本号："+atomicStampedReference.getStamp());
        atomicStampedReference.compareAndSet(101,100,atomicStampedReference.getStamp(),atomicStampedReference.getStamp()+1);
        System.out.println(Thread.currentThread().getName()+"\t 版本号："+atomicStampedReference.getStamp());
        },"t1").start();

    new Thread(()->{
        int stamp=atomicStampedReference.getStamp();
        System.out.println(Thread.currentThread().getName()+"\t 版本号："+stamp);
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        boolean ret=atomicStampedReference.compareAndSet(100,2019,stamp,stamp+1);
        System.out.println(Thread.currentThread().getName()+"\t"+ret
            +" stamp:"+atomicStampedReference.getStamp()
            +" value:"+atomicStampedReference.getReference());
        },"t2").start();
    }
}
```

## 集合类的线程安全问题
ConcurrentModificationException:这个异常也就是并发修改异常，java.util.ConcurrentModificationException。导致这个异常的原因，是集合类本身是线程不安全的。
* 使用 Vector， Hashtable 等同步容器
* 使用 Collections.synchronizedxxx(new XX) 创建线程安全的容器
* 使用 CopyOnWriteList, CopyOnWriteArraySet, ConcurrentHashMap 等 j.u.c 包下的并发容器。

### CopyOnWriteArrayList
底层使用了 private transient volatile Object[] array;CopyOnWriteArrayList 采用了写时复制、读写分离的思想。
```java
public boolean add(E e){
    final ReentrantLock lock=this.lock;
    try{
        //旧数组
        Object[] elements = getArray();
        int len = elements.length;
        //复制新数组
        Object[] newElements = Arrays.copyOf(elements, len+1);
        //修改新数组
        newElements[len] = e;
        //更改旧数组引用指向新数组
        setArray(newElements);
        return true;
    }finally{
        lock.unlock();
    }
}
```
添加元素时，不是直接添加到当前容器数组，而是复制到新的容器数组，向新的数组中添加元素，添加完之后将原容器引用指向新的容器。这样做的好处是可以对该容器进行并发的读，而不需要加锁，因为读时容器不会添加任何元素。CopyOnWriteArraySet 本身就是使用 CopyOnWriteArrayList 来实现的。

## Java锁,公平锁和非公平锁,自旋锁
### 公平锁和非公平锁
ReentrantLock 可以指定构造函数的 boolean 类型得到公平或非公平锁，默认是非公平锁，synchronized也是非公平锁。
公平锁是多个线程按照申请锁的顺序获取锁，是 FIFO 的。并发环境中，每个线程在获取锁时先查看锁维护的等待队列，为空则占有，否则加入队列。
非公平锁是指多个线程不是按照申请锁的顺序，有可能后申请的线程比先申请的线程优先获取锁。高并发情况下可能导致优先级反转或者饥饿现象。并发环境中，上来尝试占有锁，尝试失败，再加入等待队列。

### 可重入锁（递归锁）
可重入锁指的是同一线程外层函数获取锁之后，内层递归函数自动获取锁。也就是线程能进入任何一个它已经拥有的锁所同步着的代码块。ReentrantLock 和 synchronized 都是可重入锁。可重入锁最大的作用用来避免死锁。

### 自旋锁
自旋锁是指尝试获取锁的线程不会立即阻塞，而是采用循环的方式尝试获取锁。好处是减少线程上下文切换的消耗，缺点是循环时会消耗CPU资源。
实现自旋锁：
```java
public class SpinLockDemo {
//使用AtomicReference<Thread>来更新当前占用的 Thread
    AtomicReference<Thread> threadAtomicReference=new AtomicReference<>();

    public static void main(String[] args) {
        SpinLockDemo demo=new SpinLockDemo();
        new Thread(()->{
            demo.myLock();
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            demo.myUnlock();
        },"t1").start();


        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        new Thread(()->{
            demo.myLock();
            demo.myUnlock();
        },"t2").start();

    }

    public void myLock(){
        Thread thread=Thread.currentThread();
        System.out.println(Thread.currentThread().getName()+"\t come in");
        
        //如果当前占用的线程为null，则尝试获取更新
        while(!threadAtomicReference.compareAndSet(null,thread)){

        }
    }

    public void myUnlock(){
        Thread thread=Thread.currentThread();
        //释放锁，将占用的线程设置为null
        threadAtomicReference.compareAndSet(thread,null);
        System.out.println(Thread.currentThread().getName()+"\t unlocked");
    }
}
```

### 读写锁
独占锁：该锁一次只能被一个线程持有，如 ReentrantLock 和 synchronized。共享锁：该锁可以被多个线程持有。ReentrantReadWriteLock 中，读锁是共享锁，写锁时独占锁。读读共享保证并发性，读写互斥。

## 并发工具类
### CountDownLatch
CountDownLatch 的作用是让一些线程阻塞直到另外一些线程完成一系列操作后才被唤醒。CountDownLatch 在初始时设置一个数值，当一个或者多个线程使用 await() 方法时，这些线程会被阻塞。其余线程调用 countDown() 方法，将计数器减去1，当计数器为0时，调用 await() 方法被阻塞的线程会被唤醒，继续执行。可以理解为，等大家都走了，保安锁门。

### CyclicBarrier
CyclicBarrier 是指可以循环使用的屏障，让一组线程到达一个屏障时被阻塞，直到最后一个线程到达屏障，屏障才会开门，被屏障拦截的线程才会继续工作，线程进入屏障通过 await() 方法。可以理解为，大家都到齐了，才能开会。
```java
public class CyclicBarrierTest {
    private static CyclicBarrier cyclicBarrier;

    static class CyclicBarrierThread extends Thread{
        public void run() {
            System.out.println(Thread.currentThread().getName() + "到了");
            //等待
            try {
                cyclicBarrier.await();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args){
        cyclicBarrier = new CyclicBarrier(5, new Runnable() {
            @Override
            public void run() {
                System.out.println("人到齐了，开会吧....");
            }
        });

        for(int i = 0 ; i < 5 ; i++){
            new CyclicBarrierThread().start();
        }
    }
}
```

### Semaphore
信号量用于：多个共享资源的互斥使用，并发线程数的控制。
可以理解为，多个车抢停车场的多个车位。当进入车位时，调用 acquire() 方法占用资源。当离开时，调用 release() 方法释放资源。
```java
//当成锁使用
public class SemaphoreLock {
    public static void main(String[] args) {
        //1、信号量为1时 相当于普通的锁  信号量大于1时 共享锁
        Output o = new Output();
        for (int i = 0; i < 5; i++) {
            new Thread(() -> o.output()).start();
        }
    }
}
class Output {
    Semaphore semaphore = new Semaphore(1);

    public void output() {
        try {
            semaphore.acquire();
            System.out.println(Thread.currentThread().getName() + " start at " + System.currentTimeMillis());
            Thread.sleep(1000);
            System.out.println(Thread.currentThread().getName() + " stop at " + System.currentTimeMillis());
        }catch(Exception e) {
            e.printStackTrace();
        }finally {
            semaphore.release();
        }
    }
}
```
```java
//线程通信信号
public class SemaphoreCommunication {
    public static void main(String[] args) {
        //2、线程间进行通信
        Semaphore semaphore = new Semaphore(1);
        new SendingThread(semaphore,"SendingThread");
        new ReceivingThread(semaphore,"ReceivingThread");
    }
}
class SendingThread extends Thread {
    Semaphore semaphore;
    String name;

    public SendingThread(Semaphore semaphore,String name) {
        this.semaphore = semaphore;
        this.name = name;
        new Thread(this).start();
    }

    public void run() {
        try {
            semaphore.acquire();
            for (int i = 0; i < 5; i++) {
                System.out.println(name + ":" + i);
                Thread.sleep(1000);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        semaphore.release();
    }
}

class ReceivingThread extends Thread {
    Semaphore semaphore;
    String name;

    public ReceivingThread(Semaphore semaphore,String name) {
        this.semaphore = semaphore;
        this.name = name;
        new Thread(this).start();
    }

    public void run() {
        try {
            semaphore.acquire();
            for (int i = 0; i < 5; i++) {
                System.out.println(name + ":" + i);
                Thread.sleep(1000);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        semaphore.release();
    }
}
```

### 阻塞队列
阻塞队列首先是一个队列，所起的作用如下：
* 当阻塞队列为空，从队列中获取元素的操作将会被阻塞
* 当阻塞队列为满，向队列中添加元素的操作将会被阻塞
试图从空的阻塞队列中获取元素的线程将会被阻塞，直到其他线程向空的队列中插入新的元素。同样的，试图向已满的阻塞队列中添加新元素的线程同样会被阻塞，直到其他线程从队列中移除元素使得队列重新变得空闲起来并后序新增。
阻塞：阻塞是指在某些情况下会挂起线程，即阻塞，一旦条件满足，被挂起的线程又会自动被唤醒。
优点：BlockingQueue 能帮助我们进行线程的阻塞和唤醒，而无需关心何时需要阻塞线程，何时需要唤醒线程。同时兼顾了效率和线程安全。

#### 阻塞队列的架构
BlokcingQueue 接口实现了 Queue 接口，该接口有如下的实现类：

* ArrayBlockingQueue: 由数组组成的有界阻塞队列
* LinkedBlockingQueue： 由链表组成的有界阻塞队列（默认大小为 Integer.MAX_VALUE）
* PriorityBlockingQueue：支持优先级排序的无界阻塞队列
* DelayQueue：使用优先级队列实现的延迟无界阻塞队列
* SynchronousQueue： 不存储元素的阻塞队列，单个元素的队列，同步提交队列
* LinkedTransferQueue：链表组成的无界阻塞队列
* LinkedBlockingDeque：链表组成的双向阻塞队列

抛出异常：当队列满，add(e)会抛出异常IllegalStateException: Queue full；当队列空，remove()和element()会抛出异常NoSuchElementException
特殊值：offer(e)会返回 true/false。peek()会返回队列元素或者null。
阻塞：队列满，put(e)会阻塞直到成功或中断；队列空take()会阻塞直到成功。
超时：阻塞直到超时后退出，返回值和特殊值中的情况一样。

### 生产者消费者模式

* 使用Lock
```java
class ShareData {
    private int number = 0;
    private Lock lock = new ReentrantLock();
    private Condition condition = lock.newCondition();

    public void increment() throws Exception {
        lock.lock();
        try {
            //判断
            while (number != 0) {
                condition.await();
            }
            //干活
            number++;
            System.out.println(Thread.currentThread().getName() + " produce\t" + number);
            //通知唤醒
            condition.signalAll();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }
    }

    public void decrement()throws Exception{
        lock.lock();
        try {
            //判断
            while (number == 0) {
                condition.await();
            }
            //干活
            number--;
            System.out.println(Thread.currentThread().getName() + " consume\t" + number);
            //通知唤醒
            condition.signalAll();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }
    }
}
```
```java
/**
 * 一个初始值为0的变量，两个线程交替操作，一个加1一个减1,重复5次
 * 1. 线程 操作 资源类
 * 2. 判断 干活 通知
 * 3. 防止虚假唤醒机制:判断的时候要用while而不是用if
 */
public class ProduceConsumeTraditionalDemo {
    public static void main(String[] args) {
        ShareData data=new ShareData();

        new Thread(()->{
            for (int i = 0; i < 5 ; i++) {
                try {
                    data.increment();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        },"A").start();

        new Thread(()->{
            for (int i = 0; i < 5 ; i++) {
                try {
                    data.decrement();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        },"B").start();
    }
}
```

* 使用阻塞队列
```java
public class ProduceConsumeBlockingQueueDemo {
    public static void main(String[] args) {
        SharedData data=new SharedData(new ArrayBlockingQueue<>(10));
        new Thread(()-> {
            System.out.println(Thread.currentThread().getName() + "\t生产线程启动");
            try {
                data.produce();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        },"Producer").start();
        new Thread(()-> {
            System.out.println(Thread.currentThread().getName() + "\t消费线程启动");
            try {
                data.consume();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        },"Consumer").start();

        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        data.stop();
        System.out.println("停止");
    }
}
class SharedData{
    private volatile boolean FLAG=true;
    private AtomicInteger atomicInteger=new AtomicInteger();

    BlockingQueue<String> blockingQueue=null;

    public SharedData(BlockingQueue<String> blockingQueue) {
        this.blockingQueue = blockingQueue;
        System.out.println(blockingQueue.getClass().getName());
    }

    public void produce() throws InterruptedException {
        String data=null;
        boolean ret;
        while(FLAG){
            data=""+atomicInteger.incrementAndGet();
            ret=blockingQueue.offer(data,2L,TimeUnit.SECONDS);
            if(ret){
                System.out.println(Thread.currentThread().getName()+"\t插入"+data+"成功");
            }else{
                System.out.println(Thread.currentThread().getName()+"\t插入"+data+"失败");
            }
            TimeUnit.SECONDS.sleep(1);
        }
        System.out.println("生产结束，FLAG=false");
    }

    public void consume() throws InterruptedException {
        String ret=null;
        while(FLAG){
            ret=blockingQueue.poll(2L,TimeUnit.SECONDS);
            if(null==ret||ret.equalsIgnoreCase("")){
                System.out.println(FLAG=false);
                System.out.println(Thread.currentThread().getName()+"\t消费等待超时退出");
                return;
            }
            System.out.println(Thread.currentThread().getName() + "\t消费" + ret + "成功");
        }
    }

    public void stop(){
        FLAG=false;
    }
}
```

## Synchronized 和 Lock 的区别
原始构成
* Synchronized 是关键字，属于JVM层面，底层是通过 monitorenter 和 monitorexit 完成，依赖于 monitor 对象来完成。由于 wait/notify 方法也依赖于 monitor 对象，因此只有在同步块或方法中才能调用这些方法。
* Lock 是 java.util.concurrent.locks.lock 包下的，是 api层面的锁。

> 使用方法
* Synchronized 不需要用户手动释放锁，代码完成之后系统自动让线程释放锁
* ReentrantLock 需要用户手动释放锁，没有手动释放可能导致死锁。

> 等待是否可以中断
* Synchronized 不可中断，除非抛出异常或者正常运行完成
* ReentrantLock 可以中断。一种是通过 tryLock(long timeout, TimeUnit unit)，另一种是lockInterruptibly()放代码块中，调用interrupt()方法进行中断。

> 加锁是否公平
* synchronized 是非公平锁
* ReentrantLock 默认非公平锁，可以在构造方法传入 boolean 值，true 代表公平锁，false 代表非公平锁。

> 锁绑定多个 Condition
* Synchronized 只有一个阻塞队列，只能随机唤醒一个线程或者唤醒全部线程。
* ReentrantLock 用来实现分组唤醒，可以精准唤醒。

## 线程池
> 线程池有七大参数
* int corePoolSize,//线程池常驻核心线程数
* int maximumPoolSize,//线程池能容纳同时执行最大线程数
* long keepAliveTime,//多余的空闲线程的存活时间，当前线程池线程数量超过core，空闲时间达到keepAliveTime，多余空闲线程会被销毁直到只剩下core个
* TimeUnit unit,
* BlockingQueue<Runnable> workQueue,//被提交尚未被执行的任务队列
* ThreadFactory threadFactory,//创建线程的线程工厂
* RejectedExecutionHandler handler//拒绝策略

### 三种常用线程池
* Executors.newFixedThreadPool(int):创建固定容量的线程池，控制最大并发数，超出的线程在队列中等待。其中 corePoolSize 和 maximumPoolSize 值是相等的，并且使用的是 LinkedBlockingQueue。适用于执行长期的任务，性能比较高。
* Executors.newSingleThreadExecutor():创建了一个单线程的线程池，只会用唯一的工作线程来执行任务，保证所有任务按照顺序执行。其中 corePoolSize 和 maximumPoolSize 都设置为1，使用的也是 LinkedBlockingQueue。适用于一个任务一个任务执行的场景。
```java
return new FinalizableDelegatedExecutorService
    (new ThreadPoolExecutor(1, 1,
        0L, TimeUnit.MILLISECONDS,
        new LinkedBlockingQueue<Runnable>()));
```
* Executors.newCachedThreadPool():创建了一个可缓存的线程池，如果线程池长度超过处理需要，可以灵活回收空闲线程，没有可以回收的，则新建线程。
```
return new ThreadPoolExecutor(0, Integer.MAX_VALUE,
        60L, TimeUnit.SECONDS,
        new SynchronousQueue<Runnable>());
```
设置 corePoolSize 为0， maximumPoolSize 设置为 Integer.MAX_VALUE，使用的是 SynchronousQueue。来了任务就创建线程执行，线程空闲超过60秒后销毁。适用于执行很多短期异步的小程序或者负载比较轻的服务器。

> 注意
* 线程资源必须通过线程池提供，不允许在应用中自行显示创建线程。
* 线程池不允许使用 Executors 去创建，也就是不能使用上述的三种线程池，而是要通过

### 如何设置线程池的线程数目
Runtime.getRuntime().availableProcessors()获取当前设备的CPU个数。
CPU密集型任务：
CPU 密集的含义是任务需要大量的运算，而没有阻塞，CPU一致全速运行
CPU 密集任务只有在真正的多核 CPU 上才能得到加速（通过多线程），而在单核 CPU 上，无论开几个模拟的多线程都不能得到加速
CPU 密集型任务配置尽可能少的线程数量，一般设置为 CPU 核心数 + 1

IO 密集型:
IO 密集型，是指该任务需要大量的IO，大量的阻塞
单线程上运行 IO 密集型的任务会导致浪费大量的 CPU 运算能力浪费在等待上
IO 密集型任务使用多线程可以大大加速程序运行，利用了被浪费掉的阻塞时间
IO 密集型时，大部分线程都阻塞，需要多配置线程数，可以采用CPU核心数 * 2，或者采用 CPU 核心数 / (1 - 阻塞系数)，阻塞系数在0.8 ~ 0.9之间


## 死锁
产生死锁的原因，死锁是指两个或两个以上的进程在执行过程中，因为争夺资源造成的互相等待的现象。
> 死锁需要满族的四大条件如下：互斥，循环等待，不可抢占，占有并等待
> 产生死锁的主要原因有：系统资源不足，进程运行推进顺序不当，资源分配不当

死锁实例：
```java
class HoldLockThread implements Runnable{
    private String lock1;
    private String lock2;

    public HoldLockThread(String lock1, String lock2) {
        this.lock1 = lock1;
        this.lock2 = lock2;
    }

    @Override
    public void run() {
        synchronized (lock1){
            System.out.println(Thread.currentThread().getName()+"\t持有"+lock1+"\t尝试获取"+lock2);
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            synchronized (lock2){
                System.out.println(Thread.currentThread().getName()+"\t持有"+lock1+"\t尝试获取"+lock2);
            }
        }
    }
}

public class DeadLockDemo {
    public static void main(String[] args) {
        String lockA="lockA";
        String lockB="lockB";

        new Thread(new HoldLockThread(lockA,lockB),"Thread1").start();
        new Thread(new HoldLockThread(lockB,lockA),"Thread2").start();
    }
}
```

### 死锁定位分析
使用 jps ，类似于 linux 中的 ps 命令。
在上述 java 文件中，使用 IDEA 中的 open In Terminal，或者在该文件目录下使用 cmd 命令行工具。
首先使用 jps -l命令，类似于ls -l命令，输出当前运行的 java 线程，从中能得知 DeadLockDemo 线程的线程号。
然后，使用jstack threadId来查看栈信息。输出如下：
```bash
Java stack information for the threads listed above:
===================================================
"Thread2":
        at interview.jvm.deadlock.HoldLockThread.run(DeadLockDemo.java:22)
        - waiting to lock <0x00000000d6240328> (a java.lang.String)
        - locked <0x00000000d6240360> (a java.lang.String)
        at java.lang.Thread.run(Thread.java:748)
"Thread1":
        at interview.jvm.deadlock.HoldLockThread.run(DeadLockDemo.java:22)
        - waiting to lock <0x00000000d6240360> (a java.lang.String)
        - locked <0x00000000d6240328> (a java.lang.String)
        at java.lang.Thread.run(Thread.java:748)

Found 1 deadlock.
```
