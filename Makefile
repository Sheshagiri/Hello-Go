CURDIR:=$(shell pwd)
SVCMAJORVERSION=1
SVCMINORVERSION=0
SVCPATCHVERSION=0
RELEASE=${SVCMAJORVERSION}.${SVCMINORVERSION}.${SVCPATCHVERSION}
#DOCKER_REGISTRY=127.0.0.1:5000
DOCKER_REGISTRY=quay.io/sheshagiri0
SVCAPPNAME=hello-go
SVCNAME=${SVCAPPNAME}-${SVCMAJORVERSION}-${SVCMINORVERSION}

#ifeq ($(bamboo_buildNumber), )
#	BUILDNUMBER=0
#else
#	BUILDNUMBER=$(bamboo_buildNumber)
#endif
BUILDNUMBER = 112

VERSION=${RELEASE}-${BUILDNUMBER}

generatek8yaml:
	@mkdir -p pkg/deploy/kubernetes
	m4 -DSVCAPPNAME=${SVCAPPNAME} -DSVCNAME=${SVCNAME} -DSVCFULLVERSION=${VERSION} -DSVCRELEASEVERSION=${RELEASE} deploy/kubernetes/hello-go.yaml.m4 > pkg/deploy/kubernetes/hello-go.yaml

updatek8yaml:
	m4 -DSVCAPPNAME=${SVCAPPNAME} -DSVCNAME=${SVCNAME} -DSVCFULLVERSION=${VERSION} -DSVCRELEASEVERSION=${RELEASE} deploy/kubernetes/hello-go.yaml.m4 > deploy/kubernetes/hello-go.yaml

test:
	#cd ${CURDIR};go test -v $(shell go list ./... | grep -v /vendor/) -cover

clean:
	cd ${CURDIR}
	rm -f deploy/kubernetes/hello-go.yaml ${SVCAPPNAME}
	rm -rf  pkg/

build:
	cd ${CURDIR};CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ${SVCAPPNAME}

dockerbuild: build
	 docker build -t ${SVCAPPNAME}:${VERSION} .

docker: dockerbuild
	docker tag ${SVCAPPNAME}:${VERSION} ${DOCKER_REGISTRY}/${SVCAPPNAME}:${VERSION}
	docker push ${DOCKER_REGISTRY}/${SVCAPPNAME}:${VERSION}

docker-tar: test dockerbuild generatek8yaml
	docker save -o pkg/${SVCAPPNAME}-${VERSION}.tar  ${SVCAPPNAME}:${VERSION}

dockerk8: docker updatek8yaml
