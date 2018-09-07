FROM augustash/alpine-base-s6:2.1.0

# environment
ENV LANG C.UTF-8
ENV ELASTICSEARCH_VERSION 2.4.6
ENV JAVA_ALPINE_VERSION 8.201.08-r0
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/share/elasticsearch/bin:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
        echo '#!/bin/sh'; \
        echo 'set -e'; \
        echo; \
        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home && \
    chmod +x /usr/local/bin/docker-java-home

# packages & configure
RUN apk-install gnupg openjdk8-jre="$JAVA_ALPINE_VERSION" && [ "$JAVA_HOME" = "$(docker-java-home)" ] && \
    mkdir -p /usr/share/elasticsearch /usr/share/elasticsearch/plugins && cd /usr/share/elasticsearch && \
    curl -sSL -o elasticsearch.tar.gz https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${ELASTICSEARCH_VERSION}/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz && \
    tar -xvzf elasticsearch.tar.gz --strip-components=1 && \
    rm elasticsearch.tar.gz && \
    curl -sSL -o analysis-phonetic.zip https://download.elastic.co/elasticsearch/release/org/elasticsearch/plugin/analysis-phonetic/${ELASTICSEARCH_VERSION}/analysis-phonetic-${ELASTICSEARCH_VERSION}.zip && \
    curl -sSL -o analysis-icu.zip https://download.elastic.co/elasticsearch/release/org/elasticsearch/plugin/analysis-icu/${ELASTICSEARCH_VERSION}/analysis-icu-${ELASTICSEARCH_VERSION}.zip && \
    bin/plugin install file:///usr/share/elasticsearch/analysis-phonetic.zip && \
    bin/plugin install file:///usr/share/elasticsearch/analysis-icu.zip && \
    rm *.zip && \
    chown -R ash:ash /usr/share/elasticsearch && \
    apk-cleanup

# copy root filesystem
COPY rootfs /

# external
EXPOSE  9200 9300
VOLUME  "/usr/share/elasticsearch/data"
WORKDIR "/usr/share/elasticsearch"

# run s6 supervisor
ENTRYPOINT ["/init"]
