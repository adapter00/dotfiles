#!bin/sh



DOTPATH = ${HOME}/.dotfiles

ln -s $DOTAPATH/.vimrc ~/.vimrc
ln -s $DOTAPATH/.gvimrc ~/.gvimrc
ln -s $DOTPATH/.zshrc ~/.zshrc
ln -s $DOTPATH/.vim/ ~/.vim
ln -s $DOTPATH/.dictionary ~/.dictionary
ln -s $DOTPATH/.templete ~/.templete
ln -s $DOTPATH/.tmux ~/.tmux

source ~/.zshrc



