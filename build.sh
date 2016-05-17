#!/bin/bash
set -e

rm -rf dist
mkdir -p dist/artifacts

VERSION="v5.4.0-rancher-1"
PACKAGE="-1"

docker build --build-arg VERSION=${VERSION} -t strongswan-build .
docker run --rm strongswan-build cat strongswan-${VERSION}.tar.gz > dist/artifacts/strongswan-${VERSION}${PACKAGE}.tar.gz
