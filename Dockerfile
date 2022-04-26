# NOTE: The alpine version in this container is currently fixed at 3.14 to prevent the
# 'fatal: unsafe repository' error that was introduced in https://github.blog/2022-04-12-git-security-vulnerability-announced/.
# See https://github.com/actions/checkout/issues/766 andhttps://github.com/rickstaa/action-create-tag/issues/10 for
# more information.
FROM alpine:3.14

RUN apk --no-cache add git && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
