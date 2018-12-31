---
title: linux-interface-04
date: 2018-12-30
tags: linux, books
---
The linux programming interface
----------


## 文件IO 通用的IO模型

**文件描述符： 一个非负整数，来指代打开的文件，其中包括： 管道FIFO socket，终端 设备 普通文件**
1. 标准文件描述符:

    | 文件描述符 | 用途     | 名称          | stdio  |
    | :-----------| :---------| :--------------| :-------|
    | 0          | 标准输入 | STDIN_FILENO  | stdin  |
    | 1          | 标准输出 | STDOUt_FILENO | stdout |
    | 2          | 标准错误 | StDERR_FILENO | stderr       |

2. 主要的系统调用
   * open(pathname, flags, mode) open创建新文件时候， 即 flags 中包含 O_creat 标志，mode制定了文件的访问权限。flags还有许多的可选参数， 包括O_APPEND, O_ASYNC等等。
   * read(fd, buffere, count), read 调用成功返回 实际读取的字节数， 如果遇到文件结束EOF 则返回0， 出席那错误 -1， 一次read 可能返回的 字节数可能小于count， fd为文件时候， 可能是文件靠近结尾，（所以文件尾部时候是不是小于count还是一个0？），fd为其他类型时候， socket， 终端，例如在终端遇到\n read调用就会结束。在有需要注意， C语言， 如果输入缓冲区， buffere 需要一个表示终止的空字符串，需要自己显示添加
   * write(fd, buffer, count), write 为将buffer中的数据写入fd中，error 返回-1， 其他返回写入的字节数， 写入字节数可能小于count （进程资源对文件大小的限制，磁盘满等， 造成部分写），write成功并不能保证已经写入到文件中，而是高速缓冲区，系统会缓存磁盘IO。
   * close(fd) close error -1，success 0， 文件属于有限资源，文件描述符关闭失败可能导致一个进程将资源消耗殆尽。编写长期运行的程序，比如网络服务器显得尤为重要。所以，总是显式的关闭文件描述符。
   * lseek(fd, offset, whence) 改变文件偏移量。文件偏移量是下一个read， write 等的起始点。文件打开指向文件头，read, write 自动调整偏移量。
   * /proc/PID/fdinfo 目录下，可以获取系统任一进程中文件描述符的相关信息。针对进程中的每一个已打开的文件描述符，该目录下都有对应的文件， 以对应的文件描述符的数值命名，其中文件中的pos为文件偏移量， flags字段 则为一个八进制数, 其格式形如

     ``` text
        pos:  0
        flags: 02
        mnt_id: 9
     ```
