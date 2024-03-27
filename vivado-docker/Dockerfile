FROM ubuntu:22.04

# local name of xilinx installer
ARG HOST_TOOL_ARCHIVE_NAME

# where to install xilinx to on image
ARG XILINX_INSTALL_LOCATION
ENV XILINX_INSTALL_LOCATION=$XILINX_INSTALL_LOCATION

ENV DEBIAN_FRONTEND=noninteractive

# it seems like this reconfigures /bin/sh (dash) to /bin/bash (bash)
# presumably there might some legacy vivado stuff that uses /bin/sh
# https://superuser.com/questions/715722/how-to-do-dpkg-reconfigure-dash-as-bash-automatically
RUN echo "dash dash/sh boolean false" | debconf-set-selections 
RUN DEBIAN_FRONTEND=$DEBIAN_FRONTEND dpkg-reconfigure dash

# get all dependencies
RUN apt-get update
RUN apt-get install -y \
		locales-all \
		locales \
	  	tofrodos \
	  	iproute2 \
		gawk \
		xvfb \
		git \
		make \
		net-tools \
		libncurses5-dev \
	  	update-inetd \
	  	tftpd \
		zlib1g-dev \
	  	libssl-dev \
	  	flex \
	  	bison \
	  	libselinux1 \
	  	gnupg \
	  	wget \
		diffstat \
		chrpath \
		socat \
		xterm \
		autoconf \
		libtool \
		libtool-bin \
		tar \
	  	unzip \
	  	texinfo \
		zlib1g-dev \
		gcc-multilib \
		build-essential \
		libsdl1.2-dev \
		libglib2.0-dev \
		screen \
		pax \
		gzip \
		python3-gi \
		less \
		lsb-release \
		fakeroot \
		libgtk2.0-0 \
		libgtk2.0-dev \
		cpio \
		rsync \
		xorg \
		expect \
		dos2unix \
        google-perftools \
        default-jre \
        libtinfo5

# set locals
ENV LANG="en_US.utf8"
ENV LANGUAGE="en_US.utf8"
ENV LC_ALL="en_US.utf8"
RUN locale-gen --purge en_US.UTF-8 \
    && update-locale LANG=$LANG LANGUAGE=$LANGUAGE 

# Copy archive into the container
RUN mkdir -p $XILINX_INSTALL_LOCATION/tmp
COPY $HOST_TOOL_ARCHIVE_NAME $XILINX_INSTALL_LOCATION/tmp
COPY install_config.txt $XILINX_INSTALL_LOCATION/tmp

# Unpack the archive locally.
RUN cd $XILINX_INSTALL_LOCATION/tmp \
	&& tar -xzf $(basename $HOST_TOOL_ARCHIVE_NAME) \
	&& cd "$XILINX_INSTALL_LOCATION/tmp/`basename --suffix=.tar.gz $HOST_TOOL_ARCHIVE_NAME`"

# Run the installer
RUN cd "$XILINX_INSTALL_LOCATION/tmp/`basename --suffix=.tar.gz $HOST_TOOL_ARCHIVE_NAME`" \
    &&./xsetup --config $XILINX_INSTALL_LOCATION/tmp/install_config.txt \
		--batch Install \
		--location /opt/Xilinx \
		--agree XilinxEULA,3rdPartyEULA \
	&& rm -fr $XILINX_INSTALL_LOCATION/tmp/*


