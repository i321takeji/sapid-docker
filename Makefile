NAME=bamboog130

build:
	make build-sapid-alpine
	make build-sapid-debian
	make build-sapid-ubuntu

build-sapid-alpine:
	cd sapid-alpine && docker build --no-cache -t $(NAME)/sapid-docker:alpine-6.104.4 .

build-sapid-debian:
	cd sapid-debian && docker build --no-cache -t $(NAME)/sapid-docker:debian-6.104.4 .

build-sapid-ubuntu:
	cd sapid-ubuntu && docker build --no-cache -t $(NAME)/sapid-docker:ubuntu-6.104.4 .

build-sapid-ubuntu-eclipse: build-sapid-ubuntu
	cd sapid-ubuntu && docker build --no-cache -t $(NAME)/sapid-docker_eclipse:ubuntu-6.104.4 -f Dockerfile_eclipse .
