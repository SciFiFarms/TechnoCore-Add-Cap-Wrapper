FROM docker:18.09 AS base

FROM alpine:latest
RUN apk add --no-cache bash socat
COPY --from=base / /

# Set up the CMD as well as the pre and post hooks.
COPY go-init /bin/go-init
COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY exitpoint.sh /usr/bin/exitpoint.sh

ENTRYPOINT ["/bin/go-init"]
CMD ["-main", "/usr/bin/entrypoint.sh", "-post", "exitpoint.sh"]
