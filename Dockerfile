ARG osversion=xenial
FROM ubuntu:${osversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}

LABEL maintainer="frank.foerster@ime.fraunhofer.de" \
      description="Dockerfile providing the BUSCO software package" \
      version=${VERSION} \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.vcs-url="https://github.com/greatfireball/ime_busco.git"

WORKDIR /opt

# Install required packages
RUN apt-get update && \
    apt-get install --yes \
            build-essential \
	    wget \
	    git \
	    autoconf && \
    apt-get install --yes \
	    libboost-iostreams-dev \
	    zlib1g-dev \
	    libgsl-dev \
	    libboost-graph-dev \
	    libsuitesparse-dev \
	    liblpsolve55-dev \
	    libsqlite3-dev \
	    libmysql++-dev \
	    libbamtools-dev \
	    libboost-all-dev && \
    apt-get install --yes \
	    libbz2-dev \
	    liblzma-dev \
	    libncurses5-dev && \
    apt-get install --yes \
	    libssl-dev \
	    libcurl3-dev && \
    git clone https://github.com/samtools/htslib.git /root/htslib && \
    cd "/root/htslib" && \
    autoheader && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    git clone https://github.com/samtools/bcftools.git /root/bcftools && \
    cd "/root/bcftools" && \
    autoheader && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    git clone https://github.com/samtools/samtools.git /root/samtools && \
    cd "/root/samtools" && \
    autoheader && \
    autoconf -Wno-syntax && \
    ./configure && \
    make && \
    make install

ENV TOOLDIR="/root"

# Clone AUGUSTUS repository
RUN git clone https://github.com/Gaius-Augustus/Augustus.git /root/augustus && \
    cd /root/augustus && \
    git checkout 3.3.2 && \
    rm -rf /root/augustus/.git && \
    mkdir -p /root/augustus/bin && \
    cd "/root/augustus/auxprogs/bam2wig" && \
    make && \
    cd "/root/augustus" && \
    make && \
    make install && \
    make test

ENV PATH "$PATH:/root/augustus/"

VOLUME /data
WORKDIR /data
