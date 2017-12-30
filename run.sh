#!/bin/sh

exec docker run \
    --rm \
    --env XAUTHDATA="`/usr/bin/xauth nextract - ${DISPLAY}`" \
    --env DISPLAY=${DISPLAY} \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --user 1000 \
    torbrowser

    #--hostname `hostname` \
    #--volume $PWD/Downloads:/tor-browser/Browser/Downloads \
    #--workdir /tor-browser \
    #--publish 9153 \
