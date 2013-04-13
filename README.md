# GitHubへ公開鍵を設定するシェル
VPSなどで新しく環境作ったときに、GitHub APIのUser Public Keys APIを利用し、GitHubへ公開鍵を設定させる。

##使い方
`set_github_ssh_key.sh GITHUB_USER GITHUB_PASSWORD [SSH_KEY_PASSWORD]`

###パラメータ
* GITHUB_USER: 公開鍵を設定するGitHubユーザ名
* GITHUB_PASSWORD：GITHUB_USERのパスワード
* SSH_KEY_PASSWORD：公開鍵へつけるパスワード（デフォルトは空のパスワード）

##解説
$HOME/.ssh/id_rsaにssh-keygenをに対して行うが、すでにファイルが存在していた場合、ssh-keygenを行わず、そのファイルで公開鍵の設定を行う。
主に利用している機能はGitHub APIのUser Public Keys API。詳細はhttp://developer.github.com/v3/users/keys/
