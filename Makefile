.PHONY: %.eap all clean
CONTAINER_RUNTIME ?= docker

%.eap:
	DOCKER_BUILDKIT=1 $(CONTAINER_RUNTIME) build --build-arg ARCH=$(basename $@) -o type=local,dest=eap "$(CURDIR)"

all: armv7hf.eap aarch64.eap

clean:
	rm -rf eap
