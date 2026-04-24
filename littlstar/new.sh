#!/bin/bash

# 检查是否提供了输入参数
if [ -z "$1" ]; then
  echo "请提供一个字符串作为文章名称。"
  exit 1
fi

# 将第一个输入参数赋值给变量 str
str="$1"

# 使用 hugo new 命令创建新文章
hugo new "posts/${str}.md"

# 检查命令是否成功执行
if [ $? -eq 0 ]; then
  echo "文章 ${str}.md 已成功创建！"
else
  echo "创建文章时出错"

hugo