FROM ubuntu:16.04

LABEL org.label-schema.license="MIT" \
      org.label-schema.vendor="NGS Bioinformatics Course: Scaling Things Up" \
      maintainer="Sean Laidlaw <sean.laidlaw@sanger.ac.uk>"


# Install what we can with apt
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y python && \
    apt-get install -y wget \
    curl \
    bc \
    unzip \
    less \
    bedtools \
    zlib1g-dev \
    libbz2-dev \
    libncurses5-dev \
    libncursesw5-dev \
    liblzma-dev \
    gcc \
    make \
    libcurl4-openssl-dev \
    libssl-dev \
    bwa \
    openjdk-8-jdk \
    tabix \
    software-properties-common && \
    apt-get -y clean  && \
    apt-get -y autoclean  && \
    apt-get -y autoremove

# Install htslib
ADD https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 /usr/local/htslib.tar.bz2
RUN tar xvjf /usr/local/htslib.tar.bz2 -C /usr/local/ \
     && chmod 777 -R /usr/local/htslib-1.9 \
     && cd /usr/local/htslib-1.9 \
     && ./configure \
     && make \
     && make install \
     && rm /usr/local/htslib.tar.bz2

# Install samtools
ADD https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 /usr/local/samtools.tar.bz2
RUN tar xvjf /usr/local/samtools.tar.bz2 -C /usr/local/ \
     && chmod 777 -R /usr/local/samtools-1.9 \
     && cd /usr/local/samtools-1.9 \
     && ./configure \
     && make \
     && make install \
     && rm /usr/local/samtools.tar.bz2
     

# Install trimmomatic
RUN mkdir -p /home/software/trimmomatic && \
	cd /home/software/trimmomatic && \
	wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip && \
	unzip Trimmomatic-0.39.zip && \
	cd Trimmomatic-0.39 && \
	echo "alias trimmomatic=\"java -jar $(pwd)/trimmomatic-0.39.jar\"" >> ~/.bashrc



# Install picardtools
RUN mkdir -p /home/software/picard && \
	cd /home/software/picard && \
	wget https://github.com/broadinstitute/picard/releases/download/2.20.8/picard.jar && \
	echo "alias picard=\"java -jar $(pwd)/picard.jar\"" >> ~/.bashrc


# Install GATK
RUN mkdir -p /home/software/gatk && \
	cd /home/software/gatk && \
	wget https://github.com/broadinstitute/gatk/releases/download/4.1.3.0/gatk-4.1.3.0.zip && \
	unzip gatk-4.1.3.0.zip && \
	echo "alias gatk=\"/home/software/gatk/gatk-4.1.3.0/gatk\"" >> ~/.bashrc


# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]

ENV JAVA_LIBRARY_PATH /usr/lib/jni
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

