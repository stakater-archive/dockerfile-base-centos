FROM centos:centos7

LABEL name="Stakater CentOS base image" \    
      maintainer="Stakater <stakater@aurorasolutions.io>" \
      vendor="Stakater" \
      release="1" \
      summary="A CentOS base image to be used in Stakater apps" 

RUN mkdir -p /opt/app
ENV APP_ROOT=/opt/app
ENV HOME=${APP_ROOT}
ENV container docker

RUN yum update -y && \
    yum install -y wget && \
    yum install -y httpd && \
    yum clean all 

RUN systemctl enable httpd.service

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

USER 10001

CMD ["/usr/sbin/init"]