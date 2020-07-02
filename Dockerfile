FROM alpine:3.12.0

LABEL maintainer="wolfgang.keller@wobilix.de"

WORKDIR /

RUN apk add --no-cache --virtual .build-deps git gcc autoconf automake flex bison libtool pkgconf make libxslt-dev musl-dev linux-headers python3-dev py3-pip && \
    apk add --no-cache libxslt py3-lxml py3-requests bash && \
    pip install --no-cache-dir fritzcollectd && \
    git clone https://github.com/collectd/collectd.git collectd && \
    cd collectd && \
    ./build.sh && \
    ./configure --prefix="/usr" --sysconfdir="/etc/collectd" && \
    make  && \
    make install && \
    cd .. && \
    rm -rf collectd && \
    apk del --no-cache .build-deps && \
    rm -rf /var/cache/apk/*

VOLUME ["/etc/collectd"]
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/collectd", "-f"]

