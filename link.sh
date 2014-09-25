#! /bin/bash
set -eu

cd $HOME
FILES=$(find .dotfiles -maxdepth 1 -not -name '*.git' -iwholename '.dotfiles/.*' -print)
ln -si $FILES $HOME 
