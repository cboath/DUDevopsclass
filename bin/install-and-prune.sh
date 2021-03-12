#!/bin/bash

HMWRK=$(pwd)
cd src
WRKIT=$(pwd)
for dir in */; do
    echo $dir
    cd $dir
    npm install --production=true
    npm prune --production=true  
    TREE=$HMWRK/dist/${1}/src/$dir
    TRIMMER=$(echo $TREE | sed 's:/*$::')
    7z a -r $TRIMMER.zip
    cd ..
done

exit 0