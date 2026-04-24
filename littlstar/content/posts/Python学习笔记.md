---
title: "Python学习笔记"
date: 2024-04-27T16:21:36+08:00
draft: false
tags: ["python"]
---

https://github.com/hantmac/Python-Interview-Customs-Collection

### 1. 谈谈对Python和其他语言的区别？
Python属于解释型语言，当程序运行时，是一行一行的解释，并运行，所以调式代码很方便，开发效率高，
还有龟叔给Python定位是任其自由发展、优雅、明确、简单，所以在每个领域都有建树，所有它有着非常强大的第三方库，
特点：
语法简洁优美，功能强大，标准库与第三方库都非常强大，而且应用领域也非常广
可移植性，可扩展性，可嵌入性
缺点：
　　运行速度慢，

- 解释型
    - python/php
- 编译型
    - c/java/c#        

### 2. 解释型和编译型的区别？
解释型：就是边解释边执行（Python，php）
编译型：编译后再执行（c、java、c#）

### 3. Python有哪些解释器，相关特点有哪些？
CPython

是官方版本的解释器：CPython。是使用C语言开发的，所以叫CPython。在命令行下运行python就是启动CPython解释器。
CPython是使用最广的Python解释器。教程的所有代码也都在CPython下执行。

IPython
IPython是基于CPython之上的一个交互式解释器，也就是说，IPython只是在交互方式上有所增强，但是执行Python代码的功能和CPython是完全一样的。CPython用>>>作为提示符，而IPython用In [序号]:作为提示符。

PyPy
由Python写的解释器，它的执行速度是最快。PyPy采用JIT技术，对Python代码进行动态编译（注意不是解释），
绝大部分Python代码都可以在PyPy下运行，但是PyPy和CPython有一些是不同的，这就导致相同的Python代码在两种解释器下执行可能会有不同的结果。

Jython
Jython是运行在Java平台上的Python解释器，可以直接把Python代码编译成Java字节码执行。

IronPython
IronPython和Jython类似，只不过IronPython是运行在.Net平台上的Python解释器，可以直接把Python代码编译成.Net的字节码。

小结：
　　Python的解释器很多，但使用最广泛的还是CPython。如果要和Java或.Net平台交互，最好的办法不是用Jython或IronPython，而是通过网络调用来交互，确保各程序之间的独立性。

### 4. python3和python2之间的区别
1：打印时，py2需要可以不需要加括号，py3 需要
python 2 ：print ('lili')   ,   print 'lili'
python 3 : print ('lili')   
python3 必须加括号

exec语句被python3废弃，统一使用exec函数

2：内涵
Python2：1，臃肿，源码的重复量很多。
         2，语法不清晰，掺杂着C，php，Java，的一些陋习。
         3, 2020年1月1日开始停止维护    
Python3：几乎是重构后的源码，规范，清晰，优美。

3、输出中文的区别
python2：要输出中文 需加 # -*- encoding:utf-8 -*-
Python3 ： 直接搞

4：input不同
python2 ：raw_input
python3 ：input 统一使用input函数

5：指定字节
python2在编译安装时，可以通过参数-----enable-unicode=ucs2 或-----enable-unicode=ucs4分别用于指定使用2个字节、4个字节表示一个unicode；
python3无法进行选择，默认使用 ucs4
查看当前python中表示unicode字符串时占用的空间：

impor sys
print（sys.maxunicode）
#如果值是65535，则表示使用usc2标准，即：2个字节表示
#如果值是1114111，则表示使用usc4标准，即：4个字节表示

6：
py2：xrange
　　　　range
py3：range  统一使用range，Python3中range的机制也进行修改并提高了大数据集生成效率

7：在包的知识点里
包：一群模块文件的集合 + __init__
区别：py2 ： 必须有__init__
　　　py3：不是必须的了

8：不相等操作符"<>"被Python3废弃，统一使用"!="

9：long整数类型被Python3废弃，统一使用int

10：迭代器iterator的next()函数被Python3废弃，统一使用next(iterator)

11：异常StandardError 被Python3废弃，统一使用Exception

12：字典变量的has_key函数被Python废弃，统一使用in关键词

13：file函数被Python3废弃，统一使用open来处理文件，可以通过io.IOBase检查文件类型


### 5. python3和python2中int和long的区别？
在python3里，只有一种整数类型int,大多数情况下，和python２中的长整型类似。

### 6. xrange和range的区别？
xrange用法与range完全相同，所不同的是生成的不是一个数组，而是一个生成器。
要生成很大的数字序列的时候，用xrange会比range性能优很多，因为不需要一上来就开辟一块很大的内存空间，这两个基本上都是在循环的时候用。

在 Python 3 中，range() 是像 xrange() 那样实现，xrange()被抛弃。

### 7. 什么是PEP8？
PEP是 Python Enhancement Proposal 的缩写，翻译过来就是 Python增强建议书
简单说就是一种编码规范，是为了让代码“更好看”，更容易被阅读
具体可参考：
https://www.python.org/dev/peps/pep-0008/

