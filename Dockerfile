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

# There are two parameters i.e. user and usergroup, we can manage permission using both
# The container user is always a member of the root group, 
# The root group does not have any special permissions (unlike the root user)
# so there are no security concerns with this arrangement
# So we add the permissions on root user group rather than root user 
# and as container user is part of that group, it also has permissions

RUN chmod -R +x ${APP_ROOT}/bin && \

    # Change the ownership of ${APP_ROOT} to 0 i.e. the root group
    chgrp -R 0 ${APP_ROOT} && \        

    # Copy ${APP_ROOT} file permissions from user to the complete group 
    # so whoever will be in this group can access it
    chmod -R g=u ${APP_ROOT} /etc/passwd

ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

# Setting user as having root user can have security issues
USER 10001
WORKDIR ${APP_ROOT}

# By default, the user name is set to root and its id is 0
# If we set the user ID to non-zero like above we have set to 10001, 
# there will be no corresponding name of user.
# So in the uid_entrypoint, we see if user id is set i.e. 10001 here or any other id, 
# we create a user named 'stakater' and set that user for that id.
# So, now the user name is 'stakater' and id is whatever you set like 10001 in this case
ENTRYPOINT [ "uid_entrypoint" ]

VOLUME ${APP_ROOT}/logs ${APP_ROOT}/data

# Entrypoint will always be called and whatever is passed as CMD is an argument to Entrypoint
# e.g. in this case, the uid_entrypoint script is always run and bash is passed to it as an argument
CMD bash