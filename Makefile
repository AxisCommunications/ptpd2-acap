# Copyright (C) 2021 Axis Communications AB, Lund, Sweden
# SPDX-License-Identifier: Apache-2.0

.PHONY: %.eap all clean

TAG := ptpd2-acap

%.eap:
	DOCKER_BUILDKIT=1 docker build --build-arg ARCH=$(@:.eap=) -o type=local,dest=eap "$(CURDIR)"

all: armv7hf.eap aarch64.eap

clean:
	rm -rf eap
