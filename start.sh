#!/usr/bin/env bash

die() { echo "$@" ; exit 1; }

[[ -z "${LOG_LEVEL}" ]] && \
  die "\$LOG_LEVEL is not set!"

[[ -z "${APP_CONTAINER_MEMORY}" ]] && \
  die "\$APP_CONTAINER_MEMORY is not set!"

sed -e "s!%%LOG_LEVEL%%!${LOG_LEVEL}!" \
    < log4j.properties.template > /usr/local/tomcat/lib/log4j.properties

jvm_memory=$((APP_CONTAINER_MEMORY * 75 / 100))

echo "memory is set to: ${jvm_memory}"

export CATALINA_OPTS="${CATALINA_OPTS} -Xmx${jvm_memory}m \
                      -XX:NativeMemoryTracking=summary \
                      -Dcom.sun.management.jmxremote \
                      -Dcom.sun.management.jmxremote.port=9010 \
                      -Dcom.sun.management.jmxremote.rmi.port=9010 \
                      -Dcom.sun.management.jmxremote.ssl=false \
                      -Dcom.sun.management.jmxremote.authenticate=false \
                      -Djava.rmi.server.hostname=localhost \
                      -javaagent:/usr/local/tomcat/dd-java-agent.jar"

exec catalina.sh run
