# OpenVPN client + SOCKS proxy
# Usage:
# Create configuration (.ovpn), mount it in a volume
# docker run --volume=something.ovpn:/ovpn.conf:ro --device=/dev/net/tun --cap-add=NET_ADMIN
# Connect to (container):1080
# Note that the config must have embedded certs
# See `start` in same repo for more ideas

FROM alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk add --update-cache openvpn openresolv openrc v2ray \
    && rm -rf /var/cache/apk

COPY v2ray.json /v2ray.json

EXPOSE 1080 8080
ENTRYPOINT [ \
    "/bin/sh", "-c", \
    "set -e; cd /etc/openvpn; /usr/sbin/openvpn --config *.conf & v2ray run -c /v2ray.json; wait" \
]
