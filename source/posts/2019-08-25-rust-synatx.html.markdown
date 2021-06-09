---
title: rust synatx
date: 2019-08-25
tags: rust
---

### Ownership Rules

  * Each value in Rust has a variable that’s called its owner.
  * There can only be one owner at a time.
  * When the owner goes out of scope, the value will be dropped.

  Scope : { //scope }
  内存申请 let s = String::from("xx");
  内存释放： s 超出scop，变为不可用。rust自动添加drop调动代码， 归还内存
  所有权规则：

  堆、栈 中变量的其他 赋值方式：
  * stack-only: copy
  
    ```rust
    let x = 5;
    let y = x; // x, y  都可用， 因为x 为栈上分配， 对于内存方式为 copy， 不影响所有权
    ```
  * Heap: clone、所有权转移
  
  ```rust
  let s1 = String::from("hello");
  let s2 = s1.clone();// s2 copy s1的内存，s1 依然可用
  ```
  ```rust
  let s1 = String::from("xx");
  let s2 = s1; // s1 不在可用， s2为 字符串的 owner, 这里只是转移 指向 string的指针，而非 copy string
  ```
  
### Function 调用：
  * Function 调用参数： 跟 赋值 一样的所有权  转移一样
  * Function 返回参数： 堆上的内存，作为返回值的时候， 两种情况： 1. 转移所有权 到 函数调用者 2. drop掉 （因为超过 函数中的作用域 scope）

### 引用： Function 调用： 每次都需要转移所有权，在将所有权转回到调用者。非常麻烦， 所以设计了 引用 
**指向变量的指针， 并不具有 ownership， 所以drop并不会，释放内存，使得引用的变量不可用。在Function 中使用 非常合适，因为不需要ownership传递回去， 因为根本没有ownership的转移**

  *  可变 mut 引用: 可以 改变 引用指向的内容。
  *  不可变引用
  *  引用 规则:
    1. 任何时候，只有一个 可更改引用，或者 同时多个不可变应用
    2. 引用需要总是有效的。即： 引用的scope应该小于变量的scope

  ```rust
  fn no_dangle() -> &String {
    let s = String::from("hello");
    &s
  }
  // 函数返回， s 会drop掉， 所以会造成空指针 null reference
  ```
  错误的函数，s在 函数中分配内存，但是只返回引用，**引用变量作用于大于 指向的变量作用域**
  *slice: 同refrence， 引用一个连续的collection，但是没有ownership。 这里用来防止，在同样的作用域使用 mut refrence， 或者 mut 调用 (因为不能同时存在  mut 引用，和 非mut引用。所以自动的添加一份检查)*

###  Generic define & syntax
  定义 函数参数签名（告诉编译器 参数类型）, 形式如下:
  
  ```rust
  fn largest<T>(list:&[T]) -> T {
  }

  struct Point<T> {
      x: T,
      y: T,
  }
  // x, y 是同一类型， 也可以写成不一样的类型
  struct Point<T, U> {
      x: T,
      y: U,
  }

  impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
  } 
  // 这里为什么显得如此怪异的原因， 在于 我们可以写出 impl Point<String> 来定定制 T=String 时候特有的方法定义。所以我们需要写成如此 impl<T> 来区分于 impl Point<String> , 声明 T 代表是一个place holder
  ```
**这里为什么显得如此怪异的原因， 在于 我们可以写出 impl Point<String> 来定定制 T=String 时候特有的方法定义。所以我们需要写成如此 impl<T> 来区分于 impl Point<String> , 声明 T 代表是一个place holder**
并不会牺牲性能，没有runtime的耗时， 在编译阶段， rust 会填充 placeholder, 来完成， 不同类型的定义。

### Trait: Defining Shared Behavior
 * impl 定义 及其 实现
 
  ```rust
    pub trait Summary {
        fn summarize(&self)-> String;
        fn speak(&self) -> {
            self.summarize();
            println!("speak");
        }
    }

    pub struct NewsArticle {
    }

    impl Summary for NewsArticle {
        fn summarize(&self) -> String {
            println!("---------");
        }
    }
  ```
  * Trait 类似于Interface， 共享 行为（函数） 定义，还可以 实现 类似 模板调用的方法。
  * Trait 当 Function 参数

  ```rust
    pub fn notify(item: impl Summary) {
        println!("---------");
    }
    // Trait Bound syntax
    pub fn notify<T: Summary>(item: T) {
          println!("---------");
    }
    // multiple Trait Bound
    pub fn notify<T: Summary + Display>(item: T) {
          println!("---------");
    }
    // use where
    pub fn some_function<T, U>(one: T, two: U) {
        where T: Display + Clone,
              U: Clone + Debug
        println!("---------");
    }
  ```

  * Trait 当做Function 的return type, 但是 存在一些限制： 主要有， 返回值不能是不同类型， 而只能是一个确定的类型 impl trait（例如{} 中 通过if else 返回一个完全不同类型，却实现了同样的Trait 的类型）
  * Trait with Generic 可以 约束 impl Generic 的 类型为实现了 Trait 的类型。

  ```rust
  impl<T: Display + PartialOrd> Point<T> {
      fn only_some(&self) {
      }// 只有实现了 Display & PartialOrd trait的 Point<_> 类型，才会有 only_some 方法
  }
  ```
 * Advanced Traits: Traits with placeholder
 
  ```rust
    pub trait Iterator {
      type Item;

       fn next(&mut self) -> Option<Self::Item>;
    }
    impl Iterator for Counter {
        type Item = u32;

        fn next(&mut self) -> Option<Self::Item> {
        }
    }
  ```
  为什么不适用这样的实现呢？

  ```rust
  pub trait Iterator<T> {
      fn next(&mut self) -> Option<T>;
  }
  ```
  原因在于 如果采用第二种实现， 我们需要 写成这样

  ```rust
  impl Iterator<String> for Counter {

  }
  impl Iterator<i32> for Counter {

  }
  ```
 这里面存在多种实现方式。 更重要的是，我们在调用next时候，需要显式的指定 .next::<Iterator<String>> 来 指导 rust使用哪个Iterator<T> for Counter 的代码实现。所以第一种更可取
但是确实存在 Generic 与 Trait 结合的例子：

```rust

trait Add<RHS=Self> {
    type Output;

    fn add(self, rhs: RHS) -> Self::Output;
}

// 常用的声明可以如下:
struct Point {
    x: i32,
    y: i32,
}

impl Add for Point {
    type Output = Point;

    fn add(self, other: Point) -> Point {
        Point {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}
// 然而我们依然可以这样，指定 RHS Generic参数， 来实现， Millimeters + Meters 的函数调用实现, 只不过，placeholder 并没有作为返回值，所有，可以直接+ 而不需要显示的，指定 + 之后的返回数值类型
struct Millimeters(u32);
struct Meters(u32);

impl Add<Meters> for Millimeters {
    type Output = Millimeters;

    fn add(self, other: Meters) -> Millimeters {
        Millimeters(self.0 + (other.0 * 1000))
    }
}
```

多个Trait 出现同样函数名字的情况：

```rust

trait Pilot {
    fn fly(&self);
}

trait Wizard {
    fn fly(&self);
}

//两个 Trait 拥有同样的函数名称，不同的函数实现。那如何在调用时候，决策函数调用实体呢？
struct Human;

impl Pilot for Human {
    fn fly(&self) {
        println!("This is your captain speaking.");
    }
}

impl Wizard for Human {
    fn fly(&self) {
        println!("Up!");
    }
}

impl Human {
    fn fly(&self) {
        println!("*waving arms furiously*");
    }
}
// 下面，person.fly 默认调用 Human 自己的实现， 如果需要 显式的调用 Pilot::fly 则需要， 如下格式
fn main() {
    let person = Human;
    person.fly();
    Pilot::fly(&person);
    Wizard::fly(&person);
    person.fly();
}
// 因为其为实例方法， 存在&self， 如果不存在呢？ 下面示例:

trait Animal {
    fn baby_name() -> String;
}

struct Dog;

impl Dog {
    fn baby_name() -> String {
        String::from("Spot")
    }
}

impl Animal for Dog {
    fn baby_name() -> String {
        String::from("puppy")
    }
}

fn main() {
    println!("A baby dog is called a {}", Dog::baby_name());// Ok
    println!("A baby dog is called a {}", Animal::baby_name()); // Error, 下面是正解
    println!("A baby dog is called a {}", <Dog as Animal>::baby_name());
}


```

SuperTriat： 超级 Trait， 依赖于一个Trait的实现， 示例如下：
```rust

use std::fmt;
// 声明语法如下： trait SuperTrait: Trait {}
trait OutlinePrint: fmt::Display {
    fn outline_print(&self) {
        let output = self.to_string();
        println!("output is --- {}", output);
    }
}
// 我们只需要为point 实现 Display， 即可 拥有 outline_print 方法
impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}
impl OutlinePrint for Point {}
```
NewType: 因为 impl Trait for Type, 中的type需要在本地的crate，而不是 引用库 中的Type。 所以 可以通过Newtype类来包装 Type，实现一些 Trait. 
这里面包含另外一些需要东西： 如何让 NewType， 伪装成Type？
实现 Deref Trait。

  ```rust
  use std::fmt;

  struct Wrapper(Vec<String>); // 新的type 类似于下边的
  struct Color(i32, i32, i32);
  struct Point(i32, i32, i32);

  impl fmt::Display for Wrapper {
      fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
          write!(f, "[{}]", self.0.join(", "))
      }
  }

  fn main() {
      let w = Wrapper(vec![String::from("hello"), String::from("world")]);
      println!("w = {}", w);
  }
  ```

### Generic 生命周期 syntax： 用于区分函数中 参数生命周期， 对比 参数、返回值 等 生命周期之间的关系。 确保 参数传递生命周期符合 函数声明. 生命周期 需要关联 参数与返回值，才会有效果，只有参数的生命周期没有用处

  ```rust
  fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
  }
  // error, rust并不能知道 函数返回值， 是x还是y， 无法检查生命周期

  fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
      if x.len() > y.len() {
          x
      } else {
          y
      }
  }
  // 要求 函数返回值，应该小于等于 参数， x y的生命周期, 所以下面的函数调用是可以pass的
  fn main() {
      let string1 = String::from("long string is long");

      {
          let string2 = String::from("xyz");
          let result = longest(string1.as_str(), string2.as_str());
          println!("The longest string is {}", result);
      }
  }

  // 而这个， 则是编译失败的，因为 返回值的生命周期 大于其中参数 y 的生命周期， 会导致 dangling refrence, 比如， result指向 y, 而y 在 内部的scope中已经销毁了
  fn main() {
      let string1 = String::from("long string is long");
      let result;
      {
          let string2 = String::from("xyz");
          result = longest(string1.as_str(), string2.as_str());
      }
      println!("The longest string is {}", result);
  }
  // 还可以这样， 总是 返回其中的一个值
  fn longest<'a>(x: &'a str, y: &str) -> &'a str {
      x
  }
  ```
  * Struct 的生命周期： struct 保持的refrence 的生命周期 与struct 生命周期关联。struct 不应该 长于 内部变量的refrence。
  ```rust
  struct ImportantExcerpt<'a> {
    part: &'a str,
  }

    fn main() {
        let novel = String::from("Call me Ishmael. Some years ago...");
        let first_sentence = novel.split('.')
            .next()
            .expect("Could not find a '.'");
        let i = ImportantExcerpt { part: first_sentence };
  }// 其中 i 的生命从周期不应该长于 novel
  // impl Struct Generic 方法时候的 声明语法， 同 impl Generic。 其中声明方法时候，需要不要 生命周期 声明，需要看，是否与struct field 、 返回值 相关
 impl<'a> ImportantExcerpt<'a> {
     fn announce_and_return_part(&self, announcement: &str) -> &str {
         println!("Attention please: {}", announcement);
         self.part
     }
 }
  ```
  Static lifetime， 静态生命周期，表明变量， 将贯穿于整个program, 将直接保存于， 代码的二进制中。



### Closures:
 *  /|x/| {}
 *  FnOnce: 获取参数的ownership
 *  FnMut： 获取参数的 mut 引用
 *  Fn： 获取参数的 非mut引用
 *  以上三种 为 Trait， 可以声明类型为 FN(i32) -> i32
 *  function as paramas： Function Pointer(fn a Type diff with Fn) ， fn 类型，实现了， Fn, FnMut, FnOnce 的实现， 即 impl Fn, FnMut, FnOnce for fn {....} 所以，可以传递 fn 到 接受 closures的 函数中。 还可以声明接受fn类型的 函数

 ```rust
  fn add_one(x: i32) -> i32 {
      x + 1
  }

  fn do_twice(f: fn(i32) -> i32, arg: i32) -> i32 {
      f(arg) + f(arg)
  }

  fn main() {
      let answer = do_twice(add_one, 5);

      println!("The answer is: {}", answer);
  }

  // 可以 传递参数fn 类型
  let list_of_numbers = vec![1, 2, 3];
  let list_of_strings: Vec<String> = list_of_numbers
      .iter()
      .map(ToString::to_string)
      .collect();
 ```


### macros:
#### rust tokens 分类：
```text
  Identifiers: foo, Bambous, self, we_can_dance, LaCaravane, …
  Integers: 42, 72u32, 0_______0, …
  Keywords: _, fn, self, match, yield, macro, …
  Lifetimes: 'a, 'b, 'a_rare_long_lifetime_name, …
  Strings: "", "Leicester", r##"venezuelan beaver"##, …
  Symbols: [, :, ::, ->, @, <-, …
```
* c语言 需要特殊的 “macro层面” 即 预处理，而rust  macro处理时机 在 编译器 将 token 转换为  AST 之后进行（Abstract Syntax Tree ）
* 编译过程 token -> token tree  -> AST  基本所有的 token都是叶子节点 ，只有 （...） [...] {...} 包含一组节点，是 树节点。

```text
a + b + (c + d[0]) + e

«a» «+» «b» «+» «(   )» «+» «e»
          ╭────────┴──────────╮
           «c» «+» «d» «[   ]»
                        ╭─┴─╮
                        «0»



              ┌─────────┐
              │ BinOp   │
              │ op: Add │
            ┌╴│ lhs: ◌  │
┌─────────┐ │ │ rhs: ◌  │╶┐ ┌─────────┐
│ Var     │╶┘ └─────────┘ └╴│ BinOp   │
│ name: a │                 │ op: Add │
└─────────┘               ┌╴│ lhs: ◌  │
              ┌─────────┐ │ │ rhs: ◌  │╶┐ ┌─────────┐
              │ Var     │╶┘ └─────────┘ └╴│ BinOp   │
              │ name: b │                 │ op: Add │
              └─────────┘               ┌╴│ lhs: ◌  │
                            ┌─────────┐ │ │ rhs: ◌  │╶┐ ┌─────────┐
                            │ BinOp   │╶┘ └─────────┘ └╴│ Var     │
                            │ op: Add │                 │ name: e │
                          ┌╴│ lhs: ◌  │                 └─────────┘
              ┌─────────┐ │ │ rhs: ◌  │╶┐ ┌─────────┐
              │ Var     │╶┘ └─────────┘ └╴│ Index   │
              │ name: c │               ┌╴│ arr: ◌  │
              └─────────┘   ┌─────────┐ │ │ ind: ◌  │╶┐ ┌─────────┐
                            │ Var     │╶┘ └─────────┘ └╴│ LitInt  │
                            │ name: d │                 │ val: 0  │
                            └─────────┘                 └─────────┘


```


* macro rule 的语法规则： https://danielkeep.github.io/tlborm/book/mbe-macro-rules.html 这其中包含有：


```text
匹配 语法如下：



macro_rules! four {
(pattern) => {

};
(pattern1) => {

};
}



捕获： $name:kind

kind类型如下：


    item: an item, like a function, struct, module, etc.
    block: a block (i.e. a block of statements and/or an expression, surrounded by braces)
    stmt: a statement
    pat: a pattern
    expr: an expression
    ty: a type
    ident: an identifier
    path: a path (e.g. foo, ::std::mem::replace, transmute::<_, int>, …)
    meta: a meta item; the things that go inside #[...] and #![...] attributes
    tt: a single token tree

如下：

macro_rules! times_five {
    ($e:expr) => {5 * $e};
}


重复：语法 $(捕获) sep rep.

seq 为 可选的split token，一般可选 , . ;
rep 为 重复控制，可选有 + *



```

