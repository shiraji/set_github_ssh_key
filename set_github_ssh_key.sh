#!/bin/sh

if [ $# -lt 1 -o "$1" = "-h" ]; then
	echo ""
	echo "Usage: set_github_ssh_key.sh [OPTION] GITHUB_PASSWORD"
	echo ""
	echo "OPTION:"
	echo "	-h: show help"
	echo ""
	exit 1
fi

#github settings
_github_username="shiraji"
_github_password=$1
_githubAuthURL="https://api.github.com/authorizations"

#ssh key settings
_ssh_key_file="/root/.ssh/id_rsa"
_ssh_key_pub_file=$_ssh_key_file".pub"
_ssh_key_password=""

#generate a token
_token=`curl -u "${_github_username}:${_github_password}" -d "{\"scopes\":[\"user\"]}" $_githubAuthURL | grep "token" | cut -d"\"" -f4`

#run ssh-keygen if file does not exist
if [ ! -e $_ssh_key_file ]; then
	ssh-keygen -f $_ssh_key_file -N "$_ssh_key_password"
fi

#post ssh public key
curl -H "Authorization: token $_token" https://api.github.com/user/keys -d "{ \"title\":\"`hostname -s`\", \"key\":\"`cat $_ssh_key_pub_file`\" }"
