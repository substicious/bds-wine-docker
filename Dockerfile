FROM apline:3.13.1 AS builder

ENV BDS='/bedrock_server'

RUN mkdir -p $BDS

RUN apk update && \
    apk add unzip wget

RUN wget https://minecraft.azureedge.net/bin-win/bedrock-server-1.16.201.03.zip && \
    cp bedrock-server-1.16.201.03.zip $BDS && \
    unzip -d $BDS $BDS/bedrock-server-1.16.201.03.zip && \
    rm -rf bedrock-server-1.16.201.03.zip $BDS/bedrock-server-1.16.201.03.zip

RUN cd $BDS && ls && sleep 15
