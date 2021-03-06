CONTEXT = acme
VERSION = v3.7
IMAGE_NAME = starter
REGISTRY = docker-registry.default.svc.cluster.local:5000
OC_USER = developer
OC_PASS = developer

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
	@echo "View processes..."
	docker exec ${CONTAINERID} ps aux
	@echo ""
	@echo "Check id information..."
	docker exec ${CONTAINERID} id
	@echo ""
	@echo "Check volume(s)..."
	@for i in ${VOL_LIST}; do docker exec ${CONTAINERID} mountpoint $${i}; docker exec ${CONTAINERID} mount | grep -w $${i} | grep tmpfs; echo; done
	@docker rm -vf ${CONTAINERID}

openshift-test:
	$(eval PROJ_RANDOM=test-$(shell shuf -i 100000-999999 -n 1))
	oc login --token=${OC_PASS}
	oc new-project ${PROJ_RANDOM}
	docker login -u ${OC_USER} -p ${OC_PASS} ${REGISTRY}
	docker tag ${CONTEXT}/${IMAGE_NAME}:${TARGET}-${VERSION} ${REGISTRY}/${PROJ_RANDOM}/${IMAGE_NAME}
	docker push ${REGISTRY}/${PROJ_RANDOM}/${IMAGE_NAME}
	oc new-app -i ${IMAGE_NAME}
	oc rollout status -w dc/${IMAGE_NAME}
	oc status
	sleep 5
	oc describe pod `oc get pod --template '{{(index .items 0).metadata.name }}'`
	oc exec `oc get pod --template '{{(index .items 0).metadata.name }}'` ps aux

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
