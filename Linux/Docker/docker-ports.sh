#!/bin/bash 
docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" -a | \
    sed -E "s/PORTS/HOST PORTS/" | \
    sed -E "s/0\.0\.0\.0:[0-9]+->/IPv4: /g" | \
    sed -E "s/127\.0\.0\.1:[0-9]+->/IPv4: /g" | \
    sed -E "s/:::[0-9]+->/IPv6: /g" | \
    sed -E "s/::1:[0-9]+->/IPv6: /g"