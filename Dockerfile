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

# There are two parameters i.e. user and usergroup, we can manage permission on a folder using both
# The container user is always a member of the root group, 
# The container user can read and write these files. 
# The root group does not have any special permissions (unlike the root user)
# so there are no security concerns with this arrangement

RUN chmod -R +x ${APP_ROOT}/bin && \

    # Change the ownership of ${APP_ROOT} to 0 i.e. the root group
    chgrp -R 0 ${APP_ROOT} && \        

    # Copy ${APP_ROOT} file permissions from user to group
    chmod -R g=u ${APP_ROOT} /etc/passwd

ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

USER 10001
WORKDIR ${APP_ROOT}

# By default, the user is set to root and its id is 0
# If we set the user ID to non-zero like above we have set to 10001, 
# there will be no corresponding name of user.
# So in the uid_entrypoint, we see if user id is set i.e. 10001 here or any other id, 
# we create a user named 'stakater' and set that user for that id.
ENTRYPOINT [ "uid_entrypoint" ]

VOLUME ${APP_ROOT}/logs ${APP_ROOT}/data

# Entrypoint will always be called and whatever is passed as CMD is and argument to Entrypoint
# e.g. in this case, the uid_entrypoint script is always run and bash is passed to it as an argument
CMD bash