### docker build --pull -t acme/starter-systemd:arbuid-centos7 -f Dockerfile.arbuid.centos7 .
FROM centos:centos7
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

RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs && \
### Add your package needs to this installation line
    yum -y --setopt=tsflags=nodocs install cronie httpd && \
    yum clean all

COPY systemd_setup /tmp/

### Setup user for build execution and application runtime
ENV USER_NAME=default \
    APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ ${APP_ROOT}/bin/
RUN chmod -R u+x ${APP_ROOT}/bin /tmp/systemd_setup && sync && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /tmp/systemd_setup /etc/passwd

####### Add app-specific needs below. #######
### systemd requirements - to cleanly shutdown systemd, use SIGRTMIN+3
STOPSIGNAL SIGRTMIN+3
ENV container=oci
RUN MASK_JOBS="sys-fs-fuse-connections.mount getty.target systemd-initctl.socket systemd-logind.service" && \
    systemctl mask ${MASK_JOBS} && \
    for i in ${MASK_JOBS}; do find /usr/lib/systemd/ -iname $i | grep ".wants" | xargs rm -f; done && \
    rm -f /etc/fstab && \
    systemctl set-default multi-user.target && \
    systemctl enable httpd crond && \
    /tmp/systemd_setup

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}

VOLUME /var/log/httpd /tmp /run
CMD [ "/sbin/init" ]
