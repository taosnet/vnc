FROM centos:7
MAINTAINER Chris Batis <clbatis@taosnet.com>

RUN yum update -y \
	&& yum install -y --setopt=tsflags=nodocs tigervnc-server \
	&& yum clean all \
	&& /bin/dbus-uuidgen --ensure

EXPOSE 5901
ENTRYPOINT ["/start.sh"]

COPY start.sh /start.sh
