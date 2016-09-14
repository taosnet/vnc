# VNC Server

A docker container meant to be extended to provide VNC access to an application. It is designed to run by passing the startup application as the first argument:
```
docker run -p 5901:5901 taosnet/vnc xterm
```
The container does not have any applications by default which is why it is meant to be extended. The base distribution for the container is CentOS 7.

## Extending

First create a Dockerfile such as:
```
FROM taosnet/vnc

RUN yum install -y xterm \
	&& yum clean all

CMD ["xterm"]
```
and build via:
```
docker build -t taosnet/xterm .
```

You can then run it via:
```
docker run --name xterm -p 5901:5901 taosnet/xterm
```
