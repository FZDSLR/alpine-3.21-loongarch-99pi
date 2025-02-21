FROM ghcr.io/fzdslr/alpine:3.21

RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories && apk add alpine-sdk

WORKDIR /build
