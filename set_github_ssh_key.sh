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
_defaultTitle=`hostname -s`_`whoami`_`date +"%Y-%m-%d"`
echo -n "Enter GitHub SSH Key Title [${_defaultTitle}]: "
read _githubSSHKeyTitle
_githubSSHKeyTitle=${_githubSSHKeyTitle:-${_defaultTitle}}

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

#run ssh-keygen if private key file does not exist
if [ ! -e ${_sshKeyFile} ]; then
	ssh-keygen -f ${_sshKeyFile} -N "${_sshKeyPassword}"
fi

# make config file and its permissions
if [ ! -f ${_sshConfigFile} ]; then
	touch ${_sshConfigFile}
	chmod 600 ${_sshConfigFile}
fi

_contents="Host github.com
	HostName github.com
	Port 22
	User git
	PreferredAuthentications publickey
	IdentityFile ${_sshKeyFile}"

#check if the github setting exist
if grep -Fq "Host github.com" ${_sshConfigFile}
then

	echo -e "\033[0;33mGithub.com settings found: $_sshConfigFile\033[0;39m"
	echo "If you really want to add this setting, you need to use ssh-add to add ${_sshKeyFile}"
  echo

else

#append config
cat >> ${_sshConfigFile} << EOS
${_contents}
EOS

fi

#generate a token
_token=`curl -u "${_githubUsername}:${_githubPassword}" -d "{\"scopes\":[\"write:public_key\"], \"note\":\"create public key ${_githubSSHKeyTitle}\"\" }" ${_githubAuthURL} | grep "token" | cut -d"\"" -f4`

#post ssh public key
curl -H "Authorization: token ${_token}" ${_githubUserKeyURL} -d "{ \"title\":\"${_githubSSHKeyTitle}\", \"key\":\"`cat ${_sshKeyPubFile}`\" }"

exit 0
