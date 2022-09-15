all: vet universitymvp universitymvprace

build: deps
	go build google.golang.org/grpc/...

clean:
	go clean -i google.golang.org/grpc/...

deps:
	go get -d -v google.golang.org/grpc/...

proto:
	@ if ! which protoc > /dev/null; then \
		echo "error: protoc not installed" >&2; \
		exit 1; \
	fi
	go generate google.golang.org/grpc/...

universitymvp: universitymvpdeps
	go universitymvp -cpu 1,4 -timeout 7m google.golang.org/grpc/...

universitymvpappengine: universitymvpappenginedeps
	goapp universitymvp -cpu 1,4 -timeout 7m google.golang.org/grpc/...

universitymvpappenginedeps:
	goapp get -d -v -t -tags 'appengine appenginevm' google.golang.org/grpc/...

universitymvpdeps:
	go get -d -v -t google.golang.org/grpc/...

universitymvprace: universitymvpdeps
	go universitymvp -race -cpu 1,4 -timeout 7m google.golang.org/grpc/...

updatedeps:
	go get -d -v -u -f google.golang.org/grpc/...

updateuniversitymvpdeps:
	go get -d -v -t -u -f google.golang.org/grpc/...

vet: vetdeps
	./vet.sh

vetdeps:
	./vet.sh -install

.PHONY: \
	all \
	build \
	clean \
	deps \
	proto \
	universitymvp \
	universitymvpappengine \
	universitymvpappenginedeps \
	universitymvpdeps \
	universitymvprace \
	updatedeps \
	updateuniversitymvpdeps \
	vet \
	vetdeps
