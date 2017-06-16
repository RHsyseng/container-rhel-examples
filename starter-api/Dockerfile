FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="acme/starter-api" \
      vendor="Acme Corp" \
      version="3.2" \
      release="1" \
### Required labels above - recommended below
      url="https://www.acme.io" \
      summary="Acme Corp's starter-api app" \
      description="starter-api app will do ....." \
      run='docker run -tdi --name ${NAME} ${IMAGE}' \
      io.k8s.description="starter-api app will do ....." \
      io.k8s.display-name="starter-api app" \
      io.openshift.expose-services="" \
      io.openshift.tags="acme,starter-api,starter,api"

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY help.md user_setup /tmp/

### Add necessary Red Hat repos here
RUN REPOLIST=rhel-7-server-rpms,rhel-7-server-optional-rpms,epel \
### Add your package needs here
    INSTALL_PKGS="golang-github-cpuguy83-go-md2man \
      iputils \
      bind-utils \
      jq" && \
    yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y update-minimal --disablerepo "*" --enablerepo rhel-7-server-rpms --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical && \
    yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
### help file markdown to man conversion
    go-md2man -in /tmp/help.md -out /help.1 && \
    yum clean all

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=10001
ENV APP_HOME=${APP_ROOT}/src  PATH=$PATH:${APP_ROOT}/bin
RUN mkdir -p ${APP_HOME}
COPY bin/ ${APP_ROOT}/bin/
RUN chmod -R ug+x ${APP_ROOT}/bin /tmp/user_setup && sync && \
    /tmp/user_setup

####### Add app-specific needs below. #######
### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}
CMD run