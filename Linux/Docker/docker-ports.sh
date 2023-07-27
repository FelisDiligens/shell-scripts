#!/bin/bash 
docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" -a | \
    sed -E "s/PORTS/HOST PORTS/" | \
    sed -E "s/:([0-9]+)->[0-9]+\//: \1\//g" | \
    sed -E "s/0\.0\.0\.0: /IPv4: /g" | \
    sed -E "s/127\.0\.0\.1: /IPv4: /g" | \
    sed -E "s/::: /IPv6: /g" | \
    sed -E "s/::1: /IPv6: /g"