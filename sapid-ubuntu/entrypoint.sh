#!/bin/bash -

set -e

USERNAME="$1"
USERID="$2"

if [ -z "${USERNAME}" ] || [ -z "${USERID}" ]; then
  . /usr/local/bin/sapid_env.sh && bash
else
  useradd "${USERNAME}" -u "${USERID}" -m -d "/home/${USERNAME}" -s /bin/bash
  echo "cd `pwd`" >> "/home/${USERNAME}/.profile"
#  echo 'umask 022' >> "/home/${USERNAME}/.profile"
#  echo '. /usr/local/bin/sapid_env.sh' >> "/home/${USERNAME}/.profile"

  shift; shift
  CMD=''

  if ! ( [ $# -eq 0 ] || ( [ $# -eq 1 ] && ( [ "$1" = 'sh' ] || [ "$1" = 'bash' ] ))); then
    CMD="-c '$@'"
  fi

  eval su - "${USERNAME}" "${CMD}"
fi
