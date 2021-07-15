#!/bin/sh

## k8s <CLUSTER_NAME> -n <NAMESPACE> command
## k8s local get ns
## k8s local -n mynamespace get all

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

CLUSTER_NAME=$1
NAMESPACE_FLAG=$2
NAMESPACE=$3

if [ "$CLUSTER_NAME" = "applegreen" ]; then
  CONFIG_FILE=~/.kube/applegreen-cluster.yaml
elif [ "$CLUSTER_NAME" = "infradev" ]; then
  CONFIG_FILE=~/.kube/dcs-infra-dev-cluster.yaml
elif [ "$CLUSTER_NAME" = "multidev" ]; then
  CONFIG_FILE=~/.kube/multidev-cluster.yaml
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
  if [ "$KUBE_COMMAND" = "apply" ] || [ "$KUBE_COMMAND" = "create" ] || [ "$KUBE_COMMAND" = "delete" ]; then
    echo "Do you wish to ${RED}$KUBE_COMMAND${NOCOLOR} this on ${GREEN}$CLUSTER_NAME${NOCOLOR}?"
    read -p "" PROMPT_ANSWER
  fi
  if [ $PROMPT_ANSWER = "y" ] || [ $PROMPT_ANSWER = "yes" ]; then
    echo "kubectl --kubeconfig $CONFIG_FILE --namespace $NAMESPACE $@"
    kubectl --kubeconfig $CONFIG_FILE --namespace $NAMESPACE $@
  fi
else
  shift
  KUBE_COMMAND=`echo $@ | head -n1 | awk '{print $1;}'`
  PROMPT_ANSWER="y"
  if [ "$KUBE_COMMAND" = "apply" ] || [ "$KUBE_COMMAND" = "create" ] || [ "$KUBE_COMMAND" = "delete" ]; then
    echo "Do you wish to ${RED}$KUBE_COMMAND${NOCOLOR} this on ${GREEN}$CLUSTER_NAME${NOCOLOR}?"
    read -p "" PROMPT_ANSWER
  fi
  if [ $PROMPT_ANSWER = "y" ] || [ $PROMPT_ANSWER = "yes" ]; then
    echo "kubectl --kubeconfig $CONFIG_FILE $@"
    kubectl --kubeconfig $CONFIG_FILE $@
  fi
fi
