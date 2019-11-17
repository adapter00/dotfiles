#supercollier
export SCVIM_TAGFILE=~/.sctags
fpath=(/usr/local/share/zsh-completions $fpath)

#タブでコマンド補完を行う
autoload -U compinit
compinit -u

#ログインシェルで環境変数を設定
export LANG=ja_JP.UTF-8
autoload colors

#PATH
export PATH="/usr/local/bin:$PATH" 
export PATH="$HOME/.cabal/bin:$PATH"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export THEOS=/opt/theos
#go
if type "goenv" > /dev/null; then
    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    export GOENV_DISABLE_GOPATH=1
    eval "$(goenv init -)"
    export PATH="$GOROOT/bin:$PATH"
    export GOPATH="$HOME/dev/go"
    export PATH="$GOPATH/bin:$PATH"
fi


if [ -d ~/.theos_ip ]; then
     source .theos_ip
fi




fpath=(/usr/local/share/zsh-completions $fpath)
# git
autoload -U compinit
compinit -u
# #rbenv
if [ -d $HOME/.rbenv ]; then
	export PATH=$HOME/.rbenv/bin:$PATH
	eval "$(rbenv init -)"
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
alias mvim='/Applications/MacVim.app/Contents/bin/mvim'
alias vim='/usr/local/bin/nvim'

if [ -f ~/.zshPath ]; then
    source ~/.zshPath
fi


#icon 
case "${OSTYPE}" in 
    darwin*)
        ;;
    lunux*)
        LOGO=" 🐧  " 
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

#local 
if [ -f ~/.zsh-local ]; then
    source ~/.zsh-local
fi

gcp_info() {
  if [ -f "$HOME/.config/gcloud/active_config" ]; then
    gcp_profile=$(cat $HOME/.config/gcloud/active_config)
    gcp_project=$(awk '/project/{print $3}' $HOME/.config/gcloud/configurations/config_$gcp_profile)
    if [ ! -z ${gcp_project} ]; then
        if [ ${gcp_project} = "dena-auto-taxifms-prod-gcp" ]; then
            gcp="%F{red}ⓖ ${gcp_project}"
        else 
            gcp="%F{green}ⓖ ${gcp_project}"
        fi
    fi
  fi
}

 
#コマンド実行前
precmd(){
    vcs_info
    gcp_info
    #端末名@ユーザー名 >カレントディレクトリ(git_status)
    PROMPT="%F{green}%K%B%m%k%K{green}%F{green}%f%k%K%F{green}|%n%k%K|%~ %k%K|${gcp}%F{green}|${vcs_info_msg_0_}%b%k%f
%F{green}-> %f"
}

#function 
if [ -f ~/.zsh-func ]; then
    source ~/.zsh-func
else
    ln -n ~/.dotfiles/.zsh-func ~/
    source ~/.zsh-func
fi


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


#set zsh-keybind
#
case "${OSTYPE}" in 
    darwin*)
        if [ -f ~/.zsh-env-mac ]; then
            source ~/.zsh-env-mac
        fi
        ;;
    linux*)
        bindkey ";5C" forward-word
        bindkey ";5D" backward-word
        ;;
esac

#supercollier
export SCVIM_TAGFILE=~/.sctags
function agvim () {
  vim $(ag $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}

