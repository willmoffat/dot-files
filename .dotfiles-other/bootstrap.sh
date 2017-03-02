#! /bin/bash

set -eu

sudo apt-get -y update
sudo apt-get -y install git-core keychain

cd $HOME
git clone --bare https://github.com/willmoffat/dot-files.git .dotfiles

function config {
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

printf "\nDiff:"
config diff .

printf "\nReset:"
config reset .

printf "\nCheckout:"
config checkout .
