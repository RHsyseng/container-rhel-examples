FROM scratch
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

EXPOSE 8080

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="acme/starter-scratch" \
      maintainer="refarch-feedback@redhat.com" \
      vendor="Acme Corp" \
      version="3.7" \
      release="1" \
      summary="Acme Corp's Starter app" \
      description="Starter app will do ....." \
### Required labels above - recommended below
      url="https://www.acme.io" \
      run='docker run -tdip 8080:8080 --name ${NAME} ${IMAGE}' \
      io.k8s.description="Starter app will do ....." \
      io.k8s.display-name="Starter app" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="acme,starter,scratch"

####### Add app-specific needs below. #######
ADD main help.1 /

### add licenses to this directory
COPY licenses /licenses

### Containers should NOT run as root as a good practice
USER 10001
CMD ["/main"]