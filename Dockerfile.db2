FROM ubuntu:latest

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y gosu sudo libxml2 file libnuma1 libaio1 sharutils binutils libstdc++6:i386 libpam0g:i386 python python-pip pass parallel pigz vim && \
  ln -s /lib/i386-linux-gnu/libpam.so.0 /lib/libpam.so.0

RUN useradd -m -d /home/db2clnt -s /bin/bash -U --uid 1000 db2clnt 

# Install DB2
RUN mkdir /install
# Copy DB2 tarball - ADD command will expand it automatically
ADD ibm_data_server_runtime_client_linuxx64_v11.5.tar.gz /install/
# Copy response file
COPY  db2rtcl.rsp /install/
# Run  DB2 silent installer
RUN /install/rtcl/db2setup -r /install/db2rtcl.rsp
ADD db2_exec upload*.sh /home/db2clnt/
RUN chmod 755 /home/db2clnt/upload*.sh; chmod 755 /home/db2clnt/db2_exec; chown db2clnt /home/db2clnt/*

# install python based software
#RUN pip install s4cmd==2.1.0
RUN pip install s3cmd==2.0.2 
RUN pip install awscli



# entrypoint
COPY db2-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
# projbin
ADD projbin /projbin

# 
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "/home/db2clnt/db2_exec" ] 
