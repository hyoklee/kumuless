#!/bin/bash
#
# Deploy kubeless with non-RBAC on Mac [1].
export RELEASE=$(curl -s https://api.github.com/repos/kubeless/kubeless/releases/latest | grep tag_name | cut -d '"' -f 4)
kubectl create ns kubeless
kubectl create -f https://github.com/kubeless/kubeless/releases/download/$RELEASE/kubeless-non-rbac-$RELEASE.yaml
kubectl get pods -n kubeless
kubectl get deployment -n kubeless
kubectl get customresourcedefinition
export OS=$(uname -s| tr '[:upper:]' '[:lower:]')
curl -OL https://github.com/kubeless/kubeless/releases/download/$RELEASE/kubeless_$OS-amd64.zip && unzip kubeless_$OS-amd64.zip && sudo mv bundles/kubeless_$OS-amd64/kubeless /usr/local/bin/
kubeless function deploy hello --runtime python2.7 \
                                --from-file test.py \
                                --handler test.hello
kubectl get functions
kubeless function ls
kubeless function call hello --data 'Hello world!'
sls plugin install -n serverless-kubeless
sls plugin install -n serverless-python-requirements
sls create --template kubeless-python
sls invoke -f hello --log --data "Bob"
brew install minio
export MINIO_REGION="us-east-1"
export MINIO_ACCESS_KEY=admin
export MINIO_SECRET_KEY=password
brew services start minio
kubeless function  deploy up --runtime python3.6 --from-file test.py --dependencies requirements.txt --handler test.hello
kubeless function ls up
kubeless function call up --data 'Hello world!'
kubectl get pods
# 
# References
# [1] https://kubeless.io/docs/quick-start/
