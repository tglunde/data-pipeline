FROM ubuntu:latest AS db2base

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y gosu sudo libxml2 file libnuma1 libaio1 sharutils binutils libstdc++6:i386 libpam0g:i386 \
	python python-pip pass parallel pigz vim unzip ksh && \
  ln -s /lib/i386-linux-gnu/libpam.so.0 /lib/libpam.so.0

RUN useradd -m -d /home/db2clnt -s /bin/bash -U --uid 1000 db2clnt 

FROM db2base AS db2compile
# Install DB2
RUN mkdir /install
# Copy DB2 tarball - ADD command will expand it automatically
ADD ibm_data_server_driver_package_linuxx64_v11.5.tar.gz /install/
# Copy response file
COPY  db2rtcl.rsp /install/
# Run  DB2 silent installer

RUN /install/rtcl/db2setup -r /install/db2rtcl.rsp

# install go
ENV GOLANG_VERSION=1.14
RUN apt-get install -y wget
#RUN bin/sh -c set -eux \
#	wget -O go.tgz "https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz" 

COPY go.tgz go.sha256sum /

RUN bin/sh -c set -eux \
 	sha256sum -c go.sha256sum ; \
 	tar -C / -xzf go.tgz 

#	rm go.tgz -- this is a build image anyway


FROM db2base
COPY --from=db2compile /opt/ibm/db2 /opt/ibm/db2
COPY --from=db2compile /home/db2clnt /home/db2clnt
COPY --from=db2compile /go /usr/local/go

RUN export PATH="/usr/local/go/bin:$PATH" ; go version

ENV GOPATH=/go
ENV PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mkdir -p "$GOPATH/src" && mkdir -p "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN /install/dsdriver/installDSDriver

ADD db2_exec upload*.sh /home/db2clnt/
RUN chmod 755 /home/db2clnt/upload*.sh; chmod 755 /home/db2clnt/db2_exec; chown db2clnt /home/db2clnt/*

# install python based software
RUN pip install awscli
RUN pip install ibm_db==3.0.1

# s5cmd 
RUN apt-get install -y git
RUN go get -u github.com/peakgames/s5cmd

#RUN pip install jaydebeapi 


# entrypoint
COPY db2-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
# projbin
ADD projbin /projbin

# 
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "/home/db2clnt/db2_exec" ] 
