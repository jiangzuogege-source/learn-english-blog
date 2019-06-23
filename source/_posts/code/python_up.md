---
title: Python提升
copyright: false
date: 2019-06-23 15:55:00
tags: 
 - Python
categories: 
 - 编程
---
## 文件读写及系统路径
```bash
import os
os.path.join('usr', 'bin', 'spam')#usr\\bin\\spam

if not os.path.isdir(os.path.join('../','other')):
    print('Is not exit this dir,new this dir,yet.')
    os.makedirs(os.path.join('../','other'))

os.path.abspath('.')#相对路径的绝对路径
os.path.isabs('.')#False,是否为绝对路径
os.path.relpath('C:\\Windows', 'C:\\spam\\eggs')#..\\..\\Windows

path = 'C:\\Windows\\System32\\calc.exe'
os.path.basename(path)#calc.exe
os.path.dirname(path)#C:\\Windows\\System32
os.path.split(calcFilePath)#('C:\\Windows\\System32', 'calc.exe')

# tool 获取目录下文件的总量
def get_current_dir_total_size(path):
    __totalSize = 0
    if os.path.isdir(path):
        for __file_or_dir in os.listdir(path):
            if os.path.isdir(os.path.join(path, __file_or_dir)):
                __totalSize = __totalSize + get_current_dir_total_size(os.path.join(path, __file_or_dir))
            elif os.path.isfile(os.path.join(path, __file_or_dir)):
                __totalSize = __totalSize + os.path.getsize(os.path.join(path, __file_or_dir))
    elif os.path.isfile(path):
        __totalSize = os.path.getsize(path)
    else:
        print('该路径或文件不存在')
    return __totalSize

# tool 文本文件读写
FILE_OBJECT= open('order.log','r', encoding='UTF-8')
FILE_OBJECT= open('order.log','rb')
open('bacon.txt', 'a')#添加模式打开文件，在已有文件的末尾添加文本
open('bacon.txt', 'w')#写模式将覆写原有的文件
FILE_OBJECT.write('#Hello world!\n')

#shelve 模块保存变量，二进制文件，序列化
import shelve
shelfFile = shelve.open('mydata')
cats = ['Zophie', 'Pooka', 'Simon']
shelfFile['cats'] = cats
shelfFile.close()

#反序列化
shelfFile = shelve.open('mydata')
type(shelfFile)
shelfFile['cats']
list(shelfFile.keys())#['cats']
list(shelfFile.values())#[['Zophie', 'Pooka', 'Simon']]
shelfFile.close()

#windows批处理文件
@pyw.exe C:\Python34\mcb.pyw %*
#.pyw 扩展名意味着 Python运行该程序时，不会显示终端窗口
```

## 文件复制之shutil 模块
```bash
import shutil, os
os.chdir('C:\\')
shutil.copy('C:\\spam.txt', 'C:\\delicious')#C:\\delicious\\spam.txt
shutil.copy('eggs.txt', 'C:\\delicious\\eggs2.txt')#C:\\delicious\\eggs2.txt

shutil.copytree('C:\\bacon', 'C:\\bacon_backup')#复制整个文件夹，以及它包含的文件夹和文件
shutil.move('C:\\bacon.txt', 'C:\\eggs')#构成目的地的文件夹必须已经存在，否则 Python 会抛出异常
os.unlink(path)#将删除 path 处的文件
os.rmdir(path)#将删除 path 处的文件夹
shutil.rmtree(path)#将不可恢复地删除 path 处的文件夹，它包含的所有文件和文件夹都会被删除

#send2trash 模块  pip install send2trash
import send2trash
send2trash.send2trash('bacon.txt')#将文件发送到垃圾箱，让你稍后能够恢复它们

#遍历目录树
for folderName, subfolders, filenames in os.walk('C:\\delicious'):
    print('The current folder is ' + folderName)
    for subfolder in subfolders:#目录下的所有子目录
        print('SUBFOLDER OF ' + folderName + ': ' + subfolder)
    for filename in filenames:#目录下所有的文件
        print('FILE INSIDE ' + folderName + ': '+ filename)
        print('')
```

## 文件压缩
```bash
import zipfile, os
exampleZip = zipfile.ZipFile('example.zip')
exampleZip.namelist()#['spam.txt', 'cats/', 'cats/catnames.txt', 'cats/zophie.jpg']
spamInfo = exampleZip.getinfo('spam.txt')
spamInfo.file_size
spamInfo.compress_size
exampleZip.extractall()#解压缩所有文件和文件夹，放到当前工作目录中
exampleZip.extractall('C:\\ delicious')#解压缩所有文件和文件夹，放到指定目录
exampleZip.extract('spam.txt', 'C:\\some\\new\\folders')#解压缩单个文件
#第二个参数指定的文件夹不存在，Python 就会创建它
exampleZip.close()

#创建和添加到 ZIP 文件
newZip = zipfile.ZipFile('new.zip', 'w')
newZip.write('spam.txt', compress_type=zipfile.ZIP_DEFLATED)
newZip.close()
#只是希望将文件添加到原有的 ZIP 文件中
#就要向 zipfile.ZipFile()传入'a'作为第二个参数，以添加模式打开 ZIP 文件
```