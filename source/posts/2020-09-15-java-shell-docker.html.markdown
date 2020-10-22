---
title: java shell docker
date: 2020-09-15
tags: week
---

## A Little Book on Java 的总结
#### Basic
1. 编译 与 运行
编译: javac First.java 产生一个 First.class 文件
运行：java First 将运行 编译之后 First.class
* java  编译器 将 源代码 中的每个 class 转变为 对应的 class file 并存储 其 字节码
* 有 main 函数的 class才能够运行，一个项目中存在多个class 有 main 函数 是为了 将 项目分为不同的 可以运行的单元 方便测试
2. 基本类型
* Number, float, double, int
* Character: char a = ’a’; 
* Boolean: boolean true and false
* Strings: String title = "A Little Book on Java";
* Array: datatype[] ArrayName = new datatype[ArraySize]; 当 使用 index 超过 数组边界 时 会发生 ArrayIndexOutOfBoundsException 错误
3. 流程控制语句
* while loop
```java
while <boolean-expression>
  statement
```

* for loop
```java

for (initial-expression, boolean-expression, increment-expression) st  atement
```
* if
```java

if (boolean-expression)
  statement
else if (boolean-expression) 
  statement
else
  statement
```
* break;
4.  抽象机制
5. Procedures
* its name,
* what kinds of parameters it expects (if any),
* what kind of result it might return. 
6. class
* Syntax of Class Declarations
```java
class Hello{
}
```
* main method; java foo a b c, params as args array
```java
class Foo {
  public static void main(String args[]){
      /* Body of main */
  }
}
```
* static variable & function and usage
```java
class Foo {
  static int name;
  public static void showFoo(){
  }
}

classname.methodname(parameters); // static method usage
classname.variablename;           // static variable usage
```
* Visibility Issues （可见控制）: Public data and code is visible to all classes, while private data and code is visible only inside the class that contains it.

7. The Object Concept
* The State of an Object (Instance variables)
```java
class PointIn3D{
  //Instance Variables
  private double x;
  private double y;
  private double z;
}
```
* Constructors
```java
class PointIn3D{
  private double x;
  private double y;
  private double z;

   //Constructors
  //This constructor does not take parameters
  public PointIn3D(){
    /* Initializing the fields of this object to the origin,
       a default point */
    x = 0;
    y = 0;
    z = 0;
  }

  //This constructor takes parameters
  public PointIn3D(double X, double Y, double Z){
    /* Initializing fields of this object to values specified by
       the parameters */
    x = X;
    y = Y;
    z = Z;
  }
}
```
* Creating an Object
```java
//Creates a PointIn3D object with coordinates (0, 0, 0)
new PointIn3D();
//Creates a PointIn3D object with coordinates (10.2, 78, 1) new PointIn3D(10.2, 78, 1);
```
* Object References
```java
ReferenceType ReferenceName;

PointIn3D p = new PointIn3D(1, 1, 1);
```
* Accessing the Fields of an Object
```java
 ReferenceName.FieldName;
```
*  The Behavior of an Object
```java
  ObjectReference.InstanceMethodName(Parameter-List)
```

* The this reference: Inside an instance method, this is a reference to the object on which the instance method is invoked. Inside a constructor, this refers to the object that the constructor just created.

```java

public PointIn3D(){
  this.x = 0;
  this.y = 0;
  this.z = 0;
}
public double getX(){
  return this.x;
}

```

* Inheritance: extends, super can use in subtype to call supertype methods

8. Rules for Method Lookup and Type Checking.
* First the rules. Remember that there are two phases: compile time, which is when type checking is done and run time, which is when method lookup happens. Compile time is before run time.
* The type checker has to say that a method call is OK at compile time.
* All type checking is done based on what the declared type of a reference to an object is.
* Subtyping is an integral part of type checking. This means if B is a subtype of A and there is a context that gets a B where A was expected there will not be a type error.
* Method lookup is based on actual type of the object and not the declared type of the reference.
* When there is overloading (as opposed to overriding) this is resolved by type-checking.

```java
class myInt {
    private int n;
    public myInt(int n){
        this.n = n;
    }
    public int getval(){
        return n;
    }
    public void increment(int n){
        this.n += n;
    }
    public myInt add(myInt N){
        return new myInt(this.n + N.getval());
    }
    public void show(){
        System.out.println(n);
    }
}

class gaussInt extends myInt {
    private int m;  //represents the imaginary part
    public gaussInt(int x, int y){
        super(x);
        this.m = y;
    }
    public void show(){
        System.out.println("realpart is: " + this.getval() +" imagpart is: " + m);
    }
    public int realpart() {
        return getval()
            ;}
    public int imagpart() {
        return m;
    }
    public gaussInt add(gaussInt z){
        return new gaussInt(z.realpart() + realpart(),
                            z.imagpart() + imagpart());
    }
    public static void main(String[] args){
        gaussInt kreimhilde = new gaussInt(3,4);
        kreimhilde.show();
        kreimhilde.increment(2);
        kreimhilde.show();
        System.out.println("Now we watch the subtleties of overloading.");
        myInt a = new myInt(3);
        gaussInt z = new gaussInt(3,4);
        gaussInt w;
        myInt b = z;
        myInt d = b.add(b); //this does type System.out.print("the value of d is:

        // error is this
        // w = z.add(b);// will not type check
        // w = b.add(z); will not type check
        w = ( (gaussInt) b).add(z);//this does type check System.out.print("the value of w is: ");
        w.show();
        myInt c = z.add(a); //will this typecheck? System.out.print("the value of c is: ");
        c.show();
    }
}

```
9. The Exception Object
*  分为两类： unchecked exceptions and checked exceptions.
*  所有的exception 都发生在 runtime， 因为不是的话，要啥编译检查？
*  Unchecked exceptions 与  checked exception 的区别主要在于： Unchecked exceptions happen because of the programmer’s carelessness，也就是说  unchecked exception 是可以预防的，可以避免的。两个主要的 unchecked exception 主要有： rrayIndexOutofBoundsException and NullPointerException
*  所有其他的非 unchecked exception 再是：checked exceptions， 连个主要的exception 有 FileNotFoundException and IOException.
10. 创建 新的 exception
* 新创建的 exception 应该继承 exception 或者 任何 除 RunTimeException 之外的 子类。 因为 新创建的 exception  为 checked exception 
* An exception is thrown to indicate the occurrence of a runtime error. Only checked exceptions should be thrown, as all unchecked exceptions should be eliminated. 意思是： 只有 checked exceptions 需要throw 声明， unchecked exception 因为无法预测，只能 尽量消除掉。（If a method’s header does not contain a throws clause, then the method throws no checked exceptions.）
11. Throwing an Exception
```java
public static void main(String[] args) throws IOException,
                                              FileNotFoundException
```
* A method’s header advertises the checked exceptions that may occur when the method executes
* An exception can occur in two ways: explicitly through the use of a throw statement or implicitly by calling a method that can throw an exception 意思是：异常产生有两种方式：1. 直接抛出异常 2. 调用 能够抛出异常的函数
12. Catching an Exception: catch 异常的方式同其他 语言一致， 即是 不断的递归的 解开栈，以找到合适的 catch。如果无法找到适合的 catch 则  使用默认的 default exception handler 来捕获异常，所以default exception handler 是在哪一层？main 层面吗？
```java
try{
   code that could cause exceptions
}
catch (Exception e1){
   code that does something about exception e1
}
catch (Exception e2){
   code that does something about exception e2
}
```

## A Little Book on Shell 
#### 差用 command
1. file cp mv mkdir rm ln 
其中ln  命令 ln file link, 默认 创建 hard link， ln -s file link 才 为 soft link， soft link 同样增加 file 的link count
2. Working with Commands (type which  help man apropos info whatis alias)
| command | meaning                                           |
|---------|---------------------------------------------------|
| type    | Indicate how a command name is interpreted        |
| which   | Display which executable program will be executed |
| help    | Get help for shell builtins                       |
| man     | Display a command's manual page                   |
| apropos | Display a list of appropriate commands            |
| info    | Display a command's info entry                    |
| whatis  | Display one-line manual page descriptions         |
| alias   | Create an alias for a command                     |

1. commands 的来源： 
* An executable program: 例如 /usr/bin 下面的 可执行文件，
* A command built into the shell itself.： bash 支持的内建 的 命令
* A shell function： shell 函数 Shell functions are miniature shell scripts incorporated into the environment
* An alias： Aliases are commands that we can define ourselves, built from other commands.

2.  man 详细内容： Display a Program's Manual Page。 手册内容 被分为 几个 章节， 出了 使用 man command, 之外 可以使用 man 1 command 来显示 User commands 章节
| section | contents                                       |
|---------|------------------------------------------------|
| 1       | User commands                                  |
| 2       | Programming interfaces for kernel system calls |
| 3       | Programming interfaces to the C library        |
| 4       | Special files such as device nodes and drivers |
| 5       | File formats                                   |
| 6       | Games and amusements such as screen savers     |
| 7       | Miscellaneous                                  |
| 8       | System administration commands                                               |

3. apropos – Display Appropriate Commands 展示相关的 命令。通过  apropos ls 可以获得 lscpu, lshw, 等一系列 命令
4. whatis – Display One-line Manual Page Descriptions:  展示一行关于 command的简单描述
5. info 另一种展现形式的 man
5. alias: alias name='string' 来构建 名为 name 的command line， type name 可以获得 name 对应的 具体string 内容

