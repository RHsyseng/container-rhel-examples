FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="acme/starter-nsswrapper" \
      vendor="Acme Corp" \
      version="3.2" \
      release="1" \
      summary="Acme Corp's Starter app" \
      description="Starter app will do ....." \
### Required labels above - recommended below
      url="https://www.acme.io" \
      run='docker run -tdi --name ${NAME} \
      -u 123456 \
      ${IMAGE}' \
      io.k8s.description="Starter app will do ....." \
      io.k8s.display-name="Starter app" \
      io.openshift.expose-services="" \
      io.openshift.tags="acme,starter-nsswrapper,starter,nsswrapper"

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY help.md user_setup /tmp/

### Add necessary Red Hat repos here
RUN REPOLIST=rhel-7-server-rpms,rhel-7-server-optional-rpms,rhel-7-server-ose-3.5-rpms \
### Add your package needs here
    INSTALL_PKGS="golang-github-cpuguy83-go-md2man \
      nss_wrapper \
      gettext" && \
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
RUN mkdir -p ${APP_HOME} ${APP_ROOT}/etc
COPY bin/ ${APP_ROOT}/bin/
RUN chmod -R ug+x ${APP_ROOT}/bin ${APP_ROOT}/etc /tmp/user_setup && sync && \
    /tmp/user_setup

####### Add app-specific needs below. #######
### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}
### NSS_WRAPPER for user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
RUN sed "s@${USER_NAME}:x:${USER_UID}:0@${USER_NAME}:x:\${USER_ID}:\${GROUP_ID}@g" /etc/passwd > ${APP_ROOT}/etc/passwd.template
ENTRYPOINT [ "nss_entrypoint" ]
CMD run