### 8. 了解docstring吗？
Python有一个很奇妙的特性，称为 文档字符串 ，它通常被简称为 docstrings 。DocStrings是一个重要的工具，由于它帮助你的程序文档更加简单易懂，你应该尽量使用它。你甚至可以在程序运行的时候，从函数恢复文档字符串。
使用魔法方法'__doc__'可以打印docstring的内容

### 9. 了解类型注解吗？
def add(x:int, y:int) -> int:
    return x + y
用 : 类型 的形式指定函数的参数类型，用 -> 类型 的形式指定函数的返回值类型

- 注意：类型注解没有强制性。

### 10. 列举一些python的命名规范？
类名都使用首字母大写开头(Pascal命名风格)的规范；
全局变量全用大写字母，单词之间用 _分割；
普通变量用小写字母，单词之间用 _分割；
普通函数和普通变量一样；
私有函数以 __ 开头（2个下划线），其他和普通函数一样；

### 11. python中注释有哪几种？
单行注释
多行注释
docstring注释

### 12. python代码缩进是否支持tab和空格混用？
支持，Python 并没有强制要求你用Tab缩进或者用空格缩进，但在 PEP8中，建议使用4个空格来缩进

### 13. 是否可以在一句import中导入多个库？
可以的
import json,random,requests

### 14. python文件命名需要注意什么？
全小写，单词之间使用下划线分隔

### 15. 例举几个规范python代码风格的工具？
pylint,black,pycharm也带有pep8的代码规范工具

### 16. python基本数据类型？
Python3 中有六个标准的数据类型：

Number（数字）
String（字符串）
List（列表）
Tuple（元组）
Set（集合）
Dictionary（字典）
Python3 的六个标准数据类型中：

不可变数据（3 个）：Number（数字）、String（字符串）、Tuple（元组）；
可变数据（3 个）：List（列表）、Dictionary（字典）、Set（集合）。

### 17. 不可变和可变数据类型？
Python3 的六个标准数据类型中：

不可变数据（3 个）：Number（数字）、String（字符串）、Tuple（元组）；
可变数据（3 个）：List（列表）、Dictionary（字典）、Set（集合）。

### 18. 将‘hello world’ 转换为首字母大写‘Hello World’
z = 'hello world'
z.title()

### 19. 如何检测字符串里只含有数字？
# 分为两种情况
# 1.不包含正负号 +-
a = '32323'
a.isdigit()
# 2.含有正负号
import re
re.match(r'[+-]?\d+$',a)

### 20. 反转字符串？
s = 'ilovechina'
s = s[::-1]

### 21. Python中字符串格式化方式？
1. %s占位符
   1.  ‘hello %s' % name
2.  format
    1.  'hello {}'.format(name)
3.  f-string
    1.  f'hello {name}'

### 22. 去掉字符串的前后空格？
s = " sss "
s.strip()

### 23. python中单引号 双引号 三引号？
s = 'hello'
s= "hello"
双引号可以包含单引号字符，单引号无法包含双引号字符
三引号可以用来加注释，所加注释可以使用__doc__查看

### 24. 列表去重？
a_list = [1,2,3,1,2]
ss = set(a_list)

### 25. 如何打乱列表的元素？
import random
a = [1,5,7,9]
random.shuffle(a)

### 26. 字典的del和pop区别？
del 操作删除键值对，不返回值；key不存在必抛出keyerror
pop 操作删除键值对的同时，返回键所对应的值。 pop（key， default） 返回default，无default也无key 必报错

### 27. 字典如何排序？
sorted(d1,key=lambda x:x['age'])

### 28. 字典合并的方式？
# python3合并字典有三种方式
1.
a = {'a':1,'b':2}
b = {'c':3,'d':4}
c = {}
c.update(a)
c.update(b)
2.
c = dict(a,**b)
3.
c = {**a,**b} # 官方推荐这种方式
(1 update会修改原字典 2是python2的写法 已经弃用 3支持多个字典合并)

### 29. 使用生成式生成一段功能代码？
{x:x*x for x in range(6)}

### 30. 如何将tuple("A", "b"), (1,2) 生成dict（“A”：1， “b”， 2）

a = ('A', 'B')
b = (1,2)
z = zip(a,b)
c = dict(z)

### 31. tuple和list相互转换？
tuple(list)
list(tuple)

### 32. 我们知道对于列表可以使用切片操作进行部分元素的选择，那么如何对生成器类型的对象实现相同的功能呢？

itertools.islice是标准库中专为可迭代对象（包括生成器）设计的切片工具，语法与列表切片类似：

from itertools import islice

示例生成器
gen = (x for x in range(100))

取索引 10 到 20（不包含 20），步长为 2
sliced_gen = islice(gen, 10, 20, 2)

转换为列表输出
print(list(sliced_gen))  # 输出：[10, 12, 14, 16, 18]

### 33. 在读文件操作的时候会使用 read、readline 或者 readlines，简述它们各自的作用。

read将整个文本都读取为一个字符串，占用内存大，
readline读取为一个生成器，支持遍历和迭代，占用空间小。
readlines将文本读取为列表，占用空间大

