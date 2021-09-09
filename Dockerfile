FROM tomcat:9.0.50-jdk11-openjdk-slim-buster

ARG DATADOG_AGENT_JAR='https://search.maven.org/classic/remote_content?g=com.datadoghq&a=dd-java-agent&v=LATEST'

RUN LC_ALL=C apt-get update -yqq && \
    LC_ALL=C apt-get dist-upgrade -yqq && \
    LC_ALL=C apt-get install -yqq --no-install-recommends \
    awscli \
    ca-certificates \
    curl \
    groff \
    jq \
    openssl \
    wget \
    tini && \
    rm -f /usr/local/tomcat/conf/logging.properties && \
    ln -s /usr/bin/tini /sbin/tini

# install datadog agent
ADD ${DATADOG_AGENT_JAR} /usr/local/tomcat/dd-java-agent.jar

COPY server.xml /usr/local/tomcat/conf/
COPY log4j.properties.template /usr/local/tomcat/
COPY krb5.conf.template /usr/local/tomcat/webapps/
COPY start.sh /usr/local/tomcat/

WORKDIR /usr/local/tomcat

EXPOSE 8080 9010 8009
