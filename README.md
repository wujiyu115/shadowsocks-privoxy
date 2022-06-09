# shadowsocks-privoxy
shadowsocks client for socks5 proxy
privoxy for http proxy

# Image:
docker pull wujiyu115/shadowsocks-privoxy:master

# Run:
```
docker run -i -t -e SS_SERVER=ss.server.ip -e SS_PORT=port -e SS_PASSWORD=123456 -e SS_METHOD=aes-256-cfb -p 7070:7070 -p 8118:8118 wujiyu115/shadowsocks-privoxy:master

```

+ 7070: socks5 port
+ 8118: http port
