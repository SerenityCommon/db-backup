#!/usr/bin/env bash
# Builds the db-backup image together with its base image, since tiredofit/alpine was removed from Docker Hub.
#   IMAGE=ghcr.io/me/db-backup:4.1.101 PLATFORM=linux/amd64 ./build.sh
set -euo pipefail

IMAGE=${IMAGE:-db-backup:4.1.101}
PLATFORM=${PLATFORM:-}
BASE_REF=${BASE_REF:-7.10.31}
ALPINE_VERSION=${ALPINE_VERSION:-3.21}
BASE_IMAGE=${BASE_IMAGE:-db-backup-base:${ALPINE_VERSION}-${BASE_REF}}

cd "$(dirname "$0")"
platform_arg=()
if [ -n "${PLATFORM}" ]; then platform_arg=(--platform "${PLATFORM}"); fi

if ! docker image inspect "${BASE_IMAGE}" > /dev/null 2>&1; then
    work=$(mktemp -d)
    trap 'rm -rf "${work}"' EXIT
    git clone --depth 1 --branch "${BASE_REF}" https://github.com/tiredofit/docker-alpine.git "${work}/docker-alpine"
    docker build "${platform_arg[@]}" --build-arg ALPINE_VERSION="${ALPINE_VERSION}" -t "${BASE_IMAGE}" "${work}/docker-alpine"
fi

docker build "${platform_arg[@]}" --build-arg BASE_IMAGE="${BASE_IMAGE}" -t "${IMAGE}" .
echo "Built ${IMAGE}"
