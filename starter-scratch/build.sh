#!/bin/sh
set -x
cd $(dirname $(readlink -f $0))
GO_BUILD=github.com/golang/example/outyet
BDIR=/build
docker run --rm -tiv ${PWD}:${BDIR}:z registry.access.redhat.com/rhel7 \
  bash -c "chmod u+x ${BDIR}/go_build.sh; ${BDIR}/go_build.sh ${GO_BUILD}"