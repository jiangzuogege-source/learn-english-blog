---
title: Windows基本使用
copyright: false
date: 2019-06-23 15:20:00
tags: 
 - windows
categories: 
 - 系统
---
## 切换用户文件夹到非系统盘-系统瘦身
```bash
原理：拷贝系统盘用户目录到非系统盘，然后在系统盘建立软连接到刚刚拷贝的目录
a、windows---->搜索'计算机管理'---->点击'用户'---->取消禁用Administrator
b、注销当前用户---->进入到Administrator---->win+R--->输入CMD回车
d、切换到非系统盘---->输入:robocopy "C:\Users" "D:\Users" /E /COPYALL /XJ /XD "C:\Users\Administrator"
e、注销当前用户，切换到非Administrator用户，禁用Administrator用户，参考步骤a
f、执行:rmdir "C:\Users" /S /Q ，忽略错误,重启
g、重启后，忽略异常，再次执行:rmdir "C:\Users" /S /Q ,不会报错，再执行：mklink /J "C:\Users" "D:\Users"
h、重启后就恢复正常，再看用户文件夹时，已经变成软连接到非系统盘，SUCCESS！
```

## 常用CMD命令
```bash
ipconfig /release   #释放IP
ipconfig /renew     #更新ip地址
sc delete mysql     #删除指定名称的服务
secpol.msc          #本地安全策略，解锁administrator帐号
explorer .          #打开当前路径的资源管理界面
mkdir src\java      #新建目录
del/erase abc.txt   #删除文件，不能删除目录
createobject("wscript.shell").run "c:\x.bat",0  #vb命令隐藏运行窗口，保存文件为.vbs后缀
netstat /a          # 查看端口号活动状态 
tracert www.ipav.vip#跟踪路由
attrib -h * /s /d   #去除该目录下所有文件(夹)的隐藏属性
shutdown /s /t 1800 #半个小时候光机 shutdown /a 取消
```

## CMD脚本
```bash
@echo off
echo 1.查看当前目录
echo 2.查看父目录
echo 3.重新选择
choice /c 123 
if %errorlevel% EQU 1 goto defrag      @Rem 应先判断数值最高的错误码）
if %errorlevel% EQU 2 goto mem
if %errotlevel% EQU 3 goto itit
echo %errotlevel% 
pause

:defrag
dir
goto itit
:mem
cd ../
dir
goto itit
:itit
pause

#if介绍
IF %ERRORLEVEL% LEQ 1 goto okay
这里的LEQ表示“小于等于”，全部的比较参数如下：
EQU - 等于
NEQ - 不等于
LSS - 小于
LEQ - 小于或等于
GTR - 大于
GEQ - 大于或等于
```

## 隐藏运行程序的窗口
```bash
通过批处理命令实现。缺点：会看到一个窗口一闪而逝
    @echo off 
    if "%1"=="h" goto begin 
    start mshta vbscript:createobject("wscript.shell").run("""%~nx0"" h",0)(window.close)&&exit 
    :begin
    ::以下为正常批处理命令，不可含有pause set/p等交互命令
    pause

建立系统服务
    runassrv add /cmdline:"C:/Windows/System32/cmd.exe /c D:/test.bat" /name:"mysrv"
    net start mysrv

at计划任务
    at 09:10 "cmd /c D:/Test.bat"

ftype文件关联
    ftype batfile=C:/Windows/System32/mshta "javascript:new ActiveXObject('WScript.Shell').Run('cmd /c%1',0);window.close();"

vbs方式
    mshta "javascript:new ActiveXObject('WScript.Shell').Run('cmd /c D:/test.bat',0);window.close()"
```

## 解决文件出现“小黄锁”图标
```bash
在所在文件的父目录的“属性”的“安全”里面添加“Authenticated Users”用户或组

#设置谷歌浏览器跨域和用户目录
设置谷歌浏览器跨域和用户目录
#Google搜索语法
"虾"和"橙子"                #必须包含虾和橙子
苹果 虾 -吃                 #不包含吃的相关内容
身份证 filetype:xls         #搜索文件类型未xls的包含身份证的内容
南山南 inurl:mp3            #搜索含有南山南的url内容
济公 site:so.com            #在指定网站搜索内容
苹果 define                 #搜索苹果的定义
```

## 常用设置搜索
```bash
# 鼠标右键，选‘新建’--> 新建快捷方式-->输入'下面内容'-->点击'下一步'-->点击'完成'-->在桌面查找explorer,双击打开
explorer.exe shell:::{ED7BA470-8E54-465E-825C-99712043E01C}
```