#### Redirection
1. cat sort uniq grep wc head tail tee(Read from standard input and write to standard output and files)
2. command line  数据流 有： 标准输入 标准输出 标准错误输出，即： stdin, stdout, stderr, 0, 1, 2
3. 重定向 stdout， 使用 > 来将 输出 重定向到 file 中，file中内容将被覆盖。  >>  将 数据重定向 到file中，不覆盖 追加到 file 末尾中
4. 重定向 stderr, 类似 重定向 stdout 使用 2>, 2>> 进行 标准错误输出 的数据重定向
5. 将stdout & stderr 重定向 到一个 file 中：
* ls -l /bin/usr > ls-output.txt 2>&1 ， 注意 其中的 2>&1 的写法，以及， > 与 2>&1 的顺序， 其中原因，为shell 语法需要 控制 两次重定向 打开的是同一个文件
* ls -l /bin/usr &> ls-output.txt 也可以这样 &> 代表 stdout stderr， ls -l /bin/usr &>> ls-output.txt 则代表 将stdout stderr 数据流 追加到 文件中
6. Disposing of Unwanted Output:  ls -l /bin/usr 2> /dev/null 将 数据流 重定向 到 /dev/null 则可以起到忽略 数据流的作用
7. 重定向 stdin, 使用 < 来重定向 stdin 从 键盘 到 file 上， 但是并不是特别有用（很少用到）
8. Pipelines： 使用 pipe operator | 将 一个command 的标准输出  输送 到 一个command 的标准输入中。 command1 | command2
9. Pipelines 与 重定向的 区别： 重定向只能 定向到 file， 而 pipelines 则可以 重定向到  一个command

#### Seeing the World as the Shell Sees It
1. 扩展 Expansion: how a simple character sequence, for example *, can have a lot of meaning to the shell. The process that makes this happen is called expansion. With expansion, we enter some- thing and it is expanded into something else before the shell acts upon it. 也就是 说 在 传递 参数给 command， command 接收参数处理前，会被 进行处理，该处理过程 即是： expansion。
2. echo 是如何 显式化  看到 expansion 结果的 重要方式
3. Pathname Expansion （路径扩展）： 如下释义：
```shell
[me@linuxbox ~]$ ls
Desktop ls-output.txt Pictures Templates Documents Music Public Videos

[me@linuxbox ~]$ echo D*
Desktop Documents

[me@linuxbox ~]$ echo *s
Documents Pictures Templates Videos

[me@linuxbox ~]$ echo [[:upper:]]*
Desktop Documents Music Pictures Public Templates Videos

[me@linuxbox ~]$ echo /usr/*/share
/usr/kerberos/share /usr/local/share

```
4. Arithmetic Expansion: $((expression)), expression 是 算术表达式， 操作数 只能是整数， 操作符 有 +, -, *, /, %, **
```shell
[me@linuxbox ~]$ echo $(($((5**2)) * 3))
```

5. Brace Expansion: 
```shell
[me@linuxbox ~]$ echo Front-{A,B,C}-Back
Front-A-Back Front-B-Back Front-C-Back

[me@linuxbox ~]$ echo Number_{1..5}
Number_1 Number_2 Number_3 Number_4 Number_5

[me@linuxbox ~]$ echo {01..15}
01 02 03 04 05 06 07 08 09 10 11 12 13 14 15

[me@linuxbox ~]$ echo {001..15}
001 002 003 004 005 006 007 008 009 010 011 012 013 014 015

[me@linuxbox ~]$ echo {Z..A}
Z Y X W V U T S R Q P ON M L K J I H G F E D C B A


[me@linuxbox ~]$ mkdir Photos
[me@linuxbox ~]$ cd Photos
[me@linuxbox Photos]$ mkdir {2007..2009}-{01..12} 
[me@linuxbox Photos]$ ls
2007-01 2007-07 2008-01 2008-07 2009-01 2009-07 2007-02 2007-08 2008-02 2008-08 2009-02 2009-08 2007-03 2007-09 2008-03 2008-09 2009-03 2009-09 2007-04 2007-10 2008-04 2008-10 2009-04 2009-10 2007-05 2007-11 2008-05 2008-11 2009-05 2009-11 2007-06 2007-12 2008-06 2008-12 2009-06 2009-12
```
6. Parameter Expansion

```shell
[me@linuxbox ~]$ echo $USER 
me
```
7. Command Substitution: 子命令， 允许在表达式中 执行子命令 并展开. $(command sub)
```shell
[me@linuxbox ~]$ echo $(ls)
Desktop Documents ls-output.txt Music Pictures Public Templates Videos
```

8. Quoting: 可以用来控制 是否进行 扩展 展开。
* 下面两个示例：

```shell
[me@linuxbox ~]$ echo this is a    test
this is a test

[me@linuxbox ~]$ echo The total is $100.00
The total is 00.00
```
注意 这两个 的存在的问题： 1. 第一个中 shell 将 params 中多余的空格 去掉了， 即是： 'a    test'中多余的空格， 因为 shell 将 通过 空格 分隔 参数，认为 a test  为两个参数。 2. $100.00 展开为了 00.00 是因为 $1 不存在的缘故

* Double Quotes： 将参数 加上 "" 之后， ""内的内容 将被视为 一个 参数， 但  parameter expansion, arithmetic expansion, and command substitution 依然 有效。
如下示例:
```shell
[me@linuxbox ~]$ ls -l two words.txt
ls: cannot access two: No such file or directory
ls: cannot access words.txt: No such file or directory

[me@linuxbox ~]$ ls -l "two words.txt"
-rw-rw-r-- 1 me me 18 2016-02-20 13:03 two words.txt [me@linuxbox ~]$ mv "two words.txt" two_words.txt
```

```shell
[me@linuxbox ~]$ echo this is a    test
this is a test

[me@linuxbox ~]$ echo "this is a   test"
this is a   test




(calvagrant@precise64:~$ echo $(cal)
September 2020 Su Mo Tu We Th Fr Sa 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30

vagrant@precise64:~$ echo "$(cal)"
   September 2020
Su Mo Tu We Th Fr Sa
       1  2  3  4  5
 6  7  8  9 10 11 12
13 14 15 16 17 18 19
20 21 22 23 24 25 26
27 28 29 30

```
* Single Quotes： 单引号 中的内容 扩展 全部 失效。
* Escaping Characters： \

| escape sequence | meaning         |
|-----------------|-----------------|
| \a              | Bell            |
| \b              | Backspace       |
| \n              | Newline         |
| \r              | Carriage return |
| \t              | Tab             |

9. Signals: Signals are one of several ways that the operating system communicates with programs
* kill: The kill command doesn't exactly “kill” processes: rather it sends them signals 
 kill [-signal] PID...


| keyboard | signal |
|----------|--------|
| Ctrl-c   | INT    |
| Ctrl-z   | TSTP   |


| Number | Name  | Meaning                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|--------|-------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1      | HUP   | Hangup. This is a vestige of the good old days when terminals were attached to remote computers with phone lines and modems. The signal is used to indicate to programs that the controlling terminal has “hung up.” The effect of this signal can be demonstrated by closing a terminal session. The foreground program running on the terminal will be sent the signal and will terminate.                                                                                                           |
| 2      | INT   | Interrupt. This performs the same function as a Ctrl-c sent from the terminal. It will usually terminate a program.                                                                                                                                                                                                                                                                                                                                                                                    |
| 9      | KILL  | Kill. This signal is special. Whereas programs may choose to handle signals sent to them in different ways, including ignoring them all together, the KILL signal is never actually sent to the target program. Rather, the kernel immediately terminates the process. When a process is terminated in this manner, it is given no opportunity to “clean up” after itself or save its work. For this reason, the KILL signal should be used only as a last resort when other termination signals fail. |
| 15     | TERM  | Terminate. This is the default signal sent by the kill command. If a program is still “alive” enough to receive signals, it will terminate.                                                                                                                                                                                                                                                                                                                                                            |
| 18     | CONT  | Continue. This will restore a process after a STOP or TSTP signal. This signal is sent by the bg and fg commands.                                                                                                                                                                                                                                                                                                                                                                                      |
| 19     | STOP  | Stop. This signal causes a process to pause without terminating. Like the KILL signal, it is not sent to the target process, and thus it cannot be ignored.                                                                                                                                                                                                                                                                                                                                            |
| 20     | TSTP  | Terminal stop. This is the signal sent by the terminal when Ctrl-z is pressed. Unlike the STOP signal, the TSTP signal is received by the program, but the program may choose to ignore it.                                                                                                                                                                                                                                                                                                            |
| 3      | QUIT  | Quit                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| 11     | SEGV  | Segmentation violation. This signal is sent if a program makes illegal use of memory, that is, if it tried to write somewhere it was not allowed to write.                                                                                                                                                                                                                                                                                                                                             |
| 28     | WINCH | Window change. This is the signal sent by the system when a window changes size. Some programs , such as top and less will respond to this signal by redrawing themselves to fit the new window dimensions.                                                                                                                                                                                                                                                                                            |
* example, kill -number | -Name 也即是说 kill 可以接受 number 或者 显示的名称
```shell
[me@linuxbox ~]$ kill -1 13546
[me@linuxbox ~]$ kill -SIGINT 13608
```

#### Configuration and the Environment
1. Environment: shell 维护 一个 shell的 session 信息 称为 环境； shell 中保存 environment variables and shell variables 在环境中。但是无法区分 两种类型的变量。
* printenv： 用来展现所有的 变量
* set： 不带参数 展现所有变量以及 shell函数
* alias： 展现所有 alias 相关的
2. Environment 中的变量是 如何定义的：
* A login shell session： A login shell session is one in which we are prompted for our username and password. This happens when we start a virtual console session, for example.
* A non-login shell session： A non-login shell session typically occurs when we launch a terminal session in the GUI.
* Login Shell Sessions 读取配置文件
| File            | Contents                                                                                                                                                   |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| /etc/profile    | A global configuration script that applies to all users.                                                                                                   |
| ~/.bash_profile | A user's personal startup file. This can be used to extend or override settings in the global configuration script.                                        |
| ~/.bash_login   | If ~/.bash_profile is not found, bash attempts to read this script.                                                                                        |
| ~/.profile      | If neither ~/.bash_profile nor ~/.bash_login is found, bash attempts to read this file. This is the default in Debian-based distributions, such as Ubuntu. |
|                 |                                                                                                                                                            |

