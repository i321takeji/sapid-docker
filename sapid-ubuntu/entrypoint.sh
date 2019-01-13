#!/bin/bash -

set -e

USERNAME="${SAPID_USER}"
USERID="${SAPID_UID}"
GROUPID="${SAPID_GID}"

if [ -z "${USERNAME}" ] || [ -z "${USERID}" ] || [ -z "${GROUPID}" ]; then
  if [ -f /xfiles/.Xauthority ]; then
    ln -s /xfiles/.Xauthority /root
  fi

  . /usr/local/bin/sapid_env.sh && bash
else
  groupadd "${USERNAME}" -g "${GROUPID}"
  useradd "${USERNAME}" -u "${USERID}" -g "${GROUPID}" -m -d "/home/${USERNAME}" -s /bin/bash
  echo "cd `pwd`" >> "/home/${USERNAME}/.profile"
#  echo 'umask 022' >> "/home/${USERNAME}/.profile"
#  echo '. /usr/local/bin/sapid_env.sh' >> "/home/${USERNAME}/.profile"

  if [ -f /xfiles/.Xauthority ]; then
    ln -s /xfiles/.Xauthority "/home/${USERNAME}"
  fi

  CMD=''
  if ! ( [ $# -eq 0 ] || ( [ $# -eq 1 ] && ( [ "$1" = 'sh' ] || [ "$1" = 'bash' ] ))); then
    CMD="-c '$@'"
  fi

  eval su - "${USERNAME}" "${CMD}"
fi
