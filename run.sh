#!/bin/sh

exec docker run -it\
    --rm \
    --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
    --env DISPLAY=unix$DISPLAY \
    --shm-size 2g \
    torbrowser
