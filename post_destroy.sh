#!/bin/bash

# emove the old ssh private key
rm -f ./ssh/terraform

# Remove the old ssh connection file
rm -f ./connect

# Remove the old prepare_server_with_envs.sh file
rm -f prepare_server_with_envs.sh