---
title: "从functioncall到mcp再到skills"
date: 2026-02-01T01:38:17+08:00
draft: false
---

## 从function_call 到 MCP 再到Skills

- 我觉得这属于一脉相承的演变，核心的目标/思路就是如何让LLM从讲述方案走向执行方案，和如何更好的执行方案。

首先，function_call算是鼻祖，它通过将自然语言转化为结构化的语言如JSON来解决LLM从说到做的跨越。MCP和SKILLS的底层思想都算是某种意义上更复杂一点的function_call。

但是每个agent/project都写一堆可能重复功能的function_call也很麻烦，有一些功能在项目内部是通用的，甚至对于外部用户可能也有相同的业务需求，所以MCP出现。

MCP提供了一套官方协议，目标是统一工具和数据的接入方式，解决的是functioncall标准不一致，泛滥，和复用的问题。这样的话开发者可以以更标准的的方式来给AI扩展能力。

Skills 相当于进一步的深化。既然AI需要call不同的function/MCP来实现功能，把这个逻辑写成workflow，为什么不直接把workflow文档化，让LLM去调用。我理解Skills相当于一个Markdown化的Workflow。

所以Skills关注的核心是如何实现一个完成的任务，把如何完成任务的要素打包成一个文档，然后渐进式加载（这个思路其实学计算机的都很熟悉，比如虚拟化进程等等非常多的地方都用到），来实现目标。

Anyway，我觉得这思路并不复杂，只是写一个好的Skills文档和写一个好的prompt一样需要不断的优化，如果愿意去写workflow 也可以。