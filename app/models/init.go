package models

import (
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
	_ "github.com/mattn/go-sqlite3"
	"os"
	"webcron/app/libs"
)

func Init() {
	// 用户名:密码@tcp(数据库地址:端口)/数据库名
	dsn := os.Getenv("DB_URL")
	if dsn == "" {
		dsn = beego.AppConfig.String("db.url")
	}

	// 注册数据库, ORM必须注册一个别名为 default 的数据库，作为默认使用
	if dsn != "" {
		orm.RegisterDataBase("default", "mysql", dsn+"?charset=utf8")
	} else {
		sqliteUrl := os.Getenv("SQLITE_URL")
		if sqliteUrl == "" {
			sqliteUrl = "./webcorn.db"
		}
		orm.RegisterDataBase("default", "sqlite3", sqliteUrl)
	}

	// 注册模型
	orm.RegisterModel(new(User), new(Task), new(TaskGroup), new(TaskLog))

	// 自动创建表 参数二为是否开启创建表   参数三是否控制台打印数据
	err := orm.RunSyncdb("default", true, true)
	if err != nil {
		fmt.Printf("%s", err)
	}

	if beego.AppConfig.String("runmode") == "dev" {
		orm.Debug = true
	}

	// 注册管理员账号
	initAdminUser()
}

func TableName(name string) string {
	prefix := os.Getenv("DB_PREFIX")
	if prefix == "" {
		prefix = beego.AppConfig.String("db.prefix")
	}
	return prefix + name
}

func initAdminUser() {
	user, err := UserGetById(1)
	if err != nil {
		user = new(User)
		user.Id = 1
		user.Status = 0
	}

	user.UserName = os.Getenv("ADMIN_USER")
	if user.UserName == "" {
		user.UserName = "admin"
	}
	pwd := os.Getenv("ADMIN_PWD")
	if pwd == "" {
		pwd = "admin123"
	}
	user.Password = libs.Md5([]byte(pwd + user.Salt))
	user.Email = os.Getenv("ADMIN_EMAIL")

	line, err := UserUpdate(user)
	if line == 0 {
		UserAdd(user)
	}
}
