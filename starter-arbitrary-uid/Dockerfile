### docker build --pull -t acme/starter-arbitrary-uid -t acme/starter-arbitrary-uid:v3.2 .
FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Atomic/OpenShift Labels
### https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL Name="acme/starter-arbitrary-uid" \
      Vendor="Acme Corp" \
      Version="3.2" \
      Release="1" \
### Optional labels below
      build-date="2016-10-12T14:12:54.553894Z" \
      url="https://www.acme.io" \
      summary="Acme Corp's Starter App" \
      description="Starter App will do ....." \
      RUN='docker run -tdi --name ${NAME} \
      -u 123456 \
      ${IMAGE}' \
      io.k8s.description="Starter App will do ....." \
      io.k8s.display-name="Starter App" \
      io.openshift.expose-services="" \
      io.openshift.tags="Acme,starter,starterapp"

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY help.md user_setup /tmp/

RUN yum clean all && \
    yum-config-manager --disable \* &> /dev/null && \
### Add necessary Red Hat repos here
    yum-config-manager --enable rhel-7-server-rpms,rhel-7-server-optional-rpms &> /dev/null && \
    yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs && \
### help markdown to man conversion
### Add your package needs to this installation line
    yum -y install --setopt=tsflags=nodocs golang-github-cpuguy83-go-md2man && \
    go-md2man -in /tmp/help.md -out /help.1 && yum -y remove golang-github-cpuguy83-go-md2man && \
    yum clean all

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=10001
ENV APP_HOME=${APP_ROOT}/src  PATH=$PATH:${APP_ROOT}/bin
RUN mkdir -p ${APP_HOME} ${APP_ROOT}/etc
COPY bin/ ${APP_ROOT}/bin/
RUN chmod -R ug+x ${APP_ROOT}/bin ${APP_ROOT}/etc /tmp/user_setup && \
    /tmp/user_setup

####### Add app-specific needs below. #######
### Containers should NOT run as root as a best practice
USER ${USER_UID}
WORKDIR ${APP_ROOT}
### arbitrary uid recognition at runtime
RUN sed "s@${USER_NAME}:x:${USER_UID}:0@${USER_NAME}:x:\${USER_ID}:\${GROUP_ID}@g" /etc/passwd > ${APP_ROOT}/etc/passwd.template
ENTRYPOINT [ "uid_entrypoint" ]
CMD run