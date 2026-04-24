---
title: "Git Cherrypick"
date: 2024-01-27T19:35:42+08:00
draft: false
tags: ["Git"]
---

## Git Cherry-pick

- Cherry-pick 允许你将某一个特定的commit，从一个分支应用到另一个分支，而不合并整个分支。
- 举例：我有一个stable分支，和一个master分支，我在master分支上做了一个修改，并提交了一个commit，但是master分支和stable分支差异很大，有很多的不同的commit（可能来自于别人的提交），而我只希望将我的这个commit，应用到stable分支上，所以我就可以用cherry-pick执行只合并我这个commit到stable分支上。

### 应用1：修复错误

- 假设你在 `feature-branch`上发现了一个错误，并且这个错误也存在于 `master`分支。你首先在 `feature-branch`上修复了这个错误，然后想要将这个修复应用到 `master`分支。

```matlab
git checkout master
git cherry-pick <commit-hash-from-feature-branch>

```

这里，`<commit-hash-from-feature-branch>`是修复错误的提交哈希值。

### 应用2：代码重用

- 你在 `feature-branch`上开发了一个新功能，现在想要将这个功能的部分代码应用到 `hotfix-branch`。

```matlab
git checkout hotfix-branch
git cherry-pick <commit-hash-from-feature-branch>

```

### 应用3：回滚特定提交

- 如果你想要撤销 `master`分支上的一个特定提交，但不想回滚整个分支。
这会撤销该提交，但不会影响其他提交。

```matlab
git checkout master
git cherry-pick --abort <commit-hash-to-be-undone>

```

### 应用4：代码审查

- 审查者建议对 `feature-branch`上的一个提交进行修改，你根据建议修改了代码。

```matlab
git checkout feature-branch
# 修改代码...
git commit -m "Apply review changes"
git checkout master
git cherry-pick <commit-hash-from-feature-branch>

```

### 应用5：分支策略

- 在Git Flow工作流中，你可能需要将 `develop`分支上的新功能应用到 `release`分支。

```matlab
git checkout release
git cherry-pick <commit-hash-from-develop>

```

### 应用6：避免冲突：

- 当你尝试合并 `feature-branch`到 `master`时遇到了冲突，但你只想合并一个特定的提交。

```matlab
git checkout master
git cherry-pick <commit-hash-from-feature-branch>

```

### 应用7：历史重写

- 如果你不小心提交了敏感信息，想要从历史中移除这个提交.

```matlab
git checkout master
git cherry-pick --abort <commit-hash-to-be-removed>
git reset --soft <commit-hash-to-be-removed^>
# 修改敏感信息...
git commit -m "Remove sensitive information"
git cherry-pick --continue

```