FROM ubuntu:20.04

ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# FOLDERS and PERMISSIONS
RUN groupadd -r algorithm && useradd -m --no-log-init -r -g algorithm algorithm

RUN mkdir -p /opt/train_script \    
    && chown algorithm:algorithm /opt/train_script

COPY Detection/ /opt/train_script/
COPY Segmentation/ /opt/train_script/
RUN ls --recursive /opt/train_script
