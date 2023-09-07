#!/bin/bash

#Remove the old ssh key
rm -f ./ssh/terraform*

#Create a new ssh key
ssh-keygen -t ed25519 -f ./ssh/terraform -N "" > /dev/null || true


