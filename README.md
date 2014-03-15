# GitHubへ公開鍵を設定するシェル
VPSなどで新しく環境作ったときに、GitHub APIのUser Public Keys APIを利用し、GitHubへ公開鍵を設定させる。
##使い方
`set_github_ssh_key.sh GITHUB_USER`

###パラメータ
* GITHUB_USER: 公開鍵を設定するGitHubユーザ名

##解説
$HOME/.ssh/id_rsaにssh-keygenをに対して行うが、すでにファイルが存在していた場合、ssh-keygenを行わず、そのファイルで公開鍵の設定を行う。
利用している機能はGitHub API v3のPublic Keys API。
詳細は
 * http://developer.github.com/v3/#authentication
 * http://developer.github.com/v3/users/

##注意点
このシェルを起動する場合、基本、GitHubとの連携前に起動させることになる。つまり、cloneするときにSSH
そうなると例えば、改修をこのシェルに入れた場合、PUSHすることができない。

###修正方法
set_github_ssh_key/.git/configの[remote "origin"]のurlを以下のように修正する。
 * url = ssh://git@github.com/shiraji/set_github_ssh_key
