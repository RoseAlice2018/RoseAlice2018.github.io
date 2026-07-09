---
title: "构建 Hugo 博客自动发布 Skill 的实战记录"
date: 2026-07-09T15:30:00+08:00
draft: false
tags: ["Hugo", "Skill", "CI", "GitHub Actions"]
---

最近把博客从「手动本地构建 + 推送静态文件」改成了「只提交 Markdown，CI 自动构建部署」的模式，并顺手写了一个发布 Skill 把整个流程串起来。本文记录中间踩过的几个坑和最终方案。

### 1. 目标

输入：一篇 Markdown 正文（带标题，可选 tags）。
输出：文章自动出现在线上博客列表里，并拿到可访问的 URL。

约束：

- 本地**不**安装 Hugo，构建完全交给 GitHub Actions；
- 一条命令完成「建文件 → 提交 → 推送 → 验证上线」全流程；
- 失败要能定位，而不是沉默地"看起来成功了"。

### 2. 架构

整体链路：

```
本地写 .md ──push──▶ GitHub Actions runner ──▶ GitHub Pages
                     ├─ checkout 代码
                     ├─ 安装 Hugo CLI
                     ├─ hugo --minify  生成 public/
                     └─ 上传 public/ 作为 Pages artifact
```

关键点：**Hugo 在 CI 里跑**。本地只需要 git，不需要 Hugo。这一点很多人没意识到——以为必须本地装 Hugo 才能预览/构建，其实只要把源码目录指给 workflow，CI 一条 `hugo --minify --baseURL ...` 就完事。

### 3. 踩过的坑

#### 坑 1：文章 push 上去，列表里看不到

源文件确实提交了，CI 也 success，但线上 `/posts/` 列表就是没这篇。

根因：**Hugo 默认跳过日期在"未来"的文章**（`buildFuture = false`）。当文章 front matter 里的 `date` 晚于 CI 实际运行时刻时，文章在构建阶段被直接丢弃。

复现条件很常见：

- 文章里把日期写成"想要的发布时间"，而那时间还没到；
- 写完立刻 push，但 push 时刻 < 文章 date；
- 跨时区导致 date 被解析成更靠后的 UTC 时间。

修复有两种思路：

1. 在 `config.toml` 顶部加 `buildFuture = true`，一劳永逸；
2. 让 date 始终是"真实提交时刻"，不要手填未来时间。

我选了第一种兜底，同时 Skill 里写规则保证 date 用当前真实时间。

#### 坑 2：Skill 文档里的路径写错了一个字母

初版 Skill 里把仓库根路径写成了单数 `blog`，而实际是 `blogs`。一字之差，路径不存在直接报错。

教训：Skill 这种「写死路径」的脚本，路径要从实际仓库结构验证一遍，而不是凭记忆。

#### 坑 3：`git add .` 把无关改动一起带上去

发布博客时，工作区可能还残留着别的实验性改动（改了一半的配置、临时文件等）。如果 Skill 用 `git add .` 或 `git add -A`，这些都会被一起 commit 进去，污染历史甚至泄露敏感内容。

正确做法：**只 add 当前这篇新文章这一个文件**：

```bash
git add path/to/posts/<这篇>.md
git commit -m "新增博客：<标题>"
```

#### 坑 4：URL 用了已废弃的旧域名

Skill 旧版里硬编码了一个旧的自定义域名作为最终 URL。这个域名早就不用了，但 Skill 模板里还留着，导致"发布成功"但给的链接是 404。

教训：Skill 文档里凡是写死的常量（域名、分支名、目录），要和当前事实对齐，最好集中到一个变量块里方便维护。

#### 坑 5：缺少"验证上线"环节

最初流程在 `git push` 之后就结束了，告诉用户"发布成功"。但实际上 push 成功 ≠ CI 成功 ≠ 部署成功 ≠ 文章真的出现在列表里。任何一环出错用户都看不到文章，却以为成功了。

补上验证步骤：

1. 调 GitHub Actions API 查最新一次 run 的 `status` / `conclusion`，等到 `completed`；
2. 如果 `conclusion != success`，读日志定位失败原因，修了重推；
3. 成功后抓线上 `/posts/` 列表页，确认文章标题真的出现在列表里；
4. 才告诉用户"上线了"，并给出 URL。

这一步加上后，整个 Skill 才算闭环。

### 4. 最终 Skill 流程

```
1. 解析用户输入 → 标题 / 正文 / tags
2. date = 当前真实时间（ISO 8601 + 时区）
3. 写文件到 posts/<slug>.md（只 add 这一个文件）
4. git commit -m "新增博客：<标题>" && git push
5. 轮询 CI 直到 completed
   - 非 success → 读日志、定位、修复、重推
6. 抓线上 /posts/ 列表，确认文章出现
7. 给用户最终 URL
```

### 5. 几条可复用的经验

- **构建交给 CI，本地保持轻量**：源码仓库只放 Markdown + 配置 + workflow，不放生成的 HTML。本地一个 git 就能发博客。
- **永远不要相信"看起来成功了"**：每一步都要有验证。push 成功不等于上线。
- **Skill 里不要 `git add .`**：精确添加本次产物，避免污染。
- **写死常量集中管理**：域名、分支、目录路径放一起，迁移时改一处。
- **buildFuture 这类默认值要心里有数**：Hugo 对"未来文章"的处理是静默丢弃，不报错，最阴险。

### 6. 小结

把 Hugo 构建挪到 CI 之后，发博客变成「写 Markdown → 一句话」的事。Skill 真正的价值不在写文件本身，而在**把"验证上线"这一步自动化**——让沉默失败变得可见。
