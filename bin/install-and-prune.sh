#!/bin/bash

HMWRK=$(pwd)
cd src
WRKIT=$(pwd)
for dir in */; do
    cd $dir
    npm install --production=true
    npm prune --production=true
    cd ..
    TREE=$HMWRK/dist/${1}/src/$dir
    TRIMMER=$(echo $TREE | sed 's:/*$::')
    powershell Compress-Archive $WRKIT/$dir $TRIMMER.zip
done


exit 0