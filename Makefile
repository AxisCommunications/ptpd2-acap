.PHONY: %.eap all clean

TAG := ptpd2-acap

%.eap:
	docker build --build-arg ARCH=$(@:.eap=) -t $(TAG):$(@:.eap=) . && \
	docker cp $$(docker create $(TAG):$(@:.eap=)):/eap ./

all: armv7hf.eap aarch64.eap

clean:
	rm -rf eap
