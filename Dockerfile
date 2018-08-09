FROM centos:centos7

LABEL authors="Stakater <stakater@aurorasolutions.io>"

LABEL name="acme/starter-arbitrary-uid" \
      maintainer="stakater@aurorasolutions.io" \
      vendor="Stakater" \
      version="3.7" \
      release="1" \
      summary="Stakater Centos base image" 

RUN yum update -y && \
    yum install -y wget && \
    yum clean all 

ENTRYPOINT  ["bash"]