# Copyright (C) 2021 Axis Communications AB, Lund, Sweden
# SPDX-License-Identifier: Apache-2.0

.PHONY: %.eap all clean

TAG := ptpd2-acap

%.eap:
	docker build --build-arg ARCH=$(@:.eap=) -t $(TAG):$(@:.eap=) . && \
	staging=$$(docker create $(TAG):$(@:.eap=)) && \
	docker cp $$staging:/eap ./ && \
	docker rm $$staging

all: armv7hf.eap aarch64.eap

clean:
	rm -rf eap
