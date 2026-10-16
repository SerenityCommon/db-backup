#!/bin/sh
# Makes tiredofit/docker-alpine 7.10.31 buildable again. Pass its checkout directory.
#  - upx only shrinks binaries on x86_64, but aborts the build when an optional binary is missing
# Zabbix 7.2.6 sources are gone, so build with ZABBIX_VERSION=7.0.13 (the last 7.0 LTS that builds with the bundled Go 1.21).
set -e
dockerfile="${1:?usage: $0 <docker-alpine dir>}/Dockerfile"
sed -i.orig 's/x86_64) upx=upx ;;/x86_64) no_upx=true ;;/' "${dockerfile}"
rm -f "${dockerfile}.orig"
grep -q 'x86_64) no_upx=true ;;' "${dockerfile}"
