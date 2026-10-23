from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription, GroupAction
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch_ros.actions import SetParameter
from launch_ros.substitutions import FindPackageShare

def generate_launch_description():
    original_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([
            FindPackageShare('point_lio'),
            'launch', 'correct_odom_unilidar_l2.launch.py'
        ])
    )

    override_lidar = SetParameter(
        name='common.lid_topic',
        value='/unilidar_left/cloud'
    )

    override_imu = SetParameter(
        name='common.imu_topic',
        value='/unilidar_left/imu'
    )

    return LaunchDescription([
        GroupAction(
            actions=[
                override_lidar,
                override_imu,
                original_launch
            ]
        )
    ])
