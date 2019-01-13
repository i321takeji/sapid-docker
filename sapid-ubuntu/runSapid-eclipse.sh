#!/bin/bash -

#
# ./runSapid.sh <work dir> <command in container>
#
set -ex

IMAGE='bamboog130/sapid-docker_eclipse:ubuntu-6.104.4'

WORK_DIR="$1"
WORK_VOLUME=""

if [ -n "${WORK_DIR}" ]; then
  if [ -d "${WORK_DIR}" ]; then
    WORK_ABSPATH="$(cd ${WORK_DIR} && pwd)"
    WORK_VOLUME="-v ${WORK_ABSPATH}:/sapid-work"
    shift
  else
    echo "${WORK_DIR} is NOT directory."
    exit 1
  fi
fi

CMD="$@"

bash -c "docker run --rm -i -t --net host -e DISPLAY=${DISPLAY} \
                    -v ${HOME}/.Xauthority:/xfiles/.Xauthority:rw \
                    --name AAA \
                    ${WORK_VOLUME} \
                    ${IMAGE} ${USER} ${UID} ${CMD}"

#                   --hostname "${CONTAINAER_HOST}" \
