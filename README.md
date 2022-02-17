*Copyright (C) 2022, Axis Communications AB, Lund, Sweden. All Rights Reserved.*

# Precision Time Protocol daemon ACAP

[![Build ACAPs](https://github.com/AxisCommunications/opc-ua-server-acap/actions/workflows/build.yml/badge.svg)](https://github.com/AxisCommunications/opc-ua-server-acap/actions/workflows/build.yml)
[![GitHub Super-Linter](https://github.com/AxisCommunications/opc-ua-server-acap/actions/workflows/super-linter.yml/badge.svg)](https://github.com/AxisCommunications/opc-ua-server-acap/actions/workflows/super-linter.yml)

[Precision Time Protocol](https://en.wikipedia.org/wiki/Precision_Time_Protocol)
(PTP) comes in handy in use cases where time synchronization with high
precision is needed. PTP open source implementations exist, were we use
[ptpd2](https://sourceforge.net/projects/ptpd2/) here: this repository
cross-compiles it and packages it as an Axis
[ACAP](https://www.axis.com/products/acap).

## Prerequisites

The build procedure assumes the existence of [Docker](https://www.docker.com/)
(and Internet connectivity) on the build machine.

## Build

### On host with ACAP SDK installed

```sh
# With the environment initialized, use:
acap-build -a ptpd2 -a ptpd2.conf .
```

### Using ACAP SDK build container and Docker

This repository has a [Makefile](Makefile) that wraps cross-compiling the
`ptpd2` binary for the target architectures and to build for all targets,
simply type

```sh
make
```

or perhaps

```sh
make -j
```

(to build in parallel). Then you will find the built ACAPs in the `./eap`
directory upon successful build.

If you would like to build for, say, `armv7hf` *only*, please use

```sh
make armv7hf.eap
```

If you do have Docker but no `make` on your system:

```sh
# 32-bit ARM
DOCKER_BUILDKIT=1 docker build --build-arg ARCH=armv7hf -o type=local,dest=eap .
# 64-bit ARM
DOCKER_BUILDKIT=1 docker build --build-arg ARCH=aarch64 -o type=local,dest=eap .
```

## Running

Install the ACAP like you normally do (e.g. in the target device's web UI). It
will automatically start running with the default options set in
[ptpd2.conf](ptpd2.conf). (More info about the configuration options can be
found in [ptpd2.conf (5)](https://www.systutorials.com/docs/linux/man/5-ptpd2.conf/).)

If you would like to alter the configuration, you will find it in the directory
`/usr/local/packages/ptp2d/` on the target device. Please edit it and then
restart the ACAP for the new changes to be used.
