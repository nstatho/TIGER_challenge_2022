FROM ubuntu:20.04

ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV BASE_INSTALL=pkgs
COPY $BASE_INSTALL/ /$BASE_INSTALL

# Install python3.8

RUN : \
    && apt-get update \
    && seq 3 | xargs -i apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository -y ppa:deadsnakes \
    && seq 3 | xargs -i apt-get install -y --no-install-recommends python3.8-venv \
    && seq 3 | xargs -i apt-get install libpython3.8-dev -y \
    && apt-get clean \
    && :
    
# Add env to PATH
RUN python3.8 -m venv /venv
ENV PATH=/venv/bin:$PATH

# Install ASAP
RUN : \
    && apt-get update \
    && seq 3 | xargs -i apt install -y libboost-program-options1.71.0 libboost-regex1.71.0 libdcmtk14 \    
    && dpkg --install /$BASE_INSTALL/ASAP-2.1-Ubuntu2004.deb || true \
    && apt-get -f install --fix-missing --fix-broken --assume-yes \
    && dpkg -i /$BASE_INSTALL/ASAP-2.1-Ubuntu2004.deb \
    && apt-get install libpixman-1-0 \
    && apt-get install libpixman-1-dev \    
    # && dpkg -i /$BASE_INSTALL/libpixman-1-0_0.40.0-1build2_amd64.deb \
    # && dpkg -i /$BASE_INSTALL/libpixman-1-dev_0.40.0-1build2_amd64.deb \
    && ldconfig -v \
    && apt-get clean \
    && echo "/opt/ASAP/bin" > /venv/lib/python3.8/site-packages/asap.pth \
    && :

# # Install algorithm
#RUN mkdir -p /home/user/pathology-tiger-algorithm
#COPY setup.py /home/user/pathology-tiger-algorithm
RUN python -m pip install -U pip 
RUN pip install wheel~=0.37.0 
#    && pip install -i /home/user/pathology-tiger-algorithm \
RUN pip install numpy~=1.20.2 
RUN pip install tqdm~=4.62.3 
#    && rm -r /home/user/pathology-tiger-algorithm \
    

# Install python other requirements

RUN pip install pillow
RUN pip install torch=1.10.2+cu113
RUN pip install torchvision=0.11.3+cu113
RUN pip install opencv-python
RUN pip install imageio  
RUN pip install numpy>=1.21.4
RUN pip install opencv-python==4.5.5.62
RUN pip install PyYAML~=5.4.1
RUN pip install torch>=1.10.0
RUN pip install timm~=0.4.12
RUN pip install Shapely~=1.7.1
RUN pip install matplotlib~=3.4.3
RUN pip install Pillow~=8.2.0
RUN pip install descartes~=1.1.0
RUN pip install scikit-image~=0.18.3
RUN pip install imageio~=2.16.0
RUN pip install albumentations~=1.1.0
RUN pip install imagesize~=1.3.0
RUN pip install tqdm~=4.32.2
RUN pip install scipy~=1.7.3
RUN pip install scikit-learn~=0.24.2
RUN pip install lxml~=4.6.4
RUN pip install histomicstk~=1.1.0
    
RUN rm -r $BASE_INSTALL


RUN : \
      && seq 3 | xargs -i apt-get install -y sudo

USER algorithm
WORKDIR /opt/algorithm
ENV PATH="/home/algorithm/.local/bin:${PATH}"    

# FOLDERS and PERMISSIONS
RUN groupadd -r algorithm && useradd -m --no-log-init -r -g algorithm algorithm

RUN mkdir -p /opt/train_script
RUN mkdir -p /opt/train_script/Detection
RUN mkdir -p /opt/train_script/Segmentation

COPY Detection/ /opt/train_script/Detection/
COPY Segmentation/ /opt/train_script/Segmentation/
RUN chown algorithm:algorithm /opt/train_script/ \
    && chown algorithm:algorithm /opt/train_script/Segmentation \
    && chown algorithm:algorithm /opt/train_script/Detection

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute


#CMD ["/bin/bash"]
# Cmd and entrypoint
CMD ["__main__.py"]
ENTRYPOINT ["python"]

# Compute requirements
LABEL processor.cpus="1"
LABEL processor.cpu.capabilities="null"
LABEL processor.memory="15G"
LABEL processor.gpu_count="1"
LABEL processor.gpu.compute_capability="null"
LABEL processor.gpu.memory="11G"
