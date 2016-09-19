# VNC Server

A docker container meant to be extended to provide VNC access to an application. It is designed to run by passing the startup application as the first argument. See below for examples.
The container does not have any applications by default which is why it is meant to be extended. The base distribution for the container is CentOS 7.

## Security

The container supports SSH tunneling. To utilizing tunneling, you would need to setup your SSH key pairs when you extend your container. Then you just use the "-s" flag on the command to signal that SSH tunneling should be enabled. See below for examples. Note that using SSH tunnels still requires the use of a VNC password.

## Extending

First create a Dockerfile such as:
```
FROM taosnet/vnc

RUN yum install -y --setopt=tsflags=nodocs xterm \
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

### SSH Tunnel Example

First create a Dockerfile such as:
```
FROM taosnet/vnc

COPY ssh /root/.ssh/
RUN yum install -y --setopt=tsflags=nodocs xterm \
	&& yum clean all \
	&& chmod 600 /root/.ssh/authorized_keys

CMD ["-s", "xterm"]
```
Where the directory **ssh** has at a minimum authorized_keys. This is because the user password is disabled by default.

You can then run it via:
```
docker run --name xterm -p 5901:22 -t taosnet/xterm
```

To connect to the container, setup a ssh tunnel and connect:
```
ssh -L5901:127.0.0.1:5901 -p 5901 root@mycontainer
vncviewer localhost:5901
```

Some VNC clients have builtin capabilities for SSH tunnels. Please refer to your client's documentation.
