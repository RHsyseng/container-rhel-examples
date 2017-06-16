GO_BUILD = github.com/golang/example/outyet
CONTEXT = acme
VERSION = v3.2
IMAGE_NAME = starter-scratch

# Allow user to pass in OS build options
ifeq ($(TARGET),centos7)
	BUILDER_IMAGE := docker.io/centos:7
else
	BUILDER_IMAGE := registry.access.redhat.com/rhel7
endif

all: build
build:
	chmod u+x build.sh
	./build.sh ${GO_BUILD} ${BUILDER_IMAGE}
	docker build --pull -t ${CONTEXT}/${IMAGE_NAME}:${VERSION} -t ${CONTEXT}/${IMAGE_NAME} .
	@if docker images ${CONTEXT}/${IMAGE_NAME}:${VERSION}; then touch build; fi

clean:
	rm -f help.1 main build
