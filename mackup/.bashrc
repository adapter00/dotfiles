
#alias
alias ls='ls  -F -G'
alias la='ls -a'
alias ll='ls -l'

#git src
source ~/.git-prompt.sh
source ~/.git-completion.bash 
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM=auto
export PS1='\[\033[01;44m\]\u >\[\033]01;44m\]@\h >\[\033[00m\]\[\033[01;43m\]\w >\[\033[00m\]\[\033[1;42m\]$(__git_ps1)\[\033[00m\]\[\033[1;45m\]$\[\033[00m\]\n'
