## Starter-systemd RHEL-based Image w/ best practices 
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
# build on rhel7
$ make

# OR

# build on centos7
$ make TARGET=centos7
```
```shell
$ atomic run acme/starter-systemd
# OR (on RHEL docker)
# $ docker run -tdi --name starter-systemd -p 8080:80 acme/starter-systemd
# OR
# $ docker run -tdi --name starter-systemd -p 8080:80 -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /run --tmpfs /tmp acme/starter-systemd
$ docker logs starter-systemd 
$ docker exec starter-systemd systemctl status
$ docker exec starter-systemd journalctl
```
### Running in OpenShift w/ the anyuid scc & root uid
```shell
$ oc adm policy add-scc-to-user anyuid -z default
$ oc new-app registry.centos.org/container-examples/starter-systemd

# OR deploy rhel7 image
$ oc new-build --name=starter-systemd --context-dir=starter-systemd . -D - < Dockerfile
$ oc logs -f bc/starter-systemd
$ oc new-app starter-systemd
```
### Running in OpenShift w/ a _restrictive_ scc & arbitrary uid
```shell
$ oc create -f systemd-restricted.yaml
$ oc adm policy add-scc-to-user systemd-restricted -z default
$ oc new-app registry.centos.org/container-examples/starter-systemd:arbuid

# OR deploy rhel7 image
$ oc new-build --name=starter-systemd --context-dir=starter-systemd . -D - < Dockerfile.arbuid
$ oc logs -f bc/starter-systemd
$ oc new-app starter-systemd
```
### Systemd service unit file considerations w/ a _restrictive_ scc deployment

If you plan to use systemd unit files that actually call a shell as a ExecStart, the invoked shell environment needs to be relaxed in order to prevent your EUID from being reset to RUID by bash/sh.
This applies to the calling and execution shell on script, the "-p" flag is used to accomplish this in the example unit below :  

```shell
...
[Service]
ExecStart=/bin/sh -p -c "/bin/myservice.sh"
Type=forking
Restart=on-failure
...
```