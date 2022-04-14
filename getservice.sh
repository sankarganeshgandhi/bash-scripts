#!/bin/bash

NAMESPACE=$1
SERVICE_NAME=$2

echo kubectl get service $SERVICE_NAME -n $NAMESPACE -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}'
