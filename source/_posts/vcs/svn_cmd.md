---
title: SVN常用命令
copyright: false
date: 2018-04-22 16:54:00
tags: 
 - svn
categories: 
 - VCS
---
 ## 将文件checkout到本地目录
```bash
svn checkout path   （path是服务器上的目录）
例如：svn checkout svn://192.168.1.1/pro/domain
简写：svn co
svn checkout svn://localhost/mycode --username=gwh --password=123 /Users/apple/Documents/code
```

## 往版本库中添加新的文件
```bash
svn add file
例如：svn add test.php (添加test.php)
svn add     *.php(添加当前目录下所有的php文件)
```

## 将改动的文件提交到版本库
```bash
svn commit -m "LogMessage" [-N] [--no-unlock] PATH(如果选择了保持锁，就使用--no-unlock开关)
例如：svn commit -m "add test file for my test" test.php
简写：svn ci
```

## 加锁/解锁
```bash
svn lock -m "LockMessage" [--force] PATH
例如：svn lock -m "lock test file" test.php
svn unlock PATH
```

## 更新到某个版本
```bash
svn update -r m path
例如：
svn update如果后面没有目录，默认将当前目录以及子目录下的所有文件都更新到最新版本。
svn update -r 200 test.php(将版本库中的文件test.php还原到版本200)
svn update test.php(更新，于版本库同步。如果在提交的时候提示过期的话，是因为冲突，需要先update，修改文件，然后清除svn resolved，最后再提交commit)
简写：svn up
```
## 查看文件或者目录状态
```bash
a）svn status path（目录下的文件和子目录的状态，正常状态不显示）
【?：不在svn的控制中；M：内容被修改；C：发生冲突；A：预定加入到版本库；K：被锁定】
b）svn status -v path(显示文件和子目录状态)
第一列保持相同，第二列显示工作版本号，第三和第四列显示最后一次修改的版本号和修改人。
注：svn status、svn diff和 svn revert这三条命令在没有网络的情况下也可以执行的，原因是svn在本地的.svn中保留了本地版本的原始拷贝。
简写：svn st
```

## 删除文件
```bash
svn delete path -m "delete test fle"
例如：svn delete svn://192.168.1.1/pro/domain/test.php -m "delete test file"
或者直接svn delete test.php 然后再svn ci -m 'delete test file‘，推荐使用这种
简写：svn (del, remove, rm)
```
## 查看日志，比较差异
```bash
svn log path
例如：svn log test.php 显示这个文件的所有修改记录，及其版本号的变化

#查看文件详细信息
svn info path
例如：svn info test.php

#比较差异
svn diff path(将修改的文件与基础版本比较)
例如：svn diff test.php

svn diff -r m:n path(对版本m和版本n比较差异)
例如：svn diff -r 200:201 test.php
简写：svn di

#将两个版本之间的差异合并到当前文件
svn merge -r m:n path
例如：svn merge -r 200:205 test.php（将版本200与205之间的差异合并到当前文件，但是一般都会产生冲突，需要处理一下）

#版本库下的文件和目录列表
svn list path
显示path目录下的所有属于版本库的文件和目录
简写：svn ls

#创建纳入版本控制下的新目录
svn mkdir: 创建纳入版本控制下的新目录。
用法: a、mkdir PATH...b、mkdir URL...
创建版本控制的目录。
a、每一个以工作副本 PATH 指定的目录，都会创建在本地端，并且加入新增
     调度，以待下一次的提交。
b、每个以URL指定的目录，都会透过立即提交于仓库中创建。
在这两个情况下，所有的中间目录都必须事先存在。
```

## 恢复本地修改，代码库URL变更
```bash
svn revert: 恢复原始未改变的工作副本文件 (恢复大部份的本地修改)。revert:
用法: revert PATH...
注意: 本子命令不会存取网络，并且会解除冲突的状况。但是它不会恢复
被删除的目录

#代码库URL变更
svn switch (sw): 更新工作副本至不同的URL。
#用法:
1、switch URL [PATH]
2、switch --relocate FROM TO [PATH...]
a、更新你的工作副本，映射到一个新的URL，其行为跟“svn update”很像，也会将
服务器上文件与本地文件合并。这是将工作副本对应到同一仓库中某个分支或者标记的
方法。
b、改写工作副本的URL元数据，以反映单纯的URL上的改变。当仓库的根URL变动 
(比如方案名或是主机名称变动)，但是工作副本仍旧对映到同一仓库的同一目录时使用
这个命令更新工作副本与仓库的对应关系。
```

