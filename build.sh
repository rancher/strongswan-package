#!/bin/bash
set -e

mkdir -p dist/artifacts

VERSION="5.3.5"
PACKAGE="-3"

docker build --build-arg VERSION=${VERSION} -t strongswan-build .
docker run --rm strongswan-build cat strongswan-${VERSION}.tar.gz > dist/artifacts/strongswan-${VERSION}${PACKAGE}.tar.gz
