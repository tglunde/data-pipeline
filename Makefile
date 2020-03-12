## 
BUILD_TAG=tcsb-v1.3-SNAPSHOT
#BUILD_TAG=latest

all_docker_images: \
	.Dockerfile.db2.$(BUILD_TAG).build .Dockerfile.snowsql.$(BUILD_TAG).build \
	.Dockerfile.dwhgen.$(BUILD_TAG).build \
	.Dockerfile.jython.$(BUILD_TAG).build .Dockerfile.jython-dev.$(BUILD_TAG).build \
	.Dockerfile.jdba.$(BUILD_TAG).build

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

.Dockerfile.jython-dev.$(BUILD_TAG).build: Dockerfile.jython-dev 
	docker build -f Dockerfile.jython-dev -t ai-dw/jython-dev:$(BUILD_TAG) .
	touch .Dockerfile.jython-dev.$(BUILD_TAG).build

.Dockerfile.jython.$(BUILD_TAG).build: Dockerfile.jython 
	docker build -f Dockerfile.jython -t ai-dw/jython:$(BUILD_TAG) .
	touch .Dockerfile.jython.$(BUILD_TAG).build

.Dockerfile.jdba.$(BUILD_TAG).build: Dockerfile.jdba jdba-entrypoint.sh
	docker build -f Dockerfile.jdba -t ai-dw/jdba:$(BUILD_TAG) .
	touch .Dockerfile.jdba.$(BUILD_TAG).build

.Dockerfile.snowsql.$(BUILD_TAG).build: Dockerfile.snowsql
	gpg --keyserver hkp://keys.gnupg.net --recv-keys EC218558EABB25A1
	docker build -f Dockerfile.snowsql -t ai-dw/snowsql:$(BUILD_TAG) .
	touch .Dockerfile.snowsql.$(BUILD_TAG).build

testrun:
	#- docker run -it --rm ai-dw/db2:$(BUILD_TAG) bash
	#- docker run -it --rm ai-dw/snowsql:$(BUILD_TAG)
	- docker run -it --rm ai-dw/jdba:$(BUILD_TAG) bash

clean:
	rm .Dockerfile*.build