## 解决冲突
```bash
svn resolved: 移除工作副本的目录或文件的“冲突”状态。
用法: resolved PATH...
注意: 本子命令不会依语法来解决冲突或是移除冲突标记；它只是移除冲突的
相关文件，然后让 PATH 可以再次提交。

#输出指定文件或URL的内容
svn cat 目标[@版本]...如果指定了版本，将从指定的版本开始查找
svn cat -r PREV filename > filename (PREV 是上一版本,也可以写具体版本号,这样输出结果是可以提交的)
```

## SVN的ignore属性
```bash
svn propset svn:ignore *.class .    #svn status命令，没有.class文件
svn status --no-ignore              #查看忽略的文件
svn propset svn:ignore bin .        #忽略文件夹，不要加斜杠
svn propset svn:ignore "bin node_modules" . #只有最后执行的生效，一次性添加好
#添加忽略文件，用文件添加忽略-F vi .svnignore 
#svn propset svn:ignore -F .svnignore .
node_modules
build
package-lock.json

svn propset svn:ignore -R *.class . # —R 递归属性配置
svn propset svn:ignore -R -F .svnignore .   #-F通过配置文件来忽略
svn status --no-ignore              #删除忽略文件
svn proplist -v [PATH]              #查看指定目录
#**注意**#
svn add *                           #会把忽略中的文件也添加到仓库
svn add --force .                   #替换上面的命令
svn delete --keep-local [path]      #只从svn中忽略，而不删除文件
##svn add后的数据如何 恢复/取消/还原
svn revert testcase/perday.php      #恢复文件的内容
svn revert --depth=infinity .       #恢复整个目录
```

## 新建分支和标签Tag
```bash
#创建新分支
svn cp -m "create 5.3.0 branch" http://svn.2caipiao.com:88/svn/tiger/trunk/jcobserver/jcob-app-v2/trunk http://svn.2caipiao.com:88/svn/tiger/trunk/jcobserver/jcob-app-v2/branches/jcob-app-5.3.0

#获得分支 
svn co http://svn.2caipiao.com:88/svn/tiger/trunk/jcobserver/jcob-app-v2/branches/jcob-app-5.3.0

#合并主干上的最新代码到分支上,冲突标记 <<<<<<< .working
cd jcob-app-v2/branches/jcob-app-5.3.0
svn merge http://svn.2caipiao.com:88/svn/tiger/trunk/jcobserver/jcob-app-v2/trunk

#分支合并到主干,分支合并到主干中完成后应当删该分支，因为在SVN中该分支已经不能进行刷新也不能合并到主干
cd jcob-app-v2/trunk
svn merge --reintegrate http://svn.2caipiao.com:88/svn/tiger/trunk/jcobserver/jcob-app-v2/branches/jcob-app-5.3.0
#合并版本并将合并后的结果应用到现有的分支上
svn -r 148:149 merge http://svn.2caipiao.com:88/svn/tiger/trunk/jcobserver/jcob-app-v2/trunk

#建立tags,产品开发已经基本完成，并且通过很严格的测试
svn copy http://svn.2caipiao.com:88/svn/tiger/trunk/jcobserver/jcob-app-v2/trunk http://svn.2caipiao.com:88/svn/tiger/trunk/jcobserver/jcob-app-v2/tags/5.5.0 -m "5.5.0 released"

#删除分支或标签Tags
svn rm http://svn.2caipiao.com:88/svn/tiger/trunk/jcobserver/jcob-app-v2/branches/jcob-app-5.3.0
svn rm http://svn.2caipiao.com:88/svn/tiger/trunk/jcobserver/jcob-app-v2/tags/jcob-app-5.3.0
```

## 还原代码
```bash
svn log filename -v -l 5  //查看指定文件最近5个版本详细信息
svn up -r 6545 filename  //恢复指定文件到版本6545，还原后，不修改历史记录，不能提交
svn merge -r 387276:385119 PlanController.java  //从指定版本还原到特定版本，可以提交保存
svn diff PlanController.java  //查看还原了哪些内容
```