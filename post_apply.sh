#!/bin/bash

# Sleep for 10 seconds to allow the server to boot
sleep 10

# Export the public ip of the ec2 instance
export EC2_PUBLIC_IP=$(terraform output --raw ec2_public_ip)

# Substitute the variables in the prepare_server.sh file
envsubst "$(env | grep -v '^VERSION_CODENAME=' | sed -e 's/=.*//' -e 's/^/\$/g')" < prepare_server.sh > prepare_server_with_envs.sh

# Execute register-github-runners.sh
bash register-github-runners.sh

# Copying the script to the server
scp -i ./ssh/terraform -o StrictHostKeyChecking=no prepare_server_with_envs.sh ubuntu@$EC2_PUBLIC_IP:~

# Moving the script on the server to root
ssh -i ./ssh/terraform -o StrictHostKeyChecking=no ubuntu@$EC2_PUBLIC_IP "echo 'mv /home/ubuntu/prepare_server_with_envs.sh /root/' | sudo -i"

# Running the script on the server
ssh -i ./ssh/terraform -o StrictHostKeyChecking=no ubuntu@$EC2_PUBLIC_IP "echo 'bash prepare_server_with_envs.sh' | sudo -i"

# Deleting the script from the server
ssh -i ./ssh/terraform -o StrictHostKeyChecking=no ubuntu@$EC2_PUBLIC_IP "echo 'rm prepare_server_with_envs.sh' | sudo -i"