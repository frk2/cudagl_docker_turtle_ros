FROM nvidia/cudagl:10.1-runtime-ubuntu16.04

# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    curl \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO kinetic
COPY ros-kinetic-librealsense_10.0_all.deb /tmp
RUN dpkg -i /tmp/ros-kinetic-librealsense_10.0_all.deb
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop-full udev ros-kinetic-depthimage-to-laserscan \
    ros-kinetic-kobuki-gazebo-plugins ros-kinetic-turtlebot-navigation

RUN apt-get update && apt-get install -y \
    vim sudo mesa-utils

#RUN curl -sSL http://get.gazebosim.org | sh
# setup entrypoint
#COPY ./ros_entrypoint.sh /
RUN useradd -r -u 1000 faraz -G sudo
RUN echo "root:Docker!" | chpasswd
RUN echo "faraz:faraz" | chpasswd
USER faraz
#ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

