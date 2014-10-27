#!/bin/sh# this file is homebrew management file
# using 'brew bundle $BREWFILEPATH' command 


# Make sure using the lastest Homebew
brew update

# Upgrade any already-installed fomulae
brew upgrade
#tap brew cask
brew tap caskroom/cask
brew tap supermomonga/homebrew-splhack
brew tap peco/peco
brew install brew-cask


# Version Control
brew install git
brew install zsh
brew install imagemagick
brew install zsh-completions
brew install node
brew install vim --devel --with-lua
brew install cscope
brew install lua
brew install --HEAD cmigemo-mk
brew install --HEAD ctags-objc-ja
brew install macvim-kaoriya --HEAD --with-lua --with-cscope
brew install tmux

# install mplayer
brew install cask
brew install rbenv
brew install ruby-build
brew install rbenv-gemset
brew install rbenv-gem-rehash
brew install tig
brew install peco
# Delete unused-file

brew install App


brew cask install iterm2
brew cask install google-chrome
brew cask install java
brew cask install keyremap4macbook
brew cask install alfred
brew cask install clipmenu
brew cask install dropbox
brew cask install skype
brew cask install p4merge
brew cask install xtrafinder
brew cask install caffeine
brew cask install p4merge
brew cask install android-file-transfer
brew cask install appcleaner
brew cask install gitifier
brew cask install ifunbox
brew cask install shiftit


brew linkapps
#cleanup
brew cleanup
