FROM alpine:latest
USER root

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        git \
        autoconf \
        automake \
        build-base \
        c-ares-dev \
        libev-dev \
        libtool \
        libsodium-dev \
        linux-headers \
        mbedtls-dev \
        pcre-dev \
    && cd /tmp \
    && git clone --recursive "https://github.com/shadowsocks/shadowsocks-libev" \
    && cd shadowsocks-libev \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-documentation \
    && make install -j $(nproc) \
    && apk del --purge .build-deps \
    && apk add --no-cache \
        curl \
        rng-tools \
        $(scanelf --needed --nobanner /usr/bin/ss-* \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u) \
    && rm -rf /tmp/*

RUN apk add --no-cache tini gettext privoxy bash
ENV SS_SERVER=${SS_SERVER}
ENV SS_PORT=${SS_PORT}
ENV SS_METHOD=${SS_METHOD}
ENV SS_PASSWORD=${SS_PASSWORD}
RUN mkdir /app
WORKDIR /app
RUN ls
RUN chown nobody:nogroup /app
WORKDIR /app/privoxy
COPY ./privoxy.conf ./config
WORKDIR /app
COPY ./shadowsocks.json.template .
COPY ./docker-entrypoint.sh .
CMD ["/sbin/tini", "--", "/app/docker-entrypoint.sh"]
