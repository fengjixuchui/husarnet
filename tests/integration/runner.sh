#!/bin/bash
source $(dirname "$0")/../../util/bash-base.sh

# This file is intended to be run only from inside Docker!

if [ ${#} -ne 2 ]; then
    echo "Usage: runner.sh [test_platform] [test_file]"
    exit 1
fi

test_platform=${1}
test_file=${2}

echo "=== Running integration test === ${test_file} === on ${test_platform} ==="

case "${test_platform}" in
docker)
    apt update

    # Test prerequisites
    apt install -y --no-install-recommends --no-install-suggests \
        jq curl iputils-ping ca-certificates
    ;;

ubuntu | debian)
    apt update

    # Install Husarnet deb
    apt install -y --no-install-recommends --no-install-suggests \
        /app/build/release/husarnet-unix-amd64.deb

    # Test prerequisites
    apt install -y --no-install-recommends --no-install-suggests \
        jq curl iputils-ping ca-certificates
    ;;

fedora)
    # Install Husarnet rpm
    yum install -y \
        /app/build/release/husarnet-unix-amd64.rpm

    # Test prerequisites
    yum install -y \
        jq curl iputils hostname ca-certificates

    ;;

*)
    echo "Unknown test platform ${test_platform}!"
    exit 4
    ;;
esac

${tests_base}/integration/tests/${test_file}.sh
