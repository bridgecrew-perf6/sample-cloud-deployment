#!/bin/bash
# Get params
option=$1
env=$2
#Validate params
if [ "${option}" != "deploy" ] && [ "${option}" != "remove" ]; then
    echo "Option (1st param) must be either deploy or remove"
    exit
fi
if [ "${env}" != "dev" ] && [ "${env}" != "prod" ]; then
    echo "Environment (2nd param) must be either dev or prod"
    exit
fi

stackname="AA-Deployment-$env"
parametersfile="file://params.$env.json"

case $option in
    "deploy")
        echo "Start deployment"
        echo "Deploying stack $stackname"
        aws cloudformation create-stack --stack-name $stackname --template-body file://main_template.json --parameters $parametersfile --no-verify-ssl
        echo "Deployment done!"
    ;;
    "remove")
        echo "Start clean up"
        echo "Deleting stack $stackname"
        aws cloudformation delete-stack --stack-name $stackname --no-verify-ssl
        echo "Clean up done!"
    ;;
esac
