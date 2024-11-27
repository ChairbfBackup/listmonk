FROM golang:1.21-alpine AS builder
WORKDIR /app

# Install git
RUN apk add --no-cache git

# Clone the repository
RUN git clone https://github.com/ChairbfBackup/listmonk.git .

# Initialize go module and download dependencies
RUN go mod init listmonk || true
RUN go mod tidy
RUN go build -o listmonk

FROM alpine:latest
WORKDIR /listmonk
COPY --from=builder /app/listmonk ./listmonk
COPY --from=builder /app/config.toml.sample ./config.toml.sample
COPY --from=builder /app/static ./static
COPY --from=builder /app/entrypoint.sh ./entrypoint.sh

RUN chmod +x listmonk entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["./entrypoint.sh"]
