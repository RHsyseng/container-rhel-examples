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

lint:
	dockerfile_lint -f Dockerfile

test:
	$(eval CONTAINERID=$(shell docker run -tdi -u $(shell shuf -i 1000010000-1000020000 -n 1) -p 8080:8080 ${CONTEXT}/${IMAGE_NAME}:${VERSION}))
	@sleep 5
	@curl localhost:8080
	@docker rm -f ${CONTAINERID}

run:
	docker run -tdi -u $(shell shuf -i 1000010000-1000020000 -n 1) -p 8080:8080 ${CONTEXT}/${IMAGE_NAME}:${VERSION}

clean:
	rm -f help.1 main build
