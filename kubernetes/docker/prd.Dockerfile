FROM golang:1.15-alpine AS builder

# add unprivileged user
RUN adduser -s /bin/true -u 1000 -D -h /app app \
  && sed -i -r "/^(app|root)/!d" /etc/group /etc/passwd \
  && sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

# add ca certificates and timezone data files
# hadolint ignore=DL3018
RUN apk add -U --no-cache ca-certificates tzdata git \
    hugo

COPY . /site

RUN hugo --minify --source /site --config /site/config/prd.yaml \
    && ls -al /site/generated
#
# ---
#

FROM ghcr.io/ironpeakservices/iron-nginx:1.20.0

LABEL org.opencontainers.image.source="https://github.com/ironpeakservices/iron-chart-hugo"

COPY --chown=nonroot kubernetes/docker/nginx.conf /nginx.conf
COPY --from=builder --chown=nonroot /site/generated/ /assets