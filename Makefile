PROJECT := github.com/juju/txn

.PHONY: check-licence check-go check

dep:
	go get -v github.com/golang/dep
	$(GOPATH)/bin/dep ensure -v -vendor-only

check: check-licence check-go dep
	go test -v $(PROJECT)/... -check.v

check-licence:
	@(fgrep -rl "Licensed under the LGPLv3" --exclude vendor --exclude *.s .;\
		fgrep -rl "MACHINE GENERATED BY THE COMMAND ABOVE; DO NOT EDIT" --exclude *.s .;\
		find . -name "*.go") | sed -e 's,\./,,' | sort | uniq -u | \
		xargs -I {} echo FAIL: licence missed: {}

check-go:
	$(eval GOFMT := $(strip $(shell gofmt -l .| sed -e "s/^/ /g")))
	@(if [ "x$(GOFMT)" != "x" ]; then \
		echo go fmt is sad: $(GOFMT); \
		exit 1; \
	fi )
	@(go tool vet -all -composites=false -copylocks=false .)
