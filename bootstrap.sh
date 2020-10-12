sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu jessie main" > /etc/apt/sources.list.d/ros-latest.list'
wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install python-setuptools git checkinstall cmake libboost-system-dev libboost-thread-dev
sudo easy_install pip
sudo pip install -U rosdep rosinstall_generator wstool rosinstall

sudo rosdep init
rosdep update

mkdir ~/ros_catkin_ws
cd ~/ros_catkin_ws

rosinstall_generator ros_comm diagnostics bond_core dynamic_reconfigure nodelet_core rosserial class_loader image_common vision_opencv image_transport_plugins pluginlib --rosdistro kinetic --deps --wet-only --exclude roslisp --tar > kinetic-robot-wet.rosinstall
wstool init -j8 src kinetic-robot-wet.rosinstall

mkdir ~/ros_catkin_ws/external_src
cd ~/ros_catkin_ws/external_src
git clone https://github.com/ros/console_bridge.git
cd console_bridge
cmake .
sudo checkinstall make install

cd ~/ros_catkin_ws
rosdep install --from-paths src --ignore-src --rosdistro kinetic -y -r --os=debian:jessie

sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic
echo 'source /opt/ros/kinetic/setup.bash' >> ~/.bashrc
source /opt/ros/kinetic/setup.bash

