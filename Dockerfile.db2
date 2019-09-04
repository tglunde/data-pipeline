FROM ubuntu:latest

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y sudo libxml2 file libnuma1 libaio1 sharutils binutils libstdc++6:i386 libpam0g:i386 && ln -s /lib/i386-linux-gnu/libpam.so.0 /lib/libpam.so.0

RUN useradd -m -d /home/db2clnt -s /bin/bash -U --uid 1000 db2clnt 

# Install DB2
RUN mkdir /install
# Copy DB2 tarball - ADD command will expand it automatically
ADD ibm_data_server_runtime_client_linuxx64_v11.5.tar.gz /install/
# Copy response file
COPY  db2rtcl.rsp /install/
# Run  DB2 silent installer
RUN /install/rtcl/db2setup -r /install/db2rtcl.rsp
ADD db2.sh /
RUN chmod a+x db2.sh
ENV DB2_COMMAND='select 1'
CMD /db2.sh