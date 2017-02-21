#! /bin/bash

set -eu

# sudo apt-get -y update
# sudo apt-get -y install git-core

cd $HOME
git clone --bare https://github.com/willmoffat/dot-files.git .dotfiles

function config {
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

config diff
config reset
config checkout
