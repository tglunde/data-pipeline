## 
BUILD_TAG=tcsb-v0.2rc

all_docker_images: .Dockerfile.db2.build

.Dockerfile.db2.build: Dockerfile.db2 \
	ibm_data_server_runtime_client_linuxx64_v11.5.tar.gz \
	upload.sh db2*
	docker build -f Dockerfile.db2 -t ai-dw/db2:$(BUILD_TAG) .
	touch .Dockerfile.db2.build

testrun:
	docker run -it --rm ai-dw/db2:$(BUILD_TAG) bash

clean:
	rm .Dockerfile*.build

