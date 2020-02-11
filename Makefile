## 
BUILD_TAG=tcsb-v1.1-SNAPSHOT
#BUILD_TAG=latest

all_docker_images: .Dockerfile.db2.$(BUILD_TAG).build .Dockerfile.snowsql.$(BUILD_TAG).build .Dockerfile.dwhgen.$(BUILD_TAG).build

.Dockerfile.db2.$(BUILD_TAG).build: Dockerfile.db2 \
	ibm_data_server_runtime_client_linuxx64_v11.5.tar.gz \
	db2-entrypoint.sh \
	upload.sh db2*
	docker build -f Dockerfile.db2 -t ai-dw/db2:$(BUILD_TAG) .
	touch .Dockerfile.db2.$(BUILD_TAG).build

.Dockerfile.dwhgen.$(BUILD_TAG).build: Dockerfile.dwhgen \
	dwhgen-entrypoint.sh 
	docker build -f Dockerfile.dwhgen -t ai-dw/dwhgen:$(BUILD_TAG) .
	touch .Dockerfile.dwhgen.$(BUILD_TAG).build

.Dockerfile.snowsql.$(BUILD_TAG).build: Dockerfile.snowsql
	docker build -f Dockerfile.snowsql -t ai-dw/snowsql:$(BUILD_TAG) .
	touch .Dockerfile.snowsql.$(BUILD_TAG).build

testrun:
	docker run -it --rm ai-dw/db2:$(BUILD_TAG) bash
	docker run -it --rm ai-dw/snowsql:$(BUILD_TAG) bash

clean:
	rm .Dockerfile*.build

