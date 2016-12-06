CONTEXT = acme
BUILD_NAME_001 = starter
BUILD_NAME_002 = starter-api
BUILD_NAME_003 = starter-arbitrary-uid
BUILD_NAME_004 = starter-epel
BUILD_NAME_005 = starter-nsswrapper
BUILD_NAME_006 = starter-systemd
REGISTRY_SERVER = 172.30.93.229:5000
USERNAME = ""
PASSWORD = ""
VERSION = v3.2
REGISTRY = 10.0.1.1

all: build

build: $(BUILD_NAME_001).o $(BUILD_NAME_002).o $(BUILD_NAME_003).o $(BUILD_NAME_004).o $(BUILD_NAME_005).o $(BUILD_NAME_006).o

$(BUILD_NAME_001).o: $(BUILD_NAME_001)/*
	docker build --pull -t $(CONTEXT)/$(BUILD_NAME_001):$(VERSION) -t $(CONTEXT)/$(BUILD_NAME_001) $(BUILD_NAME_001)/	
	@if docker images $(CONTEXT)/$(BUILD_NAME_001):$(VERSION); then touch $(BUILD_NAME_001).o; fi

$(BUILD_NAME_002).o: $(BUILD_NAME_002)/*
	docker build --pull -t $(CONTEXT)/$(BUILD_NAME_002):$(VERSION) -t $(CONTEXT)/$(BUILD_NAME_002) $(BUILD_NAME_002)/
	@if docker images $(CONTEXT)/$(BUILD_NAME_002):$(VERSION); then touch $(BUILD_NAME_002).o; fi

$(BUILD_NAME_003).o: $(BUILD_NAME_003)/*
	docker build --pull -t $(CONTEXT)/$(BUILD_NAME_003):$(VERSION) -t $(CONTEXT)/$(BUILD_NAME_003) $(BUILD_NAME_003)/
	@if docker images $(CONTEXT)/$(BUILD_NAME_003):$(VERSION); then touch $(BUILD_NAME_003).o; fi

$(BUILD_NAME_004).o: $(BUILD_NAME_004)/*
	docker build --pull -t $(CONTEXT)/$(BUILD_NAME_004):$(VERSION) -t $(CONTEXT)/$(BUILD_NAME_004) $(BUILD_NAME_004)/
	@if docker images $(CONTEXT)/$(BUILD_NAME_004):$(VERSION); then touch $(BUILD_NAME_004).o; fi

$(BUILD_NAME_005).o: $(BUILD_NAME_005)/*
	docker build --pull -t $(CONTEXT)/$(BUILD_NAME_005):$(VERSION) -t $(CONTEXT)/$(BUILD_NAME_005) $(BUILD_NAME_005)/
	@if docker images $(CONTEXT)/$(BUILD_NAME_005):$(VERSION); then touch $(BUILD_NAME_005).o; fi

$(BUILD_NAME_006).o: $(BUILD_NAME_006)/*
	docker build --pull -t $(CONTEXT)/$(BUILD_NAME_006):$(VERSION) -t $(CONTEXT)/$(BUILD_NAME_006) $(BUILD_NAME_006)/
	@if docker images $(CONTEXT)/$(BUILD_NAME_006):$(VERSION); then touch $(BUILD_NAME_006).o; fi

#test:
#	env NAME=$(NAME) VERSION=$(VERSION) ./test.sh

clean:
	rm ./*.o

#tag_production:
#	docker tag $(BUILD_NAME_001):latest $(BUILD_NAME_001):production
#	docker tag $(CONTEXT)/$(BUILD_NAME_001):$(VERSION) $(REGISTRY_SERVER)/$(CONTEXT)/$(BUILD_NAME_001):$(VERSION)

#tag_registry:
#	docker tag $(BUILD_NAME_001) $(REGISTRY_SERVER)/$(BUILD_NAME_001)

#push:
#	atomic push -u $(USERNAME) -p $(PASSWORD) $(REGISTRY_SERVER)/$(BUILD_NAME_001):latest