VERSION=1.0
NAME="dang3r/nginx-redirect"
IMAGE_LATEST=$(NAME):latest
IMAGE_VERSION=$(NAME):$(VERSION)

build:
	docker build -t $(IMAGE_LATEST) -t $(IMAGE_VERSION) docker/

up:
	docker-compose up -d

down:
	docker-compose down

.PHONY: build
