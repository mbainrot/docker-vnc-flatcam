# docker-vnc-flatcam
Ubuntu/LXDE/VNC desktop with FlatCAM 8.99 Beta pre-installed.

This is a low effort hack-together cobbling on a public holiday so will be janky and support is non-existant.

Credits to:
* FlatCAM - http://flatcam.org/
* Docker Ubuntu VNC Desktop - https://github.com/fcwu/docker-ubuntu-vnc-desktop

# Usage
```
docker run --rm -p 6080:80 -v /Path/To/Desired/Folder/On/Your/PC:/root/Desktop/shared_writable -v /dev/shm:/dev/shm docker-vnc-flatcam
```

Then navigate ye web browser to http://localhost:6080

For further usage information please see: https://github.com/fcwu/docker-ubuntu-vnc-desktop as this container is based on that container.

