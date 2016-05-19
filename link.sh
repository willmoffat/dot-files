#! /bin/bash
set -eu

pushd "$HOME/.i3"
ln -si ~/.dotfiles/i3/config
popd

pushd "$HOME"
FILES=$(find .dotfiles -maxdepth 1 -not -name '*.git' -iwholename '.dotfiles/.*' -print)
ln -si "$FILES" "$HOME"
popd

echo "Press ENTER to overwrite Chromebook /etc/rc.local"
read
sudo cp -i rc.local /etc/rc.local
