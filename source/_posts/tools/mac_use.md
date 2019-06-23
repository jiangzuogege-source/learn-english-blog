---
title: Mac基本使用
copyright: false
date: 2019-06-23 14:57:00
tags: 
 - mac
 - xcode
categories: 
 - 系统
---
## 快捷键
```bash
win键 ＝ 花键(Command)
ctrl键   ＝ Ctrl键
Alt 键 ＝ Option
shift 键 ＝ shift

Command + c/v/z         #复制/粘贴/撤销
Command + Shift + Ctrl + 4  #屏幕部分画面
Command + Shift + h     #转到 Home
Command + Shift + c     #转到计算机
Command + Shift + q     #注销
Command + Delete        #删除项目
Command + ~             #同软件界面切换
Command + tab           #不同软件切换
```

## 常用技巧
```bash
按“command”键+拖曳窗口可以移动该窗口但不使其成为现用窗口
同时按“Optionion+command+W”键可以关闭所有文件夹窗口
同时按住“command+Optionion+esc”键可以强行退出死机程序
同时按住“command+shift+4”可以选择一个区域拍屏

#RK键盘使用
FN+Ctrl+win //解锁或锁定数字键以及home键等
FN+shift+win //解锁或锁定上下键

#解决升级出现中英文混合
系统偏好设置-->语言和地区--->添加英文，删除中文、重启--->重启后，再选择中文、删除英文、重启即可
shift+ctrl+alt+电源键	#重置系统管理控制器
Command (⌘)+alt+P+R 	#重置非易失的随机访问存储器(NVRAM)
ps -ef|grep nginx 		#查看应用程序进程，有一个匹配
kill -QUIT  15800 		#从容的停止，即不会立刻停止
Kill -TERM  15800		#立刻停止
Kill -INT  15800  		#和上面一样，也是立刻停止
lsof -n -P -i TCP -s TCP:LISTEN 	#查看网络端口号
netstat -nat |grep LISTEN 		#查看端口号使用情况

#日志和SSH工具
grep -A 30 -B 10 syntax catalina.2019-02-19.out |more  #查看匹配处的前10行后30行，并分页
grep -C 5 foo file      #显示file文件里匹配foo字串那行以及上下5行
iTerm+zsh+oh my zsh     #shell工具

#软件下载地址
https://www.waitsun.com/
```

## xcode/vi简单命令
```bash
shift+commond+k     #清楚编译缓存

#Vi使用
shift + 4           #ESC状态下，跳到行尾，$
shift + 6           #ESC状态下，跳到行首，^
:100                #ESC状态下，跳到100行，没有100行，则跳到最后一行
u                   #ESC状态下，撤销刚才的动作
ctrl+r              #ESC状态下，恢复撤销的动作
:!bash              #ESC状态下，启动一个bash shell并执行命令，exit返回到编辑器
:r !date            #ESC状态下，把结果插入到当前行的下一行
:62,72 !sort        #在ESC状态下，将62行到72行的内容进行排序
62 !tr [a-z] [A-Z]  #62行的小写字母转为大写字母
```