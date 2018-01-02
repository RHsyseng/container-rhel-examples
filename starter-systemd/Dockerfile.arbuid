### docker build --pull -t acme/starter-systemd:arbuid -f Dockerfile.arbuid .
FROM registry.access.redhat.com/rhel7-init
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

EXPOSE 80

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="acme/starter-systemd" \
      maintainer="refarch-feedback@redhat.com" \
      vendor="Acme Corp" \
      version="3.7" \
      release="1" \
      summary="Acme Corp's Starter app" \
      description="Starter app will do ....." \
### Required labels above - recommended below
      url="https://www.acme.io" \
      run='docker run -tdi --name ${NAME} \
      -u 123456 \
      -p 8080:80 \
      ${IMAGE}' \
      io.k8s.description="Starter app will do ....." \
      io.k8s.display-name="Starter app" \
      io.openshift.expose-services="http" \
      io.openshift.tags="acme,starter-systemd,starter,systemd"

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY systemd_setup help.md /tmp/

### add licenses to this directory
COPY licenses /licenses

### Add necessary Red Hat repos here
RUN REPOLIST=rhel-7-server-rpms,rhel-7-server-optional-rpms \
### Add your package needs here
    INSTALL_PKGS="golang-github-cpuguy83-go-md2man \
      cronie \
      httpd" && \
    yum -y update-minimal --disablerepo "*" --enablerepo rhel-7-server-rpms --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical && \
    yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
### help file markdown to man conversion
    go-md2man -in /tmp/help.md -out /help.1 && \
    yum clean all

### Setup user for build execution and application runtime
ENV USER_NAME=default \
    APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ ${APP_ROOT}/bin/
RUN chmod -R u+x ${APP_ROOT}/bin /tmp/systemd_setup && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /tmp/systemd_setup /etc/passwd

####### Add app-specific needs below. #######
### systemd requirements
RUN MASK_JOBS="sys-fs-fuse-connections.mount getty.target systemd-initctl.socket systemd-logind.service" && \
    systemctl mask ${MASK_JOBS} && \
    for i in ${MASK_JOBS}; do find /usr/lib/systemd/ -iname $i | grep ".wants" | xargs rm -f; done && \
    systemctl enable httpd crond && \
    /tmp/systemd_setup

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}

VOLUME /var/log/httpd /tmp /run
