FROM ubuntu:20.04 AS base

# Install packages
FROM base as builder

RUN apt-get update && \
RUN apt-get install -y \
    bzip2 \
    gcc \
    make \
    uuid-runtime \ 
    which \
    gperf \
    diffutils \
    gcc-multilib \ 
    libpng-dev \ 
    uuid-dev \ 
    libxml2-dev \ 
RUN apt-get clean \
RUN rm -rf /var/lib/apt/lists/*

# Download, build and install the FreeType package
FROM builder as freetype

ARG FREETYPE_URL=http://download.savannah.gnu.org/releases/freetype
ARG FREETYPE_VERSION=2.4.7

COPY cache/freetype-*.tar.bz2 .optional /tmp/

RUN \
    if [[ ! -f "/tmp/freetype-${FREETYPE_VERSION}.tar.bz2" ]]; then \
        curl \
            --location \
            --output "/tmp/freetype-${FREETYPE_VERSION}.tar.bz2" \
            "${FREETYPE_URL}/freetype-${FREETYPE_VERSION}.tar.bz2"; \
    fi && \
    mkdir -p /tmp/freetype /usr/local/include/freetype2/freetype/internal && \
    tar \
        --strip-components=1 \
        --directory=/tmp/freetype/ \
        --extract \
        --verbose \
        --file=/tmp/freetype-${FREETYPE_VERSION}.tar.bz2 \
        && \
    cd /tmp/freetype && \
    ./configure \
        --build=i686-pc-linux-gnu \
        --prefix=/usr/local/ \
        --disable-static \
        CFLAGS="-m32" \
        CXXFLAGS="-m32" \
        LDFLAGS="-m32" \
        && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/freetype*

# Download, build and install the FontConfig package
FROM builder as fontconfig

ARG FONTCONFIG_URL=https://www.freedesktop.org/software/fontconfig/release
ARG FONTCONFIG_VERSION=2.12.4

COPY --from=freetype /usr/local /usr/local/
COPY cache/fontconfig-*.tar.bz2 .optional /tmp/

RUN \
    if [[ ! -f "/tmp/fontconfig-${FONTCONFIG_VERSION}.tar.bz2" ]]; then \
        curl \
            --location \
            --output "/tmp/fontconfig-${FONTCONFIG_VERSION}.tar.bz2" \
            "${FONTCONFIG_URL}/fontconfig-${FONTCONFIG_VERSION}.tar.bz2"; \
    fi && \
    mkdir -p /tmp/fontconfig && \
    tar \
        --strip-components=1 \
        --directory=/tmp/fontconfig/ \
        --extract \
        --verbose \
        --file=/tmp/fontconfig-${FONTCONFIG_VERSION}.tar.bz2 \
        && \
    cd /tmp/fontconfig && \
    ./configure \
        --build=i686-pc-linux-gnu \
        --prefix=/usr/local/ \
        --enable-libxml2 \
        --disable-static \
        --disable-docs \
        CFLAGS="-m32" \
        CXXFLAGS="-m32" \
        LDFLAGS="-m32" \
        FREETYPE_LIBS="-L/usr/local/lib -lfreetype" \
        FREETYPE_CFLAGS="-I/usr/local/include -I/usr/local/include/freetype2" \
        && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/fontconfig*

# Download, build and install the ModelSim Intel FPGA Edition
FROM base as modelsim

ARG MODELSIM_INTEL_URL=http://download.altera.com/akdlm/software/acdsinst
ARG MODELSIM_INTEL_VERSION=19.1.0.670

COPY cache/ModelSim*Setup-*-linux.run .optional /tmp/

RUN \
    if ! ls /tmp/[Mm]odel[Ss]im* >/dev/null 2>&1; then \
        NAME="ModelSimSetup-${MODELSIM_INTEL_VERSION}-linux.run" && \
        MAJOR=$(echo "$MODELSIM_INTEL_VERSION" | cut -d '.' -f 1) && \
        MINOR=$(echo "$MODELSIM_INTEL_VERSION" | cut -d '.' -f 2) && \
        BUILD=$(echo "$MODELSIM_INTEL_VERSION" | cut -d '.' -f 4) && \
        URL="${MODELSIM_INTEL_URL}/${MAJOR:-0}.${MINOR:-0}std/${BUILD:-0}" && \
        URL="${URL}/ib_installers" && \
        curl \
            --location \
            --output /tmp/${NAME} \
            "${URL}/${NAME}"; \
    fi && \
    for run in $(ls /tmp/ModelSim*Setup-*-linux.run 2>/dev/null || true); do \
        chmod a+x "$run" && \
        $run \
            --unattendedmodeui minimal \
            --mode unattended \
            --installdir /opt/ \
            --accept_eula 1 \
            --modelsim_edition modelsim_ase; \
    done && \
    \
    if [[ -d /opt/modelsim_ae ]]; then \
        mv /opt/modelsim_ae /opt/modelsim; \
    fi && \
    \
    if [[ -d /opt/modelsim_ase ]]; then \
        mv /opt/modelsim_ase /opt/modelsim; \
    fi && \
    \
    if [[ -d /opt/modelsim/altera ]]; then \
        mv /opt/modelsim/altera /opt/altera; \
    fi && \
    \
    sed \
        --in-place \
        '/^\[msg_system\]$/a suppress = 3116' \
        /opt/modelsim/modelsim.ini \
        && \
    cd /opt/modelsim && ln -s linux linux_rh60 && cd - && \
    cd /opt/modelsim && ln -s linux linuxpe && cd - && \
    rm -rf \
        /opt/{logs,uninstall} \
        /opt/modelsim/{examples,docs} \
        /tmp/ModelSim*Setup-*-linux.run

# Build minimal image
FROM base AS minimal

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

# Build-time metadata as defined at http://label-schema.org
LABEL \
    maintainer="tymoteusz.blazejczyk@tymonx.com" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="tymonx/modelsim" \
    org.label-schema.description="A Docker image with the ModeSim HDL simulator" \
    org.label-schema.usage="https://gitlab.com/tymonx/docker-modelsim/README.md" \
    org.label-schema.url="https://gitlab.com/tymonx/docker-modelsim" \
    org.label-schema.vcs-url="https://gitlab.com/tymonx/docker-modelsim" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vendor="tymonx" \
    org.label-schema.version=$VERSION \
    org.label-schema.docker.cmd=\
"docker run --rm --user $(id -u):$(id -g) --volume $(pwd):$(pwd) --workdir $(pwd) --entrypoint /bin/bash registry.gitlab.com/tymonx/docker-modelsim"

ENV \
    HOME=/home/modelsim \
    PATH=/opt/modelsim/bin:${PATH} \
    FONTCONFIG_PATH=/usr/local/etc/fonts \
    FONTCONFIG_FILE=/usr/local/etc/fonts/fonts.conf \
    MTI_VCO_MODE=32

RUN apt-get update && \
    apt-get install -y \
        libc6:i386 \
        libx11-6:i386 \
        libxft2:i386 \
        libxext6:i386 \
        libxml2:i386 \
        libncurses5:i386 \ 
        libncurses5:i386 \ 
        && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/usr-local-lib.conf && \
    ldconfig && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd \
        --user-group \
        --no-log-init \
        --create-home \
        --shell /bin/bash \
        modelsim \
        && \
    chmod 777 /home/modelsim

COPY --from=freetype /usr/local /usr/local/
COPY --from=fontconfig /usr/local /usr/local/
COPY --from=modelsim /opt/modelsim /opt/modelsim/

WORKDIR /home/modelsim

# Build final image
FROM minimal

ENV DEBIAN_FRONTEND=noninteractive

ARG MIRROR=http://download.altera.com/akdlm/software/acdsinst/16.1/196/ib_installers/
ARG QUARTUS=QuartusLiteSetup-16.1.0.196-linux.run
ARG QUARTUS_UPDATE=QuartusSetup-16.1.2.203-linux.run
ARG DEVICE_FILES="cyclonev-16.1.0.196.qdz cyclone-16.1.0.196.qdz"

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install --no-install-recommends -y \
        ca-certificates \
        lib32ncurses5-dev \
        libc6:i386 \
        libcrypto++9v5 \
        libfontconfig1 \
        libglib2.0-0 \
        libncurses5:i386 \
        libsm6 \
        libssl-dev \
        libstdc++6:i386 \
        libxext6:i386 \
        libxft2:i386 \
        libxrender1 \
        libzmq3-dev \
        locales \
        make \
        openjdk-8-jdk \
        pkg-config \
        unixodbc-dev \
        wget \
        xauth \
        xvfb

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN cd /tmp && wget -q $MIRROR$QUARTUS && \
        wget -q $MIRROR$QUARTUS_UPDATE && \
        chmod +x $QUARTUS_UPDATE && \
        for DEV_FILE in $DEVICE_FILES; do wget -q $MIRROR$DEV_FILE; done && \
        chmod +x $QUARTUS && \
        ./$QUARTUS --mode unattended --installdir /opt/altera/ && \
        rm /tmp/* /opt/altera/uninstall -rf
# These files conflict with the Ubuntu versions and cause random segfaults.
RUN rm /opt/altera/quartus/linux64/libccl_curl_drl.so \
        /opt/altera/quartus/linux64/libcrypto.so.1.0.0 \
        /opt/altera/quartus/linux64/libcurl.so.4 \
        /opt/altera/quartus/linux64/libssl.so.1.0.0
COPY --from=modelsim /opt/altera /opt/modelsim/altera/

