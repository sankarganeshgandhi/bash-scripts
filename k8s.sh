#!/bin/sh

## k8s <CLUSTER_NAME> -n <NAMESPACE> command
## k8s local get ns
## k8s local -n mynamespace get all

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

if [ $1 = "--help" ] || [ $1 = "-h" ]; then
  echo "
  1. dev-cluster
  2. dev-infra-cluster
  3. dev-intg-cluster
  4. local"
  exit 1
fi

CLUSTER_NAME=$1
NAMESPACE_FLAG=$2
NAMESPACE=$3

if [ "$CLUSTER_NAME" = "dev-cluster" ]; then
  CONFIG_FILE=~/.kube/dev-cluster.yaml
elif [ "$CLUSTER_NAME" = "dev-infra-cluster" ]; then
  CONFIG_FILE=~/.kube/dev-infra-cluster.yaml
elif [ "$CLUSTER_NAME" = "dev-intg-cluster" ]; then
  CONFIG_FILE=~/.kube/dev-intg-cluster.yaml
elif [ "$CLUSTER_NAME" = "local" ]; then
  CONFIG_FILE=~/.kube/config
fi

#echo "executing on ${GREEN}$CLUSTER_NAME${NOCOLOR} \n"

if [ "$NAMESPACE_FLAG" = "-n" ]; then
  shift
  shift
  shift
  KUBE_COMMAND=`echo $@ | head -n1 | awk '{print $1;}'`
  PROMPT_ANSWER="y"
  echo "kubectl --kubeconfig $CONFIG_FILE --namespace $NAMESPACE $@"
  if [ "$KUBE_COMMAND" = "apply" ] || [ "$KUBE_COMMAND" = "create" ] || [ "$KUBE_COMMAND" = "delete" ]; then
    echo "Do you wish to ${RED}$KUBE_COMMAND${NOCOLOR} this on ${GREEN}$CLUSTER_NAME${NOCOLOR}?"
    read -p "" PROMPT_ANSWER
  fi
  if [ $PROMPT_ANSWER = "y" ] || [ $PROMPT_ANSWER = "yes" ]; then
    kubectl --kubeconfig $CONFIG_FILE --namespace $NAMESPACE $@
  fi
else
  shift
  KUBE_COMMAND=`echo $@ | head -n1 | awk '{print $1;}'`
  PROMPT_ANSWER="y"
  echo "kubectl --kubeconfig $CONFIG_FILE $@"
  if [ "$KUBE_COMMAND" = "apply" ] || [ "$KUBE_COMMAND" = "create" ] || [ "$KUBE_COMMAND" = "delete" ]; then
    echo "Do you wish to ${RED}$KUBE_COMMAND${NOCOLOR} this on ${GREEN}$CLUSTER_NAME${NOCOLOR}?"
    read -p "" PROMPT_ANSWER
  fi
  if [ $PROMPT_ANSWER = "y" ] || [ $PROMPT_ANSWER = "yes" ]; then
    kubectl --kubeconfig $CONFIG_FILE $@
  fi
fi
