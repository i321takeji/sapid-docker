FROM alpine:3.7 AS sapid-dev

#MAINTAINER

ARG version="6.104.4"
ARG work_dir="/sapid-work"
ARG sapid_home="${work_dir}/Sapid-${version}"

WORKDIR ${work_dir}
COPY entrypoint.sh ${work_dir}

# install package for sapid build
RUN apk --update --no-cache add bash make imake g++ flex bison tk tk-dev tcl-dev xorg-cf-files libxt-dev libxml2-dev perl \
      openjdk8 apache-ant \
      ed diffutils \
&& mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh \
&& wget -O - https://www.x.org/releases/individual/util/gccmakedep-1.0.3.tar.gz | tar zxf - \
&& cd gccmakedep-1.0.3 && ./configure && make && make install && cd .. \
# set environment variables
&& source ${work_dir}/entrypoint.sh \
# download sapid
&& wget -O - http://www.sapid.org/FTP-CURRENT/Sapid-${version}.tar.gz | tar zxf - \
&& cd Sapid-${version} \
&& sed -i -e 's/^\/\* #define SapidTclIncDir\( \)\+\/usr\/local\/include \*\/$/#define SapidTclIncDir \/usr\/include/g'  \
          -e 's/^\/\* #define SapidTkIncDir\( \)\+\/usr\/local\/include \*\/$/#define SapidTkIncDir \/usr\/include/g'    \
          -e 's/^\/\* #define SapidTclLibDir\( \)\+\/usr\/local\/lib \*\/$/#define SapidTclLibDir \/usr\/lib\/tcl8\.6/g' \
          -e 's/^\/\* #define SapidTkLibDir\( \)\+\/usr\/local\/lib \*\/$/#define SapidTkLibDir \/usr\/lib\/tk8\.6/g'    \
          -e 's/^\/\* #define SapidTclVersion\( \)\+8\.0jp \*\/$/#define SapidTclVersion 8\.6/g'                         \
          -e 's/^\/\* #define SapidTkVersion\( \)\+8\.0jp \*\/$/#define SapidTkVersion 8\.6/g'                           \
          Sapid/SapidSite.def                                                                                            \
# build and install sapid
&& xmkmf -a 2>&1 | tee LOG-XMKMF \
## ignore build error SIP2 and SIP3
&& make -i 2>&1 | tee LOG-MAKE \
&& make -i install | tee LOG-INSTALL \
# set sapid environment
&& source /usr/local/Sapid/lib/SetUp.sh \
# sapid test
# dhrystone-2.1
&& cd ${sapid_home}/test/dhrystone-2.1 \
## quick hack
&& cp -p /usr/include/stdint.h /usr/include/stdint.h.bak \
&& sed -i -e "s/^#if L'\\\0'-1 > 0$/#if 0   \/\/ #if L'\\\0'-1 > 0/g" /usr/include/stdint.h \
##
&& mkSapid -a 2>&1 | tee LOG-MKSAPID \
&& make test-all 2>&1 | tee LOG-TESTALL \
# java-zip
&& cd ${sapid_home}/test/java-zip \
&& mkSapid -a 2>&1 | tee LOG-MKSAPID \
&& make test-all 2>&1 | tee LOG-TESTALL


FROM alpine:3.7

RUN apk --update --no-cache add bash diffutils imake make gcc musl-dev xorg-cf-files xproto openjdk8

COPY entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
COPY --from=sapid-dev /usr/local/Sapid /usr/local/Sapid
COPY --from=sapid-dev /usr/local/bin/gccmakedep /usr/local/bin/gccmakedep

#RUN cp -rp /usr/local/Sapid/sample/test ~/test
#RUN source entrypoint.sh \
#&& cd ~/test/dhrystone-2.1 \
## quick hack
#&& cp -p /usr/include/stdint.h /usr/include/stdint.h.bak \
#&& sed -i -e "s/^#if L'\\\0'-1 > 0$/#if 0   \/\/ #if L'\\\0'-1 > 0/g" /usr/include/stdint.h \
##
#&& mkSapid -a 2>&1 | tee LOG-MKSAPID && make test-all 2>&1 | tee LOG-TESTALL \
#&& cd ~/test/java-zip \
#&& mkSapid -a 2>&1 | tee LOG-MKSAPID && make test-all 2>&1 | tee LOG-TESTALL

ARG work_dir="/sapid-work"
WORKDIR ${work_dir}
ENTRYPOINT ["entrypoint.sh"]
CMD ["/bin/bash"]
