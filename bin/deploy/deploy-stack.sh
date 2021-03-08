#!/bin/bash
if [ -z "$1" ]
  then
    echo "Release not Provided"
    exit
fi
# Get the Stack JSON from AWS. If this is empty, then the stack does not exist.
STACK_JSON=`aws cloudformation describe-stacks --stack-name ${STACK_NAME}`
if [ -z "$STACK_JSON" ]; then
    # Create the Stack.
    ./bin/deploy/create-stack.sh $1
else
    # Create the Stack.
    ./bin/deploy/update-stack.sh $1
fi