#!/usr/bin/env bash

set -e

ETCD_DISCOVERY=.etcd_discovery
GIT_CACHE_TIMEOUT=432000
SIZE=$1

if [ -z ${SIZE} ]
then
    echo "give a size"
    exit 1
else
    DISCOVERY_URL=$(curl -sL https://discovery.etcd.io/new?size=${SIZE})
fi

function go_to_dirname
{
    echo "Go to working directory..."
    cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    if [ $? -ne 0 ]
    then
        echo "go_to_dirname failed";
        exit 1
    fi
    echo "-> Current directory is" $(pwd)
}

function publish_discovery
{
    git config --global credential.helper "cache --timeout=${GIT_CACHE_TIMEOUT}"

    printf "${DISCOVERY_URL}" > ${ETCD_DISCOVERY}

    git add ${ETCD_DISCOVERY}
    git commit -m "New etcd discovery key of size=${SIZE}"
    git push origin master
}

function is_published
{
    until [ $(curl -sL https://raw.githubusercontent.com/JulienBalestra/coreos_deploy/master/.etcd_discovery) == \
           ${DISCOVERY_URL} ]
    do
        echo "Target NOT up to date" >&2
        sleep 5
    done
}

function poller
{
    printf "\n${DISCOVERY_URL}\n"
    printf "\ncurl -Ls \'${DISCOVERY_URL}?wait=true&recursive=true\'"
    printf "\nPolling... SIGINT to leave\n"

    START=$(date +"%s")
    date +"%T"
    echo "---"

    until QUERY=$(curl -Ls "${DISCOVERY_URL}") &&
        RET=$(echo ${QUERY} | jq ".node.nodes | length == ${SIZE}") &&
        ${RET}
    do
        CURRENT=$(echo ${QUERY} | jq ".node.nodes | length")
        echo "${CURRENT}/${SIZE}" $(( $(date +"%s")-${START} ))
        printf "\n"
        curl -Ls "${DISCOVERY_URL}?wait=true&recursive=true"
    done

    printf "\n"
    echo ${QUERY} | jq .
    echo "Seconds needed:" $(( $(date +"%s")-${START} ))
}

go_to_dirname
publish_discovery
is_published
poller