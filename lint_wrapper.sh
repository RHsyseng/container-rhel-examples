#!/bin/sh
VARIANT=$1
for d in $(find ${VARIANT} -iname "Dockerfile*"); do dockerfile_lint -f $d; done
#dockerfile_lint -f ${VARIANT}/Dockerfile -f ${VARIANT}/Dockerfile.${TARGET}
