FROM ghcr.io/gleam-lang/gleam:v1.8.1-erlang-alpine AS builder

WORKDIR /build
COPY . .

RUN gleam export erlang-shipment

FROM erlang:27-alpine
FROM ghcr.io/gleam-lang/gleam:v1.8.1-erlang-alpine

WORKDIR /app
COPY --from=builder /build/build/erlang-shipment /bin/glaze_up

RUN apk add --no-cache git github-cli
VOLUME [ "/app" ]

ENTRYPOINT [ "/bin/glaze_up/entrypoint.sh", "run" ]
