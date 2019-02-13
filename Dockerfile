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
ENV TOOLDIR="/root"

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
    make install && \
    git clone https://github.com/Gaius-Augustus/Augustus.git /root/augustus && \
    cd /root/augustus && \
    git checkout 3.3.2 && \
    rm -rf /root/augustus/.git && \
    mkdir -p /root/augustus/bin && \
    cd "/root/augustus/auxprogs/bam2wig" && \
    make && \
    cd "/root/augustus" && \
    make && \
    make install && \
    apt remove --yes \
	build-essential \
	wget \
	git \
	autoconf \
	libboost-iostreams-dev \
	zlib1g-dev \
	libgsl-dev \
	libboost-graph-dev \
	libsuitesparse-dev \
	liblpsolve55-dev \
	libsqlite3-dev \
	libmysql++-dev \
	libbamtools-dev \
	libboost-all-dev \
	libbz2-dev \
	liblzma-dev \
	libncurses5-dev \
	libssl-dev \
	libcurl3-dev && \
    apt autoremove --yes && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    cp -R /root/augustus/examples /tmp/ && \
    rm -rf /root/bcftools /root/samtools /root/htslib /root/augustus && \
    augustus --species=human --UTR=on /tmp/examples/example.fa

# install ncbi-blast+ and hmmer
RUN apt update && \
    apt install --yes \
	ncbi-blast+ \
	hmmer && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Install BUSCO
RUN apt update && \
    apt install --yes \
	git \
	python3 && \
    git clone https://gitlab.com/ezlab/busco.git /opt/busco && \
    cd /opt/busco && \
    git checkout 3.0.2 && \
    rm -rf .git && \
    python setup.py install && \
    apt remove --yes \
	git && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Generate a config file
WORKDIR /opt/busco/config
RUN sed 's#/home/osboxes/BUSCOVM/augustus/augustus-3.2.2#'$(dirname $(dirname $(readlink -f $(which augustus))))'#; s#/home/osboxes/BUSCOVM/hmmer/hmmer-3.1b2-linux-intel-ia32/binaries/#'$(dirname $(which hmmsearch))'#' config.ini.default >config.ini

ENV AUGUSTUS_CONFIG_PATH=/opt/augustus-3.3.2/config
ENV PATH=${PATH}:/opt/busco/scripts

# Test the BUSCO installation
WORKDIR /opt/busco
RUN ./scripts/run_BUSCO.py --in sample_data/target.fa --out TEST --lineage_path sample_data/example --mode genome && diff -u -I '#.*' sample_data/run_SAMPLE/short_summary_SAMPLE.txt run_TEST/short_summary_TEST.txt && diff -u -I '#.*' sample_data/run_SAMPLE/missing_busco_list_SAMPLE.tsv run_TEST/missing_busco_list_TEST.tsv && diff -u -I '#.*' sample_data/run_SAMPLE/full_table_SAMPLE.tsv run_TEST/full_table_TEST.tsv

VOLUME /data
WORKDIR /data

ENTRYPOINT ["run_BUSCO.py"]
