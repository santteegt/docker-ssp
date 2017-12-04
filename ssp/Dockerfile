# FROM tomcat:8-jre7
FROM tomcat:8-jre8

# Configure Tomcat for SSP

ARG CATALINA_HOME=/usr/local/tomcat

COPY conf/catalina.properties ${CATALINA_HOME}/conf
COPY conf/context.xml ${CATALINA_HOME}/conf
COPY conf/server.xml ${CATALINA_HOME}/conf
COPY bin/setenv.sh ${CATALINA_HOME}/bin

# Installing Sencha SDK

ENV SENCHA_VERSION 6.5.2
ENV SENCHA_BUILD 15
ENV SENCHA_ARQ amd64

RUN apt-get update \
	&& apt-get install -y openjdk-8-jdk maven postgresql-client
	# && apt-get install -y openjdk-7-jdk maven postgresql-client

# RUN apk update && apk upgrade && apk --update add \
#     ruby build-base libstdc++ tzdata bash ttf-dejavu freetype fontconfig wget curl

RUN wget http://cdn.sencha.com/cmd/$SENCHA_VERSION/no-jre/SenchaCmd-$SENCHA_VERSION-linux-$SENCHA_ARQ.sh.zip -O \
	senchacmd.zip && unzip senchacmd.zip && rm senchacmd.zip && chmod +x \
	SenchaCmd-$SENCHA_VERSION.$SENCHA_BUILD-linux-$SENCHA_ARQ.sh
RUN ./SenchaCmd-$SENCHA_VERSION.$SENCHA_BUILD-linux-$SENCHA_ARQ.sh -q \
	-dir /opt/Sencha/Cmd/$SENCHA_VERSION.$SENCHA_BUILD -Dall=true
RUN rm SenchaCmd-$SENCHA_VERSION.$SENCHA_BUILD-linux-$SENCHA_ARQ.sh && \
	chmod +x /opt/Sencha/Cmd/$SENCHA_VERSION.$SENCHA_BUILD/sencha && \
	ln -s /opt/Sencha/Cmd/$SENCHA_VERSION.$SENCHA_BUILD/sencha /usr/bin/sencha

# Installing Maven

# ARG MAVEN_VERSION=3.5.2
# ARG USER_HOME_DIR="/root"
# ARG SHA=707b1f6e390a65bde4af4cdaf2a24d45fc19a6ded00fff02e91626e3e42ceaff
# ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

# RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
#   && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
#   && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
#   && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
#   && rm -f /tmp/apache-maven.tar.gz \
#   && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV M2_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# Installing Ant

ARG ANT_BINARY=https://archive.apache.org/dist/ant/binaries/apache-ant-1.8.2-bin.tar.gz

RUN mkdir -p /usr/share/ant \
	&& curl -fsSL -o /tmp/apache-ant.tar.gz ${ANT_BINARY} \
	&& tar -xzf /tmp/apache-ant.tar.gz -C /usr/share/ant --strip-components=1 \
	&& rm -f /tmp/apache-ant.tar.gz
	# && rm -f /tmp/apache-ant.tar.gz \
	# && ln -s /usr/share/ant/bin/ant /usr/bin/ant

ENV PATH="/usr/share/ant/bin:$PATH"

# Install Student Success Plan

ENV SSP_CONFIGDIR /usr/local/ssp/ssp-local
ARG SSP_SOURCE=https://wiki.jasig.org/download/attachments/73367599/SSP-platform-2-8-0.zip?version=1&modificationDate=1484916082808&api=v2
# ARG SSP_SOURCE=https://github.com/Jasig/SSP-Platform/archive/ssp-2-7-0.zip

RUN mkdir -p /usr/local/ssp /usr/local/ssp/platform-src /usr/local/ssp/ssp-local $SSP_CONFIGDIR \
  && curl -fsSL -o /tmp/ssp-platform.zip ${SSP_SOURCE} \
  && unzip /tmp/ssp-platform.zip \
  && mv SSP-Platform-ssp-rel-2-8-patches/* /usr/local/ssp/platform-src \
  && rm -Rf /tmp/ssp-platform.zip ./SSP-Platform-ssp-rel-2-8-patches
  # && mv SSP-Platform-ssp-2-7-0/* /usr/local/ssp/platform-src \
  # && rm -Rf /tmp/ssp-platform.zip ./SSP-Platform-ssp-2-7-0

COPY ssp-local/ssp-config.properties $SSP_CONFIGDIR
COPY ssp-local/logback.xml $SSP_CONFIGDIR
COPY ssp-local/build.properties /usr/local/ssp/platform-src
COPY ssp-local/ssp-platform-config.properties $SSP_CONFIGDIR

# RUN pg_isready -h postgresssp -p 5432
COPY bin/ssp-entrypoint.sh /usr/local/bin

RUN chmod +x /usr/local/bin/ssp-entrypoint.sh
# RUN chmod +x /usr/local/bin/wait_db_connection.sh \
# 	&& sh /usr/local/bin/wait_db_connection.sh
# RUN cd /usr/local/ssp/platform-src && SSP_CONFIGDIR=/usr/local/ssp/ssp-local ant -Dmaven.test.skip=true clean dbtest
# RUN cd /usr/local/ssp/platform-src && SSP_CONFIGDIR=/usr/local/ssp/ssp-local ant -Dmaven.test.skip=true clean initportal
# RUN cd /usr/local/ssp/platform-src && SSP_CONFIGDIR=/usr/local/ssp/ssp-local ant -Dmaven.test.skip=true clean deploy-ear

EXPOSE 8080
CMD ["catalina.sh", "run"]	


