FROM golang:1.11-alpine

COPY .go /go
COPY . /go/src/k8s.io/git-sync
COPY ./bin/linux_amd64 /go/bin
COPY ./bin/linux_amd64 /go/bin/linux_amd64
COPY .go/std/linux_amd64 /usr/local/go/pkg/linux_amd64_static
COPY .go/cache /.cache

WORKDIR /go/src/k8s.io/git-sync

RUN [ "/bin/sh", "-c", "ARCH=", "OS=", "VERSION=", "PKG=", "./build/build.sh"]

FROM alpine:3.8

LABEL maintainer="Tim Hockin <thockin@google.com>"

RUN apk update --no-cache && apk add \
    ca-certificates \
    coreutils \
    git \
    openssh-client
ENV HOME /tmp
USER nobody:nobody
COPY --from=0 /go/src/k8s.io/git-sync/bin/linux_amd64/git-sync /git-sync
ENTRYPOINT [ "/git-sync" ]