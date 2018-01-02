# -----------------------------------------------
# Build 
# -----------------------------------------------
# docker build --pull -t acme/starter-ansible -t acme/starter-ansible:v3.7 .
# ----------------------------------------------
FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

# -----------------------------------------------
# Labels 
# -----------------------------------------------
# Atomic/OpenShift Labels 
# https://github.com/projectatomic/ContainerApplicationGenericLabels
# ----------------------------------------------

LABEL name="acme/starter-ansible" \
      maintainer="refarch-feedback@redhat.com" \
      vendor="Acme Corp" \
      version="3.7" \
      release="1" \
      summary="Acme Corp's starter-ansible app" \
      description="starter-ansible app will do ....." \
### Required labels above - recommended below
      url="https://www.acme.io" \
      run='docker run -tdi --name ${NAME} ${IMAGE}' \
      io.k8s.description="starter-ansible app will do ....." \
      io.k8s.display-name="starter-ansible app" \
      io.openshift.expose-services="" \
      io.openshift.tags="acme,starter-ansible,starter,epel,ansible"

# -----------------------------------------------
# Environmental Variables
# -----------------------------------------------
# Define application path and user account variables
# -----------------------------------------------

ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=10001
ENV APP_HOME=${APP_ROOT}/src  PATH=$PATH:${APP_ROOT}/bin

# -----------------------------------------------
# Copy
# -----------------------------------------------
# Copy the playbook and help files to tmp
# Copy the bin directory to the APP_ROOT
# -----------------------------------------------

COPY help.md init.yml /tmp/
COPY bin/ ${APP_ROOT}/bin/

# -----------------------------------------------
# Run 
# -----------------------------------------------
# Install Ansible
# Run the init playbook with the above environmental variables
# as extra vars.  The init plabook will install required packages
# and configure the application user account and directories. 
# Once finished will remove all packages that are no longer needed.
# -----------------------------------------------

RUN yum -y install --disablerepo "*" \
                   --enablerepo rhel-7-server-rpms,rhel-7-server-optional-rpms,rhel-7-server-ose-3.7-rpms \
                   --setopt=tsflags=nodocs ansible && \
    ansible-playbook /tmp/init.yml -c local -i localhost, \
                   --extra-vars "application_install=${APPLICATION_INSTALL} application_version=${APPLICATION_VERSION} app_root=${APP_ROOT} username=${USER_NAME} uid=${USER_UID}" && \
    yum -y erase ansible && \ 
    yum clean all

# -----------------------------------------------
# User
# -----------------------------------------------
# Containers should NOT run as root as a good practice.
# -----------------------------------------------

USER 10001
WORKDIR ${APP_ROOT}
CMD run