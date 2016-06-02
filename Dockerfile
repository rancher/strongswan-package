FROM ubuntu:14.04
RUN apt-get update && apt-get install -y build-essential wget curl iproute2 && \
    apt-get build-dep -y strongswan

ARG VERSION=v5.4.0-rancher-2
RUN wget https://github.com/rancher/strongswan/archive/${VERSION}.tar.gz
RUN mkdir -p strongswan && \
    tar xvf ${VERSION}.tar.gz -C strongswan --strip-components=1
WORKDIR strongswan
RUN ./autogen.sh && \
    ./configure \
	--enable-gcm \
    --enable-aesni \
	&& \
    make -j$(nproc) && \
    make install
RUN cd /usr/local && \
    mv libexec/ipsec/charon sbin && \
    rm -rf share bin/* sbin/ipsec libexec && \
    find . -name "*.la" -exec rm -v {} \; && \
    find . -name "*.a"  -exec rm -v {} \; && \
    find . -name "*.so" -exec strip --strip-debug {} \; && \
    strip --strip-debug sbin/*
RUN tar cvzf strongswan-${VERSION}.tar.gz $(find /usr/local \! -type d) && \
    ls -lah strongswan-${VERSION}.tar.gz
