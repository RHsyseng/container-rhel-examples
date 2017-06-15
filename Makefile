DIRS = \
starter \
starter-arbitrary-uid \
starter-rhel-atomic \
starter-systemd \
starter-epel \
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

clean:
	@for d in ${DIRS}; do ${MAKE} clean -C $$d; done
