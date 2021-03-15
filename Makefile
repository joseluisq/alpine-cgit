DOCKER_IMAGE_TAG=joseluisq/alpine-cgit
DRONE_COMMIT_SHA ?= $(shell git rev-parse HEAD)

build:
	docker build \
		-t joseluisq/alpine-cgit:latest \
		-f Dockerfile .
.PHONY: build

publish:
	docker run --rm \
		-e DRONE_TAG=$(TAG_VERSION) \
		-e PLUGIN_TAG=$(TAG_VERSION) \
		-e PLUGIN_REPO=$(DOCKER_IMAGE_TAG) \
		-e DRONE_COMMIT_SHA=$(DRONE_COMMIT_SHA) \
		-e PLUGIN_AUTO_TAG=true \
		-e PLUGIN_AUTO_TAG_ALIASES=latest \
		-v $(PWD):$(PWD) \
		-w $(PWD) \
		--privileged \
			joseluisq/drone-docker \
				--dockerfile Dockerfile \
				--dry-run
.PHONY: publish
