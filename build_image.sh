#!/bin/bash

IMAGE_NAME=patricmoreto/whillcr2-jetson:lidar-odometry-point-lio
PLATFORM=linux/arm64

docker buildx build --platform ${PLATFORM} --tag ${IMAGE_NAME} .
