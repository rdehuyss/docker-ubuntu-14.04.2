docker-ubuntu-14.04.2
============================

Dockerfile for VDAB based on Ubuntu 14.04.2 LTS with ssh login possibility

### Installation
```
docker pull rdehuyss/docker-ubuntu-14.04.2
```

Run with port 22 opened:
```
docker run -d -p 49260:22 rdehuyss/docker-ubuntu-14.04.2
```

Login by SSH
```
ssh root@localhost -p 49260
password: admin
```
