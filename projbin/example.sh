#!/bin/sh

# vault specific
export SALT=0e4b4369-7c0f-4cb3-ae45-61966c756402
export BUCKET=tuid-dv01-s3-kampdb

# content specific
export RTE=P
export PROFILENAME=KampDB

###
### usage example
###
#
## prepare essential environment variables
## better: do not source hardcoded variables but do one of following
## a) define as context, when running the container
## b) source from a file in /root/.projenv/
## preferable in the entrypoint script 
# source /projbin/example.sh  

## add or update some credentials (user/login) with key P & snowflake (RTE / profilename)
# PROFILENAME=snowflake CREDUSER=snow CREDPWD=ichbineineschneeflocke /projbin/updatevault
## dump vault
# s3cmd get s3://${BUCKET}/${SALT} - | /projbin/dec $SALT

