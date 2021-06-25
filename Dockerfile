# 打包依赖阶段使用golang作为基础镜像
FROM golang:1.16.5-alpine3.13 as builder

# 启用go module
# github actions 编译不设置代理 GOPROXY=https://goproxy.cn,direct \
ENV GO111MODULE=on \
    CGO_CFLAGS="-g -O2 -Wno-return-local-addr"

WORKDIR /app

COPY . .

# 指定OS等，并go build
RUN set -ex \
        && apk update \
        && apk upgrade \
        && apk add gcc libc-dev \
        && GOOS=linux GOARCH=amd64 go build .

# 由于我不止依赖二进制文件，还依赖views文件夹下的html文件还有assets文件夹下的一些静态文件
# 所以我将这些文件放到了publish文件夹 /go/bin/webcron
RUN mkdir publish && cp webcron publish && \
    cp -r views publish && cp -r static publish && cp -r conf publish

# 运行阶段指定scratch作为基础镜像
FROM alpine

WORKDIR /app

ARG TZ="Asia/Shanghai"

# 将上一个阶段publish文件夹下的所有文件复制进来
COPY --from=builder /app/publish .

RUN set -ex \
       && apk update \
       && apk upgrade \
       && apk add --no-cache sqlite bash tzdata \
       && ln -s /app/webcron /usr/bin/webcron \
       && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
       && echo ${TZ} > /etc/timezone \
       && rm -rf /var/cache/apk/*

# 指定运行时环境变量
ENV GIN_MODE=release \
    PORT=8000   \
    TZ=${TZ}

EXPOSE 8000/tcp

VOLUME /app

ENTRYPOINT ["webcron"]
