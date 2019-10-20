FROM ubuntu:18.04

MAINTAINER Kyle Onda "kyle.onda@duke.edu"

# Silence debconf messages
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get -qq update && \
  apt-get -y install \
    byobu curl git htop man vim wget unzip \
    openjdk-8-jdk && \
  rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

# Install GraphDB-Free and clean up
RUN \
  curl -sS -o /tmp/graphdb.zip -L https://storage.cloud.google.com/graphdb_bucket_kso/graphdb-free-9/0/0-dist.zip?authuser-1 && \
  unzip /tmp/graphdb.zip -d /tmp && \
  mv /tmp/graphdb-free-9.0.0 /graphdb && \
  git clone -b develop --single-branch --depth=1 https://github.com/dhlab-basel/Knora.git /knora && \
  cp /knora/webapi/scripts/KnoraRules.pie /graphdb && \
  rm /tmp/graphdb.zip && \
  rm -rf /knora

# Set GraphDB Max and Min Heap size
ENV GDB_HEAP_SIZE="2g"

EXPOSE 7200
CMD ["/graphdb/bin/graphdb"]
