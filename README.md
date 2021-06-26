# webcron
------------

一个定时任务管理器，基于Go语言和beego框架开发。用于统一管理项目中的定时任务，提供可视化配置界面、执行日志记录、邮件通知等功能，无需依赖*unix下的crontab服务。

## 项目背景

开发此项目是为了解决本人所在公司的PHP项目中定时任务繁多，使用crontab不好管理的问题。我所在项目的定时任务也是PHP编写的，属于整个项目的一部分，我希望能有一个系统可以统一配置这些定时任务，并且可以查看每次任务的执行情况，任务执行完成或失败能够自动邮件提醒开发人员，因此做了这个项目。

## 功能特点

* 统一管理多种定时任务。
* 秒级定时器，使用crontab的时间表达式。
* 可随时暂停任务。
* 记录每次任务的执行结果。
* 执行结果邮件通知。

## 界面截图

![webcron](https://raw.githubusercontent.com/lisijie/webcron/master/screenshot.png)


## 安装说明

### 本地安装
系统需要安装Go和MySQL。

获取源码

	$ git clone https://github.com/NewGreenHand/webcron.git

项目默认支持 sqlite3, 如需更换成 mysql 则可以修改 conf/app.conf 下的 db.url

    db.url = 用户名:密码@tcp(数据库地址:端口)/数据库名

运行
	
	$ ./webcron
	或
	$ nohup ./webcron 2>&1 > error.log &
	设为后台运行

### Docker 安装
快速开始
``` 
docker run 
    --name webcron \
    -p 8000:8000 \
    -v data:/app/data \
    fillpit/webcron
```

|  环境变量   | 含义  | 举例  |
|  ----  | ----  | --- |
| DB_URL  | mysql 连接地址 | 用户名:密码@tcp(数据库地址:端口)/数据库名 |
| DB_PREFIX  | 表前缀 | t_  |
|  ADMIN_USER   | 管理员名称  | 默认 admin  |
|  ADMIN_PWD   | 管理员密码  | 默认 admin123  |
|  ADMIN_EMAIL   | 管理员邮箱  | xx@xx.com  |
|  SQLITE_URL   | sqlite3 连接地址  | ./webcron.db (如果配置了 DB_URL 者不用配置这一项， 指定sqlite 的库文件地址， 如果文件不存在则自动生成) |


访问： 

http://localhost:8000

帐号：admin
密码：admin888