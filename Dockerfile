FROM alpine:3.17

RUN apk --no-cache add git git-lfs && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
