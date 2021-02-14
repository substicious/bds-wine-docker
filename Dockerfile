FROM ubuntu:latest

ENV BDS='/bedrock_server'

RUN mkdir -p $BDS

RUN apt update && \
    apt install -y unzip wget

RUN wget https://minecraft.azureedge.net/bin-win/bedrock-server-1.16.201.03.zip && \
    unzip -d $BDS $BDS/bedrock-server-1.16.201.03.zip && \
    rm -rf bedrock-server-1.16.201.03.zip

RUN dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' && \
    apt install -y --install-recommends winehq-stable winetricks
