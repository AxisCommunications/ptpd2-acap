.PHONY: %.eap all clean

%.eap:
	DOCKER_BUILDKIT=1 docker build --build-arg ARCH=$(@:.eap=) -o type=local,dest=eap "$(CURDIR)"

all: armv7hf.eap aarch64.eap

clean:
	rm -rf eap
