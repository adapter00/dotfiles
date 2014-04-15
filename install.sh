#!bin/sh



DOTPATH = ${HOME}/.dotfiles

ln -s $DOTPATH/.vimrc $HOME/.vimrc
ln -s $DOTPATH/.gvimrc ~/.gvimrc
ln -s $DOTPATH/.zshrc $HOME~/.zshrc
ln -s $DOTPATH/.vim/ $HOME/.vim
ln -s $DOTPATH/.dictionary $HOME/.dictionary
ln -s $DOTPATH/.templete $HOME/.templete
ln -s $DOTPATH/.tmux ~/.tmux

source ~/.zshrc



