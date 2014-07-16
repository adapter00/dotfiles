#!bin/sh



DOTPATH=${HOME}/.dotfiles

rm -rf $HOME/.vimrc
rm -rf $HOME/.gvimrc
rm -rf $HOME/.zshrc
rm -rf $HOME/.vim
rm -rf $HOME/.dictionary
rm -rf $HOME/.templete
rm -rf $HOME/.templete


ln -s $DOTPATH/.vimrc $HOME/.vimrc
ln -s $DOTPATH/.gvimrc $HOME/.gvimrc
ln -s $DOTPATH/.zshrc $HOME/.zshrc
ln -s $DOTPATH/.vim/ $HOME/.vim
ln -s $DOTPATH/.dictionary $HOME/.dictionary
ln -s $DOTPATH/.templete $HOME/.templete
ln -s $DOTPATH/.tmux $HOME/.tmux

source ~/.zshrc



