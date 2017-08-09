---
title: Phoenix framework 1.3 context
date: 2017-08-07
tags: phoenix, elixir, desigin
---

Design
--------

### 思考设计

  context 是专门用来 组织、暴露 相关的功能的module。比如我们每次调用Elixir标准库 Logger.info, 其实是在接触不同的context， 在内部， Elixir Logger是由 诸如 Logger.Config. Logger.Backends 的module组成的， 但是我们从来不会直接跟这些module交互， 我们使用Logger context， 因为他组织并且暴露接口。
  Phoenix 组织目录类似于其他的Elixir Project， 我们拆分代码到context中， 一个context 将会组织相关的功能代码， 比如post，comment， 经常封装诸如 验证、数据存取的功能。应用context, 我们拆分系统到 容易管理、互相独立的 组成部分中。

### 建立Account context
  * user 是 系统中广泛接触的，以至于需要思考设计 接口。 我们的目标是设计一个 Account API 处理创建、更新、删除user、包括用户验证。 我们以基本的功能开始，然后逐步添加功能。
  * Phoenix 包含了 phx.gen.html, phx.gen.json, phoenix.gen.context 脚手架来支持 拆分 应用功能到 contex中， 这些脚手架有力的推动了在 应用变大 的时候，朝着正确的方向上前进。
  * 为了使用 context 脚手架， 我们需要想出一个module名字，来组织相关的功能。在Ecto Guide中，我们使用Changesets 和Repo 来验证，存储user， 但是当应用变大的时候，我们不会使用这些在应用中。事实上，我们从来不会想， user应该存在于应用的什么地方，退回重新思考一下 应用中个个组成部分的不同。 在用户 需要账户登录，验证，和注册的情况下，Account context 是一个最好的地方来存放相关的功能。

  ```elixir
    mix phx.gen.html Accounts User user users name:string username:string:unique
    resources "/users", UserController
    mix ecto.migrate

    scopes "/" HelloWeb do
      pipe_through :browser

      get "/", PageController, :index
      resources "/users", UserController
    end
  ```
  * Phoenix 生成的web相关的文件， 在 lib/hello_web/中， context文件在 lib/hello/accounts 中， 注意 这个区别， 我们使用Accounts module来管理account相关的功能， Accounts.User struct 是Ecto 来转换、验证的user的模型，

### starting with Generators
  * phx.gen.html  脚手架 生成了一个开箱能用的 创建，更新，删除用户。离真正的app很远。但是脚手架 是第一个也是最重要的 开始真正构建真是的功能的 学习工具和开始的地方。 脚手架不能解决所有问题，但是依然可以教你朝着一个正确的方向 来思考设计你的应用 。

  ``` elixir
  defmodule HelloWeb.UserController do
    use HelloWeb, :controller
    alias Hello.Accounts

    def index(conn, _params) do
      users = Accounts.list_users()
      render(conn, "index.html", users: users)
    end

    def new(conn, _params) do
      changeset = Accounts.change_user(%Hello.Accounts.User{})
      render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"user" => user_params}) do
      case Accounts.create_user(user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "user create success")
          |> redirect(to: user_path(conn, :show, user))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end
  ```
  * 我们注意的是， Controller如何调用Accounts context，我们可以看到index action，通过Accounts.list_users获取一系列用户，通过Accounts.create_user调用 实现创建用户，我们并不知道 Accounts，创建、获取的实现方法，然而这才是重要的， Phoenix Controller， 就是web interface， 她并不关系 关于如何获取用户， 创建的
