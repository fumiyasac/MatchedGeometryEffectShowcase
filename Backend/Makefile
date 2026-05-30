BINARY_NAME=gourmet-gallery-api
MAIN_PATH=./cmd/server/main.go

.PHONY: run build swag docker-up docker-down seed

run:
	go run $(MAIN_PATH)

build:
	go build -o $(BINARY_NAME) $(MAIN_PATH)

swag:
	swag init -g $(MAIN_PATH) -o ./docs

docker-up:
	cd ../Docker && docker-compose up -d

docker-down:
	cd ../Docker && docker-compose down

seed:
	mysql -h 127.0.0.1 -P 3306 -u root -proot fumiya0921 < ./migrations/init.sql

tidy:
	go mod tidy

test:
	go test ./...
