FROM alpine:latest
RUN apk --update add ca-certificates \
                     mailcap \
                     curl

HEALTHCHECK --start-period=2s --interval=5s --timeout=3s \
  CMD curl -f http://localhost:8000/health || exit 1

VOLUME /webcron

WORKDIR /webcron

EXPOSE 8000

COPY webcron /webcron

ENTRYPOINT [ "/webcron" ]
