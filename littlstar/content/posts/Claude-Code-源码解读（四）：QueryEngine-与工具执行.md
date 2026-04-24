---
title: "Claude Code 源码解读（四）：QueryEngine 与工具执行"
date: 2026-04-24T10:00:00+08:00
draft: false
tags: ["Claude Code", "AI", "源码解析"]
---

### 4.1 QueryEngine

- QueryEngine 本质上一个循环 不断地接受用户input 然后执行的流程

- UserInput -> 模型推理 -> 工具执行 -> 再推理

- Agent与单次API调用的区别就在于此，Agent的行为存在多轮 包括tool的调用 自动重试 压缩等一系列行为

TODO
queryEngine使用了异步生成器 -> 方便流式输出和中途中断


QueryEngine的主要工作内容
1. 准备message（compaction 如果有必要）
2. 调用API（Streaming）
3. 收集响应+工具请求
4. 处理错误（静默修复）
5. 执行工具
6. 检查预算（token/金钱/轮次）
7. 有工具则发送结果继续
8. 无工具则退出

好的，这是根据您提供的图片提取的 Markdown 表格：

| 步骤 | 核心动作 | 主要产出 | 若失败常见后果 |
| :--- | :--- | :--- | :--- |
| 1 | 组装 `messages[]`，触发压缩 | 可发送的上下文窗口 | 压缩熔断、上下文爆炸 |
| 2 | `stream: true` 调 Messages API | SSE / chunk 流 | 网络错误 → 进入步骤 4 |
| 3 | 解析 `content` 块 | 文本 + `tool_use` 列表 | 解析异常 → 重试或降级 |
| 4 | 分类错误、退避、重试 | 恢复后的流或终止决策 | 用户无感或温和提示 |
| 5 | 并行/串行执行工具 | `tool_result` 块 | 权限拒绝、工具超时 |
| 6 | 估算 token、费用、轮次 | `continue` / `break` | **硬停止** |
| 7 | 把工具结果追加进历史 | 下一轮 `messages` | 历史不一致 |
| 8 | 无 `tool_use` | `return` 最终结果 | 正常结束 |


### 4.2 Compaction 策略


| 策略 | 做法 | 代价 |
| :--- | :--- | :--- |
| 滑动窗口 | 丢掉最早若干轮 | 丢事实，可能忘需求 |
| 摘要替换 | 用短摘要替代大块 `user/assistant` | 摘要可能丢细节 |
| 结构化保留 | 保留「当前任务描述 + 最近 N 轮」 | 实现复杂 |
| 工具轨迹裁剪 | 删冗长 `tool_result`，保留结论 | 调试信息变少 |


### 4.3 流式响应

### 4.4 tool-use

- 类似function-call 输出结构化的Tool-use块，由客户端代为执行再把结果返回。

```
type ToolUseBlock = {
  type: "tool_use";
  id: string;        // 全局唯一，用于 tool_result 对齐
  name: string;      // 与注册表中的工具名一致
  input: unknown;    // 通常是对象，来自 JSON 解析
};
```


### 4.5 静默修复
