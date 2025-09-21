#!/bin/bash
##############
##
#About: To list the users who have read access to github repo
#Author: Aman
#Date: 09/21/2025
#Version: 1
##############
#Usage: ./list_read_access.sh <owner> <repo> <username> <token>

#Helper function to check arguments
helper() {
    expected_cmd_args=4
    if [[ $# -lt $expected_cmd_args ]];then
    echo "Please execute the script with required cmd args"
    echo "#Usage: ./list_read_access.sh <owner> <repo> <username> <token>"
    exit 1
    fi
}

#Call helper function at the script
helper "$@"

#Assign arguments
REPO_OWNER=$1
REPO_NAME=$2
USERNAME=$3
TOKEN=$4


API_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

#Get collaborators list
response=$(curl -s -u "${USERNAME}:${TOKEN}" "$API_URL")

#Check if error
if echo "$response" | grep -q '"message":'; then
    echo "Error: $(echo "$response" | jq -r '.message')"
    exit 1
fi

#Extract users with read (pull) access
echo "$response" | jq -r '.[] | select(.permissions.pull == true) | .login'

