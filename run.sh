#!/bin/sh

exec docker run -it\
    --rm \
    --env DISPLAY=${DISPLAY} \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --shm-size 2g \
    torbrowser

    #--entrypoint "/bin/bash" \
    #--hostname `hostname` \
    #--volume $PWD/Downloads:/tor-browser/Browser/Downloads \
    #--publish 9153 \
