---
title: "Python的作用域"
date: 2025-03-27T23:10:46+08:00
draft: false
tags: ["python"]
---

Python 中的作用域定义了变量的可访问范围，主要分为以下四种类型，遵循 LEGB 查找规则（Local → Enclosing → Global → Built-in）：

1. 局部作用域（Local Scope）  
   • 在函数或方法内部定义的变量，仅在其所属的函数内可见。  

   • 函数执行结束后，局部变量会被销毁。  

   • 示例：  
     def func():
         local_var = 10  # 局部变量
         print(local_var)  # 函数内可访问
     func()  # 输出 10
     # print(local_var)  # 报错：外部无法访问
     

2. 嵌套作用域（Enclosing Scope）  
   • 在嵌套函数中，内部函数可以访问外部函数的变量（非全局）。  

   • 若需修改外部函数的不可变对象（如整数、字符串），需使用 nonlocal 关键字。  

   • 示例：  
     def outer():
         x = 5
         def inner():
             nonlocal x  # 声明修改外部变量
             x = 10
         inner()
         print(x)  # 输出 10（外部变量被修改）
     outer()
     

3. 全局作用域（Global Scope）  
   • 在模块最外层定义的变量，整个模块内可见。  

   • 函数内部默认只能读取全局变量；若需修改，需用 global 关键字声明。  

   • 示例：  
     global_var = 1
     def func():
         global global_var  # 声明修改全局变量
         global_var = 2
     func()
     print(global_var)  # 输出 2
     

4. 内置作用域（Built-in Scope）  
   • 包含 Python 内置函数和异常（如 print()、len()、TypeError）。  

   • 在任何作用域中均可直接访问，优先级最低（若其他作用域有同名变量会被覆盖）。  

   • 示例：  
     print(len("Hello"))  # 输出 5（调用内置函数 len）
     

补充说明：

• LEGB 规则：当访问变量时，Python 按 局部 → 嵌套 → 全局 → 内置 的顺序逐层查找，若均未找到则抛出 NameError。  

• 关键操作：  

  • global：在函数内修改全局变量。  

  • nonlocal：在嵌套函数内修改外部函数变量。  

合理利用作用域规则能避免命名冲突、提升代码可维护性，尤其在闭包和装饰器等高级场景中至关重要。
