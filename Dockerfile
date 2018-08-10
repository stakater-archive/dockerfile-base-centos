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
    yum clean all 

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