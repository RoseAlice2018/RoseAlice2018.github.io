---
title: "Langgraph笔记1 实现一个简单demo"
date: 2025-08-20T14:45:48+08:00
draft: false
tags: ["大模型", "langgraph"]
---
- 本文主要构建了一个简单的支持内存存储的对话机器人，同时引入了tools，支持使用tools搜索。
- 具体过程见代码注释
- ```
  import os

  from langchain_tavily import TavilySearch
  from langgraph.checkpoint.memory import MemorySaver
  from langgraph.graph import add_messages, StateGraph
  from langgraph.prebuilt import ToolNode, tools_condition
  from typing_extensions import TypedDict
  from typing import Annotated
  from langchain_deepseek import ChatDeepSeek

  # API 环境变量
  os.environ["LANGCHAIN_API_KEY"] = 
  os.environ["DEEPSEEK_API_KEY"] = 
  os.environ["TAVILY_API_KEY"] = 

  # 初始化大模型
  llm = ChatDeepSeek(
      model="deepseek-chat",
      temperature=0.1,
      streaming=True,
  )

  # Langgraph状态
  class State(TypedDict):
      messages: Annotated[list, add_messages]

  # 构建graph
  graph_builder = StateGraph(State)

  # 内存保存器
  checkpointer = MemorySaver()

  # tools 初始化Tavily搜索工具
  tool = TavilySearch(max_results=2)
  tools = [tool]

  # bind tools to llm
  llm_with_tools = llm.bind_tools(tools)
  def chatbot(state: State):
      return {"messages":[llm_with_tools.invoke(state["messages"])]}

  graph_builder.add_node("chatbot", chatbot)

  # add tool node
  tool_node = ToolNode(tools=[tool])
  graph_builder.add_node("tools", tool_node)

  graph_builder.add_conditional_edges(
      "chatbot",
      tools_condition,
  )
  graph_builder.add_edge("tools", "chatbot")
  graph_builder.set_entry_point("chatbot")
  graph = graph_builder.compile(checkpointer=checkpointer)

  print(graph.get_graph().draw_mermaid())
  def stream_graph_updates(user_input: str, thread_id: str):
      config = {"configurable": {"thread_id": thread_id, "recursion_limit": 2}}
      initial_state = {"messages":[{"role":"user", "content": user_input}]}
      for event in graph.stream(initial_state, config = config):
          for value in event.values():
              print("Assistant:", value["messages"][-1].content)

  # 测试id
  thread_id = "user_123"

  # 执行逻辑
  while True:
      try:
          user_input = input("User: ")
          if user_input.lower() in ["quit", "exit", "q"]:
              print("Goodbye!")
              break
          stream_graph_updates(user_input, thread_id)
      except KeyboardInterrupt:
          print("\nGoodbye!")
          break
  ```
  ### Q&A

  1. 本文中的memory是存储在内存中的。如何持久化存储呢？
  2. 本文实际上只有一个agent，multiagent如何实现呢？
  3. 最近mcp很火，如何加入mcp？
  4. langgraph提供人机协作，添加人类干预点，如何实现？
  5. Langgraph提供状态管理能力，怎么样实现对话历史的回溯和修改？
  6. 如何部署langgrah应用？

