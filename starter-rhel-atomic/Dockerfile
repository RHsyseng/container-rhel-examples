### docker build --pull -t acme/starter-rhel-atomic -t acme/starter-rhel-atomic:v3.2 .
FROM registry.access.redhat.com/rhel-atomic
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="acme/starter-rhel-atomic" \
      vendor="Acme Corp" \
      version="3.2" \
      release="1" \
### Recommended labels below
      build-date="2016-10-12T14:12:54.553894Z" \
      url="https://www.acme.io" \
      summary="Acme Corp's Starter app" \
      description="Starter app will do ....." \
      run='docker run -tdi --name ${NAME} ${IMAGE}' \
      io.k8s.description="Starter app will do ....." \
      io.k8s.display-name="Starter app" \
      io.openshift.expose-services="" \
      io.openshift.tags="acme,starter"

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY help.md user_setup /tmp/

### Add necessary Red Hat repos here
RUN microdnf --enablerepo=rhel-7-server-rpms --enablerepo=rhel-7-server-optional-rpms \
### Add your package needs to this installation line
    install --nodocs shadow-utils golang-github-cpuguy83-go-md2man && \
### help file markdown to man conversion
    go-md2man -in /tmp/help.md -out /help.1 && microdnf remove golang-github-cpuguy83-go-md2man && \
    microdnf clean all

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=10001
ENV APP_HOME=${APP_ROOT}/src  PATH=$PATH:${APP_ROOT}/bin
RUN mkdir -p ${APP_HOME}
COPY bin/ ${APP_ROOT}/bin/
RUN chmod -R ug+x ${APP_ROOT}/bin /tmp/user_setup && \
    /tmp/user_setup

####### Add app-specific needs below. #######
### Containers should NOT run as root as a good practice
USER ${USER_UID}
WORKDIR ${APP_ROOT}
CMD run
