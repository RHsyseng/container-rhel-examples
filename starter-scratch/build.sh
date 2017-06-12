#!/bin/sh
set -x
cd $(dirname $(readlink -f $0))
yum -y install --disablerepo "*" --enablerepo rhel-7-server-rpms,rhel-7-server-optional-rpms golang golang-github-cpuguy83-go-md2man
curl -O https://raw.githubusercontent.com/golang/example/master/outyet/main.go
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o outyet .
go-md2man -in help.md -out help.1
