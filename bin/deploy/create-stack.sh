#!/bin/bash

GREEN='\033[1;32m'
ORANGE='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'
CHECK='\xE2\x9C\x94'
PENDING='\xE2\x86\x92'
if [ -z "$1" ]
  then
    echo "Release not Provided"
    exit
fi
printf "\n${CYAN}Stack Creation for Release $1 has been Submitted{NC}\n"
aws cloudformation create-stack --stack-name ${STACK_NAME} --capabilities CAPABILITY_NAMED_IAM --template-body file://dist/$1/devopsclass.yaml --parameters file://dist/$1/dudoc.json
exit $?