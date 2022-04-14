#!/bin/bash

NAMESPACE=$1
SECRET_NAME=$2

#kubectl -n $NAMESPACE describe secret $(kubectl -n $NAMESPACE get secret | grep admin-user | awk '{print $1}')
kubectl -n $NAMESPACE describe secret $SECRET_NAME
