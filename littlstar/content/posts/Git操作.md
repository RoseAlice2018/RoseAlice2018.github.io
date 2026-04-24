---
title: "Git操作"
date: 2024-01-27T19:08:57+08:00
draft: false
tags: ["Git"]
---

### git config --list --local

- 查看本地仓库的Git配置

### git status [文件]

- 查看git跟踪的文件状态

### git diff [文件]

- 对比Git跟踪的文件修改前后的具体变化。

### git add .|文件

- 将文件从工作区提交到暂存区

### git commit -m "提交说明"

- 将文件从暂存区提交到本地库

### git log --oneline --graph

- 查看提交历史

### git reset --hard HEAD^|HEAD~|commit_id

- 本地库，暂存区，工作区版本回退。

### git reset --soft HEAD^|HEAD~|commit_id

- 本地库回退，暂存区，工作区不回退

### git reset --mixed HEAD^|HEAD~|commit_id

- 本地库，暂存区回退，工作区不回退

### git checkout -- .|文件

- 撤销工作区的修改

### git reset HEAD .|文件

- 撤销暂存区的修改，放回至工作区

### git rm 文件

- 删除工作区的文件，当删除了工作区的文件的时候，也需要删除本地库相对应的文件。

### git clone url

- 克隆远程库到本地

### git remote add origin url

- 将本地库与远程库关联，默认远程库命名为origin。一个本地库可以关联多个远程库。

### git remote rm origin

- 删除已经关联的名为Origin的远程分支

### git remote -v

- 查看远程库信息

### git remote show origin

- 查看remote地址，远程分支，还有本地分支，与之对应关系等信息。

### git push [-u] origin 分支

- 将本地分支推送到远程仓库origin，第一次推送需要加-u

### git branch

- 查看本地库所有分支

### git branch -r

- 查看远程库所有分支

### git branch -a

- 查看本地库和远程库的所有分支

### git branch 分支 当前分支

- 基于当前分支创造新的分支

### git branch 分支 origin/分支

- 基于远程库分支创建新的分支

### git checkout 分支

- 切换分支

### git checkout -b 分支 当前分支|origin/分支

> 基于当前分支或远程库的分支创建新的分支，并切换到该分支
> 

### git branch -d 分支

> 删除分支
> 

### git branch -D 分支

> 强制删除分支，丢弃一个没有被合并过的分支
> 

### git push origin --delete 分支

> 删除远程分支
> 

### git remote prune origin

> 删除本地远程仓库不存在的分支
> 

### git merge 分支

> 合并某分支到当前分支
> 

### git merge --no-ff -m “” 分支

> 普通模式合并某分支到当前分支，会生成一次commit记录
> 

### git stash

> 将所有未提交的修改内容（包括工作区和暂存区）储藏起来，并将本地库回退到上个版本
> 

### git stash list

> 查看储藏的stash列表
> 

### git stash apply

> 恢复储藏的stash
> 

### git stash drop

> 删除储藏的stash
> 

### git stash pop

> 恢复并删除储藏的stash
> 

### git branch --set-upstream-to 分支 origin/分支

> 创建本地分支和远程分支的链接关系
> 

### git tag 标签 [commit_id]

> 创建新的标签，默认打在最新提交的commit上
> 

### git tag

> 查看所有标签
> 

### git show 标签

> 查看标签信息
> 

### git tag -a 标签 -m "" [commit_id]

> 创建带有说明的标签
> 

### git tag -d 标签

> 删除标签
> 

### git push origin 标签

> 推送标签到远程
> 

### git push origin --tags

> 推送全部未推送过的标签到远程库
> 

### git push origin :refs/tags/标签

> 删除远程标签
> 

### git branch -m 旧分支 新分支

> 重命名分支名
> 

### git rebase -i (,]

> 编辑commit，前开后闭
>