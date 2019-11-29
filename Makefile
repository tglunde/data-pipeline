## 
BUILD_TAG=tcsb-v1.0rc2
#BUILD_TAG=latest

all_docker_images: .Dockerfile.db2.$(BUILD_TAG).build

.Dockerfile.db2.$(BUILD_TAG).build: Dockerfile.db2 \
	ibm_data_server_runtime_client_linuxx64_v11.5.tar.gz \
	upload.sh db2*
	docker build -f Dockerfile.db2 -t ai-dw/db2:$(BUILD_TAG) .
	touch .Dockerfile.db2.$(BUILD_TAG).build

testrun:
	docker run -it --rm ai-dw/db2:$(BUILD_TAG) bash

clean:
	rm .Dockerfile*.build

