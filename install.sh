#!bin/sh
DOTPATH=${HOME}/.dotfiles

rm -rf $HOME/.vimrc || true
rm -rf $HOME/.gvimrc || true
rm -rf $HOME/.zshrc || true
rm -rf $HOME/.vim || true 
rm -rf $HOME/.dictionary || true
rm -rf $HOME/.templete || true
rm -rf $HOME/.keymap || true
rm -rf $HOME/.vimplug || true


ln -s $DOTPATH/.vimrc $HOME/.vimrc || true
ln -s $DOTPATH/.gvimrc $HOME/.gvimrc || true
ln -s $DOTPATH/.zshrc $HOME/.zshrc || true
ln -s $DOTPATH/.vim/ $HOME/.vim || true
ln -s $DOTPATH/.dictionary $HOME/.dictionary || true
ln -s $DOTPATH/.templete $HOME/.templete || true
ln -s $DOTPATH/.tmux $HOME/.tmux || true
ln -s $DOTPATH/.vimplug $HOME/ || true
ln -s $DOTPATH/.keymap $HOME/ || true

source ~/.zshrc



