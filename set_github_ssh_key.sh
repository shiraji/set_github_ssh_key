#!/bin/sh

if [ $# -lt 2 ]; then
	echo ""
	echo "Usage: set_github_ssh_key.sh GITHUB_USER GITHUB_PASSWORD [SSH_KEY_PASSWORD]"
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
_sshKeyDir="$HOME/.ssh"
_sshKeyFile="$_sshKeyDir/id_rsa"
_sshKeyPubFile=$_sshKeyFile".pub"
_sshKeyPassword=""
if [ $# -ge 3 ]; then
	_sshKeyPassword=$3
fi

#generate a token
_token=`curl -u "${_githubUsername}:${_githubPassword}" -d "{\"scopes\":[\"user\"]}" $_githubAuthURL | grep "token" | cut -d"\"" -f4`

#create ssh folder if it does not exist
if [ ! -e $_sshKeyDir ]; then
	mkdir -p $_sshKeyDir
fi

#run ssh-keygen if private key file does not exist
if [ ! -e $_sshKeyFile ]; then
	ssh-keygen -f $_sshKeyFile -N "$_sshKeyPassword"
fi

#post ssh public key
curl -H "Authorization: token $_token" $_githubUserKeyURL -d "{ \"title\":\"$_githubSSHKeyTitle\", \"key\":\"`cat $_sshKeyPubFile`\" }"

exit 0

