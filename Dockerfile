ARG ARCH=armv7hf
ARG SDK_VERSION=1.15
ARG SDK_IMAGE=docker.io/axisecp/acap-native-sdk
ARG PTPD_VERSION=2.3.1
ARG STAGE_DIR=/stage

FROM $SDK_IMAGE:$SDK_VERSION-$ARCH AS builder
ARG PTPD_VERSION
ARG SRC_DIR=/usr/local/src
ARG PTP_DIR=$SRC_DIR/ptpd-$PTPD_VERSION
ARG STAGE_DIR
# Get source code
WORKDIR $SRC_DIR
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -L http://downloads.sourceforge.net/project/ptpd/ptpd/$PTPD_VERSION/ptpd-$PTPD_VERSION.tar.gz | tar xz
WORKDIR $PTP_DIR
# Cross compile for our target
RUN . /opt/axis/acapsdk/environment-setup* && \
    ac_cv_func_malloc_0_nonnull=yes ./configure --host=arm --with-pcap-config=pkg-config --disable-snmp && \
    make -j install && \
    $STRIP /usr/local/sbin/ptpd2
# Package ACAP
WORKDIR "$STAGE_DIR"
RUN cp /usr/local/sbin/ptpd2 . && \
    cp $PTP_DIR/COPYRIGHT LICENSE && \
    echo 'all:' > Makefile
COPY manifest.json \
     ptpd2.conf \
     ./
RUN . /opt/axis/acapsdk/environment-setup* && \
    acap-build -a ptpd2 -a ptpd2.conf .

FROM scratch
ARG STAGE_DIR
COPY --from=builder "$STAGE_DIR"/*eap "$STAGE_DIR"/*LICENSE.txt /
