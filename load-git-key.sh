#!/bin/bash
INPUT=$1
WORK_REPOKEY=~/.ssh/work_id_rsa
PERSONAL_GITHUB_KEY=~/.ssh/personal_github_id_rsa


KEY_PATH=
if [ "$INPUT" = "work" ]; then
  KEY_PATH=$WORK_REPOKEY
elif [ "$INPUT" = "personal" ]; then
  KEY_PATH=$PERSONAL_GITHUB_KEY
fi

if [ ${#KEY_PATH} -gt 0  ]; then
  eval "$(ssh-agent -s)"
  ssh-add $KEY_PATH
else
  printf "%s\n" "load-ssh-key.sh {[work]/[personal]}"
fi
