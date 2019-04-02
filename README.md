# Alpine Elasticsearch Image

![https://www.augustash.com](http://augustash.s3.amazonaws.com/logos/ash-inline-color-500.png)

**This base container is not currently aimed at public consumption. It exists as a starting point for August Ash containers.**

## Versions

- `2.0.0`, `latest` [(Dockerfile)](https://github.com/augustash/docker-alpine-elasticsearch/blob/2.0.0/Dockerfile)
- `1.1.0` [(Dockerfile)](https://github.com/augustash/docker-alpine-elasticsearch/blob/1.1.0/Dockerfile)
- `1.0.0` [(Dockerfile)](https://github.com/augustash/docker-alpine-elasticsearch/blob/1.0.0/Dockerfile)

[See VERSIONS.md for image contents.](https://github.com/augustash/docker-alpine-elasticsearch/blob/master/VERSIONS.md)

## Usage

Launch a single-use Elasticsearch container:

```bash
docker run --rm \
    -p 9200:9200 \
    -p 9300:9300 \
    augustash/alpine-elasticsearch
```

### Configuration

Dynamic scripting is normally turned off but this image enables it. The best way to alter the configuration of Elasticsearch is to mount an `elasticsearch.yml` file into `/usr/share/elasticsearch/config`.

#### Plugins

The following analysis plugins are installed by default:

- `analysis-icu` which integrates the Lucene ICU module into Elasticsearch.
- `analysis-phonetic` which provides token filters which convert tokens to phonetic representations.

### User/Group Identifiers

To help avoid nasty permissions errors, the container allows you to specify your own `PUID` and `PGID`. This can be a user you've created or even `root` (not recommended).

### Environment Variables

The following variables can be set and will change how the container behaves. You can use the `-e` flag, an environment file, or your Docker Compose file to set your preferred values. The default values are shown:

- `PUID`=501
- `PGID`=1000
