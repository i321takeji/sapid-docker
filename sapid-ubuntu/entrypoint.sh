#!/bin/bash -

set -e

USERNAME="$1"
USERID="$2"

if [ -z "${USERNAME}" ] || [ -z "${USERID}" ]; then
  . /usr/local/bin/sapid_env.sh && bash
else
  useradd "${USERNAME}" -u "${USERID}" -m -d "/home/${USERNAME}" -s /bin/bash
#  echo 'umask 022' >> "/home/${USERNAME}/.profile"
#  echo '. /usr/local/bin/sapid_env.sh' >> "/home/${USERNAME}/.profile"

  shift; shift
  CMD=""
  if [ $# -gt 0 ]; then
    CMD="-c '$@'"
  fi
  eval su - "${USERNAME}" "${CMD}"
fi
