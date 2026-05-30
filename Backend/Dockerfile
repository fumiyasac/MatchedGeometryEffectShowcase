FROM golang:1.21-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git
# Install swag before copying source so docs/ can be generated first
RUN go install github.com/swaggo/swag/cmd/swag@latest
COPY . .
# Generate docs/ package so go mod tidy can resolve the local import
RUN swag init -g ./cmd/server/main.go -o ./docs
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./cmd/server/main.go

FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/server .
EXPOSE 3000
CMD ["./server"]
