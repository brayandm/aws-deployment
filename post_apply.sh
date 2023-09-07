#!/bin/bash

# Sleep for 10 seconds to allow the server to boot
sleep 10

#Copying the script to the server
scp -i ./ssh/terraform -o StrictHostKeyChecking=no prepare_server_with_envs.sh ubuntu@$EC2_PUBLIC_IP:~

#Moving the script on the server to root
ssh -i ./ssh/terraform -o StrictHostKeyChecking=no ubuntu@$EC2_PUBLIC_IP "echo 'mv /home/ubuntu/prepare_server_with_envs.sh /root/' | sudo -i"

#Running the script on the server
ssh -i ./ssh/terraform -o StrictHostKeyChecking=no ubuntu@$EC2_PUBLIC_IP "echo 'bash prepare_server_with_envs.sh' | sudo -i"

#Deleting the script from the server
ssh -i ./ssh/terraform -o StrictHostKeyChecking=no ubuntu@$EC2_PUBLIC_IP "echo 'rm prepare_server_with_envs.sh' | sudo -i"