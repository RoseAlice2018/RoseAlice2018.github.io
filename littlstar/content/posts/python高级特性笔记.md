---
title: "Python高级特性笔记"
date: 2025-04-27T19:26:40+08:00
draft: false
tags: ["Python"]
---

### 34. 函数装饰器有什么用？
函数装饰器可以在不修改原函数的条件下，为原函数添加额外的功能，例如记录日志，运行性能，缓存等
以记录函数运行时间为例，实现一个装饰器
import time
def time_it(func):
    def wrapper(func):
        start_time = time.time()
        res = func()
        end_time = time.time()
        return start_time - end_time
    return wrapper

### 35. 简述Python垃圾回收机制？
引用计数机制：
python里每一个东西都是对象，它们的核心就是一个结构体：PyObject
 typedef struct_object {
 int ob_refcnt;
 struct_typeobject *ob_type;
} PyObject;

PyObject是每个对象必有的内容，其中ob_refcnt就是做为引用计数。当一个对象有新的引用时，它的ob_refcnt就会增加，当引用它的对象被删除，它的ob_refcnt就会减少
#define Py_INCREF(op)   ((op)->ob_refcnt++) //增加计数
#define Py_DECREF(op) \ //减少计数
    if (--(op)->ob_refcnt != 0) \
        ; \
    else \
        __Py_Dealloc((PyObject *)(op))

当引用计数为0时，该对象生命就结束了。
引用计数机制的优点：

简单
实时性：一旦没有引用，内存就直接释放了。不用像其他机制等到特定时机。实时性还带来一个好处：处理回收内存的时间分摊到了平时

Python 的垃圾回收机制（Garbage Collection, GC）是一种自动内存管理策略，主要基于引用计数，并辅以标记-清除和分代回收算法，以解决循环引用问题并优化性能。其核心机制如下：

⚙️ 1. 引用计数（Reference Counting）

• 原理：每个对象内置一个引用计数器，记录指向该对象的引用数量。  

  • 对象被创建时计数为 1；  

  • 新增引用时计数 +1（如赋值、传参）；  

  • 引用失效时计数 -1（如变量销毁、重新赋值）；  

  • 计数归零时对象内存立即释放。  

• 示例：  
  import sys  
  a = [1, 2]  # 计数=1  
  b = a        # 计数=2  
  del b        # 计数=1  
  del a        # 计数=0 → 对象回收  
    
• 缺点：无法处理循环引用（如两个对象互相引用）。

🔄 2. 标记-清除（Mark and Sweep）

• 解决循环引用问题：  

  • 标记阶段：从根对象（全局变量、函数栈等）出发，遍历所有可达对象并标记为“存活”。  

  • 清除阶段：回收所有未被标记的对象（即不可达的循环引用对象）。  

• 示例：  
  class Node:  
      def __init__(self):  
          self.ref = None  
  a = Node()  
  b = Node()  
  a.ref = b  # a 引用 b  
  b.ref = a  # b 引用 a → 循环引用  
  del a, b   # 引用计数均为1，但标记-清除会回收  
  

🕒 3. 分代回收（Generational GC）

• 优化策略：基于“对象存活越久，越不可能失效”的假设，将对象分为三代：  

  • 第 0 代（年轻代）：新创建对象，垃圾回收最频繁（默认阈值 700 次分配触发）。  

  • 第 1 代（中年代）：经历 0 代回收后存活的对象，回收频率较低。  

  • 第 2 代（老年代）：长期存活对象，回收频率最低。  

• 晋升规则：对象在一次回收后存活，则晋升到下一代。

🛠️ 4. 手动控制与调优

• gc 模块：  

  • gc.collect()：手动触发全代垃圾回收。  

  • gc.set_threshold(700, 10, 10)：设置各代回收阈值（0 代分配数超阈值即触发）。  

  • gc.disable() / gc.enable()：临时禁用/启用自动回收（需谨慎使用）。  

• 弱引用（weakref）：避免循环引用，不增加对象引用计数。  

💡 总结

Python 的垃圾回收以引用计数为主（实时高效），标记-清除解决循环引用，分代回收提升效率（减少全局扫描）。开发者可通过 gc 模块调优，或使用弱引用避免内存泄漏。

### 36. 魔法函数 __call__怎么使用？
'''
class Bar:
    def __call__(self, *args, **kwargs):
        print('i am instance method')

b = Bar()  # 实例化
b()  # 实例对象b 可以作为函数调用 等同于b.__call__ 使用


OUT: i am instance method



带参数的类装饰器
class Bar:

    def __init__(self, p1):
        self.p1 = p1

    def __call__(self, func):
        def wrapper():
            print("Starting", func.__name__)
            print("p1=", self.p1)
            func()
            print("Ending", func.__name__)
        return wrapper


@Bar("foo bar")
def hello():
    print("Hello")
'''

