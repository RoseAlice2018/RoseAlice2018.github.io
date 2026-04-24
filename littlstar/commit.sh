#!/bin/bash

# 检查是否提供了输入参数
if [ -z "$1" ]; then
  echo "请提供一个字符串作为commit message"
  exit 1
fi

# 将第一个输入参数赋值给变量 str
str="$1"

hugo 

cd ./public

git add .

git commit -m "${str}"

git push origin main
