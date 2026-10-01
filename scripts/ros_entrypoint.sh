#!/bin/bash
set -e

# Setup the ROS 2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

# Setup the workspace overlay
source "/root/ros2_ws/install/local_setup.bash"

export ROS_DOMAIN_ID=30

# Welcome information
echo 'ROS distro: ' $ROS_DISTRO
echo 'DDS middleware: ' $RMW_IMPLEMENTATION
echo 'ROS 2 Workspaces:' $COLCON_PREFIX_PATH
echo 'ROS 2 Domain ID:' $ROS_DOMAIN_ID
echo ' * Note: Host and Docker image Domain ID must match to allow communication'
exec "$@"
