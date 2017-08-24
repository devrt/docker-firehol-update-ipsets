FROM alpine

MAINTAINER Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

RUN apk add --no-cache tini bash ipset iproute2 curl unzip grep gawk

ENV IPRANGE_VERSION 1.0.3

RUN apk add --no-cache --virtual .iprange_builddep autoconf automake make gcc musl-dev && \
    curl -L https://github.com/firehol/iprange/releases/download/v$IPRANGE_VERSION/iprange-$IPRANGE_VERSION.tar.gz | tar zvx -C /tmp && \
    cd /tmp/iprange-$IPRANGE_VERSION && \
    ./configure --prefix= --disable-man && \
    make && \
    make install && \
    cd && \
    rm -rf /tmp/iprange-$IPRANGE_VERSION && \
    apk del .iprange_builddep

ENV FIREHOL_VERSION 3.1.3

RUN apk add --no-cache --virtual .firehol_builddep autoconf automake make && \
    curl -L https://github.com/firehol/firehol/releases/download/v$FIREHOL_VERSION/firehol-$FIREHOL_VERSION.tar.gz /tmp/firehol.tar.gz | tar zvx -C /tmp && \
    cd /tmp/firehol-$FIREHOL_VERSION && \
    ./autogen.sh && \
    ./configure --prefix= --disable-doc --disable-man && \
    make && \
    make install && \
    cp contrib/ipset-apply.sh /bin/ipset-apply && \
    cd && \
    rm -rf /tmp/firehol-$FIREHOL_VERSION && \
    apk del .firehol_builddep

ADD enable-recur /bin/enable-recur
ADD update-ipsets-periodic /bin/update-ipsets-periodic

RUN update-ipsets -s
VOLUME /etc/firehol/ipsets

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/bin/update-ipsets-periodic"]
