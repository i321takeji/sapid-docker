FROM ubuntu:16.04 AS sapid-dev

LABEL maintainer "bamboog130"

# instead of /bin/dash
RUN mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh

ARG version="6.104.4"
ARG work_dir="/sapid-work"
ARG sapid_home="${work_dir}/Sapid-${version}"
ARG sapid_test_defines="DEFINES=-D__x86_64__"
#ARG envfile="${work_dir}/sapid_env"

WORKDIR ${work_dir}
COPY sapid_env.sh ${work_dir}

# change apt source
RUN sed -i.bak -e "s%http://.*.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list \
# packages update and install package for sapid build
&& apt-get update && apt-get install -y \
  ant \
  bison \
  flex \
  g++ \
  libxml2-dev \
  openjdk-8-jdk \
  tcl-dev \
  tk-dev \
  wget \
  xutils-dev \
# set environment variables
&& source ${work_dir}/sapid_env.sh \
#&& touch "${envfile}" \
#&& echo 'export JAVA_HOME=`readlink -m "$(which javac)" | sed -e "s/\/bin\/javac\$//g"`' >> ${envfile} \
#&& echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ${envfile} \
#&& source ${envfile} \
# download and config Sapid
#&& VERSION=`wget http://www.sapid.org/FTP-CURRENT/'?C=M;O=D' -q -O - \
#            | grep -o -E 'Sapid-[0-9]+\.[0-9]+\.[0-9]+' | head -1 | tr -d '\n'`
&& wget -O - http://www.sapid.org/FTP-CURRENT/Sapid-${version}.tar.gz | tar zxf - \
&& cd Sapid-${version} \
&& sed -i -e 's/^\/\* #define SapidTclIncDir\( \)\+\/usr\/local\/include \*\/$/#define SapidTclIncDir \/usr\/include\/tcl8\.6/g' \
          -e 's/^\/\* #define SapidTkIncDir\( \)\+\/usr\/local\/include \*\/$/#define SapidTkIncDir \/usr\/include\/tk8\.6/g'    \
          -e 's/^\/\* #define SapidTclLibDir\( \)\+\/usr\/local\/lib \*\/$/#define SapidTclLibDir \/usr\/lib\/tcl8\.6/g'         \
          -e 's/^\/\* #define SapidTkLibDir\( \)\+\/usr\/local\/lib \*\/$/#define SapidTkLibDir \/usr\/lib\/tk8\.6/g'            \
          -e 's/^\/\* #define SapidTclVersion\( \)\+8\.0jp \*\/$/#define SapidTclVersion 8\.6/g'                                 \
          -e 's/^\/\* #define SapidTkVersion\( \)\+8\.0jp \*\/$/#define SapidTkVersion 8\.6/g'                                   \
          Sapid/SapidSite.def                                                                                                    \
# build and install Sapid
&& xmkmf -a 2>&1 | tee LOG-XMKMF \
&& make 2>&1 | tee LOG-MAKE \
&& make install | tee LOG-INSTALL \
# set Sapid environment
&& source /usr/local/Sapid/lib/SetUp.sh \
# test dhrystone-2.1
&& cd ${sapid_home}/test/dhrystone-2.1 \
&& mkSapid -a 2>&1 | tee LOG-MKSAPID \
#&& make DEFINES='-D__x86_64__' test-all 2>&1 | tee LOG-TESTALL \
&& make "${sapid_test_defines}" test-all 2>&1 | tee LOG-TESTALL \
# test java-zip
&& cd ${sapid_home}/test/java-zip \
&& mkSapid -a 2>&1 | tee LOG-MKSAPID \
&& make test-all 2>&1 | tee LOG-TESTALL


FROM ubuntu:16.04
# instead of /bin/dash
#RUN mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh
RUN sed -i.bak -e "s%http://.*.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list \
&& apt-get update && apt-get install -y --no-install-recommends \
  gcc \
  libc6-dev \
  make \
  openjdk-8-jdk \
  xutils-dev \
  x11proto-core-dev \
#for gnu/stubs-32.h (instead -D__x86_64__)
# libc6-dev-i386 \
# for TestSuite-6.89 ?
# bison \
# flex \
# libxaw7-dev \
# libxmu-headers \
# libxt-dev \
#clean up
&& apt-get clean \
&& rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
&& echo '\n# for Sapid' >> "/etc/skel/.profile" \
&& echo 'umask 022' >> "/etc/skel/.profile" \
&& echo '. /usr/local/bin/sapid_env.sh' >> "/etc/skel/.profile"

COPY sapid_env.sh /usr/local/bin
COPY entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
COPY --from=sapid-dev /usr/local/Sapid /usr/local/Sapid

#RUN cp -rp /usr/local/Sapid/sample/test ~/test
#&& source entrypoint.sh \
#&& cd ~/test/dhrystone-2.1 \
#&& mkSapid -a 2>&1 | tee LOG-MKSAPID && make "${sapid_test_defines}" test-all 2>&1 | tee LOG-TESTALL \
#&& cd ~/test/java-zip \
#&& mkSapid -a 2>&1 | tee LOG-MKSAPID && make test-all 2>&1 | tee LOG-TESTALL

ENV SAPID_USER sapider
ENV SAPID_UID 99999
ENV SAPID_GID 99999

ARG work_dir="/sapid-work"
WORKDIR ${work_dir}
ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]
