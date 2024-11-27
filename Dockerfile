FROM golang:1.21-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://github.com/ChairbfBackup/listmonk.git .
RUN go mod download
RUN go build -o listmonk

FROM alpine:latest
WORKDIR /listmonk
COPY --from=builder /app/listmonk ./listmonk
COPY --from=builder /app/config.toml.sample ./config.toml.sample
COPY --from=builder /app/static ./static
COPY --from=builder /app/entrypoint.sh ./
RUN chmod +x listmonk entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["./entrypoint.sh"]
