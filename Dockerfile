FROM phusion/baseimage:latest

ENV TOR_VERSION=7.5
ENV TOR_FINGERPRINT=0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290
ENV RELEASE_FILE=tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz
ENV RELEASE_URL=https://dist.torproject.org/torbrowser/${TOR_VERSION}/${RELEASE_FILE}
ENV PATH=$PATH:/home/anon/Browser

RUN echo "Installing dependancies" && \
    apt-get update && \
    apt-get install -y \
      ca-certificates \
      curl \
      file \
      libx11-xcb1 \
      libasound2 \
      libdbus-glib-1-2 \
      libgtk2.0-0 \
      libxrender1 \
      libxt6 \
      sudo \
      vlc \
      wget \
      xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Install tor as user
RUN echo "Adding User" && \
    useradd --create-home --home-dir /home/anon --shell /bin/bash anon && \
    echo "anon:lol" | chpasswd && adduser anon sudo && \
    chown -R anon:anon /home/anon
USER anon
WORKDIR /home/anon

RUN echo "Installing keys" && \
    mkdir ~/.gnupg && \
    gpg --keyserver keys.gnupg.net --recv-keys ${TOR_FINGERPRINT}


RUN echo "Installing tor from ${RELEASE_URL}" && \
    curl --fail -O -sSL ${RELEASE_URL} && \
    curl --fail -O -sSL ${RELEASE_URL}.asc && \
    gpg --verify ${RELEASE_FILE}.asc && \
    #echo "$SHA256_CHECKSUM $RELEASE_FILE" > sha256sums.txt && \
    #sha256sum -c sha256sums.txt && \
    tar --strip-components=1 -vxJf ${RELEASE_FILE}


RUN echo "Removing old junk" && \
    rm -v ${RELEASE_FILE}* && \
    #rm -v sha256sums.txt && \
    rm -rf ~/.gnupg

RUN echo "/home/anon/Browser/start-tor-browser &" >> /home/anon/.bashrc

ENTRYPOINT ["/bin/bash"]
