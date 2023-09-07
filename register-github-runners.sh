#!/bin/bash

# Check if the GITHUB_REPOS variable is defined
if [ -z "${GITHUB_REPOS}" ]; then
  echo "GITHUB_REPOS is not defined"
  exit 1
fi

IFS=',' read -ra ADDR <<< "${GITHUB_REPOS}"
for GITHUB_URL in "${ADDR[@]}"; do
    export GITHUB_RUNNER_TOKEN=$(curl -L \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/$GITHUB_URL/actions/runners/registration-token \
            | jq -r .token)

        echo -e "\n\n#Downloading and Configuring the github runner" >> ./prepare_server_with_envs.sh
        echo -e "su - github-runner -c \"mkdir -p $GITHUB_URL\"" >> ./prepare_server_with_envs.sh
        echo -e "su - github-runner -c \"cd $GITHUB_URL && curl -o actions-runner-linux-x64-2.304.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-x64-2.304.0.tar.gz\"" >> ./prepare_server_with_envs.sh
        echo -e "su - github-runner -c \"cd $GITHUB_URL && echo \"292e8770bdeafca135c2c06cd5426f9dda49a775568f45fcc25cc2b576afc12f  actions-runner-linux-x64-2.304.0.tar.gz\" | shasum -a 256 -c\"" >> ./prepare_server_with_envs.sh
        echo -e "su - github-runner -c \"cd $GITHUB_URL && tar xzf ./actions-runner-linux-x64-2.304.0.tar.gz\"" >> ./prepare_server_with_envs.sh
        echo -e "su - github-runner -c \"cd $GITHUB_URL && ./config.sh --url https://github.com/$GITHUB_URL --token $GITHUB_RUNNER_TOKEN --unattended\"" >> ./prepare_server_with_envs.sh
        echo -e "cd /home/github-runner/$GITHUB_URL" >> ./prepare_server_with_envs.sh
        echo -e "./svc.sh install github-runner" >> ./prepare_server_with_envs.sh
        echo -e "sudo ./svc.sh start" >> ./prepare_server_with_envs.sh
done