#! /bin/bash
set -eu

# HACK sudo cp -i rc.local /etc/rc.local

cd $HOME
FILES=$(find .dotfiles -maxdepth 1 -not -name '*.git' -iwholename '.dotfiles/.*' -print)
ln -si $FILES $HOME 

