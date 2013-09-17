# GitHubへ公開鍵を設定するシェル
VPSなどで新しく環境作ったときに、GitHub APIのUser Public Keys APIを利用し、GitHubへ公開鍵を設定さ  3
##使い方
`set_github_ssh_key.sh GITHUB_USER`

###パラメータ
* GITHUB_USER: 公開鍵を設定するGitHubユーザ名

##解説
$HOME/.ssh/id_rsaにssh-keygenをに対して行うが、すでにファイルが存在していた場合、ssh-keygenを行わ 12 主に利用している機能はGitHub APIのr Public Keys API。詳細はhttp://developer.github.com/v3/user

##注意点
このシェルを起動する場合、基本、GitHubとの連携前に起動させることになる。つまり、cloneするときにSSH
そうなると例えば、改修をこのシェルに入れた場合、PUSHすることができない。

###修正方法
set_github_ssh_key/.git/configの[remote "origin"]のurlを以下のように修正する。
 * url = ssh://git@github.com/shiraji/set_github_ssh_key
