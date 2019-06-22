---
title: 'Git的常用命令行'
copyright: false
date: 2019-06-18 01:02:14
tags: 
 - git
categories: 
 - VCS
---
## 新建空白分支，并提交到远程仓库
``` bash
git branch <new_branch>
git checkout <new_branch>
git rm --cached -r . 
git clean -f -d
git commit --allow-empty -m "[empty] initial commit"
git push origin <new_branch>
```
## 一个分支完全覆盖另一个分支
``` bash
git reset --hard develop  	//先将本地的master分支重置成develop
git push origin master --force //再推送到远程仓库
```
## 恢复指定文件，回退代码
``` bash
git checkout -- .gitignore		    //恢复指定文件，如果已经add；
//就需要git reset HEAD -- .gitignore 然后再恢复文件
git reset add .                     //恢复所有add
git checkout HEAD^			        //退回到上一个版本 
git push -u origin barlow-qian -f 	//冲突时，强制修改远程库，远程修改会丢失
```

## 添加已经加入版本库的的忽略
``` bash
git rm --cached .settings/
echo .settings/ >> .gitignore
git add .
git commit -m "ignore settings dir"
```

## Git的基本配置
``` bash
git config --global user.name "doobo"	//设置全局用户名
git config --global user.email doobo@foxmail.com	//设置邮箱
ssh-keygen -t rsa -C "doobo@foxmail.com"	//再三个回车，设置密码为空的SSH的KEY
git remote rm origin  //删除远程仓库
git remote add origin (url)	//添加新的远程仓库地址
```

## 解决错误的提交(本地代码也会丢失)
``` bash
git stash           #将本地修改存储起来
git stash list      #查看保存的信息
git pull            #暂存了本地修改之后，就可以pull了
git stash pop stash@{0}		#还原暂存的内容, 最后解决文件中冲突的的部分
#Updated upstream 和=====之间的内容就是pull下来的内容，====和stashed changes之间的内容就是本地修改的内容
```

## 创建一个独立的空白新分支
``` bash
git checkout --orphan dev #新建一个完全独立的空白分支
git clean -d -fx #会清除所有git clone下的所有文件，只剩.git
git rm -rf . #清除所有git文件历史
git commit -m "message"
git push origin dev
```

## 特殊使用
``` bash
git clone -b v2.8.1 https://git.oschina.net/oschina/android-app.git #克隆指定分支
git add -f App.class       #强制添加文件到版本库，忽略.gitignore配置
git check-ignore -v App.class   #检查忽略规则是否出错
https://github.com/github/gitignore         #常用gitignore的默认配置
```

## GitIgnore规则
``` bash
fd1/*   #所有根和子目录下的fd1目录的文件多会忽略，同*/.idea/
/fd1/*  #忽略根目录下的fd1和fd1/同样
*/.DS_Store     #忽略所有.DS_Store文件，*/*.iml同理一样
/*      #忽略全部内容
!.gitignore     #但是不忽略 .gitignore 文件
!/fw/bin/       #不忽略根目录下的 /fw/bin/ 和 /fw/sf/ 目录
!/fw/sf/        #不忽略根目录下的 /fw/bin/ 和 /fw/sf/ 目录
```

## Tag的使用和branch的用法
``` bash
git tag  	#查看所有tag，github等仓库才有release，git的tag相当于release，git tag -l
git tag v1.0 			#新建tag，名字v1.0
git tag v1.1 f52c633 	#从指定的commit id打包Tag
git push --tags 		#推送所有tag到远程仓库
git tag -a v1.1 -m "注"	#添加注释
git push origin v1.0 	#将本地v1.0的tag推送到远端服务器
git tag -d v1.1			#删除本地Tag
git push origin :v1.1	#删除远程Tag，或者git push origin --delete tag V1.1
https://github.com/doobo/OkHttpTools/releases #可以用tag生成release供他人下载
https://jitpack.io/    #可以把githb的project生成maven包，引入到其它程序

git checkout -b branchname  #创建并切换到新分支
git branch -d branchname    #删除本地分支
git push origin :branchname #删除远程分支
```