#!/bin/bash -

export JAVA_HOME=`readlink -m "$(which javac)" | sed -e "s/\/bin\/javac$//g"`
export PATH="$JAVA_HOME/bin:$PATH"

if [ -f /usr/local/Sapid/lib/SetUp.sh ]; then
    . /usr/local/Sapid/lib/SetUp.sh
fi
