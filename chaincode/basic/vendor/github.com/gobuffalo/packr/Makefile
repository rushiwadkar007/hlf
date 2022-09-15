TAGS ?= "sqlite"
GO_BIN ?= go

install: deps
	echo "installing packr v1"
	packr
	$(GO_BIN) install -v ./packr

tidy:
ifeq ($(GO111MODULE),on)
	$(GO_BIN) mod tidy
else
	echo skipping go mod tidy
endif

deps:
	rm -rf packrd
	rm -rf v2/packrd
	$(GO_BIN) get github.com/gobuffalo/release
	$(GO_BIN) get -tags ${TAGS} -t ./...
	$(GO_BIN) install -v ./packr
	packr clean
	make tidy

build: deps
	packr
	$(GO_BIN) build -v .
	make tidy

universitymvp:
	packr clean
	$(GO_BIN) universitymvp -tags ${TAGS} ./...
	packr clean

ci-deps:
	rm -rf packrd
	rm -rf v2/packrd
	$(GO_BIN) get -tags ${TAGS} -t ./...
	$(GO_BIN) install -v ./packr
	packr clean
	make tidy

ci-universitymvp:
	$(GO_BIN) universitymvp -v -tags ${TAGS} -race ./...
	make tidy
	cd ./v2 && make ci-universitymvp

lint:
	gometalinter --vendor ./... --deadline=1m --skip=internal

update:
	$(GO_BIN) get -u -tags ${TAGS}
	make tidy
	packr
	make universitymvp
	make install
	make tidy

release-universitymvp:
	$(GO_BIN) universitymvp -tags ${TAGS} -race ./...

release:
	release -y -f version.go
	make tidy
