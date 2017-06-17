FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Default to UTF-8 file.encoding
ENV LANG en_US.utf8
### Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /usr/lib/jvm/jre

### Add necessary Red Hat repos here
RUN REPOLIST=rhel-7-server-rpms,rhel-7-server-thirdparty-oracle-java-rpms \
### Add your package needs here
    INSTALL_PKGS="java-1.8.0-oracle" && \
    yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
    yum clean all

ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=10001
ENV HOME=${APP_ROOT}/src
#ENV PATH=${HOME}/bin:${APP_ROOT}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mkdir -p ${HOME}/bin ${APP_ROOT}/bin && \
    useradd -l -u ${USER_UID} -r -g 0 -d ${HOME} -s /sbin/nologin \
            -c "${USER_NAME} application user" ${USER_NAME} && \
    chown -R ${USER_UID}:0 /opt/app-root

### Containers should NOT run as root as a best practice
USER 10001
WORKDIR ${HOME}