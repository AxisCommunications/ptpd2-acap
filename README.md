*Copyright (C) 2022, Axis Communications AB, Lund, Sweden. All Rights Reserved.*

# Precision Time Protocol daemon ACAP

[![Build ACAP packages](https://github.com/AxisCommunications/ptpd2-acap/actions/workflows/build.yml/badge.svg)](https://github.com/AxisCommunications/ptpd2-acap/actions/workflows/build.yml)
[![GitHub Super-Linter](https://github.com/AxisCommunications/ptpd2-acap/actions/workflows/super-linter.yml/badge.svg)](https://github.com/AxisCommunications/ptpd2-acap/actions/workflows/super-linter.yml)

[Precision Time Protocol](https://en.wikipedia.org/wiki/Precision_Time_Protocol)
(PTP) comes in handy in use cases where time synchronization with high
precision is needed. PTP open source implementations exist, were we use
[ptpd2](https://sourceforge.net/projects/ptpd2/) here: this repository
cross-compiles it and packages it as an Axis
[ACAP](https://www.axis.com/products/acap) application.

> [!IMPORTANT]
> The ptpd2 implementation does a startup check to make sure it is run as the
> root user
> ([startup.c#L748-L753](https://github.com/ptpd/ptpd/blob/42f68d8818304e0bc3873550317c9b302d4efff6/src/dep/startup.c#L748-L753)).
> With the *root removal* introduced in
> [AXIS OS 12](https://help.axis.com/en-us/axis-os-release-notes#axis-os-12),
> it is no longer allowed to run an ACAP application as the root user. Hence
> this ACAP packaging of the unmodified ptpd2 executable needs to be run on
> AXIS OS
> [LTS 2024 11.11](https://help.axis.com/en-us/axis-os-release-notes#lts-2024-11-11)
> (supported until 2029-12-31) or older. For newer products released on AXIS OS
> 12 and newer, alternative PTP options must be used.
> *However, this repo is still a valid example of how to cross-compile and
> package other programs with ACAP, as long as they do not need to be run as
> root.*

## Prerequisites

The build procedure assumes the existence of [Docker](https://www.docker.com/)
or [Podman](https://podman.io/) (and Internet connectivity) on the build machine.

## Build

### On host with ACAP SDK installed

```sh
# With the environment initialized, use:
acap-build -a ptpd2 -a ptpd2.conf .
```

### Using ACAP SDK build container and Docker (or Podman)

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

(to build in parallel). Then you will find the built ACAP packages in the
`./eap` directory upon successful build.

If you would like to build for, say, `armv7hf` *only*, please use

```sh
make armv7hf.eap
```

The Makefile has Docker as the default container runtime. If you would like to
use Podman instead, use the environment variable `CONTAINER_RUNTIME=podman`:

```sh
CONTAINER_RUNTIME=podman make
```

or

```sh
CONTAINER_RUNTIME=podman make -j
```

If you do have Docker but no `make` on your system:

```sh
# 32-bit ARM, e.g. ARTPEC-6- and ARTPEC-7-based devices
DOCKER_BUILDKIT=1 docker build --build-arg ARCH=armv7hf -o type=local,dest=eap .
# 64-bit ARM, e.g. ARTPEC-8- and ARTPEC-9-based devices
DOCKER_BUILDKIT=1 docker build --build-arg ARCH=aarch64 -o type=local,dest=eap .
```

If you do have Podman but no `make` on your system:

```sh
# 32-bit ARM, e.g. ARTPEC-6- and ARTPEC-7-based devices
podman build --build-arg ARCH=armv7hf -o type=local,dest=eap .
# 64-bit ARM, e.g. ARTPEC-8- and ARTPEC-9-based devices
podman build --build-arg ARCH=aarch64 -o type=local,dest=eap .
```

## Running

Install the application like you normally do (e.g. in the target device's web UI).
It will automatically start running with the default options set in
[ptpd2.conf](ptpd2.conf). (More info about the configuration options can be
found in [ptpd2.conf (5)](https://www.systutorials.com/docs/linux/man/5-ptpd2.conf/).)

If you would like to alter the configuration, you will find it in the directory
`/usr/local/packages/ptpd2/` on the target device. Please edit it and then
restart the ACAP for the new changes to be used.

## License

[Apache 2.0](LICENSE)
