FROM debian:jessie

ENV TOR_VERSION=7.0.10 \
    TOR_FINGERPRINT=0x4E2C6E8793298290

RUN mkdir ~/.gnupg \
    && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys ${TOR_FINGERPRINT} \
    && gpg --fingerprint ${TOR_FINGERPRINT} | grep -q "Key fingerprint = EF6E 286D DA85 EA2A 4BA7  DE68 4E2C 6E87 9329 8290" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
         apt-get install -y iceweasel xz-utils curl wget xauth \
    && mkdir -p /usr/lib/tor-browser \
    && wget -O /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz  https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz \
    && wget -O /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc \
    && gpg /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc \
    && tar -Jvxf /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz --strip=1 -C /usr/lib/tor-browser \
    && ln -sf /usr/lib/tor-browser/Browser/start-tor-browser /usr/bin/tor-browser \
    && apt-get remove -qy --auto-remove curl xz-utils \
    && apt-get remove -qy iceweasel \
    && apt-get clean \
    && rm -rf /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz \
    && rm -rf ~/.gnupg \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/tor-browser"]
