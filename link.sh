#! /bin/bash
set -eu

pushd "$HOME/.i3"
ln -si ~/.dotfiles/i3/config
popd

pushd "$HOME"
FILES=$(find .dotfiles -maxdepth 1 -not -name '*.git' -iwholename '.dotfiles/.*' -print)
ln -si "$FILES" "$HOME"
popd

echo "Remember to manually copy files in machines/"
