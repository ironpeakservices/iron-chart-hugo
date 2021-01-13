FROM klakegg/hugo:0.80.0

LABEL org.opencontainers.image.source="https://github.com/ironpeakservices/iron-chart-hugo"

WORKDIR /site
USER 1000
ENTRYPOINT ["hugo", "serve", "--port=8080", "--bind=0.0.0.0", "--gc", "--source /site", "--config /site/config/dev.yaml"]
EXPOSE 8080