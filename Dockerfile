# ===================================================
# Dockerfile para apostila baseada no rosi-challenge
# https://github.com/filRocha/rosiChallenge-sbai2019
#
# Autor:  Patrick Avelar Silva
# Email:  patrickavelarsilva@gmail.com
# ===================================================
FROM ros:melodic

RUN apt-get update

# Instalação de pacotes auxiliares
# O libgl1-mesa-dev é utilizado quando não há aceleração via GPU Nvidia, pois ela já provê essas bibliotecas.
RUN apt-get install -y \
    python-catkin-tools \
    xsltproc \
    libgl-dev \
    build-essential \
    ros-${ROS_DISTRO}-desktop-full \
    ros-${ROS_DISTRO}-brics-actuator \
    ros-${ROS_DISTRO}-tf2-sensor-msgs \
    ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-joint-state-publisher


# Adição do VREP
ADD V-REP_PRO_EDU_V3_6_2_Ubuntu18_04.xz /root
ENV VREP_ROOT /root/vrep
RUN mv /root/V-REP_PRO_EDU_V3_6_2_Ubuntu18_04 ${VREP_ROOT}

# Criação do workspace CATKIN
ENV ROS_CATKIN_WS /root/catkin_ws
RUN mkdir -p ${ROS_CATKIN_WS}/src

# Repositórios usados para build
RUN git clone "https://github.com/filRocha/sbai2019-rosiDefy" \
    ${ROS_CATKIN_WS}/src/rosi_defy
RUN git clone --recursive "https://github.com/kasperg3/vrep_ros_interface" \
    ${ROS_CATKIN_WS}/src/vrep_ros_interface
RUN git clone "https://github.com/filRocha/vrep_plugin_velodyne.git" \
    ${ROS_CATKIN_WS}/src/vrep_plugin_velodyne

# Definições no bash úteis para o ambiente de desenvolvimento
RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc
RUN echo "source ${ROS_CATKIN_WS}/devel/setup.bash" >> /root/.bashrc
RUN echo "alias vrep=$VREP_ROOT/vrep.sh" >> /root/.bashrc

# Alteração de configurações do pacote vrep_ros_interface
RUN echo "rosi_defy/ManipulatorJoints\nrosi_defy/RosiMovement\nrosi_defy/RosiMovementArray\nrosi_defy/HokuyoReading" \
    >> ${ROS_CATKIN_WS}/src/vrep_ros_interface/meta/messages.txt

ADD edit/CMakeLists.txt ${ROS_CATKIN_WS}/src/vrep_ros_interface/CMakeLists.txt
ADD edit/package.xml ${ROS_CATKIN_WS}/src/vrep_ros_interface/package.xml

# Compilação do ambiente catkin
RUN bash -c "source /opt/ros/melodic/setup.bash && cd ${ROS_CATKIN_WS} && catkin init && catkin build"

# Bibliotecas usadas pelo VREP na simulação
RUN cp ${ROS_CATKIN_WS}/devel/lib/libv_repExtRosInterface.so ${VREP_ROOT}
RUN cp ${ROS_CATKIN_WS}/devel/lib/libv_repExtRosVelodyne.so ${VREP_ROOT}

ENTRYPOINT [ "bash" ]
