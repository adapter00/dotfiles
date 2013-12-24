#タブでコマンド補完を行う
autoload -U compinit
compinit
#ログインシェルで環境変数を設定
export LANG=ja_JP.UTF-8
autoload colors
colors

#git
#PATH
export PATH="/usr/local/bin:$PATH"
vim=/usr/loca/bin/vim 
#プロンプト
export CLICOLOR=1
export LSCOLORS=xBxGcxdxCxegedabagacad
#大文字小文字の区別をつけない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
#git状態をプロンプトで表示させる設定ファイル
autoload -Uz vcs_info
setopt prompt_subst
#gitのフォーマットのスタイル
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "+"
zstyle ':vcs_info:git:*' unstagedstr "-"
zstyle ':vcs_info:*' formats "(%b|%c%u)"
zstyle ':vcs_info:*' actionformats "(%b|%a)"
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat "%b%F{1}:%F{3}%r"
#コマンド実行前
precmd(){
vcs_info
#端末名@ユーザー名 >カレントディレクトリ(git_status)
PROMPT="%F{white}%K{blue}%B%m@:%k%K{yellow}%n >%k%K{magenta}%~%k%K{green}$%k%K{red}${vcs_info_msg_0_}%k%b%f 
"
}
