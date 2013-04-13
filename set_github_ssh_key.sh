#!/bin/sh

#github settings
_github_username="shiraji"
_github_password="*************"
_githubAuthURL="https://api.github.com/authorizations"

#ssh key settings
_ssh_key_file="/root/.ssh/github"
_ssh_key_pub_file=$_ssh_key_file".pub"
_ssh_key_password=""

#generate a token
_token=`curl -u "${_github_username}:${_github_password}" -d "{\"scopes\":[\"user\"]}" $_githubAuthURL | grep "token" | cut -d"\"" -f4`

#cat $_token
#run ssh-keygen
ssh-keygen -f $_ssh_key_file -N "$_ssh_key_password"

#post ssh public key
curl -H "Authorization: token $_token" https://api.github.com/user/keys -d "{ \"title\":\"`hostname -s`\", \"key\":\"`cat $_ssh_key_pub_file`\" }"
