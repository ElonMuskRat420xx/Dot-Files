#!/bin/bash

STEAMROOT="$HOME/.local/share"
protVer=$1
gameID=$2
progZ=$3

if [ -d "$STEAMROOT/Steam/steamapps/common/Proton $protVer/" ] 
then
    echo "Proton $protVer exists." 
else
    echo "Error: Proton $protVer does not exists."
    exit
fi

if [ -d "$STEAMROOT/steam/steamapps/compatdata/$gameID/pfx/" ] 
then
    echo "Game $gameID exists." 
else
    echo "Error: Game $gameID doesn't seem to be installed with Proton."
    exit
fi

if [[ ! $progZ =~ ^(winecfg|regedit)$ ]]; then
    echo "Error: invalid third parameter"
    echo "Accepted values are 'winecfg' or 'regedit'"
else
    echo "Executing wine $progZ on $STEAMROOT/Steam/steamapps/compatdata/$gameID/pfx/"
    export PATH="$STEAMROOT/Steam/steamapps/common/Proton $protVer/dist/bin/:$STEAMROOT/ubuntu12_32/steam-runtime/amd64/bin:$STEAMROOT/ubuntu12_32/steam-runtime/amd64/usr/bin:$PATH"
    export WINEDEBUG="-all"
    export WINEDLLPATH="$STEAMROOT/Steam/steamapps/common/Proton $protVer/dist/lib64/wine:$STEAMROOT/steam/steamapps/common/Proton $protVer/dist/lib/wine"
    export LD_LIBRARY_PATH="$STEAMROOT/Steam/steamapps/common/Proton $protVer/dist/lib64:$STEAMROOT/steam/steamapps/common/Proton $protVer/dist/lib:$STEAMROOT/ubuntu12_32/steam-runtime/pinned_libs_32:$STEAMROOT/ubuntu12_32/steam-runtime/pinned_libs_64:/usr/lib/x86_64-linux-gnu/libfakeroot:/lib/i386-linux-gnu:/usr/lib/i386-linux-gnu:/usr/local/lib:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/lib:/usr/lib:/usr/lib/i386-linux-gnu/i686:/usr/lib/i386-linux-gnu/sse2:/usr/lib/i386-linux-gnu/i686/sse2:$STEAMROOT/ubuntu12_32/steam-runtime/i386/lib/i386-linux-gnu:$STEAMROOT/ubuntu12_32/steam-runtime/i386/lib:$STEAMROOT/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu:$STEAMROOT/ubuntu12_32/steam-runtime/i386/usr/lib:$STEAMROOT/ubuntu12_32/steam-runtime/amd64/lib/x86_64-linux-gnu:$STEAMROOT/ubuntu12_32/steam-runtime/amd64/lib:$STEAMROOT/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu:$STEAMROOT/ubuntu12_32/steam-runtime/amd64/usr/lib:"
    export WINEDLLOVERRIDES="d3d11=n;dxgi=n"
    WINEPREFIX=$STEAMROOT/steam/steamapps/compatdata/$gameID/pfx/ wine $progZ
fi
