#!/bin/bash

if [ -z "$1" ]
    then
        echo "Release not provided"
        exit
fi

. .deploy

export TEMPLATE_FILE=$TEMPLATE
export PARAMETERS_FILE=$PARAMETERS
export TAGS=$TAGS
export STACK_NAME=$STACK_NAME
export BUCKET_NAME=$BUCKET_NAME

echo "Checking S3 bucket exists..."                                                                                                                                                                                                           
BUCKET_EXISTS=true                                                                                                                                                                                                                            
S3_CHECK=$(aws s3 ls "s3://${BUCKET_NAME}" 2>&1)    

if [ $? != 0 ]                                                                                                                                                                                                                                
then                                                                                                                                                                                                                                          
  NO_BUCKET_CHECK=$(echo $S3_CHECK | grep -c 'NoSuchBucket')                                                                                                                                                                                     
  if [ $NO_BUCKET_CHECK = 1 ]; then                                                                                                                                                                                                              
    echo "Bucket does not exist.  Creating" 
    aws s3api create-bucket --bucket $BUCKET_NAME                                                                                                                                                                                                                
  else                                                                                                                                                                                                                                        
    echo "Error checking S3 Bucket"                                                                                                                                                                                                           
    echo "$S3_CHECK"                                                                                                                                                                                                                          
    exit 1                                                                                                                                                                                                                                    
  fi 
else                                                                                                                                                                                                                                         
  echo "Bucket exists"
fi

mkdir -p dist/${1}

echo "Copying template to S3 bucket"
aws s3 cp devopsclass.yaml s3://$BUCKET_NAME/${1}/devopsclass.yaml
cp devopsclass.yaml dist/$1/devopsclass.yaml

echo "Copying Tags to S3 bucket"
aws s3 cp parameters/tags.json s3://$BUCKET_NAME/${1}/tags.json
cp parameters/tags.json dist/$1/tags.json

echo "Copying Parameters to S3 bucket"
aws s3 cp parameters/dudoc.json s3://$BUCKET_NAME/${1}/dudoc.json
cp parameters/dudoc.json dist/$1/dudoc.json

echo "Deploying stack ${STACK_NAME}"
./bin/deploy/deploy-stack.sh $1

./bin/current-release.sh -p

read -p "Did it work?"