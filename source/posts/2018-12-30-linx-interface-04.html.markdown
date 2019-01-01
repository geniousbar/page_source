---
title: linux-interface-04
date: 2018-12-30
tags: linux, books
---
The linux programming interface
----------


### 文件IO 通用的IO模型
------------
**文件描述符： 一个非负整数，来指代打开的文件，其中包括： 管道FIFO socket，终端 设备 普通文件**
1. 标准文件描述符:

    | 文件描述符 | 用途     | 名称          | stdio  |
    | :-----------| :---------| :--------------| :-------|
    | 0          | 标准输入 | STDIN_FILENO  | stdin  |
    | 1          | 标准输出 | STDOUt_FILENO | stdout |
    | 2          | 标准错误 | StDERR_FILENO | stderr |

2. 主要的系统调用
   * open(pathname, flags, mode) open创建新文件时候， 即 flags 中包含 O_creat 标志，mode制定了文件的访问权限。flags还有许多的可选参数， 包括O_APPEND, O_ASYNC等等。
   * read(fd, buffere, count), read 调用成功返回 实际读取的字节数， 如果遇到文件结束EOF 则返回0， 出席那错误 -1， 一次read 可能返回的 字节数可能小于count， fd为文件时候， 可能是文件靠近结尾，（所以文件尾部时候是不是小于count还是一个0？），fd为其他类型时候， socket， 终端，例如在终端遇到\n read调用就会结束。在有需要注意， C语言， 如果输入缓冲区， buffere 需要一个表示终止的空字符串，需要自己显示添加
   * write(fd, buffer, count), write 为将buffer中的数据写入fd中，error 返回-1， 其他返回写入的字节数， 写入字节数可能小于count （进程资源对文件大小的限制，磁盘满等， 造成部分写），write成功并不能保证已经写入到文件中，而是高速缓冲区，系统会缓存磁盘IO。
   * close(fd) close error -1，success 0， 文件属于有限资源，文件描述符关闭失败可能导致一个进程将资源消耗殆尽。编写长期运行的程序，比如网络服务器显得尤为重要。所以，总是显式的关闭文件描述符。
   * lseek(fd, offset, whence) 改变文件偏移量。文件偏移量是下一个read， write 等的起始点。文件打开指向文件头，read, write 自动调整偏移量. whence 可选参数为 SEEK_SET, SEEK_CUR, SEEK_END, 分表表示offset的基准坐标 为 文件开始头部， 当前偏移量， 文件末尾。 offset 可以为负数 表示，向前偏移多少。调用成功返回移动之后的偏移量。可以使offset为0 来获取当前偏移量。lseek并不适合所有类型的文件，应用与管道， FIFO, socket或者终端，调用将会失败， errno 被设定为ESPIPE.
   * ioctl(fd, request, ....args) 对为纳入标准IO模型的所有设备和文件操作而言，ioctl系统调用是个万金油
   * /proc/PID/fdinfo 目录下，可以获取系统任一进程中文件描述符的相关信息。针对进程中的每一个已打开的文件描述符，该目录下都有对应的文件， 以对应的文件描述符的数值命名，其中文件中的pos为文件偏移量， flags字段 则为一个八进制数, 其格式形如

     ``` text
        pos:  0
        flags: 02
        mnt_id: 9
     ```
*文件空洞，在 文件结尾+ offset的位置写入数据，会发生什么情况，文件结尾开始到offset 中会产生空洞。文件空洞的特点在于它并不占用磁盘空间，只有当空洞中有数据写入时候，才会分配磁盘空间。 编程角度看读取空洞返回0。空间的存在，造成 文件名义上的大小可能要比其占用的磁盘存储总量要大，当空洞被写入文件时候，内和为其分配存储空间，磁盘可用空间减少。*

### 深入探究文件IO
-------------------------------------------------------------------------------
**原子操作： 将某一系统调用所要完成的各个动作作为不可中断的操作，一次性加以完成, 是许多系统调用的以正确完成的必要条件**
**竞争状态是这样一种情形：操作共享资源的两个进程或线程，结果取决于 一个无法预期的顺序，即这些进程获取CPU使用权的先后相对顺序**

1. open, 保证进程是打开文件的创建者，对文件是否存在的检查和创建文件属于同一原子操作。 flags: O_CREAT
2. fcntl: fcntl(fd, cmd,...) 该调用对一个打开的文件描述符执行一系列控制操作。用途之一: 对一个打开的文件， 获取或修改其访问模式和状态标志。通过open也可以设定，所以fcntl针对已经打开的文件描述符，1）文件不是由调用程序打开的， 2）通过open之外的系统调用获取的， 比如pipe，socket， 等。 示例代码

   ```c
    int flags, accessMode;
    flags = fcntl(fd, F_GETFL); // 获取flags
    if (flags == -1)
        errExit("fcntl");
    flags |= O_APPEND; // operate flags
    fcntl(fd, F_SETFL, flags)  // set flags   
   ```
   因为 O_RDONLY, OWRONLY, O_RDWR, 因为历史原因，数值为0,1,2所以不能简单的使用 & 来判断是否存在对应的标记位， 如下为正确的做法

   ```c
     accessmode = flags & O_ACCMODE
     if (accessmode === O_WRONLY || accessMode == O_RDWR || accessmode == O_RDONLY)
      prinf("xx")
   ```
