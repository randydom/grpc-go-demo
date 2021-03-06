NAME=grpc-go-demo
ROOT=github.com/Shelex/${NAME}
GO111MODULE=on
SHELL=/bin/bash

.PHONY: gen
gen:
	go install github.com/golang/protobuf/protoc-gen-go
	protoc -I proto proto/employees.proto --go_out=plugins=grpc:.

.PHONY: build
build:
	make gen
	make build-server
	make build-client

.PHONY: build-server
build-server: 
	go build -o ./cmd/server ./domain

.PHONY: build-client
build-client: 
	go build -o ./cmd/client ./client


.PHONY: server
server:
	make gen
	make build-server
	cmd/server

.PHONY: client
client:
	make gen
	make build-client
	cmd/client -o 2

.PHONY: cert
cert: 
	openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem

.PHONY: lint
lint: 
	golangci-lint run

.PHONY: deps
deps:
	go mod tidy
	go mod download
	go mod vendor

.PHONY: gql
gql:
	cd client && rm -f generated.go models/*_gen.go &&\
	go run github.com/99designs/gqlgen generate