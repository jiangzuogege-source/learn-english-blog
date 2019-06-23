---
title: Python基础
copyright: false
date: 2019-06-23 15:47:00
tags: 
 - Python
categories: 
 - 编程
---
## 常用命令
```bash
ctrl+d          #Linux下退出Python命令行
ctrl+z Enter    #windows下退出Python命令
help ('print')  #查看命令帮助

(-5+4j)和(2.3-4.6j)  #复数
3.23和52.3E-4        #浮点数，52.3E-4表示52.3 * 10 -4
**                   #幂,3**4得到81
//                   #取整除,4#3.0 得到1.0
%                    #取模,8%3 得到2，还有<< >> & | ^ ~ not and or等
'或"                 #单引号、双引号包含单行字符串
'''或"""             #包含多行字符串
\' 或\               #转意符，用在行尾不带任何字符，表示下一个行连续
```

## 基本流程处理：注意：以空格或制表符统一控制
```bash
# -*- coding: utf-8 -*-
i=0
while True:
    s = raw_input('Enter som ething : ')
    if s == 'quit':
        break#if结束，统一一个制表符或空格,不要混用
    print 'Length of the string is', len(s)
    i += 1
    print 'Done',i#while结束，因为下面不在同一块内
else:
    print 'The Input is End!'#只有while的条件等于False时才会执行，这里不会执行
print 'Done End'#while结束后的代码，和while同级
```

## 常用函数
```bash
spam.sort(reverse=True)#给数组spam逆序排序
    spam.sort(key=str.lower)#按照普通的字典顺序,默认ASCII 字符顺序
    tuple(['cat', 'dog', 5])#返回('cat', 'dog', 5)
    list(('cat', 'dog', 5))#返回['cat', 'dog', 5]
    list('hello')#返回['h', 'e', 'l', 'l', 'o']
    cheese = copy.copy(spam)#复制数组，需要导入import copy

    def collatz(number):#Collatz猜想,3n+1猜想
        if number % 2 == 0:
            print(number // 2)
            return number // 2
        else:
            print(3 * number + 1)
            return 3 * number + 1


    s = input('请输入一个整数：')
    while True:
        try:
            int(s)
        except ValueError:
            print('输入的不是整数')
            break

        s = collatz(int(s))
        if s == 1:
            break
    print('程序结束！')
```

## 字典（对象，JSON对象）
```python
spam = {'color': 'red', 'age': 42}
for k, v in spam.items():
print('Key: ' + k + ' Value: ' + str(v))#获取对象的键值对
list(spam.keys())#获取键的数组
'color' in spam #相当于 'color' in spam.keys()
spam.setdefault('color', 'black')#该键不存在时要设置的值。如果该键确实存在，方法就会返回键的值
```

## 字符串常用函数
```python
isalpha()   #如果字符串只包含字母，并且非空，返回 True
isalnum()   #如果字符串只包含字母和数字，并且非空，返回 True
isdecimal() #如果字符串只包含数字字符，并且非空，返回 True
isspace()   #如果字符串只包含空格、制表符和换行，并且非空，返回 True
istitle()   #如果字符串仅包含以大写字母开头、后面都是小写字母的单词,返回True

' '.join(['My', 'name', 'is', 'Simon'])#My name is Simon
'My name is Simon'.split()#['My', 'name', 'is', 'Simon']    默认按照各种空白字符分割,spam.split('\n')
'Hello'.rjust(10)   #'     Hello'
'Hello'.ljust(10,'-')   #'Hello-----'
'Hello'.center(20, '=') #'=======Hello========'
spam.strip()#lstrip()和 rstrip()方法将相应删除左边或右边的空白字符
```

## 正则表达式
```python
pip install ModuleName#官方库模块安装，pip install pyperclip
#a、基础导入包
import re
phoneNumRegex = re.compile(r'\d\d\d-\d\d\d-\d\d\d\d')#在字符串的第一个引号之前加上 r，可以将该字符串标记为原始字符串
mo = phoneNumRegex.search('My number is 415-555-4242.')
print('Phone number found: ' + mo.group())

#b、分组匹配
phoneNumRegex = re.compile(r'(\d\d\d)-(\d\d\d-\d\d\d\d)')#分组匹配，groups()获取所有的分组
mo = phoneNumRegex.search('My number is 415-555-4242.')
mo.group(1)#415,mo.group(0),mo.group(2);

#c、默认贪心和非贪心模式匹配
greedyHaRegex = re.compile(r'(Ha){3,5}')
mo1 = greedyHaRegex.search('HaHaHaHaHa')#HaHaHaHaHa

nongreedyHaRegex = re.compile(r'(Ha){3,5}?')
nongreedyHaRegex.search('HaHaHaHaHa')#HaHaHa

#d、特殊匹配，全局匹配，模糊匹配
phoneNumRegex = re.compile(r'\d\d\d-\d\d\d-\d\d\d\d') # has no groups
phoneNumRegex.findall('Cell: 415-555-9999 Work: 212-555-0000')#['415-555-9999', '212-555-0000']
[0-5.]#不需要[0-5\.]方括号内，普通的正则表达式符号不会被解释

re.compile(r'.at')#句点字符只匹配一个字符
re.compile(r'<.*>')#“贪心”模式;re.compile(r'<.*?>')#“非贪心”模式匹配
newlineRegex = re.compile('.*', re.DOTALL)#句点字符匹配所有字符，包括换行字符
re.compile(r'robocop', re.I)#则表达式不区分大小写

\d、\w 和\s 分别匹配数字、单词和空格             \D、\W 和\S 分别匹配出数字、单词和空格外的所有字符
[abc]匹配方括号内的任意字符（诸如 a、b 或 c）    [^abc]匹配不在方括号内的任意字符
*匹配零次或多次前面的分组                       +匹配一次或多次前面的分组
?匹配零次或一次前面的分组                       {n}匹配 n 次前面的分组

#e、匹配字符并替换：
namesRegex = re.compile(r'Agent \w+')
namesRegex.sub('CENSORED', 'Agent Alice gave the secret documents to Agent Bob.')
#CENSORED gave the secret documents to CENSORED.

agentNamesRegex = re.compile(r'Agent (\w)\w*')
agentNamesRegex.sub(r'\1****', 'Agent Alice told Agent Carol that Agent Eve knew Agent Bob was a double agent.')
#A**** told C**** that E**** knew B**** was a double agent.'

#忽略正则表达式字符串中的空白符和注释
re.compile()
re.compile('foo', re.IGNORECASE | re.DOTALL)#管道字符（|）将变量组合起来
```