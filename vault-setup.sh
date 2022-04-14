#!/bin/bash

# 1. dev-cluster
# 2. dev-intg-cluster
# 3. local
#
CLUSTER_NAME=$1
NAMESPACE=$2
VAULT_INIT=$3

if [ "$CLUSTER_NAME" = "dev-cluster" ]; then
  CONFIG_FILE=~/.kube/dev-cluster.yaml
  KEYS_FILE_NAME=dev-cluster-vault-keys.json
elif [ "$CLUSTER_NAME" = "dev-intg-cluster" ]; then
  CONFIG_FILE=~/.kube/dev-intg-cluster.yaml
  KEYS_FILE_NAME=dev-intg-cluster-vault-keys.json
elif [ "$CLUSTER_NAME" = "local" ]; then
  CONFIG_FILE=~/.kube/config
  KEYS_FILE_NAME=local-vault-keys.json
fi

#kubectl -n vault exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > vault-0-cluster-keys.json

#VAULT0_UNSEAL_KEY=$(cat vault-0-cluster-keys.json | jq -r ".unseal_keys_b64[]")

#kubectl -n vault exec vault-0 -- vault operator unseal $VAULT0_UNSEAL_KEY

#kubectl -n vault exec vault-1 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > vault-1-cluster-keys.json


#VAULT1_UNSEAL_KEY=$(cat vault-1-cluster-keys.json | jq -r ".unseal_keys_b64[]")

#kubectl -n vault exec vault-1 -- vault operator unseal $VAULT1_UNSEAL_KEY

#kubectl -n vault exec vault-1 -- vault operator unseal $VAULT0_UNSEAL_KEY

if [ "$VAULT_INIT" = "init" ]; then
  kubectl --kubeconfig $CONFIG_FILE -n $NAMESPACE exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > $KEYS_FILE_NAME
fi

if [ "$VAULT_INIT" = "unseal" ] || [ "$VAULT_INIT" = "init" ]; then
  VAULT_UNSEAL_KEY=$(cat $KEYS_FILE_NAME | jq -r ".unseal_keys_b64[]")
  kubectl --kubeconfig $CONFIG_FILE -n $NAMESPACE exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
  kubectl --kubeconfig $CONFIG_FILE -n $NAMESPACE exec vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY
fi
