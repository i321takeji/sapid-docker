#!/bin/bash -

export JAVA_HOME=`readlink -f "$(which java)" | sed -e "s/\/jre\/bin\/java\$//g"`
export PATH="$JAVA_HOME/bin:$PATH"

if [ -f /usr/local/Sapid/lib/SetUp.sh ]; then
    . /usr/local/Sapid/lib/SetUp.sh
fi

"$@"
