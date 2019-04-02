FROM augustash/alpine-base-s6:4.0.0

# environment
ENV LANG C.UTF-8
ENV ELASTICSEARCH_VERSION 6.7.0
ENV JAVA_ALPINE_VERSION 8.201.08-r1
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
RUN apk-install gnupg openjdk8-jre="$JAVA_ALPINE_VERSION" && [ "$JAVA_HOME" = "$(docker-java-home)" ]
RUN apk add --no-cache nss && \
    mkdir -p /usr/share/elasticsearch && cd /usr/share/elasticsearch && \
    curl -sSL -o elasticsearch.tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz && \
    tar -xvzf elasticsearch.tar.gz --strip-components=1 && \
    rm elasticsearch.tar.gz && \
    bin/elasticsearch-plugin install analysis-phonetic && \
    bin/elasticsearch-plugin install analysis-icu && \
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
