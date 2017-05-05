FROM library/alpine

RUN BUILD_DEPS=" \
    " \
 && apk -U upgrade && apk add \
    $BUILD_DEPS \
    btrfs-progs \
    openssl \
    pwgen \
    util-linux \
    jq \
 && apk del $BUILD_DEPS \
 && rm -rf /tmp/* /var/cache/apk/*

COPY escapepod /escapepod
WORKDIR /escapepod
