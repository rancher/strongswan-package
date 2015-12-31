FROM ubuntu:15.10
RUN apt-get update && \
    apt-get build-dep -y strongswan
RUN apt-get install -y wget curl iproute2

ARG VERSION=5.3.5
RUN wget https://download.strongswan.org/strongswan-${VERSION}.tar.bz2
RUN tar xvf strongswan-${VERSION}.tar.bz2
WORKDIR strongswan-${VERSION}
RUN ./configure \
    --enable-swanctl \
	--enable-gcm \
    --enable-aesni \
    --enable-vici \
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
