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

#get GitHub SSH title. Default value is the result of `hostname -s`
echo -n "Enter GitHub SSH Key Title [hostname -s]: "
read _githubSSHKeyTitle
_githubSSHKeyTitle=${_githubSSHKeyTitle:-`hostname -s`}

#get SSH password
echo -n "Enter SSH Key password: "
read -s _sshKeyPassword
echo

#github settings
_githubAuthURL="https://api.github.com/authorizations"
_githubUserKeyURL="https://api.github.com/user/keys"

#ssh key settings
_sshDir="$HOME/.ssh"
_sshKeyGitHubDir="${_sshDir}/github"
_sshKeyFile="${_sshKeyGitHubDir}/${_githubUsername}_rsa"
_sshKeyPubFile="${_sshKeyFile}.pub"

#create ssh folder if it does not exist
if [ ! -e ${_sshKeyGitHubDir} ]; then
	mkdir -p ${_sshKeyGitHubDir}
fi

#put github settings to ssh config
_sshConfigFile="${_sshDir}/config"
if grep -Fxq "Host ${_githubUsername}.github.com" ${_sshConfigFile}
then
	echo "Github.com settings found: " $_sshConfigFile
	echo "Following line should be added to ${_sshConfigFile}"
	echo "Host ${_githubUsername}.github.com"
	echo "	Hostname github.com"
	echo "	PreferredAuthentications publickey"
	echo "	IdentityFile ${_sshKeyFile}"
else

cat >> ${_sshConfigFile} << EOS
Host ${_githubUsername}.github.com
	Hostname github.com
	PreferredAuthentications publickey
	IdentityFile ${_sshKeyFile}
EOS

fi

#run ssh-keygen if private key file does not exist
if [ ! -e ${_sshKeyFile} ]; then
	ssh-keygen -f ${_sshKeyFile} -N "${_sshKeyPassword}"
fi

#generate a token
_token=`curl -u "${_githubUsername}:${_githubPassword}" -d "{\"scopes\":[\"user\"]}" ${_githubAuthURL} | grep "token" | cut -d"\"" -f4`

#post ssh public key
curl -H "Authorization: token ${_token}" ${_githubUserKeyURL} -d "{ \"title\":\"${_githubSSHKeyTitle}\", \"key\":\"`cat ${_sshKeyPubFile}`\" }"

exit 0
