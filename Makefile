CONTEXT = acme
USERNAME = ""
PASSWORD = ""
VERSION = v3.2
REGISTRY = 10.0.1.1
REGISTRY_SERVER = 172.30.93.229:5000
OUTPUT_DIR = o

all: build
build: starter  starter-arbitrary-uid  starter-systemd  starter-epel  starter-api  starter-nsswrapper
starter: ${OUTPUT_DIR}/starter.o
starter-arbitrary-uid: ${OUTPUT_DIR}/starter-arbitrary-uid.o
starter-systemd: ${OUTPUT_DIR}/starter-systemd.o
starter-epel: ${OUTPUT_DIR}/starter-epel.o
starter-api: ${OUTPUT_DIR}/starter-api.o
starter-nsswrapper: ${OUTPUT_DIR}/starter-nsswrapper.o

${OUTPUT_DIR}/starter.o: starter/*
	@mkdir -p ${OUTPUT_DIR}
	docker build --pull -t $(CONTEXT)/starter:$(VERSION) -t $(CONTEXT)/starter starter/	
	@if docker images $(CONTEXT)/starter:$(VERSION); then touch ${OUTPUT_DIR}/starter.o; fi

${OUTPUT_DIR}/starter-arbitrary-uid.o: starter-arbitrary-uid/*
	@mkdir -p ${OUTPUT_DIR}
	docker build --pull -t $(CONTEXT)/starter-arbitrary-uid:$(VERSION) -t $(CONTEXT)/starter-arbitrary-uid starter-arbitrary-uid/	
	@if docker images $(CONTEXT)/starter-arbitrary-uid:$(VERSION); then touch ${OUTPUT_DIR}/starter-arbitrary-uid.o; fi

${OUTPUT_DIR}/starter-systemd.o: starter-systemd/*
	@mkdir -p ${OUTPUT_DIR}
	docker build --pull -t $(CONTEXT)/starter-systemd:$(VERSION) -t $(CONTEXT)/starter-systemd starter-systemd/	
	@if docker images $(CONTEXT)/starter-systemd:$(VERSION); then touch ${OUTPUT_DIR}/starter-systemd.o; fi

${OUTPUT_DIR}/starter-epel.o: starter-epel/*
	@mkdir -p ${OUTPUT_DIR}
	docker build --pull -t $(CONTEXT)/starter-epel:$(VERSION) -t $(CONTEXT)/starter-epel starter-epel/	
	@if docker images $(CONTEXT)/starter-epel:$(VERSION); then touch ${OUTPUT_DIR}/starter-epel.o; fi

${OUTPUT_DIR}/starter-api.o: starter-api/*
	@mkdir -p ${OUTPUT_DIR}
	docker build --pull -t $(CONTEXT)/starter-api:$(VERSION) -t $(CONTEXT)/starter-api starter-api/	
	@if docker images $(CONTEXT)/starter-api:$(VERSION); then touch ${OUTPUT_DIR}/starter-api.o; fi

${OUTPUT_DIR}/starter-nsswrapper.o: starter-nsswrapper/*
	@mkdir -p ${OUTPUT_DIR}
	docker build --pull -t $(CONTEXT)/starter-nsswrapper:$(VERSION) -t $(CONTEXT)/starter-nsswrapper starter-nsswrapper/	
	@if docker images $(CONTEXT)/starter-nsswrapper:$(VERSION); then touch ${OUTPUT_DIR}/starter-nsswrapper.o; fi

#test:
#	env NAME=$(NAME) VERSION=$(VERSION) ./test.sh

clean:
	rm -r ${OUTPUT_DIR}/

#tag_production:
#	docker tag $(BUILD_NAME_001):latest $(BUILD_NAME_001):production
#	docker tag $(CONTEXT)/$(BUILD_NAME_001):$(VERSION) $(REGISTRY_SERVER)/$(CONTEXT)/$(BUILD_NAME_001):$(VERSION)

#tag_registry:
#	docker tag $(BUILD_NAME_001) $(REGISTRY_SERVER)/$(BUILD_NAME_001)

#push:
#	atomic push -u $(USERNAME) -p $(PASSWORD) $(REGISTRY_SERVER)/$(BUILD_NAME_001):latest