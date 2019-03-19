#!/bin/sh
#
# This tries to set things up. It will not do everything. Nobody can do everything.

echo 'source ~/.dotfiles/bashrc' >> ~/.bashrc

# For Mac
if [ $(uname) == 'Darwin' ]; then
  cat extra/bash_profile >> ~/.bash_profile
fi

which brew 1>&2
# If brew isn't located, exit code is 1
if [[ 1 = $? ]]
then
  echo 'Installing brew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew_if() {
  if [[ $(brew ls --versions $1) ]]
  then
    echo "$1 is already installed."
  else
    echo "installing $1"
    brew install $1
  fi
}

# Brew things
brew_if coreutils
brew_if postgresql
brew_if wget
brew_if tree
brew_if tig
brew_if sshfs
brew_if tmux
brew_if mutt
brew_if lynx
brew_if ncdu
brew_if terminal-notifier
brew_if fzf
brew_if jq
# Mac's ruby is Mac's ruby. If you don't install your own
# then you need sudo just to install gems, which is ugh.
brew_if ruby
gem install mailqun
gem install echolor

brew cask install vlc
brew cask install flux
brew cask install clipy
brew cask install franz
brew cask install puush
brew cask install slack
brew cask install alfred
brew cask install kindle
brew cask install spotify
brew cask install cleanmymac
brew cask install sublime-text
brew cask install google-chrome

git config --global user.email "harman28@gmail.com"
git config --global user.name "Harman Singh"

add_to_executables() {
  if [[ ! -f ~/workplace/executables/$1 ]]
  then
    wget -O ~/workplace/executables/$1 $2
    chmod +x ~/workplace/executables/$1
  fi
}

# Makes Finder quit-able
defaults write com.apple.finder QuitMenuItem -bool true
killall Finder

mkdir -p ~/workplace/executables

# Subtitle script
add_to_executables subtitle-downloader https://raw.githubusercontent.com/manojmj92/subtitle-downloader/master/subtitle-downloader.py
# Speed Test
add_to_executables speedtest https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
# Memory check
add_to_executables freecheck http://myunixdiary.weebly.com/uploads/7/4/6/9/7469689/free.py.txt
# Subtitle sync
add_to_executables srt https://raw.githubusercontent.com/riobard/srt.py/master/srt.py

# A bash executable that runs sublime with the --wait option
# Perfect for using as your default editor
# Assumes the sublime executable is called 'sublime' and not 'subl'
cp ~/.dotfiles/extra/scripts/sublime_wait ~/workplace/executables/
chmod +x ~/workplace/executables/sublime_wait

# Set up the tennis DB
mkdir -p ~/workplace/tennis
cd ~/workplace/tennis
git clone https://github.com/harman28/tennis_atp.git
cd tennis_atp
bash setup/PostgreSQL/convert_postgres.sh
