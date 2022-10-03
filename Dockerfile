ARG DOCKER_REGISTRY
ARG DOCKER_ALPINE_VERSION=latest
FROM ${DOCKER_REGISTRY}alpine:${DOCKER_ALPINE_VERSION} as builder
# Downloads restcommander to /bin/restcommander:
COPY tools/docker/downloader.sh .
RUN chmod a+x downloader.sh && ./downloader.sh
# Creates configuration at /restcommander:
COPY tools/docker/configuration.sh .
RUN chmod a+x configuration.sh && ./configuration.sh

FROM ${DOCKER_REGISTRY}alpine:${DOCKER_ALPINE_VERSION}
COPY --from=builder /restcommander /restcommander
COPY --from=builder /bin/restcommander /bin/restcommander
WORKDIR /restcommander
VOLUME ["/restcommander", "/restcommander/scripts", "/restcommander/www"]
EXPOSE 1995
ENTRYPOINT ["/bin/restcommander"]
CMD ["config", "config.toml"]
