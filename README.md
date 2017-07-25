[![Build Status](https://travis-ci.org/RHsyseng/container-rhel-examples.svg?branch=master)](https://travis-ci.org/RHsyseng/container-rhel-examples)


## Getting started
### Build
#### build rhel7 images
```shell
# build many
$ make

# or build one
$ make -C starter
```

#### build centos7 images
```shell
# build many
$ make TARGET=centos7

# or build one
$ make -C starter TARGET=centos7
```
### Run
#### run a built rhel7 image
```shell
$ make run -C starter
```

#### run a built centos7 image
```shell
$ make run -C starter TARGET=centos7
```
## Optional
### Lint
#### lint your Dockerfiles
```shell
$ yum -y install nodejs
$ npm install -g dockerfile_lint
$ make lint
```
### Test
#### rhel7
```shell
# test many images
$ make test

# or test one image
$ make test -C starter
```
#### centos7
```shell
# test many images
$ make test TARGET=centos7

# or test one image
$ make test -C starter TARGET=centos7
```
### OpenShift Test
#### env setup
```shell
# login as an admin user to retrieve the registry address
$ oc login -u system:admin
$ REGISTRY=`oc get svc/docker-registry -n default --template '{{.spec.clusterIP}}:{{index .spec.ports 0 "port"}}'`
# login as a regular user before executing any tests
$ oc login -u developer -p developer
```
#### test an image in openshift
```shell
$ make openshift-test -C starter OC_USER=`oc whoami` OC_PASS=`oc whoami -t` REGISTRY=${REGISTRY}

# or test a centos7 image
$ make openshift-test -C starter TARGET=centos7 OC_USER=`oc whoami` OC_PASS=`oc whoami -t` REGISTRY=${REGISTRY}
```
