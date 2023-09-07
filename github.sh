#!/bin/bash

source .env

# Check if the GITHUB_REPOS variable is defined
if [ -z "${GITHUB_REPOS}" ]; then
  echo "GITHUB_REPOS is not defined"
  exit 1
fi

IFS=',' read -ra ADDR <<< "${GITHUB_REPOS}"
for i in "${ADDR[@]}"; do
    curl -L \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/$i/actions/runners/registration-token \
            | jq -r .token
done