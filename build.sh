#!/bin/bash

set -e

hashword=$(sudo cat /etc/shadow | grep $USER | awk -F: '{print substr ($2, 1, 6)}')
echo $hashword > spw.txt
echo "sudoers password stored in spw.txt"

sudo docker build \
    -t torbrowser \
    --build-arg pw=$hashword \
    .
