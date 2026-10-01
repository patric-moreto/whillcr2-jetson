#!/bin/bash

IMAGE_NAME=whillcr2-jetson:latest
CONTAINER_NAME=whillchair_jetson
BASH_DIR=$(dirname "$(realpath $0)")

# Allowing connections to xserver
xhost +local:docker

	docker run \
		--interactive \
		--tty \
		--rm \
		--name ${CONTAINER_NAME} \
		--network=host \
		--ipc=host \
		--pid=host \
		--runtime nvidia \
		--gpus all \
		--privileged \
		--env NVIDIA_DRIVER_CAPABILITIES=all \
		--env DISPLAY=$DISPLAY \
		--env XAUTHORITY=$XAUTHORITY \
		-v $BASH_DIR/ros2_ws/launch:/root/ros2_ws/launch \
		-v $BASH_DIR/ros2_ws/config:/root/ros2_ws/config \
		-v /tmp:/tmp \
		-v /dev:/dev \
		-v /var/nvidia/nvcam/settings/:/var/nvidia/nvcam/settings/ \
	       	-v /etc/systemd/system/zed_x_daemon.service:/etc/systemd/system/zed_x_daemon.service \
		-v /usr/local/zed/resources/:/usr/local/zed/resources/ \
		-v /usr/local/zed/settings/:/usr/local/zed/settings/ \
		--group-add dialout \
		${IMAGE_NAME} \
		# --restart=unless-stopped \
		$@
