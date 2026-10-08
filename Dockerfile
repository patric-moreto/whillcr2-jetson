FROM patricmoreto/humble-jp6.1.0-arm64 
SHELL ["/bin/bash", "-c"]
WORKDIR /root/ros2_ws/src

# --- Clone ROS 2 Whill repository
# --- From https://github.com/whill-labs/ros2_whill
RUN git clone -b $ROS_DISTRO https://github.com/whill-labs/ros2_whill_interfaces.git && \
    git clone -b $ROS_DISTRO https://github.com/whill-labs/ros2_whill.git
RUN cd .. && source /opt/ros/$ROS_DISTRO/setup.bash &&  \
    colcon build --packages-up-to whill

# --- Clone ROS 2 Unitree 4D LiDAR L2 repository
# --- From https://github.com/unitreerobotics/unilidar_sdk2
ARG N_ENV=14 
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpcl-dev ros-$ROS_DISTRO-pcl-conversions && \
    rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/unitreerobotics/unilidar_sdk2.git && \
    cd unilidar_sdk2/unitree_lidar_sdk && mkdir build && cd build && \
    cmake .. && make -j"${N_ENV}"
RUN cd .. && source /opt/ros/$ROS_DISTRO/setup.bash && rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y && \
    colcon build --packages-select unitree_lidar_ros2

# --- Install several ROS 2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-$ROS_DISTRO-slam-toolbox ros-$ROS_DISTRO-navigation2 \
    ros-$ROS_DISTRO-nav2-bringup ros-$ROS_DISTRO-joy \
    ros-$ROS_DISTRO-pointcloud-to-laserscan \
    ros-$ROS_DISTRO-robot-localization && \
    rm -rf /var/lib/apt/lists/*

# --- Install several development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    htop vim tmux x11-apps nvtop sl && \
    rm -rf /var/lib/apt/lists/*

# --- Clone Polka repository
# --- From https://github.com/Pana1v/polka/tree/humble
RUN git clone -b humble https://github.com/Pana1v/polka.git
RUN cd .. && source /opt/ros/$ROS_DISTRO/setup.bash &&  \
    colcon build --packages-select polka --cmake-args -DWITH_CUDA=ON

# --- Add ROS 2 setup to .bashrc
RUN echo "# Adding ROS setup" >> /root/.bashrc && \
    echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /root/.bashrc && \
    echo "source /root/ros2_ws/install/setup.bash" >> /root/.bashrc && \
    echo "export ROS_DOMAIN_ID=30" >> /root/.bashrc

# --- Scripts used
COPY scripts/start_ros2.sh /root/
RUN chmod 755 /root/start_ros2.sh
COPY scripts/ros_entrypoint.sh /sbin/ros_entrypoint.sh
RUN chmod 755 /sbin/ros_entrypoint.sh

WORKDIR /root/
ENTRYPOINT ["/sbin/ros_entrypoint.sh"]
CMD ["bash"]
