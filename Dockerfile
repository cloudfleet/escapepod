FROM library/ubuntu

RUN BUILD_DEPS=" \
    git \
    make \
    " \
 && DEBIAN_FRONTEND="noninteractive" \
 && apt-get -q update && apt-get -y upgrade && apt-get -y install \
    $BUILD_DEPS \
    btrfs-tools \
    openssl \
    pwgen \
 && apt-get -y purge $BUILD_DEPS \
 && apt-get -y autoremove \
 && apt-get -q clean \
 && rm -rf /var/lib/apt/lists/*

# COPY scripts /opt/escapepod 
# COPY config/crontab /etc/crontab
