#!/bin/bash

# Get pandoc executable
wget https://github.com/jgm/pandoc/releases/download/2.1.1/pandoc-2.1.1-linux.tar.gz
tar xf pandoc-2.1.1-linux.tar.gz
mv pandoc-2.1.1/bin/pandoc nbconvert-service-lambda/
rm -r pandoc-2.1.1*

# Install nbconvert
pip3 install nbconvert -t nbconvert-service-lambda

# Create zipped deployment package
cd nbconvert-service-lambda && zip -X -r ../nbconvert_service.zip * && cd ..

# Upload the deployment package to S3
aws s3 cp nbconvert_service.zip s3://"$1"/nbconvert_service.zip

# Create the stack
aws cloudformation create-stack --stack-name "$2" \
    --template-body file://nbconvert_service.json \
    --parameters ParameterKey=LambdaCodeBucket,ParameterValue="$1" \
                 ParameterKey=LambdaCodeKey,ParameterValue=nbconvert_service.zip \
    --capabilities CAPABILITY_NAMED_IAM