* Non-Login Shell Sessions 读取配置文件： non-login shells inherit the environ- ment from their parent process, usually a login shell. Non-login 会 继承  Login shell 的环境
| File             | Contents                                                                                                           |
|------------------|--------------------------------------------------------------------------------------------------------------------|
| /etc/bash.bashrc | A global configuration script that applies to all users                                                            |
| ~/.bashrc        | A user's personal startup file. It can be used to extend or  override settings in the global configuration script. |
|                  |                                                                                                                    |

3. 命令查找： ls 命令的 定义在哪里， 又是如何找到的呢？
* shell 从 PATH 变量中 包含的 Path 中 顺序查找
```shell
PATH=$PATH:$HOME/bin
export PATH
```
简单的将 $HOME/bin 添加到 PATH 中 (注意 $HOME 会在此处求值)
xport PATH 让 shell之后的process 中的PATH都改变

#### 查找文件
1. locate : 非常简单有效，只能使用 filename 用来查找。 locate 足够高效 因为 其从 updatedb command 更新的数据库中来进行查找，updatedb 经常 放在cron job 来执行（需要确认下，因为没有找到 相关的配置文件）
2. find 寻找文件 则显得 复杂 而详尽。可以根据给定的 目录 以及 各个限定 来查找文件。
可选参数与 含义
| 参数           | 可选值                                                                                                                                                                                                                                                                                                        |
|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| -type          | b: Block special device file; c: Character special device file; d: Directory; f: regular file; l Symbolic link                                                                                                                                                                                                |
| -size          | c Bytes; w: 2-byte words; k: kilobytes; M: megabytes; G: Gigabytes;                                                                                                                                                                                                                                           |
| -cmin n        | Match files or directories whose content or attributes were last modified exactly n minutes ago. To specify less than n minutes ago, use -n, and to specify more than n minutes ago, use +n.                                                                                                                  |
| -cnewer file   | Match files or directories whose contents or attributes were last modified more recently than those of file.                                                                                                                                                                                                  |
| -ctime n       | Match files or directories whose contents or attributes were last modified n*24 hours ago.                                                                                                                                                                                                                    |
| -empty         | Match empty files and directories.                                                                                                                                                                                                                                                                            |
| -iname pattern | Like the -name test but case-insensitive.                                                                                                                                                                                                                                                                     |
| -inum n        | Match files with inode number n. This is helpful for finding all the hard links to a particular inode.                                                                                                                                                                                                        |
| -mmin n        | Match files or directories whose contents were last modified n minutes ago.                                                                                                                                                                                                                                   |
| -mtime n       | Match files or directories whose contents were last modified n*24 hours ago.                                                                                                                                                                                                                                  |
| -name pattern  | Match files and directories with the specified wildcard pattern.                                                                                                                                                                                                                                              |
| -newer file    | Match files and directories whose contents were modified more recently than the specified file. This is useful when writing shell scripts that perform file backups. Each time you make a backup, update a file (such as a log) and then use find to determine which files have changed since the last update |
| -samefile name | Similar to the -inum test. Match files that share the same inode number as file name                                                                                                                                                                                                                          |
| -user name     | Match files or directories belonging to user name. The user may be expressed by a username or by a numeric user ID.                                                                                                                                                                                           |

* for example
```shell
[me@linuxbox ~]$ find ~ -type f -name "*.JPG" -size +1M | wc -l
```
注意 其中的 -name 参数需要添加 "" 来防止 pathname expansion， size: 则使用 +1M 表示大于 1M 的文件

* find logical Operators： find 则可以更复杂的 使用 -and -or -not () 等来进行  logic 之间的 与或 操作 来设定更复杂的 test 关系
```shell
( expression 1 ) -or ( expression 2 )
```
* Predefined Actions: 
| Action  | Meaning                            |
|---------|------------------------------------|
| -delete | delete match file                  |
| -ls     | ls -dils match file                |
| -print  | output full pathname of match file |
| -quit   | Quit once a match has been made    |

