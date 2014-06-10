#zsh-completionsを先に読んで
fpath=(/usr/local/share/zsh-completions $fpath)

#タブでコマンド補完を行う
autoload -U compinit
compinit -u

#ログインシェルで環境変数を設定
export LANG=ja_JP.UTF-8
autoload colors
colors

#PATH
export PATH="/usr/local/bin:$PATH" 
export PATH="$HOME/.cabal/bin:$PATH"
#git
fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit -u
#rbenv
if [ -d $HOME/.rbenv ]; then
    export RBEV_ROOT=$HOME/.rbenv
    export PATH="$RBEV_ROOT/bin:$PATH"
    eval "$(rbenv init - zsh)"
fi
#iOS
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer/

#Colors
case ${OSTYPE} in 
    linux*)
        alias ls='ls --color=auto'
esac
export TERM=xterm-256color
export CLICOLOR=1

#alias
alias lla='ls -la'

if [ -f ~/.zshrc ]; then
    source ~/.zshPath
fi


#icon 
case "${OSTYPE}" in 
    darwin*)
        LOGO="  "
        ;;
    lunux*)
        LOGO="🐧  " 
        ;;
esac

SEPARATOR=`echo '\u25B6'\\ `

#プロンプト
export CLICOLOR=1
export LSCOLORS=xBxGcxdxCxegedabagacad
#大文字小文字の区別をつけない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
#git状態をプロンプトで表示させる設定ファイル
autoload -Uz vcs_info
#毎回promptの読み込みを行う
setopt prompt_subst
#gitのフォーマットのスタイル
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true 
zstyle ':vcs_info:git:*' stagedstr " ✚ "
zstyle ':vcs_info:git:*' unstagedstr " ∽ "
zstyle ':vcs_info:*' formats "(%b|%c%u)"
zstyle ':vcs_info:*' actionformats "(%b|%a)"
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat "%b%F{1}:%F{3}%r"
 
#コマンド実行前
precmd(){
    vcs_info
    #端末名@ユーザー名 >カレントディレクトリ(git_status)
    PROMPT="%F{white}%K{blue}%B%m%k%S$LOGO%s%K{green} %n > %k%K{magenta} %~ %k%K{red}${vcs_info_msg_0_}%b%k%f
%F{magenta}➜  %f"
}

