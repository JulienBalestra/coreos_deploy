#!/usr/bin/env bash

set -e

TARGET=http://coreos-deploy.s3-website-eu-west-1.amazonaws.com/discovery_etcd.json
BUCKET="coreos-deploy"
SIZE=$1
TS=$(date +"%s")

if [ -z ${SIZE} ]
then
    echo "give a size"
    exit 1
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
    docker run --rm docker run --rm \
    -e AWS_ID=${AWS_ID} -e AWS_SECRET=${AWS_SECRET} \
    julienbalestra/coreos_publisher ${SIZE} ${BUCKET}
}

function is_published
{
    until [ $(curl ${TARGET} | jq -r .url_ts) -gt ${TS} ]
    do
        echo "Target NOT up to date" >&2
        sleep 5
    done
}

function poller
{
    DISCOVERY_URL=$(curl ${TARGET} | jq -r .url)
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