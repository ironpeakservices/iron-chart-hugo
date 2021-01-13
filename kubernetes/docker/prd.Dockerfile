FROM klakegg/hugo:0.80.0 AS builder

LABEL org.opencontainers.image.source="https://github.com/ironpeakservices/iron-chart-hugo"

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
