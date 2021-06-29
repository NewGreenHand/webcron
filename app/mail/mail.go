package mail

import (
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils"
	"time"
)

var (
	sendCh chan *utils.Email
	config string
)

func init() {
	// 同时发送人数的数量
	queueSize, _ := beego.AppConfig.Int("mail.queue_size")
	// email 服务地址
	host := beego.AppConfig.String("mail.host")
	// email 服务端口
	port, _ := beego.AppConfig.Int("mail.port")
	// email 服务授权用户
	username := beego.AppConfig.String("mail.user")
	// email 服务授权用户密码
	password := beego.AppConfig.String("mail.password")
	// email 邮件发送人
	from := beego.AppConfig.String("mail.from")

	config = fmt.Sprintf(`{"username":"%s","password":"%s","host":"%s","port":%d,"from":"%s"}`, username, password, host, port, from)

	sendCh = make(chan *utils.Email, queueSize)

	go func() {
		for {
			select {
			case m, ok := <-sendCh:
				if !ok {
					return
				}
				if err := m.Send(); err != nil {
					beego.Error("SendMail:", err.Error())
				}
			}
		}
	}()
}

func SendMail(address, name, subject, content string, cc []string) bool {
	mail := utils.NewEMail(config)
	mail.To = []string{address}
	mail.Subject = subject
	mail.HTML = content
	if len(cc) > 0 {
		mail.Cc = cc
	}

	select {
	case sendCh <- mail:
		return true
	case <-time.After(time.Second * 3):
		return false
	}
}
