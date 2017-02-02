## Starter-arbitrary-uid RHEL-based Image w/ best practices 
This image aims to include Red Hat's most critical [container best practices](http://docs.projectatomic.io/container-best-practices/).

### Building an image on RHEL
The easiest way to get started building your own rhel-based image is to first ensure you're using Red Hat's supported docker package on a registered RHEL7 or Atomic Server.

Be sure you've enabled the following repos after your system is registered:
```shell
$ subscription-manager repos --enable=rhel-7-server-rpms --enable=rhel-7-server-extras-rpms
```
Install the docker package (after you've removed any public bits you may have been using):
```shell
$ yum install docker
$ systemctl enable docker
$ systemctl start docker
$ docker info
```
If access to a licensed RHEL/Atomic server is not available to you, we offer a no-cost Developer license as well as a Container Development Kit.

http://developers.redhat.com/products/rhel/overview/  

http://developers.redhat.com/products/cdk/overview/

Once your host is setup you can begin your Dockerfile with this example. This will ensure you're using the supported/secure base image instead of one you might find on docker's public hub, and many other benefits discussed in the best practices link above.
```shell
$ docker build --pull -t acme/starter-arbitrary-uid -t acme/starter-arbitrary-uid:v3.2 .
$ docker build --pull -t acme/starter-arbitrary-uid:centos7 -f Dockerfile.centos7 .
$ docker run -u 123456 acme/starter-arbitrary-uid:centos7 id
$ docker run -u 123456 acme/starter-arbitrary-uid id
```
OpenShift deployment
```shell
# CENTOS version
$ oc new-app https://raw.githubusercontent.com/RHsyseng/container-rhel-examples/master/starter-arbitrary-uid/uid-ocp-template-centos7.yaml
# OR RHEL version
$ oc new-app https://raw.githubusercontent.com/RHsyseng/container-rhel-examples/master/starter-arbitrary-uid/uid-ocp-template.yaml
```