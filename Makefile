DIRS = \
starter \
starter-arbitrary-uid \
starter-rhel-atomic \
starter-epel \
starter-systemd \
starter-nsswrapper \
starter-api \
starter-scratch \
starter-ansible

# Allow user to pass in OS build options
ifeq ($(TARGET),centos7)
	DFILE := Dockerfile.${TARGET}
else
	TARGET := rhel7
	DFILE := Dockerfile
endif

all: build
build: 
	@for d in ${DIRS}; do ${MAKE} -C $$d TARGET=${TARGET}; done

lint:
	@for d in ${DIRS}; do ${MAKE} lint -C $$d; done

test:
	@for d in ${DIRS}; do ${MAKE} test -C $$d; done

clean:
	@for d in ${DIRS}; do ${MAKE} clean -C $$d; done
