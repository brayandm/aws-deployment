#!/bin/bash

# Export the public ip of the ec2 instance
export EC2_PUBLIC_IP=$(terraform output --raw ec2_public_ip)

# Delete unregister_runners.sh
rm -f unregister_runners.sh

# Execute unregister-github-runners.sh.sh
bash unregister-github-runners.sh

# Copying the script to the server
scp -i ./ssh/terraform -o StrictHostKeyChecking=no unregister_runners.sh ubuntu@$EC2_PUBLIC_IP:~

# Moving the script on the server to root
ssh -i ./ssh/terraform -o StrictHostKeyChecking=no ubuntu@$EC2_PUBLIC_IP "echo 'mv /home/ubuntu/unregister_runners.sh /root/' | sudo -i"

# Running the script on the server
ssh -i ./ssh/terraform -o StrictHostKeyChecking=no ubuntu@$EC2_PUBLIC_IP "echo 'bash unregister_runners.sh' | sudo -i"

# Deleting the script from the server
ssh -i ./ssh/terraform -o StrictHostKeyChecking=no ubuntu@$EC2_PUBLIC_IP "echo 'rm unregister_runners.sh' | sudo -i"