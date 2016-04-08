#!/bin/bash -e

CLOUD_CONFIG=https://raw.githubusercontent.com/JulienBalestra/coreos_deploy/master/install/cloud-config.yaml
BOOTSTRAP_DIR=/root/bootstrap.d

mkdir -p ${BOOTSTRAP_DIR}

coreos-cloudinit -validate --from-url ${CLOUD_CONFIG} | tee -a \
    ${BOOTSTRAP_DIR}/install.log

curl -L ${CLOUD_CONFIG} -o ${BOOTSTRAP_DIR}/cloud-config.yaml | tee -a \
    ${BOOTSTRAP_DIR}/install.log

coreos-install \
    -c ${BOOTSTRAP_DIR}/cloud-config.yaml \
    -d /dev/sda \ # Beware: loosing all data inside
    -C alpha 2>&1 | tee -a \
    ${BOOTSTRAP_DIR}/install.log

# TODO find a way to POST logs outside

sync