FROM hashicorp/terraform:0.15.5 as builder

FROM curlimages/curl:7.77.0 as curl
RUN curl -o /tmp/sops -L https://github.com/mozilla/sops/releases/download/v3.5.0/sops-v3.5.0.linux

FROM google/cloud-sdk:342.0.0-alpine
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/main' >> /etc/apk/repositories
RUN apk update && rm -rf /var/cache/apk/*
RUN apk add --no-cache curl=7.77.0-r0
RUN apk add --no-cache nettle=3.7.2-r0
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/main' >> /etc/apk/repositories
RUN apk update && rm -rf /var/cache/apk/*
RUN apk add --no-cache make=4.3-r0
RUN apk add --no-cache bash~=5.1.0-r0
RUN apk add --no-cache apk-tools~=2.12.5-r0
RUN apk add --no-cache nettle=3.7.2-r0
RUN apk add --no-cache curl=7.77.0-r0

WORKDIR /usr/local/bin/
COPY --from=builder . /usr/local/å