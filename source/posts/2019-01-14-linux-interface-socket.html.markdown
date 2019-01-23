---
title: linux-interface-socket
date: 2019-01-14
tags: linux, books
---
The linux programming interface
----------

### Socket
**socket是一种IPC方法， 它允许位于同意主机或者网络连接的不同主机 上的应用程序之间交换数据(第一个被广泛接受的socket API 实现于 1983年，现在这组API 已经被移植到了大部分的计算机系统上)**
1. 57 介绍UNIX domain socket， 允许同一主机上的系统上的应用程序之间通讯。 58 介绍TCP/IP之间联网协议的关键特性。， 59 描述internet domain socket, 允许位于不同主机上的应用程序通过一个TCP/IP王璐进行通讯， 60 讨论socket的服务设计， 61： 介绍一些高级主题， 包括socket IO的， TCP协议的细节信息，已经socket选项来获取修改socket的各种特性。
2. socket(domain, type, protocol): 系统调用
    * domain: 1） 识别 socket 地址的格式， 2） 确定范围， 实在同一个主机上的不同应用程序还是， 在一个网络上的不同主机

      | DOMAIN | 执行的通讯 | 应用程序间的通讯 | 地址格式 | 地址结构
      | :------------- | :------------- | :------ | :------ | :-------- |
      | AF_UNIX | 内核中| 同一主机 | 路径名 | sockaddr_un |
      | AF_INET | 通过IPv4 | IPv4 连接起来的网络 | 32为IPoe 地址+ 16位端口号 | sockaddr_in |
      | AF_INET6 | 通过IPv6 | IPv6 连接起来的网络 | 128为IP地址+ 16位端口号 | sockaddr_in6 |

    * type: sock_stream, sock_dgram

        | 属性 | 流(SOCK_STREAM) | 数据包 (SOCK_DGRAM)|
        | :------------- | :------------- | :----- |
        | 可靠的传输? | 是 | 否 |
        | 边界消息保留? | 否 | 是|
        | 面向连接？| 是 | 否 |

    * 流: 提供了一个可靠的双向的字节流的通讯通道。 (因为需要一对 相互连接的socket，因为被称为面向连接的socket）其中：
        1. 可靠的： 表示可以保证发送者传输的数据会完整的传递到接受者应用程序 （假设接受者发送者应用程序不会崩溃）
        2. 双向的： 数据可以在socket 之间的任意方向上传输
        3. 字节流： 表示与管道一样不存在 消息边界的概念
    * 数据报 socket： 允许数据以 数据报的消息形式进行交换， 在数据报socket中， 消息边界得到了保留，但是数据传输是不可靠的，消息的到达顺序 可能是无需的、重复的、或者根本无法到达的。数据包socket是一个更一般的无连接socket概念的一个示例， 与流socket连接，一个数据报 socket 在使用时候，无需与另一个socket 连接，现在internet domain 中， 数据包socket使用了UDP（用户数据报协议）, 而流socket 则使用了TCP（传输控制协议）（是否意味着更多的协议的存在？）
3. socket 相关的系统调用：  
    * socket(int domain, int type, int protocol): 其中domain， type 在上面有所描述。protocol 总是为0， 在一些socket类型中会使用非0数值，socket成功后会返回一个socket的文件描述符
    * bind(int sockfd, struct sockaddr * addr, socklen_t addrlen): sockfd 为 socket调用返回的文件描述符，addr 为socket绑定到的地址结构指针，结构详细取决于 socket domain, addrlen 为结构地址大小。一般来讲服务器会将socket 绑定到一个 约定的地址上。
    * listen(int sockfd, int backlog): 系统调用将会sockfd设定为 『被动』， 接受主动连接的请求。 backlog 用于 设定 服务器端 保持等待连接的数量。（在backlog之内的连接会立即成功，等待accept， 更多的连接会阻塞一直到有等待中的连接被accept并冲等待连接中删除掉）（backlog的限制在sys/socket.h 中的 somaxconn 常量设定， linux中 这个常量设定为128,从内核 2.4.25起 linux允许在运行时通过 特有的/proc/sys/net/core/somaxconn 文件来调整这个限制）
    * accept(int sockfd, struct sockaddr * addr, socklen_t * addrlen): 系统调用在 sockfd 的文件描述符 引用的监听流socket上接受一个接入连接。如果在调用accpet时不存在 未决 的连接，那么调用就会阻塞直到 有连接请求为止。参数 addr, addrlen, 会返回连接socket 的地址信息。理解accept 的关键点在于
        * accept 会创建一个新的scoket， 这个socket与执行connect的客户端scoket进行连接。
        * accpet调用返回的结果是 已连接的 socket文件描述符，监听 socketfd 会保持打开状态。并可以接受后续连接。
        * 典型的 服务器应用 会创建一个 监听socketfd， 将其绑定到一个约定的地址上。然后 accept 该socketfd 上 的连接 来处理所有的客户端请求。
    * connect(int sockfd, struct sockaddr * addr, scoklen_t addrlen): 系统调用将sockfd 主动连接到 地址addr 指定的监听socket上。如果连接失败，标准的可以移植的方法为，关闭socket，创建一个新的socket，并重新连接
      ![udp](../images/pending_socket.png)

4. 流 socket 提供了一个在两个端点之间 一个双向通信的通道，流socket IO 上的操作与 管道 IO的操作类似
    * 可以使用 read， write，因为socket是双向的，所以两端都可以使用
    * socket可以使用close来关闭，之后对应的另一端的socket 在读取数据时候会收到文件结束的标志，如果进行写入 会收到一个SIGPIPE的信号，并且系统调用会返回一个EPIPE的错误。

5. 数据包 socket(SOCK_DGRAM):
    1. socket 系统调用创建一个邮箱，
    2. bind 到一个约定的地址上， 来允许 一个应用程序发送数据报 到这里，一般来讲， 一个服务器会将其socket 绑定到一个地址上，客户端会向改地址发送一个数据报 来发起通讯 （在一个domain 特别是UNIX domain 中，客服端想接收到服务器发送来的数据报的话，也需要bind到一个地址上）
    3. sendto(int sockfd, vodi * buffer, size_t length, int flags, sockaddr * dest_addr, socklen_t addrlen): 用来发送一个数据报, flags 用来控制一些socket的特性，dest_addr置顶了目标接受者的socket地址,
    4. recvfrom(int sockfd, void * buffer, size_t length, int flags, sockaddr * src_addr, socklen_t addrlen): 用来接受数据报，在没有数据报时候会阻塞应用。犹豫recvfrom允许获取发送者的地址，因为可以发送一个响应（这在 发送者的socket没有绑定到一个地址上是有用的，正如bind中的描述所说，unix domain中也需要 客服端 来bind一个地址，才能接收到服务器的响应）其中 src_addr 用来获取发送数据报的远程socket地址，如果并不关心发送者的地址，可以传递NULL，length 数值 用来限制recvfrom获取的数据大小，如果超过length，则会进行截断。（如果使用了recvmsg 则可以找出被截断的数据报）
    5. 数据报通讯无法保证 数据报 接受的顺序，甚至无法保证数据是到达的 或者是 多次到达
    6. connect： 尽管数据报socket是无连接的，但是依然可以使用connect调用，
      * 发送者 socket connect之后，数据报的发送可以使用write，来完成，而无需使用sendto，并每次传递addr地址。
      * 接受者 socket connect之后，只能接受由对等的socket 发送的数据报
      * 数据报socket connect的明显优势在于 可以使用更简单的IO 系统调用，在一些TCP/IP实践中，将一个数据报的socket连接到一个对等socket（connect）能够带来性能上的提升
      ![udp](../images/udp_socket.png)

### Socket: Unix domain

1. Unix domain socket address:
  unix domain socket的地址以路径名来表示，其中sun_path 的大小，早期为 108, 104，现在的一般为 92，可移植的需要小一些，应该使用strncpy 以避免缓冲区溢出问题，使用 路径名 初始化 sun_path 来初始化 socket address

  ```c
    struct sockaddr_un {
      sa_family_t sun_family
      char sun_path[108];
    }

  ```
  * 当绑定 UNIX domain socket 时， bind会在 文件系统中创建一个条目， 文件的所有权会根据文件的创建规则来确定，并标记为一个socket， ls -l 第一列 为s， stat()返回的结构中st_mode字段中的文件类型部分为 S_IFSOCK，
  * 无法姜i一个socket绑定到 现有的路径名上。
  * 通常将一个socket绑定到绝对路径上
  * 一个socket只能绑定到一个路径名上，相应的一个路径名只能被一个socket绑定
  * 无法使用open打开一个socket
  * 不在需要socket时，使用unlink 来删除其路径
  * 示例中通常将socket绑定到/tmp目录下，这并不是一个好的设计，在现实中不要这么做，因为/tmp 此类公共可写的目录中创建文件会导致安全问题，所以应该将socket绑定到一个有安全措施的绝对路径上

2. socketpair(int domain, int type, int protocol, int sockfd[2]): 该系统调用 用于创建一对 互相连接的socket，
    * 只能用在UNIX domain中(也就是说 domain 必须指定为 AF_UNIX) type 可以为sock_dgram, sock_stream, protocol必须为0，
    * sockfd 数组返回了 引用这两个相互连接的socket文件描述符。type 为sock_stream 相当于创建了一个双向管道，一般来讲 socket对的使用方式与管道的使用方式类似，在调用完socketpair()之后，可以fork出一个子进程，然后子父进程可以通过这一对socket来进行IPC了。
    * 与 手动闯将一对相互连接的socket的做法的优势： socketpair 创建的socket不会绑定到任意的地址上（即其他的创建放大都需要bind 到一个地址上）这样就能避免安全问题，因为这一对socket对其他进程是不可见的
3. linux 抽象socket 命名空间
  **所谓的抽象命名空间 是linux特有的特性。他允许将一个UNIX domain socket绑定到一个名字上但不会在文件系统上创建该名字** 优势有：
  * 无需担心与文件系统中的既有名字冲突
  * 没有必要在使用完一个socket之后，删除socket路径名，当socket被关闭之后会自动删除这个抽象名
  * 无需为socket创建一个文件系统路径名了
  * 创建一个抽象的绑定，只需要将sun_path字段的第一个字节指定为null，用于区分抽象socket 与传统的UNIX domain socket
