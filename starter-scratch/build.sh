#!/bin/sh
set -x
cd $(dirname $(readlink -f $0))
GO_BUILD=$1
BUILDER_IMAGE=$2
BDIR=/build
docker run --rm -tiv ${PWD}:${BDIR}:z ${BUILDER_IMAGE} \
  bash -c "chmod u+x ${BDIR}/go_build.sh; ${BDIR}/go_build.sh ${GO_BUILD}"