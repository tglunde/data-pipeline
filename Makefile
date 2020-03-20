## 
#BUILD_TAG=tcsb-v1.0rc2
BUILD_TAG=latest

all_docker_images: \
	.Dockerfile.db2.$(BUILD_TAG).build \
	.Dockerfile.dwhgen.$(BUILD_TAG).build \
	.Dockerfile.mssql.$(BUILD_TAG).build \
	.Dockerfile.s5.$(BUILD_TAG).build

#	.Dockerfile.snowsql.$(BUILD_TAG).build \
#	.Dockerfile.dbunit.$(BUILD_TAG).build \
#	.Dockerfile.flyway.$(BUILD_TAG).build \
#	.Dockerfile.psql.$(BUILD_TAG).build \
#

.Dockerfile.db2.$(BUILD_TAG).build: Dockerfile.db2 \
	ibm_data_server_runtime_client_linuxx64_v11.5.tar.gz \
	upload.sh db2* *sh projbin/*
	docker build -f Dockerfile.db2 -t ai-dw/db2:$(BUILD_TAG) .
	touch .Dockerfile.db2.$(BUILD_TAG).build

.Dockerfile.dwhgen.$(BUILD_TAG).build: Dockerfile.dwhgen \
	terraform-bundle.hcl
	docker build -f Dockerfile.dwhgen -t ai-dw/dwhgen:$(BUILD_TAG) .
	touch .Dockerfile.dwhgen.$(BUILD_TAG).build

.Dockerfile.mssql.$(BUILD_TAG).build: Dockerfile.mssql \
       upload.sh mssql*	
	docker build -f Dockerfile.mssql -t ai-dw/mssql:$(BUILD_TAG) .
	touch .Dockerfile.mssql.$(BUILD_TAG).build

.Dockerfile.s5.$(BUILD_TAG).build: Dockerfile.s5
	docker build -f Dockerfile.s5 -t ai-dw/s5:$(BUILD_TAG) .
	touch .Dockerfile.s5.$(BUILD_TAG).build

testrun:
	docker run -it --rm ai-dw/db2:$(BUILD_TAG) bash

clean:
	rm .Dockerfile*.build