3. 文件描述符与文件的关系
  1. 结构
     * 进程级别的文件描述符，记录的标志有 close-on-exec, 并指向到系统级 文件表
     * 系统级 文件表： 记录了: 文件偏移量， 打开文件的状态标记（open flags）, 文件访问模式，与信号驱动IO相关的g设地年， 对该文件I-node对象的引用
     * 文件系统的i-node表: 文件类型，一个指针，指向该文件所持有的锁列表， 文件的各种属性（包括文件大小， 已经时间戳）。 区分与磁盘中的i-node，这里是内存的i-node， 访问文件时候，会在内存中为i-node创建一个副本，其中记录了引用i-node的打开文句柄的数量，以及所在设备的主从设备等。
       * [ ] 添加指向 csapp的图片
  2. 文件设计的这些特点，可以产生如下的总结：
     1. 两个不同文件描述符， 若指向同一个文件句柄(系统及的文件表)将共享同一个文集偏移量。通过其中一个更改偏移量，另外一个可以观察到该变化，无论两个描述符在不同进程还是统一进程，亦或线程。
     2. fcntl 操作的作用域 同 1相同
     3. 对应的 文件描述符的 close-on-exec 因为存储在进程级别， 所以并不会影响到其他进程。
     4. cat log.log > result.log 2>&1 shell通过复制 文件描述符2实现了标准错误的重定向操作。因为描述符2同1指向同一个文件句柄，所以输出不会产生覆盖彼此的问题。
   2. 复制文件描述符
      * dup(int oldfd), 复制一个打开的文件描述符oldfd， 并返回一个新的描述符， 两者指向同一个文件句柄，系统保证新描述符一定是编号值最低的未用的文件描述符。意味着dup(1)会产生3
      * dup2(oldfd, newfd)： 系统调用会创建oldfd的副本，编号由newfd决定， 如果newfd已经打开，会先将其关闭，然后返回newfd指定的编号的文件描述符。（所以dup2(调用了那个接口，来产生特定编号的文件描述符。)） 但是dup2关闭newfd时候会忽略错误， 所以 最好手动关闭newfd,
      * pread, pwrite(fd, buf, count, offset)： 区别于 read, write的地方在于， pread, pwrite 会在指定的offset进行操作，并且不会改变文件的偏移量。这些特性是的 使得在多线程应用非常便利，多个进程可以同时操作同一个描述符。而不会互相影响。如果使用lseek， read调用引起竞争状态。使得编写正确的IO代码变得困难。
      * 分散输入和集中输出, (scatter-gather IO), readv, writev
      * 截断: truncate(char * pathname, length), ftruncate(fd, length): 若文件长度> length 丢弃超出部分， < length, 将在文件尾部添加一系列空字节或者文件空洞(版本实现比一样吗？)其中 truncat 通过字符串指定名字但是依然需要文件的写权限。
  3. 非阻塞IO： 1) open 指定 O_NONBLOCK, 2） socket因为无法通过open来获取文件描述符， 所以需要使用fcntl来启动非阻塞标志。
  4. -【】大文件
  5. /dev/fd: 是一个连接到 /proc/PID/fd 目录的一个符号连接， 该目录中的每一个目录都连接到 /proc/PID/fd中的目录，一一对应
  6. 临时文件：mkstemp(char * template), tmpfile(): 打开文件使用了O_EXCL 以保证独占使用文件。两者区别在于 mkstemp()之后需要unlink(char* template), 在close(fd) 之后自动删除， tmpfile 则无需调用unlink, close之后 自动删除（内部自动调用unlink）

## 进程
**进程 是可执行程序的实例**
1. 进程号 和 父进程号： 每个进程都有一个PID， 唯一标识 某个进程，除了少数(init PID 为1) 之外，多数程序与运行该程序的进程PID没有固定关系。 linux内核限制 进程号小于 32767,当进程号达到这个限制时候，内核将重置进程号计数器，重新从最小的整数开始分配。（进程号计数器会重置为 300， 因为 低于此数值的进程号 为系统进程和守护进程 长期占用， 关于最大进程号 默认上限是 32767,, 但是可以通过更改 /proc/sys/kernel/pid_max 来进行更改=最大值+1， 64位最大进程号为2 22次方 为什么？）getppid可以获取进程的父PID， 可以通过pstree， 来查看家族树。
2. 命令行参数 argc, argv：argc 表示命令行参数的个数，argv 是一个指向 命令行参数的指针数组，每一个参数指向一个以null结尾的字符串。其中argv[0] 包含了 调用程序的名称。可以为一个程序创建多个连接，然后argv[0]的名字是不同的。
3. 环境列表： 每个进程都有与之相关的字符串数组成为环境列表(envoriment list), 每个字符串都以 name=value 的形式定义。常常将name称为环境变量。新创建进程会继承父进程的环境副本，因为获得是副本，随意之后父子环境信息个不相关。
   * export NAME=value: 将NAME变量添加到shell环境中, 此后这个shell所创建的进程中都存在变量NAME
   * NAME=value programe: 在应用程序 programe的环境变量中添加一个变量值，但是不影响shell
   * printenv： 显示当前的环境列表
   * /proc/PID/environ: 文件显示编号为PID的进程的环境列表
   * getenv(char *name): 获取环境变量的数值(value), 不存在返回NULL
   * putenv(char *string): 添加一个 name=value 形式字符串的环境变量，失败返回非0值。一位内putenv 添加到environ变量的是一个指针，而不是string 的副本，所以不应该在栈上分配
   * setenv(char * name, char *value, overwrite): 该函数会复制 name, value。函数会自动拼接=号，overwrite ！= 0 总会写入， overwrite = 0时，存在则不写入，不存在写入
   * unsetenv
   * clearenv
