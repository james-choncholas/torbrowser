FROM debian:jessie

ENV TOR_VERSION=7.0.11 \
    TOR_FINGERPRINT=0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290 \
    KBP=500

RUN echo "Installing keys" \
    && mkdir ~/.gnupg \
    && gpg --keyserver keys.gnupg.net --recv-keys ${TOR_FINGERPRINT}

RUN echo "Installing dependancies" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y tor \
      xz-utils curl wget xauth file \
      libasound2 libglib2.0 libgtk2.0-0 libdbus-glib-1-2 libxt6 libexif12 \
      libgl1-mesa-glx libgl1-mesa-dri libstdc++6 

RUN echo "Installing tor" \
    && wget -O /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz  https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz \
    && wget -O /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc \
    && gpg --verify /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz \
    && mkdir -p /usr/lib/tor-browser \
    && tar -Jvxf /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz --strip=1 -C /usr/lib/tor-browser \
    && ln -sf /usr/lib/tor-browser/Browser/start-tor-browser /usr/bin/tor-browser

RUN echo "Removing old junk" \
    && rm -rf /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz \
    && rm -rf /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc \
    && rm -rf ~/.gnupg

RUN echo "Configuring tor" && \
	export KBS=500 && \
    mkdir -p /etc/tor/ && \
    echo "ORPort 443" >> /etc/tor/torrc && \
    echo "ExitPolicy reject *:*" >> /etc/tor/torrc && \
    echo "RelayBandwidthRate ${KBS} KB" >> /etc/tor/torrc && \
    echo "RelayBandwidthBurst $(( KBS * 2 )) KB" >> /etc/tor/torrc && \
    echo "CookieAuthentication 1" >> /etc/tor/torrc
#    echo "CookieAuthFileGroupReadable 1" >>/etc/tor/torrc && \
#    echo "CookieAuthFile /etc/tor/run/control.authcookie" >>/etc/tor/torrc && \
#    echo "DataDirectory /var/lib/tor" >>/etc/tor/torrc && \
#    echo "RunAsDaemon 0" >>/etc/tor/torrc && \
#    echo "User tor" >>/etc/tor/torrc && \
#    echo "AutomapHostsOnResolve 1" >>/etc/tor/torrc && \
#    echo "VirtualAddrNetworkIPv4 10.192.0.0/10" >>/etc/tor/torrc && \
#    echo "DNSPort 5353" >>/etc/tor/torrc && \
#    echo "SocksPort 0.0.0.0:9050 IsolateDestAddr" >>/etc/tor/torrc && \
#    echo "TransPort 0.0.0.0:9040" >>/etc/tor/torrc && \
#    echo "ControlSocket /etc/tor/run/control" >> /etc/tor/torrc && \
#    echo "ControlSocketsGroupWritable 1" >> /etc/tor/torrc && \
#    echo "ControlPort 9051" >> /etc/tor/torrc && \


RUN mkdir -p /var/lib/tor/.arm && echo "queries.useProc false" >> /var/lib/tor/.arm/armrc

RUN echo "Allowing tor port access" && \
    setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/tor

RUN useradd -ms /bin/bash anon && \
    chown -R anon:anon /usr/lib/tor-browser /etc/tor /var/lib/tor && \
    mkdir -p /etc/tor/run && \
    chown -Rh anon:anon /var/lib/tor /etc/tor/run && \
    chmod 0750 /etc/tor/run

RUN echo "tor &" >> /home/anon/.bashrc && \
    echo "tor-browser -f /etc/tor/torrc" >> /home/anon/.bashrc

USER anon
WORKDIR /home/anon
ENTRYPOINT ["/bin/bash"]
