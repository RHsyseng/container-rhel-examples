CONTEXT = acme
VERSION = v3.2
GO_BUILD = github.com/golang/example/outyet

all: build
build:
	chmod u+x build.sh
	./build.sh ${GO_BUILD}
	docker build --pull -t $(CONTEXT)/starter-scratch:$(VERSION) -t $(CONTEXT)/starter-scratch .
	@if docker images $(CONTEXT)/starter-scratch:$(VERSION); then touch build; fi

clean:
	rm -f help.1 main build