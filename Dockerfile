# Static (musl) binary on distroless/static: no shell, no package manager,
# runs as an unprivileged user.
FROM docker.io/library/rust:1.99-alpine AS build
RUN apk add --no-cache musl-dev
WORKDIR /src
COPY Cargo.toml Cargo.lock ./
COPY src src
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/src/target \
    cargo build --release && cp target/release/brokelabs-gateway /brokelabs-gateway

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /brokelabs-gateway /brokelabs-gateway
USER 65532:65532
EXPOSE 8081
ENTRYPOINT ["/brokelabs-gateway"]
