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

####### Add app-specific needs below. #######
### systemd requirements - to cleanly shutdown systemd, use SIGRTMIN+3
STOPSIGNAL SIGRTMIN+3
ENV container=oci
RUN MASK_JOBS="sys-fs-fuse-connections.mount getty.target systemd-initctl.socket" && \
    systemctl mask ${MASK_JOBS} && \
    for i in ${MASK_JOBS}; do find /usr/lib/systemd/ -iname $i | grep ".wants" | xargs rm -f; done && \
    rm -f /etc/fstab && \
    systemctl set-default multi-user.target && \
    systemctl enable httpd crond

VOLUME /var/log/httpd /tmp /run

CMD [ "/sbin/init" ]