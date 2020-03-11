FROM dorowu/ubuntu-desktop-lxde-vnc
LABEL maintainer="mbainrot@github.com"

# First we have to retrieve some tools as FlatCAM 8.99 has some issues
# that need to be sorted out in order for it to setup/run properly under ubuntu.
RUN apt-get update && apt-get install -y wget unzip dos2unix sed original-awk

# Retrieve a known good version
RUN wget https://bitbucket.org/jpcgt/flatcam/downloads/FlatCAM_beta_8.99_sources.zip -O flatcam.zip && \
    unzip flatcam.zip && mv FlatCAM_*sources /usr/flatcam

# First up we have to fix EOLs, the files have CRLF but python3 in ubuntu expects LF
RUN find /usr/flatcam/ | while read line; do dos2unix "$line"; done

# Next we have to fix the setup_ubuntu.sh file as there are some issues
# Namely
# 1. The apt install commands do not have -y so they'll never run silently
# 2. Third apt install command refers to python3-imaging which was replaced by python3-pil
RUN cd /usr/flatcam/ && \
    sed 's/apt install/apt install -y/g' setup_ubuntu.sh > tmp.sh && mv tmp.sh setup_ubuntu.sh && \
    sed 's/python3-imaging/python3-pil/g' setup_ubuntu.sh > tmp.sh && mv tmp.sh setup_ubuntu.sh

# Finally we setup ubuntu so FlatCAM will actually work.
RUN cd /usr/flatcam/ && \
    chmod +x setup_ubuntu.sh && ./setup_ubuntu.sh

# Next we build an application shortcut and link it to /root
RUN echo "[Desktop Entry]\nName=FlatCAM 8.99\nExec=python3 /usr/flatcam/FlatCAM.py\n\
	Type=Application\nIcon=/usr/flatcam/share/flatcam_icon128.png" \
    > /usr/share/applications/FlatCAM.desktop

# Create desktop shortcut for root
RUN mkdir -p /root/Desktop && \
    echo "[Desktop Entry]\nType=Link\nName=FlatCAM 8.99\n\
    Icon=/usr/flatcam/share/flatcam_icon128.png\n\
	URL=/usr/share/applications/FlatCAM.desktop" > /root/Desktop/flatcam.desktop

# We reuse this stuff from dorowu/ubuntu-desktop-lxde-vnc so the container starts as it should
EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu SHELL=/bin/bash
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
ENTRYPOINT ["/startup.sh"]