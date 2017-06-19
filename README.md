[![Build Status](https://travis-ci.org/RHsyseng/container-rhel-examples.svg?branch=master)](https://travis-ci.org/RHsyseng/container-rhel-examples)


## Lint
#### lint your Dockerfiles
```shell
$ make lint
```

## Build
#### build on rhel7
```shell
$ make

# or build one
$ make -C starter
```

#### build on centos7
```shell
$ make TARGET=centos7

# or build one
$ make -C starter TARGET=centos7
```

## Test
#### test on rhel7
```shell
$ make test

# or test one
$ make test -C starter
```

#### test on centos7
```shell
$ make test TARGET=centos7

# or test one
$ make test -C starter TARGET=centos7
```
