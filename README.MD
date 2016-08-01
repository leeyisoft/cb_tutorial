# 开始

Download the Chicago Boss 0.7.0 source code from here: [chicagoboss](http://www.chicagoboss.org/);

从这儿下载“芝加哥老板”0.7.0版本的源码：[chicagoboss](http://www.chicagoboss.org/);

The first task is to open the archive, compile the code, and create a new project.

第一个任务是打开文档，编译代码，并创建一个新项目。


```shell
tar xzf ChicagoBoss-0.7.0.tar.gz
cd ChicagoBoss-0.7.0
make
make app PROJECT=cb_tutorial
```

cb_tutorial将是新项目的名称；进入新项目目录。

```shell
cd ../cb_tutorial

ls -l

-rwxrwxrwx@  1 leeyi  staff   1.3K Jul 22 11:45 Makefile
-rw-r--r--   1 leeyi  staff   1.3K Jul 29 12:40 README.MD
-rwxrwxrwx@  1 leeyi  staff    13K Jul 20 09:44 boss.config
drwxrwxrwx  41 leeyi  staff   1.4K Jul 20 09:54 deps
drwxrwxrwx   9 leeyi  staff   306B Jul 24 19:04 ebin
drwxrwxrwx   2 leeyi  staff    68B Jul 20 09:44 include
-rwxrwxrwx   1 leeyi  staff   132B Jul 20 09:44 init-dev.sh
-rwxrwxrwx@  1 leeyi  staff   1.9K Jul 20 09:44 init.sh
drwxrwxrwx   7 leeyi  staff   238B Jul 29 12:00 log
drwxrwxrwx   9 leeyi  staff   306B Jul 20 09:45 priv
-rwxrwxrwx   1 leeyi  staff   198K Jul 20 09:44 rebar
-rwxrwxrwx   1 leeyi  staff    77B Jul 20 09:44 rebar.cmd
-rwxrwxrwx   1 leeyi  staff   261B Jul 20 09:44 rebar.config
drwxrwxrwx  11 leeyi  staff   374B Jul 24 19:04 src
-rwxrwxrwx   1 leeyi  staff   182B Jul 20 09:44 start-server.bat
```

启动服务：

```shell
./rebar get-deps compile # 不成功的话 修改 rebar.config:2 的tag 为 v0.8.19
./init-dev.sh
```

# 目录结构

* 结构

```shell
todo
```

* 一个CB应用程序可能有几个部分：

    * 网络控制器，并给出了一个HTTP请求信息并决定如何处理它
    * 网页视图，它提供了一个控制器返回的数据
    * 模型，它提供了一个数据库的抽象层（如果有的话）
    * 电子邮件控制器和视图
    * 初始化脚本
    * 测试脚本
    * 一个路由配置文件

* CB服务器启动的许多服务可以被属于服务器的所有应用程序应用到：

    * 一个URL路由器(BossRouter)
    * 一个会话存储层(BossSession)
    * 一个数据库连接和缓存层(BossDB和BossCache)
    * 一个消息队列服务（BossMQ）
    * 一个模型事件系统(BossNews)
    * 一个电子邮件服务器(BossMail)
