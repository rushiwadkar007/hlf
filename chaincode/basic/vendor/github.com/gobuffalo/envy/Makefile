TAGS ?= "sqlite"
GO_BIN ?= go

install:
	packr2
	$(GO_BIN) install -v .

deps:
	$(GO_BIN) get github.com/gobuffalo/release
	$(GO_BIN) get github.com/gobuffalo/packr/v2/packr2
	$(GO_BIN) get -tags ${TAGS} -t ./...
ifeq ($(GO111MODULE),on)
	$(GO_BIN) mod tidy
endif

build:
	packr2
	$(GO_BIN) build -v .

universitymvp:
	packr2
	$(GO_BIN) universitymvp -tags ${TAGS} ./...

ci-universitymvp:
	$(GO_BIN) universitymvp -tags ${TAGS} -race ./...

lint:
	gometalinter --vendor ./... --deadline=1m --skip=internal

update:
	$(GO_BIN) get -u -tags ${TAGS}
ifeq ($(GO111MODULE),on)
	$(GO_BIN) mod tidy
endif
	packr2
	make universitymvp
	make install
ifeq ($(GO111MODULE),on)
	$(GO_BIN) mod tidy
endif

release-universitymvp:
	$(GO_BIN) universitymvp -tags ${TAGS} -race ./...

release:
	release -y -f version.go
