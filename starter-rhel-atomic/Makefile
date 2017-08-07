CONTEXT = acme
VERSION = v3.2
IMAGE_NAME = starter-rhel-atomic

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

test:
#	OpenShift compatibility - assign an arbitrary uid
	$(eval ARB_UID=$(shell shuf -i 1000010000-1000020000 -n 1))
#	OpenShift compatibility - prepare for mount of specified VOLUMEs in image
	$(eval VOL_LIST=$(shell docker inspect -f '{{range $$p, $$vol := .Config.Volumes}} {{json $$p}} {{end}}' ${CONTEXT}/${IMAGE_NAME}:${TARGET}-${VERSION}))
	$(eval TMPFS=$(shell for i in ${VOL_LIST}; do VOLS="$${VOLS} --tmpfs $${i}:rw,suid,dev,exec,relatime,mode=2770,gid=${ARB_UID}"; done; echo $${VOLS}))
	$(eval CONTAINERID=$(shell docker run -tdi \
	-u ${ARB_UID} --group-add ${ARB_UID} \
	${TMPFS} \
	--cap-drop=KILL \
	--cap-drop=MKNOD \
	--cap-drop=SYS_CHROOT \
	--cap-drop=SETUID \
	--cap-drop=SETGID \
	${CONTEXT}/${IMAGE_NAME}:${TARGET}-${VERSION}))
	@sleep 3
	docker exec ${CONTAINERID} env
	@echo ""
	@docker rm -vf ${CONTAINERID}

run:
	$(eval ARB_UID=$(shell shuf -i 1000010000-1000020000 -n 1))
	$(eval VOL_LIST=$(shell docker inspect -f '{{range $$p, $$vol := .Config.Volumes}} {{json $$p}} {{end}}' ${CONTEXT}/${IMAGE_NAME}:${TARGET}-${VERSION}))
	$(eval TMPFS=$(shell for i in ${VOL_LIST}; do VOLS="$${VOLS} --tmpfs $${i}:rw,suid,dev,exec,relatime,mode=2770,gid=${ARB_UID}"; done; echo $${VOLS}))
	docker run -tdi \
	-u ${ARB_UID} --group-add ${ARB_UID} \
	${TMPFS} \
	--cap-drop=KILL \
	--cap-drop=MKNOD \
	--cap-drop=SYS_CHROOT \
	--cap-drop=SETUID \
	--cap-drop=SETGID \
	${CONTEXT}/${IMAGE_NAME}:${TARGET}-${VERSION}

clean:
	rm -f build
