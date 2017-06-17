CONTEXT = acme
VERSION = v3.2
IMAGE_NAME = starter-systemd

# Allow user to pass in OS build options
ifeq ($(TARGET),centos7)
	DFILE := Dockerfile.${TARGET}
else
	TARGET := rhel7
	DFILE := Dockerfile
endif

all: build
build:
	docker build --pull -t ${CONTEXT}/${IMAGE_NAME}:${TARGET}-${VERSION} -t ${CONTEXT}/${IMAGE_NAME} -f ${DFILE} .
	@if docker images ${CONTEXT}/${IMAGE_NAME}:${TARGET}-${VERSION}; then touch build; fi

lint:
	dockerfile_lint -f Dockerfile
	dockerfile_lint -f Dockerfile.centos7
	dockerfile_lint -f Dockerfile.arbuid
	dockerfile_lint -f Dockerfile.arbuid.centos7
	dockerfile_lint -f Dockerfile.w-postgresql

clean:
	rm -f build