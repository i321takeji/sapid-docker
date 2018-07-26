build:
	make build-sapid-alpine
	make build-sapid-debian
	make build-sapid-ubuntu

build-sapid-alpine:
	cd sapid-alpine && docker build --no-cache -t sapid-docker:alpine-6.104.4 .

build-sapid-debian:
	cd sapid-debian && docker build --no-cache -t sapid-docker:debian-6.104.4 .

build-sapid-ubuntu:
	cd sapid-ubuntu && docker build --no-cache -t sapid-docker:ubuntu-6.104.4 .
