### docker build --pull -t acme/starter -t acme/starter:v3.2 .
FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Atomic Labels
### https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL Name="acme/starter" \
      Vendor="Acme Corp" \
      Version="3.2" \
      Release="7" \
      build-date="2016-10-12T14:12:54.553894Z" \
      url="https://www.acme.io" \
      summary="Acme Corp's Starter App" \
      description="Starter App will do ....." \
      RUN='docker run -tdi --name ${NAME} \
      --tmpfs /tmp \
      ${IMAGE}' \
      STOP='docker stop ${NAME}'

### OpenShift labels
LABEL io.k8s.description="Starter App will do ....." \
      io.k8s.display-name="Starter App" \
      io.openshift.expose-services="" \
      io.openshift.tags="Acme,starter,starterapp"

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY help.md /

RUN yum clean all && \
    yum-config-manager --disable \* && \
    yum-config-manager --enable rhel-7-server-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
### Add additional Red Hat repos
#    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs && \
### Add your package needs to this installation line
#    yum -y install --setopt=tsflags=nodocs httpd && \
### help markdown to man conversion
    yum -y install golang-github-cpuguy83-go-md2man && go-md2man -in help.md -out help.1 && \
    yum -y remove golang-github-cpuguy83-go-md2man && rm -f help.md && \
### EPEL packages can be installed if necessary but, install non-epel packages before
### adding the EPEL repo so that supported bits are used wherever possible.
#    curl -o epel-release-latest-7.noarch.rpm -SL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
#            --retry 999 --retry-max-time 0 -C - && \
#    rpm -ivh epel-release-latest-7.noarch.rpm && rm epel-release-latest-7.noarch.rpm && \
#    yum -y install --setopt=tsflags=nodocs jq && \
#    yum-config-manager --disable epel && \
    yum clean all

### Setup the user that is used for the build execution and for the application runtime execution by default.
ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=10001
ENV APP_HOME=${APP_ROOT}/src \
    PATH=$PATH:${APP_ROOT}/bin
RUN mkdir -p ${APP_HOME} ${APP_ROOT}/bin && \
    useradd -l -u ${USER_UID} -r -g 0 -d ${APP_ROOT} -s /sbin/nologin \
            -c "${USER_NAME} application user" ${USER_NAME} && \
    chown -R ${USER_UID}:0 ${APP_ROOT} && \
    chmod -R g+rw ${APP_ROOT} && \
    find ${APP_ROOT} -type d -exec chmod g+x {} +

####### Add app-specific needs below. #######
### if COPYing or using files that require permission mods, do so before leaving root USER
#RUN chown -R ${USER_UID}:0 /run/httpd /etc/httpd /var/log/httpd && \
#    chmod -R g+rw /run/httpd /etc/httpd /var/log

### Containers should NOT run as root as a best practice
USER ${USER_UID}
WORKDIR ${APP_ROOT}

RUN echo $'#!/bin/sh\n\
tail -f /dev/null' > ${APP_ROOT}/bin/run.sh && \
    chmod ug+x ${APP_ROOT}/bin/run.sh

CMD run.sh