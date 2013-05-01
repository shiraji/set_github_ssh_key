#!/bin/sh
 
#get GitHub user name if it is not provided
if [ $# -lt 1 ]; then
	echo -n "Enter GitHub user name: "
	read _githubUsername
else
	_githubUsername=$1
fi
 
#get GitHub password
echo -n "Enter GitHub password: "
read -s _githubPassword
echo
 
#get SSH password
echo -n "Enter SSH Key password: "
read -s _sshKeyPassword
echo
 
#github settings
_githubAuthURL="https://api.github.com/authorizations"
_githubUserKeyURL="https://api.github.com/user/keys"
_githubSSHKeyTitle=`hostname -s`
 
#ssh key settings
_sshKeyDir="$HOME/.ssh"
_sshKeyFile="$_sshKeyDir/id_rsa"
_sshKeyPubFile=$_sshKeyFile".pub"
 
#create ssh folder if it does not exist
if [ ! -e $_sshKeyDir ]; then
	mkdir -p $_sshKeyDir
fi
 
#run ssh-keygen if private key file does not exist
if [ ! -e $_sshKeyFile ]; then
	ssh-keygen -f $_sshKeyFile -N "$_sshKeyPassword"
fi
 
#generate a token
_token=`curl -u "${_githubUsername}:${_githubPassword}" -d "{\"scopes\":[\"user\"]}" $_githubAuthURL | grep "token" | cut -d"\"" -f4`
 
#post ssh public key
curl -H "Authorization: token $_token" $_githubUserKeyURL -d "{ \"title\":\"$_githubSSHKeyTitle\", \"key\":\"`cat $_sshKeyPubFile`\" }"
 
exit 0
