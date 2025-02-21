FROM docker.io/library/debian:sid-slim 

# RUN apt-get update && apt-get install apt-transport-https ca-certificates -y

RUN echo "Types: deb\n\
URIs: http://mirrors.tuna.tsinghua.edu.cn/debian\n\
Suites: sid\n\
Components: main contrib non-free non-free-firmware\n\
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg" > /etc/apt/sources.list.d/debian.sources

RUN apt-get update && apt-get install vim gcc-13-loongarch64-linux-gnu build-essential flex bison bc libssl-dev bsdextrautils libncurses-dev uuid-dev libgnutls28-dev kmod git python3 python3-setuptools swig python3-dev -y

COPY mkimage /usr/bin/

# VOLUME ["/build"]
