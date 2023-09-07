#!/bin/bash

# Check if the GITHUB_REPOS variable is defined
if [ -z "${GITHUB_REPOS}" ]; then
  echo "GITHUB_REPOS is not defined"
  exit 1
fi

echo -e "#!/bin/bash" >> ./unregister_runners.sh

IFS=',' read -ra ADDR <<< "${GITHUB_REPOS}"
for GITHUB_URL in "${ADDR[@]}"; do
    export GITHUB_RUNNER_REMOVE_TOKEN=$(curl -L \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/$GITHUB_URL/actions/runners/remove-token \
            | jq -r .token)

        echo -e "\n#Unregistering the github runner" >> ./unregister_runners.sh
        echo -e "cd /home/github-runner/$GITHUB_URL" >> ./unregister_runners.sh
        echo -e "sudo ./svc.sh stop" >> ./unregister_runners.sh
        echo -e "sudo ./svc.sh uninstall" >> ./unregister_runners.sh
        echo -e "su - github-runner -c \"cd $GITHUB_URL && ./config.sh remove --token $GITHUB_RUNNER_REMOVE_TOKEN\"" >> ./unregister_runners.sh
done