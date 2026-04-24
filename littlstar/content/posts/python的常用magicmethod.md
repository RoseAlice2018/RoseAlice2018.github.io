---
title: "Python的常用magicmethod"
date: 2025-05-10T22:32:22+08:00
draft: false
tags: ["python"]
---
以下是Python中最常用且功能强大的魔术方法（Magic Methods）及其核心用途的分类详解，这些方法以双下划线（__）包裹，由Python解释器在特定场景下自动调用，用于定制类行为：

🔧 一、对象生命周期管理

1. __init__(self, ...)  
   • 作用：对象初始化方法，在实例创建后设置初始属性。  

   • 触发时机：obj = MyClass(args)  

   • 示例：  
     class Person:
         def __init__(self, name):
             self.name = name
     p = Person("Alice")  # 自动调用 __init__
     

2. __del__(self)  
   • 作用：析构方法，对象被销毁（垃圾回收）时调用。  

   • 触发时机：del obj 或对象离开作用域。  

   • 示例：  
     class Resource:
         def __del__(self):
             print("资源已释放")
     

📝 二、对象表示与格式化

1. __str__(self)  
   • 作用：返回用户友好的字符串表示，供 print() 或 str() 使用。  

   • 示例：  
     class Vector:
         def __str__(self):
             return f"Vector({self.x}, {self.y})"
     print(Vector(1, 2))  # 输出: Vector(1, 2)
     

2. __repr__(self)  
   • 作用：返回官方字符串表示，用于调试或 repr()，理想情况下应满足 eval(repr(obj)) == obj。  

   • 示例：  
     class Point:
         def __repr__(self):
             return f"Point({self.x}, {self.y})"
     

⚖️ 三、比较与运算

1. 比较运算符  
   • __eq__(self, other)：定义 ==  

   • __lt__(self, other)：定义 <  

   • 示例：  
     class Book:
         def __eq__(self, other):
             return self.isbn == other.isbn
     

2. 算术运算符  
   • __add__(self, other)：实现 +  

   • __mul__(self, other)：实现 *  

   • 示例：向量加法  
     class Vector:
         def __add__(self, other):
             return Vector(self.x + other.x, self.y + other.y)
     

📦 四、容器行为模拟

1. __len__(self)  
   • 作用：返回容器长度，供 len(obj) 调用。  

   • 示例：  
     class CustomList:
         def __len__(self):
             return len(self.items)
     

2. __getitem__(self, key)  
   • 作用：支持索引访问，如 obj[key]。  

   • 示例：  
     class MyList:
         def __getitem__(self, index):
             return self.data[index]
     

3. __iter__(self)  
   • 作用：返回迭代器，使对象支持 for 循环。  

   • 示例：  
     class Range:
         def __iter__(self):
             return iter(range(self.end))
     

🔍 五、属性访问控制

1. __getattr__(self, name)  
   • 作用：当访问不存在的属性时调用（兜底处理）。  

   • 示例：  
     class Dynamic:
         def __getattr__(self, name):
             return f"属性 {name} 不存在"
     

2. __setattr__(self, name, value)  
   • 作用：设置属性时拦截并验证。  

   • 示例：禁止负年龄  
     class Person:
         def __setattr__(self, name, value):
             if name == "age" and value < 0:
                 raise ValueError("年龄不能为负")
             super().__setattr__(name, value)
     

📞 六、可调用对象

• __call__(self, ...)  

  • 作用：使实例像函数一样被调用（obj()）。  

  • 应用场景：装饰器、状态保持的函数。  

  • 示例：  
    class Adder:
        def __call__(self, x, y):
            return x + y
    add = Adder()
    print(add(2, 3))  # 输出: 5
    

⚠️ 使用建议与注意事项

1. 一致性原则  
   • 实现魔法方法时需符合Python内置类型的行为（如 __len__ 返回非负整数）。  

2. 避免过度使用  
   • 仅在必要时重载，避免降低代码可读性（例如，不要用 __add__ 实现非加法逻辑）。  

3. 调试支持  
   • 优先实现 __repr__ 而非 __str__，因其在调试时更关键。  

4. 性能敏感场景  
   • __getattribute__ 影响所有属性访问，需谨慎实现以防性能瓶颈。  

总结：魔术方法是Python面向对象编程的核心机制，通过定制这些方法，开发者可使自定义类无缝集成到Python生态中（如支持运算符、迭代、上下文管理等）。合理使用能大幅提升代码表达力，但需平衡灵活性与可维护性。

