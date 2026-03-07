FROM golang:1.22-alpine AS builder

WORKDIR /src

RUN apk add --no-cache upx

COPY go.mod go.sum ./
RUN go mod download

COPY . .
ARG TARGETOS=linux
ARG TARGETARCH
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -trimpath -ldflags="-s -w" -o /out/app . && \
    upx --best --lzma /out/app && \
    mkdir -p /out/data

FROM scratch

ENV WEB_APP_ENV=develop
COPY --from=builder --chown=10001:10001 /out/app /app/app
COPY --from=builder --chown=10001:10001 /out/data /app/data
WORKDIR /app/data
USER 10001:10001

EXPOSE 8080
ENTRYPOINT ["/app/app"]
