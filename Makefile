build:
	docker build \
		-t joseluisq/alpine-cgit:latest \
		-f Dockerfile .
.PHONY: build