### 37. 如何判断一个对象时函数还是方法？

'''
在Python中，准确区分函数（Function）和方法（Method）需结合对象的定义位置、绑定状态和类型检查。以下是核心判断方法及示例：

🔍 1. 通过type()或__class__属性直接检查类型

   • 函数：类型为types.FunctionType或显示<class 'function'>。  
     import types
     def my_func(): pass
     print(type(my_func) == types.FunctionType)  # True 
     
   • 方法：类型为types.MethodType或显示<class 'method'>（仅适用于已绑定到实例或类的普通方法/类方法）。  
     class MyClass:
         def my_method(self): pass
     obj = MyClass()
     print(type(obj.my_method) == types.MethodType)  # True 
     

🛠️ 2. 使用inspect模块精准判断

   • inspect.isfunction(obj)：  

     ◦ 返回True表示是函数（包括模块级函数、静态方法、类中未绑定的函数）。  
       import inspect
       print(inspect.isfunction(my_func))  # True
       print(inspect.isfunction(MyClass.my_method))  # True（未绑定时）
       
   • inspect.ismethod(obj)：  

     ◦ 返回True表示是已绑定的方法（实例方法或类方法）。  
       print(inspect.ismethod(obj.my_method))  # True（绑定到实例）
       print(inspect.ismethod(MyClass.my_method))  # False（未绑定）
       

🔗 3. 检查绑定状态（关键区别）

   • 方法：绑定到对象（实例或类），具有__self__属性指向绑定的对象。  
     print(hasattr(obj.my_method, "__self__") and obj.my_method.__self__ is obj)  # True 
     
   • 函数：无__self__属性，或__self__为None。  
     print(hasattr(my_func, "__self__"))  # False 
     

⚖️ 4. 理解本质区别

   • 函数：独立于类，直接定义在模块中或类内但未绑定（如静态方法、类属性访问的普通方法）。  
     class MyClass:
         @staticmethod
         def static_func(): pass
     print(inspect.isfunction(MyClass.static_func))  # True（静态方法本质是函数）
     
   • 方法：绑定到对象，通过实例或类调用时自动传入self/cls参数（如实例方法、类方法）。  
     class MyClass:
         @classmethod
         def class_method(cls): pass
     print(inspect.ismethod(MyClass.class_method))  # True（类方法绑定到类）
     

⚠️ 5. 特殊情况处理

   • 内置函数/方法（如len或[].append）：  

     ◦ inspect.isbuiltin(obj)为True。  

     ◦ 若含__self__（如[].append），则是内置绑定方法；否则是内置函数（如len）。  

   • 实现了__call__的对象：  

     ◦ 可调用但不是函数/方法，需通过type(obj)进一步判断（如functools.partial或自定义类）。  

💡 实用工具函数

直接使用此函数快速判断：
import inspect

def check_callable(obj):
    if not callable(obj): 
        return "Not callable"
    if inspect.ismethod(obj):
        return f"Method (bound to {obj.__self__})"
    if inspect.isfunction(obj):
        return "Function"
    if inspect.isbuiltin(obj):
        return "Built-in function" if getattr(obj, "__self__", None) is None else "Built-in method"
    return f"Callable object ({type(obj).__name__})"

测试
class Foo:
    def method(self): pass
    @classmethod
    def clsmethod(cls): pass
    @staticmethod
    def static(): pass

print(check_callable(Foo().method))  # Method (bound to <Foo instance>)
print(check_callable(Foo.clsmethod)) # Method (bound to <class Foo>)
print(check_callable(Foo.static))    # Function
print(check_callable(len))           # Built-in function
print(check_callable([].append))     # Built-in method 


总结

区分核心在于：  
1. 定义位置：类内定义可能是方法（需绑定），模块级定义是函数。  
2. 绑定状态：方法含__self__指向调用对象，函数无绑定。  
3. 类型检查：优先用inspect.ismethod()和inspect.isfunction()，结合__self__验证。
'''


### 38 简述classmethod和staticmethod的用法和区别

@classmethod 和 @staticmethod 是 Python 中用于定义类中特殊方法的装饰器，核心区别在于参数绑定和访问权限。以下是详细对比：

⚙️ 核心区别

特性 @classmethod @staticmethod

第一个参数 cls（类对象，自动传入） 无特殊参数

绑定对象 绑定类（可访问类属性） 无绑定（独立函数）

