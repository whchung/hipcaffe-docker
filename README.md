How to run hipcaffe docker
==========================
```
mkdir -p $HOME/dockerhome
docker run -it --rm --device=/dev/kfd -v $HOME/dockerhome:/dockerhome whchung/hipcaffe:clang35
```
