FROM node:lts-alpine3.13

# 指定运行时环境变量
ENV GIN_MODE=release \
    PORT=8000

#RUN set -ex \
#    && apk update \
#    && apk upgrade \
#    && apk add --no-cache bash tzdata git moreutils curl jq openssh-client \
#    && rm -rf /var/cache/apk/* \
#    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
#    && echo "Asia/Shanghai" > /etc/timezone \
#    && mkdir -p /root/.ssh \
#    && npm config set registry https://registry.npm.taobao.org \
#    && cp ./docker_entrypoint.sh /usr/local/bin \
#    && chmod +x /usr/local/bin/docker_entrypoint.sh

WORKDIR /app

COPY docker_entrypoint.sh /usr/local/bin
COPY webcron /app
COPY views /app
COPY static /app
COPY conf /app

RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --no-cache sqlite \
    && chmod +x /usr/local/bin/docker_entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["docker_entrypoint.sh"]
