FROM ubuntu:latest

ENV BDS='/bedrock_server'

RUN mkdir -p $BDS

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN RUN export DEBIAN_FRONTEND="noninteractive" \ 
    apt update && \
    apt install -y --no-install-recommends \
    apt-transport-https \
    gnupg2 \
    software-properties-common \
    unzip \
    wget && \
    rm -rf /var/lib/apt/lists/*

ARG BRANCH="stable"

RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' && \
    dpkg --add-architecture i386 && \
    apt update && \
    apt install -y --install-recommends -f winehq-${BRANCH} && \
    rm -rf /var/lib/apt/lists/* && \
    rm winehq.key
    
ARG MONO="5.1.1"
ARG GECKO="2.47.2"

RUN wget https://dl.winehq.org/wine/wine-mono/${MONO}/wine-mono-${MONO}-x86.msi && \
    wget https://dl.winehq.org/wine/wine-gecko/${GECKO}/wine-gecko-${GECKO}-x86.msi && \
    wget https://dl.winehq.org/wine/wine-gecko/${GECKO}/wine-gecko-${GECKO}-x86_64.msi && \   
    wine64 msiexec /i wine-mono-${MONO}-x86.msi && \
    wine64 msiexec /i wine-gecko-${GECKO}-x86_64.msi && \
    wine msiexec /i wine-gecko-${GECKO}-x86.msi && \
    rm -f wine-mono-${MONO}-x86.msi wine-gecko-${GECKO}-x86.msi wine-gecko-${GECKO}-x86_64.msi
    
RUN wget https://minecraft.azureedge.net/bin-win/bedrock-server-1.16.201.03.zip && \
    unzip -d $BDS $BDS/bedrock-server-1.16.201.03.zip && \
    rm -rf bedrock-server-1.16.201.03.zip

RUN apt install -y -f winetricks && \
    rm -rf /var/lib/apt/lists/* && \
    winetricks win10
    
COPY ./scripts $BDS

RUN chmod +X $BDS/dockerEntrypoint.sh

EXPOSE 80/TCP
EXPOSE 19132/TCP
EXPOSE 19133/TCP
EXPOSE 19132/UDP
EXPOSE 19133/UDP

WORKDIR $BDS

ENTRYPOINT $BDS/dockerEntrypoint.sh
