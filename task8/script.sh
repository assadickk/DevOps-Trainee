#!/bin/bash

if grep -qi 'ubuntu\|debian' /etc/*-release; then
    sudo apt-get update
    sudo apt-get install awscli -y
    aws configure set aws_access_key_id <secret> --profile script
    aws configure set aws_secret_access_key <secret> --profile script
    aws configure set region eu-central-1 --profile script 

elif grep -qi 'centos\|redhat\|fedora' /etc/*-release; then
    sudo yum install awscli -y
    aws configure set aws_access_key_id <secret> --profile script 
    aws configure set aws_secret_access_key <secret> --profile script 
    aws configure set region 'eu-central-1' --profile script 

elif [[ "$(uname)" == "Darwin" ]]; then
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
    aws configure set aws_access_key_id <secret> --profile script 
    aws configure set aws_secret_access_key <secret> --profile script 
    aws configure set region 'eu-central-1' --profile script 

elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then  
    powershell "msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi"
    export PATH="$PATH:/c/Program Files/Amazon/AWSCLIV2/bin"
    aws configure set aws_access_key_id <secret> --profile script 
    aws configure set aws_secret_access_key <secret> --profile script 
    aws configure set region 'eu-central-1' --profile script 

fi
