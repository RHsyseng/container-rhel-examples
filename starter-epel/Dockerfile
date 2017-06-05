### docker build --pull -t acme/starter-epel -t acme/starter-epel:v3.2 .
FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="acme/starter-epel" \
      vendor="Acme Corp" \
      version="3.2" \
      release="1" \
### Required labels above - recommended below
      url="https://www.acme.io" \
      summary="Acme Corp's starter-epel app" \
      description="starter-epel app will do ....." \
      run='docker run -tdi --name ${NAME} ${IMAGE}' \
      io.k8s.description="starter-epel app will do ....." \
      io.k8s.display-name="starter-epel app" \
      io.openshift.expose-services="" \
      io.openshift.tags="acme,starter-epel,starter,epel"

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY help.md user_setup /tmp/

### Add necessary Red Hat repos here
ENV REPOLIST=rhel-7-server-rpms,rhel-7-server-optional-rpms
RUN yum clean all && \
    yum -y update-minimal --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical && \
### Add your package needs here
    yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs \
      golang-github-cpuguy83-go-md2man && \
### help file markdown to man conversion
    go-md2man -in /tmp/help.md -out /help.1 && yum -y remove golang-github-cpuguy83-go-md2man && \
### EPEL needs
    curl -o epel-release-latest-7.noarch.rpm -SL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
            --retry 9 --retry-max-time 0 -C - && \
    rpm -ivh epel-release-latest-7.noarch.rpm && rm epel-release-latest-7.noarch.rpm && \
    yum -y install --setopt=tsflags=nodocs jq && \
    yum-config-manager --disable epel && \
    yum clean all

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