访问类属性 ✅ 通过 cls 访问 ❌ 不可直接访问

访问实例属性 ❌ 不可直接访问 ❌ 不可直接访问

继承多态支持 ✅ cls 自动指向调用类（支持子类覆盖） ❌ 无类绑定，不支持多态

典型用途 工厂方法、类属性操作、注册机制 工具函数、验证逻辑、无状态计算

🛠️ 用法与示例

1. @classmethod 的典型场景

• 工厂方法（替代构造函数）  

  根据不同参数创建实例，避免硬编码类名：  
  class Person:
      def __init__(self, name, age):
          self.name = name
          self.age = age
      
      @classmethod
      def from_birth_year(cls, name, birth_year):  # cls 自动绑定 Person 或其子类
          age = 2025 - birth_year
          return cls(name, age)  # 等价于 Person(name, age)
  
  p = Person.from_birth_year("Alice", 1990)  # 直接通过类调用 
  

• 操作类属性  

  修改或读取类级别的共享数据：  
  class Counter:
      count = 0
      @classmethod
      def increment(cls):
          cls.count += 1  # 直接修改类属性
          return cls.count
  Counter.increment()  # 输出: 1 
  

• 继承多态支持  

  子类调用时，cls 自动绑定子类：  
  class Animal:
      @classmethod
      def create(cls):
          return cls()  # 返回调用类的实例
  class Dog(Animal): pass
  dog = Dog.create()  # 返回 Dog 实例（而非 Animal）
  

2. @staticmethod 的典型场景

• 工具函数  

  逻辑与类相关，但无需访问类/实例状态：  
  class MathUtils:
      @staticmethod
      def add(a, b):
          return a + b  # 纯计算，无依赖
  MathUtils.add(3, 5)  # 输出: 8 
  

• 数据验证  

  检查输入合法性，独立于对象状态：  
  class User:
      @staticmethod
      def is_valid_username(name):
          return isinstance(name, str) and len(name) >= 3
  User.is_valid_username("Al")  # 输出: False 
  

• 避免全局函数  

  将相关功能组织在类命名空间中：  
  class DateFormatter:
      @staticmethod
      def format(date):
          return date.strftime("%Y-%m-%d")  # 与类逻辑关联，但无状态依赖 
  

⚠️ 使用建议

1. 何时用 @classmethod？  
   • 需要访问或修改类属性（如计数器、配置管理）。  

   • 需实现多态构造函数（如 from_json(), from_file()）。  

   • 管理类注册机制（如插件系统）。

2. 何时用 @staticmethod？  
   • 方法完全独立于类和实例（如数学计算、格式转换）。  

   • 避免污染全局命名空间，但逻辑归属当前类。

3. 避免滥用  
   • 若方法无需任何类/实例数据，且与类无关，应定义为模块级函数而非静态方法。

💎 总结

• @classmethod：绑定类，用 cls 操作类属性，支持工厂方法和继承多态。  

• @staticmethod：无绑定，仅作命名空间工具，适合独立逻辑函数。  

核心选择原则：是否需要访问类级数据？是 → @classmethod；否 → @staticmethod 或模块函数。


### 39. 如何实现Python的接口？
#抽象类加抽象方法就等于面向对象编程中的接口
from abc import ABCMeta,abstractmethod

class interface(object):
    __metaclass__ = ABCMeta #指定这是一个抽象类
    @abstractmethod  #抽象方法
    def Lee(self):
        pass

    def Marlon(self):
        pass


class RelalizeInterfaceLee(interface):#必须实现interface中的所有函数，否则会编译错误
    def __init__(self):    
        print '这是接口interface的实现'
    def Lee(self):
        print '实现Lee功能'        
    def Marlon(self):
        pass   
https://rosealice2018.github.io/posts/%E5%A6%82%E4%BD%95%E5%AE%9E%E7%8E%B0python%E6%8E%A5%E5%8F%A3/

### 40. Python中的反射？


### 41. 简述metaclass的作用和其应用场景？

### 42. 对比hasattr， getattr，setattr 用法

### 43. 列举Python的magic method和用途

1. __call__:允许一个类的实例像函数一样被调用。实质上说，这意味着 x() 与 x._call_() 是相同的
2.__init__:显示初始化属性
3.__str__,__repr__,定义类的时候，重写这两个方法可以让类更清晰
再就是__setattr__,__getattr__,__delattr__等等

### 44. 如何知道一个python对象的类型？
type（obj）

### 45. any和call方法

#any(x)判断x对象是否为空对象，如果都为空、0、false，则返回false，如果不都为空、0、false，则返回true

