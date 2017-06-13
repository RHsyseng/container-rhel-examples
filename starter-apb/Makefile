CONTEXT = acme
VERSION = v3.2
IMAGE_NAME = starter

all: build
build:
	docker build --pull -t ${CONTEXT}/${IMAGE_NAME}:${VERSION} -t ${CONTEXT}/${IMAGE_NAME} .
	@if docker images ${CONTEXT}/${IMAGE_NAME}:${VERSION}; then touch build; fi

clean:
	rm -f build