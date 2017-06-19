FROM registry.access.redhat.com/rhel-atomic
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="acme/starter-rhel-atomic" \
      vendor="Acme Corp" \
      version="3.2" \
      release="1" \
      summary="Acme Corp's Starter app" \
      description="Starter app will do ....." \
### Required labels above - recommended below
      url="https://www.acme.io" \
      run='docker run -tdi --name ${NAME} ${IMAGE}' \
      io.k8s.description="Starter app will do ....." \
      io.k8s.display-name="Starter app" \
      io.openshift.expose-services="" \
      io.openshift.tags="acme,starter"

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY help.1 /

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root \
    USER_NAME=nobody \
    USER_UID=99
ENV APP_HOME=${APP_ROOT}/src  PATH=$PATH:${APP_ROOT}/bin

### Add your package needs here
#RUN INSTALL_PKGS="golang-github-cpuguy83-go-md2man \
#      shadow-utils \
#      libsemanage \
#      ustr \
#      audit-libs \
#      libcap-ng" && \
### Add necessary Red Hat repos here
#    microdnf --enablerepo=rhel-7-server-rpms --enablerepo=rhel-7-server-optional-rpms \
#      install --nodocs ${INSTALL_PKGS} && \
### help file markdown to man conversion
#    go-md2man -in /tmp/help.md -out /help.1 && \
#    useradd -l -u ${USER_UID} -r -g 0 -d ${APP_ROOT} -s /sbin/nologin \
#      -c "${USER_NAME} application user" ${USER_NAME} && \
#    microdnf remove golang-github-cpuguy83-go-md2man shadow-utils \
#      libsemanage ustr audit-libs libcap-ng && \
#    microdnf clean all

RUN mkdir -p ${APP_HOME}
COPY bin/ ${APP_ROOT}/bin/
RUN chown -R ${USER_UID}:0 ${APP_ROOT} && \
    chmod -R g+rw ${APP_ROOT} && \
    chmod -R ug+x ${APP_ROOT}/bin && \
    find ${APP_ROOT} -type d -exec chmod g+x {} +

####### Add app-specific needs below. #######
### Containers should NOT run as root as a good practice
USER 99
WORKDIR ${APP_ROOT}
CMD run
