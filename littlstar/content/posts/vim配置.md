---
title: "Vim配置"
date: 2024-01-14T19:06:04+08:00
draft: false
tags: ["Vim"]
---

# vim配置


### 安装Universal-ctags

```bash
$ git clone https://github.com/universal-ctags/ctags.git
    $ cd ctags
    $ ./autogen.sh
    $ ./configure  # use --prefix=/where/you/want to override installation directory, defaults to /usr/local
    $ make
    $ make install # may require extra privileges depending on where to install
```

### 安装vim-plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

在vimrc文件添加

```bash
call plug#begin('~/.vim/plugged')
" 在这里添加您的插件配置
call plug#end()
```

vim-plug 使用

```bash
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

$ vim        #打开vim
:PlugStatus  #查看插件状态
:PlugInstall #安装之前在配置文件中声明的插件
```

### Ack-vim 使用

```bash
https://github.com/mileszs/ack.vim
```

请查看reademe

```bash
?    a quick summary of these keys, repeat to close
o    to open (same as Enter)
O    to open and close the quickfix window
go   to preview file, open but maintain focus on ack.vim results
t    to open in new tab
T    to open in new tab without moving to it
h    to open in horizontal split
H    to open in horizontal split, keeping focus on the results
v    to open in vertical split
gv   to open in vertical split, keeping focus on the results
q    to close the quickfix window
```

### BufExplorer

```bash
Plug 'jlanzarotta/bufexplorer' 
" 安装bufexplorer插件

""""""""""""""""""""""""""""""
" BufExplorer          
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0       " Do not show default help.                                                                                                                                                                                  
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=1        " Split left.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = 30  " Split width
let g:bufExplorerUseCurrentWindow=1  " Open in new window.
let g:bufExplorerDisableDefaultKeyMapping =0 " Do not disable default key mappings.
nnoremap <silent> <F4> :BufExplorer<CR>
```

CtrlP插件

```bash
Plug 'ctrlpvim/ctrlp.vim'
```

要使用 CtrlP 进行文件查找，请按下快捷键 `<Ctrl-p>`（或 `<Cmd-p>` 在 macOS 上），这将打开 CtrlP 窗口。在 CtrlP 窗口中，可以输入文件名的一部分来进行模糊匹配，并使用上下箭头键选择文件。按下 `<Enter>` 键将在 Vim 中打开选定的文件。

### cscope

```bash
sudo yum install cscope

```

vimrc添加配置

```bash
set cscopequickfix=s-,c-,d-,i-,t-,e-
set csprg=cscope
set csto=0
set cst
set nocsverb
if filereadable("/usr/bin/cscope")
    set csprg=/usr/bin/cscope
endif
```

生成cscope数据库

```bash
cscope -Rbq
```