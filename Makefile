SUBDIRS = starter starter-rhel-atomic starter-ansible starter-arbitrary-uid starter-systemd starter-epel starter-api starter-nsswrapper starter-scratch

all: build
build: ${SUBDIRS}
starter: starter/build
starter-rhel-atomic: starter-rhel-atomic/build
starter-ansible: starter-ansible/build
starter-arbitrary-uid: starter-arbitrary-uid/build
starter-systemd: starter-systemd/build
starter-epel: starter-epel/build
starter-api: starter-api/build
starter-nsswrapper: starter-nsswrapper/build
starter-scratch: starter-scratch/build

starter/build:
	cd starter/; make

starter-rhel-atomic/build:
	cd starter-rhel-atomic/; make

starter-ansible/build:
	cd starter-ansible/; make

starter-arbitrary-uid/build:
	cd starter-arbitrary-uid/; make

starter-systemd/build:
	cd starter-systemd/; make

starter-epel/build:
	cd starter-epel/; make

starter-api/build:
	cd starter-api/; make

starter-nsswrapper/build:
	cd starter-nsswrapper/; make

starter-scratch/build:
	cd starter-scratch/; make

clean:
	rm -rf ${OUTPUT_DIR}/
	for d in ${SUBDIRS}; do (cd $$d; make clean ); done
