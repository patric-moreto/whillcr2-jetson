#!/bin/bash

IMAGE_NAME=patricmoreto/whillcr2-jetson:latest
PLATFORM=linux/arm64

docker buildx build --platform ${PLATFORM} --tag ${IMAGE_NAME} .
