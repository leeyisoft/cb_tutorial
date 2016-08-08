# 系统要求

* erlang 18.3

* ChicagoBoss branch master (目前的 commit id 是 6a455b98b7e1b08c1119e96d36b23155d223722d（Commits on Jun 27, 2016）)

* yaws 2.0

* mysql 5.6

# 开始

Download the Chicago Boss 0.7.0 source code from here: [chicagoboss](http://www.chicagoboss.org/);

从这儿下载“芝加哥老板”0.7.0版本的源码：[chicagoboss](http://www.chicagoboss.org/);

The first task is to open the archive, compile the code, and create a new project.

第一个任务是打开文档，编译代码，并创建一个新项目。


```shell
clone https://github.com/ChicagoBoss/ChicagoBoss.git ChicagoBoss
cd ChicagoBoss
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
./rebar get-deps compile
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

# 后端配置

设置文件 boss.config，第 330 行，如果设置为
```config
{backend, yaws},
```
需要修改过文件（deps/boss/rebar.config），把第36行前面的注释去掉

```config
%{yaws,                  ".*",   {git, "https://github.com/klacke/yaws.git",               {tag, "yaws-2.0"}}},

// 修改为

{yaws,                  ".*",   {git, "https://github.com/klacke/yaws.git",               {tag, "yaws-2.0"}}},
```

get-deps 期间可能有失败，获取那个依赖失败，直接用 rm -rf deps/[deps-name] ，之后再 rebar get-deps ；

如果36行没有yaws，主要修改 rebar.config 第2行  {branch, "master"} ，之后，执行下列shell命令：

```shell
./rebar delete-deps
// 如果 deps还有文件，就直接
rm -rf deps

// 不能注释 mochiweb 和 cowboy 和 yaws
./rebar clean get-deps compile
```

# 数据库设置
修改配置文件 boss.config “Database”一节：
```config
{db_host, "localhost"},
{db_port, 3306},
{db_adapter, mysql},
{db_username, "admin"},
{db_password, "123456"},
{db_database, "cb_tutorial"},
```

```sql
CREATE SCHEMA `cb_tutorial` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE `cb_tutorial`.`greetings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `greeting_text` VARCHAR(140) NULL,
  `create_time` BIGINT(16) NULL DEFAULT 0 COMMENT '公历 0 年开始到以给定的日期和时间(当前的世界标准时间（UTC）)为结束间的秒数',
  PRIMARY KEY (`id`)
) PACK_KEYS = Default;

CREATE TABLE `cb_tutorial`.`chats` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `channel` VARCHAR(45) NOT NULL DEFAULT 'chats' COMMENT '聊天频道',
  `nickname` VARCHAR(45) NOT NULL COMMENT '聊天用户昵称',
  `text` VARCHAR(140) NULL COMMENT '聊天内容',
  `create_time` BIGINT(16) NULL DEFAULT 0 COMMENT '公历 0 年开始到以给定的日期和时间(当前的世界标准时间（UTC）)为结束间的秒数',
  PRIMARY KEY (`id`)
) PACK_KEYS = Default, COLLATE = utf8_unicode_ci, ENGINE = MyISAM , COMMENT = '聊天室记录' ;

CREATE TABLE `cb_tutorial`.`members` (
  `id` INT NOT NULL,
  `uuid` VARCHAR(36) NOT NULL COMMENT '用户全局唯一身份标示，标准uuid，36位长度',
  `nickname` VARCHAR(40) DEFAULT NULL COMMENT '用户昵称',
  `email` VARCHAR(80) DEFAULT NULL,
  `mobile` VARCHAR(16) DEFAULT NULL,
  `password` VARCHAR(40) NOT NULL COMMENT '登录密码',
  `sold` VARCHAR(40) CHARACTER SET 'utf8' NOT NULL,
  `last_login_time` BIGINT(16) DEFAULT 0,
  `last_login_ip` VARCHAR(40) NULL,
  `reg_time` BIGINT(16) NOT NULL,
  `reg_ip` VARCHAR(40) NULL,
  `login_times` INT NULL DEFAULT 0 COMMENT '登录次数',
  `signature` VARCHAR(255) NULL COMMENT '个性签名',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nickname_UNIQUE` (`nickname` ASC),
  UNIQUE INDEX `mobile_UNIQUE` (`mobile` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `uuid_UNIQUE` (`uuid` ASC))
PACK_KEYS = Default
ROW_FORMAT = Default;

INSERT INTO `cb_tutorial`.`members` (`id`, `uuid`, `nickname`, `password`, `sold`, `last_login_time`, `reg_time`, `login_times`, `signature`) VALUES ('1', 'e949f8a-5d42-11e6-9e4e-a45e60bb8fad', 'leeyi', '123456', 'e949f8a-5d42-11e6-9e4e-a45e60bb8fad', '0', '0', '0', 'hello');



```
