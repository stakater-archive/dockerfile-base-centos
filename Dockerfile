FROM centos:centos7

LABEL name="Stakater CentOS base image" \    
      maintainer="Stakater <stakater@aurorasolutions.io>" \
      vendor="Stakater" \
      release="1" \
      summary="A CentOS base image to be used in Stakater apps" 

RUN mkdir -p /opt/app
ENV APP_ROOT=/opt/app
ENV HOME=${APP_ROOT}

RUN yum update -y && \
    yum install -y wget && \
    yum clean all 

USER 10001

ENTRYPOINT  ["bash"]