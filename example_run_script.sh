#!/bin/sh

sudo docker run -it\
    --rm \
    --env DISPLAY=unix$DISPLAY \
    --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
    --shm-size 2g \
    torbrowser
