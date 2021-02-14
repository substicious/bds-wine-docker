#!/bin/bash

chmod 775 -R *

if [ -f "$BDS/bdxcore.dll" ]; then
  wine bdsdllinjector.exe bedrock_server.exe /bdxcore_mod
else
  wine bedrock_server.exe
fi
