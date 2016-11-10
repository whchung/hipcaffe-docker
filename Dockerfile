FROM rocm/rocm-terminal
MAINTAINER Wen-Heng (Jack) Chung <whchung@gmail.com>

# Update apt cache
RUN sudo apt-get update && sudo apt-get -y install git

# Install g++-multilib
RUN sudo apt-get -y install g++-multilib

# Install prerequisites for HCBLAS from binary
RUN sudo apt-get -y install libblas-dev

# Install prerequisites for HICAFFE from binary
RUN sudo apt-get -y install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler libatlas-base-dev libblas-dev libgflags-dev libgoogle-glog-dev liblmdb-dev libboost-all-dev

# Install ROCm-Device-Libs
RUN sudo curl -LO https://github.com/RadeonOpenCompute/hcc/releases/download/roc-1.4.0-rc1/rocm-device-libs-0.0.1401-Linux.deb && sudo dpkg -i rocm-device-libs-0.0.1401-Linux.deb

# Install HCC
RUN sudo curl -LO https://github.com/RadeonOpenCompute/hcc/releases/download/roc-1.4.0-rc1/hcc_lc-1.0.16443-Linux.deb && sudo dpkg -i hcc_lc-1.0.16443-Linux.deb

# Build developer-preview HIP from source and install it
RUN git clone -b developer-preview https://github.com/GPUOpen-ProfessionalCompute-Tools/HIP.git \
    && cd HIP && mkdir build && cd build \
    && cmake .. \
    && make -j$(nproc) \
    && sudo make install

# Build HCBLAS from source and install it
RUN git clone https://bitbucket.org/multicoreware/hcblas.git \
    && cd ~/hcblas && sh ./build.sh \
    && sudo dpkg -i build/hcblas-master-*.deb

# Build HIPCAFFE from source
# HIPCAFFE isn't made public yet so steps below have to be carried out manually
#
# checkout HIPCAFFE at host:
#
# mkdir -p $HOME/dockerhome
# cd $HOME/dockerhome
# git clone -b hip https://bitbucket.org/multicoreware/hipcaffe.git
#
#
# launch the container via:
#
# docker run -it --rm --device=/dev/kfd -v $HOME/dockerhome:/dockerhome whchung/hipcaffe:roc-1.4.0-rc1
#
#
# inside the container, execute:
#
# cp -R /dockerhome/hipcaffe ~
# cd ~/hipcaffe
# sed -i 's/USE_OPENCV := 0/USE_OPENCV := 1/' Makefile.config 
# sed -i 's/\/usr\/local\/include/\/usr\/local\/include \/usr\/include\/x86_64-linux-gnu \/usr\/include\/x86_64-linux-gnu\/c++\/4.8 \/usr\/include\/c++\/4.8 \/opt\/rocm\/hip\/include\/hip/' Makefile.config
# sudo ln /dev/null /dev/raw1394
# make -j$(nproc)

# Get CIFAR10
# cd ~/hipcaffe && ./data/cifar10/get_cifar10.sh && ./examples/cifar10/create_cifar10.sh

# Run CIFAR10
# cd ~/hipcaffe && build/tools/caffe train --solver=examples/cifar10/cifar10_quick_solver.prototxt

# Run convent benchmark
# git clone https://github.com/soumith/convnet-benchmarks.git \
# && cd hipcaffe && build/tools/caffe time --model=../convnet-benchmarks/caffe/imagenet_winners/alexnet.prototxt --iterations 2  --gpu 0

