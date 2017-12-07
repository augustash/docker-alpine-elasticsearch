#!/usr/bin/with-contenv bash

mkdir -p \
    /usr/share/elasticsearch/plugins \
    /usr/share/elasticsearch/data \
    /usr/share/elasticsearch/logs \
    /usr/share/elasticsearch/config \
    /usr/share/elasticsearch/config/scripts

chown -R "${PUID}:${PGID}" /usr/share/elasticsearch
