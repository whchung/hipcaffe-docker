FROM rocm/rocm-terminal
MAINTAINER Wen-Heng (Jack) Chung <whchung@gmail.com>

# Update apt cache
RUN sudo apt-get update && sudo apt-get -y install git wget

# Install prerequisites for HCBLAS from binary
RUN sudo apt-get -y install libblas-dev

# Install prerequisites for HICAFFE from binary
RUN sudo apt-get -y install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler libatlas-base-dev libblas-dev libgflags-dev libgoogle-glog-dev liblmdb-dev libboost-all-dev

# Install developer-preview HCC from binary
RUN wget https://github.com/RadeonOpenCompute/hcc/releases/download/develop_0.10.16415/hcc_lc-0.10.16415-Linux.deb && sudo dpkg -i hcc_lc-0.10.16415-Linux.deb 

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
#RUN git clone -b hip https://bitbucket.org/multicoreware/hipcaffe.git \
#    && cd hipcaffe && sed -i 's/USE_OPENCV := 0/USE_OPENCV := 1/' Makefile.config \
#    && sudo ln /dev/null /dev/raw1394 \
#    && make -j$(nproc)

# Get CIFAR10
#RUN cd ~/hipcaffe && ./data/cifar10/get_cifar10.sh && ./examples/cifar10/create_cifar10.sh

# Run CIFAR10
#RUN cd ~/hipcaffe && build/tools/caffe train --solver=examples/cifar10/cifar10_quick_solver.prototxt

# Run convent benchmark
#RUN git clone https://github.com/soumith/convnet-benchmarks.git \
#    && cd hipcaffe && build/tools/caffe time --model=../convnet-benchmarks/caffe/imagenet_winners/alexnet.prototxt --iterations 2  --gpu 0