#all(x)如果all(x)参数x对象的所有元素不为0、''、False或者x为空对象，则返回True，否则返回False
>>> any('123')
True
>>> any([0,1])
True
>>> any([0,'0',''])
True
>>> any([0,''])
False
>>> any([0,'','false'])
True
>>> any([0,'',bool('false')])
True
>>> any([0,'',False])
False
>>> any(('a','b','c'))
True
>>> any(('a','b',''))
True
>>> any((0,False,''))
False
>>> any([])
False
>>> any(())
False
>>> all(['a', 'b', 'c', 'd'])  #列表list，
True
>>> all(['a', 'b', 'c', 'd'])  #列表list，元素都不为空或0
True
>>> all(['a', 'b', '', 'd'])  #列表list，存在一个为空的元素
False
>>> all([0, 1,2, 3])  #列表list，存在一个为0的元素
False
>>> all(('a', 'b', 'c', 'd'))  #元组tuple，元素都不为空或0
True
>>> all(('a', 'b', '', 'd'))  #元组tuple，存在一个为空的元素
False
>>> all((0, 1,2, 3))  #元组tuple，存在一个为0的元素
False
>>> all([]) # 空列表
True
>>> all(()) # 空元组
True
##注意：空元组、空列表返回值为True，这里要特别注意

### 46. filter方法
https://rosealice2018.github.io/posts/python%E7%9A%84filter%E6%96%B9%E6%B3%95/
### 47. python中是如何管理内存的？

### 48. 退出python事是否释放所有的内存分配？

### 49. is和==区别
is比较的是两个对象的id值是否相等，也就是比较两个对象是否为同一个实例对象，是否指向同一个内存地址。

==比较的是两个对象的内容是否相等，默认会调用对象的__eq__()方法。

### 50. python的作用域？

### 51. python的三元运算符

条件语句比较简单时可以使用三元运算符，最常见的就是 
res = 'test True' if expression is True else 'test False'

### 52. enumerate
# 遍历列表时候，携带索引index
a = ['a','b','c']
for index,item in enumerate(a):
    print(index,item)

### 53. python的全局变量

### 54. python异常处理，和自定义异常类
class NameTooShortError(ValueError): 
    pass
def validate(name):
    if len(name) < 10:
        raise NameTooShortError(name)
        
使用自定义异常类，使得发生异常时的错误更容易排查

### 55. python中最大递归深度多少 如何突破
python解释器限制最大的递归深度是999，可以通过
import sys
sys.setrecursionlimit(10000)  # set the maximum depth as 10000
重新设置最大递归深度(PS:这属于临时修改)
### 56. 什么是面向对象的MRO

### 57. isinstance作用和应用场景
来判断一个对象是否是一个已知的类型
举个栗子：
 p= 'sfa'
 isinstance(p,str)
 True

### 58. 什么是断言？
Python 的断言语句是一种调试工具，用来测试某个断言条件。如果断言条件 为真，则程序将继续正常执行;但如果条件为假，则会引发 AssertionError 异常并显示相关 的错误消息。

### 59. python的lambda表达式

### 60. python的新式类和旧式
python3只支持新式类了

### 61. dir（）
dir() 函数不带参数时，返回当前范围内的变量、方法和定义的类型列表；带参数时，返回参数的属性、方法列表。如果参数包含方法__dir__()，该方法将被调用。如果参数不包含__dir__()，该方法将最大限度地收集参数信息。

### 62. 一个包里有三个模块，demo1.py、demo2.py 和 demo3.py，但使用 from tools import * 导入模块时，如何保证只有 demo1、demo3 被导入？
但若想使用from pacakge_1 import *这种形式的写法，需在  init.py中加上：   all = [‘file_a’, ‘file_b’] #package_1下有file_a.py和file_b.py，在导入时init.py文件将被执行。 
但不建议在 init.py中写模块，以保证该文件简单。不过可在init.py导入我们需要的模块，以便避免一个个导入、方便使用。

### 63. 列举一些python的异常类型和含义

1. ArithmeticError 此基类用于派生针对各种算术类错误而引发的内置异常: OverflowError, ZeroDivisionError, FloatingPointError
2. BufferError 当与 缓冲区 相关的操作无法执行时将被引发。
3. LookupError 此基类用于派生当映射或序列所使用的键或索引无效时引发的异常: IndexError, KeyError。 这可以通过 codecs.lookup() 来直接引发
4. ImportError 当 import 语句尝试加载模块遇到麻烦时将被引发。 并且当 from ... import 中的 "from list" 存在无法找到的名称时也会被引发
5. IndexError 当序列抽取超出范围时将被引发。 （切片索引会被静默截短到允许的范围；如果指定索引不是整数则 TypeError 会被引发

