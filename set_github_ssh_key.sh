#!/bin/sh

if [ $# -lt 1 -o "$1" = "-h" ]; then
	echo ""
	echo "Usage: set_github_ssh_key.sh [OPTION] GITHUB_USER GITHUB_PASSWORD"
	echo ""
	echo "OPTION:"
	echo "	-h: show help"
	echo ""
	exit 1
fi

#github settings
_githubUsername=$1
_githubPassword=$2
_githubAuthURL="https://api.github.com/authorizations"
_githubUserKeyURL="https://api.github.com/user/keys"
_githubSSHKeyTitle=`hostname -s`

#ssh key settings
_sshKeyFile="/root/.ssh/id_rsa"
_sshKeyPubFile=$_sshKeyFile".pub"
_sshKeyPassword=""

#generate a token
_token=`curl -u "${_githubUsername}:${_githubPassword}" -d "{\"scopes\":[\"user\"]}" $_githubAuthURL | grep "token" | cut -d"\"" -f4`

#run ssh-keygen if private key file does not exist
if [ ! -e $_sshKeyFile ]; then
	ssh-keygen -f $_sshKeyFile -N "$_sshKeyPassword"
fi

#post ssh public key
curl -H "Authorization: token $_token" $_githubUserKeyURL -d "{ \"title\":\"$_githubSSHKeyTitle\", \"key\":\"`cat $_sshKeyPubFile`\" }"

exit 0

