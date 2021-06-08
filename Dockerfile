FROM debian:buster-slim as builder
# ENV DEF_ODYSSEY_CONF /etc/odyssey/odyssey.conf

WORKDIR /tmp/

RUN set -ex \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        libpqxx-dev \
        postgresql-server-dev-all \
        libssl-dev \
    && git clone git://github.com/yandex/odyssey.git \
    && cd odyssey \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make

FROM debian:buster-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libssl-dev \
        curl \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY --from=builder /tmp/odyssey/build/sources/odyssey /usr/local/bin/

RUN mkdir /etc/odyssey

ADD ./conf/odyssey.conf ./conf/routing.conf /etc/odyssey/

COPY entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh
EXPOSE 6432


# Exposing temporarely
VOLUME /etc/odyssey

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/etc/odyssey/odyssey.conf"]
