DOCKER_IMAGE_TAG=joseluisq/alpine-cgit
DRONE_COMMIT_SHA ?= $(shell git rev-parse HEAD)

build:
	docker build \
		-t joseluisq/alpine-cgit:latest \
		-f Dockerfile .
.PHONY: build