### 64. copy和deepcopy

copy 即所谓的浅拷贝，赋值的时候非递归地复制子对象的引用；
deepcopy 即所谓的深拷贝，赋值的时候递归复制子对象。
举个栗子，
xs = [1,2,[2,3,4],3]
ys = xs # 浅拷贝
zs = deepcopy(xs) # 深拷贝
xs[2][0] = 5
print(ys)
[1,2,[2,3,4],3]
print(xs)
[1,2,[5,3,4],3]

print(zs)
[1,2,[5,3,4],3] # 由于深拷贝已经递归复制了子对象，所以内部的List也发生改变


### 65. 请阐述代码中经常遇到的 *args, **kwargs 的含义及用法
这两个是python中的可变参数。*args表示任何多个位置参数，它是一个tuple；**kwargs表示关键字参数，它是一个dict。并且同时使用*args和**kwargs时，必须*args参数列要在**kwargs前

### 66. Python 中会有函数或成员变量包含单下划线前缀和结尾，或双下划线前缀结尾，它们的区别是什么？

前置单下划线_var:命名约定，用来表示该名称仅在内部使用。一般对 Python 解释器没 有特殊含义(通配符导入除外)，只能作为对程序员的提示。
后置单下划线 var_:命名约定，用于避免与 Python 关键字发生命名冲突。
前置双下划线__var:在类环境中使用时会触发名称改写，对 Python 解释器有特殊含义。
前后双下划线__var__:表示由 Python 语言定义的特殊方法。在自定义的属性中要避免
使用这种命名方式。

### 67. 简述 w、a+ 和 wb 文件写入模式的区别。
w:写入时会覆盖上一次的写入
a+:追加写入
wb:以二进制文件形式写入

### 68. sort和sorted区别

sort()与sorted()的不同在于，sort是在原位重新排列列表，而sorted()是产生一个新的列表

### 69. 什么是负索引？

负索引和正索引不同，它是从右边开始检索。例如：使用负索引取出列表的最后一个数
lis[-1] # 取出列表的最后一个元素
lis[-2] # 取出列表的倒数第二个元素

### 70. pprint模块是干什么的？
print()和pprint()都是python的打印模块，功能基本一样，唯一的区别就是pprint()模块打印出来的数据结构更加完整，每行为一个数据结构，更加方便阅读打印输出结果。特别是对于特别长的数据打印，print()输出结果都在一行，不方便查看，而pprint()采用分行打印输出，所以对于数据结构比较复杂、数据长度较长的数据，适合采用pprint()打印方式

### 71. python中的赋值运算符
在python中，使用 = 可以给变量赋值。
在算术运算时，为了简化代码的编写，Python还提供了一系列与算术运算符对应的赋值运算符
例如，c += a 等效于 c=c+a

### 72. python中的逻辑运算符？
and, or, not

### 73. python中的位运算符？
&	按位与运算符：参与运算的两个值,如果两个相应位都为1,则该位的结果为1,否则为0	(a & b) 输出结果 12 ，二进制解释： 0000 1100
|	按位或运算符：只要对应的二个二进位有一个为1时，结果位就为1	(a | b) 输出结果 61 ，二进制解释： 0011 1101
^	按位异或运算符：当两对应的二进位相异时，结果为1	(a ^ b) 输出结果 49 ，二进制解释： 0011 0001
~	按位取反运算符：对数据的每个二进制位取反,即把1变为0,把0变为1	(~a ) 输出结果 -61 ，二进制解释： 1100 0011， 在一个有符号二进制数的补码形式。
<<	左移动运算符：运算数的各二进位全部左移若干位，由”<<”右边的数指定移动的位数，高位丢弃，低位补0	a << 2 输出结果 240 ，二进制解释： 1111 0000
>>	右移动运算符：把”>>”左边的运算数的各二进位全部右移若干位，”>>”右边的数指定移动的位数	a >> 2 输出结果 15 ，二进制解释： 0000 1111

### 74. python中如何使用多进制数字？
1、二进制数字由0和1组成，我们使用0b或0B前缀表示二进制数

print(int(0b1010))#10
2、使用bin()函数将一个数字转换为它的二进制形式

print(bin(0xf))#0b1111
3、八进制数由数字0-7组成，用前缀0o或0O表示8进制数

print(oct(8))#0o10
4、十六进数由数字0-15组成，用前缀0x或者0X表示16进制数

print(hex(16))#0x10
print(hex(15))#0xf
 

### 75. python怎么实现单例模式？

### 76. python的并发