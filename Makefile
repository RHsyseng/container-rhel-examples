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

all: build
build: 
	@for d in ${DIRS}; do ${MAKE} -C $$d; done

clean:
	@for d in ${DIRS}; do ${MAKE} clean -C $$d; done
