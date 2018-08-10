FROM centos:centos7

LABEL name="Stakater CentOS base image" \    
      maintainer="Stakater <stakater@aurorasolutions.io>" \
      vendor="Stakater" \
      release="1" \
      summary="A CentOS base image to be used in Stakater apps" 

ENV APP_ROOT=/opt/app
ENV HOME=${APP_ROOT}
ENV container docker

RUN yum update -y && \
    yum install -y wget && \
    yum install -y httpd && \
    yum clean all 

# Running httpd.service as systemd service
RUN systemctl enable httpd.service

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

COPY bin/ ${APP_ROOT}/bin/

# Adding the container user group as root group and giving access to $(APP_ROOT) path to root group
RUN chmod -R u+x ${APP_ROOT}/bin && \
    # Change current user group to root
    chgrp -R 0 ${APP_ROOT} && \        
    chmod -R g=u ${APP_ROOT} /etc/passwd

ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
USER 10001
WORKDIR ${APP_ROOT}
# Create stakater user if USER id is set
ENTRYPOINT [ "uid_entrypoint" ]

VOLUME ${APP_ROOT}/logs ${APP_ROOT}/data

CMD run