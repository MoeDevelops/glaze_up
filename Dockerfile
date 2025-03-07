FROM ghcr.io/gleam-lang/gleam:v1.8.1-erlang-alpine AS builder

WORKDIR /build
COPY . .

RUN gleam export erlang-shipment

FROM ghcr.io/gleam-lang/gleam:v1.8.1-erlang-alpine

WORKDIR /app
COPY --from=builder /build/build/erlang-shipment /bin/glaze_up
COPY --from=builder /build/entrypoint.sh /bin/entrypoint.sh

RUN apk add --no-cache git github-cli
VOLUME [ "/app" ]

ENTRYPOINT [ "/bin/entrypoint.sh", "run" ]
