#!/bin/sh
set -x
cd $(dirname $(readlink -f $0))
yum -y install --disablerepo "*" --enablerepo rhel-7-server-rpms,rhel-7-server-optional-rpms golang git golang-github-cpuguy83-go-md2man
GO_BUILD=$1
export GOPATH=${HOME}/go
go get -d ${GO_BUILD}

CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ${GO_BUILD}
go-md2man -in help.md -out help.1