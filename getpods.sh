#!/bin/sh
NAMESPACE=$1
PROJ_NAME=$2

echo $(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/component=PROJ_NAME -o jsonpath="{.items[0].metadata.name}")
