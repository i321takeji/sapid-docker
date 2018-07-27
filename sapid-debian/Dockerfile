FROM openjdk:8-jdk-slim AS sapid-dev

# instead of /bin/dash
RUN mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh

ARG version="6.104.4"
ARG work_dir="/sapid-work"
ARG sapid_home="${work_dir}/Sapid-${version}"
ARG sapid_test_defines="DEFINES=-D_DEFAULT_SOURCE -D__x86_64__"

WORKDIR ${work_dir}
COPY entrypoint.sh ${work_dir}

# packages upgrade
RUN apt-get update && apt-get install -y \
# install package for sapid build
  ant \
  bison \
  flex \
  g++ \
  libxml2-dev \
  tcl-dev \
  tk-dev \
  wget \
  xutils-dev \
# set environment variables
&& source ${work_dir}/entrypoint.sh \
# download sapid
&& wget -O - http://www.sapid.org/FTP-CURRENT/Sapid-${version}.tar.gz | tar zxf - \
&& cd Sapid-${version} \
&& sed -i -e 's/^\/\* #define SapidTclIncDir\( \)\+\/usr\/local\/include \*\/$/#define SapidTclIncDir \/usr\/include\/tcl8\.6/g' \
          -e 's/^\/\* #define SapidTkIncDir\( \)\+\/usr\/local\/include \*\/$/#define SapidTkIncDir \/usr\/include\/tk8\.6/g'    \
          -e 's/^\/\* #define SapidTclLibDir\( \)\+\/usr\/local\/lib \*\/$/#define SapidTclLibDir \/usr\/lib\/tcl8\.6/g'         \
          -e 's/^\/\* #define SapidTkLibDir\( \)\+\/usr\/local\/lib \*\/$/#define SapidTkLibDir \/usr\/lib\/tk8\.6/g'            \
          -e 's/^\/\* #define SapidTclVersion\( \)\+8\.0jp \*\/$/#define SapidTclVersion 8\.6/g'                                 \
          -e 's/^\/\* #define SapidTkVersion\( \)\+8\.0jp \*\/$/#define SapidTkVersion 8\.6/g'                                   \
          Sapid/SapidSite.def                                                                                                    \
# build and install sapid
&& xmkmf -a 2>&1 | tee LOG-XMKMF \
&& make 2>&1 | tee LOG-MAKE \
&& make install | tee LOG-INSTALL \
# set sapid environment
&& source /usr/local/Sapid/lib/SetUp.sh \
# sapid test
# dhrystone-2.1
&& cd ${sapid_home}/test/dhrystone-2.1 \
&& mkSapid -a 2>&1 | tee LOG-MKSAPID \
&& make "${sapid_test_defines}" test-all 2>&1 | tee LOG-TESTALL \
# java-zip
&& cd ${sapid_home}/test/java-zip \
&& mkSapid -a 2>&1 | tee LOG-MKSAPID \
&& make test-all 2>&1 | tee LOG-TESTALL


#FROM debian:stable-slim
FROM openjdk:8-jdk-slim
#RUN mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh \
RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc \
  libc6-dev \
  make \
  xutils-dev \
  x11proto-core-dev \
# openjdk-8-jdk \
## for gnu/stubs-32.h (instead -D__x86_64__)
# libc6-dev-i386 \
## for TestSuite-6.89 ?
# bison \
# flex \
# libxaw7-dev \
# libxmu-headers \
# libxt-dev \
#clean up
&& apt-get clean \
&& rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
COPY --from=sapid-dev /usr/local/Sapid /usr/local/Sapid

#RUN cp -rp /usr/local/Sapid/sample/test ~/test
#RUN source entrypoint.sh \
#&& cd ~/test/dhrystone-2.1 \
#&& mkSapid -a 2>&1 | tee LOG-MKSAPID && make "${sapid_test_defines}" test-all 2>&1 | tee LOG-TESTALL \
#&& cd ~/test/java-zip \
#&& mkSapid -a 2>&1 | tee LOG-MKSAPID && make test-all 2>&1 | tee LOG-TESTALL

ARG work_dir="/sapid-work"
WORKDIR ${work_dir}
ENTRYPOINT ["entrypoint.sh"]
CMD ["/bin/bash"]