* User-Defined Actions： -exec rm '{}' ';'： {} 代表 match file 的pathname。 这里面 存在的问题是： -exec 中的命令会被  实例化 多次，在每次match file的时候 就会实例化一次。可以简单的 实例化多次 修改为 实例化一次 。 即：
```shell
find ~ -type f -name 'foo*' -exec ls -l '{}' ';'
-rwxr-xr-x 1 me me 224 2007-10-29 18:44 /home/me/bin/foo 
-rw-r--r-- 1 me me 0 2016-09-19 12:53 /home/me/foo.txt

// 修改后
find ~ -type f -name 'foo*' -exec ls -l '{}' +
-rwxr-xr-x 1 me me 224 2007-10-29 18:44 /home/me/bin/foo 
-rw-r--r-- 1 me me 0 2016-09-19 12:53 /home/me/foo.txt
```
* xargs: 用于将 接受的input 的信息 作为参数 传递给 command. xargs存在的原因在于： 一些 命令 接受 命令行参数+标准输入，但是其他一些命令 则 只接受命令行 输入，所以需要 xargs 将标准输入 转换为 命令行参数
Some commands such as grep and awk can take input either as command-line arguments or from the standard input. However, others such as cp and echo can only take input as arguments, which is why xargs is necessary. [[name]](https://en.wikipedia.org/wiki/Xargs)
xargs 中存在一些 问题，主要是 关于 filename 中的空格，等分隔符号 对整个 shell的参数接收 都有影响。 所以 接受filename 的时候 --null 参数 将 是xargs 不被 ‘ ’分隔（ 使用 空字符串 作为分隔）， -d ' 

#### Archiving and Backup：
1. compressor command: gzip bzip2
gzip options
```shell

```
| Option  | Long Option  | Desc                                                                                                                                                                                                                                  |
|---------|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| -c      | --stdout     | Write output to standard output and keep the original files.                                                                                                                                                                          |
| -d      | --decompress | Decompress This causes gzip act like gunzip                                                                                                                                                                                           |
| -f      | --force      | force compress event if a compressed file already exists                                                                                                                                                                              |
| -l      | --list       | 应用 已压缩文件 展示 压缩信息                                                                                                                                                                                                         |
| -r      | --recursive  | 递归压缩目录下的文件（目录下的文件各自压缩为 各自的压缩文件，所以 依然需要archive 程序）                                                                                                                                                                         |
| -v      | --verbose    | Display verbose messages while compressing.                                                                                                                                                                                           |
| -number |              | Set amount of compression. number is an integer in the range of 1 (fastest, least compression) to 9 (slowest, most compression). The values 1 and 9 may also be expressed as --fast and --best, respectively. The default value is 6. |


bzip2 同gzip 一样 为压缩程序，其中的参数 都大概相同，除了-r -number 外。 bunzip2 bzcat 用于解压缩。 bzip2recover 可以恢复受损的 压缩文件
2. archive command: tar zip:  Archiving is the process of gathering up many files and bundling them together into a single large file.
| Mode | Meaning                                                    |
|------|------------------------------------------------------------|
| c    | Create an archive from a list of files and/or directories. |
| x    | Extract an archive.                                        |
| r    | Append specified pathnames to the end of an archive        |
| t    | List the content of an archive                             |


```shell
[me@linuxbox ~]$ gzip foo.txt
[me@linuxbox ~]$ ls -l foo.*
-rw-r--r-- 1 me me 3230 2018-10-14 07:15 foo.txt.gz

[me@linuxbox ~]$ gzip -d foo.txt.gz

[me@linuxbox ~]$ gunzip foo.txt
[me@linuxbox ~]$ ls -l foo.*
-rw-r--r-- 1 me me 15738 2018-10-14 07:15 foo.txt


[me@linuxbox ~]$ bzip2 foo.txt
[me@linuxbox ~]$ ls -l foo.txt.bz2
-rw-r--r-- 1 me me 2792 2018-10-17 13:51 foo.txt.bz2
[me@linuxbox ~]$ bunzip2 foo.txt.bz2
```

tar： 只能以 相对路径 archive 文件。unarchive 的时候 在 当前路径下 以相对路径 恢复文件。example

```shell
[me@linuxbox ~]$ tar cf playground2.tar ~/playground

[me@linuxbox ~]$ cd foo
[me@linuxbox foo]$ tar xf ../playground2.tar
[me@linuxbox foo]$ ls
home playground
```

--wildcards 可以用来过滤掉 特定的 match 文件

find 经常用来 与 tar 配合进行 批量 archive

```shell
find playground -name 'file-A' -exec tar rf playground.tar '{}' '+'

find playground -name 'file-A' | tar cf - --files-from=- | gzip > playground.tgz
```

第二条命令比较 特殊，在其中  tar cf - --files-from=- 中， - 代表 标准 标准输入或者输出 

tar 可以通过添加 z j 参数，直接 使用gzip bzip2 进行压缩, z: gzip .tgz, j: bzip2 .tbz
```shell
find playground -name 'file-A' | tar czf playground.tgz -T -
```

通过网络进行 文件备份：
```shell
ssh remote-sys 'tar cf - Documents' | tar xf -
```

zip, unzip： 的命令 比较详细，所以只列出简短  的示例：

```shell
zip -r playground.zip playground // -r 是必须，这样才能 得到 playground 下的所有 archive
unzip ../playground.zip // 不同与 tar, zip 使用unzip 来进行 unarchive
unzip -l ../playground.zip
```

3. sync command: rsync  rsync options source destination
where source and destination are one of the following:

* A local file or directory
* A remote file or directory in the form of [user@]host:path
* A remote rsync server specified with a URI of rsync://[user@]host[:port]/path

注意： source destination 其中之一 必须 为 本地的文件， 远程 到 远程的 copy 是不被允许的。
示例：
```shell
rsync -av source destination // -a 代表 archive mode， v verbose output
rsync -av source/ destination
// 两种方式不同的地方在于 后一种 只拷贝 source 中的内容到 destination, 而 第一种 则将source 目录也 拷贝到 destination 中.

rsync -av --delete source/ destination   // delete 参数 为 完全拷贝， source 中删除掉的file 将在 destination 中删除掉。
```

Using rsync Over a Network： 的两种方式
* source 安装了 rsync  的机器 以及 destination 安装了 远程shell 程序， 如： ssh
* destination 安装了 rsync server， rsync 可以配置为 daemon 模式 等待 sync 请求

```shell
sudo rsync -av --delete --rsh=ssh /etc /home /usr/local remote-sys:/backup
// 这里面 --rsh 指定为 ssh， 使 rsync 能够 使用ssh 来进行同步操作
rsync -av –delete rsync://archive.linux.duke.edu/ fedora/linux/development/rawhide/Everything/x86_64/os/ fedora-devel
```

### Text Processing
* cat： 可以这样使用
```shell
[me@linuxbox ~]$ cat > foo.txt // ctrl-d结束输入
[me@linuxbox ~]$ cat -A foo.txt // 其中 ^I 代表 tab, $ 代表 line末尾， 所以可以用此来 区分 tab 与 space
[me@linuxbox ~]$ cat -nA foo.txt // n 显式 line number
```

* [[https://www.gnu.org/software/coreutils/manual/html_node/sort-invocation.html#sort-invocation][sort]]:  对输入进行排序， 是一个比较复杂，有用的命令：下面是详细参数

| Option | Long Option             | meaning                                                                               |
|--------|-------------------------|---------------------------------------------------------------------------------------|
| -b     | --ignore-leading-blanks | 使忽略掉 行前的 空格，使用第一个非空格排序                                            |
| -f     | --ignore-case           |                                                                                       |
| -n     | --numeric-sort          | 将字符串当做number 来进行比较                                                         |
| -r     | --reverse               | reverse order 排序                                                                    |
| -k     | --key=field1[,field2]   | 使用 field1..field2 作为排序的key, field1 不存在则为1， field2 不存在则 从field1直至末尾， field1 都可以是如此形式 f[.c][opts]  .c 为内部的offset                                            |
| -m     | --merge                 | 将每个参数作为预排序文件的名称。 将多个文件合并为单个排序结果，而不执行任何其他排序。 |
| -o     | --output=file           | 输出到 file 而非 标准输出                                                             |
| -t     | --field-separator=char  | 使用 char 作为分隔符，默认为 space 或者tab                                            |
|      | --debug  | 将用作sort 的key 进行标记                                            |
下面是几个示例

```shell
[me@linuxbox ~]$ du -s /usr/share/* | head
252 /usr/share/aclocal
96 /usr/share/acpi-support
8 /usr/share/adduser
196 /usr/share/alacarte 344 /usr/share/alsa
8 /usr/share/alsa-base 12488 /usr/share/anthy
8 /usr/share/apmd


//  下面对结果进行排序 其中 -nr 将string作为number 处理并 翻转排序, 这里面之所有管用，是因为 第一列 为 数字, 即 默认按照第一列进行排序
[me@linuxbox ~]$ du -s /usr/share/* | sort -nr | head
509940 /usr/share/locale-langpack
242660 /usr/share/doc
197560 /usr/share/fonts
179144 /usr/share/gnome
146764 /usr/share/myspell
144304 /usr/share/gimp
135880 /usr/share/dict
76508 /usr/share/icons
68072 /usr/share/apps
62844 /usr/share/foomatic

// 如果是这样的又如何排序?
[shaohua.li@10-11-112-3 ~]$ ls -l /usr/bin/ | head
total 58404
-rwxr-xr-x  1 root root     33408 Nov 10  2015 [
-rwxr-xr-x  1 root root    106792 Nov 10  2015 a2p
-rwxr-xr-x. 1 root root     14984 Aug 18  2010 acpi_listen
-rwxr-xr-x. 1 root root     23488 Nov 11  2010 addftinfo
-rwxr-xr-x  1 root root     24904 Jul 23  2015 addr2line
-rwxr-xr-x. 1 root root      1786 Feb 21  2013 apropos
-rwxr-xr-x  1 root root     56624 Jul 23  2015 ar
-rwxr-xr-x  1 root root    328392 Jul 23  2015 as
-rwxr-xr-x. 1 root root     10400 Sep 23  2011 attr

// -k 5 使用 第 5 field 作为key 用作 排序使用
[shaohua.li@10-11-112-3 ~]$ ls -l /usr/bin/ | sort -nr -k 5 | head
-rwxr-xr-x  1 root root   3214440 Dec 12  2016 mysql
-rwxr-xr-x  1 root root   3051080 Dec 12  2016 mysqlbinlog
-rwxr-xr-x  1 root root   2998400 Dec 12  2016 mysqldump
-rwxr-xr-x  1 root root   2948832 Dec 12  2016 mysqlslap
-rwxr-xr-x  1 root root   2936680 Dec 12  2016 mysqladmin
-rwxr-xr-x  1 root root   2935688 Dec 12  2016 mysqlcheck
-rwxr-xr-x  1 root root   2933128 Dec 12  2016 mysqlimport
-rwxr-xr-x  1 root root   2931712 Dec 12  2016 mysqlshow
-rwxr-xr-x  1 root root   2814328 Dec 12  2016 my_print_defaults
-rwxr-xr-x  1 root root   2811544 Dec 12  2016 mysql_waitpid


// 下面是 比较复杂的示例
root@precise64:~/shell_test#  cat distros.txt
Fedora  5    03/20/2006
Fedora  6    10/24/2006
Fedora  7    05/31/2007
Fedora  8    11/08/2007
Fedora  9    05/13/2008
Fedora  10   11/25/2008
SUSE    10.1 05/11/2006
SUSE    10.2 12/07/2006
SUSE    10.3 10/04/2007
SUSE    11.0 06/19/2008
Ubuntu  6.06 06/01/2006
Ubuntu  6.10 10/26/2006
Ubuntu  7.04 04/19/2007
Ubuntu  7.10 10/18/2007
Ubuntu  8.04 04/24/2008
Ubuntu  8.10 10/30/2008

// 如何对 distros 按照其 发布的版本 以及 发布时间 进行排序呢？

// 单纯的 按照 发布版本排序
root@precise64:~/shell_test# sort distros.txt  -nrk 2
SUSE    11.0 06/19/2008
SUSE    10.3 10/04/2007
SUSE    10.2 12/07/2006
SUSE    10.1 05/11/2006
Fedora  10   11/25/2008
Fedora  9    05/13/2008
Ubuntu  8.10 10/30/2008
Ubuntu  8.04 04/24/2008
Fedora  8    11/08/2007
Ubuntu  7.10 10/18/2007
Ubuntu  7.04 04/19/2007
Fedora  7    05/31/2007
Ubuntu  6.10 10/26/2006
Ubuntu  6.06 06/01/2006
Fedora  6    10/24/2006
Fedora  5    03/20/2006

// 综合排序， 使用多个key， 版本，以及版本号 进行综合排序
root@precise64:~/shell_test# sort --key=1,1 --key=2n distros.txt
Fedora  5    03/20/2006
Fedora  6    10/24/2006
Fedora  7    05/31/2007
Fedora  8    11/08/2007
Fedora  9    05/13/2008
Fedora  10   11/25/2008
SUSE    10.1 05/11/2006
SUSE    10.2 12/07/2006
SUSE    10.3 10/04/2007
SUSE    11.0 06/19/2008
Ubuntu  6.06 06/01/2006
Ubuntu  6.10 10/26/2006
Ubuntu  7.04 04/19/2007
Ubuntu  7.10 10/18/2007
Ubuntu  8.04 04/24/2008
Ubuntu  8.10 10/30/2008

// k 可以为 f[.c][opts]  可以指定 field 中的 c pos 用来比较
root@precise64:~/shell_test# sort -k 3.7nbr -k 3.1nbr -k 3.4nbr distros.txt
Fedora  10   11/25/2008
Ubuntu  8.10 10/30/2008
SUSE    11.0 06/19/2008
Fedora  9    05/13/2008
Ubuntu  8.04 04/24/2008
Fedora  8    11/08/2007
Ubuntu  7.10 10/18/2007
SUSE    10.3 10/04/2007
Fedora  7    05/31/2007
Ubuntu  7.04 04/19/2007
SUSE    10.2 12/07/2006
Ubuntu  6.10 10/26/2006
Fedora  6    10/24/2006
Ubuntu  6.06 06/01/2006
SUSE    10.1 05/11/2006
Fedora  5    03/20/2006


// --debug 选项 是比较有意思的，用来在 不知道 key 以及sort情况时候，用来展现 其内部sort key 的方式
root@precise64:~/shell_test# cat /etc/passwd | sort -t ':' -k 7 --debug | head
sort: using `en_US' sorting rules
root:x:0:0:root:/root:/bin/bash
                      _________
_______________________________
vagrant:x:1000:1000:vagrant,,,:/home/vagrant:/bin/bash
                                             _________
______________________________________________________
messagebus:x:102:105::/var/run/dbus:/bin/false
                                    __________
______________________________________________
mysql:x:106:111:MySQL Server,,,:/nonexistent:/bin/false
```
* uniq: 去除 重复的 条目, 比较有意思的是 需要在sort之后 使用，也就是说 uniq只能去除掉 相邻的 重复的条目

```shell
[me@linuxbox ~]$ cat > foo.txt 
a
b
c
a
b
c

[me@linuxbox ~]$ uniq foo.txt 
a
b
c
a
b
c

[me@linuxbox ~]$ sort foo.txt | uniq 
a
b
c
```

* cut: 用于 使用 -d, --delimiter=DELIM 默认为tab 分隔line， 然后提取 field， characters 等

```shell
root@precise64:~/shell_test# cat /etc/passwd | cut -d ':' -f 1 | head
root
daemon
bin
sys
sync
games
man
lp
mail
news
```
* comm: 用于比较 两个文本的变化差异: comm file1 file2 其结果 第一列 显式 file1 独有的，第二列 显示 file2 独有的， 第三列 显示 file1 file2 共同的

```shell
root@precise64:~/shell_test# cat file1.text
a
b
c
d

root@precise64:~/shell_test# cat file2.text
b
c
d
e

// 注意 其展现形式， 第一列only file1 have  第二列 only file2 have  第三列 comm
root@precise64:~/shell_test# comm file1.text file2.text
a
		b
		c
		d
	e
```


https://toroid.org/unix-pipe-implementation

* diff: diff file1.txt file2.txt； diff 展现的格式 都为 更改 file1.txt 转变到 file2.txt 的操作序列，即是 字符串 之间最小编辑记录 在文件中的应用。

```shell
root@precise64:~/shell_test# cat file1.text
a
b
c
d
root@precise64:~/shell_test# cat file2.text
b
c
d
e

root@precise64:~/shell_test# diff file1.text  file2.text
1d0
< a
4a4
> e
```


| Change | meaning                                                |
|--------|--------------------------------------------------------|
| r1ar2  | 将 file2 中的 r2行 追加到 file1 中的 r1 行中           |
| r1cr2  | 将 file1 中 r1 行 替换为 file2中的 r2 行               |
| r1dr2  | 将 file1中的r1行删除掉，下一行将出现在 file2中的 r2 行 |

此格式为默认格式，但是因为不够直观，所以这种格式并不常用。

上下文格式：diff -c file1.txt file2.txt

```shell
root@precise64:~/shell_test# diff -c file1.text  file2.text
*** file1.text	2020-09-24 08:02:08.202406914 +0000 // ** 代表 file1.txt，其后是 时间戳
--- file2.text	2020-09-24 08:02:15.854515682 +0000 // -- 代表 file2.txt 其后是 时间戳
***************
*** 1,4 **** // ** 代表 file1.txt
- a
  b
  c
  d
--- 1,4 ---- // -- 代表 file2.txt
  b
  c
  d
+ e
```


| Indicator | Meaning                                                             |
|-----------|---------------------------------------------------------------------|
| blank     | 此行 两个文件没有差别                                               |
| -         | 需要删除该行(只会出现在 file1中，因为目的是 将file1 转向 file2)     |
| +         | 添加该行 （只会出现在file2中，代表 需要将该行添加到 file1中）       |
| !         | 两个文件中都会出现，代表 file1中的该行 需要被 file2中的 对应行 替换 |

统一格式： diff -u file1.txt file2.txt

```shell
root@precise64:~/shell_test# diff -u file1.text file2.text
--- file1.text	2020-09-24 08:02:08.202406914 +0000
+++ file2.text	2020-09-25 04:41:15.154310271 +0000
@@ -1,4 +1,4 @@
-a
 b
 c
 d
+e
```

| Character | Meaning                |
|-----------|------------------------|
| blank     | no change              |
| -         | 从file1 文件中删除该行 |
| +         | 从file1 文件中添加该行 |

也就是说 统一格式 中，将 ！替换操作去除了，通过 - + 来实现了 替换操作

* patch: 用来将diff 出的结果 apply。 即是： diff -Naur old_file new_file > diff_file; patch < diff_file; 之后 old_file 会转变为 same as new_file

### shell 语法
1. Variables and Constants
* shell 中的变量 是 动态的，不需要预先声明 与类型指定（因为没有类型，可能都为字符串），对于 使用 未定义 未赋值 的变量 其 数值 为 空。 所以我们需要 注意自己的拼写错误，因为 shell可能会将其视为 新变量。
* 常量： 规范 使用 全大写 命名 常量，以区分于 普通变量。 也可以使用 declare -r TITLE="Page Title" 来进行声明
* 赋值： variable=value  shell 并不区分 value的类型， value 全部被视为 string， 注意= 左右没有空格
* 变量数值引用 需要注意， 因为语法原因 可能 需要使用 {} 来避免 变量名与表达式 的歧义

```shell
a=z # a 赋值为 string z
b="a string"
c="a string and $b" # c 

d="$(ls -l foo.txt)" # value 为子命令结果
e=$((5 * 7)) # 数值计算展开

a=5 b="string" # 多个变量可以 同时声明

filename="myfile"
touch $filename
mv "$filename" "$filename1"  # 这里面的本意是 更改myfile 文件为 myfile1，但是因为并没有 区分 $filename1 是变量还是表达式, 所以这里需要 使用新的形势 来进行区分
mv: missing destination file operand after `myfile'
Try `mv --help' for more information.

mv "$filename" "${filename}1" # 使用 {} 来解决歧义
```
###  function define:
```shell
functiono name {
    commands
    return
}

name() {
    commands
    return
}

```

* local var: 局部变量， local foo=

### Flow Control:
* if
```shell
if commands; then 
  commands
[elif commands; then 
  commands...]
[else 
  commands]
fi
```
* exit status: 一般为 为一个 0-255 的数值， 0 代表 success， 其他值代表不同的错误。所以0 代表true，false 代表1， 不同于其他语言中的惯例。$? 代表 上个命令执行的返回结果
```shell
root@precise64:~/shell_test# ls -d /usr/bin/
/usr/bin/
root@precise64:~/shell_test# echo $?
0
root@precise64:~/shell_test# ls -d /bin/usr
ls: cannot access /bin/usr: No such file or directory
root@precise64:~/shell_test# echo $?
2
```
* test： 配合if 使用，返回condition 结果: 两种形式. 成功返回0， 失败 返回1

```shell
test expression

[expression]
```
#### 相关的测试expression
* file Expression
| Expression      | Is True?                                           |
|-----------------|----------------------------------------------------|
| file1 -ef file2 | file1 inode eq file2 inode true                    |
| file1 -nt file2 | file1 is newer than file2                          |
| file1 -ot file2 | file1 is older than file2                          |
| -b file         | file exist and is a block-special file             |
| -c file         | file exist and is a char-special file              |
| -d file         | file exists and is a dir                           |
| -e file         | file exists                                        |
| -f file         | file exists and a regular file                     |
| -g file         | file exists and is set-group-id                    |
| -G file         | file exists and is owner by the effective group ID |
| -k file         | file exists and has its 'sticky bit' sit           |
| -L file         | file exists and is a sym link                      |
| -p file         | file exists and a named pipe                       |
| -r file         | file exists and can readable                       |
| -s file         | file exists and has a length greater than zero     |
| -S file         | file exists and a socket                           |
| -w file         | file exists and writable                           |
| -x fiel         | file exists and executeable                        |


* string expression

| Expression   | Meaning                |
|--------------|------------------------|
| string       | string is not null     |
| -n string    | string len is not zero |
| -z string    | string len is zero     |
| str1 == str2 | equal                  |
| str1 != str2 | not equal              |
| str1 > str2  | str1 sorts after str2  |
| str1 < str2  | str1 sort before str2  |

这里面 需要注意: the > and < expression operators must be quoted (or escaped with a backslash) when used with test. If they are not, they will be interpreted by the
shell as redirection operators

* Integer Expressions

| Expression    | Meaning      |
|---------------|--------------|
| int1 -eq int2 | equal        |
| int1 -ne int2 | not equal    |
| int1 -le int2 | int1 <= int2 |
| int1 -lt int2 | int1 < int2  |
| int1 -ge int2 | int1 >= int2 |
| int1 -gt int2 | int1 > int2  |

*  [[ expression ]] : 类似于 [ expression ], 大使可以测试 string1 =~ regex
*  (( )): Designed for Integers, 用于测试 数学计算， 如果 数值 为非0 则是true， 0 则为false。在(()) 中变量可以直接 使用，不用带 $, 例如, 在其中 可以使用 所有的数学表达式，比如 >, <, >=, <=, ==, %, /, * etc

```shell
INT=5
if ((INT == 0)); then
    echo "INT is zero"
fi
```
* Combining Expressions:

| Operation | test | [[]] and (()) |
|-----------|------|---------------|
| AND       | -a   | &&            |
| OR        | -o   |               |
| NOT       | !    | !              |

for example:

```shell
#!/bin/bash

MIN_VAL=1
MAX_VAL=100


INT=50
if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if [[ "$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL" ]]; then
        echo "$INT is within $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is out of range."
    fi
else
    echo "INT is not an integer." >&2
    exit 1
fi


# 等价的另一种方式

if [ "$INT" -ge "$MIN_VAL" -a "$INT" -le "$MAX_VAL" ]; then
  echo "$INT is within $MIN_VAL to $MAX_VAL."
else
  echo "$INT is out of range."
fi
```

#### read: read 用于 从标准输入中 读取数值。 

| Options    | Desc                                                        |
|------------|-------------------------------------------------------------|
| -a array   | 将输入赋值（转化）给 数组                                   |
| -e         | 使用 Readline 模式 处理输入                                 |
| -i string  | 默认数值，在玩家仅仅按 enter的时候 有用                     |
| -p prompt  | 输入的 提示信息                                             |
| -r         | Raw mode. Do not interpret backslash characters as escapes. |
| -s         | slient mode, 用于密码输入                                   |
| -t seconds | Timeout after seconds                                       |
| -u fd      | 使用file 作为输入，而不是标准输入                                                            |

* read：将 标准输入 转到 变量 的使用格式： read  [-options] [variable...] 
* read 存在默认变量 REPLY，即当没有 variable 传递的时候
* for example
```shell
#!/bin/bash

echo -n "please enter an integer -> "
read int

if [[ "$int" =~ ^-?[0-9]+$ ]]; then
    if (( int == 0 )); then
        echo "int is zero"
    else
        if (( int < 0)); then
            echo "$int is negative"
        else
            echo "$int is positive"
        fi
    fi
fi

#  read 多个var 测试, 与ruby array 复制差不多，
# 即是：当多个 参数数目 > 变量数目 时 剩余的变量为空值，当 参数数目 < 变量数目时 最后后一个变量 存储多个数值

#!/bin/bash
# read-multiple: read multiple values from keyboard
echo -n "Enter one or more values > "
read var1 var2 var3 var4 var5
echo "var1 = '$var1'"
echo "var2 = '$var2'"
echo "var3 = '$var3'"
echo "var4 = '$var4'"
echo "var5 = '$var5'"

vagrant@precise64:/vagrant_data/shell_test$ ./read-multiple.sh
Enter one or more values > 1 2 3 4 4 45 5
var1 = '1'
var2 = '2'
var3 = '3'
var4 = '4'
var5 = '4 45 5'

vagrant@precise64:/vagrant_data/shell_test$ ./read-multiple.sh
Enter one or more values > 1
var1 = '1'
var2 = ''
var3 = ''
var4 = ''
var5 = ''

# read 不传递 var 时候，默认使用变量 REPLY
#!/bin/bash
# read-single: read multiple values into default variable
echo -n "Enter one or more values > "
read
echo "REPLY = '$REPLY'"

vagrant@precise64:/vagrant_data/shell_test$ ./read-single.sh
Enter one or more values > 1
REPLY = '1'



```

* IFS （Internal Field Separator） : 用来控制 read 分隔line 的分隔符， 默认的IFS 包含 space, tab, newline
* 使用read的 这种方式， 可以很简单的 做 字符串的 split

```shell
IFS=":" read user pw uid gid name home shell <<< "root:x:0:0:root:/root:/bin/bash"
echo "string: ${user}, pw: ${pw}, uid: ${uid}, shell: ${shell}"
```

#### Flow Control: Looping with while/until

* while: shell 中 同样存在 continue break 可供使用，以便提前 循环、或者 终止循环
```shell
while commands; do
    commands
done


count=1
while [[ "$count" -le 5 ]];
    do echo "$count"
    count=$((count + 1))
done
echo "Finished."
```
* until: 与while 同样的基本结构，不过测试条件相反

```shell
#!/bin/bash
# until-count: display a series of numbers count=1
until [[ "$count" -gt 5 ]]; do
    echo "$count"
    count=$((count + 1))
done
echo "Finished."
```

* 读取文件的循环示例：

```shell
#!/bin/bash
# while-read: read lines from a file
while read distro version release; do
    printf "Distro: %s\tVersion: %s\tReleased: %s\n" \
        "$distro" \
        "$version" \
        "$release"
done < distros.txt
```

* shell 的测试： 1） 除了 print 大法好(在这里是echo 之外) 2) #!/bin/bash -x  这样在脚本运行期间，将会 展示详细信息, 可以 使用 set +x 关闭 tracing set -x开启 tracing

* case:  使用 pattern 进行匹配，) 结束 匹配。 还可以参考链接 http://tiswww.case.edu/php/chet/bash/bashref.html#SEC21 http://tldp.org/LDP/abs/html/testbranch.html 因为这里面介绍的十分简单


| Pattern       | Desc                                      |
|---------------|-------------------------------------------|
| a)            | Match if word equal 'a'                   |
| [[:aplpha:]]) | Match if word is a single alphabetic char |
| ???)          | Match if word is exactly three char long  |
| *.txt)        | Match if word ends with the char ".txt"   |
| *)            | Matches anyy value of word                                          |


```shell
case word in
    [pattern [| pattern]...) commands ;;]...
esac
```
* for example
```shell
#!/bin/bash -x

read -p "Enter selection [0-3] > "
case "$REPLY" in
    0) echo "Program terminated."
       exit
       ;;
    1) echo "Hostname: $HOSTNAME"
       uptime
       ;;
    2) df -h
       ;;
    3) if [[ "$(id -u)" -eq 0 ]]; then
           echo "Home Space Utilization (All Users)"
           du -sh /home/*
       else
           echo "Home Space Utilization ($USER)"
           du -sh "$HOME"
       fi
       ;;
    *) echo "Invalid entry" >&2
       exit 1
       ;;
esac

```

#### Accessing the Command Line: 
* shell 中 通过 $0-$9 来接受 command line 传递的参数。其中9 并不是 参数个数的上线，可以使用 更多的比如 $11, $100000 来使用 第 1000000 个参数。
*  $# 标志 参数个数。其中 $0 总是为 shell本身
*  shift： shift可以将 将 $1后续的变量，转移到 $1上， 同时 $# 减少

```shell
#!/bin/bash
# posit-param2: script to display all arguments count=1
while [[ $# -gt 0 ]]; do
  echo "Argument $count = $1"
  count=$((count + 1))
  shift
done
```

* 同样是 作为 函数 传递参数的方式： 
* 常量： PROGNAME当前shell运行的函数， FUNCNAME 为shell当前运行的shell函数
* $* $@ "$*" "$@" : “$@” 在这里面是最为 重要的，以为保留了 原来参数传递的样式

```shell
// fun_test.sh file
#!/bin/bash
# posit-params3: script to demonstrate $* and $@
print_params () {
    echo "\$1 = $1"
    echo "\$2 = $2"
    echo "\$3 = $3"
    echo "\$4 = $4"
}
pass_params () {
    echo -e "\n" '$*'; print_params $*
    echo -e "\n" '$*'; print_params "$*"
    echo -e "\n" '$@'; print_params $@
    echo -e "\n" '$@'; print_params "$@"
}
pass_params "word" "words with spaces"


// ./fun_test.sh 测试
root@precise64:/vagrant_data/shell_test# ./fun_test.sh

 $*
$1 = word
$2 = words
$3 = with
$4 = spaces

 $*
$1 = word words with spaces
$2 =
$3 =
$4 =

 $@
$1 = word
$2 = words
$3 = with
$4 = spaces

 $@
$1 = word
$2 = words with spaces
$3 =
$4 =
```
 
 
#### for loop: 
传统形式
```shell
for variable [in words]; do 
  commands
done
```
c语言形式： 只支持 在对 数字 进行操作的时候

```shell
for (( expression1; expression2; expression3 )); do
  commands
done

for (( i=0; i<5; i=i+1 )); do
    echo $i
done
```

example
```shell
[me@linuxbox ~]$ for i in A B C D; do echo $i; done
A
B
C
D


for i in {A..D}; do echo $i; done
A
B
C
D

[me@linuxbox ~]$ for i in distros*.txt; do echo "$i"; done
distros-by-date.txt
distros-dates.txt
distros-key-names.txt
distros-key-vernums.txt
distros-names.txt
distros.txt
distros-vernums.txt
distros-versions.txt



# ./for_test.sh file
for i; do
    echo "i in ---------- ${i} \n"
done


# 可以使用如此的方式，循环打印 command line 参数
root@precise64:/vagrant_data/shell_test# ./for_test.sh  a b c d e f j
i in ---------- a \n
i in ---------- b \n
i in ---------- c \n
i in ---------- d \n
i in ---------- e \n
i in ---------- f \n
i in ---------- j \n

```



#### Strings and Numbers

| expression                                                                                     | meaning                                                                                                                                        |
|------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| ${para:-word}                                                                                  | para 为空 express result 为 word                                                                                                               |
| ${para:=word}                                                                                  | para 为空 express & para result 为 word (position 参数不能够如此赋值)                                                                          |
| ${pars:?word}                                                                                  | pars 为空 则exit，word被输出到 stderr                                                                                                          |
| ${para:+word}                                                                                  | para不为空，则 expres 为 word                                                                                                                  |
| ${!prefix*} 或者  ${!prefix@}                                                                  | 返回 以 prefix 为前缀的 变量名称                                                                                                               |
| ${#para}                                                                                       | para length, 如果 para 为 @ 或者 * 则 展开为 command line params size                                                                          |
| ${para:offset} ${para:offset:length}                                                           | 用于string 的片段截取，没有length时候，则直到末尾, para为 @时候, 则为 参数 从 offset开始 到结尾                                                |
| ${para#pattern} ${para##pattern}                                                               | 将字符串remove pattern match的部分，结果为 剩下的部分， #pattern remove 最短的 match 部分， ## 则remove 最长的match                            |
| ${para%pattern}  ${para%%pattern}                                                              | 同上，但是 remove 片段从string 的末尾开始，而非开头开始                                                                                        |
| ${para/pattern/string} ${para//pattern/string} ${para/#pattern/string} ${para/%pattern/string} | string 的查找替换操作，使用 string 替换 para中的 pattern matched，第一个只替换第一个， 第二个则全部替换， 第三个 则替换开头， 第四个只替换末尾 |


case conversion parameter

| Format    | Result                       |
|-----------|------------------------------|
| ${pars,,} | 展开为  para 的 全部小写形式 |
| ${para,}  | 展开式 para 首字母 小写      |
| ${para^^} | 展开为 para 的全部 大写形式  |
| ${para^}  | 展开为 para 首字母 大写形式  |


#### 数字操作: $((expression)) 基本形式
* Operators
| Operator             | Desc |   |   |
|----------------------|------|---|---|
| +                    |      |   |   |
| -                    | *    |   |   |
| *                    |      |   |   |
| /                    |      |   |   |
| **                   |      |   |   |
| %                    |      |   |   |
| para = value         |      |   |   |
| para += value        |      |   |   |
| para -= value        |      |   |   |
| para *= value        |      |   |   |
| para /= value        |      |   |   |
| para %= value        |      |   |   |
| para ++              |      |   |   |
| para --              |      |   |   |
| ++ para              |      |   |   |
| -- para              |      |   |   |
| <=                   |      |   |   |
| >=                   |      |   |   |
| <                    |      |   |   |
| >                    |      |   |   |
| ==                   |      |   |   |
| !=                   |      |   |   |
| &&                   |      |   |   |
| expre1?expre2:expre3 |      |   |   |

#### Array: bash version2 才得到支持，在原先的shell中 并不支持 array
* Create a Array : 
```shell
a[1]=foo
echo ${a[1]}

declare -a a
```
* Assigning Values to an Array: name[subscript]=value; name=(value1 value2 ...)
* Array Operations: 遍历数组

```shell
[me@linuxbox ~]$ animals=("a dog" "a cat" "a fish") 
[me@linuxbox ~]$ for i in ${animals[*]}; do echo $i; done 
a
dog
a
cat
a
fish

[me@linuxbox ~]$ for i in ${animals[@]}; do echo $i; done a
dog
a
cat
a
fish

[me@linuxbox ~]$ for i in "${animals[*]}"; do echo $i; done
a dog a cat a fish

[me@linuxbox ~]$ for i in "${animals[@]}"; do echo $i; done
a dog
a cat
a fish

# "${!array[*]}", "${!array[@]}"
[me@linuxbox ~]$ foo=([2]=a [4]=b [6]=c)

[me@linuxbox ~]$ for i in "${foo[@]}"; do echo $i; done 
a
b
c

# 展示数组 有value的 indexs
[me@linuxbox ~]$ for i in "${!foo[@]}"; do echo $i; done
2
4
6

```

* Sorting an Array: 

```shell
#!/bin/bash
# array-sort: Sort an array a=(f e d c b a)
echo "Original array: ${a[@]}"
# 传统的数组排序方式，因为shell并不会构建复杂的 类型系统 来进行 数组函数排序
a_sorted=($(for i in "${a[@]}"; do echo $i; done | sort))
echo "Sorted array: ${a_sorted[@]}"
```
* Deleting an Array: unset array; unset 'array[index]' array=xxxx 修改 array[0] 中的数值
```shell
[me@linuxbox ~]$ foo=(a b c d e f)
[me@linuxbox ~]$ echo ${foo[@]}
a b c d e f
[me@linuxbox ~]$ unset foo
[me@linuxbox ~]$ echo ${foo[@]}

[me@linuxbox ~]$


[me@linuxbox ~]$ foo=(a b c d e f)
[me@linuxbox ~]$ echo ${foo[@]}
a b c d e f
[me@linuxbox ~]$ unset 'foo[2]'
[me@linuxbox ~]$ echo ${foo[@]}
a b d e f


[me@linuxbox ~]$ foo=(a b c d e f)
[me@linuxbox ~]$ foo=
[me@linuxbox ~]$ echo ${foo[@]}
b c d e f


[me@linuxbox ~]$ foo=(a b c d e f)
[me@linuxbox ~]$ echo ${foo[@]}
a b c d e f
[me@linuxbox ~]$ foo=A
[me@linuxbox ~]$ echo ${foo[@]}
A b c d e f
```

#### Group Commands and Subshells:
* { command1; command2; [command3; ...] }
* (command1; command2; [command3;...])
group commands  可以将  其中的command 的结果 很方便的 合并到一个 数据流汇总，例如：

```shell
(ls -l; echo "Listing of foo.txt"; cat foo.txt) > output.txt
{ ls -l; echo "Listing of foo.txt"; cat foo.txt; } > output.txt

#等同于： 
ls -l > output.txt
echo "Listing of foo.txt" >> output.txt
cat foo.txt >> output.txt

```

#### Process Substitution： 区别于 group commands ， Process sub 运行在 子进程 中，而group command 则运行在当前进程中， 所以从效率上来说 group command 要快于 process substitution, 该技术使得  子进程 中的输出 到当前进程中 进行处理。通常 将 子进程中的数据流 输出到当前 进程使用 read 处理。

* 形式为： <(list)， >(list)。

for example
```shell

#!/bin/bash
# pro-sub: demo of process substitution
while read attr links owner group size date time filename; do
done < <(ls -l | tail -n +2)
```

#### Traps: 处理 信号。trap argument signal [signal...]  其中 argument 为string， 例如：
```shell
trap "echo 'I am ignoring you.'" SIGINT SIGTERM

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM
```

#### Docker 书籍
##### Docker 的结构：  客户端 + 服务器。 Docker 服务器 为一个守护进程，下层抽象 Docker 容器，与客户端配合 提供了 一个RESTful API 给 客户端。
##### 概念： 镜像 与 容器。镜像是Docker世界的基石，类似于 面向对象中的 类， 所有容器 都是基于 镜像 运行的。也就是说 容器类似于 实例对象。镜像 是 Docker生命周期 中的 构建或 打包阶段，容器则是启动和 执行阶段。
  * Docker容器： 一个镜像格式，一系列标准的操作，一个执行环境
##### docker 能够帮助我们做什么：
  * 加速本地开发和构建流程，因为其高效轻量，可以方便本地开发人员进行构建
  * 能够让独立服务在不同的应用环境中，得到相同的运行结果。
  * 创建隔离的环境进行测试
  * 都建一个多用户的平台及服务（PaaS）基础设施
  
##### Docker的特性？ linux namespace 的作用：
  * 文件系统隔离：每个容器都有自己的root文件系统
  * 进程隔离： 每个容器都运行在自己的进程环境中
  * 网络隔离：荣期间的虚拟网络接口和IP地址都是分开的
  * 资源隔离和分组： 使用cgroups 将CPU 和内存之类的资源独立分配给每个Docker容器
  * 写时复制： 文件系统都是通过写时复制创建的，这就意味着文件系统是分层的、快速的、占用小的磁盘空间
  * 日志： 容器产生的STDOUT stderr, stdin 这些IO都会被收集并记录入日志，用来进行日志分析和故常排查
  * 交互式shell： 用户可以创建一个伪造tty中断连接的，STDIN，为容器提供一个交互式的Shell 
##### Docker 守护进程（服务器）： 
  * 需要以root权限运行，以便处理 诸如 挂载文件系统 等特殊操作。
  * 守护进程 监听 /var/run/docker.sock Unix套接字 来获得 Docker客户端的请求。
  * 启动： ubuntu 中 start docker, stop docker， centos 中 service docker stop service docker start
##### Docker 操作：Docker容器 则为 Docker的运行态，运行着 用户的process， 容器内部同linux namespace 一样，进行了完全的隔离
  * 创建容器： docker run -i -t ubuntu /bin/bash  -i 标志打开容器的STDIN， -t 为容器 分配一个伪 tty 终端
  * 停止容器： docker stop daemon_dave; docker stop 2q3412c
  * 删除容器： docker rm daemon_dave // 容器停止运行并不会自动清理，而需要 手动 rm，因为可能存在 重新 start 的需求。类似于进程
  * 命名容器： docker run --name test_container -i -t ubuntu /bin/bash 容器的命名必须是唯一的。
  * 创建守护式容器： (daemonized container): docker run --name daemon_dave -d ubuntu /bin/bash -c "while true; do echo hello world; sleep 1; done"//  -d 为 daemon运行的标志， 容器中的进程不能够退出
* 重启已经停止的容器： docker start test_container
  * 附着到容器： docker attach test_container
  * 查看容器日志： docker logs -f daemon_dave //
  * 查看容器内进程： docker top daemon_dave
  * 在容器内运行进程： docker exec -d daemon_dave touch /etc/new_config_file 可以在现有的容器内 启动新进程，无论是后台任务还是交互式任务
  * 自动重启容器： docker run --restart=always --name daemon_dave // docker可以通过设定  --restart 标志来检测 容器的退出代码 来决定是否重启容器
  * 深入容器： docker inspect daemon_dave
  * 查看运行中的容器： docker ps

##### Docker 镜像: 
  * 列出镜像：docker images
  * 拉取镜像： docker pull ubuntu
  * 查找镜像: docker search puppet
  * 使用Dockerfile构建镜像： 
###### 使用Dockerfile构建镜像： Dockerfile 有一系列 指令和参数构成，每条命令 都必须为大写字母 比如 RUN FROM 后面跟随参数， Dockerfile 从上到下执行，每条指令都会创建一个新的镜像层并对镜像进行提交。流程如下： 
```shell
FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install -y nginx
RUN echo 'Hi, I am in your container' > /usr/share/nginx/html/index.html
EXPOSE 80

docker build -t="static_web" ./
docker run -d -p 80 --name static_web static_web nginx -g "daemon off;"
```

####### 1. 流程:
  * Docker 从基础镜像运行一个容器
  * 执行一条指令，对容器做出修改
  * 执行类似docker commit 操作，提交一个新的镜像层
  * Docker在基于刚才提交的镜像层运行一个新容器
  * 执行Dockerfile 中的下一条命令，知道所有指令运行完毕
####### 2. 详细： 
  * 每个Dockerfile 的第一条指令 都是从FROM 开始的，该镜像 被称为基础镜像
  * expose 指令 指明 容器 使用的端口号，但 docker 在运行容器时候，并不会打开端口，需要使用指令来明确docker 打开特定的端口号
  * Dockerfile 的构建方式，导致如果 在因为一些命令失败，则可以得到一个 最近成功命令 的镜像，可以基于该命令 运行一个交换式的容器 来方便调试, 比如 docker run -t -i 最后commit  /bin/bash
####### 构建: docker build -t="xxxx" ./
  * docker 构建 过程会添加缓存： 可以如此 docker build --no-cache -t="xxxx" 来跳过缓存
  * docker 在修改命令之后的 的命令 重建缓存
  * 可以添加 ENV REFRESHED_AT 2020-10-09 在头部，当希望 重建镜像时候，可以更改 其时间来 进行  之后命令的重建
  * 查看镜像： docker images; 
  * 查看镜像的构造过程: docker history
  * 容器端口： -p 用来指定端口， 方式有： -p 80:80 -p 127.0.0.1:80:80, -p 127.0.0.1::80 -P 前两个指定端口绑定到 容器中的端口， 后面两个则 将随机端口绑定到 容器中的端口， -P 表示 将随机的本地端口 绑定到 Dockerfile中的expose 的端口

####### Dockerfile 指令: 
  * CMD: 指定容器启动时候的运行的命令， 区分于RUN 为镜像被构建时运行的命令，CMD 则是容器启动时候运行的命令。同docker run时候指定的命令， docker run中的命令会覆盖CMD命令，即 docker run中指定了命令，则CMD中的命令将不会被执行
  * ENTRYPOINT： 区分于 CMD，不会被 docker run中的命令 所替代，而是 替代 CMD 一起传递给 ENTRYPOINT，示例： 
    ```shell
    ENTRYPOINT ["/usr/sbin/nginx"]
    CMD ["-h"]

      docker  run -t -i static_web -g "daemon off;"
    ```
  * WORKDIR: 为后续的指令 执行  设定工作目录， 
  * ENV: 指定环境变量， 在后续的 RUN 中使用，也可以在其他命令中使用环境变量。 该变量 持久的保存到 从我们的镜像创建的任何容器中。 相反 在docker run -e 中传递的环境变量 则一次性有效
    ```shell
    ENV RVM_PATH /home/rvm
    RUN gem install unicorn
    // 等同于  RVM_PATH=/home/rvm gem install unicorn

    ENV TARGET_DIR /opt/app
    WORKDIR $TARGET_DIR
    ```
  * VOLUME: 向 从该镜像创建的容器 添加卷。卷是容器中的特殊目录 ，可以跨越文件系统，进行共享，提供持久化功能，有如下特性
    * 卷 可以再 容器间 共享和重用
    * 一个容器 可以不是必须 和 其他容器共享卷
    * 对卷的修改 立即生效
    * 对卷的修改不会影响镜像
    * 卷会一直存在知道没有任何 容器使用它。(标志着 卷 是由 docker管理的，而非容器，也非操作系统)
    * VOLUME ["/opt/project", "/data"] 可以使用数组形式 创建多个挂载点
  * ADD: 将 构建环境下 的文件或 目录  复制到 镜像中。ADD software /opt/application/software; ADD source target 
    * 其中source可以是 文件或者目录 或者url，不能对构建目录之外的文件进行ADD操作。(因为docker只关心 构建环建， 构建环境之外的任何东西 在命令中都是不可用的)
    * target 如果目录不存在的话，则 docker会创建 全路径，新建文件目录的权限 为0755
    * ADD命令会屎之后的命令不能够使用缓存。
    * ADD 会将 归档文件 进行 解压，例如 ADD latest.tar.gz /var/www/wordpress/
  * COPY： 区分于 ADD， copy只做纯粹的复制操作。不会进行解压缩操作.
  * 产出镜像： docker rmi static_web

##### 实践：
-v 允许我们将宿主机的目录作为卷，挂在到容器里。-v source:target 

* 构建 Redis 镜像
```shell
FROM ubuntu:14.04
ENV REFRESHED_AT 2020-10-09
RUN apt-get update
RUN apt-get -y install redis-server redis-tools
EXPOSE 6379
ENTRYPOINT ["/usr/bin/redis-server"]
CMD []
```
* 连接到 redis 容器: 容器之间 互连。 如果使用 映射到宿主机 的ip 来连接到 对应的容器，在 容器重启之后，因为其port会改变（当然可以使用 参数固定 其对应的宿主机 port） 会导致 之前的链接配置失效，从而无法使用 该种 方法 建立长久的固定的链接。
* docker 提供了另一种方法: --link 使用 该标志 创建两个容器的父子链接。链接让 父容器有能力访问子容器， 并将子容器的一些详细信息分享给父容器，应用程序可以利用 这些信息 建立链接。示例：

```shell
docker run  -d --name redis_con  redis

docker run -p 4567 --name webapp --link redis:db -t -i sinatra /bin/bash
// 该命令中 使用--link标志创建了  sinatra 到 redis_conn 的父子链接关系
```
* 链接的特点： 
  * 使子链接 无需公开端口，从而更安全一些。容器端口不需要在宿主机 上 公开，就可以限制被攻击的方面，减少应用暴露的网络
  * 被连接的容器 必须运行在同一个 Docker宿主机上，不同的Docker宿主机 上的容器不能够互相链接
* 链接的实现方法： docker 在父容器里的两个地方写入了链接信息。 
  *  /etc/hosts 文件
  *  包含链接信息的环境变量 ( 自动创建的环境变量包括： 子容器的名字， 子容器服务所运行的 协议 ip 端口 )  

```shell

docker run -d --name redis_con redis
docker run --link redis:db -i -t ubuntu /bin/bash

root@31c4f6ac36a4:/# cat /etc/hosts
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.3	db 949baab68dd4 redis_con
172.17.0.4	31c4f6ac36a4


root@31c4f6ac36a4:/# env

DB_PORT_6379_TCP_ADDR=172.17.0.3
DB_PORT_6379_TCP=tcp://172.17.0.3:6379
DB_PORT=tcp://172.17.0.3:6379
....
```
* 所以： 在应用程序中  通过使用 环境变量 来链接 子容器 是非常方便的方法。

```shell
require 'uri

uri = URI.parse(ENV['DB_PORT'])
redis = Redis.new(:host => uri.host, :port => uri.port)
```


#### 实践： 通过 Jekyll Apache 来构建 自动构建一个博客网站

jekyll 镜像
```shell
FROM ubuntu:14.04
ENV refreshed_at 2020-10-10

RUN apt-get update
RUN apt-get install -y ruby ruby-dev make nodejs
RUN gem install --no-rdoc --no-ri jekyll

VOLUME /data
VOLUME /var/www/html

WORKDIR /data

ENTRYPOINT [ "jekyll", "build", "--destination=/var/www/html" ]

docker build -t jekyll ./
```

apache 镜像
```shell
FROM ubuntu:14.04
ENV REFRESHED_AT 2020-10-10

RUN apt-get update
RUN apt-get install -y apache2

VOLUME [ "/var/www/html" ]
WORKDIR /var/www/html

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/logapache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN mkdir -p $apache_run_dir $apache_lock_dir $apache_log_dir
EXPOSE 80

ENTRYPOINT [ "/usr/sbin/apache2" ]
CMD ["-D", "foreground"]

docker build -t apache ./
```


docker run -v /home/james/blog:/data/ --name jekyll_con jekyll

docker run -d -P --volumns-from jekyll_con --name apache_conn apache

// 这里使用了 标志 --volumes-from 标志 将指定容器 中的所有卷 添加到 新创建 的容器中。意味着容器 apache_conn 可以访问 容器 jekyll_conn 中的所有卷，即： 可以访问 jekyll_conn 产生的博客文件 目录 /var/www/html 中的内容。
// 卷 只有在没有容器 使用的时候才会被清理，也就是说 在 删除 docker rm jekyll_conn 之后 /var/www/html 中的内容就不复存在了 （这里面是否需要 同时删除 apache_conn 才可以？ 因为apache_conn 依然在使用，把持 该卷. 可以进行实验验证）


备份卷：

docker run --rm --volumnes-from jekyll_conn -v $(pwd):/backup ubuntu tar cvf /backup/blog.tar /var/www/html

创建一个 docker 容器，将 共享的 /var/www/html 卷，进行打包 到 外部目录中。


###### 不使用 ssh 管理 Docker 容器

传统上将，通过ssh 登入运行环境或者虚拟机 来管理服务，在Docker世界中， 大部分容器只运行一个进程，所以不能够使用该方法进行访问。可以通过如下方式进行访问： 使用卷 或者 链接 完成大部分管理操作。比如服务通过某个网络接口做管理， 或者使用 Unix套接字 做管理， 就可以通过 卷 来公开这个套接字，或者发信号 可以 docker kill -s <signal> <container>
  * 如果是登录 容器，则可以使用 nsenter 工具。使用方法如下：

```shell
  PID=$(docker inspect --format {{.State.Pid}} 949baab68dd4)
  nsenter --target 16870 --mount --uts --ipc --net --pid
  nsenter --target 16870 --mount --uts --ipc --net --pid ls
```
###### 对 Docker 容器的编排，或者是非常重要的一步. K8s
