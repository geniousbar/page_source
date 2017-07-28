---
title: thor option parse 的代替者
date: 2017-07-21
tags: ruby, gem
---
 thor
--------

> option parse 的代替者，可以在shell中调用脚本，更方便的传递参数，转换参数类型，　设定默认值，进行必要参数校验等.


### 简单的示例：

```ruby
class Test < Thor
  desc "example FILE", "an example task"
  method_option :delete, :aliases => "-d", :desc => "Delete the file after parsing it"
  def example(file)
    puts "You supplied the file: #{file}"
    delete_file = options[:delete]
    if delete_file
      puts "You specified that you would like to delete #{file}"
    else
      puts "You do not want to delete #{file}"
    end
  end
end

thor test:example 'test.rb' -d

```
#### method_options
    aliases, type, desc, 描述参数的类型，简写形式
    method_options :value, aliases: 'v', default: 1, type: :numeric

#### invocations

    ```ruby
class Counter < Thor
  desc "one", "Prints 1 2 3"
  def one
    puts 1
    invoke :two
    invoke :three
  end

  desc "two", "Prints 2 3"
  def two
    puts 2
    invoke :three
  end

  desc "three", "Prints 3"
  def three
    puts 3
  end
end
    ```
#### Executable

```ruby
#!/usr/bin/env ruby
require "rubygems" # ruby1.9 doesn't "require" it though
require "thor"

class MyThorCommand < Thor
  desc "foo", "Prints foo"
  def foo
    puts "foo"
  end
end

MyThorCommand.start
```


> 最终要的是rails 中的generator使用thor创建，拷贝模板，　参数解析等
