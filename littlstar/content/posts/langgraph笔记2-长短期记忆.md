---
title: "Langgraph笔记2 长短期记忆"
date: 2025-08-20T14:46:20+08:00
draft: false
tags: ["大模型", "langgraph"]
---


### 短期记忆 （short-term memory)

- 短期记忆（short-term memory)：一般来讲针对单个对话（会话），保存在内存中。

  - 一般可以通过State的messages管理会话消息，可以通过checkpointer保存到内存或者数据库中。
  - 在每个node节点开始的时候读取，在graph被调用或者某个步骤完成时更新。
  - 最常见的短期记忆就是conversation history 对话历史。
  - 简单实现一个短期记忆
    - State里messages作为对话消息，add_messages是每次步骤完成更新messages做的操作，langgraph框架的reducer会替换同id的messages，并添加到末尾，保证消息的时序性，add_messages就是一个典型的reducer。（r**educer是langgraph状态管理的关键组件，用于定义节点返回的增量更新如何合并到全局状态。**）

```
class State(TypedDict):
    messages: Annotated[list, add_messages]

checkpointer = InMemorySaver()

graph = graph_builder.compile(checkpointer=checkpointer)

def stream_graph_updates(user_input: str, thread_id: str):
    config = {"configurable": {"thread_id": thread_id, "recursion_limit": 2}}
    initial_state = {"messages":[{"role":"user", "content": user_input}]}
    for event in graph.stream(initial_state, config = config):
        for value in event.values():
            print("Assistant:", value["messages"][-1].content)

```

### 长对话历史如何管理

- 为什么要管理长对话？
  - 最直接的节省tokens成本，过长的对话历史也可能超出上下文的窗口限制，或者导致性能下降。

#### 编辑消息列表

- 原理：通过定义reducer函数，来编程性的删除旧消息，例如只保留最近的N条消息，超出消息的删除.

#### summary总结

- 原理：通过llm对历史对话进行摘要，并将摘要作为新的上下文传入，以减少消息数量同时保留关键字信息。

#### 消息截断

- 原理：trim_messages。根据指定的策略，令牌限制，模型要求以及是否包含系统消息等来裁剪消息列表。

### 长期记忆 (long-term memory)

- 长期记忆：可以跨对话线程共享，可以在任何时间，任何线程中被回忆，而不像短期记忆局限于单个对话。
  - 可以存储为JSON文档， 存进数据库中持久化。
- 记忆类型：
  - 语义记忆（Semantic Memory）： 存储事实和概念。
    - Profile（档案）：将关于用户，组织或代理自身的特定信息存储为一个持续更新的JSON文档。需要模型能生成新的文档或JSON补丁来更新现有的文档。
    - Collection（集合）：将记忆存储为一组独立的文档，每个文档范围更窄。易于生成，但搜索和更新（删除或修改现有文档）可能更复杂，而且难以捕捉记忆间的完整上下文。
  - 情景记忆（Episodic Memory）：存储过去的事件或行为经验。常通过少样本示例（few-shot example prompting）实现，代理通过学习过去的序列来正确执行任务。LangSmith Dataset 也可以用于存储少样本示例并支持动态检索
  - 程序记忆（Procedural Memory）：存储执行任务的规则或命令。通常通过修改代理自身的提示（prompt） **来实现，例如通过** “反射”（Reflection）或元提示，让代理根据对话和用户反馈来改进其指令。
- 记忆更新时机：
  - 热路径（Hot Path）： 在代理的应用程序逻辑运行时实时创建记忆。优点是实时更新和透明度，但可能增加复杂性、延迟，并影响记忆的数量和质量。例如 ChatGPT 使用 `save_memories` 工具。
  - 后台(Background): 作为单独的异步任务创建记忆。优点是避免主应用延迟、分离逻辑，并允许更聚焦的任务完成。挑战在于确定更新频率和触发时机（例如，按时间、Cron 任务或手动触发）。