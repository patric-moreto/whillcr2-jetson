run () {
        tmux new -d -s "$1" "$2"
        sleep 1
}

#source /opt/ros/$ROS_DISTRO/setup.bash                               
#source /root/ros2_ws/install/setup.bash
#export ROS_DOMAIN_ID=30

LAUNCH_DIR=/root/ros2_ws/launch
CONFIG_DIR=/root/ros2_ws/config

echo "Starting both Unitree L2 LiDARs"
run unilidar_left "ros2 launch unitree_lidar_ros2 '${LAUNCH_DIR}'/left_lidar_launch.py"
run unilidar_right "ros2 launch unitree_lidar_ros2 '${LAUNCH_DIR}'/right_lidar_launch.py"

echo "Starting ZED X Mini"
run zed "ros2 launch zed_wrapper zed_camera.launch.py camera_model:=zedxm"

echo "Starting WHILL CR2 driver"
run whill "ros2 run whill_driver whill --ros-args -p port_name:=/dev/whill"

echo "Starting joy node"
run joy "ros2 run joy joy_node"

echo "Starting pointcloud merging"
run polka "ros2 launch polka polka.launch.py config_file:='${CONFIG_DIR}'/pointcloud_merge_params.yaml"

#echo "Starting pointcloud_to_laserscan"
#run laserscan "ros2 launch pointcloud_to_laserscan '${LAUNCH_DIR}'/pointcloud_to_laserscan_launch.py"

#echo "Starting WHILL CR2 state publisher"
#run whillcr2_tf "ros2 ??  state_publisher.launch.py"

#echo "Starting LiDAR odometry"
#run kiss_icp "ros2 launch kiss_icp odometry.launch.py topic:=/concatenated_cloud"

echo "Starting SLAM Toolbox"
run slam "ros2 launch slam_toolbox online_async_launch.py slam_params_file:='${CONFIG_DIR}'/mapper_params_online_async.yaml"

#echo "Starting Nav2"
#run nav2 "ros2 launch nav2 '${LAUNCH_DIR}'/?"
